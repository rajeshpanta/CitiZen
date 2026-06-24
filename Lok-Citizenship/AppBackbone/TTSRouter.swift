import Foundation
import Combine

/// Routes TTS calls to OpenAI (if configured) with automatic fallback to on-device TTS
/// when there's no key or the API request fails.
final class TTSRouter: TextToSpeechService {

    private let openAI: OpenAITTSService
    private let local  = LocalTTSService()

    private let isSpeakingSubject = CurrentValueSubject<Bool, Never>(false)
    private var subs = Set<AnyCancellable>()
    private var fallbackSub: AnyCancellable?
    /// Tracks the public publisher returned by the most recent `speak(...)`
    /// call so `stopSpeaking()` can complete it terminally. Without this
    /// reference, an in-flight OpenAI fetch interrupted by `stopSpeaking`
    /// has its callback dropped (request-id guard) and the returned
    /// publisher never reaches `.finished` — any subscriber awaiting
    /// completion hangs forever. Today this is masked by VoiceQuizController
    /// cancelling its `ttsChain` subscription on stop, but any other
    /// consumer (or a future `for await` caller) would hang.
    private var inFlightSubject: PassthroughSubject<Void, Never>?

    var isSpeakingPublisher: AnyPublisher<Bool, Never> {
        isSpeakingSubject.eraseToAnyPublisher()
    }

    /// `openAI` is injected so all consumers (TTSRouter + SlowSpeechHelper)
    /// can share one OpenAITTSService — see the comment on
    /// `ServiceLocator.openAITTS` for why. Default argument preserves
    /// backward compatibility for any caller that still wants its own
    /// isolated instance (currently none in this codebase, but cheap to
    /// keep).
    init(openAI: OpenAITTSService = OpenAITTSService()) {
        self.openAI = openAI
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

        // Use OpenAI TTS for all languages when configured. OpenAI handles
        // multilingual text well (Spanish, Mandarin, Nepali), and for Nepali
        // it's strictly better than the iOS fallback (no ne-NP voice pack →
        // iOS degrades to Hindi; OpenAI speaks Nepali directly). Local TTS
        // is kept as the automatic fallback when OpenAI is not configured or
        // the network/API call fails.
        guard openAI.isConfigured else {
            return local.speak(text, languageCode: languageCode)
        }

        let subject = PassthroughSubject<Void, Never>()
        inFlightSubject = subject

        openAI.fetchAndPlay(text: text) { [weak self] success in
            guard let self else { return }
            // Drop the callback if stopSpeaking already terminated the
            // subject (and nil'd / replaced inFlightSubject). Without this
            // identity check, a late successful callback could re-emit on
            // an already-finished PassthroughSubject (Combine treats that
            // as a no-op so no crash, but it's a clearer contract this way).
            guard self.inFlightSubject === subject else { return }
            if success {
                subject.send(())
                subject.send(completion: .finished)
                self.inFlightSubject = nil
            } else {
                // OpenAI couldn't produce audio (no key accepted, network fail, API error).
                // Fall back to local TTS.
                self.fallbackSub = self.local.speak(text, languageCode: languageCode)
                    .sink { [weak self] _ in
                        guard let self, self.inFlightSubject === subject else { return }
                        subject.send(())
                        subject.send(completion: .finished)
                        self.inFlightSubject = nil
                    }
            }
        }

        return subject.eraseToAnyPublisher()
    }

    func stopSpeaking() {
        // Cancel the fallback subscription FIRST so a final emission from
        // `local.stopSpeaking()` can't sneak through and complete the
        // subject after we've intentionally terminated it below.
        fallbackSub?.cancel()
        fallbackSub = nil
        openAI.stopSpeaking()
        local.stopSpeaking()
        // Complete any in-flight publisher with `.finished` so subscribers
        // waiting on the speech chain reach a terminal signal even when
        // OpenAI's callback got dropped by its request-id guard. Identity
        // captured locally so we can clear the property BEFORE sending
        // the terminal — that way any racing callback identity-check
        // sees `nil` and bails out.
        if let subject = inFlightSubject {
            inFlightSubject = nil
            subject.send(())
            subject.send(completion: .finished)
        }
    }
}
