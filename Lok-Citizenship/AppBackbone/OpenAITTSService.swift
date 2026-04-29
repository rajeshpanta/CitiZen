import Foundation
import AVFoundation
import Combine
import CryptoKit

/// Cloud text-to-speech via OpenAI's `tts-1`, routed through our Supabase
/// edge function so the OpenAI key never ships in the iOS bundle.
///
/// The on-disk MP3 cache is keyed on `model|voice|text`, so each unique
/// question incurs a single round trip per device. After that it's free.
final class OpenAITTSService: NSObject, TextToSpeechService {

    // MARK: - Config (single voice, single model for now)

    private static let voice = "nova"
    private static let model = "tts-1"

    // MARK: - Protocol output

    var isSpeakingPublisher: AnyPublisher<Bool, Never> { isSpeaking.eraseToAnyPublisher() }

    // MARK: - Private state

    private let isSpeaking = CurrentValueSubject<Bool, Never>(false)
    private var finished   = PassthroughSubject<Void, Never>()
    private var currentTask: URLSessionDataTask?
    private var player: AVAudioPlayer?

    /// Identifies the in-flight speak request. Bumped on every `fetchAndPlay`
    /// and on `stopSpeaking`. The wrapped completion checks this against its
    /// captured id and drops late callbacks — without it, a cancelled
    /// `URLSessionDataTask` or stale `AVAudioPlayer` delegate firing after
    /// `stopSpeaking` would still call `completion(false)`, which makes
    /// `TTSRouter` fall back to local TTS for the *previous* question's text
    /// (audible as "speaks the prior question over the new one").
    /// Read & written on the main queue only.
    private var currentRequestId = UUID()

    // MARK: - Configuration check

    /// True when the Supabase backend is configured. The router uses this to
    /// decide whether to attempt cloud TTS at all — without Supabase creds
    /// (e.g. dev builds), we fall back to `LocalTTSService`.
    var isConfigured: Bool { SupabaseConfig.isConfigured }

    // MARK: - Protocol speak (simple entry point)

    func speak(_ text: String, languageCode: String) -> AnyPublisher<Void, Never> {
        stopSpeaking()
        finished = PassthroughSubject<Void, Never>()
        fetchAndPlay(text: text) { [weak self] _ in
            self?.finished.send(())
            self?.finished.send(completion: .finished)
        }
        return finished.eraseToAnyPublisher()
    }

