import Foundation

/// Simple spaced repetition scheduler based on consecutive correct answers.
/// Questions with fewer consecutive correct answers are due sooner.
enum SpacedRepetitionEngine {

    /// Intervals in days based on consecutive correct count.
    /// 0 correct → always due, 1 → 1 day, 2 → 3 days, 3 → 7 days, 4+ → 30 days.
    private static let intervals: [Int] = [0, 1, 3, 7, 30]

    /// Default interval for streaks beyond the table. Matches the final
    /// entry in `intervals` so the in-table and out-of-table paths produce
    /// the same answer at the boundary. Centralized so the two call sites
    /// (`dueQuestions`, `dueCount`) can't drift if `intervals` is ever
    /// rebalanced.
    private static let defaultInterval = 30

    /// Returns questions that are "due" for review, sorted by urgency (most overdue first).
    /// - Parameters:
    ///   - allQuestions: The full pool of questions to consider.
    ///   - records: Per-question performance data from QuestionTracker.
    ///   - limit: Maximum number of questions to return.
    /// - Returns: Questions that need review, capped at `limit`.
    static func dueQuestions(
        from allQuestions: [UnifiedQuestion],
        records: [String: QuestionRecord],
        limit: Int = 15
    ) -> [UnifiedQuestion] {
        let now = Date()

        let scored: [(question: UnifiedQuestion, urgency: Double)] = allQuestions.compactMap { q in
            guard let record = records[q.id] else {
                return nil // Never attempted — not a "mistake" to review
            }

            // Perfect mastery (3+ consecutive correct) AND not yet due
            // `max(0, ...)` is defensive — `consecutiveCorrect` is
            // only incremented or reset to 0 in current code, but a
            // corrupted UserDefaults blob or a future migration bug
            // could yield a negative value, and `intervals[-1]` is
            // a hard crash. Cheap insurance.
            let streak = max(0, record.consecutiveCorrect)
            let intervalDays = streak < intervals.count
                ? intervals[streak]
                : defaultInterval

            // If never answered correctly, always due
            guard let lastCorrect = record.lastCorrect else {
                return (q, Double.greatestFiniteMagnitude) // Most urgent
            }

            let daysSince = now.timeIntervalSince(lastCorrect) / 86400
            let overdueDays = daysSince - Double(intervalDays)

            // Only include if overdue (or never correct)
            guard overdueDays >= 0 else { return nil }

            return (q, overdueDays)
        }

        return scored
            .sorted { $0.urgency > $1.urgency }
            .prefix(limit)
            .map(\.question)
    }

    /// Returns the count of currently due questions without building the full array.
    static func dueCount(
        from allQuestions: [UnifiedQuestion],
        records: [String: QuestionRecord]
    ) -> Int {
        let now = Date()
        return allQuestions.reduce(0) { count, q in
            guard let record = records[q.id] else { return count }
            guard let lastCorrect = record.lastCorrect else {
                return count + 1 // Never correct → due
            }
            // `max(0, ...)` is defensive — `consecutiveCorrect` is
            // only incremented or reset to 0 in current code, but a
            // corrupted UserDefaults blob or a future migration bug
            // could yield a negative value, and `intervals[-1]` is
            // a hard crash. Cheap insurance.
            let streak = max(0, record.consecutiveCorrect)
            let intervalDays = streak < intervals.count
                ? intervals[streak]
                : defaultInterval
            let daysSince = now.timeIntervalSince(lastCorrect) / 86400
            return daysSince >= Double(intervalDays) ? count + 1 : count
        }
    }
}
