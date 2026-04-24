import AVFoundation

/// Checks whether iOS has a usable speech voice installed for a given locale.
/// Used by `PracticeSelectionView` to warn the user when TTS will silently
/// fall back to an English voice reading non-English text (garbled audio).
///
/// This helper mirrors the fallback chain in `LocalTTSService.speak`. If you
/// change one, change the other.
enum VoiceAvailability {

    /// True when at least one installed voice can pronounce text in `locale`
    /// — either the locale itself or a documented language-family fallback.
    /// False only when the lookup would end up on an English voice trying to
    /// pronounce non-English text.
    static func hasUsableVoice(for locale: String) -> Bool {
        if AVSpeechSynthesisVoice(language: locale) != nil {
            return true
        }
        // Nepali shares the Devanagari script with Hindi and iOS does not
        // ship a Nepali voice. Hindi is the supported fallback.
        if locale == "ne-NP", AVSpeechSynthesisVoice(language: "hi-IN") != nil {
            return true
        }
        return false
    }
}
