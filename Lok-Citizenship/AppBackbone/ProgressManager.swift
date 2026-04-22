import Foundation

/// Lightweight progress tracker using UserDefaults.
/// Tracks lifetime stats and study streaks across quiz sessions.
@MainActor
final class ProgressManager {

    static let shared = ProgressManager()
    private let defaults = UserDefaults.standard
    private init() {}

    // ─────────────────────────────────────────────────────────────
    // MARK: - Lifetime Stats
    // ─────────────────────────────────────────────────────────────

    var totalQuestionsAnswered: Int {
        get { defaults.integer(forKey: "pm_totalQuestionsAnswered") }
        set { defaults.set(newValue, forKey: "pm_totalQuestionsAnswered") }
    }

    var totalCorrectAnswers: Int {
        get { defaults.integer(forKey: "pm_totalCorrectAnswers") }
        set { defaults.set(newValue, forKey: "pm_totalCorrectAnswers") }
    }

    var totalQuizzesTaken: Int {
        get { defaults.integer(forKey: "pm_totalQuizzesTaken") }
        set { defaults.set(newValue, forKey: "pm_totalQuizzesTaken") }
    }

    var totalQuizzesPassed: Int {
        get { defaults.integer(forKey: "pm_totalQuizzesPassed") }
        set { defaults.set(newValue, forKey: "pm_totalQuizzesPassed") }
    }

    // ─────────────────────────────────────────────────────────────
    // MARK: - Streak Tracking
    // ─────────────────────────────────────────────────────────────

    var currentStreak: Int {
        get { defaults.integer(forKey: "pm_currentStreak") }
        set { defaults.set(newValue, forKey: "pm_currentStreak") }
    }

    var longestStreak: Int {
        get { defaults.integer(forKey: "pm_longestStreak") }
        set { defaults.set(newValue, forKey: "pm_longestStreak") }
    }

    var lastActiveDate: Date? {
        get { defaults.object(forKey: "pm_lastActiveDate") as? Date }
        set { defaults.set(newValue, forKey: "pm_lastActiveDate") }
    }

    // ─────────────────────────────────────────────────────────────
    // MARK: - Recording Events
    // ─────────────────────────────────────────────────────────────

    /// Call this each time a user answers a question (tap or voice).
    func recordAnswer(correct: Bool) {
        totalQuestionsAnswered += 1
        if correct {
            totalCorrectAnswers += 1
        }
    }

    /// Call this when a quiz session ends (completed all questions OR failed at 4 mistakes).
    func recordQuizCompletion(passed: Bool) {
        totalQuizzesTaken += 1
        if passed { totalQuizzesPassed += 1 }
        updateStreak()
    }

    // ─────────────────────────────────────────────────────────────
    // MARK: - Streak Logic
    // ─────────────────────────────────────────────────────────────

    /// Updates the streak based on the current date vs. last active date.
    /// Same-day completions don't double-count.
    private func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        if let lastDate = lastActiveDate {
            let lastDay = calendar.startOfDay(for: lastDate)
            let dayDiff = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0

            switch dayDiff {
            case 0:
                // Same day — streak already counted, no change
                break
            case 1:
                // Consecutive day — extend streak
                currentStreak += 1
            default:
                // Gap of 2+ days — streak resets
                currentStreak = 1
            }
        } else {
            // First ever session
            currentStreak = 1
        }

        if currentStreak > longestStreak {
            longestStreak = currentStreak
        }

        lastActiveDate = Date()
    }

    // ─────────────────────────────────────────────────────────────
    // MARK: - Mock Interview Tracking
    // ─────────────────────────────────────────────────────────────

    var mockInterviewsCompleted: Int {
        get { defaults.integer(forKey: "pm_mockInterviewsCompleted") }
        set { defaults.set(newValue, forKey: "pm_mockInterviewsCompleted") }
    }

    /// Free users get 1 mock interview. After that, Pro required.
    var canAccessFreeMockInterview: Bool {
        mockInterviewsCompleted < 1
    }

    func recordMockInterviewCompleted() {
        mockInterviewsCompleted += 1
    }

    // ─────────────────────────────────────────────────────────────
    // MARK: - Onboarding (ready for future OnboardingView)
    // ─────────────────────────────────────────────────────────────

    var hasCompletedOnboarding: Bool {
        get { defaults.bool(forKey: "pm_hasCompletedOnboarding") }
        set { defaults.set(newValue, forKey: "pm_hasCompletedOnboarding") }
    }

    var interviewDate: Date? {
        get { defaults.object(forKey: "pm_interviewDate") as? Date }
        set { defaults.set(newValue, forKey: "pm_interviewDate") }
    }

    var preferredLanguage: String? {
        get { defaults.string(forKey: "pm_preferredLanguage") }
        set { defaults.set(newValue, forKey: "pm_preferredLanguage") }
    }

    // ─────────────────────────────────────────────────────────────
    // MARK: - Computed Helpers
    // ─────────────────────────────────────────────────────────────

    /// Overall accuracy as a percentage (0–100). Returns 0 if no questions answered.
    var accuracyPercentage: Int {
        guard totalQuestionsAnswered > 0 else { return 0 }
        return (totalCorrectAnswers * 100) / totalQuestionsAnswered
    }

    /// True if the streak should be considered "at risk" (last session was yesterday
    /// or earlier and no session today yet). Useful for future notifications.
    var streakAtRisk: Bool {
        guard currentStreak > 0, let lastDate = lastActiveDate else { return false }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastDay = calendar.startOfDay(for: lastDate)
        let dayDiff = calendar.dateComponents([.day], from: lastDay, to: today).day ?? 0
        return dayDiff >= 1
    }
}
