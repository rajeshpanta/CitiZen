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
///
/// Storage is keyed by `"<locale>::<questionID>"` so a user studying in
/// multiple languages doesn't have one language's mistakes poisoning the
/// other's readiness — failing `q_1_01` in Spanish (`es-ES::q_1_01`) is a
/// completely separate record from passing it in English (`en-US::q_1_01`),
/// even though both share the underlying question ID.
///
/// All public read APIs are language-scoped. The raw `records` dict is still
/// `@Published` for SwiftUI invalidation, but views should NEVER read keys
/// directly — use `record(for:language:)` / `recordsForLanguage(_:)` /
/// `masteredCount(for:)` etc. so the per-language scoping stays honest.
final class QuestionTracker: ObservableObject {

    static let shared = QuestionTracker()

    private let defaults = UserDefaults.standard

    /// New per-language storage key. The format change is what bumped the
    /// version: keys are `"<locale>::<questionID>"` rather than bare IDs.
    private static let storageKey = "pm_questionHistory_v2"
    /// Pre-v2 storage. Read once at init for migration, then deleted.
    private static let legacyStorageKey = "pm_questionHistory"

    /// Composite-key store: `"<locale>::<questionID>"` → record. Don't read
    /// keys directly from views — go through the per-language helpers below.
    @Published private(set) var records: [String: QuestionRecord]

    private init() {
        // Prefer v2 storage. If absent, migrate any pre-v2 records under
        // the user's preferred language (set during onboarding) — that's
        // the only safe assumption: existing users were studying in one
        // language, and tagging their existing progress with that language
        // preserves their mastery state in the language they were using.
        // English fallback for users who somehow have no preferred
        // language set (very rare — only if they skipped onboarding).
        if let data = UserDefaults.standard.data(forKey: Self.storageKey),
           let decoded = try? JSONDecoder().decode([String: QuestionRecord].self, from: data) {
            records = decoded
        } else if let oldData = UserDefaults.standard.data(forKey: Self.legacyStorageKey),
                  let oldDecoded = try? JSONDecoder().decode([String: QuestionRecord].self, from: oldData) {
            let inferredLocale = UserDefaults.standard.string(forKey: "pm_preferredLanguage") ?? "en-US"
            var migrated: [String: QuestionRecord] = [:]
            for (qid, record) in oldDecoded {
                migrated[Self.compositeKey(qid: qid, lang: inferredLocale)] = record
            }
            records = migrated
            // Persist in new format, and only remove the legacy key AFTER a
            // successful write. If encode/persist fails, leave the legacy
            // key in place so the migration can retry on next launch —
            // wiping it unconditionally would lose the user's entire
            // pre-v2 history if the v2 write didn't land.
            if let data = try? JSONEncoder().encode(migrated) {
                UserDefaults.standard.set(data, forKey: Self.storageKey)
                UserDefaults.standard.removeObject(forKey: Self.legacyStorageKey)
            }
        } else {
            records = [:]
        }

        // Fold any legacy Traditional-Chinese (zh-TW) records into the
        // canonical zh-CN bucket. Earlier builds tagged Traditional-variant
        // answers with the TTS locale "zh-TW", but every read path keys off
        // zh-CN, so that progress was invisible. Recover it so returning
        // 繁體 learners keep their mastery / review history.
        let twKeys = records.keys.filter { $0.hasPrefix("zh-TW::") }
        if !twKeys.isEmpty {
            for twKey in twKeys {
                guard let tw = records[twKey] else { continue }
                let qid = String(twKey.dropFirst("zh-TW::".count))
                let cnKey = "zh-CN::\(qid)"
                records[cnKey] = records[cnKey].map { Self.merge($0, tw) } ?? tw
                records[twKey] = nil
            }
            save()
        }
    }

    // MARK: - Composite key helper

    /// Canonicalize a locale to its record bucket. Simplified and Traditional
    /// Chinese (`zh-CN` / `zh-TW`) are ONE learner over ONE question bank, so
    /// they share a bucket — otherwise answers given with the Traditional
    /// toggle (TTS locale `zh-TW`) would be written to a key no readiness /
    /// review path ever reads (those all key off `AppLanguage.chinese` ==
    /// `zh-CN`), silently nullifying a 繁體 learner's progress.
    private static func canonicalLocale(_ lang: String) -> String {
        lang.hasPrefix("zh") ? "zh-CN" : lang
    }

    private static func compositeKey(qid: String, lang: String) -> String {
        "\(canonicalLocale(lang))::\(qid)"
    }

    /// Merge two records for the same question (used when folding a legacy
    /// `zh-TW` record into its canonical `zh-CN` bucket).
    private static func merge(_ a: QuestionRecord, _ b: QuestionRecord) -> QuestionRecord {
        var r = QuestionRecord()
        r.attempts = a.attempts + b.attempts
        r.correct = a.correct + b.correct
        // Use the streak from whichever record was attempted MORE RECENTLY, not
        // max(): consecutiveCorrect is path-dependent (reset to 0 on any wrong
        // answer), so max() could resurrect a streak the user no longer has and
        // wrongly mark a freshly-missed question as mastered / hide it from review.
        r.consecutiveCorrect = (a.lastAttempted ?? .distantPast) >= (b.lastAttempted ?? .distantPast)
            ? a.consecutiveCorrect : b.consecutiveCorrect
        r.lastAttempted = [a.lastAttempted, b.lastAttempted].compactMap { $0 }.max()
        r.lastCorrect = [a.lastCorrect, b.lastCorrect].compactMap { $0 }.max()
        return r
    }

