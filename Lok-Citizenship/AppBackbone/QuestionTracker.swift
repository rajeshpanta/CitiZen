import Foundation

/// Per-question performance record, persisted as JSON in UserDefaults.
struct QuestionRecord: Codable {
    var attempts: Int = 0
    var correct: Int = 0
    var lastAttempted: Date?
    var lastCorrect: Date?
    var consecutiveCorrect: Int = 0

    var accuracy: Double {
        guard attempts > 0 else { return 0 }
        return Double(correct) / Double(attempts)
    }
}

/// Tracks per-question performance for spaced repetition and readiness scoring.
/// Stores a `[questionID: QuestionRecord]` dictionary as JSON in UserDefaults.
final class QuestionTracker: ObservableObject {

    static let shared = QuestionTracker()

    private let defaults = UserDefaults.standard
    private let storageKey = "pm_questionHistory"

    @Published private(set) var records: [String: QuestionRecord]

    private init() {
        if let data = UserDefaults.standard.data(forKey: "pm_questionHistory"),
           let decoded = try? JSONDecoder().decode([String: QuestionRecord].self, from: data) {
            records = decoded
        } else {
            records = [:]
        }
    }

    // MARK: - Record an answer

    func recordAnswer(questionID: String, correct: Bool) {
        guard !questionID.isEmpty else { return }

        var record = records[questionID] ?? QuestionRecord()
        record.attempts += 1
        record.lastAttempted = Date()

        if correct {
            record.correct += 1
            record.lastCorrect = Date()
            record.consecutiveCorrect += 1
        } else {
            record.consecutiveCorrect = 0
        }

        records[questionID] = record
        save()
    }

    // MARK: - Queries

    /// Returns IDs of questions the user has gotten wrong (accuracy < 50%) or never answered correctly.
    func missedQuestionIDs() -> Set<String> {
        Set(records.compactMap { id, record in
            record.accuracy < 0.5 ? id : nil
        })
    }

    /// Returns the record for a specific question, or nil if never attempted.
    func record(for questionID: String) -> QuestionRecord? {
        records[questionID]
    }

    /// Number of questions mastered (3+ consecutive correct).
    var masteredCount: Int {
        records.values.filter { $0.consecutiveCorrect >= 3 }.count
    }

    /// Number of questions attempted but not yet mastered.
    var learningCount: Int {
        records.values.filter { $0.attempts > 0 && $0.consecutiveCorrect < 3 }.count
    }

    // MARK: - Persistence

    private func save() {
        if let data = try? JSONEncoder().encode(records) {
            defaults.set(data, forKey: storageKey)
        }
    }
}
