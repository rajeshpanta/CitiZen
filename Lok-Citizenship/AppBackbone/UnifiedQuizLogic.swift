import Foundation
import Combine

// ═════════════════════════════════════════════════════════════════
// MARK: - Quiz Status (single terminal state)
// ═════════════════════════════════════════════════════════════════

/// Replaces the three separate booleans (showResult, hasFailed, hasPassed).
/// Exactly one value at any time — no inconsistent combinations possible.
enum QuizStatus: Equatable {
    case inProgress
    case completed   // practice: finished all questions without hitting mistake limit
    case passed      // mock interview: reached required correct answers
    case failed      // hit the mistake limit (both modes)
}

// ═════════════════════════════════════════════════════════════════
// MARK: - Quiz Mode (centralized rules)
// ═════════════════════════════════════════════════════════════════

/// All mode-specific business rules live here. No branching in the quiz engine.
struct QuizMode {

    /// Maximum wrong answers before failure.
    let maxMistakes: Int

    /// Number of correct answers needed for early pass. Nil = no early pass (practice).
    let requiredCorrect: Int?

    /// How many questions to draw from the pool. Nil = use all questions (practice).
    let questionLimit: Int?

    // MARK: - Presets

    static let practice = QuizMode(
        maxMistakes: 4,
        requiredCorrect: nil,
        questionLimit: nil
    )

    static let audioOnly = QuizMode(
        maxMistakes: .max,
        requiredCorrect: nil,
        questionLimit: nil
    )

    static func mockInterview(
        questionCount: Int = 10,
        requiredCorrect: Int = 8
    ) -> QuizMode {
        QuizMode(
            maxMistakes: questionCount - requiredCorrect + 1,
            requiredCorrect: requiredCorrect,
            questionLimit: questionCount
        )
    }

    // MARK: - Rule evaluation

    /// Check if the quiz should terminate after an answer.
    /// Returns nil if quiz continues, or a terminal status if it should stop.
    func checkTermination(correct: Int, incorrect: Int) -> QuizStatus? {
        if let req = requiredCorrect, correct >= req { return .passed }
        if incorrect >= maxMistakes { return .failed }
        return nil
    }
}

// ═════════════════════════════════════════════════════════════════
// MARK: - Progress Tracking Protocol
// ═════════════════════════════════════════════════════════════════

/// Abstraction for progress persistence. Injected into the quiz engine
/// so it can be swapped for testing or alternative implementations.
protocol ProgressTracking {
    func recordAnswer(correct: Bool)
    func recordQuizCompletion(passed: Bool)
}

/// ProgressManager conforms by default. The conformance is isolated to
/// the main actor because `ProgressManager` itself is `@MainActor`-isolated;
/// without this, Swift 6 strict concurrency flags the conformance as
/// crossing actor boundaries and can-cause-data-races. Practically, the
/// only consumer is `UnifiedQuizLogic` (also `@MainActor`), so this is the
/// honest declaration of where the work happens — no runtime change.
extension ProgressManager: @MainActor ProgressTracking {}

// ═════════════════════════════════════════════════════════════════
// MARK: - Unified Quiz Logic
// ═════════════════════════════════════════════════════════════════

/// Reusable quiz engine for both Practice and Mock Interview modes.
/// Owns quiz state and business rules. Does not own UI flow or timing.
///
/// `@MainActor` because every consumer is a SwiftUI view (`QuizView`,
/// `MockInterviewView`, `AudioOnlyView`) that already runs on main, and
/// because the engine writes `@Published` state that SwiftUI requires from
/// main. Annotating explicitly is what unblocks the default-argument
/// reference to `@MainActor`-isolated `ProgressManager.shared` in the
/// initializer below — under Swift 6 strict concurrency, that reference
/// from a nonisolated context would otherwise be an error.
@MainActor
final class UnifiedQuizLogic: ObservableObject {

    // MARK: - Published state

    @Published var questions: [UnifiedQuestion] = []
    @Published var currentQuestionIndex = 0
    @Published var correctAnswers       = 0
    @Published var incorrectAnswers     = 0
    @Published var status: QuizStatus   = .inProgress

