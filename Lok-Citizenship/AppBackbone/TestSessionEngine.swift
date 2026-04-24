import Foundation
import Combine

/// Runs a USCIS-style 3-sentence test session, mode-agnostic.
///
/// Used by both Reading Test Mode (user reads aloud, STT → grade) and Writing Test
/// Mode (user types from dictation, diff → grade). The engine only tracks sentences,
/// current index, per-sentence pass/fail, and session-level pass/fail. The caller
/// decides how each sentence is graded.
///
/// Default `sentencesNeededToPass = 1` matches real USCIS scoring: get 1 of 3 right
/// to pass the reading/writing portion of the test.
final class TestSessionEngine: ObservableObject {

    struct Attempt: Identifiable {
        let id = UUID()
        let sentence: String
        var userAnswer: String = ""
        var passed: Bool = false
        var attempted: Bool = false
    }

    @Published private(set) var attempts: [Attempt]
    @Published private(set) var currentIndex: Int = 0
    @Published private(set) var isFinished: Bool = false

    let sentencesNeededToPass: Int

    init(sentences: [String], sentencesNeededToPass: Int = 1) {
        self.attempts = sentences.map { Attempt(sentence: $0) }
        self.sentencesNeededToPass = sentencesNeededToPass
    }

    // MARK: - Read-only state

    var currentSentence: String {
        guard currentIndex < attempts.count else { return "" }
        return attempts[currentIndex].sentence
    }

    var sentencesPassed: Int {
        attempts.filter(\.passed).count
    }

    var sessionPassed: Bool {
        sentencesPassed >= sentencesNeededToPass
    }

    // MARK: - Mutations

    /// Record the result of the current sentence. Does not advance.
    func recordAttempt(userAnswer: String, passed: Bool) {
        guard currentIndex < attempts.count else { return }
        attempts[currentIndex].userAnswer = userAnswer
        attempts[currentIndex].passed = passed
        attempts[currentIndex].attempted = true
    }

    /// Move to the next sentence, or finish the session if the last sentence was
    /// just attempted.
    func advance() {
        guard !isFinished else { return }
        if currentIndex < attempts.count - 1 {
            currentIndex += 1
        } else {
            isFinished = true
        }
    }

    /// Reset the session with a fresh set of sentences (e.g. "Try Again" after session end).
    func restart(with sentences: [String]) {
        attempts = sentences.map { Attempt(sentence: $0) }
        currentIndex = 0
        isFinished = false
    }
}
