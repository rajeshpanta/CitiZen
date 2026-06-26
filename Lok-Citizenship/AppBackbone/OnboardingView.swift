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
        case intro, language, questionSetSelection, whyOral, voiceDemo, whatYoullMaster, interviewDate, notifications, quiz, results
        /// Step dot index. Intro and results don't get a dot.
        var dotIndex: Int? {
            switch self {
            case .intro, .results:          return nil
            case .language:                 return 0
            case .questionSetSelection:     return 1
            case .whyOral:                  return 2
            case .voiceDemo:                return 3
            case .whatYoullMaster:          return 4
            case .interviewDate:            return 5
            case .notifications:            return 6
            case .quiz:                     return 7
            }
        }
    }

    enum DateChoice { case notChosen, picked, notScheduled, exploring }

    @State private var step: Step = .intro
    @State private var selectedLanguage: AppLanguage?
    @State private var interviewDate = Date()
    @State private var dateChoice: DateChoice = .notChosen

    // MARK: - Elegance state (intro screen first-impression polish)
    //
    // `hasAppearedIntro` drives the staggered fade-up entry so the
    // screen feels alive rather than slapped down whole. `heroPulse`
    // is a slow infinite breathing animation on the cyan circle —
    // the kind of subtle motion premium apps use to signal life
    // without being distracting.
    @State private var hasAppearedIntro = false
    @State private var heroPulse = false

    // MARK: - Voice demo screen state
    //
    // The onboarding voice demo gives users the "wow" moment — they
    // SPEAK their first answer and see the app understand them. We use
    // the same LocalSTTService the real quizzes use so the experience
    // they get here matches the experience they'll get during real
    // study. Permission is requested inline on first mic tap.
    enum VoiceDemoStatus {
        case idle              // Initial state — show mic, no transcript
        case listening         // Mic active, transcript building
        case success           // Transcript contained "constitution" — celebrate
        case retry             // Transcript was off-topic — gentle nudge
        case permissionDenied  // User said no to mic/speech — show Settings link
    }
    @StateObject private var demoVoiceCtrl = OnboardingVoiceDemoController()

    @State private var selectedQuestionSet: ProgressManager.QuestionSet = .set2008

    // Quiz state
    @StateObject private var quizLogic = UnifiedQuizLogic()
    @State private var selectedAnswer: Int?
    @State private var isAnswered = false
    @State private var isAnswerCorrect = false

    // Voice demo state (intro screen)
    @ObservedObject private var notifications = NotificationManager.shared
    @State private var isDemoPlaying = false
    @State private var demoSubscription: AnyCancellable?
    /// Observed so `introScreen` can call `stopDemo()` if the user
    /// backgrounds the app mid-demo. AVAudioSession interruptions (phone
    /// call, Siri, alarm) sometimes leave the synthesizer in a half-
    /// stopped state where the delegate didn't fire — without this, the
    /// "Hear a sample" button stays stuck in the red "stop" state even
    /// though no audio is playing.
    @Environment(\.scenePhase) private var scenePhase

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
            case .intro:                  introScreen
            case .language:               languageScreen
            case .questionSetSelection:   questionSetSelectionScreen
            case .whyOral:                whyOralScreen
            case .voiceDemo:              voiceDemoScreen
            case .whatYoullMaster:        whatYoullMasterScreen
            case .interviewDate:          dateScreen
            case .notifications:          notificationScreen
            case .quiz:                   quizScreen
            case .results:                resultsScreen
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

                // Hero icon — cyan-glowing star in a soft circle.
                // Pulses slowly to signal life; glow radius breathes
                // with the scale so the whole element feels organic
                // rather than mechanical.
                ZStack {
                    // Outer glow ring (drawn behind the circle so it
                    // bleeds outward without bounding the visible disc).
                    Circle()
                        .fill(Color.cyan.opacity(0.18))
                        .frame(width: 160, height: 160)
                        .blur(radius: 28)
                        .scaleEffect(heroPulse ? 1.08 : 0.95)

                    Circle()
                        .fill(LinearGradient(
                            colors: [.cyan.opacity(0.35), .cyan.opacity(0.05)],
                            startPoint: .top, endPoint: .bottom))
                        .frame(width: 120, height: 120)
                        .scaleEffect(heroPulse ? 1.04 : 1.0)
                        .shadow(color: .cyan.opacity(0.45),
                                radius: heroPulse ? 28 : 16,
                                x: 0, y: 0)

                    Image(systemName: "star.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.cyan)
                        .shadow(color: .cyan.opacity(0.6), radius: 8, x: 0, y: 0)
                }
                .staggeredEntry(delay: 0.00, appeared: hasAppearedIntro)

                Text(s.onboardingIntroHeadline)
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .staggeredEntry(delay: 0.15, appeared: hasAppearedIntro)

                Text(s.onboardingIntroTagline)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .staggeredEntry(delay: 0.28, appeared: hasAppearedIntro)

                VStack(spacing: 10) {
                    featureRow(icon: "mic.fill",
                               title: s.onboardingFeatureVoice,
                               subtitle: s.onboardingFeatureVoiceSub,
                               color: .cyan)
                        .staggeredEntry(delay: 0.42, appeared: hasAppearedIntro)
                    featureRow(icon: "globe",
                               title: s.onboardingFeatureLanguage,
                               subtitle: s.onboardingFeatureLanguageSub,
                               color: .blue)
                        .staggeredEntry(delay: 0.52, appeared: hasAppearedIntro)
                    featureRow(icon: "checkmark.seal.fill",
                               title: s.onboardingFeatureMock,
                               subtitle: s.onboardingFeatureMockSub,
                               color: .green)
                        .staggeredEntry(delay: 0.62, appeared: hasAppearedIntro)
                }
                .padding(.horizontal, 20)
                .padding(.top, 4)

                voiceDemoButton
                    .padding(.horizontal, 20)
                    .padding(.top, 4)
                    .staggeredEntry(delay: 0.76, appeared: hasAppearedIntro)

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
                .accessibilityLabel(s.onboardingContinue)
                .staggeredEntry(delay: 0.90, appeared: hasAppearedIntro)

                // Fast-path: skip onboarding and drop the user at the
                // main practice menu with safe defaults. Crucial for
                // the "let me see what this is before I commit" user —
                // historically the biggest source of onboarding drop-
                // off. We still persist language (detected from the
                // device locale) and `hasCompletedOnboarding`, so the
                // user isn't shown the funnel again on next launch.
                // They can complete a full placement quiz later from
                // Settings if they want a recommended level.
                Button {
                    let gen = UIImpactFeedbackGenerator(style: .light); gen.impactOccurred()
                    stopDemo()
                    skipToFreePractice()
                } label: {
                    Text(s.onboardingExploreFree)
                        .font(.subheadline.bold())
                        .foregroundColor(.white.opacity(0.85))
                        .lineLimit(2)
                        .minimumScaleFactor(0.85)
                        .padding(.vertical, 4)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.06))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                }
                .padding(.horizontal, 24)
                .padding(.top, 4)
                .padding(.bottom, 30)
                .accessibilityLabel(s.onboardingExploreFree)
                .staggeredEntry(delay: 1.00, appeared: hasAppearedIntro)
            }
        }
        .scrollIndicators(.hidden)
        .onAppear {
            // Re-arm both animations on every appearance so the polish
            // replays if the user resets onboarding from Settings (DEBUG
            // build). A tiny delay before flipping `hasAppearedIntro` to
            // true ensures the .opacity / .offset baseline is rendered
            // first — without that, SwiftUI sometimes paints the final
            // state straight away and skips the fade-in.
            hasAppearedIntro = false
            heroPulse = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                hasAppearedIntro = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.40) {
                withAnimation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true)) {
                    heroPulse = true
                }
            }
        }
        // Bind the demo button's visual state to the real TTS engine
        // signal rather than our local flag. The sink in `playDemo`
        // fires only on natural completion of the publisher — an
        // audio-session interruption (phone call, Siri) can leave the
        // engine stopped without sending that terminal, stranding the
        // button in the red "stop" state. The TTS service's
        // `isSpeakingPublisher` reflects the synthesizer's delegate
        // (didStart/didFinish/didCancel), so observing it here covers
        // every stop path including interruptions.
        .onReceive(ServiceLocator.shared.ttsService.isSpeakingPublisher) { speaking in
            if !speaking { isDemoPlaying = false }
        }
        .onChange(of: scenePhase) { phase in
            // Belt-and-suspenders: if the user backgrounds the app
            // mid-demo, halt the demo explicitly so it doesn't resume
            // when they come back (and so the UI flag doesn't get
            // stuck on if the OS interrupted before the delegate ran).
            if phase != .active { stopDemo() }
        }
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
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Spacer().frame(height: 8)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 14)], spacing: 14) {
                ForEach(AppLanguage.allCases) { lang in
                    Button {
                        let gen = UISelectionFeedbackGenerator(); gen.selectionChanged()
                        withAnimation { selectedLanguage = lang; step = .questionSetSelection }
                    } label: {
                        VStack(spacing: 8) {
                            Text(lang.flag).font(.system(size: 36))
                            Text(lang.displayName).font(.headline).foregroundColor(.white)
                            Text(lang.englishName).font(.caption).foregroundColor(.white.opacity(0.4))
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

            // Cap two years out: USCIS interview scheduling rarely exceeds
            // ~14 months from filing, so a 24-month ceiling is generous.
            // Without an upper bound, picking 2099 makes the readiness
            // dashboard render "26500 days until your interview" — looks
            // like a date-formatting bug.
            DatePicker("",
                       selection: $interviewDate,
                       in: Date()...(Calendar.current.date(byAdding: .year, value: 2, to: Date()) ?? Date()),
                       displayedComponents: .date)
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
        ProgressManager.shared.questionSet = selectedQuestionSet
        ProgressManager.shared.hasChosenQuestionSet = true
        ProgressManager.shared.hasCompletedOnboarding = true
        onComplete(lang)
    }

    /// Fast-path completion. Detect the device locale → pick the
    /// matching AppLanguage (English fallback for any locale we don't
    /// support). Persist sensible defaults so the user lands at Level
    /// 1 of the practice menu without seeing onboarding again. They
    /// can still adjust language and interview date later in Settings.
    private func skipToFreePractice() {
        let lang = detectedAppLanguage()
        ProgressManager.shared.preferredLanguage = lang.rawValue
        ProgressManager.shared.interviewDate = nil
        ProgressManager.shared.recommendedLevel = 1
        ProgressManager.shared.hasChosenQuestionSet = true
        ProgressManager.shared.hasCompletedOnboarding = true
        onComplete(lang)
    }

    /// Maps the device's preferred language code to one of our
    /// supported AppLanguages. Returns .english for anything we don't
    /// localize so the user gets a usable app instead of a broken one.
    private func detectedAppLanguage() -> AppLanguage {
        let code = Locale.current.language.languageCode?.identifier ?? "en"
        switch code {
        case "es": return .spanish
        case "ne", "hi": return .nepali   // Nepali speakers' devices often default to Hindi
        case "zh": return .chinese
        default:   return .english
        }
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
        case .english:
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
        case .english:
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

    // Step indicator dots (4 steps: language, date, notifications, quiz)
    private func stepDots() -> some View {
        OnboardingStepDots(currentIndex: step.dotIndex ?? -1)
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
        // Updated copy: name BOTH the question text and audio (voice
        // is the differentiator) and add a reassurance about being
        // able to change later. The previous copy ("We'll show
        // questions in your language") was true but didn't address
        // the common hesitation — "what if I pick wrong?"
        switch lang {
        case .english: return "Questions and voice in your language.\nYou can change this anytime in Settings."
        case .nepali:  return "तपाईंको भाषामा प्रश्न र आवाज।\nसेटिङ्समा जहिले पनि परिवर्तन गर्न सक्नुहुन्छ।"
        case .spanish: return "Preguntas y voz en tu idioma.\nPuedes cambiarlo en Configuración."
        case .chinese: return "用你的语言显示问题和语音。\n随时可以在设置中更改。"
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

// ═════════════════════════════════════════════════════════════════
// MARK: - New onboarding screens
// ═════════════════════════════════════════════════════════════════
//
// These extend the OnboardingView struct with the 3 informative
// screens added between Language and Interview Date:
//
//   • whyOralScreen          — the differentiation pitch
//   • voiceDemoScreen        — live voice STT try-it-now moment
//   • whatYoullMasterScreen  — content scope authority
//
// Each screen reuses the staggered-entry modifier introduced earlier
// so the overall onboarding feels visually consistent.
private extension OnboardingView {

    // ─────────────────────────────────────────────────────────────
    // Screen: Question set selection (new step after language)
    // ─────────────────────────────────────────────────────────────
    var questionSetSelectionScreen: some View {
        OnboardingQuestionSetView(
            language: selectedLanguage ?? .english,
            selectedSet: $selectedQuestionSet,
            onContinue: { withAnimation { step = .whyOral } }
        )
    }

    // ─────────────────────────────────────────────────────────────
    // Screen: Why CitiZen — the real interview is oral
    // ─────────────────────────────────────────────────────────────
    var whyOralScreen: some View {
        OnboardingWhyOralView(
            language: selectedLanguage ?? .english,
            onContinue: { withAnimation { step = .voiceDemo } }
        )
    }

    // ─────────────────────────────────────────────────────────────
    // Screen: Live voice demo
    // ─────────────────────────────────────────────────────────────
    var voiceDemoScreen: some View {
        OnboardingVoiceDemoView(
            language: selectedLanguage ?? .english,
            controller: demoVoiceCtrl,
            onSuccess: { withAnimation { step = .whatYoullMaster } },
            onSkip:    { withAnimation { step = .whatYoullMaster } }
        )
    }

    // ─────────────────────────────────────────────────────────────
    // Screen: What you'll master
    // ─────────────────────────────────────────────────────────────
    var whatYoullMasterScreen: some View {
        OnboardingMasterView(
            language: selectedLanguage ?? .english,
            onContinue: { withAnimation { step = .interviewDate } }
        )
    }
}

// MARK: - Staggered entry modifier
//
// One-line modifier so every onboarding element fades and rises into
// place with a per-element delay. Pulled out of OnboardingView so the
// intro body reads as a clean list of elements + delays rather than a
// repeated `.opacity / .offset / .animation` boilerplate at every site.
//
// The animation is intentionally short (0.55 s) so the cumulative entry
// of all elements completes in just over a second — long enough to feel
// considered, short enough not to make the user wait to read or tap.
private struct StaggeredEntry: ViewModifier {
    let delay: Double
    let appeared: Bool
    func body(content: Content) -> some View {
        content
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 22)
            .animation(.easeOut(duration: 0.55).delay(delay), value: appeared)
    }
}

private extension View {
    /// Fade-up reveal with a per-element delay. Use to compose
    /// staggered entry across a screen.
    func staggeredEntry(delay: Double, appeared: Bool) -> some View {
        modifier(StaggeredEntry(delay: delay, appeared: appeared))
    }
}

// ─────────────────────────────────────────────────────────────────
// Step-progress dot row
// ─────────────────────────────────────────────────────────────────
//
// 8 dots cover every intermediate screen with a dotIndex:
// language(0), questionSetSelection(1), whyOral(2), voiceDemo(3),
// whatYoullMaster(4), interviewDate(5), notifications(6), quiz(7).
// Intro and results don't render dots (their dotIndex is nil).
//
// Pulled out as a standalone struct so the 3 informative screens
// below (which are their own private structs) can render the dots
// inline — previously only the parent OnboardingView could call
// `stepDots()`, which left whyOral / voiceDemo / whatYoullMaster
// with no progress indicator at all.
private struct OnboardingStepDots: View {
    let currentIndex: Int
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<8, id: \.self) { i in
                Circle()
                    .fill(i == currentIndex ? Color.cyan : Color.white.opacity(0.2))
                    .frame(width: 8, height: 8)
            }
        }
    }
}

// ═════════════════════════════════════════════════════════════════
// MARK: - Onboarding screen components
// ═════════════════════════════════════════════════════════════════

// ─────────────────────────────────────────────────────────────────
// Why CitiZen — the real interview is oral
// ─────────────────────────────────────────────────────────────────
private struct OnboardingWhyOralView: View {
    let language: AppLanguage
    let onContinue: () -> Void
    @State private var appeared = false
    @State private var micPulse = false

    private var s: UIStrings { UIStrings.forLanguage(language) }

    var body: some View {
        VStack(spacing: 18) {
            Spacer(minLength: 30)

            // Tag chip — small "Why CitiZen" eyebrow
            Text(s.onboardingWhyOralEyebrow)
                .font(.caption.bold())
                .foregroundColor(.cyan)
                .tracking(2)
                .textCase(.uppercase)
                .staggeredEntry(delay: 0.00, appeared: appeared)

            // Main headline — "The real interview is ORAL."
            Text(s.onboardingWhyOralHeadline)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .staggeredEntry(delay: 0.10, appeared: appeared)

            // Subtitle
            Text(s.onboardingWhyOralSubtitle)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.65))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)
                .staggeredEntry(delay: 0.22, appeared: appeared)

            Spacer().frame(height: 8)

            // Side-by-side comparison panel
            HStack(spacing: 12) {
                comparisonCard(
                    icon: "hand.tap",
                    iconColor: .white.opacity(0.5),
                    title: s.onboardingOtherAppsLabel,
                    body: s.onboardingOtherAppsDesc,
                    isPositive: false
                )
                .staggeredEntry(delay: 0.36, appeared: appeared)

                comparisonCard(
                    icon: "mic.fill",
                    iconColor: .cyan,
                    title: s.onboardingCitiZenLabel,
                    body: s.onboardingCitiZenDesc,
                    isPositive: true,
                    pulse: micPulse
                )
                .staggeredEntry(delay: 0.46, appeared: appeared)
            }
            .padding(.horizontal, 20)

            // Stat fact tile
            HStack(spacing: 12) {
                Image(systemName: "person.badge.shield.checkmark.fill")
                    .font(.title3)
                    .foregroundColor(.cyan)
                Text(s.onboardingWhyOralFactTile)
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cyan.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.cyan.opacity(0.25), lineWidth: 1)
            )
            .padding(.horizontal, 20)
            .padding(.top, 6)
            .staggeredEntry(delay: 0.60, appeared: appeared)

            Spacer()

            // CTA
            Button {
                let gen = UIImpactFeedbackGenerator(style: .medium); gen.impactOccurred()
                onContinue()
            } label: {
                HStack(spacing: 8) {
                    Text(s.onboardingTryItNow)
                    Image(systemName: "arrow.right")
                }
                .font(.headline.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 52)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(LinearGradient(
                            colors: [.cyan, .blue],
                            startPoint: .leading, endPoint: .trailing))
                )
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
            .staggeredEntry(delay: 0.74, appeared: appeared)

            OnboardingStepDots(currentIndex: 2)
                .padding(.bottom, 24)
                .staggeredEntry(delay: 0.82, appeared: appeared)
        }
        .onAppear {
            appeared = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { appeared = true }
            withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                micPulse = true
            }
        }
    }

    @ViewBuilder
    private func comparisonCard(icon: String, iconColor: Color, title: String,
                                body: String, isPositive: Bool, pulse: Bool = false) -> some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(isPositive ? Color.cyan.opacity(0.18) : Color.white.opacity(0.06))
                    .frame(width: 56, height: 56)
                    .scaleEffect(pulse ? 1.12 : 1.0)
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(iconColor)
            }

            Text(title)
                .font(.caption.bold())
                .foregroundColor(isPositive ? .cyan : .white.opacity(0.55))
                .tracking(1)
                .textCase(.uppercase)

            Text(body)
                .font(.subheadline.bold())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(isPositive ? Color.cyan.opacity(0.06) : Color.white.opacity(0.04))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isPositive ? Color.cyan.opacity(0.4) : Color.white.opacity(0.1),
                        lineWidth: isPositive ? 1.5 : 1)
        )
    }
}

