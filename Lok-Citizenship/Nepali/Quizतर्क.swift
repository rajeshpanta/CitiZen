import Foundation
import SwiftUI

class Quizतर्क: ObservableObject {
    @Published var questions: [BilingualQuestion] = []
    @Published var currentQuestionIndex: Int = 0
    @Published var correctAnswers: Int = 0
    @Published var incorrectAnswers: Int = 0
    @Published var showResult: Bool = false
    @Published var selectedLanguage: Language = .english // ✅ Language Toggle

    enum Language {
        case english, nepali
    }

    var currentQuestion: BilingualQuestion {
        guard currentQuestionIndex < questions.count else {
            return BilingualQuestion(
                englishText: "No question available",
                nepaliText: "प्रश्न उपलब्ध छैन",
                englishOptions: [],
                nepaliOptions: [],
                correctAnswer: 0
            )
        }
        return questions[currentQuestionIndex]
    }

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

    func answerQuestion(_ answerIndex: Int) -> Bool {
        guard currentQuestionIndex < questions.count else { return false }

        let isCorrect = currentQuestion.correctAnswer == answerIndex
        if isCorrect {
            correctAnswers += 1
        } else {
            incorrectAnswers += 1
        }

        return isCorrect // ✅ No auto-advance! Next question only when user clicks "Next"
    }

    func moveToNextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            showResult = true
        }
    }

    func previousQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
            showResult = false
        }
    }

    func resetQuiz() {
        questions.shuffle()
        currentQuestionIndex = 0
        correctAnswers = 0
        incorrectAnswers = 0
        showResult = false
    }

    func startQuiz() {
        questions.shuffle()
        resetQuiz()
        showResult = false
    }

    func switchLanguage(to language: Language) {
        selectedLanguage = language
    }
}

// ✅ Updated Bilingual Question Model
struct BilingualQuestion {
    let englishText: String
    let nepaliText: String
    let englishOptions: [String] // ✅ Separate options for English
    let nepaliOptions: [String]  // ✅ Separate options for Nepali
    let correctAnswer: Int
}
