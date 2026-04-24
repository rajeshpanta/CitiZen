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
    static let timeSensitiveIDs: Set<String> = ["q_1_08", "q_1_09", "q_3_05", "q_4_10"]

    /// True when the correct answer depends on current officeholders.
    var isTimeSensitive: Bool { Self.timeSensitiveIDs.contains(id) }
}
