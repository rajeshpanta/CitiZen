import SwiftUI
import Combine
import AVFoundation
import Speech

/// A single reusable quiz view that replaces all 20 Practice views.
/// Configured entirely by the `QuizConfig` passed in at init time.
struct QuizView: View {

    let config: QuizConfig

    // MARK: - Quiz engine

    @StateObject private var quizLogic = UnifiedQuizLogic()

    // MARK: - Per-question UI state (reset between questions)

    @State private var selectedAnswer: Int?
    @State private var showAnswerFeedback = false
    @State private var isAnswerCorrect    = false
    @State private var isAnswered         = false

    // MARK: - TTS / STT state (mirrors from Combine publishers)

    @State private var isSpeaking  = false
    @State private var isRecording = false
    @State private var transcription = ""
    @State private var authorizationStatus: SFSpeechRecognizerAuthorizationStatus = .notDetermined
    @State private var ttsChain: AnyCancellable?

    // MARK: - Alerts

    @State private var showQuitConfirmation = false
    @State private var micPermissionDenied  = false
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Services

    private let tts: TextToSpeechService = ServiceLocator.shared.ttsService
    private let stt: SpeechToTextService = ServiceLocator.shared.sttService

    // MARK: - Derived helpers

    /// True when the quiz supports language switching (bilingual or trilingual).
    private var isMultilingual: Bool {
        !config.languageToggles.isEmpty
    }

    /// Current localized UI strings based on the selected language variant.
    private var strings: QuizStrings {
        config.stringsForVariant(quizLogic.selectedVariantIndex)
    }

    /// Current TTS/STT locale based on the selected language variant.
    private var localeCode: String {
        config.localeForVariant(quizLogic.selectedVariantIndex)
    }

    /// Whether STT should prefer on-device recognition for the current variant.
    private var offlineOnly: Bool {
        config.offlineForVariant(quizLogic.selectedVariantIndex)
    }

    // ─────────────────────────────────────────────────────────────
    // MARK: - BODY
    // ─────────────────────────────────────────────────────────────

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Language toggle (only for bilingual / trilingual quizzes)
                if isMultilingual {
                    languageToggleBar
                }

                // Progress bar + score
                progressSection

                // Quiz content or result screen
                if quizLogic.showResult || quizLogic.hasFailed {
                    resultCard
                } else if isMultilingual {
                    // Bilingual/trilingual layout: question → options → mic
                    questionSection
                    optionsSection
                    micSection
                } else {
                    // English-only layout: question → mic → options
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
                    stopAllAudio()
                    showQuitConfirmation = true
                }
                .foregroundColor(.red)
            }
        }
        .background(
            ZStack {
                Image(config.backgroundImage).resizable().scaledToFill()
                Color.black.opacity(0.8)
            }
            .ignoresSafeArea()
        )

        // Quit confirmation alert
        .alert(isPresented: $showQuitConfirmation) {
            Alert(
                title: Text(strings.quitTitle),
                message: Text(strings.quitMessage),
                primaryButton: .destructive(Text(strings.quitYes)) {
                    stopAllAudio()
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel(Text(strings.quitNo))
            )
        }

        // Mic permission denied alert
        .alert(strings.micPermissionAlert, isPresented: $micPermissionDenied) {
            Button("OK", role: .cancel) { }
        }

        // Setup on first appearance
        .onAppear {
            quizLogic.selectedVariantIndex = config.defaultVariantIndex
            quizLogic.questions = config.questions
            quizLogic.startQuiz()
            stt.requestAuthorization()
        }

        // Bridge Combine publishers → @State
        .onReceive(tts.isSpeakingPublisher) { isSpeaking = $0 }
        .onReceive(stt.isRecordingPublisher) { rec in
            // When recording stops, check if voice matched an answer
            if isRecording && !rec { checkVoiceAnswer() }
            isRecording = rec
        }
        .onReceive(stt.transcriptionPublisher)       { transcription       = $0 }
        .onReceive(stt.authorizationStatusPublisher) { authorizationStatus = $0 }
    }
}

