//
//  LocalSTTService.swift
//

import Foundation          // basic types
import AVFoundation        // audio session / engine
import Speech              // SFSpeechRecognizer…
import Combine             // publishers

// ───────────────────────────────────────────
// MARK: Speech-to-Text service protocol
// ───────────────────────────────────────────
protocol SpeechToTextService {
    var authorizationStatusPublisher: AnyPublisher<SFSpeechRecognizerAuthorizationStatus,Never> { get }
    var isRecordingPublisher:         AnyPublisher<Bool,Never>                                 { get }
    var transcriptionPublisher:       AnyPublisher<String,Never>                               { get }
    /// True from the moment the engine stops (silence detected) through the
    /// async transcription round-trip, false otherwise. Lets views distinguish
    /// "still listening" from "user finished, we're processing" — without
    /// this signal, `isRecordingPublisher` stays true through the cloud-
    /// transcription window (Whisper) and the UI reads "Listening" while
    /// the user has actually stopped talking and is waiting on the upload.
    /// Default impl returns `Just(false)` for synchronous services
    /// (LocalSTT) where the gap doesn't exist.
    var isProcessingPublisher:        AnyPublisher<Bool,Never>                                 { get }

    func requestAuthorization()

    /// – Parameters:
    ///   - options:      the four multiple-choice strings (exact text)
    ///   - localeCode:   e.g. “en-US” or “hi-IN”
    ///   - offlineOnly:  *true* ⇒ prefer on-device, but will stream if unavailable
    func startRecording(withOptions options:[String],
                        localeCode:String,
                        offlineOnly:Bool)

    /// Graceful stop — finalize whatever audio has been captured (e.g. upload
    /// to Whisper). Use when the user wants their words to count.
    func stopRecording()

    /// Hard cancel — discard any captured audio, skip any pending upload, and
    /// release the audio session. Use when the user has explicitly chosen a
    /// different action (End/Back/Skip/tap-answer/replay) and the in-flight
    /// recording is no longer relevant.
    ///
    /// Default implementation falls through to `stopRecording()` for services
    /// without async finalization. WhisperSTTService overrides this to skip
    /// the wasted Whisper round-trip.
    func cancelRecording()
}

extension SpeechToTextService {
    func cancelRecording() { stopRecording() }
    /// Default: services without a post-engine-stop processing window
    /// (LocalSTT — SF returns transcripts synchronously off the engine
    /// callback) report a constant false. Concrete services that have
    /// such a window (WhisperSTT) override with a real subject.
    var isProcessingPublisher: AnyPublisher<Bool,Never> {
        Just(false).eraseToAnyPublisher()
    }
}

// ───────────────────────────────────────────
// MARK: Concrete on-device / streaming STT
// ───────────────────────────────────────────
final class LocalSTTService: NSObject, SpeechToTextService {

    // publishers
    private let auth  = CurrentValueSubject<SFSpeechRecognizerAuthorizationStatus,Never>(.notDetermined)
    private let rec   = CurrentValueSubject<Bool,Never>(false)
    private let trans = PassthroughSubject<String,Never>()

    var authorizationStatusPublisher: AnyPublisher<SFSpeechRecognizerAuthorizationStatus,Never> { auth.eraseToAnyPublisher() }
    var isRecordingPublisher:         AnyPublisher<Bool,Never>                                 { rec.eraseToAnyPublisher()  }
    var transcriptionPublisher:       AnyPublisher<String,Never>                               { trans.eraseToAnyPublisher()}

    // speech objects
    private let engine      = AVAudioEngine()
    private var recognizer  : SFSpeechRecognizer?
    private var request     : SFSpeechAudioBufferRecognitionRequest?
    private var task        : SFSpeechRecognitionTask?

    // ───────────────────────────────
    // MARK: authorisation
    // ───────────────────────────────
    func requestAuthorization() {
        AVAudioSession.sharedInstance().requestRecordPermission { ok in
            guard ok else { DispatchQueue.main.async { self.auth.send(.denied) }; return }
            SFSpeechRecognizer.requestAuthorization { st in
                DispatchQueue.main.async { self.auth.send(st) }
            }
        }
    }

    // ───────────────────────────────
    // MARK: start recording
    // ───────────────────────────────
    func startRecording(withOptions options:[String],
                        localeCode:String,
                        offlineOnly:Bool = false)
    {
        stopRecording()                                      // clean slate

        // Apple's SFSpeechRecognizer does not support Nepali (ne-NP). Nepali and
        // Hindi share the Devanagari script and roughly 60% of vocabulary, so
        // the Hindi recognizer is used as a best-effort fallback for Nepali
        // speakers. TTS still uses ne-NP for speaking — this substitution is
        // scoped to the STT layer only.
        let effectiveLocale = (localeCode == "ne-NP") ? "hi-IN" : localeCode

        recognizer = SFSpeechRecognizer(locale: Locale(identifier: effectiveLocale))
        guard let recognizer, recognizer.isAvailable else {
            auth.send(.restricted); return
        }

        // prefer on-device – fall back to streaming if missing
        let wantOnDevice = offlineOnly && recognizer.supportsOnDeviceRecognition

        request = SFSpeechAudioBufferRecognitionRequest()
        request?.shouldReportPartialResults  = true
        request?.requiresOnDeviceRecognition = wantOnDevice
        // `options` is part of the protocol for callers that wanted early-stop
        // on a literal option phrase. We don't use it any more — that hack
        // cut off ESL users mid-sentence ("not Washington, I mean Adams") and
        // mis-fired on short options. We rely on SF's `isFinal` (silence) here
        // and on AnswerMatcher to handle the actual match downstream.
        _ = options

        // Configure shared session via the central helper. Same
        // category, mode, options, and route override as every other
        // audio path — and importantly, the helper drops
        // `.defaultToSpeaker` (which previously forced our output to the
        // iPhone speaker even when a BT speaker was connected) and
        // applies a runtime route override that picks the speaker only
        // when no external output is present.
        guard AudioSessionPrewarmer.configureSession() else {
            rec.send(false); return
        }

        // mic → recognition buffer
        let node = engine.inputNode
        let fmt  = node.outputFormat(forBus: 0)
        guard fmt.sampleRate > 0 else {          // no mic / invalid format
            rec.send(false); return
        }
        node.removeTap(onBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: fmt) { [weak self] buf, _ in
            self?.request?.append(buf)
        }

        try? engine.start()
        rec.send(true)

        guard let request else { rec.send(false); return }
        task = recognizer.recognitionTask(with: request) { [weak self] res, err in
            guard let self else { return }

            if let res {
                let txt = res.bestTranscription.formattedString
                trans.send(txt)
                if res.isFinal { stopRecording(); return }
            }
            if err != nil { stopRecording() }
        }
    }

    // ───────────────────────────────
    // MARK: stop
    // ───────────────────────────────
    func stopRecording() {
        if engine.isRunning {
            engine.stop()
            engine.inputNode.removeTap(onBus: 0)
        }
        request?.endAudio()
        task?.cancel()
        request = nil; task = nil
        rec.send(false)

        // Do NOT deactivate the audio session here. `stopRecording` is
        // called between every question (via `VoiceQuizController.stopAudio`),
        // and a `setActive(false)` → next-question's `setActive(true)` cycle
        // makes background music un-duck and re-duck audibly on every
        // STT↔TTS handoff. The orange mic indicator drops as soon as
        // `engine.stop()` runs (it tracks active mic capture, not session
        // active state), so we don't need the deactivate to clear it.
        // Final teardown happens in the view's `.onDisappear` via
        // `AudioSessionPrewarmer.deactivate()`.
    }
}
