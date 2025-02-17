import Foundation
import SwiftUI

class QuizLogic: ObservableObject {
    @Published var questions: [Question] = []
    @Published var currentQuestionIndex: Int = 0
    @Published var correctAnswers: Int = 0
    @Published var incorrectAnswers: Int = 0
    @Published var showResult: Bool = false
    @Published var hasFailed: Bool = false // ✅ Track if user failed

    let maxMistakesAllowed = 4 // ✅ Maximum mistakes allowed before failing

    var currentQuestion: Question {
        guard currentQuestionIndex < questions.count else {
            return Question(text: "No question available", options: [], correctAnswer: 0)
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
            if incorrectAnswers >= maxMistakesAllowed {
                hasFailed = true // ✅ Fails the quiz if 4 mistakes are made
            }
        }

        return isCorrect
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
            showResult = false // ✅ Reset result when going back
        }
    }

    func resetQuiz() {
        questions.shuffle() // ✅ Reshuffle questions on reset
        currentQuestionIndex = 0
        correctAnswers = 0
        incorrectAnswers = 0
        showResult = false
        hasFailed = false // ✅ Reset failure condition
    }

    func startQuiz() {
        questions.shuffle() // Shuffle questions at the start
        resetQuiz()
        showResult = false // ✅ Reset result screen
    }
}
