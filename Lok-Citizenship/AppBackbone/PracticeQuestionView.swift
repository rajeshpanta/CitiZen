//import SwiftUI
//
///// A view that displays a single practice question, plus on-device TTS (🔊) and STT (🎤) buttons.
///// Below, it shows a scrollable transcription area.
///// Bindings are driven by `PracticeQuestionViewModel`.
//struct PracticeQuestionView: View {
//    @StateObject var viewModel: PracticeQuestionViewModel
//    @Environment(\.presentationMode) var presentationMode   // ← Needed for “Quit”
//
//    var body: some View {
//        VStack(spacing: 24) {
//            // MARK: Question Text
//            Text(viewModel.questionText)
//                .font(.title2)
//                .multilineTextAlignment(.leading)
//                .padding(.horizontal)
//
//            // MARK: Text-to-Speech (TTS) Button / Spinner
//            HStack {
//                Spacer()
//                if viewModel.isSpeaking {
//                    // Show a spinner while TTS is speaking
//                    ProgressView()
//                        .progressViewStyle(CircularProgressViewStyle())
//                        .scaleEffect(1.2)
//                        .padding(.trailing, 24)
//                } else {
//                    Button(action: {
//                        viewModel.speakQuestion()
//                    }) {
//                        Image(systemName: "speaker.wave.2.fill")
//                            .font(.system(size: 32))
//                            .foregroundColor(.blue)
//                    }
//                    .padding(.trailing, 24)
//                    .disabled(viewModel.isSpeaking)
//                }
//            }
//
//            // MARK: Speech-to-Text (STT) Button
//            HStack {
//                Spacer()
//                if viewModel.isRecording {
//                    Button(action: {
//                        viewModel.stopRecording()
//                    }) {
//                        Image(systemName: "mic.circle.fill")
//                            .font(.system(size: 48))
//                            .foregroundColor(.red)
//                    }
//                    .padding(.trailing, 24)
//                } else {
//                    Button(action: {
//                        viewModel.startRecording()
//                    }) {
//                        Image(systemName: "mic.circle")
//                            .font(.system(size: 48))
//                            .foregroundColor(.blue)
//                    }
//                    .padding(.trailing, 24)
//                    .disabled(viewModel.isSpeaking) // Don’t record while TTS is speaking
//                }
//            }
//
//            // MARK: Transcription Display
//            VStack(alignment: .leading, spacing: 8) {
//                Text("Your Answer:")
//                    .font(.headline)
//                ScrollView {
//                    Text(viewModel.transcription)
//                        .font(.body)
//                        .padding()
//                        .background(Color(.secondarySystemBackground))
//                        .cornerRadius(8)
//                }
//                .frame(height: 150)
//            }
//            .padding(.horizontal)
//
//            Spacer()
//        }
//        .navigationTitle("Practice Question")
//        .padding(.top, 16)
//
//        // If user denied STT permissions, show an alert
//        .alert(isPresented: $viewModel.showAuthorizationAlert) {
//            Alert(
//                title: Text("Speech Recognition Disabled"),
//                message: Text("Please enable Microphone & Speech Recognition in Settings → Privacy."),
//                dismissButton: .default(Text("OK"))
//            )
//        }
//        .onAppear {
//            viewModel.requestSpeechPermissions()
//        }
//
//        // ─────────────────────────────────────────────────────────
//        //  Add the Quit button to the navigation bar here:
//        // ─────────────────────────────────────────────────────────
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button("Quit") {
//                    presentationMode.wrappedValue.dismiss()
//                }
//                .foregroundColor(.red)
//            }
//        }
//    }
//}
