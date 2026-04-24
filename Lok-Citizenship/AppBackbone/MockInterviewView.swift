import SwiftUI
import Speech

// ═════════════════════════════════════════════════════════════════
// MARK: - Question Pool Helper
// ═════════════════════════════════════════════════════════════════

enum QuestionPool {
    static func allQuestions(for language: AppLanguage) -> [UnifiedQuestion] {
        switch language {
        case .english:
            return EnglishQuestions.practice1 + EnglishQuestions.practice2
                 + EnglishQuestions.practice3 + EnglishQuestions.practice4
                 + EnglishQuestions.practice5
        case .nepali:
            return NepaliQuestions.practice1 + NepaliQuestions.practice2
                 + NepaliQuestions.practice3 + NepaliQuestions.practice4
                 + NepaliQuestions.practice5
        case .spanish:
            return SpanishQuestions.practice1 + SpanishQuestions.practice2
                 + SpanishQuestions.practice3 + SpanishQuestions.practice4
                 + SpanishQuestions.practice5
        case .chinese:
            return ChineseQuestions.practice1 + ChineseQuestions.practice2
                 + ChineseQuestions.practice3 + ChineseQuestions.practice4
                 + ChineseQuestions.practice5
        }
    }
}

// ═════════════════════════════════════════════════════════════════
// MARK: - Mock Interview View
// ═════════════════════════════════════════════════════════════════

struct MockInterviewView: View {

    let language: AppLanguage

    @StateObject private var quizLogic = UnifiedQuizLogic()
    @StateObject private var voice: VoiceQuizController

    @Environment(\.presentationMode) private var presentationMode

    private let interviewQuestionCount = 10
    private let requiredCorrect = 8

    // Custom init to wire voice controller to quiz logic
    init(language: AppLanguage) {
        self.language = language
        let logic = UnifiedQuizLogic()
        let vc = VoiceQuizController(quizLogic: logic)
        vc.requireContinueOnWrong = true
        _quizLogic = StateObject(wrappedValue: logic)
        _voice = StateObject(wrappedValue: vc)
    }

    @State private var mockRecorded = false
    @State private var pulseRing = false

    private var s: UIStrings { UIStrings.forLanguage(language) }

    private var endLabel: String {
        switch language {
        case .english: return "End"
        case .spanish: return "Terminar"
        case .nepali:  return "समाप्त"
        case .chinese: return "结束"
        }
    }

    private var backLabel: String {
        switch language {
        case .english: return "Back"
        case .spanish: return "Atrás"
        case .nepali:  return "पछाडि"
        case .chinese: return "返回"
        }
    }

    // ─────────────────────────────────────────────────────────────
    // MARK: - BODY
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