// ─────────────────────────────────────────────────────────────────
// Live voice STT demo
// ─────────────────────────────────────────────────────────────────
private struct OnboardingVoiceDemoView: View {
    let language: AppLanguage
    @ObservedObject var controller: OnboardingVoiceDemoController
    let onSuccess: () -> Void
    let onSkip: () -> Void

    @State private var appeared = false
    @State private var micPulse = false
    @State private var didFireSuccess = false
    @Environment(\.openURL) private var openURL

    private var s: UIStrings { UIStrings.forLanguage(language) }

    var body: some View {
        VStack(spacing: 18) {
            Spacer(minLength: 30)

            Text(s.onboardingVoiceDemoEyebrow)
                .font(.caption.bold())
                .foregroundColor(.cyan)
                .tracking(2)
                .textCase(.uppercase)
                .staggeredEntry(delay: 0.00, appeared: appeared)

            Text(s.onboardingVoiceDemoTitle)
                .font(.title.bold())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .staggeredEntry(delay: 0.10, appeared: appeared)

            // Question card
            VStack(spacing: 8) {
                Text(s.onboardingVoiceDemoQuestionLabel)
                    .font(.caption.bold())
                    .foregroundColor(.cyan)
                    .tracking(1.5)
                    .textCase(.uppercase)
                Text(s.onboardingVoiceDemoQuestion)
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.06))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            )
            .padding(.horizontal, 20)
            .staggeredEntry(delay: 0.22, appeared: appeared)

