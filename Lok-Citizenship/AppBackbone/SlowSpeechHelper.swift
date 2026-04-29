import Foundation
import AVFoundation

/// Shared AVSpeechSynthesizer used by the Reading/Writing practice screens.
///
/// These screens need slower-than-default speech rates (~0.8–0.85×) as an ESL aid,
/// and the `TextToSpeechService` protocol used elsewhere in the app doesn't expose
/// a rate parameter. Rather than have four views each instantiate their own
/// `AVSpeechSynthesizer`, they all call through this single shared helper:
///
/// - Memory: one synthesizer instance app-wide (for practice screens).
/// - Natural "stop previous speech" behavior — speaking a new sentence automatically
///   stops the current one, since `synthesizer.speak` on an active AVSpeechSynthesizer
///   queues by default, and `stopSpeaking(at: .immediate)` is called first here.
/// - Rate is passed per-call so each screen keeps its custom pacing.
///
/// Not to be used for Mock Interview / Practice Quiz — those route through the
/// `TextToSpeechService` protocol so they can transparently fall through to the
/// OpenAI nova voice (when the proxy is wired up later).
final class SlowSpeechHelper {

    static let shared = SlowSpeechHelper()

    private let synthesizer = AVSpeechSynthesizer()

    private init() {}

    /// Speak `text` at the given rate multiplier (1.0 = default speech rate).
    /// Any currently-playing speech is interrupted first.
    func speak(_ text: String,
               rateMultiplier: Float = 0.85,
               languageCode: String = "en-US") {
        synthesizer.stopSpeaking(at: .immediate)

        // Self-heal the audio session before speaking. `LocalSTTService`
        // deactivates the session with `.notifyOthersOnDeactivation` after
        // STT, so the next `synthesizer.speak()` would queue onto an
        // inactive session and fail silently. Use the central helper
        // (same `.playAndRecord` config as every other audio path) so we
        // don't churn the category between Reading practice and Mock
        // Interview / Quiz / Audio-Only — category transitions on a
        // live session are flaky on real devices, and the previous
        // `.playback` config here was the source of that churn.
        AudioSessionPrewarmer.configureSession()

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * rateMultiplier
        synthesizer.speak(utterance)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
