import Foundation
import os

/// Matches a spoken transcription against a list of quiz options.
///
/// Two-tier matcher tuned for ESL speakers preparing for the U.S. citizenship test:
///
/// 1. **Local scoring** combines two signals:
///    - **Jaccard token overlap** (catches paraphrases with shared words).
///    - **Character trigram similarity** (catches mispronunciations and STT slips —
///      "constitushun" → "constitution", "wepublic" → "republic").
///    The combined score is the max of the two.
///
/// 2. **GPT fallback** via the `/match` Edge Function. Triggered when the local
///    score doesn't clearly favor a single option. Tuned to reward understanding,
///    not literal wording.
///
/// Decision rule (in order):
///  - Local score ≥ 0.7 with margin ≥ 0.15 over the runner-up → commit locally.
///  - Otherwise, ask GPT (12s timeout).
///  - GPT returns a matched index → commit it.
///  - GPT explicitly says "no match" → return nil (don't second-guess — GPT
///    can read paraphrasing the local scorer can't, so its rejection is
///    authoritative).
///  - GPT unavailable (network/server error) → fall back to the best local
///    candidate if it's at least 0.5 (graceful offline behavior).
///  - Otherwise → nil (genuinely no match).
///
/// The 3-state GPT result is what makes "GPT says no" different from "GPT
/// can't be reached" — the old code returned `Int?` for both cases and the
/// caller couldn't tell them apart, which let the offline fallback
/// false-positive low-confidence local matches over GPT's explicit reject.
enum AnswerMatcher {

    /// 3-state outcome of the GPT round trip. Lets callers distinguish
    /// "GPT explicitly rejected" (authoritative no-match) from "GPT couldn't
    /// be reached" (try the offline fallback).
    enum GPTMatchResult {
        case matched(Int)
        case rejected
        case unavailable
    }

    private static let log = Logger(subsystem: "com.citizen.app", category: "AnswerMatcher")

    /// Local score required to commit without consulting GPT.
    private static let highConfidence = 0.7
    /// Required margin between best and runner-up for a confident local commit.
    private static let confidenceMargin = 0.15
    /// Minimum local score to accept as a fallback when GPT is unavailable.
    private static let offlineFallbackMin = 0.5
    /// Trigram weight relative to Jaccard. Slightly discounted because trigrams
    /// can produce noise (incidental character overlap between unrelated phrases).
    private static let trigramWeight = 0.9

    /// Best-effort match. Local-first, GPT fallback, offline graceful degradation.
    /// Returns the matched option index, or nil if no plausible match.
    static func match(spoken: String,
                      options: [String],
                      question: String) async -> Int? {
        let trimmed = spoken.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !options.isEmpty else { return nil }

        let scored = scoredCandidates(spoken: trimmed, options: options)
        let best = scored.first
        let runnerUp = scored.dropFirst().first
        let margin = (best?.score ?? 0) - (runnerUp?.score ?? 0)

        if let best, best.score >= highConfidence, margin >= confidenceMargin {
            log.info("local commit idx=\(best.idx) score=\(best.score) margin=\(margin)")
            return best.idx
        }

        // Below the confident-commit bar — let GPT have a look. The /match prompt
        // is ESL-tuned and handles paraphrase + pronunciation cases the local
        // scorer misses.
        if SupabaseConfig.isConfigured {
            switch await gptMatch(spoken: trimmed, options: options, question: question) {
            case .matched(let idx):
                log.info("gpt commit idx=\(idx)")
                return idx
            case .rejected:
                // GPT looked at the answer and decided no option matches.
                // Trust it — GPT reads paraphrases the local scorer misses,
                // so its "no" is more reliable than a fuzzy local trigram
                // overlap. Skip the offline fallback in this case.
                log.info("gpt rejected; honoring as no-match")
                return nil
            case .unavailable:
                log.info("gpt unavailable; trying offline fallback")
                // fall through to offline fallback below
            }
        }

        // Offline / GPT-unreachable path: take the best local candidate if it's
        // at least minimally plausible. Better to give a partial-credit answer
        // than dead-end an offline user with a half-decent attempt.
        if let best, best.score >= offlineFallbackMin {
            log.info("offline fallback idx=\(best.idx) score=\(best.score)")
            return best.idx
        }

        log.info("no match; best score=\(best?.score ?? 0)")
        return nil
    }

