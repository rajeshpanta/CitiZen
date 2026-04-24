import Foundation

/// Localized labels for non-quiz UI (selection screen, mock interview, etc.).
/// `QuizStrings` handles labels inside the quiz itself.
struct UIStrings {

    // MARK: - Practice selection

    let navPracticeSelection: String
    let pickPractice: String
    let mockInterview: String
    let mockSubtitlePro: String
    let mockSubtitleFree: String
    let mockSubtitleLocked: String
    let examReadiness: String
    /// printf-style: "%d/%d mastered · %d%% ready" — 3 ints (mastered, total, pct)
    let examReadinessSubtitleFormat: String
    let reviewMistakes: String
    /// printf-style: "%d questions due for review"
    let reviewMistakesSubtitleFormat: String
    let reviewMistakesEmpty: String
    let practiceLevels: String
    let readingWriting: String
    let handsFree: String
    let readingPractice: String
    let readingPracticeSubtitle: String
    let writingPractice: String
    let writingPracticeSubtitle: String
    let unlockWithPro: String
    let audioOnly: String
    let audioOnlySubtitle: String
    let levelEasy: String
    let levelMedium: String
    let levelHard: String
    let levelAdvanced: String
    let levelExpert: String
    /// printf-style: "%d days until your interview"
    let daysUntilInterviewFormat: String

    // MARK: - Mock interview

    let navMockInterview: String
    let mockHeadline: String
    let mockTagline: String
    /// printf-style: "%d questions"
    let mockRowQuestionsFormat: String
    let mockRowQuestionsSub: String
    /// printf-style: "%d correct to pass"
    let mockRowPassFormat: String
    let mockRowPassSub: String
    let mockRowVoice: String
    let mockRowVoiceSub: String
    let startInterview: String

    let interviewQuestionLabel: String     // "QUESTION"
    let interviewStatusReading: String     // "Reading question…"
    let interviewStatusListening: String   // "Listening…"
    let interviewStatusNext: String        // "Next question…"
    /// printf-style: "Need %d"
    let interviewNeedFormat: String
    let interviewOrTap: String             // "OR TAP YOUR ANSWER"
    let interviewTapMic: String            // "Tap mic to speak"
    let interviewListening: String         // "Listening…" (in mic dock)
    let interviewTapAgain: String          // "Tap again to stop"
    let interviewAnswerOutLoud: String     // "Answer the question out loud"
    let interviewCorrect: String           // "Correct!"
    let interviewWrong: String             // "Wrong"
    let interviewMatching: String          // "Matching answer…"
    let interviewDidntHear: String         // "Didn't catch that"
    let interviewRetry: String             // "Try again"
    let interviewSkip: String              // "Skip"
    let interviewReplay: String            // "Replay"
    let interviewNextQuestion: String      // "Next Question"
    let interviewCorrectAnswerLabel: String // "Correct answer"

    let resultPassed: String               // "PASSED"
    let resultFailed: String               // "FAILED"
    /// printf-style: "%d of %d correct"
    let resultOfCorrectFormat: String
    let resultCorrect: String              // "Correct"
    let resultWrong: String                // "Wrong"
    let resultScore: String                // "Score"
    let resultRequiredToPass: String       // "Required to pass"
    let resultLifetimeStats: String        // "LIFETIME STATS"
    let resultAnswered: String             // "Answered"
    let resultAccuracy: String             // "Accuracy"
    let resultStreak: String               // "Streak"
    let resultShareResult: String          // "Share Result"
    let resultTryAgain: String             // "Try Again"
    let resultDone: String                 // "Done"
    let resultReviewHeader: String         // "Question review"
    let resultReviewYouAnswered: String    // "Your answer:"
    let resultReviewCorrectAnswer: String  // "Correct answer:"
    let resultReviewNoAnswer: String       // "No answer"

    // MARK: - Onboarding

    let onboardingIntroHeadline: String      // "Pass your USCIS interview"
    let onboardingIntroTagline: String       // "Built for voice, for your language"
    let onboardingFeatureVoice: String       // "Voice-first practice"
    let onboardingFeatureVoiceSub: String    // "Hear questions, speak answers"
    let onboardingFeatureLanguage: String    // "4 languages"
    let onboardingFeatureLanguageSub: String // "English, Spanish, Nepali, Chinese"
    let onboardingFeatureMock: String        // "Real test simulation"
    let onboardingFeatureMockSub: String     // "10-question mock interview"
    let onboardingContinue: String           // "Continue"
    let onboardingHearSample: String         // "Hear a sample"
    /// A short sentence used for the TTS demo button in onboarding.
    let onboardingSampleText: String
    let notificationsTitle: String           // "Stay on track"
    let notificationsSubtitle: String        // "Daily reminders keep your streak alive"
    let notificationsEnable: String          // "Enable Daily Reminders"
    let notificationsSkip: String            // "Not now"
    /// "Start at Level %d" — placement recommendation button label
    let onboardingStartAtLevelFormat: String
    /// "Recommended" — small badge on recommended practice level card
    let recommendedBadge: String

    // MARK: - Paywall

    let paywallHeadlineDefault: String
    let paywallHeadlineLockedLevel: String
    let paywallHeadlineMockInterview: String
    let paywallSubheadlineDefault: String
    let paywallSubheadlineLockedLevel: String
    let paywallSubheadlineMockInterview: String
    let paywallFeaturesDefault: [String]
    let paywallFeaturesLockedLevel: [String]
    let paywallFeaturesMockInterview: [String]
    let paywallLifetime: String
    let paywallLifetimeSubtitle: String
    let paywallMonthly: String
    /// "3-day free trial, then %@/mo" — %@ is the monthly price.
    let paywallMonthlySubtitleFormat: String
    let paywallFree: String
    let paywallBestValue: String
    let paywall3DaysFree: String
    let paywallProcessing: String
    let paywallStartFreeTrial: String
    let paywallContinue: String
    let paywallLoadingPricing: String
    let paywallPricingUnavailable: String
    let paywallTryAgain: String
    let paywallCostFilingFee: String
    let paywallCostAttorney: String
    let paywallCostAppBrand: String
    /// "A %@/month subscription after 3-day free trial..." — %@ is the monthly price.
    let paywallDisclosureFormat: String
    let paywallPurchaseIncomplete: String
    let paywallPurchaseFailed: String
    let paywallVerificationIssue: String
    let paywallDismiss: String
    let paywallRestore: String
    let paywallPrivacy: String
    let paywallTerms: String
    /// Body text shown in the "Verification Issue" alert when receipt verification fails.
    let paywallErrorVerificationFailed: String

    // MARK: - Audio-only spoken feedback

    /// Spoken when the user answers correctly (hands-free mode).
    let audioFeedbackCorrect: String
    /// "The answer is %@" — %@ is the correct option text.
    let audioFeedbackTheAnswerIsFormat: String

    // MARK: - Reading & Writing practice (USCIS English reading/writing test)

    /// "Card %d of %d"
    let practiceCardCountFormat: String
    let readingListenBtn: String
    let readingShowBtn: String
    let readingNextBtn: String
    let writingHeader: String
    let writingPlayAgainBtn: String
    let writingInputPlaceholder: String
    let writingCheckBtn: String
    let writingCorrectLabel: String
    let writingIncorrectLabel: String
    let writingCorrectAnswerLabel: String
    let writingNextBtn: String
    /// "%d of %d words correct" — score summary shown on writing feedback.
    let writingWordsCorrectFormat: String
    /// 8 category-label fields used on the pill badge of each vocab card.
    let vocabCategoryPeople: String
    let vocabCategoryCivics: String
    let vocabCategoryPlaces: String
    let vocabCategoryHolidays: String
    let vocabCategoryMonths: String
    let vocabCategoryQuestionWords: String
    let vocabCategoryVerbs: String
    let vocabCategoryOther: String

    // MARK: - Test Mode (Reading / Writing)

    let testModeLearn: String
    let testModeTest: String
    let testModeReadingIntro: String
    /// "Sentence %d of %d"
    let testModeSentenceOfFormat: String
    let testModeTapToStart: String
    let testModeStopBtn: String
    let testModeRecording: String
    let testModeWeHeard: String
    let testModeRestartBtn: String
    let testModeSessionPassed: String
    let testModeSessionFailed: String
    /// "You passed %d of %d sentences"
    let testModeScoreFormat: String
    let testModeMicPermission: String
    let testModeContinueBtn: String
    /// Shown when the user taps "Done" without having spoken — no audio was captured.
    let testModeNoSpeechHeard: String
    /// M2: title + body + buttons for the "end test in progress" confirmation alert
    /// that fires when user taps Back during an active 3-sentence session.
    let testModeExitConfirmTitle: String
    let testModeExitConfirmMessage: String
    let testModeExitConfirmYes: String
    let testModeExitConfirmNo: String

    // MARK: - Accessibility labels (N2: VoiceOver-readable labels for icon-only buttons)

    let a11yStartRecording: String
    let a11yStopRecording: String
    let a11yClose: String
    let a11yBack: String

