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
        vc.offlineSTT = language == .english
        vc.variantIndex = language == .english ? 0 : 1
        _quizLogic = StateObject(wrappedValue: logic)
        _voice = StateObject(wrappedValue: vc)
    }

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

                    Text("\(quizLogic.attemptedQuestions)/\(quizLogic.totalQuestions)  ·  \(quizLogic.correctAnswers) correct")
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
                Text(correct ? "Correct" : "Wrong")
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
                    Text("Stop")
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
                    Text("Session Complete")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    Text("\(quizLogic.correctAnswers) of \(quizLogic.attemptedQuestions) correct (\(quizLogic.scorePercentage)%)")
                        .foregroundColor(.white.opacity(0.7))

                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Done")
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
            let pool = QuestionPool.allQuestions(for: language)
            quizLogic.languageTag = language.rawValue
            quizLogic.startAudioOnly(from: pool, questionCount: 15)
            voice.start()
        }
        .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
        .onDisappear { UIApplication.shared.isIdleTimerDisabled = false }
    }

    // MARK: - Phase Indicator

    private var phaseIndicator: some View {
        VStack(spacing: 12) {
            switch voice.phase {
            case .speakingQuestion:
                Image(systemName: "speaker.wave.2.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.blue)
                Text("Listening to question...")
                    .foregroundColor(.white.opacity(0.6))

            case .listening:
                Image(systemName: "mic.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.red)
                Text("Speak your answer")
                    .foregroundColor(.white.opacity(0.6))

            case .processingAnswer:
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 50))
                    .foregroundColor(.yellow)
                Text("Processing...")
                    .foregroundColor(.white.opacity(0.6))

            case .idle:
                Image(systemName: "headphones.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white.opacity(0.4))
                Text("Audio-Only Mode")
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