    /// Returns the best local candidate above the offline-fallback threshold (0.5),
    /// or nil. Kept as a thin convenience for callers that only want the offline
    /// behavior. Most code should call `match(...)` instead.
    static func localMatch(spoken: String, options: [String]) -> Int? {
        let trimmed = spoken.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !options.isEmpty else { return nil }
        guard let best = scoredCandidates(spoken: trimmed, options: options).first,
              best.score >= offlineFallbackMin else { return nil }
        return best.idx
    }

    /// Returns the best local candidate's index, score, and the runner-up's
    /// score (0 when there's only one option). Lets callers like
    /// `WhisperSTTService` apply their own confidence + margin policy without
    /// re-running the scorer.
    static func localScore(spoken: String, options: [String]) -> (idx: Int, score: Double, runnerUp: Double)? {
        let trimmed = spoken.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !options.isEmpty else { return nil }
        let scored = scoredCandidates(spoken: trimmed, options: options)
        guard let best = scored.first else { return nil }
        let runnerUp = scored.dropFirst().first?.score ?? 0
        return (best.idx, best.score, runnerUp)
    }

    // MARK: - Scoring

    private struct Candidate { let idx: Int; let score: Double }

    private static func scoredCandidates(spoken: String, options: [String]) -> [Candidate] {
        let sTokens = tokenize(spoken)
        let sTrigrams = trigrams(spoken.lowercased())

        var results: [Candidate] = []
        results.reserveCapacity(options.count)
        for (idx, option) in options.enumerated() {
            let oTokens = tokenize(option)
            let oTrigrams = trigrams(option.lowercased())

            let jacc = jaccard(sTokens, oTokens)
            let tri = jaccard(sTrigrams, oTrigrams)
            // Take the max of the two signals. Either a strong word-level overlap
            // OR a strong character-level overlap is enough to count.
            let score = max(jacc, tri * trigramWeight)
            results.append(Candidate(idx: idx, score: score))
        }
        return results.sorted { $0.score > $1.score }
    }

    // MARK: - Token-level normalization

    /// Filler words that don't carry meaning in answer matching. Stripping them
    /// keeps the Jaccard denominator small for verbose ESL phrasings like
    /// "I think the answer is George Washington" → {george, washington}.
    private static let stopwords: Set<String> = [
        // Articles & prepositions
        "the", "a", "an", "of", "to", "in", "for", "on", "at", "by", "with",
        "from", "into", "onto", "upon", "about", "as",
        // Conjunctions / connectors
        "and", "or", "but", "so", "if", "then", "also", "because",
        // Auxiliary / copular verbs
        "is", "am", "are", "was", "were", "be", "been", "being",
        "have", "has", "had", "do", "does", "did",
        "can", "could", "would", "should", "may", "might", "will", "shall",
        // Pronouns (filler in answers)
        "i", "you", "he", "she", "we", "they", "me", "him", "her", "us", "them",
        "my", "your", "his", "our", "their", "its",
        // Demonstratives / fillers
        "it", "this", "that", "these", "those", "there", "here",
        // Question words (rarely in answers, but ESL filler echoes)
        "what", "who", "where", "when", "why", "how", "which",
        // Common ESL hedges
        "think", "know", "guess", "maybe", "really", "just",
    ]

    /// Number-word → digit normalization. Lets "twenty-seven" tokens partially
    /// align with the digit form "27" — though the GPT prompt is the
    /// authoritative source for compound numbers like "twenty seven" → "27".
    private static let wordToNumber: [String: String] = [
        "zero": "0", "one": "1", "two": "2", "three": "3", "four": "4",
        "five": "5", "six": "6", "seven": "7", "eight": "8", "nine": "9",
        "ten": "10", "eleven": "11", "twelve": "12", "thirteen": "13",
        "fourteen": "14", "fifteen": "15", "sixteen": "16", "seventeen": "17",
        "eighteen": "18", "nineteen": "19", "twenty": "20", "thirty": "30",
        "forty": "40", "fifty": "50", "sixty": "60", "seventy": "70",
        "eighty": "80", "ninety": "90", "hundred": "100",
    ]

