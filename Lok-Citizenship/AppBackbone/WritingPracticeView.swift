import SwiftUI
import AVFoundation

/// Writing practice: TTS dictates a sentence, user types it, fuzzy matching checks answer.
struct WritingPracticeView: View {

    @State private var currentIndex = 0
    @State private var userInput = ""
    @State private var result: AnswerResult?
    @State private var words = ReadingWritingContent.writingVocabulary.shuffled()

    private let synthesizer = AVSpeechSynthesizer()

    enum AnswerResult {
        case correct, incorrect
    }

    private var currentWord: ReadingWritingWord {
        words[currentIndex % words.count]
    }

    var body: some View {
        VStack(spacing: 20) {

            // Progress
            HStack {
                Text("Card \(currentIndex + 1) of \(words.count)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.5))
                Spacer()
                Text(currentWord.category)
                    .font(.caption.bold())
                    .foregroundColor(.orange)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.orange.opacity(0.2)))
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)

            Spacer()

            // Listen prompt
            VStack(spacing: 16) {
                Image(systemName: "ear.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)

                Text("Listen and type the sentence")
                    .font(.headline)
                    .foregroundColor(.white)

                Button {
                    speak(currentWord.exampleSentence)
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "speaker.wave.2.fill")
                        Text("Play Again")
                    }
                    .font(.subheadline.bold())
                    .foregroundColor(.blue)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(Color.blue.opacity(0.15)))
                }
            }

            // Text input
            TextField("Type what you hear...", text: $userInput)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.sentences)
                .disableAutocorrection(true)
                .padding(.horizontal, 24)

            // Check button
            if result == nil {
                Button {
                    checkAnswer()
                } label: {
                    Text("Check")
                        .font(.headline.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(userInput.isEmpty ? Color.gray : Color.blue)
                        )
                }
                .disabled(userInput.isEmpty)
                .padding(.horizontal, 24)
            }

            // Result feedback
            if let result {
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: result == .correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                        Text(result == .correct ? "Correct!" : "Not quite")
                    }
                    .font(.title3.bold())
                    .foregroundColor(result == .correct ? .green : .red)

                    if result == .incorrect {
                        VStack(spacing: 4) {
                            Text("Correct answer:")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))
                            Text(currentWord.exampleSentence)
                                .font(.body.bold())
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 24)
                    }

                    Button {
                        nextCard()
                    } label: {
                        Text("Next")
                            .font(.headline.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.green))
                    }
                    .padding(.horizontal, 24)
                }
            }

            Spacer()
        }
        .background(
            LinearGradient(
                colors: [Color(red: 0, green: 0.1, blue: 0.3), .black],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("Writing Practice")
        .onAppear {
            // Auto-play the first sentence
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                speak(currentWord.exampleSentence)
            }
        }
    }

    private func checkAnswer() {
        let similarity = fuzzyMatch(userInput, currentWord.exampleSentence)
        result = similarity >= 0.75 ? .correct : .incorrect
    }

    private func nextCard() {
        synthesizer.stopSpeaking(at: .immediate)
        userInput = ""
        result = nil
        currentIndex += 1
        if currentIndex >= words.count {
            words.shuffle()
            currentIndex = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            speak(currentWord.exampleSentence)
        }
    }

    private func speak(_ text: String) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.8
        synthesizer.speak(utterance)
    }

    /// Simple fuzzy match: compare lowercased words, return fraction of matching words.
    private func fuzzyMatch(_ input: String, _ expected: String) -> Double {
        let inputWords = Set(input.lowercased()
            .filter { $0.isLetter || $0.isWhitespace }
            .split(separator: " ")
            .map(String.init))
        let expectedWords = Set(expected.lowercased()
            .filter { $0.isLetter || $0.isWhitespace }
            .split(separator: " ")
            .map(String.init))

        guard !expectedWords.isEmpty else { return 0 }
        let matching = inputWords.intersection(expectedWords).count
        return Double(matching) / Double(expectedWords.count)
    }
}
