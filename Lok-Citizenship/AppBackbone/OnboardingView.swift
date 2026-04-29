import SwiftUI
import Combine

// ═════════════════════════════════════════════════════════════════
// MARK: - Onboarding Flow
// ═════════════════════════════════════════════════════════════════

struct OnboardingView: View {

    /// Called when onboarding completes. Passes the selected language.
    let onComplete: (AppLanguage) -> Void

    // MARK: - State

    enum Step: Int, CaseIterable {
        case intro, language, interviewDate, notifications, quiz, results
        /// Step dot index. Intro and results don't get a dot.
        var dotIndex: Int? {
            switch self {
            case .intro, .results: return nil
            case .language:        return 0
            case .interviewDate:   return 1
            case .notifications:   return 2
            case .quiz:            return 3
            }
        }
    }

    enum DateChoice { case notChosen, picked, notScheduled, exploring }

    @State private var step: Step = .intro
    @State private var selectedLanguage: AppLanguage?
    @State private var interviewDate = Date()
    @State private var dateChoice: DateChoice = .notChosen

    // Quiz state
    @StateObject private var quizLogic = UnifiedQuizLogic()
    @State private var selectedAnswer: Int?
    @State private var isAnswered = false
    @State private var isAnswerCorrect = false

    // Voice demo state (intro screen)
    @ObservedObject private var notifications = NotificationManager.shared
    @State private var isDemoPlaying = false
    @State private var demoSubscription: AnyCancellable?

    // MARK: - Derived

    private var s: UIStrings { UIStrings.forLanguage(selectedLanguage ?? .english) }

    // ─────────────────────────────────────────────────────────────
    // MARK: - Body
    // ─────────────────────────────────────────────────────────────

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

