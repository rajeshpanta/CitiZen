import SwiftUI

/// A single reusable quiz view that replaces all 20 Practice views.
/// Configured entirely by the `QuizConfig` passed in at init time.
struct QuizView: View {

    let config: QuizConfig
    let level: Int

    // MARK: - Quiz engine + voice controller

    @StateObject private var quizLogic = UnifiedQuizLogic()
    @StateObject private var voice: VoiceQuizController

    // MARK: - Per-question UI state (reset between questions)

    @State private var selectedAnswer: Int?
    @State private var showAnswerFeedback = false
    @State private var isAnswerCorrect    = false
    @State private var isAnswered         = false
    @State private var showVoicePanel     = false

    // MARK: - Alerts & Paywall

    @State private var showQuitConfirmation = false
    @State private var micPermissionDenied  = false
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Init (wire voice controller to quiz logic in manual mode)

    init(config: QuizConfig, level: Int) {
        self.config = config
        self.level = level

        let logic = UnifiedQuizLogic()
        let vc = VoiceQuizController(quizLogic: logic)
        vc.autoAdvance = false  // practice mode: view controls answer flow
        _quizLogic = StateObject(wrappedValue: logic)
        _voice = StateObject(wrappedValue: vc)
    }

    // MARK: - Derived helpers

    private var isMultilingual: Bool {
        !config.languageToggles.isEmpty
    }

    private var strings: QuizStrings {
        config.stringsForVariant(quizLogic.selectedVariantIndex)
    }

    private var localeCode: String {
        config.localeForVariant(quizLogic.selectedVariantIndex)
    }

    private var quizLevel: String {
        "practice_\(level)"
    }

    private var offlineOnly: Bool {
        config.offlineForVariant(quizLogic.selectedVariantIndex)
    }

    private var mistakesRemaining: Int {
        max(0, 4 - quizLogic.incorrectAnswers)
    }

    /// Sync voice controller config when variant changes.
    private func syncVoiceConfig() {
        voice.localeCode = localeCode
        voice.offlineSTT = offlineOnly
        voice.variantIndex = quizLogic.selectedVariantIndex
    }

    // ─────────────────────────────────────────────────────────────
    // MARK: - BODY
    // ─────────────────────────────────────────────────────────────

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {

                if isMultilingual {
                    languageToggleBar
                }

                progressSection

                if quizLogic.isFinished {
                    resultCard
                } else {
                    questionCard
                    optionsSection
                    voiceSection
                    if !isAnswered {
                        navButtons
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, isAnswered ? 180 : 32)
        }
        .scrollIndicators(.hidden)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(strings.quit, role: .destructive) {
                    voice.stop()
                    showQuitConfirmation = true
                }
                .foregroundColor(.red)
            }
        }
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.0, green: 0.10, blue: 0.30),
                    Color(red: 0.0, green: 0.05, blue: 0.18),
                    Color.black
                ],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if isAnswered && !quizLogic.isFinished {
                feedbackBar
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: isAnswered)
        .animation(.easeInOut(duration: 0.2), value: showVoicePanel)
        .alert(isPresented: $showQuitConfirmation) {
            Alert(
                title: Text(strings.quitTitle),
                message: Text(strings.quitMessage),
                primaryButton: .destructive(Text(strings.quitYes)) {
                    voice.stop()
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel(Text(strings.quitNo))
            )
        }
        .alert(strings.micPermissionAlert, isPresented: $micPermissionDenied) {
            Button("OK", role: .cancel) { }
        }
        .onAppear {
            quizLogic.selectedVariantIndex = config.defaultVariantIndex
            quizLogic.questions = config.questions

            // Analytics context
            quizLogic.languageTag = localeCode
            quizLogic.levelTag = level

            quizLogic.startQuiz()
            syncVoiceConfig()
            voice.requestAuthorization()
        }
        .onDisappear {
            // Defensive cleanup. Quit/Back buttons already call voice.stop(),
            // but the interactive swipe-back gesture and programmatic dismissal
            // can bypass those paths and leave TTS/STT running in the background.
            // voice.stop() is idempotent so the double-call on explicit paths is a no-op.
            voice.stop()
        }

        // When voice matches an answer in manual mode, process it
        .onChange(of: voice.matchedAnswerIndex) { idx in
            guard let idx else { return }
            processAnswer(idx)
            voice.resetMatch()
        }
        .onChange(of: voice.isRecording) { recording in
            if recording { showVoicePanel = true }
        }
    }
}

