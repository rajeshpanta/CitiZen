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
// MARK: - Supabase Analytics (Production)
// ═════════════════════════════════════════════════════════════════

/// Posts each event to a Supabase `analytics_events` table over REST.
/// Zero new dependencies — reuses the existing `SupabaseConfig` URL
/// and anon key already used by the Whisper edge function.
///
/// All events are fire-and-forget background POSTs. Network failures
/// are silently dropped — analytics must never break the app or
/// surface as a user-visible failure.
///
/// Privacy: events carry only the anonymous `DeviceID.current`
/// (Keychain-stored UUID, not linkable to any third party). Per
/// Apple's ATT definition, this is not "tracking" — the paywall's
/// "No ads, no tracking" claim remains defensible.
///
/// ─────────────────────────────────────────────────────────────────
/// One-time Supabase setup (run once in the SQL Editor):
///
///     CREATE TABLE analytics_events (
///         id BIGSERIAL PRIMARY KEY,
///         event_name TEXT NOT NULL,
///         properties JSONB,
///         device_id TEXT,
///         app_version TEXT,
///         platform TEXT,
///         created_at TIMESTAMPTZ DEFAULT now()
///     );
///     ALTER TABLE analytics_events ENABLE ROW LEVEL SECURITY;
///     CREATE POLICY "anon insert" ON analytics_events
///         FOR INSERT TO anon WITH CHECK (true);
///     CREATE INDEX idx_analytics_events_name_created
///         ON analytics_events (event_name, created_at DESC);
///
/// That's it — the table is now write-only for the public anon key.
/// Reads use your service-role key in the SQL Editor for analysis.
/// ─────────────────────────────────────────────────────────────────
final class SupabaseAnalytics: AnalyticsTracking {

    private let endpoint: URL
    private let session: URLSession
    private let appVersion: String

    init() {
        self.endpoint = SupabaseConfig.url.appendingPathComponent("rest/v1/analytics_events")
        let config = URLSessionConfiguration.default
        // Short timeout — analytics is best-effort. If the network is
        // slow we'd rather drop the event than queue up a backlog of
        // long-running requests during a user's quiz session.
        config.timeoutIntervalForRequest = 5
        config.timeoutIntervalForResource = 10
        self.session = URLSession(configuration: config)

        let v = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "?"
        let b = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "?"
        self.appVersion = "\(v) (\(b))"
    }

    func track(_ event: AnalyticsEvent) {
        // Snapshot the event into a value type before the async hop so
        // we don't pull any unexpected references across the boundary.
        let name = event.name
        let props = event.properties
        let deviceID = DeviceID.current
        let version = appVersion
        let url = endpoint
        let apikey = SupabaseConfig.anonKey
        let urlSession = session

        Task.detached(priority: .background) {
            await Self.send(
                url: url,
                apikey: apikey,
                session: urlSession,
                name: name,
                props: props,
                deviceID: deviceID,
                version: version
            )
        }
    }

    private static func send(
        url: URL,
        apikey: String,
        session: URLSession,
        name: String,
        props: [String: String],
        deviceID: String,
        version: String
    ) async {
        let payload: [String: Any] = [
            "event_name": name,
            "properties": props,
            "device_id": deviceID,
            "app_version": version,
            "platform": "ios",
            // Explicit app tag for the shared `analytics_events` table
            // (also written to by Semora). The DB column has a default
            // of `'citizen'`, so technically this is redundant — but
            // sending it explicitly protects against the unlikely
            // scenario where someone changes the default later. Mirrors
            // how Semora's analytics writer explicitly sends 'semora'.
            "app_name": "citizen"
        ]
        guard let body = try? JSONSerialization.data(withJSONObject: payload) else { return }

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue(apikey, forHTTPHeaderField: "apikey")
        req.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        // `return=minimal` tells PostgREST not to echo the inserted row
        // back, which saves bandwidth on a write-only table.
        req.setValue("return=minimal", forHTTPHeaderField: "Prefer")
        req.httpBody = body

        // Silent failure is the contract — analytics never surfaces a
        // user-visible error. _ = on `try?` is intentional.
        _ = try? await session.data(for: req)
    }
}

// ═════════════════════════════════════════════════════════════════
// MARK: - Analytics Singleton
// ═════════════════════════════════════════════════════════════════

/// Global access point. The backend is selected at init based on
/// build configuration and whether Supabase credentials are present:
///
///   - DEBUG builds: `ConsoleAnalytics` (prints to console, no
///     network). Prevents dev sessions from polluting production
///     analytics. Override `Analytics.shared.backend` manually if
///     you want to test the Supabase path end-to-end.
///   - Release with Supabase configured: `SupabaseAnalytics`.
///   - Release without Supabase: `ConsoleAnalytics`, which is a
///     no-op in release (its body is `#if DEBUG`-gated).
final class Analytics {
    static let shared = Analytics()
    var backend: AnalyticsTracking
    private init() {
        #if DEBUG
        self.backend = ConsoleAnalytics()
        #else
        if SupabaseConfig.isConfigured {
            self.backend = SupabaseAnalytics()
        } else {
            self.backend = ConsoleAnalytics()
        }
        #endif
    }

    static func track(_ event: AnalyticsEvent) {
        shared.backend.track(event)
    }
}
