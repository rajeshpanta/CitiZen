import Foundation

/// Word-level diff + similarity for the Writing practice screen.
///
/// Uses token-level Levenshtein distance (so word **order** matters — "right to vote" !=
/// "vote to right"), which matches how a USCIS officer grades the writing test more
/// closely than the old Jaccard set-overlap logic.
///
/// Pure algorithm, no network, no AI, no external dependencies.
enum WritingDiffRenderer {

    // MARK: - Public API

    struct Diff {
        /// 0.0 = no overlap, 1.0 = perfect match. Based on token-level edit distance.
        let ratio: Double
        /// Expected sentence broken into tokens (user-visible, preserves original casing).
        let expectedTokens: [String]
        /// For each index in `expectedTokens`, true if that word (case-insensitive) was
        /// matched by the user at the corresponding position in the longest common
        /// subsequence. False means the user missed or reordered the word.
        let expectedMatches: [Bool]
        /// Count of expected words that the user got right (sum of true values above).
        let wordsCorrect: Int
    }

    /// Length-aware pass threshold. Longer USCIS sentences get proportionally more
    /// forgiveness — matching officer leniency: a single typo should pass even on a
    /// 3- or 4-word sentence, and two small slips on a 7–9-word sentence should also
    /// pass when meaning is preserved.
    ///
    /// - Very short (0–3 tokens): 0.65 (lets 1 error on 3-word pass: 2/3 = 0.667).
    /// - Short (4–6 tokens): 0.75 (1 error on 4-word; 1–2 on 5/6-word).
    /// - Medium (7–9 tokens): 0.70 (lets 2 errors on 7-word pass: 5/7 = 0.714).
    /// - Long (10+ tokens): 0.65 (lets 3 errors on 10-word pass: 7/10 = 0.70).
    static func passThreshold(expectedTokenCount: Int) -> Double {
        switch expectedTokenCount {
        case 0...3:   return 0.65
        case 4...6:   return 0.75
        case 7...9:   return 0.70
        default:      return 0.65
        }
    }

    /// Produce the diff between the expected sentence and the user's input.
    static func diff(expected: String, input: String) -> Diff {
        let expTokens = tokenize(preserveCase: true, expected)
        let userTokensLC = tokenize(preserveCase: false, input)
        let expTokensLC  = expTokens.map { $0.lowercased() }

        let distance = editDistance(expTokensLC, userTokensLC)
        let denom = max(expTokensLC.count, userTokensLC.count, 1)
        let ratio = 1.0 - (Double(distance) / Double(denom))

        let matches = longestCommonSubsequenceMask(from: expTokensLC, into: userTokensLC)
        let correct = matches.filter { $0 }.count

        return Diff(
            ratio: ratio,
            expectedTokens: expTokens,
            expectedMatches: matches,
            wordsCorrect: correct
        )
    }

    // MARK: - Internals

    /// Normalize input: collapse abbreviations, strip punctuation, lowercase (optional),
    /// split on whitespace.
    ///
    /// Abbreviation handling: a dot BETWEEN two letters is removed (so "D.C." → "DC",
    /// "U.S.A." → "USA") — this matches how a USCIS officer accepts "DC" for "D.C." in
    /// writing. Dots at word boundaries (e.g. "Mr. Smith" or end-of-sentence) are left
    /// alone so normal punctuation stripping handles them.
    private static func tokenize(preserveCase: Bool, _ s: String) -> [String] {
        let abbrevCollapsed = s.replacingOccurrences(
            of: #"([A-Za-z])\.(?=[A-Za-z])"#,
            with: "$1",
            options: .regularExpression
        )
        let cleaned = abbrevCollapsed.unicodeScalars.map { scalar -> Character in
            if CharacterSet.alphanumerics.contains(scalar) || scalar == " " {
                return Character(scalar)
            }
            return " "
        }
        let joined = String(cleaned)
        let finalized = preserveCase ? joined : joined.lowercased()
        return finalized
            .split(separator: " ", omittingEmptySubsequences: true)
            .map(String.init)
    }

    /// Classic Levenshtein edit distance on arrays (insert/delete/substitute = cost 1).
    private static func editDistance(_ a: [String], _ b: [String]) -> Int {
        let n = a.count
        let m = b.count
        if n == 0 { return m }
        if m == 0 { return n }

        var prev = Array(0...m)
        var curr = Array(repeating: 0, count: m + 1)

        for i in 1...n {
            curr[0] = i
            for j in 1...m {
                let cost = a[i - 1] == b[j - 1] ? 0 : 1
                curr[j] = min(
                    prev[j] + 1,         // delete
                    curr[j - 1] + 1,     // insert
                    prev[j - 1] + cost   // substitute
                )
            }
            swap(&prev, &curr)
        }
        return prev[m]
    }

    /// Returns a Bool mask the same length as `expected`. `true` at index i means
    /// `expected[i]` is part of the longest common subsequence with `actual` — i.e.
    /// the user wrote that word AND it appears in the correct relative order.
    private static func longestCommonSubsequenceMask(
        from expected: [String],
        into actual: [String]
    ) -> [Bool] {
        let n = expected.count
        let m = actual.count
        if n == 0 { return [] }
        if m == 0 { return Array(repeating: false, count: n) }

        // Standard LCS DP table.
        var dp = Array(
            repeating: Array(repeating: 0, count: m + 1),
            count: n + 1
        )
        for i in 1...n {
            for j in 1...m {
                if expected[i - 1] == actual[j - 1] {
                    dp[i][j] = dp[i - 1][j - 1] + 1
                } else {
                    dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
                }
            }
        }

        // Walk the table backward to mark which expected indices are part of the LCS.
        var mask = Array(repeating: false, count: n)
        var i = n
        var j = m
        while i > 0 && j > 0 {
            if expected[i - 1] == actual[j - 1] {
                mask[i - 1] = true
                i -= 1
                j -= 1
            } else if dp[i - 1][j] >= dp[i][j - 1] {
                i -= 1
            } else {
                j -= 1
            }
        }
        return mask
    }
}
