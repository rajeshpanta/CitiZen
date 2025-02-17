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

    func requestAuthorization()

    /// – Parameters:
    ///   - options:      the four multiple-choice strings (exact text)
    ///   - localeCode:   e.g. “en-US” or “hi-IN”
    ///   - offlineOnly:  *true* ⇒ prefer on-device, but will stream if unavailable
    func startRecording(withOptions options:[String],
                        localeCode:String,
                        offlineOnly:Bool)

    func stopRecording()
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
    private var expectedLC  : [String] = []

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

        recognizer = SFSpeechRecognizer(locale: Locale(identifier: localeCode))
        guard let recognizer, recognizer.isAvailable else {
            auth.send(.restricted); return
        }

        // prefer on-device – fall back to streaming if missing
        let wantOnDevice = offlineOnly && recognizer.supportsOnDeviceRecognition

        request = SFSpeechAudioBufferRecognitionRequest()
        request?.shouldReportPartialResults  = true
        request?.requiresOnDeviceRecognition = wantOnDevice

        expectedLC = options.map { $0.lowercased() }

        // audio session
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? session.setActive(true, options: .notifyOthersOnDeactivation)

        // mic → recognition buffer
        let node = engine.inputNode
        let fmt  = node.outputFormat(forBus: 0)
        node.removeTap(onBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: fmt) { [weak self] buf, _ in
            self?.request?.append(buf)
        }

        try? engine.start()
        rec.send(true)

        task = recognizer.recognitionTask(with: request!) { [weak self] res, err in
            guard let self else { return }

            if let res {
                let txt = res.bestTranscription.formattedString
                trans.send(txt)

                let spoken = txt.lowercased()
                if expectedLC.contains(where: { spoken == $0 || spoken.contains($0) }) {
                    stopRecording(); return
                }
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
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
}
