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

    /// for STT
    var sttLocale: String {
        switch self {
        case .english: return "en-US"
        case .nepali:  return "ne-NP"  // or "hi-IN" if you prefer
        case .spanish: return "es-ES"
        case .chinese: return "zh-CN"
        }
    }
}
