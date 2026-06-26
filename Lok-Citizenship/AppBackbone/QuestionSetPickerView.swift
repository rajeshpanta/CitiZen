import SwiftUI

/// Full-screen modal shown once to existing users (upgraded from a prior build
/// that lacked the 100-question track). New users see the equivalent step inside
/// OnboardingView instead. After the user picks, `pm_hasChosenQuestionSet` is set
/// true and this modal never appears again.
struct QuestionSetPickerView: View {
    let language: AppLanguage
    let onConfirm: (ProgressManager.QuestionSet) -> Void

    @State private var selectedSet: ProgressManager.QuestionSet = ProgressManager.shared.questionSet
    @State private var appeared = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.0, green: 0.10, blue: 0.30),
                    Color(red: 0.0, green: 0.05, blue: 0.18),
                    Color.black
                ],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Spacer(minLength: 32)

                    // Icon
                    ZStack {
                        Circle()
                            .fill(Color.cyan.opacity(0.12))
                            .frame(width: 100, height: 100)
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 44))
                            .foregroundColor(.cyan)
                    }
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)
                    .animation(.easeOut(duration: 0.5), value: appeared)

                    Text(headline)
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 20)
                        .animation(.easeOut(duration: 0.5).delay(0.10), value: appeared)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 28)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 20)
                        .animation(.easeOut(duration: 0.5).delay(0.18), value: appeared)

                    Spacer().frame(height: 4)

                    // Two track cards
                    VStack(spacing: 14) {
                        trackCard(
                            set: .set2008,
                            icon: "checkmark.seal.fill",
                            iconColor: .green,
                            title: title100,
                            badge: badgeRecommended,
                            badgeColor: .green,
                            description: desc100,
                            detail: detail100,
                            animationDelay: 0.28
                        )

                        trackCard(
                            set: .set2020,
                            icon: "books.vertical.fill",
                            iconColor: .purple,
                            title: title128,
                            badge: badgeComprehensive,
                            badgeColor: .purple,
                            description: desc128,
                            detail: detail128,
                            animationDelay: 0.40
                        )
                    }
                    .padding(.horizontal, 20)

                    // Note about switching later
                    HStack(spacing: 6) {
                        Image(systemName: "info.circle")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.35))
                        Text(switchNote)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.45))
                    }
                    .padding(.horizontal, 28)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.52), value: appeared)

                    Spacer(minLength: 16)

                    Button {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        ProgressManager.shared.questionSet = selectedSet
                        ProgressManager.shared.hasChosenQuestionSet = true
                        onConfirm(selectedSet)
                    } label: {
                        Text(continueLabel)
                            .font(.headline.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 54)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(LinearGradient(
                                        colors: [.blue, .blue.opacity(0.75)],
                                        startPoint: .leading, endPoint: .trailing))
                            )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 36)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.60), value: appeared)
                }
            }
            .scrollIndicators(.hidden)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { appeared = true }
        }
    }

    // MARK: - Track card

    private func trackCard(
        set: ProgressManager.QuestionSet,
        icon: String,
        iconColor: Color,
        title: String,
        badge: String,
        badgeColor: Color,
        description: String,
        detail: String,
        animationDelay: Double
    ) -> some View {
        let isSelected = selectedSet == set
        return Button {
            UISelectionFeedbackGenerator().selectionChanged()
            withAnimation(.spring(response: 0.3)) { selectedSet = set }
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(iconColor)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.headline.bold())
                            .foregroundColor(.white)
                        Text(detail)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.55))
                    }
                    Spacer()
                    Text(badge)
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(badgeColor)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(badgeColor.opacity(0.15)))
                        .overlay(Capsule().stroke(badgeColor.opacity(0.4), lineWidth: 1))
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundColor(isSelected ? .cyan : .white.opacity(0.3))
                }
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.70))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.cyan.opacity(0.08) : Color.white.opacity(0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.cyan.opacity(0.5) : Color.white.opacity(0.1),
                            lineWidth: isSelected ? 1.5 : 1)
            )
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .animation(.easeOut(duration: 0.5).delay(animationDelay), value: appeared)
    }

    // MARK: - Localized copy

    private var headline: String {
        switch language {
        case .english: return "One New Feature"
        case .nepali:  return "एउटा नयाँ सुविधा"
        case .spanish: return "Una nueva función"
        case .chinese: return "一项新功能"
        }
    }
    private var subtitle: String {
        switch language {
        case .english: return "CitiZen now supports both the 100-question and 128-question test banks. Which set would you like to study?"
        case .nepali:  return "CitiZen ले अब १०० र १२८ दुवै प्रश्न बैंकहरू समर्थन गर्छ। तपाईं कुन सेट पढ्न चाहनुहुन्छ?"
        case .spanish: return "CitiZen ahora admite bancos de 100 y 128 preguntas. ¿Cuál quieres estudiar?"
        case .chinese: return "CitiZen现在支持100题和128题两种题库。你想学习哪一套？"
        }
    }
    private var title100: String {
        switch language {
        case .english: return "100 Questions"
        case .nepali:  return "१०० प्रश्नहरू"
        case .spanish: return "100 preguntas"
        case .chinese: return "100道题"
        }
    }
    private var detail100: String {
        switch language {
        case .english: return "10 sets · 10 questions each · Pass 6/10"
        case .nepali:  return "१० सेट · प्रत्येक १० प्रश्न · ६/१० पास"
        case .spanish: return "10 sets · 10 preguntas cada uno · Pasa 6/10"
        case .chinese: return "10组 · 每组10题 · 通过需6/10"
        }
    }
    private var desc100: String {
        switch language {
        case .english: return "The current official USCIS civics test. Each practice set mirrors the real interview: 10 questions, pass 6 out of 10."
        case .nepali:  return "वर्तमान आधिकारिक USCIS नागरिकता परीक्षा। प्रत्येक अभ्यास सेट वास्तविक अन्तर्वार्ता जस्तै: १० प्रश्न, १० मध्ये ६ पास।"
        case .spanish: return "El examen cívico oficial actual de USCIS. Cada set de práctica imita la entrevista real: 10 preguntas, pasa 6 de 10."
        case .chinese: return "目前USCIS官方公民考试。每组练习模拟真实面试：10题，通过需答对6道。"
        }
    }
    private var title128: String {
        switch language {
        case .english: return "128 Questions"
        case .nepali:  return "१२८ प्रश्नहरू"
        case .spanish: return "128 preguntas"
        case .chinese: return "128道题"
        }
    }
    private var detail128: String {
        switch language {
        case .english: return "8 sets · 16 questions each · Practice mode"
        case .nepali:  return "८ सेट · प्रत्येक १६ प्रश्न · अभ्यास मोड"
        case .spanish: return "8 sets · 16 preguntas cada uno · Modo práctica"
        case .chinese: return "8组 · 每组16题 · 练习模式"
        }
    }
    private var desc128: String {
        switch language {
        case .english: return "A broader 128-question bank for deep preparation. 8 thematic practice levels covering every topic area in detail."
        case .nepali:  return "गहन तयारीको लागि व्यापक १२८-प्रश्न बैंक। ८ विषयगत स्तरहरूमा हरेक विषय विस्तृत।"
        case .spanish: return "Un banco de 128 preguntas más amplio para una preparación profunda. 8 niveles temáticos que cubren cada área en detalle."
        case .chinese: return "包含128道题的广泛题库，深度备考。8个主题级别，全面涵盖各知识领域。"
        }
    }
    private var badgeRecommended: String {
        switch language {
        case .english: return "RECOMMENDED"
        case .nepali:  return "सिफारिश"
        case .spanish: return "RECOMENDADO"
        case .chinese: return "推荐"
        }
    }
    private var badgeComprehensive: String {
        switch language {
        case .english: return "COMPREHENSIVE"
        case .nepali:  return "व्यापक"
        case .spanish: return "COMPLETO"
        case .chinese: return "全面"
        }
    }
    private var switchNote: String {
        switch language {
        case .english: return "You can switch study tracks anytime in Settings"
        case .nepali:  return "तपाईं सेटिङ्समा जुनसुकै बेला ट्र्याक परिवर्तन गर्न सक्नुहुन्छ"
        case .spanish: return "Puedes cambiar la ruta de estudio en Ajustes en cualquier momento"
        case .chinese: return "你可以随时在设置中切换学习方向"
        }
    }
    private var continueLabel: String {
        switch language {
        case .english: return "Start Studying"
        case .nepali:  return "अध्ययन सुरु गर्नुहोस्"
        case .spanish: return "Empezar a estudiar"
        case .chinese: return "开始学习"
        }
    }
}