    private static func tokenize(_ text: String) -> Set<String> {
        let lowered = text.lowercased()
        let strippedChars = lowered.unicodeScalars.map { s -> Character in
            if CharacterSet.alphanumerics.contains(s) { return Character(s) }
            return " "
        }
        let stripped = String(strippedChars)
        let words = stripped.split(separator: " ").map { String($0) }
        let mapped = words.map { wordToNumber[$0] ?? $0 }
        return Set(mapped.filter { !stopwords.contains($0) && !$0.isEmpty })
    }

    // MARK: - Character trigram normalization

    /// Character trigrams over a normalized form of the input. Pads with spaces
    /// so word-boundary trigrams are captured (helps short single-word options
    /// like "Adams" stand out against "Madison").
    private static func trigrams(_ text: String) -> Set<String> {
        let cleanedChars = text.unicodeScalars.map { s -> Character in
            if CharacterSet.alphanumerics.contains(s) { return Character(s) }
            return " "
        }
        // Collapse runs of spaces and pad with a single space on each side.
        let collapsed = String(cleanedChars)
            .split(separator: " ", omittingEmptySubsequences: true)
            .joined(separator: " ")
        guard !collapsed.isEmpty else { return [] }
        let padded = " \(collapsed) "
        let chars = Array(padded)
        guard chars.count >= 3 else { return [] }

        var grams: Set<String> = []
        grams.reserveCapacity(chars.count - 2)
        for i in 0...(chars.count - 3) {
            grams.insert(String(chars[i..<i + 3]))
        }
        return grams
    }

    // MARK: - Set similarity

    private static func jaccard<T: Hashable>(_ a: Set<T>, _ b: Set<T>) -> Double {
        if a.isEmpty || b.isEmpty { return 0 }
        let intersect = a.intersection(b).count
        let union = a.union(b).count
        guard union > 0 else { return 0 }
        return Double(intersect) / Double(union)
    }

    // MARK: - GPT match (cloud-routed)

    /// Calls our `/match` edge function, which proxies to gpt-4o-mini with an
    /// ESL-favorable prompt. Used as the fallback when the local score isn't
    /// confidently above the commit threshold.
    ///
    /// Returns:
    /// - `.matched(idx)` — GPT picked an option (idx is bounds-checked)
    /// - `.rejected` — GPT explicitly returned `{"index": null}`. The caller
    ///   should NOT fall back to a fuzzy local match — GPT had access to the
    ///   full paraphrase context and decided no option fits.
    /// - `.unavailable` — request failed (network, timeout, non-200, malformed
    ///   response). Caller should try the offline fallback.
    static func gptMatch(spoken: String, options: [String], question: String) async -> GPTMatchResult {
        guard SupabaseConfig.isConfigured else { return .unavailable }

        let endpoint = SupabaseConfig.url
            .appendingPathComponent("functions/v1/match")
        var req = URLRequest(url: endpoint)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue(SupabaseConfig.anonKey, forHTTPHeaderField: "apikey")
        req.setValue("Bearer \(SupabaseConfig.anonKey)", forHTTPHeaderField: "Authorization")
        req.setValue(DeviceID.current, forHTTPHeaderField: "X-Device-Id")
        // Aligned with the server-side OpenAI timeout (15s). Previously 8s, which
        // dropped slow-but-valid GPT responses client-side.
        req.timeoutInterval = 12

        let body: [String: Any] = [
            "spoken": spoken,
            "options": options,
            "question": question,
        ]
        req.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (data, response) = try await URLSession.shared.data(for: req)
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                let code = (response as? HTTPURLResponse)?.statusCode ?? -1
                log.error("gpt http status=\(code)")
                return .unavailable
            }
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                log.error("gpt response not JSON")
                return .unavailable
            }
            // The function returns {"index": N} or {"index": null}. Distinguish
            // explicit null (NSNull from JSONSerialization) from missing key:
            //  - integer in range  → matched
            //  - explicit null     → rejected (authoritative no-match)
            //  - missing / weird   → unavailable (treat as malformed → fallback)
            if let idx = json["index"] as? Int, idx >= 0, idx < options.count {
                return .matched(idx)
            }
            if json["index"] is NSNull {
                return .rejected
            }
            log.error("gpt response missing or invalid 'index' field")
            return .unavailable
        } catch {
            log.error("gpt request failed: \(String(describing: error))")
            return .unavailable
        }
    }
}