    /// Fetch audio (from cache or our edge function) and play it.
    /// Calls `completion(true)` when playback finishes, `completion(false)` if fetch
    /// or play failed. The router uses this to fall back to local TTS on failure.
    ///
    /// `rate` adjusts playback speed via `AVAudioPlayer.rate` (1.0 = original).
    /// Used by `SlowSpeechHelper` to keep the 0.8–0.85× ESL slowdown for
    /// Reading / Writing practice while still using the OpenAI voice.
    /// Cache key is unaffected — the same MP3 is reused across rates,
    /// since rate is a playback-time property, not file content.
    ///
    /// The completion is automatically dropped if `stopSpeaking` (or another
    /// `fetchAndPlay`) supersedes this request — see `currentRequestId`. This
    /// prevents stale-cancel callbacks from triggering the router's local-TTS
    /// fallback for the previous question's text.
    func fetchAndPlay(text: String, rate: Float = 1.0, completion: @escaping (Bool) -> Void) {
        guard isConfigured, !text.isEmpty else {
            completion(false)
            return
        }

        let myId = UUID()
        currentRequestId = myId

        // Wraps the caller's completion: only fires while this request is the
        // current one. If `stopSpeaking` was called (or a newer `fetchAndPlay`
        // started), `currentRequestId` no longer matches and the call is
        // silently dropped. This is the fix for the "speaks the previous
        // question" bug — see `currentRequestId` comment.
        //
        // The check runs on main, so all writes/reads to `currentRequestId`
        // are serialized — no atomics needed.
        let guardedCompletion: (Bool) -> Void = { [weak self] success in
            guard let self, self.currentRequestId == myId else { return }
            completion(success)
        }

        let cacheURL = cacheFileURL(for: text)
        if FileManager.default.fileExists(atPath: cacheURL.path) {
            play(from: cacheURL, rate: rate, completion: guardedCompletion)
            return
        }

        let endpoint = SupabaseConfig.url
            .appendingPathComponent("functions/v1/tts")
        var req = URLRequest(url: endpoint)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue(SupabaseConfig.anonKey, forHTTPHeaderField: "apikey")
        req.setValue("Bearer \(SupabaseConfig.anonKey)", forHTTPHeaderField: "Authorization")
        req.setValue(DeviceID.current, forHTTPHeaderField: "X-Device-Id")
        req.timeoutInterval = 15

        let body: [String: Any] = [
            "text": text,
            "voice": Self.voice,
        ]
        req.httpBody = try? JSONSerialization.data(withJSONObject: body)

        currentTask = URLSession.shared.dataTask(with: req) { [weak self] data, response, error in
            guard let self else { return }

            // Clear our task slot now that the network round-trip is done.
            // Without this, the previous question's `URLSessionDataTask`
            // is held until the next `fetchAndPlay` overwrites the slot
            // (or `stopSpeaking` runs) — small but unbounded across a
            // long interview. The currentRequestId guard prevents a
            // stale completion from nil-ing out a task that a fresher
            // `fetchAndPlay` has already assigned.
            DispatchQueue.main.async { [weak self] in
                guard let self, self.currentRequestId == myId else { return }
                self.currentTask = nil
            }

            // No special-case for NSURLErrorCancelled here. `guardedCompletion`
            // already drops user-initiated cancels (currentRequestId mismatch).
            // System-initiated cancels (background, low memory) leave the id
            // unchanged, so they fall through to fallback like any other
            // failure — which is the desired behavior.
            guard error == nil,
                  let data,
                  let http = response as? HTTPURLResponse,
                  http.statusCode == 200 else {
                #if DEBUG
                if let http = response as? HTTPURLResponse {
                    print("[Cloud TTS] HTTP \(http.statusCode): \(String(data: data ?? Data(), encoding: .utf8) ?? "")")
                } else if let error {
                    print("[Cloud TTS] error: \(error)")
                }
                #endif
                DispatchQueue.main.async { guardedCompletion(false) }
                return
            }
            do {
                try data.write(to: cacheURL, options: .atomic)
            } catch {
                DispatchQueue.main.async { guardedCompletion(false) }
                return
            }
            DispatchQueue.main.async { [weak self] in
                // Re-check currentRequestId BEFORE creating a new player.
                // Without this guard, a stopSpeaking() that ran between the
                // URLSession completion and this dispatched block would be
                // overwritten — `play()` would create a fresh AVAudioPlayer
                // and start playback AFTER the user already tapped End/Back.
                // The original guardedCompletion only guards the completion
                // callback, not the play() call itself, so the player would
                // continue speaking the (now-cancelled) question over the
                // result screen. This guard is the actual fix.
                guard let self, self.currentRequestId == myId else { return }
                self.play(from: cacheURL, rate: rate, completion: guardedCompletion)
            }
        }
        currentTask?.resume()
    }

    // MARK: - Playback

    private var playCompletion: ((Bool) -> Void)?

    private func play(from url: URL, rate: Float = 1.0, completion: @escaping (Bool) -> Void) {
        do {
            // Configure the shared session via the central helper. Same
            // category + options + route override as STT, so the
            // category never has to transition mid-interview (live
            // category switches are flaky on real devices). The helper
            // also drops `.defaultToSpeaker` and applies a runtime route
            // override so BT speakers actually route to BT instead of
            // being forced to the iPhone speaker.
            AudioSessionPrewarmer.configureSession()

            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            // Apple requires `enableRate = true` BEFORE `prepareToPlay()`
            // for rate adjustments to take effect. Skip it at default
            // speed so we don't pay the time-stretching engine cost
            // for the common case (Mock Interview, Practice 1–5).
            if rate != 1.0 {
                player?.enableRate = true
            }
            player?.prepareToPlay()
            if rate != 1.0 {
                player?.rate = rate
            }
            player?.play()
            isSpeaking.send(true)
            playCompletion = completion
        } catch {
            #if DEBUG
            print("[Cloud TTS] Playback failed: \(error)")
            #endif
            // The cached file may be poisoned (truncated download, server
            // returned non-MP3, decoder rejected it). Remove it so the next
            // attempt re-fetches instead of looping on the same bad bytes.
            try? FileManager.default.removeItem(at: url)
            completion(false)
        }
    }

    // MARK: - Prefetch