// ═════════════════════════════════════════════════════════════════
// MARK: - SUB-VIEWS
// ═════════════════════════════════════════════════════════════════

private extension QuizView {

    // MARK: Language toggle bar

    var languageToggleBar: some View {
        HStack(spacing: 8) {
            ForEach(Array(config.languageToggles.enumerated()), id: \.offset) { _, toggle in
                Button {
                    voice.stop()
                    quizLogic.switchVariant(to: toggle.variantIndex)
                    syncVoiceConfig()
                } label: {
                    Text(toggle.label)
                        .font(.footnote.bold())
                        .foregroundColor(quizLogic.selectedVariantIndex == toggle.variantIndex
                                         ? .white : .white.opacity(0.55))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(quizLogic.selectedVariantIndex == toggle.variantIndex
                                      ? Color.blue
                                      : Color.white.opacity(0.08))
                        )
                }
            }
        }
    }

    // MARK: Progress header (bar + stats row)

    var progressSection: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.12))
                    .frame(height: 8)
                GeometryReader { geo in
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Color.green, Color.mint],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .frame(
                            width: progressFraction * geo.size.width,
                            height: 8
                        )
                }
                .frame(height: 8)
            }

            HStack(spacing: 14) {
                // Question counter
                Label("\(quizLogic.attemptedQuestions)/\(quizLogic.totalQuestions)",
                      systemImage: "list.bullet")
                    .font(.caption.bold())
                    .foregroundColor(.white.opacity(0.75))

                Spacer()

                // Score pill
                Text("\(strings.scoreLabel) \(quizLogic.scorePercentage)%")
                    .font(.caption.bold())
                    .foregroundColor(.yellow)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(
                        Capsule().fill(Color.yellow.opacity(0.15))
                    )

                // Mistake pips
                HStack(spacing: 3) {
                    ForEach(0..<4, id: \.self) { i in
                        Image(systemName: i < mistakesRemaining ? "heart.fill" : "heart")
                            .font(.caption2)
                            .foregroundColor(i < mistakesRemaining ? .red : .white.opacity(0.25))
                    }
                }
            }
        }
    }

    var progressFraction: CGFloat {
        guard quizLogic.totalQuestions > 0 else { return 0 }
        return CGFloat(quizLogic.attemptedQuestions) / CGFloat(quizLogic.totalQuestions)
    }

    // MARK: Question card

    var questionCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline) {
                Text(isMultilingual
                     ? "\(strings.questionLabel) \(quizLogic.currentQuestionIndex + 1)"
                     : "Q\(quizLogic.currentQuestionIndex + 1)")
                    .font(.caption.bold())
                    .foregroundColor(.white.opacity(0.5))
                    .tracking(1)
                    .textCase(.uppercase)

                Spacer()

                speakerButton
            }

            Text(quizLogic.currentText)
                .font(.title2.bold())
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)

            if quizLogic.currentQuestion.isTimeSensitive {
                timeSensitiveNote
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }

    /// Shown on questions whose correct answer changes with current officeholders.
    /// Rendered in the user's app language so they know to verify at uscis.gov.
    var timeSensitiveNote: some View {
        HStack(alignment: .top, spacing: 6) {
            Image(systemName: "info.circle.fill")
                .font(.caption2)
                .foregroundColor(.yellow.opacity(0.85))
                .padding(.top, 2)
            Text(UIStrings.forLocaleCode(localeCode).questionTimeSensitiveNote)
                .font(.caption2)
                .foregroundColor(.yellow.opacity(0.75))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    var speakerButton: some View {
        Button {
            if voice.isSpeaking {
                voice.stop()
            } else {
                voice.stop()
                speakQuestionAndOptions()
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: voice.isSpeaking
                      ? "speaker.wave.2.fill"
                      : "play.fill")
                    .font(.caption.bold())
                Text(voice.isSpeaking ? "Stop" : "Listen")
                    .font(.caption.bold())
            }
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule().fill(voice.isSpeaking
                               ? Color.red.opacity(0.85)
                               : Color.blue.opacity(0.85))
            )
        }
        .disabled(voice.isRecording || isAnswered)
        .opacity(voice.isRecording || isAnswered ? 0.4 : 1)
    }

    // MARK: Answer options

    var optionsSection: some View {
        VStack(spacing: 10) {
            ForEach(quizLogic.currentOptions.indices, id: \.self) { idx in
                Button {
                    voice.stop()
                    guard !isAnswered else { return }
                    processAnswer(idx)
                } label: {
                    optionRow(idx)
                }
                .disabled(isAnswered)
                .buttonStyle(.plain)
            }
        }
    }

    @ViewBuilder
    func optionRow(_ idx: Int) -> some View {
        let isCorrectOption = idx == quizLogic.currentQuestion.correctAnswer
        let isSelectedWrong = isAnswered && idx == selectedAnswer && !isCorrectOption

        HStack(spacing: 12) {
            Text(optionLetter(idx))
                .font(.subheadline.bold())
                .foregroundColor(optionLetterColor(idx))
                .frame(width: 28, height: 28)
                .background(
                    Circle().fill(optionLetterBG(idx))
                )

            Text(quizLogic.currentOptions[idx])
                .font(.body)
                .foregroundColor(optionTextColor(idx))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            if isAnswered && isCorrectOption {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else if isSelectedWrong {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, minHeight: 56)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(optionBackground(idx))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(optionBorder(idx), lineWidth: 1.5)
        )
    }

    // MARK: Voice input (collapsed by default)

    @ViewBuilder
    var voiceSection: some View {
        if isAnswered {
            EmptyView()
        } else if showVoicePanel || voice.isRecording || !voice.transcription.isEmpty {
            voiceExpanded
        } else {
            voiceCollapsed
        }
    }

    var voiceCollapsed: some View {
        Button {
            tryStartListening()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "mic.fill")
                    .font(.subheadline)
                Text(strings.yourAnswer)
                    .font(.subheadline.bold())
                Spacer()
                Text(UIStrings.forLocaleCode(localeCode).quizTapToSpeakHint)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
            }
            .foregroundColor(.white.opacity(0.85))
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.18))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue.opacity(0.35), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    var voiceExpanded: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label(strings.yourAnswer, systemImage: voice.isRecording
                      ? "waveform"
                      : "mic.fill")
                    .font(.subheadline.bold())
                    .foregroundColor(voice.isRecording ? .red : .white)

                Spacer()

                if voice.isRecording {
                    Button {
                        voice.stop()
                    } label: {
                        Image(systemName: "stop.circle.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                    .accessibilityLabel(UIStrings.forLocaleCode(localeCode).a11yStopRecording)
                } else {
                    HStack(spacing: 10) {
                        Button {
                            voice.stop()
                            showVoicePanel = false
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .accessibilityLabel(UIStrings.forLocaleCode(localeCode).a11yClose)
                        Button {
                            tryStartListening()
                        } label: {
                            Image(systemName: "mic.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                        .disabled(voice.isSpeaking)
                        .accessibilityLabel(UIStrings.forLocaleCode(localeCode).a11yStartRecording)
                    }
                }
            }

            Text(voice.transcription.isEmpty
                 ? (voice.isRecording
                    ? UIStrings.forLocaleCode(localeCode).quizMicListening
                    : UIStrings.forLocaleCode(localeCode).quizMicPressToRetry)
                 : voice.transcription)
                .font(.body)
                .foregroundColor(voice.transcription.isEmpty
                                 ? .white.opacity(0.4)
                                 : .white)
                .frame(maxWidth: .infinity, minHeight: 46, alignment: .leading)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.black.opacity(0.35))
                )
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(voice.isRecording ? Color.red.opacity(0.5) : Color.white.opacity(0.1),
                        lineWidth: 1)
        )
    }

    // MARK: Previous / Skip (only before answering)

    var navButtons: some View {
        HStack(spacing: 12) {
            Button {
                voice.stop()
                quizLogic.previousQuestion()
                resetPerQuestionState()
            } label: {
                Label(strings.previous, systemImage: "chevron.left")
                    .font(.subheadline.bold())
                    .foregroundColor(.white.opacity(0.8))
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.08))
                    )
            }
            .disabled(quizLogic.currentQuestionIndex == 0)
            .opacity(quizLogic.currentQuestionIndex == 0 ? 0.4 : 1)

            Button {
                voice.stop()
                quizLogic.moveToNextQuestion()
                resetPerQuestionState()
            } label: {
                Label(strings.skip, systemImage: "chevron.right")
                    .labelStyle(.titleAndIcon)
                    .environment(\.layoutDirection, .rightToLeft)
                    .font(.subheadline.bold())
                    .foregroundColor(.white.opacity(0.8))
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.08))
                    )
            }
            .disabled(quizLogic.isFinished)
        }
    }

    // MARK: Sticky feedback bar (visible after answering)

    var feedbackBar: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: isAnswerCorrect
                      ? "checkmark.circle.fill"
                      : "xmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(isAnswerCorrect ? .green : .red)

                Text(isAnswerCorrect ? strings.correct : strings.wrong)
                    .font(.headline.bold())
                    .foregroundColor(isAnswerCorrect ? .green : .red)

                Spacer()

                Text("\(strings.mistakesLabel) \(quizLogic.incorrectAnswers)/4")
                    .font(.caption.bold())
                    .foregroundColor(.orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(Color.orange.opacity(0.15)))
            }

            if !isAnswerCorrect {
                let explanation = quizLogic.currentQuestion.variants.first?.explanation ?? ""
                if !explanation.isEmpty {
                    Text(explanation)
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            Button {
                voice.stop()
                quizLogic.moveToNextQuestion()
                resetPerQuestionState()
            } label: {
                HStack {
                    Text(strings.nextQuestion)
                        .font(.headline.bold())
                    Image(systemName: "arrow.right")
                        .font(.subheadline.bold())
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 52)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(LinearGradient(
                            colors: [Color.orange, Color.orange.opacity(0.85)],
                            startPoint: .leading, endPoint: .trailing))
                )
            }
        }
        .padding(16)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.55),
                            Color.black.opacity(0.85)
                        ],
                        startPoint: .top, endPoint: .bottom
                    )
                )
                .ignoresSafeArea(edges: .bottom)
        )
        .overlay(
            Rectangle()
                .fill(
                    (isAnswerCorrect ? Color.green : Color.red).opacity(0.5)
                )
                .frame(height: 2),
            alignment: .top
        )
    }

    // MARK: Result / fail card

    var resultCard: some View {
        VStack(spacing: 14) {
            if quizLogic.status == .failed {
                Image(systemName: "xmark.seal.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.red)
                Text(strings.failedTitle)
                    .font(.title.bold()).foregroundColor(.red)
                Text(strings.failedSubtitle)
                    .foregroundColor(.white.opacity(0.7))
            } else {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.green)
                Text(strings.completed)
                    .font(.title.bold()).foregroundColor(.white)
            }

            HStack(spacing: 18) {
                statPill(value: "\(quizLogic.correctAnswers)",
                         label: strings.correctLabel,
                         color: .green)
                statPill(value: "\(quizLogic.incorrectAnswers)",
                         label: strings.incorrectLabel,
                         color: .red)
                statPill(value: "\(quizLogic.scorePercentage)%",
                         label: strings.scoreLabel,
                         color: .yellow)
            }
            .padding(.top, 4)

            progressSummary

            shareButton(
                score: quizLogic.correctAnswers,
                total: quizLogic.attemptedQuestions,
                passed: quizLogic.status != .failed
            )

            Button {
                voice.stop()

                // Analytics context
                quizLogic.languageTag = localeCode
                quizLogic.levelTag = level

                quizLogic.startQuiz()
                resetPerQuestionState()
            } label: {
                Label(strings.restartQuiz, systemImage: "arrow.clockwise")
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.blue)
                    )
            }
            .padding(.top, 4)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }

    func statPill(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.title3.bold())
                .foregroundColor(color)
            Text(label)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.12))
        )
    }

    var progressSummary: some View {
        let pm = ProgressManager.shared
        let ui = UIStrings.forLocaleCode(localeCode)
        return VStack(spacing: 6) {
            Divider().background(Color.white.opacity(0.15))
            Text(ui.quizLifetimeStats)
                .font(.caption).foregroundColor(.gray)
            HStack(spacing: 20) {
                VStack {
                    Text("\(pm.totalQuestionsAnswered)")
                        .font(.headline).foregroundColor(.white)
                    Text(ui.quizStatAnswered)
                        .font(.caption2).foregroundColor(.gray)
                }
                VStack {
                    Text("\(pm.accuracyPercentage)%")
                        .font(.headline).foregroundColor(.white)
                    Text(ui.readinessAccuracy)
                        .font(.caption2).foregroundColor(.gray)
                }
                VStack {
                    Text("\(pm.currentStreak)")
                        .font(.headline).foregroundColor(.orange)
                    Text(ui.quizStatStreak)
                        .font(.caption2).foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// ═════════════════════════════════════════════════════════════════
// MARK: - ANSWER + SPEECH HELPERS
// ═════════════════════════════════════════════════════════════════

private extension QuizView {

    /// Central answer handler — used by both tap and voice paths.
    func processAnswer(_ idx: Int) {
        guard !isAnswered else { return }
        selectedAnswer     = idx
        isAnswerCorrect    = quizLogic.answerQuestion(idx)
        showAnswerFeedback = true
        isAnswered         = true
        showVoicePanel     = false
    }

    func tryStartListening() {
        guard voice.authorizationStatus == .authorized, !isAnswered else {
            if voice.authorizationStatus != .authorized {
                micPermissionDenied = true
            }
            return
        }
        showVoicePanel = true
        voice.startManualListening()
    }

    /// Speak the question text, then "Your options are:", then each option.
    func speakQuestionAndOptions() {
        let introDelay = config.questionToOptionsDelay
        var items: [(text: String, delay: TimeInterval)] = [
            (quizLogic.currentText, introDelay),
            (strings.optionsIntro, 1.0)
        ]
        for opt in quizLogic.currentOptions {
            items.append((opt, 1.0))
        }
        syncVoiceConfig()
        voice.speakSequence(items)
    }

    func optionLetter(_ idx: Int) -> String {
        ["A", "B", "C", "D", "E", "F"][min(idx, 5)]
    }

    // MARK: Option color helpers

    func optionBackground(_ idx: Int) -> Color {
        guard isAnswered else { return Color.white.opacity(0.06) }
        if idx == quizLogic.currentQuestion.correctAnswer { return Color.green.opacity(0.18) }
        if idx == selectedAnswer { return Color.red.opacity(0.18) }
        return Color.white.opacity(0.03)
    }

    func optionBorder(_ idx: Int) -> Color {
        guard isAnswered else { return Color.white.opacity(0.12) }
        if idx == quizLogic.currentQuestion.correctAnswer { return Color.green.opacity(0.7) }
        if idx == selectedAnswer { return Color.red.opacity(0.7) }
        return Color.white.opacity(0.05)
    }

    func optionTextColor(_ idx: Int) -> Color {
        guard isAnswered else { return .white }
        if idx == quizLogic.currentQuestion.correctAnswer { return .green }
        if idx == selectedAnswer { return .red.opacity(0.9) }
        return .white.opacity(0.35)
    }

    func optionLetterColor(_ idx: Int) -> Color {
        guard isAnswered else { return .white }
        if idx == quizLogic.currentQuestion.correctAnswer { return .white }
        if idx == selectedAnswer { return .white }
        return .white.opacity(0.35)
    }

    func optionLetterBG(_ idx: Int) -> Color {
        guard isAnswered else { return Color.white.opacity(0.12) }
        if idx == quizLogic.currentQuestion.correctAnswer { return Color.green.opacity(0.8) }
        if idx == selectedAnswer { return Color.red.opacity(0.8) }
        return Color.white.opacity(0.08)
    }

    func resetPerQuestionState() {
        selectedAnswer     = nil
        isAnswered         = false
        showAnswerFeedback = false
        showVoicePanel     = false
        voice.resetMatch()
        // Clear stale mic transcription from the previous question. Otherwise
        // the expanded voice panel reappears on Q2 showing Q1's answer text
        // (the panel auto-expands whenever voice.transcription is non-empty).
        voice.clearTranscription()
    }

    func shareButton(score: Int, total: Int, passed: Bool) -> some View {
        let card = ShareCardView(
            score: score,
            total: total,
            passed: passed,
            streak: ProgressManager.shared.currentStreak
        )
        return Button {
            guard let image = card.renderImage() else { return }
            let av = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let root = scene.windows.first?.rootViewController else { return }
            if let popover = av.popoverPresentationController {
                popover.sourceView = root.view
                popover.sourceRect = CGRect(x: root.view.bounds.midX, y: root.view.bounds.midY, width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
            root.present(av, animated: true)
        } label: {
            Label("Share Result", systemImage: "square.and.arrow.up")
                .font(.subheadline.bold())
                .foregroundColor(.blue)
        }
        .padding(.top, 2)
    }
}
