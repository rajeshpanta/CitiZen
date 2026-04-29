import SwiftUI
import UIKit
import Speech

/// Minimal hands-free quiz interface for audio-only studying.
/// TTS reads question → STT listens → TTS speaks feedback → next question.
struct AudioOnlyView: View {

    let language: AppLanguage

    @StateObject private var quizLogic = UnifiedQuizLogic()
    @StateObject private var voice: VoiceQuizController

    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.scenePhase) private var scenePhase

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
        let vc = VoiceQuizController(quizLogic: logic, stt: stt)
        vc.autoAdvance = true
        vc.speakAnswerFeedback = true
        vc.localeCode = language.rawValue
        // For LocalSTT: prefer on-device with graceful fallback (see
        // LocalSTTService.startRecording). Whisper ignores this flag.
        vc.offlineSTT = true
        vc.variantIndex = language == .english ? 0 : 1
        _quizLogic = StateObject(wrappedValue: logic)
        _voice = StateObject(wrappedValue: vc)
    }

    private var s: UIStrings { UIStrings.forLanguage(language) }

    /// True when mic / speech-recognition permission has been denied or
    /// restricted. In that state the voice flow can't run, so we replace the
    /// hands-free UI with a Settings prompt instead of letting the user sit
    /// in a silent timeout loop.
    private var isMicBlocked: Bool {
        voice.authorizationStatus == .denied
            || voice.authorizationStatus == .restricted
    }

    /// Idempotent: only loads questions and starts voice the first time it's
    /// called with a granted permission. Called from both onAppear (covers the
    /// already-authorized case) and onChange of authorizationStatus (covers
    /// the .notDetermined → .authorized transition after the OS prompt).
    private func startQuizIfPossible() {
        guard voice.authorizationStatus == .authorized,
              quizLogic.totalQuestions == 0 else { return }
        // Pre-warm the audio session so .duckOthers has time to lower
        // any background music before the first question's TTS plays —
        // see AudioSessionPrewarmer for why this matters.
        AudioSessionPrewarmer.prewarm {
            let pool = QuestionPool.allQuestions(for: language)
            quizLogic.languageTag = language.rawValue
            quizLogic.startAudioOnly(from: pool, questionCount: 15)
            voice.start()
        }
    }

    var body: some View {
        Group {
            if isMicBlocked {
                permissionScreen
            } else {
                quizSurface
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if quizLogic.isFinished || voice.phase == .idle || isMicBlocked {
                    Button(s.a11yBack) {
                        voice.stop()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            voice.requestAuthorization()
            // Only start once permission is actually .authorized. If still
            // .notDetermined the OS prompt is firing — the onChange below will
            // start the quiz when the user accepts. Without this, TTS would
            // begin reading into a mic that never captures audio (every
            // question would dead-end at the 10s timeout).
            startQuizIfPossible()
        }
        .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
        .onChange(of: voice.authorizationStatus) { _ in
            // Auth resolved either way. If denied/restricted, kill any
            // in-flight TTS so it doesn't keep speaking under the permission
            // screen. If just-authorized and we haven't started yet, kick off.
            if isMicBlocked {
                voice.stop()
            } else {
                startQuizIfPossible()
            }
        }
        .onChange(of: scenePhase) { phase in
            // Refresh OS-level permission on Settings return so the user who
            // toggled mic access doesn't get stuck on permissionScreen. Only
            // refresh when blocked — no need to re-query on every foreground
            // when the quiz is running.
            if phase == .active && isMicBlocked {
                voice.requestAuthorization()
            }
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
            // Defensive cleanup: Stop/Back buttons already call voice.stop(),
            // but back-swipe / programmatic dismissal can bypass those paths
            // and leave TTS/STT running in the background. voice.stop() is
            // idempotent so the double-call on explicit-dismiss paths is a no-op.
            voice.stop()
        }
    }

    // MARK: - Permission Screen

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

    // MARK: - Quiz Surface

    private var quizSurface: some View {
        VStack(spacing: 32) {

            Spacer()

            // Phase indicator
            phaseIndicator

            // Progress
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

            // Transcription
            if !voice.transcription.isEmpty {
                Text(voice.transcription)
                    .font(.body)
                    .foregroundColor(.yellow)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            // Answer feedback
            if let correct = voice.lastAnswerCorrect {
                Text(correct ? s.interviewCorrect : s.interviewWrong)
                    .font(.title2.bold())
                    .foregroundColor(correct ? .green : .red)
            }

            Spacer()

            // Mic toggle
            Button {
                voice.toggleMic()
            } label: {
                Image(systemName: voice.isRecording ? "mic.circle.fill" : "mic.circle")
                    .font(.system(size: 70))
                    .foregroundColor(voice.isRecording ? .red : .blue)
            }

            Spacer()

            // Stop button
            if !quizLogic.isFinished {
                Button {
                    voice.stop()
                    quizLogic.forceEnd()
                } label: {
                    Text(s.audioOnlyStopBtn)
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(14)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            } else {
                // Finished
                VStack(spacing: 12) {
                    Text(s.audioOnlySessionComplete)
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    Text(String(format: s.audioOnlyFinalScoreFormat,
                                quizLogic.correctAnswers,
                                quizLogic.attemptedQuestions,
                                quizLogic.scorePercentage))
                        .foregroundColor(.white.opacity(0.7))

                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text(s.resultDone)
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(14)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            }
        }
    }

    // MARK: - Phase Indicator

    private var phaseIndicator: some View {
        VStack(spacing: 12) {
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
        .font(.subheadline)
    }
}
