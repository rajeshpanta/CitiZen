import SwiftUI
import UIKit                           // ← NEW: needed for UIColor

@main
struct Lok_CitizenshipApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    // ─────────────────────────────────────────────────────────────
    /// Force all navigation-bar titles to render in white
    /// (works for both inline and large titles)
    init() {                          // ← NEW BLOCK
        let attrs: [NSAttributedString.Key : Any] = [
            .foregroundColor : UIColor.white
        ]
        UINavigationBar.appearance().titleTextAttributes      = attrs
        UINavigationBar.appearance().largeTitleTextAttributes = attrs
    }
    // ─────────────────────────────────────────────────────────────

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
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
