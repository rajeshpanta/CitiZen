import Foundation
import AVFoundation
import Combine

// MARK: – Protocol
protocol TextToSpeechService {
    var isSpeakingPublisher: AnyPublisher<Bool, Never> { get }
    func speak(_ text: String, languageCode: String) -> AnyPublisher<Void, Never>
    func stopSpeaking()
}

// MARK: – Implementation
//
// `@unchecked Sendable` is the audit-and-assert pattern: we know this class
// is reachable from concurrent contexts (Combine `flatMap` captures, the
// `ServiceLocator.shared` static), but `AVSpeechSynthesizer` itself is not
// Sendable. The thread-safety contract we maintain:
//
//  1. All public API (`speak`, `stopSpeaking`) is called from the main
//     actor — the only consumer is `VoiceQuizController`, which is
//     `@MainActor`.
//  2. `AVSpeechSynthesizer` delivers its delegate callbacks on the same
//     thread that invoked `speak` — main, by (1).
//  3. `isSpeaking` and `finished` are Combine subjects (thread-safe
//     internally); subscribers `receive(on: DispatchQueue.main)` before
//     reading anyway.
//
// Without `@unchecked Sendable`, strict concurrency flags the non-Sendable
// `synthesizer` property as breaking the class's implicit Sendable
// conformance.
final class LocalTTSService: NSObject, TextToSpeechService, @unchecked Sendable {

    // Public publisher
    var isSpeakingPublisher: AnyPublisher<Bool, Never> { isSpeaking.eraseToAnyPublisher() }

    // Private
    private let synthesizer = AVSpeechSynthesizer()
    private let isSpeaking  = CurrentValueSubject<Bool, Never>(false)
    private var finished    = PassthroughSubject<Void, Never>()

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    // MARK: Speak
    func speak(_ text: String, languageCode: String) -> AnyPublisher<Void, Never> {
        stopSpeaking()
        finished = PassthroughSubject<Void, Never>()

        // iOS does not ship a Nepali (ne-NP) voice pack, so a raw lookup returns
        // nil and the chain falls through to an English voice that garbles the
        // Devanagari text. Hindi (hi-IN) uses the same script and pronounces
        // Nepali text intelligibly, so it's a better first fallback for Nepali
        // than English. Mirrors the STT fallback in LocalSTTService.
        let voice = AVSpeechSynthesisVoice(language: languageCode)
                    ?? (languageCode == "ne-NP" ? AVSpeechSynthesisVoice(language: "hi-IN") : nil)
                    ?? AVSpeechSynthesisVoice(language: "en-US")
                    ?? AVSpeechSynthesisVoice.speechVoices().first

        let u = AVSpeechUtterance(string: text)
        u.voice = voice
        u.rate  = AVSpeechUtteranceDefaultSpeechRate
        u.preUtteranceDelay = 0    // no pause before speaking
        u.postUtteranceDelay = 0   // no pause after speaking

        // Match WhisperSTTService and OpenAITTSService — keep .playAndRecord
        // throughout the interview so we don't transition categories mid-flow.
        // Category switches on a live session are flaky on real devices.
        let session = AVAudioSession.sharedInstance()
        do {
            if session.category != .playAndRecord {
                try session.setCategory(
                    .playAndRecord,
                    mode: .spokenAudio,
                    options: [.duckOthers, .defaultToSpeaker, .allowBluetoothHFP]
                )
            }
            try session.setActive(true)
        } catch {
            #if DEBUG
            print("[TTS] Audio session setup failed: \(error)")
            #endif
        }

        synthesizer.speak(u)
        isSpeaking.send(true)
        return finished.eraseToAnyPublisher()
    }

    // MARK: Stop
    func stopSpeaking() {
        // Unconditional emits on stop (even if already idle) are deliberate.
        // Subscribers (notably VoiceQuizController.bindPublishers) detect a
        // true→false transition to fire onTTSFinished. When stopSpeaking is
        // called while already idle, we emit false→false — subscribers cache
        // the prior value, so the transition check correctly drops it.
        //
        // Safety detail: VoiceQuizController.stop() calls stopAudio (→ this
        // method) BEFORE flipping phase to .idle. If receive(on:) were
        // synchronous, onTTSFinished would run while phase is still
        // .speakingQuestion and schedule a stale autoStartListening. Combine's
        // receive(on: DispatchQueue.main) is asynchronous (next runloop), so
        // by the time the subscriber runs, phase is already .idle and the
        // guard in onTTSFinished correctly drops it. Don't change to a
        // synchronous scheduler without revisiting that flow.
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking.send(false)
        finished.send(()); finished.send(completion: .finished)
    }
}

// MARK: – Delegate
extension LocalTTSService: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_: AVSpeechSynthesizer, didStart _: AVSpeechUtterance) {
        isSpeaking.send(true)
    }
    func speechSynthesizer(_: AVSpeechSynthesizer, didFinish _: AVSpeechUtterance) { done() }
    func speechSynthesizer(_: AVSpeechSynthesizer, didCancel _: AVSpeechUtterance) { done() }

    private func done() {
        isSpeaking.send(false)
        finished.send(()); finished.send(completion: .finished)
        // Keep audio session active for faster TTS/STT transitions.
    }
}