    /// F7: reminds the user that the USCIS writing test is evaluated in English.
    /// Rendered in the user's app language so they understand the requirement.
    let writingEnglishDisclaimer: String
    /// Reminds the user that Mock Interview is conducted in English, matching the
    /// real USCIS test. Shown on the ready screen in the user's app language so
    /// non-English users understand why the questions will be read in English.
    let mockInterviewEnglishDisclaimer: String
    /// Banner shown on Practice Selection when the user's chosen language has
    /// no voice pack installed on the device. TTS would otherwise silently
    /// fall back to an English voice reading non-English text.
    let voicePackMissingMessage: String
    /// Shown below time-sensitive question text (President, VP, Speaker, Chief
    /// Justice) to remind the user that the correct answer depends on current
    /// officeholders and can change. Avoids the "your app taught me the wrong
    /// answer and I failed USCIS" refund-review class.
    let questionTimeSensitiveNote: String
    /// F3: shown when SFSpeechRecognizer reports `.restricted` (recognizer itself
    /// not available — e.g. language pack missing). Distinct from mic-permission denial.
    let testModeSpeechUnavailable: String

    // MARK: - Exam Readiness (F6: Reading + Writing test progress)

    let readinessReadingTitle: String
    let readinessWritingTitle: String
    /// printf-style 3-arg: "%d of %d sessions passed · %d%% ready"
    let readinessSessionsFormat: String
    let readinessNotStarted: String

    // MARK: - Nav titles for secondary screens

    let navInterviewChecklist: String
    let navExamReadiness: String
    let navReviewMistakes: String
    let navReadingPractice: String
    let navWritingPractice: String
    let navAudioOnly: String
    let navSettings: String

    // MARK: - Readiness dashboard

    let readinessProgressByLevel: String
    let readinessReadyLabel: String
    /// printf-style 2-arg: "%d of %d questions mastered"
    let readinessMasteredFormat: String
    let readinessStatMastered: String
    let readinessStatLearning: String
    let readinessStatNew: String
    let readinessCurrentStreak: String
    let readinessBestStreak: String
    let readinessAccuracy: String

    // MARK: - Audio-only mode (screen copy)

    let audioOnlyStatusListeningToQuestion: String
    let audioOnlyStatusSpeakYourAnswer: String
    let audioOnlyStatusProcessing: String
    let audioOnlyStopBtn: String
    let audioOnlySessionComplete: String
    /// printf 3-arg: "%d/%d · %d correct" — attempted/total · correct
    let audioOnlyProgressFormat: String
    /// printf 3-arg: "%d of %d correct (%d%%)"
    let audioOnlyFinalScoreFormat: String

    // MARK: - Quiz voice panel + lifetime stats

    let quizTapToSpeakHint: String
    let quizMicListening: String
    let quizMicPressToRetry: String
    let quizLifetimeStats: String
    let quizStatAnswered: String
    let quizStatStreak: String

    // MARK: - Settings

    let settingsRemindersHeader: String
    let settingsDailyReminder: String
    let settingsReminderTime: String
    let settingsEnableNotifications: String
    let settingsRemindersCaption: String
    let settingsInterviewHeader: String
    let settingsHasScheduledInterview: String
    let settingsInterviewDate: String
    let settingsSubscriptionHeader: String
    let settingsProActive: String
    let settingsRestorePurchases: String
    let settingsLegalHeader: String
    let settingsPrivacyPolicy: String
    let settingsTermsOfUse: String
    let settingsAboutHeader: String
    let settingsVersionLabel: String

    // MARK: - App intro

    let appTagline: String
    let getStartedBtn: String
}

// MARK: - Factories

extension UIStrings {

    static func forLanguage(_ language: AppLanguage) -> UIStrings {
        switch language {
        case .english: return .english
        case .spanish: return .spanish
        case .nepali:  return .nepali
        case .chinese: return .chinese
        }
    }

    /// Pick the UIStrings bundle matching an STT/TTS locale code (e.g. "en-US", "es-ES",
    /// "ne-NP", "zh-CN"). Used by `VoiceQuizController` which operates on locale codes,
    /// not `AppLanguage` values. Unknown codes fall back to English.
    static func forLocaleCode(_ code: String) -> UIStrings {
        switch code {
        case "ne-NP":          return .nepali
        case "es-ES":          return .spanish
        case "zh-CN", "zh-TW": return .chinese
        default:               return .english
        }
    }

    /// Translate a raw category label from `ReadingWritingContent` (always stored in English,
    /// since the content itself is English USCIS vocabulary) into the user's language.
    /// Unknown categories fall through unchanged.
    func localizedCategory(_ raw: String) -> String {
        switch raw {
        case "People":         return vocabCategoryPeople
        case "Civics":         return vocabCategoryCivics
        case "Places":         return vocabCategoryPlaces
        case "Holidays":       return vocabCategoryHolidays
        case "Months":         return vocabCategoryMonths
        case "Question Words": return vocabCategoryQuestionWords
        case "Verbs":          return vocabCategoryVerbs
        case "Other":          return vocabCategoryOther
        default:               return raw
        }
    }

    // ─────────────────────────────────────────────────────────────
    // English
    // ─────────────────────────────────────────────────────────────

