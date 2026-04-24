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

    init(language: AppLanguage) {
        self.language = language
        let logic = UnifiedQuizLogic()
        let vc = VoiceQuizController(quizLogic: logic)
        vc.autoAdvance = true
        vc.speakAnswerFeedback = true
        vc.localeCode = language.rawValue
        // Prefer on-device STT for all languages. If the user hasn't downloaded
        // the on-device pack for their language, LocalSTTService gracefully falls
        // back to streaming via `wantOnDevice = offlineOnly && supportsOnDeviceRecognition`.
        // Matches the QuizConfig.offlineForVariant pattern used by the practice quiz.
        vc.offlineSTT = true
        vc.variantIndex = language == .english ? 0 : 1
        _quizLogic = StateObject(wrappedValue: logic)
        _voice = StateObject(wrappedValue: vc)
    }

    private var s: UIStrings { UIStrings.forLanguage(language) }

    var body: some View {
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if quizLogic.isFinished || voice.phase == .idle {
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
            let pool = QuestionPool.allQuestions(for: language)
            quizLogic.languageTag = language.rawValue
            quizLogic.startAudioOnly(from: pool, questionCount: 15)
            voice.start()
        }
        .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
            // Defensive cleanup: Stop/Back buttons already call voice.stop(),
            // but back-swipe / programmatic dismissal can bypass those paths
            // and leave TTS/STT running in the background. voice.stop() is
            // idempotent so the double-call on explicit-dismiss paths is a no-op.
            voice.stop()
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
