//
//  PracticeSelectionView.swift
//

import SwiftUI

// MARK: – Helper struct to bundle each destination
private struct PracticeItem: Identifiable {
    let id        = UUID()
    let title     : String
    let view      : AnyView
    let minHeight : CGFloat
    let fontSize  : CGFloat
}

struct PracticeSelectionView: View {
    let language: AppLanguage

    private var items: [PracticeItem] {
        switch language {
        case .english:
            return [
                PracticeItem(title: "Practice 1 – Very Easy",
                             view: AnyView(QuizView(config: .english(questions: EnglishQuestions.practice1))),
                             minHeight: 20, fontSize: 16),
                PracticeItem(title: "Practice 2 – Easy",
                             view: AnyView(QuizView(config: .english(questions: EnglishQuestions.practice2))),
                             minHeight: 25, fontSize: 18),
                PracticeItem(title: "Practice 3 – Medium ",
                             view: AnyView(QuizView(config: .english(questions: EnglishQuestions.practice3))),
                             minHeight: 30, fontSize: 20),
                PracticeItem(title: "Practice 4 – Hard",
                             view: AnyView(QuizView(config: .english(questions: EnglishQuestions.practice4))),
                             minHeight: 35, fontSize: 22),
                PracticeItem(title: "Practice 5 – Problamatic",
                             view: AnyView(QuizView(config: .english(questions: EnglishQuestions.practice5))),
                             minHeight: 40, fontSize: 24)
            ]

        case .nepali:
            return [
                PracticeItem(title: "पहिलो अभ्यास – सजिलो प्रश्नहरू",
                             view: AnyView(QuizView(config: .nepali(questions: NepaliQuestions.practice1))),
                             minHeight: 20, fontSize: 16),
                PracticeItem(title: "दोस्रो अभ्यास – सजिलो प्रश्नहरू",
                             view: AnyView(QuizView(config: .nepali(questions: NepaliQuestions.practice2))),
                             minHeight: 25, fontSize: 18),
                PracticeItem(title: "तेस्रो अभ्यास – मध्यम प्रश्नहरू",
                             view: AnyView(QuizView(config: .nepali(questions: NepaliQuestions.practice3))),
                             minHeight: 30, fontSize: 20),
                PracticeItem(title: "चौथो अभ्यास – कठिन प्रश्नहरू",
                             view: AnyView(QuizView(config: .nepali(questions: NepaliQuestions.practice4))),
                             minHeight: 35, fontSize: 22),
                PracticeItem(title: "पाँचौं अभ्यास – अति कठिन प्रश्नहरू",
                             view: AnyView(QuizView(config: .nepali(questions: NepaliQuestions.practice5))),
                             minHeight: 40, fontSize: 24)
            ]

        case .spanish:
            return [
                PracticeItem(title: "Práctica 1 – Preguntas fáciles",
                             view: AnyView(QuizView(config: .spanish(questions: SpanishQuestions.practice1))),
                             minHeight: 20, fontSize: 16),
                PracticeItem(title: "Práctica 2 – Preguntas fáciles",
                             view: AnyView(QuizView(config: .spanish(questions: SpanishQuestions.practice2))),
                             minHeight: 25, fontSize: 18),
                PracticeItem(title: "Práctica 3 – Preguntas intermedias",
                             view: AnyView(QuizView(config: .spanish(questions: SpanishQuestions.practice3))),
                             minHeight: 30, fontSize: 20),
                PracticeItem(title: "Práctica 4 – Preguntas difíciles",
                             view: AnyView(QuizView(config: .spanish(questions: SpanishQuestions.practice4))),
                             minHeight: 35, fontSize: 22),
                PracticeItem(title: "Práctica 5 – Preguntas muy difíciles",
                             view: AnyView(QuizView(config: .spanish(questions: SpanishQuestions.practice5))),
                             minHeight: 40, fontSize: 24)
            ]

        case .chinese:
            return [
                PracticeItem(title: "练习 1 – 简单问题",
                             view: AnyView(QuizView(config: .chinese(questions: ChineseQuestions.practice1))),
                             minHeight: 20, fontSize: 16),
                PracticeItem(title: "练习 2 – 简单问题",
                             view: AnyView(QuizView(config: .chinese(questions: ChineseQuestions.practice2))),
                             minHeight: 25, fontSize: 18),
                PracticeItem(title: "练习 3 – 中等问题",
                             view: AnyView(QuizView(config: .chinese(questions: ChineseQuestions.practice3))),
                             minHeight: 30, fontSize: 20),
                PracticeItem(title: "练习 4 – 困难问题",
                             view: AnyView(QuizView(config: .chinese(questions: ChineseQuestions.practice4))),
                             minHeight: 35, fontSize: 22),
                PracticeItem(title: "练习 5 – 最难问题",
                             view: AnyView(QuizView(config: .chinese(questions: ChineseQuestions.practice5))),
                             minHeight: 40, fontSize: 24)
            ]
        }
    }

    // MARK: – Language‐specific UI

    private var pageTitle: String {
        switch language {
        case .english: return "Pick A Practice Set 👇🏻"
        case .nepali:  return "आफ्नो अभ्यास छान्नुहोस् 👇🏻"
        case .spanish: return "Elige tu práctica 👇🏻"
        case .chinese: return "选择你的练习👇🏻"
        }
    }

    private var navTitle: String {
        switch language {
        case .english: return "Practice Selection"
        case .nepali:  return "अभ्यास छनोट"
        case .spanish: return "Selección de práctica"
        case .chinese: return "选择你的练习"
        }
    }

    private var backgroundAsset: String {
        language == .chinese ? "USAChina" : "BackgroundImage"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Header
                Text(pageTitle)
                    .multilineTextAlignment(.center)
                    .font(.title).bold()
                    .foregroundColor(.white)
                    .padding(.top, 20)

                // Buttons
                ForEach(items) { item in
                    NavigationLink(
                            destination:
                                item.view
                                    .navigationTitle(item.title)                   // ← Dynamic title here
                                    .navigationBarTitleDisplayMode(.inline)
                        )  {
                        Text(item.title)
                            .font(.system(size: item.fontSize, weight: .bold))
                            .frame(maxWidth: .infinity, minHeight: item.minHeight)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }

                Spacer().frame(height: 50)
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle(navTitle)
        .background(
            Image(backgroundAsset)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.8))
        )
    }
}