    /// Per-question log for end-of-quiz review (mock interview result screen).
    @Published var answerLog: [AnswerLogEntry] = []

    struct AnswerLogEntry: Identifiable {
        let id = UUID()
        let question: UnifiedQuestion
        /// Selected option index, or nil if skipped / no valid answer.
        let userAnswer: Int?
        let isCorrect: Bool
    }

    /// Which language variant is currently displayed.
    @Published var selectedVariantIndex = 0

    // MARK: - Configuration

    private(set) var mode = QuizMode.practice
    private let progress: ProgressTracking
    private var completionRecorded = false

    /// When false, `answerQuestion` and `finish` skip writing to `ProgressTracking`,
    /// `QuestionTracker.shared`, and Analytics. Used by the onboarding placement quiz
    /// so the user's lifetime stats aren't polluted by the pre-onboarding assessment.
    var tracksProgress = true

    // MARK: - Init

    /// Default `progress` is `nil`, resolved to `ProgressManager.shared`
    /// inside the body. The shared instance is `@MainActor`-isolated, and
    /// Swift 6 evaluates default-argument expressions in a nonisolated
    /// context independent of the init's own isolation — referencing
    /// `ProgressManager.shared` directly as a default would be a
    /// strict-concurrency violation. Resolving inside the init body, which
    /// inherits the class's `@MainActor` isolation, is the diagnostic-free
    /// way to keep the convenient parameterless `UnifiedQuizLogic()` form.
    init(defaultVariantIndex: Int = 0,
         progress: (any ProgressTracking)? = nil) {
        self.selectedVariantIndex = defaultVariantIndex
        self.progress = progress ?? ProgressManager.shared
    }

    // MARK: - Current question (safe access)

    var currentQuestion: UnifiedQuestion {
        guard !questions.isEmpty, currentQuestionIndex < questions.count else {
            return UnifiedQuestion(id: "", correctAnswer: 0, variants: [
                .init(text: "", options: [])
            ])
        }
        return questions[currentQuestionIndex]
    }

    // MARK: - Current variant helpers

    private var currentVariant: UnifiedQuestion.Variant {
        let variants = currentQuestion.variants
        let idx = min(selectedVariantIndex, variants.count - 1)
        return variants[max(idx, 0)]
    }

    var currentText: String { currentVariant.text }
    var currentOptions: [String] { currentVariant.options }

    // MARK: - Computed metrics

    var totalQuestions: Int { questions.count }
    var attemptedQuestions: Int { correctAnswers + incorrectAnswers }
    var isFinished: Bool { status != .inProgress }

    var scorePercentage: Int {
        guard totalQuestions > 0 else { return 0 }
        return (correctAnswers * 100) / totalQuestions
    }

    // MARK: - Language switching

    func switchVariant(to index: Int) {
        selectedVariantIndex = index
    }

    // MARK: - Answer handling

    /// Record an answer. Returns true if correct.
    @discardableResult
    func answerQuestion(_ answerIndex: Int) -> Bool {
        guard currentQuestionIndex < questions.count, !isFinished else { return false }

        let q = currentQuestion
        let optionCount = q.variants.first?.options.count ?? 0
        let validIndex: Int? = (answerIndex >= 0 && answerIndex < optionCount) ? answerIndex : nil
        let isCorrect = answerIndex == q.correctAnswer
        if isCorrect {
            correctAnswers += 1
        } else {
            incorrectAnswers += 1
        }

        answerLog.append(AnswerLogEntry(
            question: q,
            userAnswer: validIndex,
            isCorrect: isCorrect
        ))

        if tracksProgress {
            progress.recordAnswer(correct: isCorrect)
            QuestionTracker.shared.recordAnswer(questionID: currentQuestion.id, correct: isCorrect)
        }

        // Ask the mode if we've hit a terminal condition
        if let terminal = mode.checkTermination(
            correct: correctAnswers,
            incorrect: incorrectAnswers
        ) {
            finish(terminal)
        }

        return isCorrect
    }

    // MARK: - Navigation

