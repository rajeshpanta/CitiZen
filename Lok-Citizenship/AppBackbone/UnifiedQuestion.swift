import Foundation

/// A single quiz question that can hold text and options in one or more languages.
///
/// - English questions have 1 variant (index 0 = English).
/// - Nepali/Spanish questions have 2 variants (0 = English, 1 = target language).
/// - Chinese questions have 3 variants (0 = English, 1 = Simplified, 2 = Traditional).
///
/// The quiz view picks which variant to display based on the user's language toggle.
/// Safe array subscript that returns nil instead of crashing on out-of-bounds.
extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

struct UnifiedQuestion {
    let id: String
    let correctAnswer: Int
    let variants: [Variant]

    struct Variant {
        let text: String
        let options: [String]
        let explanation: String

        init(text: String, options: [String], explanation: String = "") {
            self.text = text
            self.options = options
            self.explanation = explanation
        }
    }

    /// Question IDs whose correct answer can change as real-world officeholders
    /// change (President, Vice President, Speaker of the House, Chief Justice).
    /// Views use `isTimeSensitive` to render a small disclaimer pointing users
    /// to uscis.gov/citizenship for the current answer. Kept as a central set
    /// so question data files stay untouched.
    ///
    /// All four supported languages (English, Spanish, Chinese, Nepali) use
    /// the official 2025 USCIS question numbers (`q_25_NNN`). The legacy
    /// `q_1_NN` / `q_3_NN` / `q_4_NN` IDs are retained here for backward
    /// compatibility with any user tracker records persisted before the
    /// migration — they no longer appear in any active question file but
    /// won't hurt to keep in the set.
    static let timeSensitiveIDs: Set<String> = [
        // Legacy IDs (retained for backward compatibility with old tracker records)
        "q_1_08", "q_1_09", "q_3_05", "q_4_10",
        // 2025 USCIS official question numbers (active across all languages)
        "q_25_030",  // Speaker of the House
        "q_25_038",  // President
        "q_25_039",  // Vice President
        "q_25_057",  // Chief Justice
        // 2008 USCIS 100-question track officeholder questions
        "q_08_028",  // President
        "q_08_029",  // Vice President
        "q_08_040",  // Chief Justice
        "q_08_046",  // President's political party
        "q_08_047",  // Speaker of the House
    ]

    /// True when the correct answer depends on current officeholders.
    var isTimeSensitive: Bool { Self.timeSensitiveIDs.contains(id) }
}
