import SwiftUI
import UIKit
import Speech
import Combine

/// Hands-free audio quiz. Three stages, top to bottom:
///
/// 1. **Length picker** — pre-session screen where the user chooses how
///    many questions (10 / 25 / 50 / Full pool).
/// 2. **Session** — TTS reads question → STT listens → TTS speaks
///    feedback → next question. The controller drives the cycle in
///    auto-advance mode.
/// 3. **Finished** — score + Try Again / Review Missed / Done.
///
/// Critical UX guarantees this view enforces:
///
/// - The back button is **always visible** during a session, but tapping
///   it routes through a confirm dialog so a stray touch can't destroy
///   progress (parallels the Reading / Writing test confirm-exit).
/// - The controller is configured with `feedbackWatchdogTimeout = 8` and
///   `retryOnEmptySpoken = true`, both of which are gated knobs on
///   `VoiceQuizController` that other consumers (Mock Interview,
///   Practice quizzes) don't enable. They turn the prior silent-stall
///   failure mode into either a "didn't hear you, try again" retry
///   loop or, after one retry, a marked-wrong + advance.
struct AudioOnlyView: View {

    let language: AppLanguage

    private enum Stage { case lengthPicker, session, finished }

    /// Length choices the picker exposes. `.full` runs every available
    /// question once (capped by pool size in `UnifiedQuizLogic.startAudioOnly`).
    private enum SessionLength: Int, CaseIterable, Identifiable {
        case short = 10, medium = 25, long = 50, full = 999
        var id: Int { rawValue }
    }