            // Mic button
            Button {
                let gen = UIImpactFeedbackGenerator(style: .heavy); gen.impactOccurred()
                handleMicTap()
            } label: {
                ZStack {
                    Circle()
                        .fill(controller.status == .listening
                              ? Color.red.opacity(0.25)
                              : Color.cyan.opacity(0.18))
                        .frame(width: 120, height: 120)
                        .scaleEffect(micPulse ? 1.08 : 1.0)
                    Circle()
                        .stroke(controller.status == .listening ? Color.red : Color.cyan,
                                lineWidth: 2)
                        .frame(width: 120, height: 120)
                    Image(systemName: controller.status == .listening ? "stop.fill" : "mic.fill")
                        .font(.system(size: 44))
                        .foregroundColor(controller.status == .listening ? .red : .cyan)
                }
            }
            .padding(.top, 6)
            .staggeredEntry(delay: 0.36, appeared: appeared)

            // Status / transcript area
            VStack(spacing: 6) {
                statusLine
                if !controller.transcript.isEmpty {
                    Text("\u{201C}\(controller.transcript)\u{201D}")
                        .font(.subheadline.italic())
                        .foregroundColor(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .lineLimit(2)
                }
            }
            .frame(minHeight: 70)
            .padding(.top, 4)
            .staggeredEntry(delay: 0.48, appeared: appeared)

            Spacer()

            // Skip link
            Button {
                controller.stop()
                onSkip()
            } label: {
                Text(s.onboardingVoiceDemoSkip)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.55))
                    .underline()
            }
            .padding(.bottom, 12)
            .staggeredEntry(delay: 0.66, appeared: appeared)

            OnboardingStepDots(currentIndex: 3)
                .padding(.bottom, 24)
                .staggeredEntry(delay: 0.74, appeared: appeared)
        }
        .onAppear {
            appeared = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { appeared = true }
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                micPulse = true
            }
        }
        .onDisappear {
            controller.stop()
        }
        .onChange(of: controller.status) { newStatus in
            // Auto-advance on success after a brief celebration moment.
            if newStatus == .success && !didFireSuccess {
                didFireSuccess = true
                let gen = UINotificationFeedbackGenerator(); gen.notificationOccurred(.success)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                    onSuccess()
                }
            }
        }
    }

    @ViewBuilder
    private var statusLine: some View {
        switch controller.status {
        case .idle:
            Text(s.onboardingVoiceDemoHintTap)
                .font(.footnote)
                .foregroundColor(.white.opacity(0.6))

        case .listening:
            HStack(spacing: 6) {
                Circle().fill(Color.red).frame(width: 6, height: 6)
                    .scaleEffect(micPulse ? 1.4 : 1.0)
                Text(s.onboardingVoiceDemoListening)
                    .font(.footnote.bold())
                    .foregroundColor(.red)
            }

        case .success:
            HStack(spacing: 6) {
                Image(systemName: "checkmark.seal.fill").foregroundColor(.green)
                Text(s.onboardingVoiceDemoSuccess)
                    .font(.headline.bold())
                    .foregroundColor(.green)
            }

        case .retry:
            VStack(spacing: 4) {
                Text(s.onboardingVoiceDemoRetry)
                    .font(.footnote)
                    .foregroundColor(.orange)
                Text(s.onboardingVoiceDemoCorrectAnswerHint)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }

        case .permissionDenied:
            VStack(spacing: 6) {
                Text(s.onboardingVoiceDemoPermissionDenied)
                    .font(.footnote)
                    .foregroundColor(.orange)
                Button(s.openSettings) {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        openURL(url)
                    }
                }
                .font(.footnote.bold())
                .foregroundColor(.cyan)
            }
        }
    }

    private func handleMicTap() {
        if controller.status == .listening {
            controller.stop()
            return
        }
        // Reset and start.
        didFireSuccess = false
        controller.start(language: language)
    }
}

