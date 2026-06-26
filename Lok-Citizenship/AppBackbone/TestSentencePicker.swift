import Foundation

/// Picks sentences for a Reading or Writing Test session, preferring sentences the
/// user hasn't seen in the last few sessions (M4: avoid back-to-back repeats).
///
/// If there aren't enough "fresh" sentences left after excluding recents, falls back
/// to the full pool — so a small pool can't starve the picker.
enum TestSentencePicker {

    /// - Parameters:
    ///   - pool: the full vocabulary pool (reading or writing).
    ///   - count: how many sentences the session needs. Default 3, matching USCIS.
    ///   - excludingRecent: sentence IDs used in recent sessions; prefer to avoid.
    /// - Returns: an array of `count` words, random but preferring fresh ones.
    static func pick(from pool: [ReadingWritingWord],
                     count: Int = 3,
                     excludingRecent recent: [String] = []) -> [ReadingWritingWord] {
        guard !pool.isEmpty else { return [] }
        let recentSet = Set(recent)
        let fresh = pool.filter { !recentSet.contains($0.id) }
        // If too many sentences have been seen recently to fill a fresh session,
        // use the whole pool — better to repeat than to fail.
        let source = fresh.count >= count ? fresh : pool
        // Deduplicate by sentence text: multiple vocabulary words can share the
        // same exampleSentence (e.g. "President" and "lives" both use
        // "The President lives in the White House."). Without this filter a
        // 3-sentence session could present the identical sentence twice, which
        // is confusing and distorts the score.
        var seenSentences = Set<String>()
        var result: [ReadingWritingWord] = []
        for word in source.shuffled() {
            guard result.count < count else { break }
            if seenSentences.insert(word.exampleSentence).inserted {
                result.append(word)
            }
        }
        // Fallback: if dedup exhausted the pool before filling `count`,
        // top up from any remaining words (duplicates allowed at this point).
        if result.count < count {
            let picked = Set(result.map(\.id))
            for word in pool.shuffled() where !picked.contains(word.id) {
                result.append(word)
                if result.count >= count { break }
            }
        }
        return result
    }
}