    @StateObject private var quizLogic = UnifiedQuizLogic()
    @StateObject private var voice: VoiceQuizController

    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.scenePhase) private var scenePhase

    @State private var stage: Stage = .lengthPicker
    @State private var pickedLength: SessionLength = .medium
    @State private var showExitConfirm: Bool = false
    @State private var showReviewMissed: Bool = false
    /// Guard against re-entering `.finished` actions: when the controller
    /// flips `phase = .finished`, we want to (a) speak the score summary
    /// once and (b) move to the finished stage. SwiftUI's `.onReceive`
    /// can fire repeatedly during state churn; this latch keeps the
    /// summary TTS to a single utterance.
    @State private var didAnnounceFinish: Bool = false
    /// Holds the score-announcement TTS subscription. Stored on the view
    /// (not in the controller) because the controller is in `.finished`
    /// when the announcement runs and we don't want it re-binding to a
    /// dead session. Reassigning this property auto-cancels the previous
    /// subscription, which is the right behavior on Try-Again.
    @State private var summaryAnnouncement: AnyCancellable?

    init(language: AppLanguage) {
        self.language = language
        let logic = UnifiedQuizLogic()
        // Audio-only is hands-free study, so accuracy matters as much as in
        // mock interview — use cloud Whisper when available. Falls back to
        // LocalSTTService when Supabase isn't configured so dev / offline
        // sessions still work.
        let stt: SpeechToTextService = SupabaseConfig.isConfigured
            ? WhisperSTTService()
            : ServiceLocator.shared.sttService
        // Use the shared `TTSRouter` (default arg). Router is language-aware:
        // English → OpenAI nova; non-English → on-device local voices.
        let vc = VoiceQuizController(quizLogic: logic, stt: stt)
        vc.autoAdvance = true
        vc.speakAnswerFeedback = true
        vc.localeCode = language.rawValue
        vc.offlineSTT = true
        vc.variantIndex = language == .english ? 0 : 1

        // Audio-only-specific safety nets, both gated by VoiceQuizController
        // config knobs that other consumers leave at their defaults.
        // Watchdog: if the feedback chain stalls (TTS publisher never
        // completes), force-advance after 8s instead of stalling silently.
        vc.feedbackWatchdogTimeout = 8
        // Empty-spoken retry: speak "I didn't hear you, try again" on the
        // first silent listen, mark-wrong-and-advance on the second.
        vc.retryOnEmptySpoken = true
        vc.emptySpokenRetryLimit = 1

        _quizLogic = StateObject(wrappedValue: logic)
        _voice = StateObject(wrappedValue: vc)
    }

    private var s: UIStrings { UIStrings.forLanguage(language) }

    /// Permissions denied / restricted → can't run the voice flow at all.
    private var isMicBlocked: Bool {
        voice.authorizationStatus == .denied
            || voice.authorizationStatus == .restricted
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0, green: 0.08, blue: 0.25), .black],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            Group {
                if isMicBlocked {
                    permissionScreen
                } else {
                    switch stage {
                    case .lengthPicker: lengthPickerScreen
                    case .session:      sessionScreen
                    case .finished:     finishedScreen
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) { backButton }
        }
        .onAppear {
            voice.requestAuthorization()
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onChange(of: voice.authorizationStatus) { _ in
            if isMicBlocked {
                voice.stop()
                voice.cancelPendingInterruptionResume()
            }
        }
        .onChange(of: scenePhase) { phase in
            // Refresh auth on Settings-return so a user who toggled mic
            // access gets unstuck without a manual restart.
            if phase == .active && isMicBlocked {
                voice.requestAuthorization()
            }
        }
        .onChange(of: voice.phase) { newPhase in
            // Controller signals end-of-session → switch stage and speak
            // the score summary once. Latched via `didAnnounceFinish`.
            if newPhase == .finished, stage == .session, !didAnnounceFinish {
                didAnnounceFinish = true
                stage = .finished
                announceFinalScore()
            }
        }
        .alert(s.audioOnlyExitConfirmTitle, isPresented: $showExitConfirm) {
            Button(s.audioOnlyExitConfirmEnd, role: .destructive) {
                voice.stop()
                quizLogic.forceEnd()
                presentationMode.wrappedValue.dismiss()
            }
            Button(s.audioOnlyExitConfirmCancel, role: .cancel) { }
        } message: {
            Text(s.audioOnlyExitConfirmMessage)
        }
        .sheet(isPresented: $showReviewMissed) {
            // Pass the same `variantIndex` the controller used so the
            // review shows the question text in the user's language
            // (variant 1 for non-English) rather than the English source.
            ReviewMissedSheet(
                language: language,
                variantIndex: language == .english ? 0 : 1,
                answerLog: quizLogic.answerLog
            )
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
            // Defensive cleanup — see prior comment in older revision.
            voice.stop()
            voice.cancelPendingInterruptionResume()
            AudioSessionPrewarmer.deactivate()
        }
    }

    // ─────────────────────────────────────────────────────────────
    // MARK: Back button
    // ─────────────────────────────────────────────────────────────

    /// Always-visible back button. During an active session the tap is
    /// routed through `showExitConfirm` so a brushed touch can't destroy
    /// progress. On the picker / finished stages it dismisses immediately.
    private var backButton: some View {
        Button {
            switch stage {
            case .lengthPicker, .finished:
                voice.stop()
                presentationMode.wrappedValue.dismiss()
            case .session:
                showExitConfirm = true
            }
        } label: {
            Image(systemName: "chevron.backward")
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .accessibilityLabel(s.a11yBack)
    }

    // ─────────────────────────────────────────────────────────────
    // MARK: Permission screen (unchanged from prior version)
    // ─────────────────────────────────────────────────────────────

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
                    RoundedRectangle(cornerRadius: 14).fill(Color.blue)
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 6)
            Spacer()
        }
    }

    // ─────────────────────────────────────────────────────────────
    // MARK: Stage 1 — length picker
    // ─────────────────────────────────────────────────────────────

    private var lengthPickerScreen: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 12)

            // Hero icon
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [.blue.opacity(0.4), .blue.opacity(0.05)],
                        startPoint: .top, endPoint: .bottom))
                    .frame(width: 110, height: 110)
                Image(systemName: "headphones.circle.fill")
                    .font(.system(size: 56))
                    .foregroundColor(.blue)
            }

            Text(s.audioOnlyChooseLengthTitle)
                .font(.title2.bold())
                .foregroundColor(.white)

            Text(s.audioOnlyLengthTip)
                .font(.footnote)
                .foregroundColor(.white.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            // Cards
            VStack(spacing: 10) {
                ForEach(SessionLength.allCases) { len in
                    lengthCard(len)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 4)

            Spacer()

            // Start CTA
            Button {
                startSession()
            } label: {
                Text(s.audioOnlyStartBtn)
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(LinearGradient(
                                colors: [.green, .green.opacity(0.8)],
                                startPoint: .leading, endPoint: .trailing))
                    )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
    }

    private func lengthCard(_ len: SessionLength) -> some View {
        let isSelected = pickedLength == len
        let title: String
        let subtitle: String
        switch len {
        case .short:
            title = String(format: s.audioOnlyLengthCardFormat, len.rawValue)
            subtitle = s.audioOnlyLengthShortSubtitle
        case .medium:
            title = String(format: s.audioOnlyLengthCardFormat, len.rawValue)
            subtitle = s.audioOnlyLengthMediumSubtitle
        case .long:
            title = String(format: s.audioOnlyLengthCardFormat, len.rawValue)
            subtitle = s.audioOnlyLengthLongSubtitle
        case .full:
            title = s.audioOnlyLengthFullPool
            subtitle = s.audioOnlyLengthFullSubtitle
        }
        return Button {
            withAnimation(.easeInOut(duration: 0.15)) { pickedLength = len }
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.green : Color.white.opacity(0.2),
                                lineWidth: 2)
                        .frame(width: 22, height: 22)
                    if isSelected {
                        Circle().fill(Color.green).frame(width: 12, height: 12)
                    }
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.55))
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? Color.green.opacity(0.10) : Color.white.opacity(0.04))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.green.opacity(0.6) : Color.white.opacity(0.08),
                            lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func startSession() {
        guard voice.authorizationStatus == .authorized else { return }
        AudioSessionPrewarmer.prewarm {
            let pool = QuestionPool.allQuestions(for: language)
            quizLogic.languageTag = language.rawValue
            // SessionLength.full's rawValue (999) is greater than any
            // realistic pool, so `startAudioOnly` caps it to the actual
            // pool size — full-pool means "every question once, in
            // shuffled order."
            quizLogic.startAudioOnly(from: pool, questionCount: pickedLength.rawValue)
            didAnnounceFinish = false
            stage = .session
            voice.start()
        }
    }

    // ─────────────────────────────────────────────────────────────
    // MARK: Stage 2 — running session
    // ─────────────────────────────────────────────────────────────

    private var sessionScreen: some View {
        VStack(spacing: 28) {
            Spacer()

            phaseIndicator

            if quizLogic.totalQuestions > 0 {
                VStack(spacing: 8) {
                    ProgressView(
                        value: Double(quizLogic.attemptedQuestions),
                        total: Double(max(quizLogic.totalQuestions, 1))
                    )
                    .accentColor(.blue)
                    .padding(.horizontal, 40)

                    Text(String(format: s.audioOnlyProgressFormat,
                                quizLogic.attemptedQuestions,
                                quizLogic.totalQuestions,
                                quizLogic.correctAnswers))
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.6))
                }
            }

            if !voice.transcription.isEmpty {
                Text(voice.transcription)
                    .font(.body)
                    .foregroundColor(.yellow)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            if let correct = voice.lastAnswerCorrect {
                Text(correct ? s.interviewCorrect : s.interviewWrong)
                    .font(.title2.bold())
                    .foregroundColor(correct ? .green : .red)
            }

            Spacer()

            Button {
                voice.toggleMic()
            } label: {
                Image(systemName: voice.isRecording ? "mic.circle.fill" : "mic.circle")
                    .font(.system(size: 70))
                    .foregroundColor(voice.isRecording ? .red : .blue)
            }

            Spacer()

            // End-session button: routes through confirm dialog (same path
            // as the toolbar back button during a session).
            Button {
                showExitConfirm = true
            } label: {
                Text(s.audioOnlyStopBtn)
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.85))
                    .cornerRadius(14)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 24)
        }
    }

    private var phaseIndicator: some View {
        VStack(spacing: 12) {
            // Whisper round-trip window: phase is still .listening (rec
            // doesn't flip until the upload returns) but the user has
            // already stopped talking. Show the same "Processing…" tile
            // we use for matching/awaitingContinue so the user isn't
            // told to "Speak your answer" while we're already uploading.
            if voice.isProcessingTranscript {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 50))
                    .foregroundColor(.yellow)
                Text(s.audioOnlyStatusProcessing)
                    .foregroundColor(.white.opacity(0.6))
            } else {
            switch voice.phase {
            case .speakingQuestion:
                Image(systemName: "speaker.wave.2.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.blue)
                Text(s.audioOnlyStatusListeningToQuestion)
                    .foregroundColor(.white.opacity(0.6))

            case .listening:
                Image(systemName: "mic.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.red)
                Text(s.audioOnlyStatusSpeakYourAnswer)
                    .foregroundColor(.white.opacity(0.6))

            case .processingAnswer, .matching, .awaitingContinue:
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 50))
                    .foregroundColor(.yellow)
                Text(s.audioOnlyStatusProcessing)
                    .foregroundColor(.white.opacity(0.6))

            case .idle:
                Image(systemName: "headphones.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white.opacity(0.4))
                Text(s.audioOnly)
                    .foregroundColor(.white.opacity(0.6))

            case .finished:
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.green)
            }
            }
        }
        .font(.subheadline)
    }

    // ─────────────────────────────────────────────────────────────
    // MARK: Stage 3 — finished
    // ─────────────────────────────────────────────────────────────

    private var finishedScreen: some View {
        VStack(spacing: 18) {
            Spacer()
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [.green.opacity(0.35), .green.opacity(0.05)],
                        startPoint: .top, endPoint: .bottom))
                    .frame(width: 130, height: 130)
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
            }
            Text(s.audioOnlySessionComplete)
                .font(.title.bold())
                .foregroundColor(.white)
            Text(String(format: s.audioOnlyFinalScoreFormat,
                        quizLogic.correctAnswers,
                        quizLogic.attemptedQuestions,
                        quizLogic.scorePercentage))
                .font(.title3)
                .foregroundColor(.white.opacity(0.85))

            Spacer()

            VStack(spacing: 12) {
                // Try Again — restart with the same length.
                Button {
                    didAnnounceFinish = false
                    startSession()
                } label: {
                    Text(s.resultTryAgain)
                        .font(.headline.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(LinearGradient(
                                    colors: [.blue, .blue.opacity(0.8)],
                                    startPoint: .leading, endPoint: .trailing))
                        )
                }

                // Review Missed — only enabled when there are misses to show.
                Button {
                    showReviewMissed = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "list.bullet.rectangle")
                        Text(s.audioOnlyReviewMissedBtn)
                    }
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 46)
                    .background(
                        RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.10))
                    )
                }

                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text(s.resultDone)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .frame(maxWidth: .infinity, minHeight: 40)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }

    /// Speak the final-score summary once when the session finishes. Uses
    /// the existing localized announcement format so all four languages
    /// hear "Session complete. You scored X out of Y. Z percent."
    private func announceFinalScore() {
        let phrase = String(format: s.audioOnlySessionAnnouncementFormat,
                            quizLogic.correctAnswers,
                            quizLogic.attemptedQuestions,
                            quizLogic.scorePercentage)
        // Reassigning the @State cancellable cancels any prior subscription
        // (e.g. a stale Try-Again-during-announcement), then starts the
        // new utterance. Going through ServiceLocator's TTSRouter directly
        // — `voice` is already in `.finished` and we don't want its TTS
        // chain re-bound here.
        summaryAnnouncement = ServiceLocator.shared.ttsService
            .speak(phrase, languageCode: language.rawValue)
            .sink { _ in }
    }
}