// ─────────────────────────────────────────────────────────────────
// Voice demo controller — wraps the shared SpeechToTextService for
// the onboarding demo. Kept separate from VoiceQuizController to
// avoid pulling in quiz-specific logic (timeouts, scoring, audio
// routing).
// ─────────────────────────────────────────────────────────────────
@MainActor
final class OnboardingVoiceDemoController: ObservableObject {
    @Published var status: OnboardingView.VoiceDemoStatus = .idle
    @Published var transcript: String = ""

    private let stt: SpeechToTextService = ServiceLocator.shared.sttService
    private var transcriptSink: AnyCancellable?
    private var authSink: AnyCancellable?
    private var recordingSink: AnyCancellable?

    // Localized accepted-answer keywords for the current demo run.
    // Set by start(language:) so the success check matches whatever
    // language the user picked on the prior screen — previously this
    // was hard-coded to "constitution", which silently failed for
    // Spanish / Nepali / Chinese users.
    private var acceptedKeywords: [String] = []
    // Locale code for the current demo run — stored so the deferred
    // startRecording (triggered by authSink on first grant) uses the
    // same locale that start(language:) was called with.
    private var pendingLocaleCode: String = "en-US"
    // Tracks whether mic permission has already been granted so start()
    // can immediately call startRecording instead of waiting for authSink
    // to re-fire (which only fires on status transitions, not on re-tap).
    private var isSTTAuthorized: Bool = false

