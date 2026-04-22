import Foundation

/// Simple spaced repetition scheduler based on consecutive correct answers.
/// Questions with fewer consecutive correct answers are due sooner.
enum SpacedRepetitionEngine {

    /// Intervals in days based on consecutive correct count.
    /// 0 correct → always due, 1 → 1 day, 2 → 3 days, 3 → 7 days, 4+ → 30 days.
    private static let intervals: [Int] = [0, 1, 3, 7, 30]

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
            let streak = record.consecutiveCorrect
            let intervalDays = streak < intervals.count
                ? intervals[streak]
                : intervals.last!

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
            let streak = record.consecutiveCorrect
            let intervalDays = streak < intervals.count
                ? intervals[streak]
                : intervals.last!
            let daysSince = now.timeIntervalSince(lastCorrect) / 86400
            return daysSince >= Double(intervalDays) ? count + 1 : count
        }
    }
}