    static let english = UIStrings(
        navPracticeSelection: "Practice Selection",
        pickPractice: "Pick A Practice Set 👇🏻",
        mockInterview: "Mock Interview",
        mockSubtitlePro: "Simulate the real USCIS test",
        mockSubtitleFree: "Try your first mock interview free",
        mockSubtitleLocked: "Unlock unlimited mock interviews",
        examReadiness: "Exam Readiness",
        examReadinessSubtitleFormat: "%d/%d mastered · %d%% ready",
        reviewMistakes: "Review Mistakes",
        reviewMistakesSubtitleFormat: "%d questions due for review",
        reviewMistakesEmpty: "Complete some practice first",
        practiceLevels: "Practice Levels",
        readingWriting: "Reading & Writing",
        handsFree: "Hands-Free",
        readingPractice: "Reading Practice",
        readingPracticeSubtitle: "Practice USCIS reading vocabulary",
        writingPractice: "Writing Practice",
        writingPracticeSubtitle: "Listen and type USCIS sentences",
        unlockWithPro: "Unlock with Pro",
        audioOnly: "Audio-Only Mode",
        audioOnlySubtitle: "Study hands-free with voice",
        levelEasy: "Easy",
        levelMedium: "Medium",
        levelHard: "Hard",
        levelAdvanced: "Advanced",
        levelExpert: "Expert",
        daysUntilInterviewFormat: "%d days until your interview",

        navMockInterview: "Mock Interview",
        mockHeadline: "Mock Interview",
        mockTagline: "Simulate the real USCIS civics test",
        mockRowQuestionsFormat: "%d questions",
        mockRowQuestionsSub: "Pulled from the full USCIS pool",
        mockRowPassFormat: "%d correct to pass",
        mockRowPassSub: "Matches USCIS passing threshold",
        mockRowVoice: "Answer by voice",
        mockRowVoiceSub: "Speak your answer, just like the real test",
        startInterview: "Start Interview",

        interviewQuestionLabel: "QUESTION",
        interviewStatusReading: "Reading question…",
        interviewStatusListening: "Listening…",
        interviewStatusNext: "Next question…",
        interviewNeedFormat: "Need %d",
        interviewOrTap: "OR TAP YOUR ANSWER",
        interviewTapMic: "Tap mic to speak",
        interviewListening: "Listening…",
        interviewTapAgain: "Tap again to stop",
        interviewAnswerOutLoud: "Answer the question out loud",
        interviewCorrect: "Correct!",
        interviewWrong: "Wrong",
        interviewMatching: "Matching answer…",
        interviewDidntHear: "Didn't catch that",
        interviewRetry: "Try again",
        interviewSkip: "Skip",
        interviewReplay: "Replay",
        interviewNextQuestion: "Next Question",
        interviewCorrectAnswerLabel: "Correct answer",

        resultPassed: "PASSED",
        resultFailed: "FAILED",
        resultOfCorrectFormat: "%d of %d correct",
        resultCorrect: "Correct",
        resultWrong: "Wrong",
        resultScore: "Score",
        resultRequiredToPass: "Required to pass",
        resultLifetimeStats: "LIFETIME STATS",
        resultAnswered: "Answered",
        resultAccuracy: "Accuracy",
        resultStreak: "Streak",
        resultShareResult: "Share Result",
        resultTryAgain: "Try Again",
        resultDone: "Done",
        resultReviewHeader: "Question review",
        resultReviewYouAnswered: "Your answer:",
        resultReviewCorrectAnswer: "Correct answer:",
        resultReviewNoAnswer: "No answer",

        onboardingIntroHeadline: "Pass your USCIS interview",
        onboardingIntroTagline: "Built for voice, built for your language",
        onboardingFeatureVoice: "Voice-first practice",
        onboardingFeatureVoiceSub: "Hear questions, speak answers",
        onboardingFeatureLanguage: "4 languages",
        onboardingFeatureLanguageSub: "English, Spanish, Nepali, Chinese",
        onboardingFeatureMock: "Real test simulation",
        onboardingFeatureMockSub: "10-question mock interview",
        onboardingContinue: "Continue",
        onboardingHearSample: "Hear a sample",
        onboardingSampleText: "What is the capital of the United States?",
        notificationsTitle: "Stay on track",
        notificationsSubtitle: "Daily reminders keep your streak alive",
        notificationsEnable: "Enable Daily Reminders",
        notificationsSkip: "Not now",
        onboardingStartAtLevelFormat: "Start at Level %d",
        recommendedBadge: "Recommended",

        paywallHeadlineDefault: "Pass Your Citizenship\nInterview",
        paywallHeadlineLockedLevel: "Ready for Harder\nQuestions?",
        paywallHeadlineMockInterview: "Simulate the Real\nUSCIS Interview",
        paywallSubheadlineDefault: "Get full access to every feature and pass with confidence.",
        paywallSubheadlineLockedLevel: "Harder questions prepare you for the real test. Unlock all 5 levels.",
        paywallSubheadlineMockInterview: "You've tried your free interview. Unlock unlimited attempts to keep improving.",
        paywallFeaturesDefault: [
            "All 5 practice levels",
            "Unlimited mock interviews",
            "Master hard & expert questions",
            "Full progress tracking"
        ],
        paywallFeaturesLockedLevel: [
            "Advanced & Expert difficulty levels",
            "Unlimited mock interview practice",
            "Master the hardest questions first",
            "Track your improvement over time"
        ],
        paywallFeaturesMockInterview: [
            "Unlimited mock interview attempts",
            "Advanced & Expert practice levels",
            "Voice-powered interview simulation",
            "Track scores, streaks, and progress"
        ],
        paywallLifetime: "Lifetime",
        paywallLifetimeSubtitle: "One payment, forever yours",
        paywallMonthly: "Monthly",
        paywallMonthlySubtitleFormat: "3-day free trial, then %@/mo",
        paywallFree: "FREE",
        paywallBestValue: "BEST VALUE",
        paywall3DaysFree: "3 DAYS FREE",
        paywallProcessing: "Processing…",
        paywallStartFreeTrial: "Start Free Trial",
        paywallContinue: "Continue",
        paywallLoadingPricing: "Loading pricing…",
        paywallPricingUnavailable: "Pricing is temporarily unavailable.",
        paywallTryAgain: "Try Again",
        paywallCostFilingFee: "USCIS filing fee",
        paywallCostAttorney: "Immigration attorney",
        paywallCostAppBrand: "CitiZen Pro",
        paywallDisclosureFormat: "A %@/month subscription after 3-day free trial. Payment will be charged to your Apple ID account at the confirmation of purchase. Subscription automatically renews unless auto-renew is turned off at least 24 hours before the end of the current period. You can manage and cancel your subscription in your Apple ID Account Settings.",
        paywallPurchaseIncomplete: "Purchase was not completed.",
        paywallPurchaseFailed: "Purchase failed. Please try again.",
        paywallVerificationIssue: "Verification Issue",
        paywallDismiss: "Dismiss",
        paywallRestore: "Restore Purchases",
        paywallPrivacy: "Privacy Policy",
        paywallTerms: "Terms of Use",
        paywallErrorVerificationFailed: "Purchase could not be verified. Please try restoring purchases.",

        audioFeedbackCorrect: "Correct",
        audioFeedbackTheAnswerIsFormat: "The answer is %@",

        practiceCardCountFormat: "Card %d of %d",
        readingListenBtn: "Listen",
        readingShowBtn: "Show",
        readingNextBtn: "Next",
        writingHeader: "Listen and type the sentence",
        writingPlayAgainBtn: "Play Again",
        writingInputPlaceholder: "Type what you hear…",
        writingCheckBtn: "Check",
        writingCorrectLabel: "Correct!",
        writingIncorrectLabel: "Not quite",
        writingCorrectAnswerLabel: "Correct answer:",
        writingNextBtn: "Next",
        writingWordsCorrectFormat: "%d of %d words correct",
        vocabCategoryPeople: "People",
        vocabCategoryCivics: "Civics",
        vocabCategoryPlaces: "Places",
        vocabCategoryHolidays: "Holidays",
        vocabCategoryMonths: "Months",
        vocabCategoryQuestionWords: "Question Words",
        vocabCategoryVerbs: "Verbs",
        vocabCategoryOther: "Other",

        testModeLearn: "Learn",
        testModeTest: "Test",
        testModeReadingIntro: "Read each sentence aloud. You'll get 3 sentences — pass 1 to pass the test.",
        testModeSentenceOfFormat: "Sentence %d of %d",
        testModeTapToStart: "Tap the mic when you're ready to read aloud",
        testModeStopBtn: "Done",
        testModeRecording: "Listening…",
        testModeWeHeard: "We heard:",
        testModeRestartBtn: "Try Again",
        testModeSessionPassed: "You passed!",
        testModeSessionFailed: "Not yet — keep practicing.",
        testModeScoreFormat: "You passed %d of %d sentences",
        testModeMicPermission: "Please allow microphone access in Settings to use Test Mode.",
        testModeContinueBtn: "Continue",
        testModeNoSpeechHeard: "We didn't hear anything — tap the mic and try again.",
        testModeExitConfirmTitle: "End test?",
        testModeExitConfirmMessage: "You'll lose your progress on this 3-sentence session.",
        testModeExitConfirmYes: "End test",
        testModeExitConfirmNo: "Keep practicing",

        a11yStartRecording: "Start recording",
        a11yStopRecording: "Stop recording",
        a11yClose: "Close",
        a11yBack: "Back",

        writingEnglishDisclaimer: "The USCIS writing test is in English. Type in English for the best practice.",
        mockInterviewEnglishDisclaimer: "The real USCIS interview is conducted in English. This mock is English-only so your practice matches the real test.",
        voicePackMissingMessage: "This language's voice pack isn't installed. For clear audio, add it in Settings → Accessibility → Spoken Content → Voices.",
        questionTimeSensitiveNote: "Answers change over time. Verify the current officeholder at uscis.gov/citizenship before your interview.",
        testModeSpeechUnavailable: "Speech recognition isn't available on this device. In iOS Settings → General → Keyboard, make sure an English keyboard is added and try again.",

        readinessReadingTitle: "English Reading Test",
        readinessWritingTitle: "English Writing Test",
        readinessSessionsFormat: "%d of %d sessions passed · %d%% ready",
        readinessNotStarted: "Not started yet",

        navInterviewChecklist: "Interview Checklist",
        navExamReadiness: "Exam Readiness",
        navReviewMistakes: "Review Mistakes",
        navReadingPractice: "Reading Practice",
        navWritingPractice: "Writing Practice",
        navAudioOnly: "Audio-Only",
        navSettings: "Settings",

        readinessProgressByLevel: "Progress by Level",
        readinessReadyLabel: "Ready",
        readinessMasteredFormat: "%d of %d questions mastered",
        readinessStatMastered: "Mastered",
        readinessStatLearning: "Learning",
        readinessStatNew: "New",
        readinessCurrentStreak: "Current Streak",
        readinessBestStreak: "Best Streak",
        readinessAccuracy: "Accuracy",

        audioOnlyStatusListeningToQuestion: "Listening to question…",
        audioOnlyStatusSpeakYourAnswer: "Speak your answer",
        audioOnlyStatusProcessing: "Processing…",
        audioOnlyStopBtn: "Stop",
        audioOnlySessionComplete: "Session Complete",
        audioOnlyProgressFormat: "%d/%d · %d correct",
        audioOnlyFinalScoreFormat: "%d of %d correct (%d%%)",

        quizTapToSpeakHint: "Tap to speak",
        quizMicListening: "Listening…",
        quizMicPressToRetry: "Press the mic to try again",
        quizLifetimeStats: "Lifetime Stats",
        quizStatAnswered: "Answered",
        quizStatStreak: "Streak",

        settingsRemindersHeader: "Study Reminders",
        settingsDailyReminder: "Daily Reminder",
        settingsReminderTime: "Reminder Time",
        settingsEnableNotifications: "Enable Notifications",
        settingsRemindersCaption: "Get daily reminders to study and streak alerts.",
        settingsInterviewHeader: "Interview",
        settingsHasScheduledInterview: "I have a scheduled interview",
        settingsInterviewDate: "Interview Date",
        settingsSubscriptionHeader: "Subscription",
        settingsProActive: "Active",
        settingsRestorePurchases: "Restore Purchases",
        settingsLegalHeader: "Legal",
        settingsPrivacyPolicy: "Privacy Policy",
        settingsTermsOfUse: "Terms of Use",
        settingsAboutHeader: "About",
        settingsVersionLabel: "Version",

        appTagline: "U.S. Citizenship Test Prep",
        getStartedBtn: "Get Started"
    )

    // ─────────────────────────────────────────────────────────────
    // Spanish
    // ─────────────────────────────────────────────────────────────