    init() {
        // Watch authorization changes:
        // — .denied/.restricted → show the Settings escape link.
        // — .authorized after .notDetermined → start the deferred recording
        //   (start() skips startRecording when auth is not yet granted and
        //   waits for this sink to fire instead).
        authSink = stt.authorizationStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] authStatus in
                guard let self else { return }
                self.isSTTAuthorized = authStatus == .authorized
                if authStatus == .denied || authStatus == .restricted {
                    if self.status == .listening || self.status == .idle {
                        if self.status == .listening {
                            self.stt.cancelRecording()
                        }
                        self.cleanupSubscriptions()
                        self.status = .permissionDenied
                    }
                } else if authStatus == .authorized && self.status == .listening {
                    // Auth just granted — start the recording we deferred in start().
                    self.stt.startRecording(withOptions: [], localeCode: self.pendingLocaleCode, offlineOnly: true)
                }
            }
    }

    func start(language: AppLanguage) {
        transcript = ""
        status = .listening
        acceptedKeywords = Self.keywords(for: language)
        pendingLocaleCode = language.rawValue
        // Subscribe to the live transcript stream. The publisher emits
        // partial transcripts as the user speaks so the on-screen quote
        // builds up in real time.
        transcriptSink = stt.transcriptionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] partial in
                guard let self else { return }
                self.transcript = partial
                self.evaluate(partial)
            }

        // When LocalSTTService finishes (silence detected → engine
        // stops), `isRecordingPublisher` flips to false. If we still
        // don't have a match, that's the "retry" moment.
        // dropFirst(1) skips the CurrentValueSubject's immediate replay of
        // false — without it the initial false delivery arrives on the next
        // run-loop while status is already .listening, satisfying the
        // !isRecording && status == .listening guard and immediately calling
        // cleanupSubscriptions() before the mic ever records anything.
        recordingSink = stt.isRecordingPublisher
            .dropFirst(1)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isRecording in
                guard let self else { return }
                if !isRecording && self.status == .listening {
                    // Engine stopped on its own. If transcript still
                    // empty or off-topic, prompt retry.
                    if !self.matchesAccepted(self.transcript) {
                        self.status = self.transcript.isEmpty ? .idle : .retry
                        self.cleanupSubscriptions()
                    }
                }
            }

        // If already authorized start recording immediately. Otherwise request
        // auth and let authSink (init) call startRecording when the OS dialog
        // resolves — calling requestAuthorization() when already authorized
        // re-publishes .authorized, which would trigger authSink's startRecording
        // branch while start() has also already called startRecording, causing
        // a double-start on the AVAudioEngine.
        if isSTTAuthorized {
            stt.startRecording(withOptions: [], localeCode: language.rawValue, offlineOnly: true)
        } else {
            stt.requestAuthorization()
        }
    }

    func stop() {
        stt.cancelRecording()
        cleanupSubscriptions()
        if status == .listening { status = .idle }
    }

    private func evaluate(_ partial: String) {
        // Case-insensitive contains over the localized keyword set so
        // natural phrasings succeed across languages: "the constitution",
        // "U.S. Constitution", "la constitución", "संविधान", "宪法",
        // etc.
        if matchesAccepted(partial) {
            status = .success
            stt.stopRecording()
            cleanupSubscriptions()
        }
    }

    private func matchesAccepted(_ text: String) -> Bool {
        let lower = text.lowercased()
        return acceptedKeywords.contains { lower.contains($0.lowercased()) }
    }

    /// Spoken-answer keywords for "What is the supreme law of the land?".
    /// Always includes "constitution" as a fallback so a learned English
    /// term still passes even when STT runs in another locale.
    private static func keywords(for language: AppLanguage) -> [String] {
        switch language {
        case .english: return ["constitution"]
        case .spanish: return ["constitución", "constitucion", "constitution"]
        case .nepali:  return ["संविधान", "constitution"]
        case .chinese: return ["宪法", "憲法", "constitution"]
        }
    }

    private func cleanupSubscriptions() {
        transcriptSink?.cancel(); transcriptSink = nil
        recordingSink?.cancel();  recordingSink = nil
    }
}

