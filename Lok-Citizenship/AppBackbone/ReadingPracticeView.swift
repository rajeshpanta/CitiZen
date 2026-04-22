import SwiftUI
import AVFoundation

/// Flashcard-style reading practice using official USCIS vocabulary.
/// Shows a sentence, user practices reading aloud, TTS provides pronunciation.
struct ReadingPracticeView: View {

    @State private var currentIndex = 0
    @State private var showSentence = false
    @State private var words = ReadingWritingContent.readingVocabulary.shuffled()

    private let synthesizer = AVSpeechSynthesizer()

    private var currentWord: ReadingWritingWord {
        words[currentIndex % words.count]
    }

    var body: some View {
        VStack(spacing: 24) {

            // Progress
            HStack {
                Text("Card \(currentIndex + 1) of \(words.count)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.5))
                Spacer()
                Text(currentWord.category)
                    .font(.caption.bold())
                    .foregroundColor(.cyan)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.cyan.opacity(0.2)))
            }
            .padding(.horizontal, 24)

            Spacer()

            // Word card
            VStack(spacing: 16) {
                Text(currentWord.word)
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                if showSentence {
                    Text(currentWord.exampleSentence)
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.08))
            )
            .padding(.horizontal, 20)

            Spacer()

            // Action buttons
            HStack(spacing: 16) {
                // Listen button
                Button {
                    speak(currentWord.exampleSentence)
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.system(size: 24))
                        Text("Listen")
                            .font(.caption)
                    }
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color.blue.opacity(0.15)))
                }

                // Reveal / Next button
                Button {
                    if showSentence {
                        nextCard()
                    } else {
                        withAnimation { showSentence = true }
                    }
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: showSentence ? "arrow.right.circle.fill" : "eye.fill")
                            .font(.system(size: 24))
                        Text(showSentence ? "Next" : "Show")
                            .font(.caption)
                    }
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color.green.opacity(0.15)))
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .background(
            LinearGradient(
                colors: [Color(red: 0, green: 0.1, blue: 0.3), .black],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("Reading Practice")
    }

    private func nextCard() {
        synthesizer.stopSpeaking(at: .immediate)
        withAnimation {
            showSentence = false
            currentIndex += 1
            if currentIndex >= words.count {
                words.shuffle()
                currentIndex = 0
            }
        }
    }

    private func speak(_ text: String) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.85
        synthesizer.speak(utterance)
    }
}