    static let spanish = UIStrings(
        navPracticeSelection: "Selección de práctica",
        pickPractice: "Elige tu práctica 👇🏻",
        mockInterview: "Entrevista simulada",
        mockSubtitlePro: "Simula el examen real de USCIS",
        mockSubtitleFree: "Prueba tu primera entrevista gratis",
        mockSubtitleLocked: "Desbloquea entrevistas ilimitadas",
        examReadiness: "Preparación para el examen",
        examReadinessSubtitleFormat: "%d/%d dominadas · %d%% listo",
        reviewMistakes: "Revisar errores",
        reviewMistakesSubtitleFormat: "%d preguntas para repasar",
        reviewMistakesEmpty: "Completa primero algo de práctica",
        practiceLevels: "Niveles de práctica",
        readingWriting: "Lectura y escritura",
        handsFree: "Manos libres",
        readingPractice: "Práctica de lectura",
        readingPracticeSubtitle: "Practica el vocabulario de lectura de USCIS",
        writingPractice: "Práctica de escritura",
        writingPracticeSubtitle: "Escucha y escribe oraciones de USCIS",
        unlockWithPro: "Desbloquear con Pro",
        audioOnly: "Modo solo audio",
        audioOnlySubtitle: "Estudia sin manos con tu voz",
        levelEasy: "Fácil",
        levelMedium: "Medio",
        levelHard: "Difícil",
        levelAdvanced: "Avanzado",
        levelExpert: "Experto",
        daysUntilInterviewFormat: "%d días para tu entrevista",

        navMockInterview: "Entrevista simulada",
        mockHeadline: "Entrevista simulada",
        mockTagline: "Simula el examen real de cívica de USCIS",
        mockRowQuestionsFormat: "%d preguntas",
        mockRowQuestionsSub: "Tomadas del banco completo de USCIS",
        mockRowPassFormat: "%d correctas para aprobar",
        mockRowPassSub: "Coincide con el umbral de USCIS",
        mockRowVoice: "Responde con la voz",
        mockRowVoiceSub: "Di tu respuesta, como en el examen real",
        startInterview: "Comenzar entrevista",

        interviewQuestionLabel: "PREGUNTA",
        interviewStatusReading: "Leyendo la pregunta…",
        interviewStatusListening: "Escuchando…",
        interviewStatusNext: "Siguiente pregunta…",
        interviewNeedFormat: "Necesitas %d",
        interviewOrTap: "O TOCA TU RESPUESTA",
        interviewTapMic: "Toca el micro para hablar",
        interviewListening: "Escuchando…",
        interviewTapAgain: "Toca otra vez para parar",
        interviewAnswerOutLoud: "Responde en voz alta",
        interviewCorrect: "¡Correcto!",
        interviewWrong: "Incorrecto",
        interviewMatching: "Comprobando respuesta…",
        interviewDidntHear: "No te escuché",
        interviewRetry: "Intentar de nuevo",
        interviewSkip: "Saltar",
        interviewReplay: "Repetir",
        interviewNextQuestion: "Siguiente pregunta",
        interviewCorrectAnswerLabel: "Respuesta correcta",

        resultPassed: "APROBADO",
        resultFailed: "NO APROBADO",
        resultOfCorrectFormat: "%d de %d correctas",
        resultCorrect: "Correctas",
        resultWrong: "Incorrectas",
        resultScore: "Puntuación",
        resultRequiredToPass: "Necesarias para aprobar",
        resultLifetimeStats: "ESTADÍSTICAS TOTALES",
        resultAnswered: "Respondidas",
        resultAccuracy: "Precisión",
        resultStreak: "Racha",
        resultShareResult: "Compartir resultado",
        resultTryAgain: "Intentar de nuevo",
        resultDone: "Listo",
        resultReviewHeader: "Revisión de preguntas",
        resultReviewYouAnswered: "Tu respuesta:",
        resultReviewCorrectAnswer: "Respuesta correcta:",
        resultReviewNoAnswer: "Sin respuesta",

        onboardingIntroHeadline: "Aprueba tu entrevista de USCIS",
        onboardingIntroTagline: "Hecho para la voz, hecho para tu idioma",
        onboardingFeatureVoice: "Práctica con voz",
        onboardingFeatureVoiceSub: "Escucha preguntas, responde hablando",
        onboardingFeatureLanguage: "4 idiomas",
        onboardingFeatureLanguageSub: "Inglés, español, nepalí, chino",
        onboardingFeatureMock: "Simulación real del examen",
        onboardingFeatureMockSub: "Entrevista simulada de 10 preguntas",
        onboardingContinue: "Continuar",
        onboardingHearSample: "Escuchar ejemplo",
        onboardingSampleText: "¿Cuál es la capital de los Estados Unidos?",
        notificationsTitle: "Mantente al día",
        notificationsSubtitle: "Los recordatorios diarios mantienen tu racha",
        notificationsEnable: "Activar recordatorios diarios",
        notificationsSkip: "Ahora no",
        onboardingStartAtLevelFormat: "Empezar en el nivel %d",
        recommendedBadge: "Recomendado",

        paywallHeadlineDefault: "Aprueba tu entrevista\nde ciudadanía",
        paywallHeadlineLockedLevel: "¿Listo para preguntas\nmás difíciles?",
        paywallHeadlineMockInterview: "Simula la entrevista\nreal de USCIS",
        paywallSubheadlineDefault: "Accede a todas las funciones y aprueba con confianza.",
        paywallSubheadlineLockedLevel: "Las preguntas difíciles te preparan para el examen real. Desbloquea los 5 niveles.",
        paywallSubheadlineMockInterview: "Ya probaste tu entrevista gratuita. Desbloquea intentos ilimitados para seguir mejorando.",
        paywallFeaturesDefault: [
            "Los 5 niveles de práctica",
            "Entrevistas simuladas ilimitadas",
            "Domina las preguntas difíciles y expertas",
            "Seguimiento completo de progreso"
        ],
        paywallFeaturesLockedLevel: [
            "Niveles avanzado y experto",
            "Práctica ilimitada de entrevista simulada",
            "Domina primero las preguntas más difíciles",
            "Seguimiento de tu mejora a lo largo del tiempo"
        ],
        paywallFeaturesMockInterview: [
            "Intentos ilimitados de entrevista simulada",
            "Niveles avanzado y experto",
            "Simulación de entrevista con voz",
            "Seguimiento de puntuación, rachas y progreso"
        ],
        paywallLifetime: "Compra única",
        paywallLifetimeSubtitle: "Un solo pago, tuyo para siempre",
        paywallMonthly: "Mensual",
        paywallMonthlySubtitleFormat: "3 días de prueba gratis, luego %@/mes",
        paywallFree: "GRATIS",
        paywallBestValue: "MEJOR OFERTA",
        paywall3DaysFree: "3 DÍAS GRATIS",
        paywallProcessing: "Procesando…",
        paywallStartFreeTrial: "Comenzar prueba gratis",
        paywallContinue: "Continuar",
        paywallLoadingPricing: "Cargando precios…",
        paywallPricingUnavailable: "Los precios no están disponibles por ahora.",
        paywallTryAgain: "Reintentar",
        paywallCostFilingFee: "Tarifa de solicitud USCIS",
        paywallCostAttorney: "Abogado de inmigración",
        paywallCostAppBrand: "CitiZen Pro",
        paywallDisclosureFormat: "Una suscripción de %@/mes después de 3 días de prueba gratuita. El pago se cargará a tu cuenta Apple ID al confirmar la compra. La suscripción se renueva automáticamente a menos que se desactive la renovación automática al menos 24 horas antes del final del período actual. Puedes gestionar y cancelar tu suscripción en la configuración de tu cuenta Apple ID.",
        paywallPurchaseIncomplete: "La compra no se completó.",
        paywallPurchaseFailed: "La compra falló. Intenta de nuevo.",
        paywallVerificationIssue: "Problema de verificación",
        paywallDismiss: "Cerrar",
        paywallRestore: "Restaurar compras",
        paywallPrivacy: "Política de privacidad",
        paywallTerms: "Términos de uso",
        paywallErrorVerificationFailed: "No se pudo verificar la compra. Intenta restaurar compras.",

        audioFeedbackCorrect: "Correcto",
        audioFeedbackTheAnswerIsFormat: "La respuesta es %@",

        practiceCardCountFormat: "Tarjeta %d de %d",
        readingListenBtn: "Escuchar",
        readingShowBtn: "Mostrar",
        readingNextBtn: "Siguiente",
        writingHeader: "Escucha y escribe la oración",
        writingPlayAgainBtn: "Reproducir de nuevo",
        writingInputPlaceholder: "Escribe lo que escuchas…",
        writingCheckBtn: "Verificar",
        writingCorrectLabel: "¡Correcto!",
        writingIncorrectLabel: "No exactamente",
        writingCorrectAnswerLabel: "Respuesta correcta:",
        writingNextBtn: "Siguiente",
        writingWordsCorrectFormat: "%d de %d palabras correctas",
        vocabCategoryPeople: "Personas",
        vocabCategoryCivics: "Civismo",
        vocabCategoryPlaces: "Lugares",
        vocabCategoryHolidays: "Feriados",
        vocabCategoryMonths: "Meses",
        vocabCategoryQuestionWords: "Palabras interrogativas",
        vocabCategoryVerbs: "Verbos",
        vocabCategoryOther: "Otro",

        testModeLearn: "Aprender",
        testModeTest: "Prueba",
        testModeReadingIntro: "Lee cada oración en voz alta. Tendrás 3 oraciones — aprobar 1 basta para pasar la prueba.",
        testModeSentenceOfFormat: "Oración %d de %d",
        testModeTapToStart: "Toca el micro cuando estés listo para leer en voz alta",
        testModeStopBtn: "Listo",
        testModeRecording: "Escuchando…",
        testModeWeHeard: "Escuchamos:",
        testModeRestartBtn: "Intentar de nuevo",
        testModeSessionPassed: "¡Aprobaste!",
        testModeSessionFailed: "Aún no — sigue practicando.",
        testModeScoreFormat: "Aprobaste %d de %d oraciones",
        testModeMicPermission: "Permite el acceso al micrófono en Ajustes para usar el modo Prueba.",
        testModeContinueBtn: "Continuar",
        testModeNoSpeechHeard: "No escuchamos nada — toca el micro e inténtalo de nuevo.",
        testModeExitConfirmTitle: "¿Terminar la prueba?",
        testModeExitConfirmMessage: "Perderás tu progreso en esta sesión de 3 oraciones.",
        testModeExitConfirmYes: "Terminar prueba",
        testModeExitConfirmNo: "Seguir practicando",

        a11yStartRecording: "Comenzar grabación",
        a11yStopRecording: "Detener grabación",
        a11yClose: "Cerrar",
        a11yBack: "Atrás",

        writingEnglishDisclaimer: "La prueba de escritura de USCIS es en inglés. Escribe en inglés para una mejor práctica.",
        mockInterviewEnglishDisclaimer: "La entrevista real de USCIS se realiza en inglés. Esta simulación es solo en inglés para que tu práctica coincida con el examen real.",
        voicePackMissingMessage: "No tienes instalada la voz de este idioma. Para un audio claro, agrégala en Ajustes → Accesibilidad → Contenido hablado → Voces.",
        questionTimeSensitiveNote: "Las respuestas cambian con el tiempo. Verifica al funcionario actual en uscis.gov/citizenship antes de tu entrevista.",
        testModeSpeechUnavailable: "El reconocimiento de voz no está disponible en este dispositivo. En Ajustes → General → Teclado, asegúrate de tener un teclado en inglés e inténtalo de nuevo.",

        readinessReadingTitle: "Prueba de lectura en inglés",
        readinessWritingTitle: "Prueba de escritura en inglés",
        readinessSessionsFormat: "%d de %d sesiones aprobadas · %d%% listo",
        readinessNotStarted: "Aún no iniciado",

        navInterviewChecklist: "Lista para la entrevista",
        navExamReadiness: "Preparación para el examen",
        navReviewMistakes: "Revisar errores",
        navReadingPractice: "Práctica de lectura",
        navWritingPractice: "Práctica de escritura",
        navAudioOnly: "Solo audio",
        navSettings: "Ajustes",

        readinessProgressByLevel: "Progreso por nivel",
        readinessReadyLabel: "Listo",
        readinessMasteredFormat: "%d de %d preguntas dominadas",
        readinessStatMastered: "Dominadas",
        readinessStatLearning: "Aprendiendo",
        readinessStatNew: "Nuevas",
        readinessCurrentStreak: "Racha actual",
        readinessBestStreak: "Mejor racha",
        readinessAccuracy: "Precisión",

        audioOnlyStatusListeningToQuestion: "Escuchando la pregunta…",
        audioOnlyStatusSpeakYourAnswer: "Di tu respuesta",
        audioOnlyStatusProcessing: "Procesando…",
        audioOnlyStopBtn: "Detener",
        audioOnlySessionComplete: "Sesión completa",
        audioOnlyProgressFormat: "%d/%d · %d correctas",
        audioOnlyFinalScoreFormat: "%d de %d correctas (%d%%)",

        quizTapToSpeakHint: "Toca para hablar",
        quizMicListening: "Escuchando…",
        quizMicPressToRetry: "Pulsa el micrófono para reintentar",
        quizLifetimeStats: "Estadísticas totales",
        quizStatAnswered: "Respondidas",
        quizStatStreak: "Racha",

        settingsRemindersHeader: "Recordatorios de estudio",
        settingsDailyReminder: "Recordatorio diario",
        settingsReminderTime: "Hora del recordatorio",
        settingsEnableNotifications: "Activar notificaciones",
        settingsRemindersCaption: "Recibe recordatorios diarios para estudiar y alertas de racha.",
        settingsInterviewHeader: "Entrevista",
        settingsHasScheduledInterview: "Tengo una entrevista programada",
        settingsInterviewDate: "Fecha de la entrevista",
        settingsSubscriptionHeader: "Suscripción",
        settingsProActive: "Activa",
        settingsRestorePurchases: "Restaurar compras",
        settingsLegalHeader: "Legal",
        settingsPrivacyPolicy: "Política de privacidad",
        settingsTermsOfUse: "Términos de uso",
        settingsAboutHeader: "Acerca de",
        settingsVersionLabel: "Versión",

        appTagline: "Preparación para el examen de ciudadanía de EE. UU.",
        getStartedBtn: "Comenzar"
    )

