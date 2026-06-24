import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en-US"
    case nepali  = "ne-NP"
    case spanish = "es-ES"
    case chinese = "zh-CN"

    var id: String { rawValue }

    var flag: String {
        switch self {
        case .english: return "🇺🇸"
        case .nepali:  return "🇳🇵"
        case .spanish: return "🇪🇸"
        case .chinese: return "🇨🇳"
        }
    }

    var displayName: String {
        switch self {
        case .english: return "English"
        case .nepali:  return "नेपाली"
        case .spanish: return "Español"
        case .chinese: return "中文"
        }
    }

    /// for TTS
    var ttsLocale: String { rawValue }

    var englishName: String {
        switch self {
        case .english: return "English"
        case .nepali:  return "Nepali"
        case .spanish: return "Spanish"
        case .chinese: return "Chinese"
        }
    }
}
