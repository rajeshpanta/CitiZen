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

// MARK: - Rating prompt scheduling
//
// Strategy: ask for a review at the moment of peak satisfaction. Each
// user has a different "wow" moment — some love passing mock interviews,
// others love mastering practice levels, others love building streaks.
// So we have 5 distinct trigger points and ask at the FIRST occurrence
// of each. iOS caps `requestReview()` at 3 displays per 365 days per
// user (silently no-ops past that), so 5 trigger candidates × first-
// occurrence-only × a global 120-day floor between any two prompts
// naturally fits within Apple's quota while maximising the chance we
// catch each user at their personal peak.
//
// Why a separate enum (not a method on ProgressManager): the rating
// gate is policy, not progress. ProgressManager owns user-progress
// state; this owns when-to-nag state. Keeping them separated avoids
// `ProgressManager.recordX()` accidentally growing review side effects.
enum RatingPrompt {
    private static let defaults = UserDefaults.standard
    private static let lastRequestKey = "rp_lastRequestDate"
    private static let minDaysBetweenPrompts: TimeInterval = 120 * 24 * 3600

    /// All meaningful satisfaction events the app can request a review
    /// on. Each case has its own UserDefaults key so the "first time
    /// this specific journey delighted the user" moment is captured
    /// even if a different trigger already fired earlier in the user's
    /// lifetime. The raw values double as the UserDefaults keys.
    enum Trigger: String {
        case mockInterviewPassed   = "rp_trigger_mockPassed"
        case practiceLevelMastered = "rp_trigger_levelMastered"
        case readingTestPassed     = "rp_trigger_readingPassed"
        case writingTestPassed     = "rp_trigger_writingPassed"
        case threeDayStreak        = "rp_trigger_streak3"
    }

    /// Call when one of the `Trigger` events fires (mock pass, level
    /// mastered, etc.). Returns true if the calling view should now
    /// invoke `@Environment(\.requestReview)`.
    ///
    /// Returns true only when ALL of:
    ///   1. This is the FIRST time this specific trigger has fired
    ///      for this user (so we never re-prompt for the same journey).
    ///   2. We're outside the global 120-day cooldown from the last
    ///      prompt we asked for (any trigger).
    ///
    /// Side effects: the trigger's first-occurrence flag and the
    /// last-request stamp are ONLY written when the function returns
    /// true (i.e., when the prompt actually fires). This is important:
    /// if a trigger fires during another trigger's cooldown, it must
    /// remain available for a future call so the user still gets a
    /// chance to be prompted at that journey's peak moment after the
    /// cooldown lifts.
    @discardableResult
    static func shouldPrompt(for trigger: Trigger) -> Bool {
        // First-occurrence check. If we've already asked for THIS
        // trigger, never ask for it again — we want to catch the
        // peak moment for that journey, not nag every time it
        // recurs.
        guard !defaults.bool(forKey: trigger.rawValue) else { return false }

        // Global cooldown. iOS itself caps displays at 3 per 365
        // days; without our own floor, the 3 would fire in the
        // first week and leave the rest of the year empty.
        // Return WITHOUT consuming the trigger flag — see the doc
        // comment above. Otherwise a trigger that happens to hit
        // during another trigger's cooldown would be permanently
        // lost, even if its journey recurs months later.
        if let last = defaults.object(forKey: lastRequestKey) as? Date,
           Date().timeIntervalSince(last) < minDaysBetweenPrompts {
            return false
        }

        // Both gates passed — consume the trigger AND stamp the
        // cooldown clock. Order matters less here since both writes
        // succeed together, but doing them only on the success path
        // keeps the "fairness" guarantee in the doc comment intact.
        defaults.set(true, forKey: trigger.rawValue)
        defaults.set(Date(), forKey: lastRequestKey)
        return true
    }
}