    // ─────────────────────────────────────────────────────────────
    // Nepali
    // ─────────────────────────────────────────────────────────────

    static let nepali = UIStrings(
        navPracticeSelection: "अभ्यास छनोट",
        pickPractice: "आफ्नो अभ्यास छान्नुहोस् 👇🏻",
        mockInterview: "नक्कली अन्तर्वार्ता",
        mockSubtitlePro: "वास्तविक USCIS परीक्षाको अनुकरण",
        mockSubtitleFree: "पहिलो नक्कली अन्तर्वार्ता निःशुल्क",
        mockSubtitleLocked: "असीमित नक्कली अन्तर्वार्ता अनलक गर्नुहोस्",
        examReadiness: "परीक्षा तयारी",
        examReadinessSubtitleFormat: "%d/%d सिकिएको · %d%% तयार",
        reviewMistakes: "गल्तीहरू समीक्षा",
        reviewMistakesSubtitleFormat: "%d प्रश्नहरू समीक्षाका लागि",
        reviewMistakesEmpty: "पहिले केही अभ्यास गर्नुहोस्",
        practiceLevels: "अभ्यास स्तरहरू",
        readingWriting: "पढाइ र लेखाइ",
        handsFree: "हात-मुक्त",
        readingPractice: "पढाइ अभ्यास",
        readingPracticeSubtitle: "USCIS पढाइ शब्दावली अभ्यास",
        writingPractice: "लेखाइ अभ्यास",
        writingPracticeSubtitle: "USCIS वाक्य सुन्नुहोस् र टाइप गर्नुहोस्",
        unlockWithPro: "Pro सँग अनलक",
        audioOnly: "अडियो-मात्र मोड",
        audioOnlySubtitle: "आवाजले हात-मुक्त अध्ययन",
        levelEasy: "सजिलो",
        levelMedium: "मध्यम",
        levelHard: "कठिन",
        levelAdvanced: "उन्नत",
        levelExpert: "विज्ञ",
        daysUntilInterviewFormat: "तपाईंको अन्तर्वार्तामा %d दिन बाँकी",

        navMockInterview: "नक्कली अन्तर्वार्ता",
        mockHeadline: "नक्कली अन्तर्वार्ता",
        mockTagline: "वास्तविक USCIS नागरिक परीक्षाको अनुकरण",
        mockRowQuestionsFormat: "%d प्रश्नहरू",
        mockRowQuestionsSub: "पूरै USCIS सूचीबाट छानिएका",
        mockRowPassFormat: "पास हुन %d सही चाहिन्छ",
        mockRowPassSub: "USCIS पास मापदण्ड सँग मेल",
        mockRowVoice: "आवाजले उत्तर दिनुहोस्",
        mockRowVoiceSub: "वास्तविक परीक्षा जस्तै बोल्नुहोस्",
        startInterview: "अन्तर्वार्ता सुरु गर्नुहोस्",

        interviewQuestionLabel: "प्रश्न",
        interviewStatusReading: "प्रश्न पढ्दै…",
        interviewStatusListening: "सुन्दै…",
        interviewStatusNext: "अर्को प्रश्न…",
        interviewNeedFormat: "%d चाहिन्छ",
        interviewOrTap: "वा आफ्नो उत्तर छान्नुहोस्",
        interviewTapMic: "बोल्नको लागि माइक थिच्नुहोस्",
        interviewListening: "सुन्दै…",
        interviewTapAgain: "रोक्न फेरि थिच्नुहोस्",
        interviewAnswerOutLoud: "प्रश्नको उत्तर चर्को स्वरमा दिनुहोस्",
        interviewCorrect: "सही!",
        interviewWrong: "गलत",
        interviewMatching: "उत्तर जाँच्दै…",
        interviewDidntHear: "सुनिएन",
        interviewRetry: "फेरि प्रयास",
        interviewSkip: "छोड्नुहोस्",
        interviewReplay: "फेरि सुन्नुहोस्",
        interviewNextQuestion: "अर्को प्रश्न",
        interviewCorrectAnswerLabel: "सही उत्तर",

        resultPassed: "पास भयो",
        resultFailed: "फेल भयो",
        resultOfCorrectFormat: "%d/%d सही",
        resultCorrect: "सही",
        resultWrong: "गलत",
        resultScore: "अङ्क",
        resultRequiredToPass: "पास हुन चाहिने",
        resultLifetimeStats: "कुल तथ्याङ्क",
        resultAnswered: "जवाफ दिइएको",
        resultAccuracy: "शुद्धता",
        resultStreak: "लगातार",
        resultShareResult: "परिणाम साझा गर्नुहोस्",
        resultTryAgain: "फेरि प्रयास गर्नुहोस्",
        resultDone: "सकियो",
        resultReviewHeader: "प्रश्न समीक्षा",
        resultReviewYouAnswered: "तपाईंको उत्तर:",
        resultReviewCorrectAnswer: "सही उत्तर:",
        resultReviewNoAnswer: "उत्तर दिइएन",

        onboardingIntroHeadline: "USCIS अन्तर्वार्ता पास गर्नुहोस्",
        onboardingIntroTagline: "आवाज र तपाईंको भाषाका लागि बनाइएको",
        onboardingFeatureVoice: "आवाजद्वारा अभ्यास",
        onboardingFeatureVoiceSub: "प्रश्न सुन्नुहोस्, बोलेर जवाफ दिनुहोस्",
        onboardingFeatureLanguage: "४ भाषा",
        onboardingFeatureLanguageSub: "अंग्रेजी, स्पेनिश, नेपाली, चिनियाँ",
        onboardingFeatureMock: "वास्तविक परीक्षा अनुकरण",
        onboardingFeatureMockSub: "१० प्रश्नको नक्कली अन्तर्वार्ता",
        onboardingContinue: "जारी राख्नुहोस्",
        onboardingHearSample: "नमूना सुन्नुहोस्",
        onboardingSampleText: "संयुक्त राज्य अमेरिकाको राजधानी के हो?",
        notificationsTitle: "नियमित रहनुहोस्",
        notificationsSubtitle: "दैनिक सम्झौटाले तपाईंको लगातारलाई जिवन्त राख्छ",
        notificationsEnable: "दैनिक सम्झौटा सक्षम गर्नुहोस्",
        notificationsSkip: "अहिले होइन",
        onboardingStartAtLevelFormat: "स्तर %d बाट सुरु गर्नुहोस्",
        recommendedBadge: "सिफारिस",

        paywallHeadlineDefault: "आफ्नो नागरिकता\nअन्तर्वार्ता पास गर्नुहोस्",
        paywallHeadlineLockedLevel: "कठिन प्रश्नहरूका\nलागि तयार?",
        paywallHeadlineMockInterview: "वास्तविक USCIS\nअन्तर्वार्ता अनुकरण",
        paywallSubheadlineDefault: "सबै सुविधामा पूर्ण पहुँच पाउनुहोस् र विश्वासका साथ पास गर्नुहोस्।",
        paywallSubheadlineLockedLevel: "कठिन प्रश्नले तपाईंलाई वास्तविक परीक्षाका लागि तयार पार्छ। सबै ५ स्तर अनलक गर्नुहोस्।",
        paywallSubheadlineMockInterview: "तपाईंले आफ्नो निःशुल्क अन्तर्वार्ता गरिसक्नुभयो। असीमित प्रयास अनलक गर्नुहोस्।",
        paywallFeaturesDefault: [
            "सबै ५ अभ्यास स्तर",
            "असीमित नक्कली अन्तर्वार्ता",
            "कठिन र विज्ञ प्रश्नमा दक्षता",
            "पूर्ण प्रगति ट्र्याकिङ"
        ],
        paywallFeaturesLockedLevel: [
            "उन्नत र विज्ञ कठिनाइ स्तर",
            "असीमित नक्कली अन्तर्वार्ता अभ्यास",
            "पहिले सबैभन्दा कठिन प्रश्नहरूमा दक्षता",
            "समयसँगै आफ्नो प्रगति ट्र्याक गर्नुहोस्"
        ],
        paywallFeaturesMockInterview: [
            "असीमित नक्कली अन्तर्वार्ता प्रयास",
            "उन्नत र विज्ञ अभ्यास स्तर",
            "आवाजद्वारा अन्तर्वार्ता अनुकरण",
            "अङ्क, लगातार र प्रगति ट्र्याक"
        ],
        paywallLifetime: "आजीवन",
        paywallLifetimeSubtitle: "एकचोटि तिर्नुहोस्, सधैंभरि तपाईंको",
        paywallMonthly: "मासिक",
        paywallMonthlySubtitleFormat: "३ दिन निःशुल्क परीक्षण, त्यसपछि %@/महिना",
        paywallFree: "निःशुल्क",
        paywallBestValue: "उत्तम मूल्य",
        paywall3DaysFree: "३ दिन निःशुल्क",
        paywallProcessing: "प्रक्रियामा…",
        paywallStartFreeTrial: "निःशुल्क परीक्षण सुरु",
        paywallContinue: "जारी राख्नुहोस्",
        paywallLoadingPricing: "मूल्य लोड गर्दै…",
        paywallPricingUnavailable: "मूल्य अहिले उपलब्ध छैन।",
        paywallTryAgain: "फेरि प्रयास गर्नुहोस्",
        paywallCostFilingFee: "USCIS आवेदन शुल्क",
        paywallCostAttorney: "अध्यागमन वकिल",
        paywallCostAppBrand: "CitiZen Pro",
        paywallDisclosureFormat: "३-दिनको निःशुल्क परीक्षणपछि %@/महिनाको सदस्यता। भुक्तानी पुष्टि गर्दा तपाईंको Apple ID खातामा शुल्क लाग्नेछ। हालको अवधि सकिनुभन्दा कम्तिमा २४ घण्टा अगाडि स्वत:-नवीकरण बन्द नगरेसम्म सदस्यता स्वत: नवीकरण हुनेछ। तपाईं आफ्नो सदस्यता Apple ID खाता सेटिङमा व्यवस्थापन र रद्द गर्न सक्नुहुन्छ।",
        paywallPurchaseIncomplete: "खरिद पूरा भएन।",
        paywallPurchaseFailed: "खरिद असफल। कृपया फेरि प्रयास गर्नुहोस्।",
        paywallVerificationIssue: "प्रमाणीकरण समस्या",
        paywallDismiss: "बन्द गर्नुहोस्",
        paywallRestore: "खरिदहरू पुनर्स्थापना",
        paywallPrivacy: "गोपनीयता नीति",
        paywallTerms: "प्रयोगका सर्तहरू",
        paywallErrorVerificationFailed: "खरिद प्रमाणित गर्न सकिएन। कृपया खरिदहरू पुनर्स्थापना गर्ने प्रयास गर्नुहोस्।",

        audioFeedbackCorrect: "सही",
        audioFeedbackTheAnswerIsFormat: "जवाफ %@ हो",

        practiceCardCountFormat: "कार्ड %d / %d",
        readingListenBtn: "सुन्नुहोस्",
        readingShowBtn: "देखाउनुहोस्",
        readingNextBtn: "अर्को",
        writingHeader: "वाक्य सुन्नुहोस् र टाइप गर्नुहोस्",
        writingPlayAgainBtn: "फेरि बजाउनुहोस्",
        writingInputPlaceholder: "सुनेको कुरा टाइप गर्नुहोस्…",
        writingCheckBtn: "जाँच गर्नुहोस्",
        writingCorrectLabel: "सही!",
        writingIncorrectLabel: "ठ्याक्कै होइन",
        writingCorrectAnswerLabel: "सही उत्तर:",
        writingNextBtn: "अर्को",
        writingWordsCorrectFormat: "%d/%d शब्द सही",
        vocabCategoryPeople: "व्यक्ति",
        vocabCategoryCivics: "नागरिक शास्त्र",
        vocabCategoryPlaces: "स्थानहरू",
        vocabCategoryHolidays: "चाडपर्वहरू",
        vocabCategoryMonths: "महिनाहरू",
        vocabCategoryQuestionWords: "प्रश्न शब्दहरू",
        vocabCategoryVerbs: "क्रियाहरू",
        vocabCategoryOther: "अन्य",

        testModeLearn: "सिक्नुहोस्",
        testModeTest: "परीक्षा",
        testModeReadingIntro: "हरेक वाक्य चर्को स्वरमा पढ्नुहोस्। ३ वाक्य आउनेछन् — १ सही पढ्नुभयो भने पास।",
        testModeSentenceOfFormat: "वाक्य %d / %d",
        testModeTapToStart: "तपाईं तयार भएपछि माइक थिच्नुहोस् र चर्को स्वरमा पढ्नुहोस्",
        testModeStopBtn: "सकियो",
        testModeRecording: "सुन्दै…",
        testModeWeHeard: "हामीले सुन्यौं:",
        testModeRestartBtn: "फेरि प्रयास",
        testModeSessionPassed: "तपाईंले पास गर्नुभयो!",
        testModeSessionFailed: "अझै भएको छैन — अभ्यास गर्नुहोस्।",
        testModeScoreFormat: "तपाईंले %d / %d वाक्य पास गर्नुभयो",
        testModeMicPermission: "परीक्षा मोड प्रयोग गर्न सेटिङहरूमा माइक्रोफोन पहुँच अनुमति दिनुहोस्।",
        testModeContinueBtn: "जारी राख्नुहोस्",
        testModeNoSpeechHeard: "हामीले केही सुनेनौं — माइक थिच्नुहोस् र फेरि प्रयास गर्नुहोस्।",
        testModeExitConfirmTitle: "परीक्षा समाप्त गर्ने?",
        testModeExitConfirmMessage: "यस ३-वाक्यको परीक्षा सत्रको प्रगति हराउनेछ।",
        testModeExitConfirmYes: "परीक्षा समाप्त",
        testModeExitConfirmNo: "अभ्यास जारी राख्नुहोस्",

        a11yStartRecording: "रेकर्डिङ सुरु गर्नुहोस्",
        a11yStopRecording: "रेकर्डिङ रोक्नुहोस्",
        a11yClose: "बन्द गर्नुहोस्",
        a11yBack: "पछाडि",

        writingEnglishDisclaimer: "USCIS लेखाइ परीक्षा अंग्रेजीमा हुन्छ। उत्तम अभ्यासका लागि अंग्रेजीमा टाइप गर्नुहोस्।",
        mockInterviewEnglishDisclaimer: "वास्तविक USCIS अन्तर्वार्ता अंग्रेजीमा गरिन्छ। यो नक्कली अन्तर्वार्ता अंग्रेजीमा मात्र छ ताकि तपाईंको अभ्यास वास्तविक परीक्षासँग मेल खाओस्।",
        voicePackMissingMessage: "स्पष्ट नेपाली अडियोको लागि, iOS Settings → Accessibility → Spoken Content → Voices मा हिन्दी आवाज स्थापना गर्नुहोस्।",
        questionTimeSensitiveNote: "उत्तरहरू समयसँगै परिवर्तन हुन सक्छन्। अन्तर्वार्ता अघि uscis.gov/citizenship मा हालको पदाधिकारी जाँच्नुहोस्।",
        testModeSpeechUnavailable: "यस उपकरणमा वाक् पहिचान उपलब्ध छैन। iOS सेटिङ → सामान्य → किबोर्डमा अंग्रेजी किबोर्ड थपिएको छ भन्ने सुनिश्चित गरी फेरि प्रयास गर्नुहोस्।",

        readinessReadingTitle: "अंग्रेजी पढाइ परीक्षा",
        readinessWritingTitle: "अंग्रेजी लेखाइ परीक्षा",
        readinessSessionsFormat: "%d/%d सत्र पास · %d%% तयार",
        readinessNotStarted: "अझै सुरु गरिएको छैन",

        navInterviewChecklist: "अन्तर्वार्ता चेकलिस्ट",
        navExamReadiness: "परीक्षा तयारी",
        navReviewMistakes: "गल्तीहरू समीक्षा",
        navReadingPractice: "पढाइ अभ्यास",
        navWritingPractice: "लेखाइ अभ्यास",
        navAudioOnly: "अडियो-मात्र",
        navSettings: "सेटिङहरू",

        readinessProgressByLevel: "स्तर अनुसार प्रगति",
        readinessReadyLabel: "तयार",
        readinessMasteredFormat: "%d/%d प्रश्नहरूमा दक्ष",
        readinessStatMastered: "दक्ष",
        readinessStatLearning: "सिक्दै",
        readinessStatNew: "नयाँ",
        readinessCurrentStreak: "हालको स्ट्रिक",
        readinessBestStreak: "उत्कृष्ट स्ट्रिक",
        readinessAccuracy: "शुद्धता",

        audioOnlyStatusListeningToQuestion: "प्रश्न सुन्दै…",
        audioOnlyStatusSpeakYourAnswer: "आफ्नो उत्तर भन्नुहोस्",
        audioOnlyStatusProcessing: "प्रक्रियामा…",
        audioOnlyStopBtn: "रोक्नुहोस्",
        audioOnlySessionComplete: "सत्र पूरा भयो",
        audioOnlyProgressFormat: "%d/%d · %d सही",
        audioOnlyFinalScoreFormat: "%d/%d सही (%d%%)",

        quizTapToSpeakHint: "बोल्न ट्याप गर्नुहोस्",
        quizMicListening: "सुन्दै…",
        quizMicPressToRetry: "फेरि प्रयास गर्न माइक थिच्नुहोस्",
        quizLifetimeStats: "कुल तथ्याङ्क",
        quizStatAnswered: "जवाफ दिइएको",
        quizStatStreak: "स्ट्रिक",

        settingsRemindersHeader: "अध्ययन रिमाइन्डरहरू",
        settingsDailyReminder: "दैनिक रिमाइन्डर",
        settingsReminderTime: "रिमाइन्डर समय",
        settingsEnableNotifications: "सूचनाहरू सक्रिय गर्नुहोस्",
        settingsRemindersCaption: "अध्ययन गर्न र स्ट्रिक कायम राख्न दैनिक रिमाइन्डरहरू पाउनुहोस्।",
        settingsInterviewHeader: "अन्तर्वार्ता",
        settingsHasScheduledInterview: "मेरो अन्तर्वार्ता तालिका छ",
        settingsInterviewDate: "अन्तर्वार्ता मिति",
        settingsSubscriptionHeader: "सदस्यता",
        settingsProActive: "सक्रिय",
        settingsRestorePurchases: "खरिदहरू पुनर्स्थापना",
        settingsLegalHeader: "कानुनी",
        settingsPrivacyPolicy: "गोपनीयता नीति",
        settingsTermsOfUse: "प्रयोगका सर्तहरू",
        settingsAboutHeader: "बारेमा",
        settingsVersionLabel: "संस्करण",

        appTagline: "अमेरिकी नागरिकता परीक्षा तयारी",
        getStartedBtn: "सुरु गर्नुहोस्"
    )

