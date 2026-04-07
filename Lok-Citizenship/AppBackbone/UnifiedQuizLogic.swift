import Foundation
import Combine

/// The single quiz engine that replaces `QuizLogic`, `Quizतर्क`, `QuizLogica`,
/// and `QuizCNLogic`.
///
/// It manages score tracking, question navigation, and the selected language variant.
/// The view reads `currentText` and `currentOptions` which automatically reflect
/// whichever variant (language) is selected.
final class UnifiedQuizLogic: ObservableObject {

    // MARK: - Published state (drives the UI)

    @Published var questions: [UnifiedQuestion] = []
    @Published var currentQuestionIndex = 0
    @Published var correctAnswers       = 0
    @Published var incorrectAnswers     = 0
    @Published var showResult           = false
    @Published var hasFailed            = false

    /// Which language variant is currently displayed (index into each question's `variants`).
    @Published var selectedVariantIndex = 0

    // MARK: - Configuration

    let maxMistakesAllowed = 4

    // MARK: - Init

    init(defaultVariantIndex: Int = 0) {
        self.selectedVariantIndex = defaultVariantIndex
    }

    // MARK: - Safe access to the current question

    var currentQuestion: UnifiedQuestion {
        guard !questions.isEmpty, currentQuestionIndex < questions.count else {
            return UnifiedQuestion(correctAnswer: 0, variants: [
                .init(text: "", options: [])
            ])
        }
        return questions[currentQuestionIndex]
    }

    // MARK: - Current variant helpers

    /// The current question's variant, clamped to a valid index.
    private var currentVariant: UnifiedQuestion.Variant {
        let variants = currentQuestion.variants
        let idx = min(selectedVariantIndex, variants.count - 1)
        return variants[max(idx, 0)]
    }

    /// Question text in the selected language.
    var currentText: String {
        currentVariant.text
    }

    /// Answer options in the selected language.
    var currentOptions: [String] {
        currentVariant.options
    }

    // MARK: - Computed metrics

    var totalQuestions: Int {
        questions.count
    }

    var attemptedQuestions: Int {
        correctAnswers + incorrectAnswers
    }

    var scorePercentage: Int {
        guard totalQuestions > 0 else { return 0 }
        return (correctAnswers * 100) / totalQuestions
    }

    // MARK: - Language switching

    func switchVariant(to index: Int) {
        selectedVariantIndex = index
    }

    // MARK: - Answer handling

    /// Record an answer. Returns `true` if correct.
    @discardableResult
    func answerQuestion(_ answerIndex: Int) -> Bool {
        guard currentQuestionIndex < questions.count else { return false }

        let isCorrect = answerIndex == currentQuestion.correctAnswer
        if isCorrect {
            correctAnswers += 1
        } else {
            incorrectAnswers += 1
            if incorrectAnswers >= maxMistakesAllowed {
                hasFailed = true
            }
        }
        return isCorrect
    }

    // MARK: - Navigation

    func moveToNextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            showResult = true
        }
    }

    func previousQuestion() {
        guard currentQuestionIndex > 0 else { return }
        currentQuestionIndex -= 1
        showResult = false
    }

    // MARK: - Lifecycle

    func startQuiz() {
        guard !questions.isEmpty else { return }
        questions.shuffle()
        currentQuestionIndex = 0
        correctAnswers       = 0
        incorrectAnswers     = 0
        showResult           = false
        hasFailed            = false
    }
}
