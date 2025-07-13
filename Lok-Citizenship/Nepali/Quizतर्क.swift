import Foundation
import SwiftUI

// ─────────────────────────────────────────────────────────────
// MARK:  Language & Question
// ─────────────────────────────────────────────────────────────
//enum Language { case english, nepali }

struct BilingualQuestion {
    let englishText:    String
    let nepaliText:     String
    let englishOptions: [String]
    let nepaliOptions:  [String]
    let correctAnswer:  Int
}

// ─────────────────────────────────────────────────────────────
// MARK:  Quiz Engine
// ─────────────────────────────────────────────────────────────
/// <#Description#>
final class Quizतर्क: ObservableObject {

    // Published ------------------------------------------------
    @Published var questions: [BilingualQuestion] = []
    @Published var currentQuestionIndex           = 0
    @Published var correctAnswers                 = 0
    @Published var incorrectAnswers               = 0
    @Published var showResult                     = false
    @Published var hasFailed                      = false
    @Published var selectedLanguage: AppLanguage  = .english

    
    // MARK: - NEW initializer  🔥
        init(initialLanguage: AppLanguage = .nepali) {
            self.selectedLanguage = initialLanguage
        }

    // Config ---------------------------------------------------
    private let maxMistakesAllowed = 4

    // Safe access (⚠️  FIXED)
    var currentQuestion: BilingualQuestion {
        guard currentQuestionIndex < questions.count, !questions.isEmpty else {
            // placeholder used while the array is still empty
            return BilingualQuestion(
                englishText:    "",
                nepaliText:     "",
                englishOptions: [],
                nepaliOptions:  [],
                correctAnswer:  0
            )
        }
        return questions[currentQuestionIndex]
    }

    // Helpers --------------------------------------------------
    var totalQuestions: Int       { questions.count }
    var attemptedQuestions: Int   { correctAnswers + incorrectAnswers }
    var scorePercentage: Int      { totalQuestions == 0 ? 0 : (correctAnswers * 100) / totalQuestions }

    // Language toggle
    func switchLanguage(to lang: AppLanguage) { selectedLanguage = lang }

    // Answer ---------------------------------------------------
    @discardableResult
    func answerQuestion(_ idx: Int) -> Bool {
        guard currentQuestionIndex < questions.count else { return false }

        let ok = idx == currentQuestion.correctAnswer
        if  ok { correctAnswers   += 1 }
        else   {
            incorrectAnswers += 1
            if incorrectAnswers >= maxMistakesAllowed { hasFailed = true }
        }
        return ok
    }

    // Navigation ----------------------------------------------
    func moveToNextQuestion() {
        if currentQuestionIndex < questions.count - 1 { currentQuestionIndex += 1 }
        else                                          { showResult = true      }
    }

    func previousQuestion() {
        guard currentQuestionIndex > 0 else { return }
        currentQuestionIndex -= 1
    }

    // Lifecycle -----------------------------------------------
    func startQuiz() {
        // Don’t crash if the host view forgot to assign questions
        if questions.isEmpty {
            assertionFailure("Quizतर्क.startQuiz(): questions array is empty")
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