// ═════════════════════════════════════════════════════════════════
// MARK: - SUB-VIEWS
// ═════════════════════════════════════════════════════════════════

private extension QuizView {

    // MARK: Language toggle bar

    /// Row of buttons to switch between languages (e.g. English ↔ Nepali).
    var languageToggleBar: some View {
        HStack {
            ForEach(Array(config.languageToggles.enumerated()), id: \.offset) { _, toggle in
                if toggle.variantIndex != config.languageToggles.first?.variantIndex {
                    Spacer()
                }
                Button(toggle.label) {
                    stopAllAudio()
                    quizLogic.switchVariant(to: toggle.variantIndex)
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

            // Bilingual: separate yellow "Question 1/15" label
            if isMultilingual {
                Text("\(strings.questionLabel) "
                     + "\(quizLogic.currentQuestionIndex + 1)/\(quizLogic.totalQuestions)")
                    .font(.subheadline)
                    .foregroundColor(.yellow)
            }

            // Question text
            // English-only: inline number prefix "1.  What is..."
            // Bilingual: just the question text (number is in the label above)
            if isMultilingual {
                Text(quizLogic.currentText)
                    .font(.title).bold().foregroundColor(.white)
            } else {
                Text("\(quizLogic.currentQuestionIndex + 1).  \(quizLogic.currentText)")
                    .font(.title).bold().foregroundColor(.white)
            }

            // Speaker button (TTS)
            speakerButton
        }
        .padding(.horizontal)
    }

    /// TTS speaker icon: red while speaking, blue otherwise.
    var speakerButton: some View {
        HStack {
            Spacer()
            if isSpeaking {
                Button { stopAllAudio() } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 28)).foregroundColor(.red)
                }
                .padding(.trailing, 24)
            } else {
                Button {
                    stopAllAudio()
                    speakQuestionAndOptions()
                } label: {
                    Image(systemName: "speaker.wave.1.fill")
                        .font(.system(size: 28)).foregroundColor(.blue)
                }
                .padding(.trailing, 24)
                .disabled(isRecording || isAnswered)
            }
        }
    }

    // MARK: Answer option buttons + navigation

    var optionsSection: some View {
        VStack(spacing: 12) {

            // Four multiple-choice buttons
            ForEach(quizLogic.currentOptions.indices, id: \.self) { idx in
                Button {
                    stopAllAudio()
                    guard !isAnswered else { return }
                    selectedAnswer     = idx
                    isAnswerCorrect    = quizLogic.answerQuestion(idx)
                    showAnswerFeedback = true
                    isAnswered         = true
                } label: {
                    Text(quizLogic.currentOptions[idx])
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(
                            isAnswered
                            ? (idx == quizLogic.currentQuestion.correctAnswer
                               ? Color.green : Color.red)
                            : Color.blue
                        )
                        .cornerRadius(10)
                }
                .disabled(isAnswered)
            }

            // After answering: feedback + Next button
            // Before answering: Previous + Skip buttons
            if showAnswerFeedback {
                feedbackAndNext
            } else {
                prevAndSkip
            }
        }
    }

    /// Shows correct/wrong feedback, mistake count, and Next Question button.
    var feedbackAndNext: some View {
        VStack(spacing: 4) {
            Text(isAnswerCorrect ? strings.correct : strings.wrong)
                .font(.headline)
                .foregroundColor(isAnswerCorrect ? .green : .red)

            Text("\(strings.mistakesLabel) \(quizLogic.incorrectAnswers)/4")
                .foregroundColor(.orange)

            Button(strings.nextQuestion) {
                stopAllAudio()
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

    /// Previous and Skip navigation buttons.
    var prevAndSkip: some View {
        HStack {
            Button(strings.previous) {
                stopAllAudio()
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
                stopAllAudio()
                quizLogic.moveToNextQuestion()
                resetPerQuestionState()
            }
            .disabled(quizLogic.showResult || quizLogic.hasFailed)
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
                // English-only: "Your Answer:"
                // Bilingual: "🎤 Your Answer:" (with emoji prefix)
                Text(isMultilingual
                     ? "🎤 \(strings.yourAnswer)"
                     : strings.yourAnswer)
                    .font(.headline)
                    .foregroundColor(.white)

                Spacer()
                micButton
            }

            // Live transcription display
            ScrollView {
                Text(transcription)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
            }
            .frame(maxHeight: 120)
        }
        .padding(.horizontal)
    }

    /// Mic icon: red pulsing circle while recording, blue outline otherwise.
    var micButton: some View {
        Group {
            if isRecording {
                Button { stopAllAudio() } label: {
                    Image(systemName: "mic.circle.fill")
                        .font(.system(size: 40)).foregroundColor(.red)
                }
            } else {
                Button {
                    guard authorizationStatus == .authorized, !isAnswered else {
                        if authorizationStatus != .authorized {
                            micPermissionDenied = true
                        }
                        return
                    }
                    stopAllAudio()
                    stt.startRecording(
                        withOptions: quizLogic.currentOptions,
                        localeCode:  localeCode,
                        offlineOnly: offlineOnly
                    )
                } label: {
                    Image(systemName: "mic.circle")
                        .font(.system(size: 40)).foregroundColor(.blue)
                }
                .disabled(isSpeaking || isAnswered)
            }
        }
        .padding(.trailing, 24)
    }

    // MARK: Result / fail card

    var resultCard: some View {
        VStack(spacing: 8) {
            if quizLogic.hasFailed {
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

            Button(strings.restartQuiz) {
                stopAllAudio()
                quizLogic.startQuiz()
                resetPerQuestionState()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

// ═════════════════════════════════════════════════════════════════
// MARK: - SPEECH HELPERS
// ═════════════════════════════════════════════════════════════════

private extension QuizView {

    /// Speak the question text, then "Your options are:", then each option.
    /// Uses config.questionToOptionsDelay (2.0s for English, 1.5s for others).
    func speakQuestionAndOptions() {
        let lc = localeCode
        let introDelay = config.questionToOptionsDelay

        var chain: AnyPublisher<Void, Never> = tts
            .speak(quizLogic.currentText, languageCode: lc)
            .flatMap { _ in Just(()).delay(for: .seconds(introDelay),
                                          scheduler: DispatchQueue.main) }
            .flatMap { tts.speak(strings.optionsIntro, languageCode: lc) }
            .flatMap { _ in Just(()).delay(for: .seconds(1.0),
                                          scheduler: DispatchQueue.main) }
            .eraseToAnyPublisher()

        for opt in quizLogic.currentOptions {
            chain = chain
                .flatMap { tts.speak(opt, languageCode: lc) }
                .flatMap { _ in Just(()).delay(for: .seconds(1.0),
                                              scheduler: DispatchQueue.main) }
                .eraseToAnyPublisher()
        }

        ttsChain = chain.sink { _ in }
    }

    /// When STT stops recording, check if the transcription matches any option.
    /// Uses the same case-insensitive contains-matching as the original views.
    func checkVoiceAnswer() {
        guard !isAnswered else { return }
        let spoken = transcription
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard let idx = quizLogic.currentOptions.firstIndex(where: {
            let lc = $0.lowercased()
            return spoken == lc || spoken.contains(lc)
        }) else { return }

        stopAllAudio()
        isAnswered         = true
        selectedAnswer     = idx
        isAnswerCorrect    = quizLogic.answerQuestion(idx)
        showAnswerFeedback = true
    }

    /// Clear per-question state when moving to the next question.
    func resetPerQuestionState() {
        selectedAnswer     = nil
        isAnswered         = false
        showAnswerFeedback = false
        transcription      = ""
    }

    /// Stop all audio: cancel TTS chain, stop synthesizer, stop mic.
    func stopAllAudio() {
        ttsChain?.cancel(); ttsChain = nil
        tts.stopSpeaking()
        stt.stopRecording()
    }
}
