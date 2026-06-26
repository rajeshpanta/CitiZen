import Foundation

/// Everything needed to display a quiz: questions, localization, and audio config.
///
/// `PracticeSelectionView` builds one `QuizConfig` per practice set and passes it
/// to `QuizView`. This replaces the 20 separate Practice view structs.
struct QuizConfig {

    /// The questions for this practice set.
    let questions: [UnifiedQuestion]

    /// Language toggle buttons shown at the top of the quiz.
    /// Empty array means no toggle (English-only quizzes).
    let languageToggles: [LanguageToggle]

    /// Which variant index to show by default when the quiz starts.
    /// 0 for English-only quizzes; typically the target language index for bilingual.
    let defaultVariantIndex: Int

    /// Returns the `QuizStrings` (localized labels) for a given variant index.
    let stringsForVariant: (Int) -> QuizStrings

    /// Returns the TTS/STT locale code for a given variant index (e.g. "en-US", "es-ES").
    let localeForVariant: (Int) -> String

    /// Returns whether STT should prefer on-device recognition for a given variant index.
    let offlineForVariant: (Int) -> Bool

    /// Delay (seconds) between speaking the question text and saying "Your options are:".
    /// English uses 2.0; all other languages use 1.5.
    let questionToOptionsDelay: TimeInterval

    /// When non-nil, the quiz starts in interview mode with this many correct answers
    /// required to pass. QuizView calls `startMockInterview(from:questionCount:requiredCorrect:)`
    /// instead of `startQuiz()`, giving the same early-pass / early-fail logic as the real
    /// USCIS interview. The 100-question track sets this to 6 (6/10 = USCIS pass threshold).
    /// Nil (default) = standard practice mode (4-mistake limit).
    var requiredCorrect: Int? = nil

    /// One button in the language toggle bar.
    struct LanguageToggle {
        let label: String       // e.g. "🇺🇸 English", "🇳🇵 नेपाली"
        let variantIndex: Int   // which variant this button selects
    }
}

// MARK: - Convenience factories

extension QuizConfig {

    /// English-only quiz (no language toggle).
    static func english(questions: [UnifiedQuestion]) -> QuizConfig {
        QuizConfig(
            questions:              questions,
            languageToggles:        [],
            defaultVariantIndex:    0,
            stringsForVariant:      { _ in .english },
            localeForVariant:       { _ in "en-US" },
            offlineForVariant:      { _ in true },
            questionToOptionsDelay: 2.0
        )
    }

    /// English + Nepali bilingual quiz.
    static func nepali(questions: [UnifiedQuestion]) -> QuizConfig {
        QuizConfig(
            questions:              questions,
            languageToggles: [
                LanguageToggle(label: "🇺🇸 English", variantIndex: 0),
                LanguageToggle(label: "🇳🇵 नेपाली",  variantIndex: 1)
            ],
            defaultVariantIndex:    1,
            stringsForVariant:      { $0 == 0 ? .englishBilingual : .nepali },
            localeForVariant:       { $0 == 0 ? "en-US" : "ne-NP" },
            // Prefer on-device STT for both variants. Nepali falls back to Hindi
            // inside LocalSTTService. If the user hasn't downloaded the on-device
            // pack, iOS gracefully degrades to streaming (see LocalSTTService:79).
            offlineForVariant:      { _ in true },
            questionToOptionsDelay: 1.5
        )
    }

    /// English + Spanish bilingual quiz.
    static func spanish(questions: [UnifiedQuestion]) -> QuizConfig {
        QuizConfig(
            questions:              questions,
            languageToggles: [
                LanguageToggle(label: "🇺🇸 English", variantIndex: 0),
                LanguageToggle(label: "🇪🇸 Español", variantIndex: 1)
            ],
            defaultVariantIndex:    1,
            stringsForVariant:      { $0 == 0 ? .englishBilingual : .spanish },
            localeForVariant:       { $0 == 0 ? "en-US" : AppLanguage.spanish.rawValue },
            // Prefer on-device STT for both variants. Safe fallback to streaming
            // if the user hasn't downloaded the Spanish on-device pack.
            offlineForVariant:      { _ in true },
            questionToOptionsDelay: 1.5
        )
    }

    /// Review Mistakes quiz using the same config style as the given language.
    static func reviewMistakes(questions: [UnifiedQuestion], language: AppLanguage) -> QuizConfig {
        switch language {
        case .english: return .english(questions: questions)
        case .nepali:  return .nepali(questions: questions)
        case .spanish: return .spanish(questions: questions)
        case .chinese: return .chinese(questions: questions)
        }
    }

    // MARK: - 100-question track (interview mode: 6/10 to pass)

    /// English-only interview-mode quiz for the 100-question track.
    /// Uses the same TTS/STT config as `english(questions:)` but starts in
    /// mock-interview mode: 10 questions, 6/10 to pass (matches the real USCIS interview).
    static func english100(questions: [UnifiedQuestion]) -> QuizConfig {
        var config = english(questions: questions)
        config.requiredCorrect = 6
        return config
    }

    /// English + Nepali bilingual interview-mode quiz for the 100-question track.
    static func nepali100(questions: [UnifiedQuestion]) -> QuizConfig {
        var config = nepali(questions: questions)
        config.requiredCorrect = 6
        return config
    }

    /// English + Spanish bilingual interview-mode quiz for the 100-question track.
    static func spanish100(questions: [UnifiedQuestion]) -> QuizConfig {
        var config = spanish(questions: questions)
        config.requiredCorrect = 6
        return config
    }

    /// English + Chinese trilingual interview-mode quiz for the 100-question track.
    static func chinese100(questions: [UnifiedQuestion]) -> QuizConfig {
        var config = chinese(questions: questions)
        config.requiredCorrect = 6
        return config
    }

    /// Review mistakes for the 100-question track.
    /// Uses practice mode (4-mistake limit), NOT interview mode, because the
    /// review set is always fewer than 10 questions. Applying requiredCorrect=6
    /// to a 5-question set makes maxMistakes = 0, which would fail the quiz
    /// immediately after the first answer (incorrectAnswers=0 >= maxMistakes=0).
    static func reviewMistakes100(questions: [UnifiedQuestion], language: AppLanguage) -> QuizConfig {
        switch language {
        case .english: return .english(questions: questions)
        case .nepali:  return .nepali(questions: questions)
        case .spanish: return .spanish(questions: questions)
        case .chinese: return .chinese(questions: questions)
        }
    }

    /// English + Chinese Simplified + Chinese Traditional trilingual quiz.
    static func chinese(questions: [UnifiedQuestion]) -> QuizConfig {
        QuizConfig(
            questions:              questions,
            languageToggles: [
                LanguageToggle(label: "🇺🇸 English", variantIndex: 0),
                LanguageToggle(label: "🇨🇳 简体",     variantIndex: 1),
                LanguageToggle(label: "🇹🇼 繁體",     variantIndex: 2)
            ],
            defaultVariantIndex:    1,
            stringsForVariant:      { idx in
                switch idx {
                case 0:  return .englishBilingual
                case 2:  return .chineseTraditional
                default: return .chineseSimplified
                }
            },
            localeForVariant:       { idx in
                switch idx {
                case 2:  return "zh-TW"
                case 1:  return "zh-CN"
                default: return "en-US"
                }
            },
            offlineForVariant:      { _ in true },         // always offline for Chinese
            questionToOptionsDelay: 1.5
        )
    }
}
