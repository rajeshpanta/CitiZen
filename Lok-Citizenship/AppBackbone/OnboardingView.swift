import SwiftUI

// ═════════════════════════════════════════════════════════════════
// MARK: - Onboarding Flow
// ═════════════════════════════════════════════════════════════════

struct OnboardingView: View {

    /// Called when onboarding completes. Passes the selected language.
    let onComplete: (AppLanguage) -> Void

    // MARK: - State

    enum Step { case language, interviewDate, quiz, results }

    @State private var step: Step = .language
    @State private var selectedLanguage: AppLanguage?
    @State private var interviewDate = Date()
    @State private var dateChoice: DateChoice = .notChosen

    enum DateChoice { case notChosen, picked, notScheduled, exploring }

    // Quiz state
    @StateObject private var quizLogic = UnifiedQuizLogic()
    @State private var selectedAnswer: Int?
    @State private var isAnswered = false
    @State private var isAnswerCorrect = false
    @State private var showFeedback = false

    // ─────────────────────────────────────────────────────────────
    // MARK: - Body
    // ─────────────────────────────────────────────────────────────

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.0, green: 0.15, blue: 0.4),
                    Color(red: 0.0, green: 0.08, blue: 0.25),
                    Color.black
                ],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            switch step {
            case .language:      languageScreen
            case .interviewDate: dateScreen
            case .quiz:          quizScreen
            case .results:       resultsScreen
            }
        }
        .animation(.easeInOut(duration: 0.3), value: step)
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: - Screen 1: Language
    // ═════════════════════════════════════════════════════════════

    private var languageScreen: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "globe")
                .font(.system(size: 46))
                .foregroundColor(.cyan)

            Text("What language\ndo you speak?")
                .font(.title.bold())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text("We'll show questions in your language")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.5))

            Spacer().frame(height: 8)

            // Language cards
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 14)], spacing: 14) {
                ForEach(AppLanguage.allCases) { lang in
                    Button {
                        withAnimation { selectedLanguage = lang; step = .interviewDate }
                    } label: {
                        VStack(spacing: 8) {
                            Text(lang.flag).font(.system(size: 36))
                            Text(lang.displayName).font(.headline).foregroundColor(.white)
                            Text(englishName(lang)).font(.caption).foregroundColor(.white.opacity(0.4))
                        }
                        .frame(maxWidth: .infinity, minHeight: 110)
                        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.08)))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.1), lineWidth: 1))
                    }
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            // Step indicator
            stepDots(current: 0)
                .padding(.bottom, 30)
        }
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: - Screen 2: Interview Date
    // ═════════════════════════════════════════════════════════════

    private var dateScreen: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 44))
                .foregroundColor(.cyan)

            Text(dateTitle)
                .font(.title2.bold())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text(dateSubtitle)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.5))

            // Date picker
            DatePicker("", selection: $interviewDate, in: Date()..., displayedComponents: .date)
                .datePickerStyle(.compact)
                .labelsHidden()
                .colorScheme(.dark)
                .padding(.horizontal, 40)
                .padding(.vertical, 8)

            // Primary: set date
            Button {
                dateChoice = .picked
                startQuiz()
            } label: {
                Text(dateSetButton)
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(14)
            }
            .padding(.horizontal, 32)

            Text(orText)
                .font(.caption)
                .foregroundColor(.white.opacity(0.3))
                .padding(.top, 4)

            // Alternative options — styled as visible cards
            VStack(spacing: 10) {
                Button {
                    dateChoice = .notScheduled
                    startQuiz()
                } label: {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.cyan)
                        Text(dateNotScheduled)
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.3))
                    }
                    .font(.subheadline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.07)))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
                }

                Button {
                    dateChoice = .exploring
                    startQuiz()
                } label: {
                    HStack {
                        Image(systemName: "eyes")
                            .foregroundColor(.cyan)
                        Text(dateExploring)
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.3))
                    }
                    .font(.subheadline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.07)))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.1), lineWidth: 1))
                }
            }
            .padding(.horizontal, 32)

            Spacer()

            stepDots(current: 1)
                .padding(.bottom, 30)
        }
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: - Screen 3: Placement Quiz
    // ═════════════════════════════════════════════════════════════

    private var quizScreen: some View {
        VStack(spacing: 16) {

            // Header
            HStack {
                Text(quizHeader)
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.6))
                Spacer()
                Text("\(quizLogic.attemptedQuestions + (isAnswered ? 0 : 0))/\(quizLogic.totalQuestions)")
                    .font(.subheadline.bold())
                    .foregroundColor(.cyan)
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)

            ProgressView(
                value: Double(quizLogic.currentQuestionIndex),
                total: Double(max(quizLogic.totalQuestions, 1))
            )
            .accentColor(.cyan)
            .padding(.horizontal, 24)

            Spacer().frame(height: 30)

            // Question
            Text(currentQuestionText)
                .font(.title3.bold())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Spacer().frame(height: 24)

            // Answer options
            VStack(spacing: 10) {
                ForEach(currentOptions.indices, id: \.self) { idx in
                    Button {
                        guard !isAnswered else { return }
                        selectedAnswer = idx
                        isAnswerCorrect = quizLogic.answerQuestion(idx)
                        isAnswered = true
                        showFeedback = true

                        // Auto-advance after brief delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            if quizLogic.isFinished {
                                withAnimation { step = .results }
                            } else {
                                quizLogic.moveToNextQuestion()
                                resetQuestionState()
                            }
                        }
                    } label: {
                        HStack {
                            Text(["A", "B", "C", "D"][min(idx, 3)])
                                .font(.headline.bold())
                                .frame(width: 24)
                            Text(currentOptions[idx])
                                .multilineTextAlignment(.leading)
                            Spacer()
                            if isAnswered && idx == quizLogic.currentQuestion.correctAnswer {
                                Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                            } else if isAnswered && idx == selectedAnswer && !isAnswerCorrect {
                                Image(systemName: "xmark.circle.fill").foregroundColor(.red)
                            }
                        }
                        .foregroundColor(answerColor(idx))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(RoundedRectangle(cornerRadius: 12).fill(answerBackground(idx)))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(answerBorder(idx), lineWidth: 1.5))
                    }
                    .disabled(isAnswered)
                }
            }
            .padding(.horizontal, 24)

            Spacer()

            stepDots(current: 2)
                .padding(.bottom, 30)
        }
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: - Screen 4: Results
    // ═════════════════════════════════════════════════════════════

    private var resultsScreen: some View {
        VStack(spacing: 20) {
            Spacer()

            // Score circle
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 8)
                    .frame(width: 120, height: 120)
                Circle()
                    .trim(from: 0, to: scoreRatio)
                    .stroke(scoreColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 2) {
                    Text("\(quizLogic.correctAnswers)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                    Text("\(ofText) \(quizLogic.attemptedQuestions)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                }
            }

            Text(resultHeadline)
                .font(.title2.bold())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text(resultMessage)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()

            Button {
                completeOnboarding()
            } label: {
                Text(startStudying)
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.blue, .blue.opacity(0.7)],
                            startPoint: .leading, endPoint: .trailing
                        )
                    )
                    .cornerRadius(14)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
        }
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: - Helpers
    // ═════════════════════════════════════════════════════════════

    private func startQuiz() {
        guard let lang = selectedLanguage else { return }
        let pool = QuestionPool.allQuestions(for: lang)
        let desiredVariant = lang == .english ? 0 : 1
        let maxVariant = pool.first?.variants.count ?? 1
        quizLogic.selectedVariantIndex = min(desiredVariant, maxVariant - 1)
        quizLogic.languageTag = lang.rawValue
        quizLogic.startMockInterview(from: pool, questionCount: 5, requiredCorrect: 3)
        withAnimation { step = .quiz }
    }

    private func completeOnboarding() {
        guard let lang = selectedLanguage else { return }
        ProgressManager.shared.preferredLanguage = lang.rawValue
        ProgressManager.shared.interviewDate = dateChoice == .picked ? interviewDate : nil
        ProgressManager.shared.hasCompletedOnboarding = true
        onComplete(lang)
    }

    private func resetQuestionState() {
        selectedAnswer = nil
        isAnswered = false
        isAnswerCorrect = false
        showFeedback = false
    }

    // Question text in user's language
    private var currentQuestionText: String {
        let q = quizLogic.currentQuestion
        guard !q.variants.isEmpty else { return "" }
        let idx = quizLogic.selectedVariantIndex
        let safeIdx = min(max(idx, 0), q.variants.count - 1)
        return q.variants[safeIdx].text
    }

    private var currentOptions: [String] {
        let q = quizLogic.currentQuestion
        guard !q.variants.isEmpty else { return [] }
        let idx = quizLogic.selectedVariantIndex
        let safeIdx = min(max(idx, 0), q.variants.count - 1)
        return q.variants[safeIdx].options
    }

    // Score helpers
    private var scoreRatio: CGFloat {
        guard quizLogic.attemptedQuestions > 0 else { return 0 }
        return CGFloat(quizLogic.correctAnswers) / CGFloat(quizLogic.attemptedQuestions)
    }

    private var scoreColor: Color {
        switch quizLogic.correctAnswers {
        case 0...1: return .red
        case 2...3: return .orange
        default:    return .green
        }
    }

    private var resultHeadline: String {
        let score = quizLogic.correctAnswers
        switch lang {
        case .nepali:
            switch score {
            case 0...1: return "तयारी सुरु गरौं"
            case 2...3: return "राम्रो सुरुवात!"
            default:    return "उत्कृष्ट आधार!"
            }
        case .spanish:
            switch score {
            case 0...1: return "¡Vamos a prepararte!"
            case 2...3: return "¡Buen comienzo!"
            default:    return "¡Gran base!"
            }
        case .chinese:
            switch score {
            case 0...1: return "让我们开始准备"
            case 2...3: return "良好的开始！"
            default:    return "基础扎实！"
            }
        default:
            switch score {
            case 0...1: return "Let's Get You Ready"
            case 2...3: return "Good Start!"
            default:    return "Great Foundation!"
            }
        }
    }

    private var resultMessage: String {
        let score = quizLogic.correctAnswers
        switch lang {
        case .nepali:
            switch score {
            case 0...1: return "चिन्ता नलिनुहोस् — सबैले कतैबाट सुरु गर्छन्। CitiZen ले तपाईंलाई चरणबद्ध रूपमा तयार गर्नेछ।"
            case 2...3: return "तपाईंसँग पहिले नै केही ज्ञान छ। नियमित अभ्यासले तपाईंलाई छिट्टै तयार बनाउनेछ।"
            default:    return "प्रभावशाली! तपाईंलाई धेरै कुरा थाहा छ। अझ राम्रो तयारी गरौं।"
            }
        case .spanish:
            switch score {
            case 0...1: return "No te preocupes — todos empiezan en algún lugar. CitiZen te ayudará paso a paso."
            case 2...3: return "Ya tienes algo de conocimiento. Con práctica regular, estarás listo pronto."
            default:    return "¡Impresionante! Ya sabes mucho. Vamos a perfeccionar tus habilidades."
            }
        case .chinese:
            switch score {
            case 0...1: return "别担心——每个人都是从零开始的。CitiZen 会帮助你一步步学习。"
            case 2...3: return "你已经有一些基础了。坚持练习，很快就能准备好。"
            default:    return "很棒！你已经知道很多了。让我们继续巩固，确保你通过面试。"
            }
        default:
            switch score {
            case 0...1: return "No worries — everyone starts somewhere. CitiZen will help you build your knowledge step by step."
            case 2...3: return "You have some knowledge already. With regular practice, you'll be interview-ready in no time."
            default:    return "Impressive! You already know a lot. Let's sharpen your skills and make sure you pass with confidence."
            }
        }
    }

    // Answer button styling
    private func answerColor(_ idx: Int) -> Color {
        guard isAnswered else { return .white }
        if idx == quizLogic.currentQuestion.correctAnswer { return .green }
        if idx == selectedAnswer { return .red.opacity(0.8) }
        return .white.opacity(0.3)
    }

    private func answerBackground(_ idx: Int) -> Color {
        guard isAnswered else { return .white.opacity(0.08) }
        if idx == quizLogic.currentQuestion.correctAnswer { return .green.opacity(0.15) }
        if idx == selectedAnswer { return .red.opacity(0.15) }
        return .white.opacity(0.03)
    }

    private func answerBorder(_ idx: Int) -> Color {
        guard isAnswered else { return .white.opacity(0.1) }
        if idx == quizLogic.currentQuestion.correctAnswer { return .green.opacity(0.5) }
        if idx == selectedAnswer { return .red.opacity(0.5) }
        return .white.opacity(0.05)
    }

    private func englishName(_ lang: AppLanguage) -> String {
        switch lang {
        case .english: return "English"
        case .nepali:  return "Nepali"
        case .spanish: return "Spanish"
        case .chinese: return "Chinese"
        }
    }

    // Step indicator dots
    private func stepDots(current: Int) -> some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(i == current ? Color.cyan : Color.white.opacity(0.2))
                    .frame(width: 8, height: 8)
            }
        }
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: - Localized Onboarding Strings
    // ═════════════════════════════════════════════════════════════

    private var lang: AppLanguage { selectedLanguage ?? .english }

    private var dateTitle: String {
        switch lang {
        case .english: return "When is your\ncitizenship interview?"
        case .nepali:  return "तपाईंको नागरिकता\nअन्तर्वार्ता कहिले हो?"
        case .spanish: return "¿Cuándo es tu\nentrevista de ciudadanía?"
        case .chinese: return "你的公民面试\n是什么时候？"
        }
    }

    private var dateSubtitle: String {
        switch lang {
        case .english: return "We'll help you stay on track"
        case .nepali:  return "हामी तपाईंलाई तयार रहन मद्दत गर्नेछौं"
        case .spanish: return "Te ayudaremos a mantenerte al día"
        case .chinese: return "我们会帮助你保持进度"
        }
    }

    private var dateSetButton: String {
        switch lang {
        case .english: return "Set Date & Continue"
        case .nepali:  return "मिति सेट गर्नुहोस्"
        case .spanish: return "Establecer fecha y continuar"
        case .chinese: return "设置日期并继续"
        }
    }

    private var dateNotScheduled: String {
        switch lang {
        case .english: return "I haven't scheduled yet"
        case .nepali:  return "मैले अझै तय गरेको छैन"
        case .spanish: return "Aún no la he programado"
        case .chinese: return "我还没有安排"
        }
    }

    private var dateExploring: String {
        switch lang {
        case .english: return "I'm just exploring"
        case .nepali:  return "म अन्वेषण गर्दै छु"
        case .spanish: return "Solo estoy explorando"
        case .chinese: return "我只是在看看"
        }
    }

    private var quizHeader: String {
        switch lang {
        case .english: return "Quick Assessment"
        case .nepali:  return "छोटो मूल्याङ्कन"
        case .spanish: return "Evaluación rápida"
        case .chinese: return "快速评估"
        }
    }

    private var startStudying: String {
        switch lang {
        case .english: return "Start Studying"
        case .nepali:  return "अध्ययन सुरु गर्नुहोस्"
        case .spanish: return "Empezar a estudiar"
        case .chinese: return "开始学习"
        }
    }

    private var orText: String {
        switch lang {
        case .english: return "or"
        case .nepali:  return "वा"
        case .spanish: return "o"
        case .chinese: return "或者"
        }
    }

    private var ofText: String {
        switch lang {
        case .english: return "of"
        case .nepali:  return "मा"
        case .spanish: return "de"
        case .chinese: return "共"
        }
    }
}
