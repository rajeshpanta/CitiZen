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
final class SlowSpeechHelper {

    static let shared = SlowSpeechHelper()

    private let synthesizer = AVSpeechSynthesizer()
    private let openAI = OpenAITTSService()

    private init() {}

    /// Emits `true` while the cloud (OpenAI) playback is active and `false`
    /// otherwise. Views use this to clear a "buffering…" spinner the moment
    /// audio actually starts playing — the speaker tap → cloud fetch →
    /// decode → AVAudioPlayer.play() round-trip can run 300–1500 ms on
    /// the cold path, and a static speaker icon during that window looks
    /// like a no-op.
    ///
    /// Only mirrors the OpenAI engine. Local AVSpeechSynthesizer (used as
    /// the fallback when OpenAI is unconfigured or for non-English) starts
    /// effectively instantly, so a loading indicator there isn't useful.
    var isSpeakingPublisher: AnyPublisher<Bool, Never> { openAI.isSpeakingPublisher }

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
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * rateMultiplier
        synthesizer.speak(utterance)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        openAI.stopSpeaking()
    }
}
