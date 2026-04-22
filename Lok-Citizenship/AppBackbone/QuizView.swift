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
            VStack(spacing: 20) {

                if isMultilingual {
                    languageToggleBar
                }

                progressSection

                if quizLogic.isFinished {
                    resultCard
                } else if isMultilingual {
                    questionSection
                    optionsSection
                    micSection
                } else {
                    questionSection
                    micSection
                    optionsSection
                }
            }
            .padding(.bottom, 40)
        }
        .padding()
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
        
        // When voice matches an answer in manual mode, process it
        .onChange(of: voice.matchedAnswerIndex) { idx in
            guard let idx else { return }
            processAnswer(idx)
            voice.resetMatch()
        }
    }
}

// ═════════════════════════════════════════════════════════════════
// MARK: - SUB-VIEWS
// ═════════════════════════════════════════════════════════════════

private extension QuizView {

    // MARK: Language toggle bar

    var languageToggleBar: some View {
        HStack {
            ForEach(Array(config.languageToggles.enumerated()), id: \.offset) { _, toggle in
                if toggle.variantIndex != config.languageToggles.first?.variantIndex {
                    Spacer()
                }
                Button(toggle.label) {
                    voice.stop()
                    quizLogic.switchVariant(to: toggle.variantIndex)
                    syncVoiceConfig()
                }
                .padding(isMultilingual && config.languageToggles.count > 2 ? 8 : 16)
                .background(quizLogic.selectedVariantIndex == toggle.variantIndex
                             ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(isMultilingual && config.languageToggles.count > 2 ? 8 : 10)
            }
        }
        .padding(.horizontal)
    }

    // MARK: Progress bar + score counter

    var progressSection: some View {
        VStack {
            ProgressView(
                value: Double(quizLogic.attemptedQuestions),
                total: Double(max(quizLogic.totalQuestions, 1))
            )
            .accentColor(.green)

            Text("\(quizLogic.attemptedQuestions)/\(quizLogic.totalQuestions)  •  "
                 + "\(strings.scoreLabel) \(quizLogic.scorePercentage)%")
                .font(.subheadline)
                .foregroundColor(.yellow)
        }
        .padding(.horizontal)
    }

    // MARK: Question text + speaker button

    var questionSection: some View {
        VStack(alignment: .leading, spacing: 8) {

            if isMultilingual {
                Text("\(strings.questionLabel) "
                     + "\(quizLogic.currentQuestionIndex + 1)/\(quizLogic.totalQuestions)")
                    .font(.subheadline)
                    .foregroundColor(.yellow)
            }

            if isMultilingual {
                Text(quizLogic.currentText)
                    .font(.title).bold().foregroundColor(.white)
            } else {
                Text("\(quizLogic.currentQuestionIndex + 1).  \(quizLogic.currentText)")
                    .font(.title).bold().foregroundColor(.white)
            }

            speakerButton
        }
        .padding(.horizontal)
    }

    var speakerButton: some View {
        HStack {
            Spacer()
            if voice.isSpeaking {
                Button { voice.stop() } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 28)).foregroundColor(.red)
                }
                .padding(.trailing, 24)
            } else {
                Button {
                    voice.stop()
                    speakQuestionAndOptions()
                } label: {
                    Image(systemName: "speaker.wave.1.fill")
                        .font(.system(size: 28)).foregroundColor(.blue)
                }
                .padding(.trailing, 24)
                .disabled(voice.isRecording || isAnswered)
            }
        }
    }

    // MARK: Answer option buttons + navigation

    var optionsSection: some View {
        VStack(spacing: 12) {

            ForEach(quizLogic.currentOptions.indices, id: \.self) { idx in
                Button {
                    voice.stop()
                    guard !isAnswered else { return }
                    processAnswer(idx)
                } label: {
                    HStack {
                        Text(optionLetter(idx))
                            .font(.headline.bold())
                            .foregroundColor(answerButtonTextColor(idx))
                            .frame(width: 28)
                        Text(quizLogic.currentOptions[idx])
                            .foregroundColor(answerButtonTextColor(idx))
                            .multilineTextAlignment(.leading)
                        Spacer()
                        if isAnswered && idx == quizLogic.currentQuestion.correctAnswer {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else if isAnswered && idx == selectedAnswer && idx != quizLogic.currentQuestion.correctAnswer {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(answerButtonBackground(idx))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(answerButtonBorder(idx), lineWidth: 1.5)
                    )
                }
                .disabled(isAnswered)
            }

            if showAnswerFeedback {
                feedbackAndNext
            } else {
                prevAndSkip
            }
        }
    }

    var feedbackAndNext: some View {
        VStack(spacing: 4) {
            Text(isAnswerCorrect ? strings.correct : strings.wrong)
                .font(.headline)
                .foregroundColor(isAnswerCorrect ? .green : .red)

            // Show explanation after wrong answer
            if !isAnswerCorrect {
                let explanation = quizLogic.currentQuestion.variants.first?.explanation ?? ""
                if !explanation.isEmpty {
                    Text(explanation)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .padding(.top, 4)
                }
            }

            Text("\(strings.mistakesLabel) \(quizLogic.incorrectAnswers)/4")
                .foregroundColor(.orange)

            Button(strings.nextQuestion) {
                voice.stop()
                quizLogic.moveToNextQuestion()
                resetPerQuestionState()
            }
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding(.bottom, 4)
    }

    var prevAndSkip: some View {
        HStack {
            Button(strings.previous) {
                voice.stop()
                quizLogic.previousQuestion()
                resetPerQuestionState()
            }
            .disabled(quizLogic.currentQuestionIndex == 0)
            .foregroundColor(.white)
            .padding()
            .background(Color.gray)
            .cornerRadius(10)

            Spacer()

            Button(strings.skip) {
                voice.stop()
                quizLogic.moveToNextQuestion()
                resetPerQuestionState()
            }
            .disabled(quizLogic.isFinished)
            .foregroundColor(.white)
            .padding()
            .background(Color.orange)
            .cornerRadius(10)
        }
    }

    // MARK: Mic button + transcription area

    var micSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(isMultilingual
                     ? "🎤 \(strings.yourAnswer)"
                     : strings.yourAnswer)
                    .font(.headline)
                    .foregroundColor(.white)

                Spacer()
                micButton
            }

            ScrollView {
                Text(voice.transcription)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
            }
            .frame(maxHeight: 120)
        }
        .padding(.horizontal)
    }

    var micButton: some View {
        Group {
            if voice.isRecording {
                Button { voice.stop() } label: {
                    Image(systemName: "mic.circle.fill")
                        .font(.system(size: 40)).foregroundColor(.red)
                }
            } else {
                Button {
                    guard voice.authorizationStatus == .authorized, !isAnswered else {
                        if voice.authorizationStatus != .authorized {
                            micPermissionDenied = true
                        }
                        return
                    }
                    voice.startManualListening()
                } label: {
                    Image(systemName: "mic.circle")
                        .font(.system(size: 40)).foregroundColor(.blue)
                }
                .disabled(voice.isSpeaking || isAnswered)
            }
        }
        .padding(.trailing, 24)
    }

    // MARK: Result / fail card

    var resultCard: some View {
        VStack(spacing: 8) {
            if quizLogic.status == .failed {
                Text(strings.failedTitle)
                    .font(.largeTitle).bold().foregroundColor(.red)
                Text(strings.failedSubtitle)
                    .foregroundColor(.white)
            } else {
                Text(strings.completed)
                    .font(.largeTitle).bold().foregroundColor(.white)
            }

            Text("\(strings.correctLabel) \(quizLogic.correctAnswers)")
                .foregroundColor(.green)
            Text("\(strings.incorrectLabel) \(quizLogic.incorrectAnswers)")
                .foregroundColor(.red)
            Text("\(strings.scoreLabel): \(quizLogic.scorePercentage)%")
                .font(.headline).foregroundColor(.yellow)

            progressSummary

            shareButton(
                score: quizLogic.correctAnswers,
                total: quizLogic.attemptedQuestions,
                passed: quizLogic.status != .failed
            )

            Button(strings.restartQuiz) {
                voice.stop()

                // Analytics context
                quizLogic.languageTag = localeCode
                quizLogic.levelTag = level

                quizLogic.startQuiz()
                resetPerQuestionState()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }

    var progressSummary: some View {
        let pm = ProgressManager.shared
        return VStack(spacing: 4) {
            Divider().background(Color.white.opacity(0.3))
            Text("Lifetime Stats")
                .font(.caption).foregroundColor(.gray)
            HStack(spacing: 16) {
                VStack {
                    Text("\(pm.totalQuestionsAnswered)")
                        .font(.headline).foregroundColor(.white)
                    Text("Answered")
                        .font(.caption2).foregroundColor(.gray)
                }
                VStack {
                    Text("\(pm.accuracyPercentage)%")
                        .font(.headline).foregroundColor(.white)
                    Text("Accuracy")
                        .font(.caption2).foregroundColor(.gray)
                }
                VStack {
                    Text("\(pm.currentStreak)")
                        .font(.headline).foregroundColor(.orange)
                    Text("Streak")
                        .font(.caption2).foregroundColor(.gray)
                }
            }
            .padding(.top, 4)
        }
        .padding(.vertical, 8)
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

    func answerButtonBackground(_ idx: Int) -> Color {
        guard isAnswered else { return Color.white.opacity(0.08) }
        if idx == quizLogic.currentQuestion.correctAnswer { return Color.green.opacity(0.2) }
        if idx == selectedAnswer { return Color.red.opacity(0.2) }
        return Color.white.opacity(0.04)
    }

    func answerButtonBorder(_ idx: Int) -> Color {
        guard isAnswered else { return Color.white.opacity(0.12) }
        if idx == quizLogic.currentQuestion.correctAnswer { return Color.green.opacity(0.6) }
        if idx == selectedAnswer { return Color.red.opacity(0.6) }
        return Color.white.opacity(0.05)
    }

    func answerButtonTextColor(_ idx: Int) -> Color {
        guard isAnswered else { return .white }
        if idx == quizLogic.currentQuestion.correctAnswer { return .green }
        if idx == selectedAnswer { return .red.opacity(0.8) }
        return .white.opacity(0.3)
    }

    func resetPerQuestionState() {
        selectedAnswer     = nil
        isAnswered         = false
        showAnswerFeedback = false
        voice.resetMatch()
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
        .padding(.top, 4)
    }
}