            switch step {
            case .intro:         introScreen
            case .language:      languageScreen
            case .interviewDate: dateScreen
            case .notifications: notificationScreen
            case .quiz:          quizScreen
            case .results:       resultsScreen
            }
        }
        .animation(.easeInOut(duration: 0.3), value: step)
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: - Screen 0: Intro
    // ═════════════════════════════════════════════════════════════

    private var introScreen: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer(minLength: 40)

                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [.cyan.opacity(0.35), .cyan.opacity(0.05)],
                            startPoint: .top, endPoint: .bottom))
                        .frame(width: 120, height: 120)
                    Image(systemName: "star.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.cyan)
                }

                Text(s.onboardingIntroHeadline)
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                Text(s.onboardingIntroTagline)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                VStack(spacing: 10) {
                    featureRow(icon: "mic.fill",
                               title: s.onboardingFeatureVoice,
                               subtitle: s.onboardingFeatureVoiceSub,
                               color: .cyan)
                    featureRow(icon: "globe",
                               title: s.onboardingFeatureLanguage,
                               subtitle: s.onboardingFeatureLanguageSub,
                               color: .blue)
                    featureRow(icon: "checkmark.seal.fill",
                               title: s.onboardingFeatureMock,
                               subtitle: s.onboardingFeatureMockSub,
                               color: .green)
                }
                .padding(.horizontal, 20)
                .padding(.top, 4)

                voiceDemoButton
                    .padding(.horizontal, 20)
                    .padding(.top, 4)

                Spacer(minLength: 12)

                Button {
                    let gen = UIImpactFeedbackGenerator(style: .medium); gen.impactOccurred()
                    stopDemo()
                    withAnimation { step = .language }
                } label: {
                    Text(s.onboardingContinue)
                        .font(.headline.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 52)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(LinearGradient(
                                    colors: [.blue, .blue.opacity(0.75)],
                                    startPoint: .leading, endPoint: .trailing))
                        )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
            }
        }
        .scrollIndicators(.hidden)
    }

    private func featureRow(icon: String, title: String, subtitle: String, color: Color) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
                .frame(width: 32)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.55))
            }
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }

    private var voiceDemoButton: some View {
        Button {
            let gen = UIImpactFeedbackGenerator(style: .light); gen.impactOccurred()
            if isDemoPlaying {
                stopDemo()
            } else {
                playDemo()
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: isDemoPlaying ? "stop.fill" : "speaker.wave.2.fill")
                    .font(.caption.bold())
                Text(s.onboardingHearSample)
                    .font(.caption.bold())
            }
            .foregroundColor(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                Capsule().fill(isDemoPlaying
                               ? Color.red.opacity(0.85)
                               : Color.white.opacity(0.12))
            )
            .overlay(
                Capsule().stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
        }
    }

    private func playDemo() {
        let tts = ServiceLocator.shared.ttsService
        let text = s.onboardingSampleText
        let locale = (selectedLanguage ?? .english).rawValue
        isDemoPlaying = true
        demoSubscription = tts.speak(text, languageCode: locale)
            .receive(on: DispatchQueue.main)
            .sink { _ in self.isDemoPlaying = false }
    }

    private func stopDemo() {
        ServiceLocator.shared.ttsService.stopSpeaking()
        demoSubscription?.cancel()
        demoSubscription = nil
        isDemoPlaying = false
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

            Text(languageHeadline)
                .font(.title.bold())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text(languageSubtitle)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.5))

            Spacer().frame(height: 8)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 14)], spacing: 14) {
                ForEach(AppLanguage.allCases) { lang in
                    Button {
                        let gen = UISelectionFeedbackGenerator(); gen.selectionChanged()
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

            stepDots()
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

            DatePicker("", selection: $interviewDate, in: Date()..., displayedComponents: .date)
                .datePickerStyle(.compact)
                .labelsHidden()
                .colorScheme(.dark)
                .padding(.horizontal, 40)
                .padding(.vertical, 8)

            Button {
                dateChoice = .picked
                withAnimation { step = .notifications }
            } label: {
                Text(dateSetButton)
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(LinearGradient(
                                colors: [.blue, .blue.opacity(0.75)],
                                startPoint: .leading, endPoint: .trailing))
                    )
            }
            .padding(.horizontal, 32)

            Text(orText)
                .font(.caption)
                .foregroundColor(.white.opacity(0.3))
                .padding(.top, 4)

            VStack(spacing: 10) {
                Button {
                    dateChoice = .notScheduled
                    withAnimation { step = .notifications }
                } label: {
                    dateAltRow(icon: "clock", text: dateNotScheduled)
                }

                Button {
                    dateChoice = .exploring
                    withAnimation { step = .notifications }
                } label: {
                    dateAltRow(icon: "eyes", text: dateExploring)
                }
            }
            .padding(.horizontal, 32)

            Spacer()

            stepDots()
                .padding(.bottom, 30)
        }
    }

    private func dateAltRow(icon: String, text: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.cyan)
            Text(text)
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

    // ═════════════════════════════════════════════════════════════
    // MARK: - Screen 3: Notifications
    // ═════════════════════════════════════════════════════════════

    private var notificationScreen: some View {
        VStack(spacing: 20) {
            Spacer()

            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [.orange.opacity(0.35), .orange.opacity(0.05)],
                        startPoint: .top, endPoint: .bottom))
                    .frame(width: 120, height: 120)
                Image(systemName: "bell.badge.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.orange)
            }

            Text(s.notificationsTitle)
                .font(.title.bold())
                .foregroundColor(.white)

            Text(s.notificationsSubtitle)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.55))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()

            VStack(spacing: 10) {
                Button {
                    let gen = UIImpactFeedbackGenerator(style: .medium); gen.impactOccurred()
                    // Wait for the OS prompt to resolve before advancing.
                    // Without this, a slow user dismissal would land the
                    // placement-quiz screen behind the still-presented
                    // permission sheet (the previous fixed 0.5 s delay
                    // was a race that occasionally failed in practice).
                    notifications.requestPermission {
                        startQuiz()
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "bell.fill")
                        Text(s.notificationsEnable)
                    }
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(LinearGradient(
                                colors: [.orange, .orange.opacity(0.8)],
                                startPoint: .leading, endPoint: .trailing))
                    )
                }

                Button {
                    startQuiz()
                } label: {
                    Text(s.notificationsSkip)
                        .font(.subheadline.bold())
                        .foregroundColor(.white.opacity(0.7))
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.08))
                        )
                }
            }
            .padding(.horizontal, 24)

            stepDots()
                .padding(.top, 8)
                .padding(.bottom, 30)
        }
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: - Screen 4: Placement Quiz
    // ═════════════════════════════════════════════════════════════

    private var quizScreen: some View {
        VStack(spacing: 16) {

            HStack {
                Text(quizHeader)
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.6))
                Spacer()
                Text("\(quizLogic.attemptedQuestions)/\(quizLogic.totalQuestions)")
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

            Spacer().frame(height: 24)

            Text(currentQuestionText)
                .font(.title3.bold())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .fixedSize(horizontal: false, vertical: true)

            Spacer().frame(height: 16)

            VStack(spacing: 10) {
                ForEach(currentOptions.indices, id: \.self) { idx in
                    Button {
                        guard !isAnswered else { return }
                        let gen = UISelectionFeedbackGenerator(); gen.selectionChanged()
                        selectedAnswer = idx
                        isAnswerCorrect = quizLogic.answerQuestion(idx)
                        isAnswered = true

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
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

            stepDots()
                .padding(.bottom, 30)
        }
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: - Screen 5: Results
    // ═════════════════════════════════════════════════════════════

    private var resultsScreen: some View {
        VStack(spacing: 20) {
            Spacer()

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
                let gen = UIImpactFeedbackGenerator(style: .medium); gen.impactOccurred()
                completeOnboarding()
            } label: {
                Text(String(format: s.onboardingStartAtLevelFormat, recommendedLevel))
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 54)
                    .background(
                        LinearGradient(
                            colors: [.blue, .blue.opacity(0.75)],
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
        quizLogic.tracksProgress = false  // placement must not pollute lifetime stats
        quizLogic.startMockInterview(from: pool, questionCount: 5, requiredCorrect: 3)
        withAnimation { step = .quiz }
    }

    private var recommendedLevel: Int {
        switch quizLogic.correctAnswers {
        case 0...1: return 1
        case 2...3: return 2
        default:    return 3
        }
    }

    private func completeOnboarding() {
        guard let lang = selectedLanguage else { return }
        ProgressManager.shared.preferredLanguage = lang.rawValue
        ProgressManager.shared.interviewDate = dateChoice == .picked ? interviewDate : nil
        ProgressManager.shared.recommendedLevel = recommendedLevel
        ProgressManager.shared.hasCompletedOnboarding = true
        onComplete(lang)
    }

    private func resetQuestionState() {
        selectedAnswer = nil
        isAnswered = false
        isAnswerCorrect = false
    }

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

    // Step indicator dots (4 steps: language, date, notifications, quiz)
    private func stepDots() -> some View {
        HStack(spacing: 8) {
            ForEach(0..<4, id: \.self) { i in
                Circle()
                    .fill(i == (step.dotIndex ?? -1) ? Color.cyan : Color.white.opacity(0.2))
                    .frame(width: 8, height: 8)
            }
        }
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: - Localized copy (still inline for the few strings specific to onboarding screens)
    // ═════════════════════════════════════════════════════════════

    private var lang: AppLanguage { selectedLanguage ?? .english }

    private var languageHeadline: String {
        switch lang {
        case .english: return "What language\ndo you speak?"
        case .nepali:  return "तपाईं कुन\nभाषा बोल्नुहुन्छ?"
        case .spanish: return "¿Qué idioma\nhablas?"
        case .chinese: return "你说哪种\n语言？"
        }
    }

    private var languageSubtitle: String {
        switch lang {
        case .english: return "We'll show questions in your language"
        case .nepali:  return "हामी तपाईंको भाषामा प्रश्न देखाउनेछौं"
        case .spanish: return "Te mostraremos las preguntas en tu idioma"
        case .chinese: return "我们会用你的语言显示问题"
        }
    }

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
