// LanguageSelectionView.swift
import SwiftUI

struct LanguageSelectionView: View {
    private let columns = [GridItem(.adaptive(minimum: 130), spacing: 24)]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 24) {
                ForEach(AppLanguage.allCases) { lang in
                    NavigationLink {
                        PracticeSelectionView(language: lang)   // ➜ step 2
                    } label: {
                        VStack(spacing: 12) {
                            Text(lang.flag).font(.system(size: 48))
                            Text(lang.displayName)
                                .font(.title3).bold()
                        }
                        .frame(maxWidth: .infinity, minHeight: 140)
                        .background(Color.green.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(18)
                    }
                }
            }
            .padding(32)
        }
        .navigationTitle("Choose Language")
        .background(
            Image("BackgroundImage")
                .resizable().scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.85))
        )
    }
}