            Group {
                if quizLogic.isFinished {
                    resultScreen
                } else if voice.phase == .idle {
                    readyScreen
                } else {
                    interviewScreen
                }
            }
        }
        .onChange(of: quizLogic.isFinished) { finished in
            if finished && !mockRecorded {
                mockRecorded = true
                ProgressManager.shared.recordMockInterviewCompleted()
            }
        }
        .onChange(of: voice.isRecording) { recording in
            pulseRing = recording
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !quizLogic.isFinished && voice.phase != .idle {
                    Button(endLabel, role: .destructive) {
                        voice.stop()
                        quizLogic.forceEnd()
                    }
                    .foregroundColor(.red)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                if voice.phase == .idle || quizLogic.isFinished {
                    Button(backLabel) {
                        voice.stop()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            voice.requestAuthorization()
        }
        .onDisappear {
            // Defensive cleanup. End/Back buttons already call voice.stop(),
            // but the interactive swipe-back gesture and programmatic dismissal
            // can bypass those paths and leave TTS/STT running in the background.
            // voice.stop() is idempotent so the double-call on explicit paths is a no-op.
            voice.stop()
        }
    }

    // ─────────────────────────────────────────────────────────────
    // MARK: - Ready Screen
    // ─────────────────────────────────────────────────────────────

    private var readyScreen: some View {
        ScrollView {
            VStack(spacing: 22) {
                Spacer(minLength: 30)

                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [.blue.opacity(0.35), .blue.opacity(0.05)],
                            startPoint: .top, endPoint: .bottom))
                        .frame(width: 130, height: 130)
                    Image(systemName: "person.fill.questionmark")
                        .font(.system(size: 54))
                        .foregroundColor(.blue)
                }

                Text(s.mockHeadline)
                    .font(.largeTitle).bold()
                    .foregroundColor(.white)

                Text(s.mockTagline)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.6))

                VStack(spacing: 10) {
                    readyRow(icon: "list.number",
                             title: String(format: s.mockRowQuestionsFormat, interviewQuestionCount),
                             subtitle: s.mockRowQuestionsSub)
                    readyRow(icon: "checkmark.circle.fill",
                             title: String(format: s.mockRowPassFormat, requiredCorrect),
                             subtitle: s.mockRowPassSub)
                    readyRow(icon: "mic.fill",
                             title: s.mockRowVoice,
                             subtitle: s.mockRowVoiceSub)
                }
                .padding(.horizontal, 16)

                // English-only disclaimer. Shown in the user's app language so
                // non-English users understand why questions will be read in English
                // (mock interview intentionally mirrors the real USCIS test).
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "info.circle.fill")
                        .font(.footnote)
                        .foregroundColor(.yellow.opacity(0.8))
                    Text(s.mockInterviewEnglishDisclaimer)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.65))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 0)
                }
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.05)))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.yellow.opacity(0.2), lineWidth: 1))
                .padding(.horizontal, 16)

                Button {
                    quizLogic.startMockInterview(
                        from: QuestionPool.allQuestions(for: language),
                        questionCount: interviewQuestionCount,
                        requiredCorrect: requiredCorrect
                    )
                    voice.start()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "play.fill")
                        Text(s.startInterview)
                    }
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
                .padding(.horizontal, 20)
                .padding(.top, 6)

                Spacer(minLength: 20)
            }
        }
        .scrollIndicators(.hidden)
    }

    private func readyRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.blue)
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

    // ─────────────────────────────────────────────────────────────
    // MARK: - Interview Screen
    // ─────────────────────────────────────────────────────────────

    private var interviewScreen: some View {
        VStack(spacing: 16) {
            progressSection
                .padding(.horizontal, 16)
                .padding(.top, 4)

            ScrollView {
                VStack(spacing: 16) {
                    questionCard
                    statusPill
                    if voice.didTimeout {
                        didntHearBanner
                    }
                    if !voice.transcription.isEmpty {
                        transcriptionCard
                    }
                    if let correct = voice.lastAnswerCorrect {
                        answerFeedback(correct: correct)
                    }
                    fallbackOptions
                    if awaitingWrongContinue {
                        nextQuestionButton
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
            .scrollIndicators(.hidden)

            micDock
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
        }
        .onChange(of: voice.lastAnswerCorrect) { correct in
            guard let correct = correct else { return }
            let gen = UINotificationFeedbackGenerator()
            gen.notificationOccurred(correct ? .success : .error)
        }
    }

    private var awaitingWrongContinue: Bool {
        voice.phase == .awaitingContinue && voice.lastAnswerCorrect == false
    }

    // MARK: Progress

    private var progressSection: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.12))
                    .frame(height: 8)
                GeometryReader { geo in
                    Capsule()
                        .fill(LinearGradient(
                            colors: [.blue, .cyan],
                            startPoint: .leading, endPoint: .trailing))
                        .frame(width: progressFraction * geo.size.width, height: 8)
                }
                .frame(height: 8)
            }

            // Listening countdown bar (only while listening).
            if voice.phase == .listening, let start = voice.listeningStartedAt {
                TimelineView(.periodic(from: start, by: 0.08)) { context in
                    let elapsed = context.date.timeIntervalSince(start)
                    let remaining = max(0, 1 - (elapsed / 10.0))
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.white.opacity(0.08))
                            .frame(height: 3)
                        GeometryReader { geo in
                            Capsule()
                                .fill(Color.red.opacity(0.7))
                                .frame(width: remaining * geo.size.width, height: 3)
                        }
                        .frame(height: 3)
                    }
                }
            }

            HStack(spacing: 10) {
                Label("\(quizLogic.currentQuestionIndex + 1)/\(quizLogic.totalQuestions)",
                      systemImage: "list.bullet")
                    .font(.caption.bold())
                    .foregroundColor(.white.opacity(0.75))

                Spacer()

                scorePill(value: quizLogic.correctAnswers,
                          icon: "checkmark.circle.fill",
                          color: .green)
                scorePill(value: quizLogic.incorrectAnswers,
                          icon: "xmark.circle.fill",
                          color: .red)

                Text(String(format: s.interviewNeedFormat, requiredCorrect))
                    .font(.caption.bold())
                    .foregroundColor(.yellow)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Capsule().fill(Color.yellow.opacity(0.15)))
            }
        }
    }

    private var progressFraction: CGFloat {
        guard quizLogic.totalQuestions > 0 else { return 0 }
        return CGFloat(quizLogic.currentQuestionIndex) / CGFloat(quizLogic.totalQuestions)
    }

    private func scorePill(value: Int, icon: String, color: Color) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2.bold())
            Text("\(value)")
                .font(.caption.bold())
        }
        .foregroundColor(color)
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(Capsule().fill(color.opacity(0.15)))
    }

    // MARK: Question card

    private var questionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(s.interviewQuestionLabel) \(quizLogic.currentQuestionIndex + 1)")
                .font(.caption.bold())
                .foregroundColor(.white.opacity(0.5))
                .tracking(1)
                .textCase(.uppercase)

            Text(quizLogic.currentQuestion.variants.first?.text ?? "")
                .font(.title2.bold())
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)

            if quizLogic.currentQuestion.isTimeSensitive {
                // Correct answer depends on current officeholder; point the user
                // to uscis.gov/citizenship. Localized to user's app language.
                HStack(alignment: .top, spacing: 6) {
                    Image(systemName: "info.circle.fill")
                        .font(.caption2)
                        .foregroundColor(.yellow.opacity(0.85))
                        .padding(.top, 2)
                    Text(s.questionTimeSensitiveNote)
                        .font(.caption2)
                        .foregroundColor(.yellow.opacity(0.75))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
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

    // MARK: Status pill

    @ViewBuilder
    private var statusPill: some View {
        switch voice.phase {
        case .speakingQuestion:
            statusLabel(icon: "speaker.wave.2.fill", text: s.interviewStatusReading, color: .blue)
        case .listening:
            statusLabel(icon: "waveform", text: s.interviewStatusListening, color: .red)
        case .matching:
            statusLabel(icon: "sparkles", text: s.interviewMatching, color: .purple)
        case .processingAnswer:
            statusLabel(icon: "hourglass", text: s.interviewStatusNext, color: .yellow)
        default:
            EmptyView()
        }
    }

    // MARK: Didn't-hear banner (after timeout)

    private var didntHearBanner: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "ear.trianglebadge.exclamationmark")
                    .font(.headline)
                    .foregroundColor(.orange)
                Text(s.interviewDidntHear)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                Spacer()
            }
            HStack(spacing: 10) {
                Button {
                    let gen = UIImpactFeedbackGenerator(style: .light); gen.impactOccurred()
                    voice.replayQuestion()
                } label: {
                    Label(s.interviewReplay, systemImage: "speaker.wave.2.fill")
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 12).padding(.vertical, 8)
                        .background(Capsule().fill(Color.blue.opacity(0.8)))
                }
                Button {
                    let gen = UIImpactFeedbackGenerator(style: .light); gen.impactOccurred()
                    voice.toggleMic()
                } label: {
                    Label(s.interviewRetry, systemImage: "arrow.clockwise")
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 12).padding(.vertical, 8)
                        .background(Capsule().fill(Color.green.opacity(0.8)))
                }
                Spacer()
                Button {
                    let gen = UIImpactFeedbackGenerator(style: .light); gen.impactOccurred()
                    voice.skipCurrent()
                } label: {
                    Text(s.interviewSkip)
                        .font(.caption.bold())
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal, 12).padding(.vertical, 8)
                        .background(Capsule().fill(Color.white.opacity(0.15)))
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12).fill(Color.orange.opacity(0.12))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12).stroke(Color.orange.opacity(0.4), lineWidth: 1)
        )
    }

    // MARK: Next-question button (shown after a wrong answer)

    private var nextQuestionButton: some View {
        Button {
            let gen = UIImpactFeedbackGenerator(style: .medium); gen.impactOccurred()
            voice.continueAfterWrong()
        } label: {
            HStack {
                Text(s.interviewNextQuestion)
                    .font(.headline.bold())
                Image(systemName: "arrow.right")
                    .font(.subheadline.bold())
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(LinearGradient(
                        colors: [.orange, .orange.opacity(0.85)],
                        startPoint: .leading, endPoint: .trailing))
            )
        }
    }

    private func statusLabel(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.subheadline.bold())
            Text(text)
                .font(.subheadline.bold())
        }
        .foregroundColor(color)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Capsule().fill(color.opacity(0.15)))
        .overlay(Capsule().stroke(color.opacity(0.4), lineWidth: 1))
    }

    // MARK: Transcription card

    private var transcriptionCard: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "quote.opening")
                .font(.caption)
                .foregroundColor(.yellow.opacity(0.7))
            Text(voice.transcription)
                .font(.body)
                .foregroundColor(.yellow)
                .multilineTextAlignment(.leading)
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.yellow.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.yellow.opacity(0.25), lineWidth: 1)
        )
    }

    // MARK: Answer feedback flash

    private func answerFeedback(correct: Bool) -> some View {
        VStack(spacing: 6) {
            HStack(spacing: 8) {
                Image(systemName: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.title3)
                Text(correct ? s.interviewCorrect : s.interviewWrong)
                    .font(.headline.bold())
            }
            .foregroundColor(correct ? .green : .red)

            if !correct && !voice.lastAnswerExplanation.isEmpty {
                Text(voice.lastAnswerExplanation)
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.75))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill((correct ? Color.green : Color.red).opacity(0.12))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke((correct ? Color.green : Color.red).opacity(0.4), lineWidth: 1)
        )
    }

    // MARK: Fallback options

    private var fallbackOptions: some View {
        let options = quizLogic.currentQuestion.variants.first?.options ?? []
        let correctIdx = voice.lastCorrectIndex
        let showingAnswer = voice.phase == .awaitingContinue && voice.lastAnswerCorrect == false
        let disabled = voice.phase == .processingAnswer
                    || voice.phase == .speakingQuestion
                    || voice.phase == .matching
                    || voice.phase == .awaitingContinue
        return VStack(spacing: 8) {
            HStack {
                Text(showingAnswer ? s.interviewCorrectAnswerLabel.uppercased() : s.interviewOrTap)
                    .font(.caption2.bold())
                    .tracking(1)
                    .foregroundColor(showingAnswer ? .green.opacity(0.8) : .white.opacity(0.4))
                Spacer()
            }
            .padding(.top, 4)

            ForEach(options.indices, id: \.self) { idx in
                Button {
                    let gen = UISelectionFeedbackGenerator(); gen.selectionChanged()
                    voice.submitTapAnswer(idx)
                } label: {
                    optionRow(idx: idx,
                              text: options[idx],
                              isCorrect: showingAnswer && correctIdx == idx)
                }
                .buttonStyle(.plain)
                .disabled(disabled)
                .opacity(disabled && !(showingAnswer && correctIdx == idx) ? 0.5 : 1)
            }
        }
    }

    private func optionRow(idx: Int, text: String, isCorrect: Bool) -> some View {
        HStack(spacing: 12) {
            Text(optionLetter(idx))
                .font(.subheadline.bold())
                .foregroundColor(.white)
                .frame(width: 26, height: 26)
                .background(
                    Circle().fill(isCorrect
                                  ? Color.green.opacity(0.85)
                                  : Color.white.opacity(0.12))
                )

            Text(text)
                .font(.body)
                .foregroundColor(isCorrect ? .green : .white.opacity(0.9))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            if isCorrect {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isCorrect ? Color.green.opacity(0.15) : Color.white.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isCorrect ? Color.green.opacity(0.6) : Color.white.opacity(0.1),
                        lineWidth: isCorrect ? 1.5 : 1)
        )
    }

    private func optionLetter(_ idx: Int) -> String {
        ["A", "B", "C", "D", "E", "F"][min(idx, 5)]
    }

    // MARK: Mic dock

    private var micDock: some View {
        let micDisabled = voice.phase == .speakingQuestion
                       || voice.phase == .processingAnswer
                       || voice.phase == .matching
                       || voice.phase == .awaitingContinue
        return HStack(spacing: 14) {
            ZStack {
                Circle()
                    .stroke(Color.red.opacity(0.4), lineWidth: 2)
                    .frame(width: pulseRing ? 80 : 62, height: pulseRing ? 80 : 62)
                    .opacity(pulseRing ? 0 : 1)
                    .animation(voice.isRecording
                               ? .easeOut(duration: 1.2).repeatForever(autoreverses: false)
                               : .default,
                               value: pulseRing)

                Button {
                    let gen = UIImpactFeedbackGenerator(style: .light); gen.impactOccurred()
                    voice.toggleMic()
                } label: {
                    Image(systemName: "mic.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 58, height: 58)
                        .background(
                            Circle().fill(voice.isRecording ? Color.red : Color.blue)
                        )
                        .overlay(
                            Circle().stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                }
                .disabled(micDisabled)
                .opacity(micDisabled ? 0.5 : 1)
                .accessibilityLabel(voice.isRecording ? s.a11yStopRecording : s.a11yStartRecording)
            }
            .frame(width: 80, height: 80)

            VStack(alignment: .leading, spacing: 2) {
                Text(voice.isRecording ? s.interviewListening : s.interviewTapMic)
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                Text(voice.isRecording
                     ? s.interviewTapAgain
                     : s.interviewAnswerOutLoud)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.55))
            }

            Spacer()

            Button {
                let gen = UIImpactFeedbackGenerator(style: .light); gen.impactOccurred()
                voice.replayQuestion()
            } label: {
                Image(systemName: "speaker.wave.2.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Color.white.opacity(0.12)))
            }
            .disabled(voice.phase == .speakingQuestion || voice.phase == .matching)
            .accessibilityLabel(s.interviewReplay)
            .opacity(voice.phase == .speakingQuestion || voice.phase == .matching ? 0.4 : 1)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }

    // ─────────────────────────────────────────────────────────────
    // MARK: - Result Screen
    // ─────────────────────────────────────────────────────────────

    private var resultScreen: some View {
        let passed = quizLogic.status == .passed

        return ScrollView {
            VStack(spacing: 18) {
                Spacer(minLength: 20)

                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [(passed ? Color.green : Color.red).opacity(0.4),
                                     (passed ? Color.green : Color.red).opacity(0.05)],
                            startPoint: .top, endPoint: .bottom))
                        .frame(width: 130, height: 130)
                    Image(systemName: passed ? "checkmark.seal.fill" : "xmark.seal.fill")
                        .font(.system(size: 56))
                        .foregroundColor(passed ? .green : .red)
                }

                Text(passed ? s.resultPassed : s.resultFailed)
                    .font(.largeTitle).bold()
                    .foregroundColor(passed ? .green : .red)

                Text(String(format: s.resultOfCorrectFormat,
                            quizLogic.correctAnswers,
                            quizLogic.attemptedQuestions))
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))

                HStack(spacing: 12) {
                    statCard(value: "\(quizLogic.correctAnswers)",
                             label: s.resultCorrect, color: .green)
                    statCard(value: "\(quizLogic.incorrectAnswers)",
                             label: s.resultWrong, color: .red)
                    statCard(value: "\(quizLogic.scorePercentage)%",
                             label: s.resultScore, color: .yellow)
                }
                .padding(.horizontal, 16)

                HStack {
                    Text(s.resultRequiredToPass)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.6))
                    Spacer()
                    Text("\(requiredCorrect) / \(interviewQuestionCount)")
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.06))
                )
                .padding(.horizontal, 16)

                lifetimeStats
                    .padding(.horizontal, 16)

                if !quizLogic.answerLog.isEmpty {
                    reviewList
                        .padding(.horizontal, 16)
                }

                shareResultButton
                    .padding(.top, 2)

                HStack(spacing: 12) {
                    Button {
                        quizLogic.startMockInterview(
                            from: QuestionPool.allQuestions(for: language),
                            questionCount: interviewQuestionCount,
                            requiredCorrect: requiredCorrect
                        )
                        voice.restart()
                    } label: {
                        Label(s.resultTryAgain, systemImage: "arrow.clockwise")
                            .font(.headline.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.blue)
                            )
                    }

                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text(s.resultDone)
                            .font(.headline.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.white.opacity(0.15))
                            )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 4)

                Spacer(minLength: 20)
            }
        }
        .scrollIndicators(.hidden)
    }

    private func statCard(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.title3.bold())
                .foregroundColor(color)
            Text(label)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.12))
        )
    }

    // MARK: Review list

    private var reviewList: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(s.resultReviewHeader.uppercased())
                    .font(.caption2.bold())
                    .tracking(1)
                    .foregroundColor(.white.opacity(0.4))
                Spacer()
            }
            ForEach(Array(quizLogic.answerLog.enumerated()), id: \.element.id) { (index, entry) in
                reviewRow(number: index + 1, entry: entry)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.05))
        )
    }

    private func reviewRow(number: Int, entry: UnifiedQuizLogic.AnswerLogEntry) -> some View {
        let variant = entry.question.variants.first
        let options = variant?.options ?? []
        let correctText = options[safe: entry.question.correctAnswer] ?? ""
        let userText: String = {
            if let ua = entry.userAnswer, let opt = options[safe: ua] {
                return opt
            }
            return s.resultReviewNoAnswer
        }()
        return VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: entry.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(entry.isCorrect ? .green : .red)
                    .font(.subheadline.bold())
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(number). \(variant?.text ?? "")")
                        .font(.footnote.bold())
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                    HStack(spacing: 6) {
                        Text(s.resultReviewYouAnswered)
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.5))
                        Text(userText)
                            .font(.caption2.bold())
                            .foregroundColor(entry.isCorrect ? .green : .red)
                    }
                    if !entry.isCorrect {
                        HStack(spacing: 6) {
                            Text(s.resultReviewCorrectAnswer)
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.5))
                            Text(correctText)
                                .font(.caption2.bold())
                                .foregroundColor(.green)
                        }
                    }
                }
                Spacer(minLength: 0)
            }
            if number < quizLogic.answerLog.count {
                Divider().background(Color.white.opacity(0.08))
            }
        }
    }

    private var lifetimeStats: some View {
        let pm = ProgressManager.shared
        return VStack(spacing: 8) {
            HStack {
                Text(s.resultLifetimeStats)
                    .font(.caption2.bold())
                    .tracking(1)
                    .foregroundColor(.white.opacity(0.4))
                Spacer()
            }
            HStack(spacing: 20) {
                VStack {
                    Text("\(pm.totalQuestionsAnswered)")
                        .font(.headline).foregroundColor(.white)
                    Text(s.resultAnswered).font(.caption2).foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                VStack {
                    Text("\(pm.accuracyPercentage)%")
                        .font(.headline).foregroundColor(.white)
                    Text(s.resultAccuracy).font(.caption2).foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                VStack {
                    Text("\(pm.currentStreak)")
                        .font(.headline).foregroundColor(.orange)
                    Text(s.resultStreak).font(.caption2).foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.05))
        )
    }

    // MARK: - Share

    private var shareResultButton: some View {
        Button {
            let card = ShareCardView(
                score: quizLogic.correctAnswers,
                total: quizLogic.attemptedQuestions,
                passed: quizLogic.status == .passed,
                streak: ProgressManager.shared.currentStreak
            )
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
            Label(s.resultShareResult, systemImage: "square.and.arrow.up")
                .font(.subheadline.bold())
                .foregroundColor(.blue)
        }
    }
}
