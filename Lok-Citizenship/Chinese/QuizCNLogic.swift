import Foundation
import SwiftUI

// ─────────────────────────────────────────────────────────────
// MARK: – Three-way language enum for this quiz
// ─────────────────────────────────────────────────────────────
enum QuizLanguageCN {
    case english, simplified, traditional
}

// ─────────────────────────────────────────────────────────────
// MARK: – Question model (tri‐lingual)
// ─────────────────────────────────────────────────────────────
struct TrilingualQuestionCN {
    let englishText:             String
    let chineseSimplifiedText:   String
    let chineseTraditionalText:  String

    let englishOptions:            [String]
    let chineseSimplifiedOptions:  [String]
    let chineseTraditionalOptions: [String]

    let correctAnswer: Int
}

// ─────────────────────────────────────────────────────────────
// MARK: – Quiz engine (tri‐lingual)
// ─────────────────────────────────────────────────────────────
final class QuizCNLogic: ObservableObject {

    // ── Public state ────────────────────────────────────────
    @Published var questions: [TrilingualQuestionCN] = []
    @Published var currentQuestionIndex             = 0
    @Published var correctAnswers                   = 0
    @Published var incorrectAnswers                 = 0
    @Published var showResult                       = false
    @Published var hasFailed                        = false
    @Published var selectedLanguage: QuizLanguageCN  = .english
    
    // ── NEW initializer ────────────────────────────────────
    init(initialLanguage: QuizLanguageCN = .simplified) {
        _selectedLanguage = Published(initialValue: initialLanguage)
    }


    // ── Configuration ──────────────────────────────────────
    private let maxMistakesAllowed = 4

    // ── Safe current question ─────────────────────────────
    var currentQuestion: TrilingualQuestionCN {
        guard !questions.isEmpty,
              currentQuestionIndex < questions.count
        else {
            return TrilingualQuestionCN(
                englishText:             "",
                chineseSimplifiedText:   "",
                chineseTraditionalText:  "",
                englishOptions:            [],
                chineseSimplifiedOptions:  [],
                chineseTraditionalOptions: [],
                correctAnswer: 0
            )
        }
        return questions[currentQuestionIndex]
    }

    // ── Computed helpers ────────────────────────────────────

    /// “Question 3/15” in the right language
    func questionNumberLabel(index: Int, total: Int) -> String {
        switch selectedLanguage {
        case .english:
            return "Question \(index)/\(total)"
        case .simplified:
            return "题目 \(index)/\(total)"
        case .traditional:
            return "題目 \(index)/\(total)"
        }
    }

    /// “3/15 • Score 80%” or “3/15 • 得分 80%”
    var progressLabel: String {
        let score = "\(scorePercentage)%"
        switch selectedLanguage {
        case .english:
            return "\(attemptedQuestions)/\(totalQuestions) • Score \(score)"
        case .simplified, .traditional:
            return "\(attemptedQuestions)/\(totalQuestions) • 得分 \(score)"
        }
    }

    /// Title shown in the nav bar
    var navTitle: String {
        switch selectedLanguage {
        case .english:      return "Practice 1"
        case .simplified:   return "练习 1"
        case .traditional:  return "練習 1"
        }
    }

    /// The question text in the current language
    var currentText: String {
        switch selectedLanguage {
        case .english:      return currentQuestion.englishText
        case .simplified:   return currentQuestion.chineseSimplifiedText
        case .traditional:  return currentQuestion.chineseTraditionalText
        }
    }

    /// The four answer choices in the current language
    var currentOptions: [String] {
        switch selectedLanguage {
        case .english:      return currentQuestion.englishOptions
        case .simplified:   return currentQuestion.chineseSimplifiedOptions
        case .traditional:  return currentQuestion.chineseTraditionalOptions
        }
    }

    /// “Your options are:” vs. “你的选项是：” vs. “你的選項是：”
    var optionsIntroText: String {
        switch selectedLanguage {
        case .english:      return "Your options are:"
        case .simplified:   return "你的选项是："
        case .traditional:  return "你的選項是："
        }
    }

    // ── Underlying quiz metrics ─────────────────────────────

    var totalQuestions: Int     { questions.count }
    var attemptedQuestions: Int { correctAnswers + incorrectAnswers }
    var scorePercentage: Int {
        guard totalQuestions > 0 else { return 0 }
        return (correctAnswers * 100) / totalQuestions
    }

    // ── Language toggle ─────────────────────────────────────
    func switchLanguage(to lang: QuizLanguageCN) {
        selectedLanguage = lang
    }

    // ── Answer handling ────────────────────────────────────
    @discardableResult
    func answerQuestion(_ idx: Int) -> Bool {
        guard currentQuestionIndex < questions.count else { return false }
        let ok = idx == currentQuestion.correctAnswer
        if ok {
            correctAnswers += 1
        } else {
            incorrectAnswers += 1
            if incorrectAnswers >= maxMistakesAllowed {
                hasFailed = true
            }
        }
        return ok
    }

    // ── Navigation ─────────────────────────────────────────
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

    // ── Lifecycle ──────────────────────────────────────────
    func startQuiz() {
        guard !questions.isEmpty else {
            assertionFailure("questions array is empty")
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
