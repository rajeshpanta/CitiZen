import SwiftUI

/// Defers construction of a wrapped view until it actually renders.
///
/// `NavigationLink(destination:)` evaluates its destination as part of the
/// parent's body, which means every body re-render of the list view
/// constructs every destination — even ones the user never visits. For
/// destinations whose `init` does real work (allocates services, registers
/// notification observers, opens an audio engine), that's wasted CPU on
/// throwaway instances that SwiftUI immediately discards behind
/// `@StateObject`.
///
/// Wrapping the destination in `LazyView { Heavy() }` (or via the
/// `@autoclosure` init: `LazyView(Heavy())`) postpones the inner view's
/// construction until SwiftUI evaluates `LazyView.body` — which only
/// happens when the link is actually pushed.
struct LazyView<Content: View>: View {
    private let build: () -> Content

    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }

    init(@ViewBuilder _ build: @escaping () -> Content) {
        self.build = build
    }

    var body: Content { build() }
}