    // MARK: - Record an answer

    /// Record an answered question for the given language. `language`
    /// should be the locale code in use when the question was answered
    /// (`en-US`, `es-ES`, `ne-NP`, `zh-CN`/`zh-TW`) so a Spanish learner
    /// who toggles a quiz to English mid-session has those English
    /// answers correctly bucketed under English instead of Spanish.
    func recordAnswer(questionID: String, language: String, correct: Bool) {
        guard !questionID.isEmpty else { return }
        let key = Self.compositeKey(qid: questionID, lang: language)
        var record = records[key] ?? QuestionRecord()
        record.attempts += 1
        record.lastAttempted = Date()

        if correct {
            record.correct += 1
            record.lastCorrect = Date()
            record.consecutiveCorrect += 1
        } else {
            record.consecutiveCorrect = 0
        }

        records[key] = record
        save()
    }

    // MARK: - Per-language queries

    /// Per-question record scoped to one language. Returns nil if the
    /// user has never answered this question in that language — even if
    /// they've answered it in another language.
    func record(for questionID: String, language: String) -> QuestionRecord? {
        records[Self.compositeKey(qid: questionID, lang: language)]
    }

    /// All records for one language, returned with bare question IDs as
    /// keys (matching the pre-v2 shape, so consumers like
    /// `SpacedRepetitionEngine.dueQuestions` can take it without any
    /// awareness of the per-language storage layout).
    func recordsForLanguage(_ language: String) -> [String: QuestionRecord] {
        let prefix = "\(Self.canonicalLocale(language))::"
        var out: [String: QuestionRecord] = [:]
        for (key, record) in records where key.hasPrefix(prefix) {
            let qid = String(key.dropFirst(prefix.count))
            out[qid] = record
        }
        return out
    }

    /// Number of questions mastered (≥3 consecutive correct) in this
    /// language's bucket.
    ///
    /// Pass `inPool` to restrict the count to questions still present in the
    /// current question bank. This matters after a question-bank migration
    /// (e.g., English moved from the legacy 75-question layout to the 2025
    /// 128-question USCIS bank): old records under the old IDs would
    /// otherwise inflate the mastered count even though those questions
    /// no longer appear in the pool. Without `inPool`, returns the raw
    /// record-level count (suitable for telemetry that wants historical
    /// totals, not per-pool readiness).
    func masteredCount(for language: String, inPool pool: [UnifiedQuestion]? = nil) -> Int {
        let prefix = "\(Self.canonicalLocale(language))::"
        let validIDs = pool.map { Set($0.map(\.id)) }
        return records.reduce(0) { acc, entry in
            guard entry.key.hasPrefix(prefix), entry.value.consecutiveCorrect >= 3 else { return acc }
            if let validIDs {
                let qid = String(entry.key.dropFirst(prefix.count))
                guard validIDs.contains(qid) else { return acc }
            }
            return acc + 1
        }
    }

    /// Number of questions attempted but not yet mastered in this language.
    /// See `masteredCount(for:inPool:)` for `inPool` semantics.
    func learningCount(for language: String, inPool pool: [UnifiedQuestion]? = nil) -> Int {
        let prefix = "\(Self.canonicalLocale(language))::"
        let validIDs = pool.map { Set($0.map(\.id)) }
        return records.reduce(0) { acc, entry in
            guard entry.key.hasPrefix(prefix),
                  entry.value.attempts > 0,
                  entry.value.consecutiveCorrect < 3 else { return acc }
            if let validIDs {
                let qid = String(entry.key.dropFirst(prefix.count))
                guard validIDs.contains(qid) else { return acc }
            }
            return acc + 1
        }
    }

    /// Per-language overall accuracy as a 0–100 integer percentage.
    /// Returns 0 if the user has never answered any question in this
    /// language. Used by `ReadinessView`'s streak/accuracy summary so
    /// the figure shown actually reflects the language being viewed.
    func accuracyPercentage(for language: String, inPool pool: [UnifiedQuestion]? = nil) -> Int {
        let prefix = "\(Self.canonicalLocale(language))::"
        let validIDs = pool.map { Set($0.map(\.id)) }
        var attempts = 0, correct = 0
        for (key, record) in records where key.hasPrefix(prefix) {
            if let validIDs {
                let qid = String(key.dropFirst(prefix.count))
                guard validIDs.contains(qid) else { continue }
            }
            attempts += record.attempts
            correct += record.correct
        }
        guard attempts > 0 else { return 0 }
        return (correct * 100) / attempts
    }

    // MARK: - Persistence

    private func save() {
        if let data = try? JSONEncoder().encode(records) {
            defaults.set(data, forKey: Self.storageKey)
        }
    }
}
