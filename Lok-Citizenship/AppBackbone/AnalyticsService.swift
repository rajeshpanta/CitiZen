import Foundation

// ═════════════════════════════════════════════════════════════════
// MARK: - Analytics Event
// ═════════════════════════════════════════════════════════════════

/// Strongly-typed analytics events. Add new cases as needed.
enum AnalyticsEvent {
    case appOpened
    case languageSelected(language: String)
    case quizStarted(mode: String, language: String, level: Int)
    case questionAnswered(correct: Bool, usedVoice: Bool, language: String)
    case quizCompleted(mode: String, score: Int, passed: Bool, language: String)
    case voiceUsed(feature: String, language: String)      // feature: "tts" or "stt"
    case voiceMatchFailed(language: String)
    case voiceTimeout(language: String)
    case paywallShown(trigger: String)
    case purchaseStarted(productID: String)
    case purchaseCompleted(productID: String)
    case purchaseFailed(productID: String)
    case purchaseRestored

    /// Flattened key-value representation for any analytics backend.
    var name: String {
        switch self {
        case .appOpened:          return "app_opened"
        case .languageSelected:   return "language_selected"
        case .quizStarted:        return "quiz_started"
        case .questionAnswered:   return "question_answered"
        case .quizCompleted:      return "quiz_completed"
        case .voiceUsed:          return "voice_used"
        case .voiceMatchFailed:   return "voice_match_failed"
        case .voiceTimeout:       return "voice_timeout"
        case .paywallShown:       return "paywall_shown"
        case .purchaseStarted:    return "purchase_started"
        case .purchaseCompleted:  return "purchase_completed"
        case .purchaseFailed:     return "purchase_failed"
        case .purchaseRestored:   return "purchase_restored"
        }
    }

    var properties: [String: String] {
        switch self {
        case .appOpened:
            return [:]
        case .languageSelected(let language):
            return ["language": language]
        case .quizStarted(let mode, let language, let level):
            return ["mode": mode, "language": language, "level": "\(level)"]
        case .questionAnswered(let correct, let usedVoice, let language):
            return ["correct": "\(correct)", "used_voice": "\(usedVoice)", "language": language]
        case .quizCompleted(let mode, let score, let passed, let language):
            return ["mode": mode, "score": "\(score)", "passed": "\(passed)", "language": language]
        case .voiceUsed(let feature, let language):
            return ["feature": feature, "language": language]
        case .voiceMatchFailed(let language):
            return ["language": language]
        case .voiceTimeout(let language):
            return ["language": language]
        case .paywallShown(let trigger):
            return ["trigger": trigger]
        case .purchaseStarted(let productID):
            return ["product_id": productID]
        case .purchaseCompleted(let productID):
            return ["product_id": productID]
        case .purchaseFailed(let productID):
            return ["product_id": productID]
        case .purchaseRestored:
            return [:]
        }
    }
}

// ═════════════════════════════════════════════════════════════════
// MARK: - Analytics Tracking Protocol
// ═════════════════════════════════════════════════════════════════

/// Abstraction for analytics dispatch. Inject into components that emit events.
/// Swap implementations for testing, logging, or a real backend (TelemetryDeck, Firebase).
protocol AnalyticsTracking {
    func track(_ event: AnalyticsEvent)
}

// ═════════════════════════════════════════════════════════════════
// MARK: - Console Analytics (Debug)
// ═════════════════════════════════════════════════════════════════

/// Prints events to console. Use during development.
/// Replace with TelemetryDeck/Firebase when ready.
final class ConsoleAnalytics: AnalyticsTracking {
    func track(_ event: AnalyticsEvent) {
        #if DEBUG
        let props = event.properties.isEmpty
            ? ""
            : " " + event.properties.map { "\($0.key)=\($0.value)" }.joined(separator: ", ")
        print("[Analytics] \(event.name)\(props)")
        #endif
    }
}

// ═════════════════════════════════════════════════════════════════
// MARK: - Analytics Singleton
// ═════════════════════════════════════════════════════════════════

/// Global access point. Swap `shared.backend` to change implementations.
final class Analytics {
    static let shared = Analytics()
    var backend: AnalyticsTracking = ConsoleAnalytics()
    private init() {}

    static func track(_ event: AnalyticsEvent) {
        shared.backend.track(event)
    }
}
