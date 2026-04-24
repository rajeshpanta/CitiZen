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
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: languageCode)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * rateMultiplier
        synthesizer.speak(utterance)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
