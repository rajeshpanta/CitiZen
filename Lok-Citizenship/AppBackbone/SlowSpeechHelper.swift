import Foundation
import AVFoundation
import Combine

/// Slowed-speech helper used by the Reading / Writing practice + test screens.
///
/// These screens need slower-than-default speech rates (~0.8–0.85×) as an ESL aid.
/// The Reading / Writing flows are USCIS English-only, so by default this helper
/// routes through `OpenAITTSService` (the same premium voice as Mock Interview
/// and Practice 1–5 in English) and uses `AVAudioPlayer.rate` for the slowdown,
/// preserving the ESL pacing while upgrading the voice. When OpenAI isn't
/// configured (dev builds) — or when a future caller passes a non-English
/// `languageCode` — we fall back to a shared `AVSpeechSynthesizer`.
///
/// Lifecycle notes:
/// - One `AVSpeechSynthesizer` and one `OpenAITTSService` instance app-wide.
/// - A new `speak` interrupts whichever engine is currently playing.
/// - `stop()` interrupts both engines so callers don't have to know which is in use.
final class SlowSpeechHelper: NSObject {

    static let shared = SlowSpeechHelper()

    private let synthesizer = AVSpeechSynthesizer()
    private let localSpeaking = CurrentValueSubject<Bool, Never>(false)
    /// Identity-tracks the utterance handed to synthesizer.speak(). Stale
    /// didCancel callbacks (from a prior utterance interrupted by a new speak)
    /// are dropped by guarding against this in the delegate — mirrors LocalTTSService.
    private var currentUtterance: AVSpeechUtterance?
    /// Shared with `TTSRouter` (and therefore the Quiz/Mock/AudioOnly
    /// flows) via `ServiceLocator`. Owning a separate instance here used
    /// to mean Reading-practice TTS and Mock-interview TTS could collide
    /// on the same `AVAudioSession` with no way for either side's
    /// `stopSpeaking` to silence the other. One shared instance gives
    /// one in-flight player + one request-id across the whole app.
    private let openAI = ServiceLocator.shared.openAITTS

    private override init() {
        super.init()
        synthesizer.delegate = self
    }

    /// Emits `true` while either the cloud (OpenAI) or local AVSpeechSynthesizer
    /// is active. Views use this to clear the "buffering…" spinner the moment
    /// audio starts — the cloud path takes 300–1500 ms on a cold fetch; the
    /// local fallback fires almost instantly but still needs to clear the spinner.
    var isSpeakingPublisher: AnyPublisher<Bool, Never> {
        openAI.isSpeakingPublisher
            .combineLatest(localSpeaking)
            .map { $0 || $1 }
            .eraseToAnyPublisher()
    }

    /// Best-effort cache warm for `text`. No-op when OpenAI is unconfigured
    /// or the language isn't English (the local synthesizer doesn't cache).
    /// Idempotent — see `OpenAITTSService.prefetch`. Safe to call from
    /// `.onAppear` and `.onChange(currentIndex)` to pre-warm the next card.
    func prefetch(text: String, languageCode: String = "en-US") {
        guard openAI.isConfigured,
              languageCode.lowercased().hasPrefix("en") else { return }
        openAI.prefetch(text: text)
    }

    /// Speak `text` at the given rate multiplier (1.0 = default speech rate).
    /// Any currently-playing speech is interrupted first.
    func speak(_ text: String,
               rateMultiplier: Float = 0.85,
               languageCode: String = "en-US") {
        // Stop both engines — caller doesn't know which one was last used,
        // and one of them might still be playing a previous sentence.
        synthesizer.stopSpeaking(at: .immediate)
        openAI.stopSpeaking()

        // Self-heal the audio session before speaking. `LocalSTTService`
        // deactivates the session with `.notifyOthersOnDeactivation` after
        // STT, so the next playback would queue onto an inactive session
        // and fail silently. Use the central helper (same `.playAndRecord`
        // config as every other audio path) so we don't churn the category
        // between Reading practice and Mock Interview / Quiz / Audio-Only —
        // category transitions on a live session are flaky on real devices.
        AudioSessionPrewarmer.configureSession()

        let englishOnly = languageCode.lowercased().hasPrefix("en")
        if openAI.isConfigured && englishOnly {
            openAI.fetchAndPlay(text: text, rate: rateMultiplier) { [weak self] success in
                // Fall back to AVSpeechSynthesizer only if the cloud call
                // never produced playable audio. The guarded-completion in
                // OpenAITTSService already drops late stale callbacks, so
                // success=false here is a real fetch/decode failure.
                guard let self, !success else { return }
                self.speakLocal(text, rateMultiplier: rateMultiplier, languageCode: languageCode)
            }
        } else {
            speakLocal(text, rateMultiplier: rateMultiplier, languageCode: languageCode)
        }
    }

    private func speakLocal(_ text: String, rateMultiplier: Float, languageCode: String) {
        let utterance = AVSpeechUtterance(string: text)
        // ne-NP has no iOS voice pack — fall back to hi-IN (same Devanagari
        // script, intelligible pronunciation) then en-US, matching LocalTTSService.
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
                        ?? (languageCode == "ne-NP" ? AVSpeechSynthesisVoice(language: "hi-IN") : nil)
                        ?? (languageCode.hasPrefix("es-") ? AVSpeechSynthesisVoice.speechVoices().first(where: { $0.language.hasPrefix("es-") }) : nil)
                        ?? AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * rateMultiplier
        currentUtterance = utterance
        synthesizer.speak(utterance)
    }

    func stop() {
        // Eagerly reset localSpeaking so isSpeakingPublisher clears immediately —
        // stopSpeaking(at: .immediate) only schedules didCancel asynchronously,
        // which would leave the spinner stuck for up to one run-loop.
        currentUtterance = nil
        localSpeaking.send(false)
        synthesizer.stopSpeaking(at: .immediate)
        openAI.stopSpeaking()
    }
}

// MARK: - AVSpeechSynthesizerDelegate

extension SlowSpeechHelper: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        guard utterance === currentUtterance else { return }
        localSpeaking.send(true)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        guard utterance === currentUtterance else { return }
        currentUtterance = nil
        localSpeaking.send(false)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        guard utterance === currentUtterance else { return }
        currentUtterance = nil
        localSpeaking.send(false)
    }
}
