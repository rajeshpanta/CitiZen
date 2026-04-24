import Foundation
import AVFoundation
import Combine
import CryptoKit

/// OpenAI-backed text-to-speech. Downloads MP3 from the `/v1/audio/speech` endpoint,
/// caches it to disk, and plays it with AVAudioPlayer.
///
/// API key is read from `UserDefaults.standard.string(forKey: "openai_api_key")`.
/// If no key is set, `isConfigured` is false and the router should use the local service.
final class OpenAITTSService: NSObject, TextToSpeechService {

    // MARK: - Config (single voice, single model for now)

    private static let voice = "nova"
    private static let model = "tts-1"
    private static let endpoint = URL(string: "https://api.openai.com/v1/audio/speech")!

    // MARK: - Protocol output

    var isSpeakingPublisher: AnyPublisher<Bool, Never> { isSpeaking.eraseToAnyPublisher() }

    // MARK: - Private state

    private let isSpeaking = CurrentValueSubject<Bool, Never>(false)
    private var finished   = PassthroughSubject<Void, Never>()
    private var currentTask: URLSessionDataTask?
    private var player: AVAudioPlayer?

    // MARK: - Configuration check

    var isConfigured: Bool {
        let k = UserDefaults.standard.string(forKey: "openai_api_key") ?? ""
        return !k.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private var apiKey: String? {
        let raw = UserDefaults.standard.string(forKey: "openai_api_key") ?? ""
        let trimmed = raw.trimmingCharacters(in: .whitespaces)
        return trimmed.isEmpty ? nil : trimmed
    }

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

    /// Fetch audio (from cache or API) and play it.
    /// Calls `completion(true)` when playback finishes, `completion(false)` if fetch or play failed
    /// before any audio was produced. The router uses this to fall back to local TTS on failure.
    func fetchAndPlay(text: String, completion: @escaping (Bool) -> Void) {
        guard let key = apiKey, !text.isEmpty else {
            completion(false)
            return
        }

        let cacheURL = cacheFileURL(for: text)
        if FileManager.default.fileExists(atPath: cacheURL.path) {
            play(from: cacheURL, completion: completion)
            return
        }

        var req = URLRequest(url: Self.endpoint)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        req.timeoutInterval = 15
        let body: [String: Any] = [
            "model": Self.model,
            "voice": Self.voice,
            "input": text,
            "response_format": "mp3"
        ]
        req.httpBody = try? JSONSerialization.data(withJSONObject: body)

        currentTask = URLSession.shared.dataTask(with: req) { [weak self] data, response, error in
            guard let self else { return }
            if let error = error as NSError?, error.code == NSURLErrorCancelled {
                DispatchQueue.main.async { completion(false) }
                return
            }
            guard error == nil,
                  let data,
                  let http = response as? HTTPURLResponse,
                  http.statusCode == 200 else {
                #if DEBUG
                if let http = response as? HTTPURLResponse {
                    print("[OpenAI TTS] HTTP \(http.statusCode): \(String(data: data ?? Data(), encoding: .utf8) ?? "")")
                } else if let error {
                    print("[OpenAI TTS] error: \(error)")
                }
                #endif
                DispatchQueue.main.async { completion(false) }
                return
            }
            do {
                try data.write(to: cacheURL, options: .atomic)
            } catch {
                DispatchQueue.main.async { completion(false) }
                return
            }
            DispatchQueue.main.async {
                self.play(from: cacheURL, completion: completion)
            }
        }
        currentTask?.resume()
    }

    // MARK: - Playback

    private var playCompletion: ((Bool) -> Void)?

    private func play(from url: URL, completion: @escaping (Bool) -> Void) {
        do {
            let session = AVAudioSession.sharedInstance()
            if session.category != .playback {
                try session.setCategory(.playback, mode: .spokenAudio, options: .duckOthers)
            }
            try session.setActive(true)

            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.prepareToPlay()
            player?.play()
            isSpeaking.send(true)
            playCompletion = completion
        } catch {
            #if DEBUG
            print("[OpenAI TTS] Playback failed: \(error)")
            #endif
            completion(false)
        }
    }

    // MARK: - Stop

    func stopSpeaking() {
        currentTask?.cancel()
        currentTask = nil
        player?.stop()
        player = nil
        if isSpeaking.value {
            isSpeaking.send(false)
        }
        playCompletion?(false)
        playCompletion = nil
    }

    // MARK: - Cache

    private func cacheFileURL(for text: String) -> URL {
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("openai_tts", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let key = "\(Self.model)|\(Self.voice)|\(text)"
        let hash = SHA256.hash(data: Data(key.utf8))
            .map { String(format: "%02x", $0) }
            .joined()
        return dir.appendingPathComponent("\(hash).mp3")
    }
}

// MARK: - AVAudioPlayerDelegate

extension OpenAITTSService: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isSpeaking.send(false)
        playCompletion?(flag)
        playCompletion = nil
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        isSpeaking.send(false)
        playCompletion?(false)
        playCompletion = nil
    }
}
