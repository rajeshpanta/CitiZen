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
    /// Tab-switch abandon-confirm state. The picker uses a custom binding
    /// (in `body`) that diverts a "switch away from the active Test tab"
    /// gesture into this alert instead of changing `mode` directly. On
    /// confirm we apply `pendingMode`; on cancel we drop it and leave
    /// the picker on the active Test tab.
    @State private var showAbandonTabConfirm: Bool = false
    @State private var pendingMode: Mode? = nil

    // Speaker-button loading state. The OpenAI cold path (network →
    // decode → AVAudioPlayer.play) can run 300–1500 ms; without a
    // visible indicator the speaker tap looks unresponsive. We flip to
    // true on tap, clear it the moment `SlowSpeechHelper.isSpeakingPublisher`
    // emits true (audio actually started), and rely on `speakerLoadNonce`
    // to invalidate stale safety-timeout closures across rapid taps.
    @State private var isSpeakerLoading: Bool = false
    @State private var speakerLoadNonce: Int = 0

    @Environment(\.dismiss) private var dismiss

    private var s: UIStrings { UIStrings.forLanguage(language) }

    private var currentWord: ReadingWritingWord {
        words[currentIndex % words.count]
    }

    var body: some View {
        VStack(spacing: 0) {
            // Mode selector. Custom binding intercepts tab-switch
            // attempts during an active test session and routes them
            // through `showAbandonTabConfirm` instead of letting `mode`
            // change silently — same destructive-action treatment as
            // the back-button confirm dialog. Switches when no test is
            // active pass straight through.
            Picker("", selection: Binding(
                get: { mode },
                set: { newValue in
                    if testSessionActive && newValue != mode {
                        pendingMode = newValue
                        showAbandonTabConfirm = true
                    } else {
                        mode = newValue
                    }
                }
            )) {
                Text(s.testModeLearn).tag(Mode.learn)
                Text(s.testModeTest).tag(Mode.test)
            }
            .pickerStyle(.segmented)
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
        // Tab-switch abandon-confirm. Reuses the same exit-confirm strings
        // since the user-visible action is identical (abandon the in-progress
        // test session, lose progress on this attempt).
        .alert(s.testModeExitConfirmTitle, isPresented: $showAbandonTabConfirm) {
            Button(s.testModeExitConfirmYes, role: .destructive) {
                if let m = pendingMode { mode = m }
                pendingMode = nil
            }
            Button(s.testModeExitConfirmNo, role: .cancel) {
                pendingMode = nil
            }
        } message: {
            Text(s.testModeExitConfirmMessage)
        }
        // Release the audio session when the user actually leaves Reading
        // Practice (back-button or swipe-back). Inner `.onDisappear` hooks
        // on `learnModeBody` / `ReadingTestView` deliberately don't
        // deactivate — those fire on every Learn↔Test tab switch and
        // would re-introduce the music-pumping we just fixed for the
        // mock-interview flow. This outer hook fires only on screen-leave.
        .onDisappear {
            AudioSessionPrewarmer.deactivate()
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
                        ZStack {
                            // Fixed-size slot keeps the button height
                            // stable across the spinner ↔ icon swap.
                            if isSpeakerLoading {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .tint(.blue)
                            } else {
                                Image(systemName: "speaker.wave.2.fill")
                                    .font(.system(size: 24))
                            }
                        }
                        .frame(width: 28, height: 28)
                        Text(s.readingListenBtn)
                            .font(.caption)
                    }
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color.blue.opacity(0.15)))
                }
                .disabled(isSpeakerLoading)

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
        // Warm the OpenAI MP3 cache so the first tap on the Listen
        // button is instant. No-op when OpenAI is unconfigured or the
        // cache already has the file. Runs on appear and on every card
        // advance — see `nextCard`'s onChange below.
        .onAppear {
            SlowSpeechHelper.shared.prefetch(text: currentWord.exampleSentence)
        }
        .onChange(of: currentIndex) { _ in
            SlowSpeechHelper.shared.prefetch(text: currentWord.exampleSentence)
        }
        // Cloud playback emits true the instant audio starts. Use that
        // as the authoritative "loading done" signal — more reliable
        // than guessing at a fixed delay. The 6-second nonce-guarded
        // timeout below is purely a safety net for the cloud-failure +
        // local-fallback path (AVSpeechSynthesizer doesn't go through
        // this publisher), so loading would otherwise stick.
        .onReceive(SlowSpeechHelper.shared.isSpeakingPublisher) { speaking in
            if speaking { isSpeakerLoading = false }
        }
        // C1: stop Learn-mode TTS when user switches to the Test tab or leaves the screen.
        .onDisappear {
            SlowSpeechHelper.shared.stop()
            isSpeakerLoading = false
        }
    }

    private func nextCard() {
        SlowSpeechHelper.shared.stop()
        isSpeakerLoading = false
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
        isSpeakerLoading = true
        speakerLoadNonce &+= 1
        let myNonce = speakerLoadNonce
        SlowSpeechHelper.shared.speak(text, rateMultiplier: 0.85)
        // Safety net: if isSpeakingPublisher never fires (local-TTS
        // fallback, cloud failure with no fallback), clear the spinner
        // so the button doesn't get stuck. The nonce check ensures a
        // newer tap's timeout doesn't cancel its own state.
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            if speakerLoadNonce == myNonce {
                isSpeakerLoading = false
            }
        }
    }
}
