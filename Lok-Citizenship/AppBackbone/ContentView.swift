import SwiftUI

struct ContentView: View {
    @State private var animate = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.0, green: 0.15, blue: 0.4),
                        Color(red: 0.0, green: 0.08, blue: 0.25),
                        Color.black
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()

                    // Flag icon
                    Text("🇺🇸")
                        .font(.system(size: 70))
                        .scaleEffect(animate ? 1.0 : 0.8)
                        .opacity(animate ? 1.0 : 0.0)

                    Spacer().frame(height: 24)

                    // App name
                    Text("CitiZen")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(animate ? 1.0 : 0.0)

                    Text("U.S. Citizenship Test Prep")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.5))
                        .padding(.top, 4)
                        .opacity(animate ? 1.0 : 0.0)

                    Spacer().frame(height: 40)

                    // Value props
                    VStack(spacing: 14) {
                        featureChip(icon: "mic.fill", text: "Practice with your voice")
                        featureChip(icon: "globe", text: "Study in 4 languages")
                        featureChip(icon: "checkmark.shield.fill", text: "300+ official civics questions")
                    }
                    .opacity(animate ? 1.0 : 0.0)

                    Spacer()

                    // CTA button
                    NavigationLink {
                        LanguageSelectionView()
                    } label: {
                        Text("Get Started")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [Color.blue, Color.blue.opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 32)
                    .opacity(animate ? 1.0 : 0.0)

                    Spacer().frame(height: 50)
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.8)) {
                    animate = true
                }
            }
        }
    }

    private func featureChip(icon: String, text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(.cyan)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}