// ─────────────────────────────────────────────────────────────────
// What you'll master — content scope + 8 levels
// ─────────────────────────────────────────────────────────────────
private struct OnboardingMasterView: View {
    let language: AppLanguage
    let onContinue: () -> Void
    @State private var appeared = false

    private var s: UIStrings { UIStrings.forLanguage(language) }

    private let levelChips: [(label: String, color: Color)] = [
        ("L1",  .green),
        ("L2",  .green),
        ("L3",  .yellow),
        ("L4",  .orange),
        ("L5",  .red),
        ("L6",  .purple),
        ("L7",  .indigo),
        ("L8",  .pink)
    ]

    var body: some View {
        VStack(spacing: 18) {
            Spacer(minLength: 30)

            Text(s.onboardingMasterEyebrow)
                .font(.caption.bold())
                .foregroundColor(.cyan)
                .tracking(2)
                .textCase(.uppercase)
                .staggeredEntry(delay: 0.00, appeared: appeared)

            Text(s.onboardingMasterHeadline)
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .staggeredEntry(delay: 0.10, appeared: appeared)

            Text(s.onboardingMasterSubtitle)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.65))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .staggeredEntry(delay: 0.22, appeared: appeared)

            // 8-level chip bar
            VStack(spacing: 8) {
                Text(s.onboardingMasterLevelsLabel)
                    .font(.caption.bold())
                    .foregroundColor(.white.opacity(0.45))
                    .tracking(1)
                    .textCase(.uppercase)

                HStack(spacing: 6) {
                    ForEach(0..<levelChips.count, id: \.self) { i in
                        let chip = levelChips[i]
                        Text(chip.label)
                            .font(.caption.bold())
                            .foregroundColor(chip.color)
                            .frame(width: 34, height: 34)
                            .background(
                                Circle().fill(chip.color.opacity(0.15))
                            )
                            .overlay(
                                Circle().stroke(chip.color.opacity(0.45), lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.top, 6)
            .staggeredEntry(delay: 0.36, appeared: appeared)

            // 4 feature tiles
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                masterTile(icon: "mic.badge.plus", color: .cyan, title: s.onboardingMasterFeatureMock)
                masterTile(icon: "book.fill", color: .purple, title: s.onboardingMasterFeatureReading)
                masterTile(icon: "pencil.line", color: .indigo, title: s.onboardingMasterFeatureWriting)
                masterTile(icon: "headphones", color: .teal, title: s.onboardingMasterFeatureAudio)
            }
            .padding(.horizontal, 20)
            .padding(.top, 6)
            .staggeredEntry(delay: 0.50, appeared: appeared)

            // Footer line
            HStack(spacing: 8) {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.cyan)
                Text(s.onboardingMasterFooter)
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.top, 6)
            .staggeredEntry(delay: 0.64, appeared: appeared)

            Spacer()

            Button {
                let gen = UIImpactFeedbackGenerator(style: .medium); gen.impactOccurred()
                onContinue()
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
            .padding(.bottom, 12)
            .staggeredEntry(delay: 0.78, appeared: appeared)

            OnboardingStepDots(currentIndex: 4)
                .padding(.bottom, 24)
                .staggeredEntry(delay: 0.86, appeared: appeared)
        }
        .onAppear {
            appeared = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { appeared = true }
        }
    }

    private func masterTile(icon: String, color: Color, title: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 28)
            Text(title)
                .font(.subheadline.bold())
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

// ─────────────────────────────────────────────────────────────────
// Question Set Selection — shown as onboarding step after language
// ─────────────────────────────────────────────────────────────────
private struct OnboardingQuestionSetView: View {
    let language: AppLanguage
    @Binding var selectedSet: ProgressManager.QuestionSet
    let onContinue: () -> Void

    @State private var appeared = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 24)

            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 46))
                .foregroundColor(.cyan)
                .staggeredEntry(delay: 0.00, appeared: appeared)

            Text(headline)
                .font(.title.bold())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .staggeredEntry(delay: 0.10, appeared: appeared)

            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.55))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 28)
                .staggeredEntry(delay: 0.20, appeared: appeared)

            Spacer().frame(height: 4)

            VStack(spacing: 14) {
                trackCard(
                    set: .set2008,
                    icon: "checkmark.seal.fill",
                    iconColor: .green,
                    title: title100,
                    badge: badgeRecommended,
                    badgeColor: .green,
                    description: desc100,
                    detail: detail100
                )
                .staggeredEntry(delay: 0.32, appeared: appeared)

                trackCard(
                    set: .set2020,
                    icon: "books.vertical.fill",
                    iconColor: .purple,
                    title: title128,
                    badge: badgeComprehensive,
                    badgeColor: .purple,
                    description: desc128,
                    detail: detail128
                )
                .staggeredEntry(delay: 0.44, appeared: appeared)
            }
            .padding(.horizontal, 20)

            Spacer()

            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                onContinue()
            } label: {
                Text(continueLabel)
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
            .padding(.bottom, 12)
            .staggeredEntry(delay: 0.58, appeared: appeared)

            OnboardingStepDots(currentIndex: 1)
                .padding(.bottom, 24)
                .staggeredEntry(delay: 0.66, appeared: appeared)
        }
        .onAppear {
            appeared = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { appeared = true }
        }
    }

    private func trackCard(
        set: ProgressManager.QuestionSet,
        icon: String,
        iconColor: Color,
        title: String,
        badge: String,
        badgeColor: Color,
        description: String,
        detail: String
    ) -> some View {
        let isSelected = selectedSet == set
        return Button {
            UISelectionFeedbackGenerator().selectionChanged()
            selectedSet = set
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
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
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(badgeColor.opacity(0.15)))
                        .overlay(Capsule().stroke(badgeColor.opacity(0.4), lineWidth: 1))
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
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
    }

    // MARK: - Localized copy
    private var headline: String {
        switch language {
        case .english: return "Choose Your Study Track"
        case .nepali:  return "अध्ययन ट्र्याक छान्नुहोस्"
        case .spanish: return "Elige tu ruta de estudio"
        case .chinese: return "选择你的学习方向"
        }
    }
    private var subtitle: String {
        switch language {
        case .english: return "You can switch tracks anytime in Settings"
        case .nepali:  return "तपाईं सेटिङ्समा जुनसुकै बेला ट्र्याक परिवर्तन गर्न सक्नुहुन्छ"
        case .spanish: return "Puedes cambiar de ruta en cualquier momento en Ajustes"
        case .chinese: return "你可以随时在设置中切换方向"
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
        case .english: return "The current official USCIS civics test used at real naturalization interviews. Each practice set mirrors the real interview: 10 questions, pass 6 out of 10."
        case .nepali:  return "वास्तविक USCIS नागरिकता अन्तर्वार्तामा प्रयोग हुने आधिकारिक परीक्षा। प्रत्येक अभ्यास सेट वास्तविक अन्तर्वार्ता जस्तै: १० प्रश्न, १० मध्ये ६ पास।"
        case .spanish: return "El examen cívico oficial de USCIS que se usa en las entrevistas reales de naturalización. Cada set de práctica imita la entrevista real: 10 preguntas, pasa 6 de 10."
        case .chinese: return "目前真实USCIS入籍面试所使用的官方公民考试。每组练习模拟真实面试：10道题，通过需答对6道。"
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
        case .english: return "A broader 128-question bank for deep preparation. Covers every topic area in detail across 8 thematic practice levels."
        case .nepali:  return "गहन तयारीको लागि व्यापक १२८-प्रश्न बैंक। ८ विषयगत अभ्यास स्तरमा हरेक विषय क्षेत्र विस्तृत रूपमा समेट्छ।"
        case .spanish: return "Un banco de 128 preguntas más amplio para una preparación profunda. Cubre cada área temática en detalle en 8 niveles de práctica."
        case .chinese: return "包含128道题的广泛题库，助你深度备考。通过8个主题练习级别，全面涵盖各知识领域。"
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
    private var continueLabel: String {
        switch language {
        case .english: return "Continue"
        case .nepali:  return "जारी राख्नुहोस्"
        case .spanish: return "Continuar"
        case .chinese: return "继续"
        }
    }
}
