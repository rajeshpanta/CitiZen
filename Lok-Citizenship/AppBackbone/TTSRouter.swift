import Foundation
import Combine

/// Routes TTS calls to OpenAI (if configured) with automatic fallback to on-device TTS
/// when there's no key or the API request fails.
final class TTSRouter: TextToSpeechService {

    private let openAI = OpenAITTSService()
    private let local  = LocalTTSService()

    private let isSpeakingSubject = CurrentValueSubject<Bool, Never>(false)
    private var subs = Set<AnyCancellable>()
    private var fallbackSub: AnyCancellable?

    var isSpeakingPublisher: AnyPublisher<Bool, Never> {
        isSpeakingSubject.eraseToAnyPublisher()
    }

    init() {
        Publishers.CombineLatest(
            openAI.isSpeakingPublisher,
            local.isSpeakingPublisher
        )
        .map { $0 || $1 }
        .removeDuplicates()
        .sink { [weak self] in self?.isSpeakingSubject.send($0) }
        .store(in: &subs)
    }

    // MARK: - Protocol

    func speak(_ text: String, languageCode: String) -> AnyPublisher<Void, Never> {
        stopSpeaking()

        // Language-aware engine choice. OpenAI nova is American-English-
        // accented — it sounds natural reading English content but
        // unnatural reading Spanish / Mandarin / Nepali (correct words,
        // wrong accent). Native iOS voices for those locales sound
        // dramatically better, so non-English speech stays on local TTS.
        // English text gets the OpenAI cloud voice everywhere it's
        // configured, matching the premium feel of Mock Interview.
        let englishOnly = languageCode.lowercased().hasPrefix("en")

        guard openAI.isConfigured && englishOnly else {
            return local.speak(text, languageCode: languageCode)
        }

        let subject = PassthroughSubject<Void, Never>()

        openAI.fetchAndPlay(text: text) { [weak self] success in
            guard let self else { return }
            if success {
                subject.send(())
                subject.send(completion: .finished)
            } else {
                // OpenAI couldn't produce audio (no key accepted, network fail, API error).
                // Fall back to local TTS.
                self.fallbackSub = self.local.speak(text, languageCode: languageCode)
                    .sink { _ in
                        subject.send(())
                        subject.send(completion: .finished)
                    }
            }
        }

        return subject.eraseToAnyPublisher()
    }

    func stopSpeaking() {
        openAI.stopSpeaking()
        local.stopSpeaking()
        fallbackSub?.cancel()
        fallbackSub = nil
    }
}
