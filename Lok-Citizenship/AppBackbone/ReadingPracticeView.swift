import SwiftUI

/// Flashcard-style reading practice using official USCIS vocabulary, plus a
/// USCIS-style Test Mode (3-sentence read-aloud session).
///
/// Two modes, selected via the segmented control at the top:
/// - **Learn Mode** (default): flashcard drilling — shows a vocab word, reveal the
///   sentence, TTS pronounces it. Unlimited cards, no scoring.
/// - **Test Mode**: simulates the real USCIS reading test — 3 random sentences, user
///   reads each aloud, STT grades against the expected sentence, pass 1 of 3.
///
/// The practiced content (word + sentence) stays in English regardless of app
/// language — that's the actual USCIS reading test. Chrome renders in the user's
/// language.
struct ReadingPracticeView: View {

    var language: AppLanguage = .english

    private enum Mode: Int, CaseIterable { case learn, test }
    @State private var mode: Mode = .learn

    @State private var currentIndex = 0
    @State private var showSentence = false
    @State private var words = ReadingWritingContent.readingVocabulary.shuffled()

    // M2: true while a 3-sentence Test session is in progress. Back-button
    // confirmation alert fires only when this is true. `ReadingTestView` flips
    // this on its own appear/disappear + when the session finishes.
    @State private var testSessionActive: Bool = false
    @State private var showExitConfirm: Bool = false
    @Environment(\.dismiss) private var dismiss

    private var s: UIStrings { UIStrings.forLanguage(language) }

    private var currentWord: ReadingWritingWord {
        words[currentIndex % words.count]
    }

    var body: some View {
        VStack(spacing: 0) {
            // Mode selector
            Picker("", selection: $mode) {
                Text(s.testModeLearn).tag(Mode.learn)
                Text(s.testModeTest).tag(Mode.test)
            }
            .pickerStyle(.segmented)
            // Disable mid-test so the user can't silently abandon a
            // session by switching to Learn — that path bypassed the
            // back-button confirm-exit alert and skipped F6 progress
            // recording (the session was destroyed before
            // `session.isFinished` flipped). Confirm-exit alert + edge-
            // swipe block already guard the back path; this guards
            // the picker.
            .disabled(testSessionActive)
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 4)

            Group {
                switch mode {
                case .learn:
                    learnModeBody
                case .test:
                    ReadingTestView(language: language,
                                    pool: ReadingWritingContent.readingVocabulary,
                                    sessionActive: $testSessionActive)
                }
            }
        }
        .background(
            LinearGradient(
                colors: [Color(red: 0, green: 0.1, blue: 0.3), .black],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle(s.navReadingPractice)
        // F2: also block the edge-swipe-to-pop gesture so swipes don't bypass the
        // confirm-exit alert that the tapped back button triggers.
        .background(
            NavigationSwipeBackDisabler(disabled: testSessionActive)
                .frame(width: 0, height: 0)
        )
        .navigationBarBackButtonHidden(testSessionActive)
        .toolbar {
            if testSessionActive {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showExitConfirm = true
                    } label: {
                        Image(systemName: "chevron.backward")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .accessibilityLabel(s.a11yBack)
                }
            }
        }
        .alert(s.testModeExitConfirmTitle, isPresented: $showExitConfirm) {
            Button(s.testModeExitConfirmYes, role: .destructive) { dismiss() }
            Button(s.testModeExitConfirmNo, role: .cancel) { }
        } message: {
            Text(s.testModeExitConfirmMessage)
        }
    }

    // MARK: - Learn mode (existing flashcard flow, unchanged)

    private var learnModeBody: some View {
        VStack(spacing: 24) {

            // Progress
            HStack {
                Text(String(format: s.practiceCardCountFormat, currentIndex + 1, words.count))
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.5))
                Spacer()
                Text(s.localizedCategory(currentWord.category))
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
                        Text(s.readingListenBtn)
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
                        Text(showSentence ? s.readingNextBtn : s.readingShowBtn)
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
        // C1: stop Learn-mode TTS when user switches to the Test tab or leaves the screen.
        .onDisappear {
            SlowSpeechHelper.shared.stop()
        }
    }

    private func nextCard() {
        SlowSpeechHelper.shared.stop()
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
        SlowSpeechHelper.shared.speak(text, rateMultiplier: 0.85)
    }
}
