import Foundation
import AVFoundation
import Speech
import Combine
import os

/// Hybrid STT for the mock interview.
///
/// One mic source (`AVAudioEngine` input tap) feeds two consumers in parallel:
///
/// - **SFSpeechRecognizer** — live partial transcripts (so the user sees
///   words appear as they speak) and built-in silence detection (the
///   recognizer fires `isFinal` ~1.5 s after the user stops talking).
/// - **AVAudioFile** — captures the same buffers to disk so we can upload
///   the full clip to OpenAI Whisper for the *final accurate* transcript
///   used for answer matching.
///
/// On silence, we end the SF request, stop the engine, and upload to
/// Whisper. When Whisper returns, we replace the on-screen partial with the
/// authoritative transcript and tell the controller to evaluate. If Whisper
/// fails, we fall back to the last SF partial so the user still gets a
/// match instead of a dead end.
///
/// `VoiceQuizController.bindPublishers` reads the stored transcription on
/// the trailing edge of `isRecording`, so we publish the final transcript
/// *before* flipping `isRecording = false`.
final class WhisperSTTService: NSObject, SpeechToTextService {

    private static let log = Logger(subsystem: "com.citizen.app", category: "WhisperSTT")

    // ── Publishers (protocol) ───────────────────────────────────────────
    private let auth  = CurrentValueSubject<SFSpeechRecognizerAuthorizationStatus, Never>(.notDetermined)
    private let rec   = CurrentValueSubject<Bool, Never>(false)
    private let trans = PassthroughSubject<String, Never>()

    var authorizationStatusPublisher: AnyPublisher<SFSpeechRecognizerAuthorizationStatus, Never> {
        auth.eraseToAnyPublisher()
    }
    var isRecordingPublisher: AnyPublisher<Bool, Never> { rec.eraseToAnyPublisher() }
    var transcriptionPublisher: AnyPublisher<String, Never> { trans.eraseToAnyPublisher() }

    // ── Recording state ─────────────────────────────────────────────────
    private let engine = AVAudioEngine()
    private var sfRecognizer: SFSpeechRecognizer?
    private var sfRequest: SFSpeechAudioBufferRecognitionRequest?
    private var sfTask: SFSpeechRecognitionTask?
    private var audioFile: AVAudioFile?
    private var recordingURL: URL?
    private var languageHint: String?
    private var uploadTask: Task<Void, Never>?

    /// Last SF partial — used as the fallback transcript if Whisper fails.
    private var lastPartial: String = ""

    /// Guards `handleSilenceDetected` from running twice (SF can deliver
    /// `isFinal` then immediately error on the same task).
    private var didTriggerStop = false

    // ── Early-exit state ────────────────────────────────────────────────
    /// Quiz options for the current question. Used by the early-exit check
    /// to score live SF partials against the answer choices. Empty when the
    /// caller didn't pass options (free-form mode), in which case early-exit
    /// is disabled.
    private var quizOptions: [String] = []

    /// When listening began. Early-exit is suppressed for the first ~1.5s so
    /// brief stray partials ("um…") don't commit before the user actually
    /// finishes their answer.
    private var listeningStartTime: Date?

    /// Local match score required to skip the Whisper upload and commit the
    /// SF partial directly. Tuned high — we'd rather pay the upload latency
    /// than commit a wrong answer prematurely.
    private static let earlyExitMinScore = 0.85
    /// Minimum margin between the best option and runner-up. Without this an
    /// ambiguous partial like "Lincoln was first president" could fire
    /// prematurely if multiple options score high.
    private static let earlyExitMinMargin = 0.15
    /// Minimum number of spoken tokens before early-exit is allowed. Stops a
    /// single spurious word ("yeah") from triggering a commit.
    private static let earlyExitMinTokens = 2
    /// Minimum elapsed listening time before early-exit is allowed.
    private static let earlyExitMinElapsed: TimeInterval = 1.5

