import SwiftUI
import UIKit

/// Disables the edge-swipe-to-pop gesture on the enclosing `UINavigationController`
/// while `disabled == true`. Complements `navigationBarBackButtonHidden(true)` so
/// that BOTH the tap path and the swipe path respect the "confirm before leaving"
/// logic (see F2 — back-swipe used to bypass the Test session exit alert).
///
/// Usage: attach to the parent view as a zero-size background.
///
/// ```swift
/// .background(
///     NavigationSwipeBackDisabler(disabled: testSessionActive)
///         .frame(width: 0, height: 0)
/// )
/// ```
///
/// Re-enables the gesture automatically on view disappearance so it doesn't leak
/// into other screens in the nav stack.
struct NavigationSwipeBackDisabler: UIViewRepresentable {

    let disabled: Bool

    // Stores the nav controller so dismantleUIView can use it after the
    // view is removed from the hierarchy (at which point owningNavigationController
    // returns nil because the responder chain is already torn down).
    class Coordinator {
        weak var navController: UINavigationController?
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> UIView {
        let v = UIView(frame: .zero)
        v.isUserInteractionEnabled = false
        v.isHidden = true  // not absorbing any layout space
        return v
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // updateUIView is already called on the main thread — no dispatch needed.
        // Cache the reference on first resolve so dismantleUIView can use it.
        if let nav = uiView.owningNavigationController {
            context.coordinator.navController = nav
        }
        context.coordinator.navController?.interactivePopGestureRecognizer?.isEnabled = !disabled
    }

    static func dismantleUIView(_ uiView: UIView, coordinator: Coordinator) {
        // Use the cached weak reference — owningNavigationController is nil here
        // because the view has already been removed from the window hierarchy.
        coordinator.navController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}

private extension UIView {
    /// Walks the responder chain up to find a UINavigationController.
    var owningNavigationController: UINavigationController? {
        var responder: UIResponder? = self
        while let next = responder?.next {
            if let nav = next as? UINavigationController { return nav }
            responder = next
        }
        return nil
    }
}
