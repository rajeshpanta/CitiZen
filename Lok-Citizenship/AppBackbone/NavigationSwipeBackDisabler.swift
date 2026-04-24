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

    func makeUIView(context: Context) -> UIView {
        let v = UIView(frame: .zero)
        v.isUserInteractionEnabled = false
        v.isHidden = true  // not absorbing any layout space
        return v
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            guard let nav = uiView.owningNavigationController else { return }
            nav.interactivePopGestureRecognizer?.isEnabled = !disabled
        }
    }

    static func dismantleUIView(_ uiView: UIView, coordinator: ()) {
        // On removal, make sure we re-enable so future screens behave normally.
        DispatchQueue.main.async {
            uiView.owningNavigationController?
                .interactivePopGestureRecognizer?.isEnabled = true
        }
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
