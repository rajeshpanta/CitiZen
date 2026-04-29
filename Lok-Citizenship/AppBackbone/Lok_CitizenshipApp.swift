import SwiftUI
import UIKit                           // ← NEW: needed for UIColor

// `@MainActor`: this struct reads `@MainActor`-isolated singletons
// (`ProgressManager.shared.hasCompletedOnboarding`, `.preferredLanguage`)
// from non-isolated property initializers and the `body` closure. Under
// Swift 5 default checking this compiles because SwiftUI's App struct
// runs on main implicitly, but Swift 6 strict concurrency would reject
// it. Annotating the struct itself makes the actor isolation explicit
// and future-proofs the file. SwiftUI App protocol conformance is
// MainActor-compatible (the system always runs `init` and `body` on
// main), so this changes nothing at runtime.
@main
@MainActor
struct Lok_CitizenshipApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @State private var hasCompletedOnboarding = ProgressManager.shared.hasCompletedOnboarding

    /// Resolve saved language preference to AppLanguage enum. Falls back to English.
    private var savedLanguage: AppLanguage {
        guard let raw = ProgressManager.shared.preferredLanguage,
              let lang = AppLanguage(rawValue: raw) else { return .english }
        return lang
    }

    // ─────────────────────────────────────────────────────────────
    /// Force all navigation-bar titles to render in white
    init() {
        let attrs: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor.white
        ]
        UINavigationBar.appearance().titleTextAttributes      = attrs
        UINavigationBar.appearance().largeTitleTextAttributes = attrs

        // Trim the OpenAI TTS MP3 cache once per launch. The cache key
        // is `model|voice|text`, so every unique question / option /
        // answer-feedback string accumulates an MP3 forever. Across
        // four languages this can grow into hundreds of MB without
        // any user-visible bound. iOS would eventually purge under
        // disk pressure, but capping at launch is cheaper and avoids
        // App Review flags.
        //
        // Detached at utility priority so the directory enumeration +
        // per-file `removeItem` calls don't block SwiftUI's first paint
        // on cold launch with a saturated cache. Safe to race with
        // later TTS playback because `trimCache` only deletes by mtime
        // and any file mid-playback is the freshest one (just written
        // by `fetchAndPlay`'s `data.write(to: cacheURL, ...)`).
        Task.detached(priority: .utility) {
            OpenAITTSService.trimCache()
        }
    }
    // ─────────────────────────────────────────────────────────────

    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    NavigationView {
                        PracticeSelectionView(language: savedLanguage)
                    }
                } else {
                    OnboardingView { _ in
                        hasCompletedOnboarding = true
                    }
                }
            }
            .onAppear {
                Analytics.track(.appOpened)
                NotificationManager.shared.checkAuthorization()
                if NotificationManager.shared.isEnabled {
                    NotificationManager.shared.scheduleAll()
                }
            }
        }
    }
}

// MARK: - AppDelegate (unchanged)
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    // Lock app to portrait mode
    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        .portrait          // Change to .all for full rotation support
    }
}
