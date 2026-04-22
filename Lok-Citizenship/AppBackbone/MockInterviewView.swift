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
        _quizLogic = StateObject(wrappedValue: logic)
        _voice = StateObject(wrappedValue: VoiceQuizController(quizLogic: logic))
    }

    // ─────────────────────────────────────────────────────────────
    // MARK: - BODY
    // ─────────────────────────────────────────────────────────────

    @State private var mockRecorded = false

    var body: some View {
        VStack(spacing: 0) {
            if quizLogic.isFinished {
                resultScreen
            } else if voice.phase == .idle {
                readyScreen
            } else {
                interviewScreen
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .onChange(of: quizLogic.isFinished) { finished in
            if finished && !mockRecorded {
                mockRecorded = true
                ProgressManager.shared.recordMockInterviewCompleted()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !quizLogic.isFinished && voice.phase != .idle {
                    Button("End", role: .destructive) {
                        voice.stop()
                        quizLogic.forceEnd()
                    }
                    .foregroundColor(.red)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                if voice.phase == .idle || quizLogic.isFinished {
                    Button("Back") {
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
    }

    // ─────────────────────────────────────────────────────────────
    // MARK: - Ready Screen
    // ─────────────────────────────────────────────────────────────

    private var readyScreen: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "person.fill.questionmark")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            Text("Mock Interview")
                .font(.largeTitle).bold()
                .foregroundColor(.white)

            Text("\(interviewQuestionCount) questions from the real USCIS civics test.\nYou need \(requiredCorrect) correct to pass.\nAnswer out loud using your voice.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Button {
                quizLogic.startMockInterview(
                    from: QuestionPool.allQuestions(for: language),
                    questionCount: interviewQuestionCount,
                    requiredCorrect: requiredCorrect
                )
                voice.start()
            } label: {
                Text("Start Interview")
                    .font(.title3).bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 40)

            Spacer()
        }
    }

    // ─────────────────────────────────────────────────────────────
    // MARK: - Interview Screen
    // ─────────────────────────────────────────────────────────────

    private var interviewScreen: some View {
        VStack(spacing: 20) {

            // Progress
            HStack {
                Text("Question \(quizLogic.currentQuestionIndex + 1) of \(quizLogic.totalQuestions)")
                    .font(.headline).foregroundColor(.white)
                Spacer()
                HStack(spacing: 8) {
                    Text("\(quizLogic.correctAnswers)")
                        .foregroundColor(.green).bold()
                    Text("\(quizLogic.incorrectAnswers)")
                        .foregroundColor(.red).bold()
                }
            }
            .padding(.horizontal)
            .padding(.top, 16)

            ProgressView(
                value: Double(quizLogic.currentQuestionIndex),
                total: Double(max(quizLogic.totalQuestions, 1))
            )
            .accentColor(.blue)
            .padding(.horizontal)

            Spacer()

            // Question text
            Text(quizLogic.currentQuestion.variants.first?.text ?? "")
                .font(.title2).bold()
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            // Status indicator
            statusIndicator

            // Transcription
            if !voice.transcription.isEmpty {
                Text(voice.transcription)
                    .font(.body)
                    .foregroundColor(.yellow)
                    .padding(.horizontal, 24)
                    .multilineTextAlignment(.center)
            }

            // Answer feedback flash
            if let correct = voice.lastAnswerCorrect {
                Text(correct ? "Correct!" : "Wrong")
                    .font(.title3).bold()
                    .foregroundColor(correct ? .green : .red)

                if !correct && !voice.lastAnswerExplanation.isEmpty {
                    Text(voice.lastAnswerExplanation)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
            }

            Spacer()

            // Fallback: tap-to-answer options
            fallbackOptions

            // Manual mic toggle
            if voice.phase == .listening || voice.phase == .speakingQuestion {
                micToggleButton
                    .padding(.bottom, 20)
            }
        }
    }

    private var statusIndicator: some View {
        HStack(spacing: 8) {
            switch voice.phase {
            case .speakingQuestion:
                Image(systemName: "speaker.wave.2.fill")
                    .foregroundColor(.blue)
                Text("Reading question...")
                    .foregroundColor(.gray)
            case .listening:
                Image(systemName: "mic.fill")
                    .foregroundColor(.red)
                Text("Listening...")
                    .foregroundColor(.gray)
            case .processingAnswer:
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.yellow)
                Text("Next question...")
                    .foregroundColor(.gray)
            default:
                EmptyView()
            }
        }
        .font(.subheadline)
    }

    private var micToggleButton: some View {
        Button {
            voice.toggleMic()
        } label: {
            Image(systemName: voice.isRecording ? "mic.circle.fill" : "mic.circle")
                .font(.system(size: 50))
                .foregroundColor(voice.isRecording ? .red : .blue)
        }
    }

    private var fallbackOptions: some View {
        let options = quizLogic.currentQuestion.variants.first?.options ?? []
        return VStack(spacing: 6) {
            Text("or tap your answer:")
                .font(.caption).foregroundColor(.gray)
            ForEach(options.indices, id: \.self) { idx in
                Button {
                    voice.submitTapAnswer(idx)
                } label: {
                    Text(options[idx])
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.8))
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                }
                .disabled(voice.phase == .processingAnswer || voice.phase == .speakingQuestion)
            }
        }
        .padding(.horizontal, 24)
    }

    // ─────────────────────────────────────────────────────────────
    // MARK: - Result Screen
    // ─────────────────────────────────────────────────────────────

    private var resultScreen: some View {
        VStack(spacing: 20) {
            Spacer()

            if quizLogic.status == .passed {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 70))
                    .foregroundColor(.green)
                Text("PASSED")
                    .font(.largeTitle).bold()
                    .foregroundColor(.green)
            } else {
                Image(systemName: "xmark.seal.fill")
                    .font(.system(size: 70))
                    .foregroundColor(.red)
                Text("FAILED")
                    .font(.largeTitle).bold()
                    .foregroundColor(.red)
            }

            Text("\(quizLogic.correctAnswers) / \(quizLogic.attemptedQuestions)")
                .font(.title).foregroundColor(.white)

            Text("Score: \(quizLogic.scorePercentage)%")
                .font(.headline).foregroundColor(.yellow)

            VStack(spacing: 8) {
                HStack {
                    Text("Correct").foregroundColor(.gray)
                    Spacer()
                    Text("\(quizLogic.correctAnswers)").foregroundColor(.green).bold()
                }
                HStack {
                    Text("Wrong").foregroundColor(.gray)
                    Spacer()
                    Text("\(quizLogic.incorrectAnswers)").foregroundColor(.red).bold()
                }
                HStack {
                    Text("Required to pass").foregroundColor(.gray)
                    Spacer()
                    Text("\(requiredCorrect)").foregroundColor(.white)
                }
            }
            .padding(.horizontal, 40)

            // Lifetime stats
            let pm = ProgressManager.shared
            VStack(spacing: 4) {
                Divider().background(Color.white.opacity(0.3))
                Text("Lifetime Stats")
                    .font(.caption).foregroundColor(.gray)
                HStack(spacing: 16) {
                    VStack {
                        Text("\(pm.totalQuestionsAnswered)")
                            .font(.headline).foregroundColor(.white)
                        Text("Answered").font(.caption2).foregroundColor(.gray)
                    }
                    VStack {
                        Text("\(pm.accuracyPercentage)%")
                            .font(.headline).foregroundColor(.white)
                        Text("Accuracy").font(.caption2).foregroundColor(.gray)
                    }
                    VStack {
                        Text("\(pm.currentStreak)")
                            .font(.headline).foregroundColor(.orange)
                        Text("Streak").font(.caption2).foregroundColor(.gray)
                    }
                }
                .padding(.top, 4)
            }
            .padding(.vertical, 8)

            // Share result
            shareResultButton

            Spacer()

            HStack(spacing: 16) {
                Button {
                    quizLogic.startMockInterview(
                        from: QuestionPool.allQuestions(for: language),
                        questionCount: interviewQuestionCount,
                        requiredCorrect: requiredCorrect
                    )
                    voice.restart()
                } label: {
                    Text("Try Again")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }

                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
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
            Label("Share Result", systemImage: "square.and.arrow.up")
                .font(.subheadline.bold())
                .foregroundColor(.blue)
        }
    }
}
