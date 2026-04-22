import SwiftUI
import UIKit                           // ← NEW: needed for UIColor

@main
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
