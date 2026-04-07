import Foundation

/// A single quiz question that can hold text and options in one or more languages.
///
/// - English questions have 1 variant (index 0 = English).
/// - Nepali/Spanish questions have 2 variants (0 = English, 1 = target language).
/// - Chinese questions have 3 variants (0 = English, 1 = Simplified, 2 = Traditional).
///
/// The quiz view picks which variant to display based on the user's language toggle.
struct UnifiedQuestion {
    let correctAnswer: Int
    let variants: [Variant]

    struct Variant {
        let text: String
        let options: [String]
    }
}
