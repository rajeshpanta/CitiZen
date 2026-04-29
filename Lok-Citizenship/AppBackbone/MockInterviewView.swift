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
    @Environment(\.scenePhase) private var scenePhase

    private let interviewQuestionCount = 10
    private let requiredCorrect = 8

    // Custom init to wire voice controller to quiz logic
    init(language: AppLanguage) {
        self.language = language
        let logic = UnifiedQuizLogic()
        // Mock interview uses cloud Whisper (better accuracy on accented
        // English). Fall back to LocalSTTService if Supabase isn't configured
        // so dev builds without backend creds still work end-to-end.
        let stt: SpeechToTextService = SupabaseConfig.isConfigured
            ? WhisperSTTService()
            : ServiceLocator.shared.sttService
        let vc = VoiceQuizController(quizLogic: logic, stt: stt)
        vc.requireContinueOnWrong = true
        _quizLogic = StateObject(wrappedValue: logic)
        _voice = StateObject(wrappedValue: vc)
    }

    @State private var mockRecorded = false
    @State private var pulseRing = false
    @State private var showEndConfirm = false
    /// True when the user tapped Start Interview before mic / speech
    /// permission had resolved (still `.notDetermined`). Once the OS
    /// prompt completes the `onChange` handler reads this flag and either
    /// kicks off the interview (`.authorized`) or lets the body switch to
    /// `permissionScreen` (`.denied` / `.restricted`). Without this gate,
    /// a fresh-install user who taps Start before granting saw TTS read
    /// the question into a mic that wasn't authorized yet — every
    /// question dead-ended at the 10 s listening timeout.
    @State private var pendingStartInterview = false

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

    /// True when the mic / speech-recognition permission state will prevent
    /// the voice flow from working. Covers both explicit user denial and the
    /// `.restricted` case (no recognizer available — e.g. parental controls).
    /// `.notDetermined` is intentionally NOT blocked: the OS prompt fires when
    /// the user taps Start Interview, and once they answer it the state moves
    /// to `.authorized` or `.denied` and the view re-renders.
    private var isMicBlocked: Bool {
        voice.authorizationStatus == .denied
            || voice.authorizationStatus == .restricted
    }

    /// Single entry point for "user wants to start the mock interview".
    /// Branches on the current permission status so a Start tap before the
    /// OS prompt has resolved doesn't fire TTS into an unauthorized mic.
    /// `.authorized` runs the full start flow; `.notDetermined` arms a
    /// pending start that the `onChange` handler completes; `.denied` /
    /// `.restricted` are no-ops because the body's `permissionScreen`
    /// already takes the user there.
    private func startInterviewIfPossible() {
        switch voice.authorizationStatus {
        case .authorized:
            AudioSessionPrewarmer.prewarm {
                quizLogic.startMockInterview(
                    from: QuestionPool.allQuestions(for: language),
                    questionCount: interviewQuestionCount,
                    requiredCorrect: requiredCorrect
                )
                voice.start()
            }
        case .notDetermined:
            pendingStartInterview = true
            voice.requestAuthorization()
        default:
            break
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
                } else if isMicBlocked {
                    permissionScreen
                } else if quizLogic.totalQuestions == 0 {
                    readyScreen
                } else {
                    // Once questions are loaded, stay on the interview screen
                    // for every phase including .idle. Phase .idle mid-quiz
                    // happens after a listening timeout or a match failure;
                    // the didntHearBanner inside interviewScreen is the
                    // recovery surface for that state. Falling back to
                    // readyScreen here would let "Start Interview" reset the
                    // quiz from question 1 and silently discard progress.
                    interviewScreen
                }
            }
        }
        .onChange(of: quizLogic.isFinished) { finished in
            // Only record an attempt if the user actually answered something.
            // Without this check, a panic-tap of Start → End → confirm with
            // zero questions answered burns a free-tier mock attempt with
            // nothing to show for it. `attemptedQuestions` is incremented
            // by `recordAnswer` (and skip), so it's a faithful "did this
            // session happen?" signal.
            if finished && !mockRecorded && quizLogic.attemptedQuestions > 0 {
                mockRecorded = true
                ProgressManager.shared.recordMockInterviewCompleted()
            }
        }
        .onChange(of: voice.isRecording) { recording in
            pulseRing = recording
        }
        .onChange(of: voice.authorizationStatus) { status in
            if isMicBlocked {
                // Permission flipped to denied/restricted — either the
                // initial OS prompt resolved with deny after the user
                // tapped Start, or they revoked from Settings mid-quiz.
                // Halt any in-flight TTS/STT so it doesn't keep playing
                // underneath the permissionScreen, and drop any stale
                // pending start. Also clear the post-interruption resume
                // flag so a `.ended` notification arriving after permission
                // is revoked doesn't replay the question on top of the
                // permission screen UI.
                voice.stop()
                voice.cancelPendingInterruptionResume()
                pendingStartInterview = false
            } else if pendingStartInterview && status == .authorized {
                // OS prompt resolved with grant after the user tapped
                // Start while still `.notDetermined`. Run the start flow
                // now that the mic is actually available.
                pendingStartInterview = false
                startInterviewIfPossible()
            }
        }
        .onChange(of: scenePhase) { phase in
            // When the user returns from Settings (or any other backgrounding),
            // re-query permission so the permissionScreen → readyScreen
            // transition happens automatically. AVAudioSession returns the
            // *current* OS-level permission on each call, so this picks up
            // changes the user made while we were backgrounded. Only refresh
            // if we're currently blocked to avoid chatter on every foreground.
            if phase == .active && isMicBlocked {
                voice.requestAuthorization()
            }
        }
        .alert(s.endInterviewTitle, isPresented: $showEndConfirm) {
            Button(endLabel, role: .destructive) {
                // Stop audio BEFORE flipping the quiz to .finished.
                // Without voice.stop(), an in-flight TTS read continues
                // playing onto the result screen ("speaks the question
                // on old voice"). voice.stop() bumps OpenAITTSService's
                // currentRequestId, which both halts the AVAudioPlayer
                // synchronously (cached-MP3 path) and arms the
                // re-check-id guard in fetchAndPlay so a pending
                // network completion can't start a new player after End.
                voice.stop()
                quizLogic.forceEnd()
            }
            Button(s.endInterviewKeep, role: .cancel) {
                // No-op: End-tap doesn't touch voice state, so cancelling
                // leaves the user in the same phase they were in
                // (speakingQuestion / listening / awaitingContinue).
            }
        } message: {
            Text(s.endInterviewMessage)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                // End is shown for the entire in-progress run, including the
                // .idle states reached via timeout/match-fail. Otherwise the
                // user has no way to officially end the attempt and Back-ing
                // out doesn't bump the mock-completed counter.
                if !quizLogic.isFinished && quizLogic.totalQuestions > 0 {
                    Button(endLabel, role: .destructive) {
                        // Just show the alert — DON'T touch voice state yet.
                        // If the user cancels, they should be returned to
                        // exactly the state they were in (listening,
                        // awaitingContinue with "Next Question" visible,
                        // etc.). Stopping voice on tap would force
                        // phase=.idle and erase the next-question CTA
                        // after a wrong answer. Audio is stopped only
                        // when the user confirms — see the destructive
                        // button in the .alert above.
                        showEndConfirm = true
                    }
                    .foregroundColor(.red)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                // Back is only on the pre-quiz ready/permission screens and
                // the post-quiz result screen — never mid-quiz, where End is
                // the correct exit (it records the attempt as failed).
                if quizLogic.totalQuestions == 0 || quizLogic.isFinished {
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
            // Mock interview can run several minutes with long pauses while
            // the user is speaking aloud. Keep the screen awake so the
            // phone doesn't dim/lock mid-question and pause the mic.
            // Mirrors AudioOnlyView. Re-enabled on disappear.
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
            // Defensive cleanup. End/Back buttons already call voice.stop(),
            // but the interactive swipe-back gesture and programmatic dismissal
            // can bypass those paths and leave TTS/STT running in the background.
            // voice.stop() is idempotent so the double-call on explicit paths is a no-op.
            voice.stop()
            // Drop any latent "auto-resume after interruption" intent so an
            // `AVAudioSession.interruptionNotification(.ended)` arriving
            // between this disappear and the StateObject's actual
            // deallocation can't replayQuestion() into a screen the user
            // has already left.
            voice.cancelPendingInterruptionResume()
            // Release the audio session now that the user is leaving the
            // screen for real — between-question stops deliberately keep
            // the session active to avoid music-ducking flicker, so this
            // is the one place the session gets torn down.
            AudioSessionPrewarmer.deactivate()
        }
    }

    // ─────────────────────────────────────────────────────────────
    // MARK: - Permission Screen
    // ─────────────────────────────────────────────────────────────

    /// Replaces the ready screen when mic / speech-recognition permission has
    /// been denied or restricted. Without this, tapping "Start Interview"
    /// would let TTS read the question but the listen step would silently no-op
    /// — the user sits in `.listening` with nothing being captured until the
    /// 10 s timeout fires.
    private var permissionScreen: some View {
        VStack(spacing: 18) {
            Spacer()
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [.red.opacity(0.35), .red.opacity(0.05)],
                        startPoint: .top, endPoint: .bottom))
                    .frame(width: 130, height: 130)
                Image(systemName: "mic.slash.fill")
                    .font(.system(size: 54))
                    .foregroundColor(.red)
            }

            Text(s.micPermissionTitle)
                .font(.title2.bold())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            Text(s.micPermissionBody)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .fixedSize(horizontal: false, vertical: true)

            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "gear")
                    Text(s.micPermissionOpenSettings)
                }
                .font(.headline.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, minHeight: 52)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.blue)
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 6)

            Spacer()
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
                    // Permission-aware start. `.authorized` runs the
                    // full prewarm + startMockInterview + voice.start
                    // flow; `.notDetermined` arms the pending flag so
                    // the OS prompt's resolution kicks the start.
                    // `.denied` / `.restricted` shouldn't reach this
                    // button (the body would be on `permissionScreen`).
                    startInterviewIfPossible()
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
        // Whisper upload window: rec is still true (cleared after the cloud
        // round-trip) but the user has already stopped speaking. Show the
        // same "matching answer…" pill we use for the GPT-match window so
        // the post-speech "we're working" state is one unified UI instead
        // of flipping Listening → Matching mid-flow.
        if voice.isProcessingTranscript {
            statusLabel(icon: "sparkles", text: s.interviewMatching, color: .purple)
        } else {
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
        // Taps stay enabled during `.matching` so a slow GPT roundtrip never
        // strands the user. First tap wins — the in-flight matcher Task in
        // VoiceQuizController.evaluateTranscription is guarded by
        // `phase == .matching` and discards its result once recordAnswer flips
        // the phase to `.awaitingContinue`.
        let disabled = voice.phase == .processingAnswer
                    || voice.phase == .speakingQuestion
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
                // Three states: processing (Whisper round-trip in flight after
                // user stopped speaking), listening (mic active and capturing),
                // idle (waiting for the user to tap). Without the processing
                // branch, the dock kept reading "Listening" through the cloud
                // upload window even though the user had already finished.
                Text(voice.isProcessingTranscript
                     ? s.interviewMatching
                     : (voice.isRecording ? s.interviewListening : s.interviewTapMic))
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                // Subtitle is contextual help — "tap to stop" while listening,
                // "answer out loud" while idle. Suppressed during processing
                // because the mic is no-op in that window (didTriggerStop guard
                // makes a tap silent), so a help line would be misleading.
                if !voice.isProcessingTranscript {
                    Text(voice.isRecording ? s.interviewTapAgain : s.interviewAnswerOutLoud)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.55))
                }
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
            // .awaitingContinue is the wrong-answer-shown state. Replaying
            // there re-runs speakCurrentQuestion → autoStartListening, which
            // re-records an answer for the SAME question — double-incrementing
            // the score and adding a duplicate entry to the answer log. Disable
            // here so the only path forward is "Next Question".
            .disabled(voice.phase == .speakingQuestion
                      || voice.phase == .matching
                      || voice.phase == .awaitingContinue)
            .accessibilityLabel(s.interviewReplay)
            .opacity((voice.phase == .speakingQuestion
                      || voice.phase == .matching
                      || voice.phase == .awaitingContinue) ? 0.4 : 1)
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
                        AudioSessionPrewarmer.prewarm {
                            quizLogic.startMockInterview(
                                from: QuestionPool.allQuestions(for: language),
                                questionCount: interviewQuestionCount,
                                requiredCorrect: requiredCorrect
                            )
                            voice.restart()
                        }
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
            // Voice-no-match path: STT captured speech but it didn't map
            // to any option, so we recorded `userAnswer = nil` plus the
            // spoken text. Surface what was heard (in curly quotes) so
            // the user can tell apart "I said something the matcher
            // rejected" from "I skipped / nothing was heard."
            if let spoken = entry.userSpokenText?.trimmingCharacters(in: .whitespacesAndNewlines),
               !spoken.isEmpty {
                return "\u{201C}\(spoken)\u{201D}"
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
            // Pick the foreground-active window scene rather than `connectedScenes.first`.
            // On iPhone today there's typically only one scene, but iPad multi-window
            // (and any future Stage Manager / external display setup) makes `.first`
            // non-deterministic — we could end up presenting the share sheet onto a
            // background scene's root and have it never appear. Filtering by
            // `.foregroundActive` and preferring `isKeyWindow` keeps the activity
            // sheet on the user's currently visible window.
            guard let scene = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .first(where: { $0.activationState == .foregroundActive }),
                  let root = (scene.windows.first(where: { $0.isKeyWindow }) ?? scene.windows.first)?
                    .rootViewController
            else { return }
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