    /// Warm the on-disk cache for `text` without playing it. Used by the
    /// Reading / Writing practice views to fetch the next card's audio in
    /// the background while the user is still on the current card, so the
    /// next speaker tap is a cache hit instead of a 1–2 second cloud
    /// round-trip.
    ///
    /// Critical isolation: this method must NOT touch `currentTask`,
    /// `currentRequestId`, `player`, `isSpeaking`, or `playCompletion`.
    /// Those belong to the active `fetchAndPlay` request. Prefetch runs
    /// completely in parallel — its URLSessionDataTask is fire-and-forget
    /// (URLSession retains it while running), and its completion only
    /// writes the MP3 to disk. No view-visible state changes, no audio
    /// playback, no interference with `stopSpeaking()`.
    ///
    /// Idempotent: returns immediately if the cache file already exists,
    /// so re-prefetching the same text across rapid card-swipes is cheap.
    /// Backend rate-limits at 120/hour/device, well above any realistic
    /// prefetch volume from a study session.
    func prefetch(text: String) {
        guard isConfigured, !text.isEmpty else { return }
        let cacheURL = cacheFileURL(for: text)
        if FileManager.default.fileExists(atPath: cacheURL.path) { return }

        let endpoint = SupabaseConfig.url
            .appendingPathComponent("functions/v1/tts")
        var req = URLRequest(url: endpoint)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue(SupabaseConfig.anonKey, forHTTPHeaderField: "apikey")
        req.setValue("Bearer \(SupabaseConfig.anonKey)", forHTTPHeaderField: "Authorization")
        req.setValue(DeviceID.current, forHTTPHeaderField: "X-Device-Id")
        req.timeoutInterval = 15

        let body: [String: Any] = [
            "text": text,
            "voice": Self.voice,
        ]
        req.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: req) { data, response, error in
            // Silent no-op on any failure — this is a best-effort warm,
            // not a user-facing operation. The next real `fetchAndPlay`
            // call will hit the slow path and surface errors there.
            guard error == nil,
                  let data,
                  let http = response as? HTTPURLResponse,
                  http.statusCode == 200 else {
                return
            }
            try? data.write(to: cacheURL, options: .atomic)
        }.resume()
    }

    // MARK: - Stop

    func stopSpeaking() {
        // Bump the request id BEFORE doing anything else. Any data-task
        // callback or AVAudioPlayer delegate that fires after this point
        // sees a mismatched id (via guardedCompletion in fetchAndPlay) and
        // drops the call — that's how the stale-fallback bug is prevented.
        currentRequestId = UUID()
        currentTask?.cancel()
        currentTask = nil
        player?.stop()
        player = nil
        if isSpeaking.value {
            isSpeaking.send(false)
        }
        // playCompletion (if set) is a guardedCompletion that will now drop
        // itself thanks to the id bump above. Clearing the reference is enough.
        playCompletion = nil
    }

    // MARK: - Cache

    private static let cacheDirName = "openai_tts"

    private func cacheFileURL(for text: String) -> URL {
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(Self.cacheDirName, isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let key = "\(Self.model)|\(Self.voice)|\(text)"
        let hash = SHA256.hash(data: Data(key.utf8))
            .map { String(format: "%02x", $0) }
            .joined()
        return dir.appendingPathComponent("\(hash).mp3")
    }

    /// Trim the on-disk cache to at most `maxBytes`, evicting oldest files
    /// first (by modification time). Call once at app launch — running
    /// during an interview could cause file-IO stalls at the wrong moment.
    ///
    /// Why this exists: the cache key is `model|voice|text`, so every
    /// unique question / answer-feedback / option string accumulates an
    /// MP3 forever. Across four languages and ~100 question variants the
    /// directory can grow into the hundreds of MB. iOS will purge caches
    /// under disk pressure so we won't crash, but App Review has flagged
    /// unbounded caches before, and low-storage users notice.
    static func trimCache(maxBytes: Int = 100 * 1024 * 1024) {
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(cacheDirName, isDirectory: true)

        let keys: [URLResourceKey] = [.fileSizeKey, .contentModificationDateKey]
        guard let urls = try? FileManager.default.contentsOfDirectory(
            at: dir,
            includingPropertiesForKeys: keys,
            options: .skipsHiddenFiles
        ) else { return }

        let entries: [(url: URL, size: Int, mtime: Date)] = urls.compactMap { url in
            guard let values = try? url.resourceValues(forKeys: Set(keys)),
                  let size = values.fileSize,
                  let mtime = values.contentModificationDate else { return nil }
            return (url, size, mtime)
        }

        var total = entries.reduce(0) { $0 + $1.size }
        guard total > maxBytes else { return }

        // Oldest first → newer files are kept (likely re-played sooner).
        for entry in entries.sorted(by: { $0.mtime < $1.mtime }) {
            if total <= maxBytes { break }
            try? FileManager.default.removeItem(at: entry.url)
            total -= entry.size
        }
    }
}

// MARK: - AVAudioPlayerDelegate

extension OpenAITTSService: AVAudioPlayerDelegate {
    // AVAudioPlayerDelegate callbacks are documented as fired on the
    // thread that called `play()` — typically main here, but Apple's
    // delivery thread has historically been inconsistent across iOS
    // versions. `playCompletion` and `currentRequestId` are otherwise
    // touched only on main, so we hop unconditionally to keep all
    // mutations on a single queue and avoid a TSAN-class race with
    // `play()` / `stopSpeaking()`.
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.isSpeaking.send(false)
            self.playCompletion?(flag)
            self.playCompletion = nil
        }
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.isSpeaking.send(false)
            self.playCompletion?(false)
            self.playCompletion = nil
        }
    }
}
