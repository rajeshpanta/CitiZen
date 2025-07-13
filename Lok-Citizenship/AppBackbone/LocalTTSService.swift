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

        let voice = AVSpeechSynthesisVoice(language: languageCode) ??
                    AVSpeechSynthesisVoice(language: "en-US")!    // fallback

        let u = AVSpeechUtterance(string: text)
        u.voice = voice
        u.rate  = AVSpeechUtteranceDefaultSpeechRate

        try? AVAudioSession.sharedInstance()
            .setCategory(.playback, mode: .spokenAudio, options: .duckOthers)
        try? AVAudioSession.sharedInstance().setActive(true)

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
        try? AVAudioSession.sharedInstance().setActive(false)
    }
}
