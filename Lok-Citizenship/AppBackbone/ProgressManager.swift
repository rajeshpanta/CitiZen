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

    /// Level (1–5) recommended to the user based on onboarding placement quiz.
    /// PracticeSelectionView highlights this level with a "Recommended" badge.
    /// Nil when no recommendation has been saved.
    var recommendedLevel: Int? {
        get {
            let stored = defaults.integer(forKey: "pm_recommendedLevel")
            return stored > 0 ? stored : nil
        }
        set { defaults.set(newValue ?? 0, forKey: "pm_recommendedLevel") }
    }

    // ─────────────────────────────────────────────────────────────
    // MARK: - Recently-used test sentences (M4: dedup across sessions)
    // ─────────────────────────────────────────────────────────────

    /// Keeps the last `capacity` sentence IDs used in a reading/writing test session.
    /// Used to avoid immediately repeating the same sentences across back-to-back
    /// sessions. Capped so the pool can't get fully exhausted.
    private static let recentSentenceHistoryCapacity = 10

    var recentReadingSentenceIDs: [String] {
        get { defaults.stringArray(forKey: "pm_recentReadingSentenceIDs") ?? [] }
        set {
            let trimmed = Array(newValue.suffix(Self.recentSentenceHistoryCapacity))
            defaults.set(trimmed, forKey: "pm_recentReadingSentenceIDs")
        }
    }

    var recentWritingSentenceIDs: [String] {
        get { defaults.stringArray(forKey: "pm_recentWritingSentenceIDs") ?? [] }
        set {
            let trimmed = Array(newValue.suffix(Self.recentSentenceHistoryCapacity))
            defaults.set(trimmed, forKey: "pm_recentWritingSentenceIDs")
        }
    }

    func rememberReadingSentences(_ ids: [String]) {
        recentReadingSentenceIDs = recentReadingSentenceIDs + ids
    }

    func rememberWritingSentences(_ ids: [String]) {
        recentWritingSentenceIDs = recentWritingSentenceIDs + ids
    }

    // ─────────────────────────────────────────────────────────────
    // MARK: - Reading & Writing test progress (F6)
    //
    // Session-level counters: one increment per completed 3-sentence session.
    // Pass/fail follows USCIS rules (session passes if ≥ 1 of 3 sentences correct).
    // Shown on ReadinessView to give users a sense of their R/W readiness over time.
    // ─────────────────────────────────────────────────────────────

    var readingTestsTaken: Int {
        get { defaults.integer(forKey: "pm_readingTestsTaken") }
        set { defaults.set(newValue, forKey: "pm_readingTestsTaken") }
    }

    var readingTestsPassed: Int {
        get { defaults.integer(forKey: "pm_readingTestsPassed") }
        set { defaults.set(newValue, forKey: "pm_readingTestsPassed") }
    }

    var writingTestsTaken: Int {
        get { defaults.integer(forKey: "pm_writingTestsTaken") }
        set { defaults.set(newValue, forKey: "pm_writingTestsTaken") }
    }

    var writingTestsPassed: Int {
        get { defaults.integer(forKey: "pm_writingTestsPassed") }
        set { defaults.set(newValue, forKey: "pm_writingTestsPassed") }
    }

    /// Record the outcome of one completed Reading Test session.
    /// Safe to call exactly once per session — view callers guard with a flag.
    func recordReadingTestSession(passed: Bool) {
        readingTestsTaken += 1
        if passed { readingTestsPassed += 1 }
    }

    /// Record the outcome of one completed Writing Test session.
    func recordWritingTestSession(passed: Bool) {
        writingTestsTaken += 1
        if passed { writingTestsPassed += 1 }
    }

    /// Pass rate as a 0–100 integer percentage; `nil` if no sessions taken yet.
    var readingTestPassRatePercent: Int? {
        guard readingTestsTaken > 0 else { return nil }
        return (readingTestsPassed * 100) / readingTestsTaken
    }

    var writingTestPassRatePercent: Int? {
        guard writingTestsTaken > 0 else { return nil }
        return (writingTestsPassed * 100) / writingTestsTaken
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