    // ─────────────────────────────────────────────────────────────
    // Chinese (Simplified)
    // ─────────────────────────────────────────────────────────────

    static let chinese = UIStrings(
        navPracticeSelection: "选择你的练习",
        pickPractice: "选择你的练习👇🏻",
        mockInterview: "模拟面试",
        mockSubtitlePro: "模拟真实的USCIS考试",
        mockSubtitleFree: "免费试用首次模拟面试",
        mockSubtitleLocked: "解锁无限模拟面试",
        examReadiness: "考试准备",
        examReadinessSubtitleFormat: "已掌握 %d/%d · %d%% 就绪",
        reviewMistakes: "复习错题",
        reviewMistakesSubtitleFormat: "%d 道题待复习",
        reviewMistakesEmpty: "请先完成一些练习",
        practiceLevels: "练习等级",
        readingWriting: "阅读与写作",
        handsFree: "免提模式",
        readingPractice: "阅读练习",
        readingPracticeSubtitle: "练习USCIS阅读词汇",
        writingPractice: "写作练习",
        writingPracticeSubtitle: "听写USCIS句子",
        unlockWithPro: "解锁Pro",
        audioOnly: "纯音频模式",
        audioOnlySubtitle: "用语音免提学习",
        levelEasy: "简单",
        levelMedium: "中等",
        levelHard: "困难",
        levelAdvanced: "进阶",
        levelExpert: "专家",
        daysUntilInterviewFormat: "距离面试还有 %d 天",

        navMockInterview: "模拟面试",
        mockHeadline: "模拟面试",
        mockTagline: "模拟真实的USCIS公民考试",
        mockRowQuestionsFormat: "%d 道题",
        mockRowQuestionsSub: "从完整USCIS题库中抽取",
        mockRowPassFormat: "答对 %d 道即通过",
        mockRowPassSub: "符合USCIS通过标准",
        mockRowVoice: "用语音回答",
        mockRowVoiceSub: "像真实考试一样说出答案",
        startInterview: "开始面试",

        interviewQuestionLabel: "题目",
        interviewStatusReading: "正在朗读题目…",
        interviewStatusListening: "聆听中…",
        interviewStatusNext: "下一题…",
        interviewNeedFormat: "需要 %d",
        interviewOrTap: "或点击你的答案",
        interviewTapMic: "点击麦克风说话",
        interviewListening: "聆听中…",
        interviewTapAgain: "再次点击以停止",
        interviewAnswerOutLoud: "请大声回答问题",
        interviewCorrect: "正确!",
        interviewWrong: "错误",
        interviewMatching: "正在匹配答案…",
        interviewDidntHear: "没有听清",
        interviewRetry: "再试一次",
        interviewSkip: "跳过",
        interviewReplay: "重播",
        interviewNextQuestion: "下一题",
        interviewCorrectAnswerLabel: "正确答案",

        resultPassed: "通过",
        resultFailed: "未通过",
        resultOfCorrectFormat: "答对 %d / %d",
        resultCorrect: "正确",
        resultWrong: "错误",
        resultScore: "得分",
        resultRequiredToPass: "通过所需",
        resultLifetimeStats: "累计统计",
        resultAnswered: "已答题",
        resultAccuracy: "准确率",
        resultStreak: "连续天数",
        resultShareResult: "分享结果",
        resultTryAgain: "再试一次",
        resultDone: "完成",
        resultReviewHeader: "题目回顾",
        resultReviewYouAnswered: "你的回答:",
        resultReviewCorrectAnswer: "正确答案:",
        resultReviewNoAnswer: "未作答",

        onboardingIntroHeadline: "通过 USCIS 公民面试",
        onboardingIntroTagline: "为语音而建,为你的语言而建",
        onboardingFeatureVoice: "语音练习",
        onboardingFeatureVoiceSub: "听问题,说答案",
        onboardingFeatureLanguage: "4 种语言",
        onboardingFeatureLanguageSub: "英语、西班牙语、尼泊尔语、中文",
        onboardingFeatureMock: "真实考试模拟",
        onboardingFeatureMockSub: "10 道题模拟面试",
        onboardingContinue: "继续",
        onboardingHearSample: "听一个示例",
        onboardingSampleText: "美国的首都是哪里?",
        notificationsTitle: "保持进度",
        notificationsSubtitle: "每日提醒让连续天数不中断",
        notificationsEnable: "启用每日提醒",
        notificationsSkip: "暂不开启",
        onboardingStartAtLevelFormat: "从等级 %d 开始",
        recommendedBadge: "推荐",

        paywallHeadlineDefault: "通过你的公民\n入籍面试",
        paywallHeadlineLockedLevel: "准备好更难的\n题目了吗?",
        paywallHeadlineMockInterview: "模拟真实的\nUSCIS 面试",
        paywallSubheadlineDefault: "解锁全部功能, 自信通过面试.",
        paywallSubheadlineLockedLevel: "难题帮你为真实考试做准备. 解锁全部 5 个等级.",
        paywallSubheadlineMockInterview: "你已试过免费面试. 解锁无限次数继续提升.",
        paywallFeaturesDefault: [
            "全部 5 个练习等级",
            "无限模拟面试",
            "掌握困难与专家题目",
            "完整进度追踪"
        ],
        paywallFeaturesLockedLevel: [
            "进阶与专家难度等级",
            "无限模拟面试练习",
            "先掌握最难的题目",
            "追踪你随时间的进步"
        ],
        paywallFeaturesMockInterview: [
            "无限模拟面试次数",
            "进阶与专家练习等级",
            "语音驱动的面试模拟",
            "追踪分数、连续天数和进度"
        ],
        paywallLifetime: "终身",
        paywallLifetimeSubtitle: "一次付费, 终身使用",
        paywallMonthly: "月度",
        paywallMonthlySubtitleFormat: "3 天免费试用, 之后 %@/月",
        paywallFree: "免费",
        paywallBestValue: "最超值",
        paywall3DaysFree: "3 天免费",
        paywallProcessing: "处理中…",
        paywallStartFreeTrial: "开始免费试用",
        paywallContinue: "继续",
        paywallLoadingPricing: "加载价格…",
        paywallPricingUnavailable: "价格暂时无法显示.",
        paywallTryAgain: "重试",
        paywallCostFilingFee: "USCIS 申请费",
        paywallCostAttorney: "移民律师",
        paywallCostAppBrand: "CitiZen Pro",
        paywallDisclosureFormat: "3 天免费试用后为 %@/月订阅. 确认购买时将从你的 Apple ID 账户扣款. 除非在当前周期结束前至少 24 小时关闭自动续订, 订阅将自动续订. 你可以在 Apple ID 账户设置中管理和取消订阅.",
        paywallPurchaseIncomplete: "购买未完成.",
        paywallPurchaseFailed: "购买失败, 请重试.",
        paywallVerificationIssue: "验证问题",
        paywallDismiss: "关闭",
        paywallRestore: "恢复购买",
        paywallPrivacy: "隐私政策",
        paywallTerms: "使用条款",
        paywallErrorVerificationFailed: "无法验证购买. 请尝试恢复购买.",

        audioFeedbackCorrect: "正确",
        audioFeedbackTheAnswerIsFormat: "答案是 %@",

        practiceCardCountFormat: "第 %d 张 / 共 %d 张",
        readingListenBtn: "聆听",
        readingShowBtn: "显示",
        readingNextBtn: "下一个",
        writingHeader: "听句子并输入",
        writingPlayAgainBtn: "再次播放",
        writingInputPlaceholder: "输入你听到的内容…",
        writingCheckBtn: "检查",
        writingCorrectLabel: "正确!",
        writingIncorrectLabel: "不太对",
        writingCorrectAnswerLabel: "正确答案:",
        writingNextBtn: "下一个",
        writingWordsCorrectFormat: "答对 %d / %d 个单词",
        vocabCategoryPeople: "人物",
        vocabCategoryCivics: "公民",
        vocabCategoryPlaces: "地点",
        vocabCategoryHolidays: "节日",
        vocabCategoryMonths: "月份",
        vocabCategoryQuestionWords: "疑问词",
        vocabCategoryVerbs: "动词",
        vocabCategoryOther: "其他",

        testModeLearn: "学习",
        testModeTest: "测试",
        testModeReadingIntro: "请大声朗读每个句子. 共 3 个句子 — 读对 1 个即可通过.",
        testModeSentenceOfFormat: "第 %d / %d 句",
        testModeTapToStart: "准备好后点击麦克风, 大声朗读句子",
        testModeStopBtn: "完成",
        testModeRecording: "聆听中…",
        testModeWeHeard: "我们听到:",
        testModeRestartBtn: "再试一次",
        testModeSessionPassed: "你通过了!",
        testModeSessionFailed: "还没通过 — 继续练习.",
        testModeScoreFormat: "你通过了 %d / %d 个句子",
        testModeMicPermission: "请在设置中允许麦克风访问以使用测试模式.",
        testModeContinueBtn: "继续",
        testModeNoSpeechHeard: "我们什么都没听到 — 请再次点击麦克风.",
        testModeExitConfirmTitle: "结束测试?",
        testModeExitConfirmMessage: "此 3 题测试的进度将丢失.",
        testModeExitConfirmYes: "结束测试",
        testModeExitConfirmNo: "继续练习",

        a11yStartRecording: "开始录音",
        a11yStopRecording: "停止录音",
        a11yClose: "关闭",
        a11yBack: "返回",

        writingEnglishDisclaimer: "USCIS 写作测试使用英语. 请用英语输入以获得最佳练习效果.",
        mockInterviewEnglishDisclaimer: "真实的 USCIS 面试以英语进行. 此模拟面试仅使用英语, 以便你的练习与真实考试保持一致.",
        voicePackMissingMessage: "未安装此语言的语音包. 为获得清晰的音频, 请在 设置 → 辅助功能 → 朗读内容 → 语音 中添加.",
        questionTimeSensitiveNote: "答案会随时间变化. 面试前请在 uscis.gov/citizenship 查看当前任职官员.",
        testModeSpeechUnavailable: "此设备上语音识别不可用. 请在 iOS 设置 → 通用 → 键盘中添加英语键盘后重试.",

        readinessReadingTitle: "英语阅读测试",
        readinessWritingTitle: "英语写作测试",
        readinessSessionsFormat: "%d / %d 次通过 · %d%% 就绪",
        readinessNotStarted: "尚未开始",

        navInterviewChecklist: "面试清单",
        navExamReadiness: "考试准备",
        navReviewMistakes: "复习错题",
        navReadingPractice: "阅读练习",
        navWritingPractice: "写作练习",
        navAudioOnly: "纯音频",
        navSettings: "设置",

        readinessProgressByLevel: "各级别进度",
        readinessReadyLabel: "就绪",
        readinessMasteredFormat: "已掌握 %d / %d 题",
        readinessStatMastered: "已掌握",
        readinessStatLearning: "学习中",
        readinessStatNew: "新题",
        readinessCurrentStreak: "当前连续天数",
        readinessBestStreak: "最长连续",
        readinessAccuracy: "准确率",

        audioOnlyStatusListeningToQuestion: "正在播放问题…",
        audioOnlyStatusSpeakYourAnswer: "请说出你的答案",
        audioOnlyStatusProcessing: "处理中…",
        audioOnlyStopBtn: "停止",
        audioOnlySessionComplete: "会话完成",
        audioOnlyProgressFormat: "%d/%d · 答对 %d 题",
        audioOnlyFinalScoreFormat: "答对 %d / %d 题（%d%%）",

        quizTapToSpeakHint: "点击说话",
        quizMicListening: "聆听中…",
        quizMicPressToRetry: "按麦克风重试",
        quizLifetimeStats: "累计统计",
        quizStatAnswered: "已答题",
        quizStatStreak: "连续天数",

        settingsRemindersHeader: "学习提醒",
        settingsDailyReminder: "每日提醒",
        settingsReminderTime: "提醒时间",
        settingsEnableNotifications: "开启通知",
        settingsRemindersCaption: "开启每日学习提醒与连续天数通知。",
        settingsInterviewHeader: "面试",
        settingsHasScheduledInterview: "我已预约面试",
        settingsInterviewDate: "面试日期",
        settingsSubscriptionHeader: "订阅",
        settingsProActive: "已启用",
        settingsRestorePurchases: "恢复购买",
        settingsLegalHeader: "法律",
        settingsPrivacyPolicy: "隐私政策",
        settingsTermsOfUse: "使用条款",
        settingsAboutHeader: "关于",
        settingsVersionLabel: "版本",

        appTagline: "美国公民入籍考试备考",
        getStartedBtn: "开始使用"
    )
}
