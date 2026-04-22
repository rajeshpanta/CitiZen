import SwiftUI

/// Branded result card designed to be rendered as a shareable image.
struct ShareCardView: View {
    let score: Int
    let total: Int
    let passed: Bool
    let streak: Int

    private var pct: Int {
        total > 0 ? (score * 100) / total : 0
    }

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Text("CitiZen")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "flag.fill")
                    .foregroundColor(.blue)
            }

            Divider().background(Color.white.opacity(0.3))

            // Score
            VStack(spacing: 8) {
                Text(passed ? "PASSED" : "KEEP PRACTICING")
                    .font(.headline)
                    .foregroundColor(passed ? .green : .orange)

                Text("\(score)/\(total)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)

                Text("\(pct)% Score")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }

            if streak > 1 {
                HStack(spacing: 6) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("\(streak)-day streak")
                        .font(.caption.bold())
                        .foregroundColor(.orange)
                }
            }

            Divider().background(Color.white.opacity(0.3))

            Text("Preparing for U.S. Citizenship with CitiZen")
                .font(.caption)
                .foregroundColor(.white.opacity(0.5))
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .frame(width: 340)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(
                    colors: [Color(red: 0, green: 0.1, blue: 0.35), Color.black],
                    startPoint: .top, endPoint: .bottom
                ))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
    }

    /// Renders this view to a UIImage for sharing.
    @MainActor
    func renderImage() -> UIImage? {
        let renderer = ImageRenderer(content: self)
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage
    }
}