// ═════════════════════════════════════════════════════════════════
// MARK: - Review Missed Sheet
// ═════════════════════════════════════════════════════════════════

/// Lists every wrong-answer attempt from the just-finished session with
/// what the user said, the correct answer, and the explanation. Empty
/// state shown when there are no misses (a perfect run).
private struct ReviewMissedSheet: View {

    let language: AppLanguage
    /// Which variant of each question to render (matches what the
    /// controller spoke during the session — 0 for English, 1 for the
    /// user's localized variant).
    let variantIndex: Int
    let answerLog: [UnifiedQuizLogic.AnswerLogEntry]

    @Environment(\.dismiss) private var dismiss

    private var s: UIStrings { UIStrings.forLanguage(language) }

    /// Filters down to incorrect entries only. Index-out-of-range
    /// `userAnswer == nil` (the voice-no-match path) is included —
    /// those are the cases where review is most useful.
    private var missed: [UnifiedQuizLogic.AnswerLogEntry] {
        answerLog.filter { !$0.isCorrect }
    }

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color(red: 0, green: 0.08, blue: 0.25), .black],
                    startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()

                if missed.isEmpty {
                    VStack(spacing: 14) {
                        Image(systemName: "star.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.yellow)
                        Text(s.audioOnlyReviewEmptyState)
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(Array(missed.enumerated()), id: \.offset) { _, entry in
                                missedCard(entry)
                            }
                        }
                        .padding(20)
                    }
                }
            }
            .navigationTitle(s.audioOnlyReviewMissedTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(s.resultDone) { dismiss() }
                        .foregroundColor(.white)
                }
            }
            .preferredColorScheme(.dark)
        }
    }

    private func missedCard(_ entry: UnifiedQuizLogic.AnswerLogEntry) -> some View {
        // Clamp the variant index in case a question's variant array is
        // shorter than expected — fall back to the first available.
        let variants = entry.question.variants
        let idx = min(variantIndex, max(variants.count - 1, 0))
        let v = variants.indices.contains(idx) ? variants[idx] : variants.first
        let questionText = v?.text ?? ""
        let correctText = v?.options[safe: entry.question.correctAnswer] ?? ""
        let explanation = v?.explanation ?? ""

        return VStack(alignment: .leading, spacing: 10) {
            Text(questionText)
                .font(.subheadline.bold())
                .foregroundColor(.white)

            VStack(alignment: .leading, spacing: 2) {
                Text(s.audioOnlyReviewYouSaidLabel)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
                Text(entry.userSpokenText?.isEmpty == false
                     ? entry.userSpokenText!
                     : s.audioOnlyReviewNoAnswerCaptured)
                    .font(.subheadline)
                    .foregroundColor(.red.opacity(0.85))
                    .italic()
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(s.audioOnlyReviewCorrectLabel)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
                Text(correctText)
                    .font(.subheadline.bold())
                    .foregroundColor(.green)
            }

            if !explanation.isEmpty {
                Text(explanation)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.65))
                    .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.05))
        )
    }
}