    // ── Authorization (mic + speech recognition) ───────────────────────
    func requestAuthorization() {
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] mic in
            guard mic else {
                DispatchQueue.main.async { self?.auth.send(.denied) }
                return
            }
            // SF authorization is also required for the live-partial path.
            SFSpeechRecognizer.requestAuthorization { status in
                DispatchQueue.main.async { self?.auth.send(status) }
            }
        }
    }

    // ── Start ───────────────────────────────────────────────────────────
    func startRecording(withOptions options: [String],
                        localeCode: String,
                        offlineOnly: Bool) {
        // `offlineOnly` is for the `LocalSTTService` use case; the Whisper path
        // always does silence-stop + cloud transcription. `options` is now used
        // for the early-exit check — when an SF partial already maps to one
        // option with high local confidence, skip the Whisper roundtrip.
        _ = offlineOnly

        stopEngineAndSF()                                  // clean slate
        didTriggerStop = false
        lastPartial = ""
        quizOptions = options
        listeningStartTime = Date()
        languageHint = String(localeCode.prefix(2)).lowercased()

        // Audio session — keep on .playAndRecord so TTS can play between
        // questions without another category transition (see comment in
        // OpenAITTSService for why mid-session transitions are fragile on
        // real devices).
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(
                .playAndRecord,
                mode: .spokenAudio,
                options: [.duckOthers, .defaultToSpeaker, .allowBluetoothHFP]
            )
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            Self.log.error("session config failed: \(String(describing: error))")
            rec.send(false); return
        }

        // SF recognizer for the live-partial + silence path. Apple's models
        // don't cover Nepali (ne-NP); fall back to Hindi for similar
        // Devanagari coverage. Whisper handles the final accurate pass for
        // any language.
        let effectiveLocale = (localeCode == "ne-NP") ? "hi-IN" : localeCode
        let recog = SFSpeechRecognizer(locale: Locale(identifier: effectiveLocale))
        guard let recog, recog.isAvailable else {
            Self.log.error("SF recognizer unavailable for \(effectiveLocale, privacy: .public)")
            // Audio session is already active by this point — release it so
            // the orange mic indicator doesn't stick on this failure path.
            deactivateSession()
            rec.send(false); return
        }
        sfRecognizer = recog

        let req = SFSpeechAudioBufferRecognitionRequest()
        req.shouldReportPartialResults = true
        req.requiresOnDeviceRecognition = false   // streaming mode for accuracy + auto-isFinal
        sfRequest = req

        // Mic tap — same buffer feeds SF and the WAV file we'll upload.
        let input = engine.inputNode
        input.removeTap(onBus: 0)
        let format = input.outputFormat(forBus: 0)
        guard format.sampleRate > 0 else {
            Self.log.error("invalid input format (sampleRate=\(format.sampleRate))")
            deactivateSession()
            rec.send(false); return
        }

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("whisper-\(UUID().uuidString).wav")
        do {
            // Write 16-bit mono PCM in the input's native sample rate. Whisper
            // accepts WAV directly. At 48 kHz mono int16 that's ~96 KB/sec, so
            // a 30-second answer is ~3 MB — well under our server cap.
            audioFile = try AVAudioFile(
                forWriting: url,
                settings: [
                    AVFormatIDKey: kAudioFormatLinearPCM,
                    AVSampleRateKey: format.sampleRate,
                    AVNumberOfChannelsKey: 1,
                    AVLinearPCMBitDepthKey: 16,
                    AVLinearPCMIsFloatKey: false,
                    AVLinearPCMIsBigEndianKey: false,
                ],
                commonFormat: .pcmFormatInt16,
                interleaved: true
            )
            recordingURL = url
        } catch {
            Self.log.error("audio file create failed: \(String(describing: error))")
            deactivateSession()
            rec.send(false); return
        }

        input.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            // Real-time audio thread — keep work minimal.
            self?.sfRequest?.append(buffer)
            try? self?.audioFile?.write(from: buffer)
        }

        do {
            engine.prepare()
            try engine.start()
        } catch {
            Self.log.error("engine start failed: \(String(describing: error))")
            input.removeTap(onBus: 0)
            deactivateSession()
            rec.send(false); return
        }

        sfTask = recog.recognitionTask(with: req) { [weak self] result, err in
            guard let self else { return }
            if let result = result {
                let text = result.bestTranscription.formattedString
                self.lastPartial = text
                DispatchQueue.main.async {
                    self.trans.send(text)
                }
                // Early-exit: if the live SF partial already maps to a quiz
                // option with high confidence, skip the Whisper upload and
                // commit. Cuts ~1–2s of latency on easy answers; falls back
                // to the full Whisper pass when the partial is ambiguous.
                if self.shouldEarlyExit(partial: text) {
                    self.handleEarlyExit(partial: text)
                    return
                }
                if result.isFinal {
                    self.handleSilenceDetected()
                }
            }
            if err != nil {
                // Common case: SF errors with "no speech detected" after
                // initial silence. Treat the same as isFinal — let the user
                // retry via the "didn't hear you" banner.
                self.handleSilenceDetected()
            }
        }

        Self.log.info("recording started -> \(url.lastPathComponent, privacy: .public)")
        rec.send(true)
    }

    /// Triggered from the SF task callback (background queue) when SF reports
    /// `isFinal` (silence) or an error. Idempotent — only the first call
    /// kicks off stop+upload.
    ///
    /// The `didTriggerStop` guard runs INSIDE the main-queue dispatch so it's
    /// serialized with `stopRecording`, `cancelRecording`, and `handleEarlyExit`
    /// (all main-queue writers). Without that, SF's BG callback could race
    /// with a user-initiated End on main and pass the guard concurrently.
    private func handleSilenceDetected() {
        DispatchQueue.main.async { [weak self] in
            guard let self, !self.didTriggerStop else { return }
            self.didTriggerStop = true
            self.finishRecordingAndUpload()
        }
    }

    /// Decide whether an SF partial is confident enough to skip the Whisper
    /// upload. All four guards must hold:
    ///   1. We have quiz options to score against (free-form callers don't).
    ///   2. We've been listening for at least `earlyExitMinElapsed` (don't fire
    ///      on stray initial partials).
    ///   3. The partial has at least `earlyExitMinTokens` tokens (don't fire
    ///      on a single throwaway word).
    ///   4. The local match score is at least `earlyExitMinScore`.
    private func shouldEarlyExit(partial: String) -> Bool {
        guard !quizOptions.isEmpty else { return false }
        guard let start = listeningStartTime,
              Date().timeIntervalSince(start) >= Self.earlyExitMinElapsed else { return false }
        let tokenCount = partial.split(whereSeparator: { $0.isWhitespace }).count
        guard tokenCount >= Self.earlyExitMinTokens else { return false }
        guard let result = AnswerMatcher.localScore(spoken: partial, options: quizOptions) else {
            return false
        }
        // Both checks: high absolute score AND clear separation from runner-up.
        // Without the margin check, an ambiguous answer could commit to whichever
        // option happened to sort first.
        return result.score >= Self.earlyExitMinScore
            && (result.score - result.runnerUp) >= Self.earlyExitMinMargin
    }

    /// Commit the SF partial as the final transcript and skip the Whisper
    /// upload. Mirrors the path `finishWith` takes after a successful upload.
    /// Idempotent against `didTriggerStop`. Guard runs on main so it serializes
    /// with the other writers (see `handleSilenceDetected` for the rationale).
    private func handleEarlyExit(partial: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self, !self.didTriggerStop else { return }
            self.didTriggerStop = true
            // `.private` so a sysdiagnose / Console.app export redacts the
            // user's spoken text. Xcode (with the dev profile installed)
            // still shows the value, so debugging is unaffected.
            Self.log.info("early-exit on partial: \"\(partial, privacy: .private)\"")
            // Tear down recording state and discard the on-disk audio — we're
            // not going to upload it.
            let url = self.recordingURL
            self.stopEngineAndSF()
            if let url {
                try? FileManager.default.removeItem(at: url)
            }
            // Same emit order as finishWith: transcript first, then flip
            // isRecording so the controller's bindPublishers picks up the
            // final text in `evaluateTranscription`.
            if !partial.isEmpty {
                self.trans.send(partial)
            }
            self.rec.send(false)
            // Note: NOT deactivating session here. The next TTS (answer
            // feedback / next question) will reuse the active session.
            // Deactivation happens only on cancelRecording (End/Back).
        }
    }

    // ── Stop ──────────────────────────────────────────────────────────
    /// Graceful stop — finalize captured audio (upload to Whisper). Idempotent.
    /// Use when the user wants their words to count (e.g., manual mic-tap to
    /// stop because they finished speaking).
    func stopRecording() {
        guard rec.value else {
            stopEngineAndSF()
            return
        }
        if !didTriggerStop {
            didTriggerStop = true
            finishRecordingAndUpload()
        }
    }

    /// Hard cancel — discard captured audio, abort any in-flight Whisper upload,
    /// release the audio session. Used by VoiceQuizController.stopAudio for all
    /// the "user chose a different action" paths (End/Back/Skip/replay/tap-answer).
    /// Idempotent.
    func cancelRecording() {
        // Cancel pending upload (in case finishRecordingAndUpload already ran
        // and the Task is in flight). Task cancellation is cooperative — the
        // upload's URLSession data task respects cancellation by throwing
        // CancellationError, which the upload handler treats as "fall back",
        // but we won't read that result because we tear down state below.
        uploadTask?.cancel()
        uploadTask = nil

        let urlToRemove = recordingURL
        let wasRecording = rec.value

        // Mark stop-triggered so any racing SF callback (handleSilenceDetected
        // / handleEarlyExit) hits its didTriggerStop guard and no-ops.
        didTriggerStop = true

        stopEngineAndSF()
        if let url = urlToRemove {
            try? FileManager.default.removeItem(at: url)
        }

        // Only emit isRecording=false if it was actually true. Re-emitting
        // false→false would fire the controller's onSTTFinished guard
        // unnecessarily (it'd no-op via the phase guard, but the dispatch
        // is still wasted).
        if wasRecording {
            rec.send(false)
        }
        deactivateSession()
    }

    /// Stop engine, end SF, then kick off Whisper upload on the captured file.
    /// Always runs on the main thread.
    private func finishRecordingAndUpload() {
        let urlToUpload = recordingURL
        let language = languageHint
        let partial = lastPartial

        stopEngineAndSF()

        guard let url = urlToUpload else {
            // Engine never started or already torn down — emit failure so the
            // controller surfaces the "didn't hear you" banner.
            Task { [weak self] in await self?.emitFailure() }
            return
        }

        uploadTask?.cancel()
        uploadTask = Task { [weak self] in
            await self?.upload(url: url, language: language, fallback: partial)
        }
    }

    /// Tear down engine, tap, SF task, and audio file. Does NOT flip the
    /// `isRecording` publisher — that happens after the upload resolves so
    /// `VoiceQuizController` evaluates the final transcript.
    private func stopEngineAndSF() {
        if engine.isRunning {
            engine.stop()
        }
        engine.inputNode.removeTap(onBus: 0)
        sfRequest?.endAudio()
        sfTask?.cancel()
        sfRequest = nil
        sfTask = nil
        sfRecognizer = nil
        audioFile = nil
        recordingURL = nil
        quizOptions = []
        listeningStartTime = nil
    }

    // ── Upload ──────────────────────────────────────────────────────────
    private func upload(url: URL, language: String?, fallback: String) async {
        defer { try? FileManager.default.removeItem(at: url) }

        guard let audio = try? Data(contentsOf: url), !audio.isEmpty else {
            Self.log.error("recording file empty: \(url.lastPathComponent, privacy: .public)")
            await finishWith(text: fallback)
            return
        }
        // Audio byte count is fine to log publicly (size, not content).
        // The `fallback` string is the on-device SF transcript that we
        // also send to Whisper — redact in exports for the same reason
        // as the other transcript log sites.
        Self.log.info("uploading \(audio.count) bytes (fallback: \"\(fallback, privacy: .private)\")")

        // Anything under ~4KB of WAV is essentially silence — skip the round
        // trip and use the SF fallback (might be empty too, in which case the
        // controller shows "didn't hear you").
        if audio.count < 4_096 {
            Self.log.info("recording too small; using SF fallback")
            await finishWith(text: fallback)
            return
        }

        let endpoint = SupabaseConfig.url
            .appendingPathComponent("functions/v1/transcribe")
        var req = URLRequest(url: endpoint)
        req.httpMethod = "POST"
        req.setValue(SupabaseConfig.anonKey, forHTTPHeaderField: "apikey")
        req.setValue("Bearer \(SupabaseConfig.anonKey)", forHTTPHeaderField: "Authorization")
        req.setValue(DeviceID.current, forHTTPHeaderField: "X-Device-Id")
        req.timeoutInterval = 30

        let boundary = "Boundary-\(UUID().uuidString)"
        req.setValue("multipart/form-data; boundary=\(boundary)",
                     forHTTPHeaderField: "Content-Type")
        req.httpBody = multipartBody(boundary: boundary,
                                     audio: audio,
                                     filename: url.lastPathComponent,
                                     language: language)

        do {
            let (data, resp) = try await URLSession.shared.data(for: req)
            guard let http = resp as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode)
            else {
                let code = (resp as? HTTPURLResponse)?.statusCode ?? -1
                let bodyStr = String(data: data, encoding: .utf8) ?? ""
                // Status code is fine public (diagnostic only). The
                // response body can contain echoed input text or other
                // server-emitted strings — redact in exports.
                Self.log.error("http \(code, privacy: .public): \(bodyStr, privacy: .private); using SF fallback")
                await finishWith(text: fallback)
                return
            }
            guard
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let text = json["text"] as? String
            else {
                Self.log.error("response not JSON or missing 'text'; using SF fallback")
                await finishWith(text: fallback)
                return
            }
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            // Whisper sometimes returns empty text for true silence — fall
            // back to SF partial in that case (still likely empty, but lets
            // the controller decide the right "no speech" UX).
            let final = trimmed.isEmpty ? fallback : trimmed
            // Final user transcript — `.private` so device-log exports
            // (sysdiagnose, Console.app) redact the user's spoken text.
            // Aligns with the privacy policy's "we do not log or store
            // the resulting transcript" claim.
            Self.log.info("whisper transcript: \(final, privacy: .private)")
            await finishWith(text: final)
        } catch {
            if Task.isCancelled { return }
            Self.log.error("upload failed: \(String(describing: error)); using SF fallback")
            await finishWith(text: fallback)
        }
    }

    private func multipartBody(boundary: String,
                               audio: Data,
                               filename: String,
                               language: String?) -> Data {
        var body = Data()
        let crlf = "\r\n"

        if let lang = language, !lang.isEmpty {
            body.append("--\(boundary)\(crlf)")
            body.append("Content-Disposition: form-data; name=\"language\"\(crlf)\(crlf)")
            body.append("\(lang)\(crlf)")
        }

        body.append("--\(boundary)\(crlf)")
        body.append(
            "Content-Disposition: form-data; name=\"audio\"; filename=\"\(filename)\"\(crlf)"
        )
        body.append("Content-Type: audio/wav\(crlf)\(crlf)")
        body.append(audio)
        body.append(crlf)
        body.append("--\(boundary)--\(crlf)")
        return body
    }

    // ── Emit on main thread ─────────────────────────────────────────────

    @MainActor
    private func finishWith(text: String) {
        // Emit final transcription FIRST (so the controller's
        // bindPublishers sees it when isRecording flips to false), then flip.
        if !text.isEmpty {
            trans.send(text)
        }
        rec.send(false)
        // Note: NOT deactivating audio session here. Keeping .playAndRecord
        // active across questions avoids an activate/deactivate cycle on every
        // STT-then-TTS handoff (cycles can disrupt Bluetooth audio routing and
        // cause the orange-mic-indicator to flicker). Deactivation happens
        // only on `cancelRecording` (End/Back/Skip/replay) — i.e., when the
        // session is truly done.
    }

    @MainActor
    private func emitFailure() {
        rec.send(false)
        // Same rationale as finishWith — keep session active.
    }

    private func deactivateSession() {
        try? AVAudioSession.sharedInstance()
            .setActive(false, options: .notifyOthersOnDeactivation)
    }
}

private extension Data {
    mutating func append(_ string: String) {
        if let d = string.data(using: .utf8) { append(d) }
    }
}
