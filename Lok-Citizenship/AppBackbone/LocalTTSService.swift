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
final class LocalTTSService: NSObject, TextToSpeechService {

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

        let session = AVAudioSession.sharedInstance()
        do {
            if session.category != .playback {
                try session.setCategory(.playback, mode: .spokenAudio, options: .duckOthers)
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