    /// Advance to the next question. If at the last question, finish the quiz.
    func moveToNextQuestion() {
        guard !isFinished else { return }
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            // Reached the end — determine final status
            if mode.requiredCorrect != nil {
                // Mock interview: must meet threshold
                let passed = correctAnswers >= (mode.requiredCorrect ?? 0)
                finish(passed ? .passed : .failed)
            } else {
                finish(.completed)
            }
        }
    }

    func previousQuestion() {
        guard currentQuestionIndex > 0 else { return }
        currentQuestionIndex -= 1
    }

    // MARK: - Lifecycle

    /// Language identifier for analytics. Set by the view before starting.
    var languageTag = "en-US"

    /// Practice level for analytics. Set by the view before starting.
    var levelTag = 0

    /// Start a practice quiz using all loaded questions.
    /// Questions the user struggles with (accuracy < 60%) appear earlier.
    func startQuiz() {
        mode = .practice
        resetWith(adaptiveShuffle(questions))
        if tracksProgress {
            Analytics.track(.quizStarted(mode: "practice", language: languageTag, level: levelTag))
        }
    }

    /// Start a mock interview, picking questions from the pool.
    func startMockInterview(from pool: [UnifiedQuestion],
                            questionCount: Int = 10,
                            requiredCorrect: Int = 8) {
        guard !pool.isEmpty else { return }
        mode = .mockInterview(questionCount: questionCount,
                              requiredCorrect: requiredCorrect)
        let selected = Array(pool.shuffled().prefix(min(questionCount, pool.count)))
        resetWith(selected)
        if tracksProgress {
            Analytics.track(.quizStarted(mode: "mock_interview", language: languageTag, level: 0))
        }
    }

    /// Start an audio-only session. No failure limit — runs through all questions.
    func startAudioOnly(from pool: [UnifiedQuestion],
                        questionCount: Int = 15) {
        guard !pool.isEmpty else { return }
        mode = .audioOnly
        let selected = Array(pool.shuffled().prefix(min(questionCount, pool.count)))
        resetWith(selected)
        Analytics.track(.quizStarted(mode: "audio_only", language: languageTag, level: 0))
    }

    /// Force-end the quiz as failed (e.g. user taps "End" in mock interview).
    func forceEnd() {
        guard !isFinished else { return }
        finish(.failed)
    }

    // MARK: - Private

    /// Shuffle questions so that ones the user struggles with appear earlier.
    /// Questions with <60% accuracy get 3x weight; unattempted questions keep normal weight.
    private func adaptiveShuffle(_ pool: [UnifiedQuestion]) -> [UnifiedQuestion] {
        let records = QuestionTracker.shared.records
        return pool.map { q -> (q: UnifiedQuestion, weight: Double) in
            guard let record = records[q.id], record.attempts > 0 else {
                return (q, Double.random(in: 0..<1))
            }
            let boost: Double = record.accuracy < 0.6 ? 3.0 : 1.0
            return (q, boost + Double.random(in: 0..<1))
        }
        .sorted { $0.weight > $1.weight }
        .map(\.q)
    }

    private func resetWith(_ pool: [UnifiedQuestion]) {
        guard !pool.isEmpty else { return }
        // Callers are responsible for ordering: startQuiz passes adaptive-weighted
        // order, mock/audio pass a shuffled random subset. Don't re-shuffle here
        // or the adaptive ordering gets destroyed.
        questions            = pool
        currentQuestionIndex = 0
        correctAnswers       = 0
        incorrectAnswers     = 0
        status               = .inProgress
        completionRecorded   = false
        answerLog            = []
    }

    private func finish(_ terminal: QuizStatus) {
        status = terminal
        guard !completionRecorded else { return }
        completionRecorded = true
        guard tracksProgress else { return }
        let passed = terminal == .passed || terminal == .completed
        progress.recordQuizCompletion(passed: passed)

        let modeName = mode.requiredCorrect == nil ? "practice" : "mock_interview"
        Analytics.track(.quizCompleted(
            mode: modeName,
            score: scorePercentage,
            passed: passed,
            language: languageTag
        ))
    }
}
