import Foundation
import SwiftUI

// MARK:  Language & Question (English ↔︎ Spanish)

struct BilingualQuestionES {
    let englishText:    String
    let spanishText:    String
    let englishOptions: [String]
    let spanishOptions: [String]
    let correctAnswer:  Int
}

// MARK:  Quiz Engine

final class QuizLogica: ObservableObject {

    // Published ------------------------------------------------
    @Published var questions: [BilingualQuestionES] = []
    @Published var currentQuestionIndex             = 0
    @Published var correctAnswers                   = 0
    @Published var incorrectAnswers                 = 0
    @Published var showResult                       = false
    @Published var hasFailed                        = false
    @Published var selectedLanguage: AppLanguage    = .english   // .english / .spanish
    
    // ── NEW initializer ────────────────────────────────────
    // MARK: - NEW initializer  🔥
        init(initialLanguage: AppLanguage = .spanish) {
            self.selectedLanguage = initialLanguage
        }

    // Config ---------------------------------------------------
    private let maxMistakesAllowed = 4

    // Safe access
    var currentQuestion: BilingualQuestionES {
        guard currentQuestionIndex < questions.count, !questions.isEmpty else {
            return BilingualQuestionES(
                englishText:    "",
                spanishText:    "",
                englishOptions: [],
                spanishOptions: [],
                correctAnswer:  0
            )
        }
        return questions[currentQuestionIndex]
    }

    // Helpers --------------------------------------------------
    var totalQuestions: Int     { questions.count }
    var attemptedQuestions: Int { correctAnswers + incorrectAnswers }
    var scorePercentage: Int    { totalQuestions == 0 ? 0 : (correctAnswers * 100) / totalQuestions }

    // Language toggle
    func switchLanguage(to lang: AppLanguage) { selectedLanguage = lang }

    // Answer ---------------------------------------------------
    @discardableResult
    func answerQuestion(_ idx: Int) -> Bool {
        guard currentQuestionIndex < questions.count else { return false }

        let ok = idx == currentQuestion.correctAnswer
        if ok {
            correctAnswers += 1
        } else {
            incorrectAnswers += 1
            if incorrectAnswers >= maxMistakesAllowed { hasFailed = true }
        }
        return ok
    }

    // Navigation ----------------------------------------------
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
    }

    // Lifecycle -----------------------------------------------
    func startQuiz() {
        guard !questions.isEmpty else {
            assertionFailure("QuizLogica.startQuiz(): questions array is empty")
            return
        }
        questions.shuffle()
        currentQuestionIndex = 0
        correctAnswers       = 0
        incorrectAnswers     = 0
        showResult           = false
        hasFailed            = false
    }
}
