import SwiftUI

@main
struct Lok_CitizenshipApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
// AppDelegate inside the same file
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    // Lock app to portrait mode
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait // Change to .all for full rotation support
    }
}
