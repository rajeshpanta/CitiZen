import SwiftUI

struct LanguageSelectionView: View {
    private let columns = [GridItem(.adaptive(minimum: 145), spacing: 16)]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.0, green: 0.12, blue: 0.35),
                    Color(red: 0.0, green: 0.06, blue: 0.2),
                    Color.black
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Choose Your Language")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                        Text("Practice in your native language")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding(.top, 20)

                    // Language cards
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(AppLanguage.allCases) { lang in
                            NavigationLink {
                                PracticeSelectionView(language: lang)
                                    .onAppear {
                                        Analytics.track(.languageSelected(language: lang.rawValue))
                                    }
                            } label: {
                                VStack(spacing: 10) {
                                    Text(lang.flag)
                                        .font(.system(size: 44))

                                    Text(lang.displayName)
                                        .font(.headline)
                                        .foregroundColor(.white)

                                    Text(englishName(for: lang))
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.45))
                                }
                                .frame(maxWidth: .infinity, minHeight: 130)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.08))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)

                    Spacer().frame(height: 30)
                }
            }
        }
        .navigationTitle("Language")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func englishName(for lang: AppLanguage) -> String {
        switch lang {
        case .english: return "English"
        case .nepali:  return "Nepali"
        case .spanish: return "Spanish"
        case .chinese: return "Chinese"
        }
    }
}
