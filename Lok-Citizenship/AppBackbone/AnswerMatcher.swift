import Foundation

/// Matches a spoken transcription against a list of quiz options.
/// Two-stage: a normalized token-overlap local match, then an optional GPT fallback.
enum AnswerMatcher {

    /// Best-effort match. Tries local normalization first (fast, offline).
    /// If no confident local match and an OpenAI key is set, asks GPT.
    /// Returns the matched option index, or nil if no confident match.
    static func match(spoken: String,
                      options: [String],
                      question: String) async -> Int? {
        let trimmed = spoken.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !options.isEmpty else { return nil }

        if let local = localMatch(spoken: trimmed, options: options) {
            return local
        }
        if let remote = await gptMatch(spoken: trimmed, options: options, question: question) {
            return remote
        }
        return nil
    }

    // MARK: - Local match (token overlap with number words normalized)

    static func localMatch(spoken: String, options: [String]) -> Int? {
        let sTokens = tokenize(spoken)
        guard !sTokens.isEmpty else { return nil }

        var best: (idx: Int, score: Double)?
        for (idx, option) in options.enumerated() {
            let oTokens = tokenize(option)
            guard !oTokens.isEmpty else { continue }
            let score = jaccard(sTokens, oTokens)
            if score >= 0.5 {
                if best == nil || score > best!.score {
                    best = (idx, score)
                }
            }
        }
        return best?.idx
    }

    private static let stopwords: Set<String> = [
        "the", "a", "an", "of", "to", "is", "are", "and", "or", "in",
        "for", "on", "at", "by", "with", "it", "its", "this", "that"
    ]

    private static let wordToNumber: [String: String] = [
        "zero": "0", "one": "1", "two": "2", "three": "3", "four": "4",
        "five": "5", "six": "6", "seven": "7", "eight": "8", "nine": "9",
        "ten": "10", "eleven": "11", "twelve": "12", "thirteen": "13",
        "fourteen": "14", "fifteen": "15", "sixteen": "16", "seventeen": "17",
        "eighteen": "18", "nineteen": "19", "twenty": "20", "thirty": "30",
        "forty": "40", "fifty": "50", "sixty": "60", "seventy": "70",
        "eighty": "80", "ninety": "90", "hundred": "100"
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

    private static func jaccard(_ a: Set<String>, _ b: Set<String>) -> Double {
        let intersect = a.intersection(b).count
        let union = a.union(b).count
        guard union > 0 else { return 0 }
        return Double(intersect) / Double(union)
    }

    // MARK: - GPT match

    static func gptMatch(spoken: String, options: [String], question: String) async -> Int? {
        let raw = UserDefaults.standard.string(forKey: "openai_api_key") ?? ""
        let key = raw.trimmingCharacters(in: .whitespaces)
        guard !key.isEmpty else { return nil }

        let optionLines = options.enumerated()
            .map { "\($0.offset): \($0.element)" }
            .joined(separator: "\n")
        let prompt = """
        A user is answering a multiple-choice civics question by voice. Pick the option that best matches what they said.

        Question: \(question)
        Options:
        \(optionLines)

        User said: "\(spoken)"

        Rules:
        - Be liberal: "biden" matches "Joe Biden", "four" matches "4 years", "washington" matches "George Washington", "fifty" matches "50".
        - If the user's speech clearly doesn't match any option, answer -1.
        - If ambiguous between two options, answer -1.
        Respond with a single integer (the option index, or -1). No other text.
        """

        var req = URLRequest(url: URL(string: "https://api.openai.com/v1/chat/completions")!)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        req.timeoutInterval = 6

        let body: [String: Any] = [
            "model": "gpt-4o-mini",
            "temperature": 0,
            "max_tokens": 5,
            "messages": [
                ["role": "user", "content": prompt]
            ]
        ]
        req.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (data, response) = try await URLSession.shared.data(for: req)
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                return nil
            }
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let choices = json["choices"] as? [[String: Any]],
                  let first = choices.first,
                  let message = first["message"] as? [String: Any],
                  let content = message["content"] as? String else {
                return nil
            }
            let cleaned = content.trimmingCharacters(in: .whitespacesAndNewlines)
            if cleaned.hasPrefix("-") { return nil }
            guard let idx = Int(cleaned.prefix { $0.isNumber }),
                  idx >= 0, idx < options.count else {
                return nil
            }
            return idx
        } catch {
            return nil
        }
    }
}
