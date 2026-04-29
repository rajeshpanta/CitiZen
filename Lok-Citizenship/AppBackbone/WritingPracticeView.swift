import SwiftUI

/// Writing practice: TTS dictates a sentence, user types it, order-preserving
/// Levenshtein grading via `WritingDiffRenderer`.
///
/// Two modes (segmented picker at top):
/// - **Learn Mode** (default): open-ended flashcards — dictation → type → grade → next,
///   no session, no pass/fail, no end.
/// - **Test Mode**: simulates the real USCIS writing test — 3 dictated sentences,
///   user types each, pass 1 of 3 to pass the session.
///
/// Practiced content (English USCIS sentences) stays in English; surrounding chrome
/// renders in the user's app language.
struct WritingPracticeView: View {

    var language: AppLanguage = .english

    private enum Mode: Int, CaseIterable { case learn, test }
    @State private var mode: Mode = .learn

    @State private var currentIndex = 0
    @State private var userInput = ""
    @State private var lastDiff: WritingDiffRenderer.Diff?
    @State private var words = ReadingWritingContent.writingVocabulary.shuffled()

    // M2: in-progress Test session flag + confirm-exit alert state.
    @State private var testSessionActive: Bool = false
    @State private var showExitConfirm: Bool = false
    /// Tab-switch abandon-confirm state. Mirrors ReadingPracticeView:
    /// the picker's custom binding diverts an "abandon the active Test
    /// tab" gesture into this alert; confirm applies `pendingMode`,
    /// cancel drops it.
    @State private var showAbandonTabConfirm: Bool = false
    @State private var pendingMode: Mode? = nil
    // F5: auto-focus the text field shortly after the view appears.
    @FocusState private var inputFocused: Bool
    // F4: guard for delayed auto-speak — if user leaves before the delay fires,
    // skip the speak so it can't collide with a Test-mode auto-dictation.
    @State private var isAppeared: Bool = false

    // Speaker-button loading state — see ReadingPracticeView for full notes.
    // Cloud TTS cold path is 300–1500 ms; spinner shows during that gap.
    @State private var isSpeakerLoading: Bool = false
    @State private var speakerLoadNonce: Int = 0

    @Environment(\.dismiss) private var dismiss

    private var s: UIStrings { UIStrings.forLanguage(language) }

    private var currentWord: ReadingWritingWord {
        words[currentIndex % words.count]
    }

    /// Length-aware pass decision: uses `WritingDiffRenderer.passThreshold` so the
    /// grade is lenient in proportion to sentence length (see M1 — ESL-friendly
    /// against longer sentences without being sloppy on short ones).
    private var isCorrect: Bool {
        guard let diff = lastDiff else { return false }
        return diff.ratio >= WritingDiffRenderer.passThreshold(expectedTokenCount: diff.expectedTokens.count)
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
                    WritingTestView(language: language,
                                    pool: ReadingWritingContent.writingVocabulary,
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
        .navigationTitle(s.navWritingPractice)
        // F2: also block edge-swipe pop so it respects the confirm-exit alert.
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
        // Release the audio session when the user actually leaves Writing
        // Practice (back-button or swipe-back). Inner `.onDisappear` hooks
        // on `learnModeBody` / `WritingTestView` deliberately don't
        // deactivate — those fire on every Learn↔Test tab switch and
        // would re-introduce the music-pumping we just fixed for the
        // mock-interview flow. This outer hook fires only on screen-leave.
        .onDisappear {
            AudioSessionPrewarmer.deactivate()
        }
    }

    // MARK: - Learn mode (existing flashcard flow, unchanged)

    private var learnModeBody: some View {
        VStack(spacing: 20) {

            // Progress
            HStack {
                Text(String(format: s.practiceCardCountFormat, currentIndex + 1, words.count))
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.5))
                Spacer()
                Text(s.localizedCategory(currentWord.category))
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

                Text(s.writingHeader)
                    .font(.headline)
                    .foregroundColor(.white)

                // F7: remind non-English-speaking users that the test itself is English.
                // Text renders in their app language so they understand the requirement.
                Text(s.writingEnglishDisclaimer)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                Button {
                    speak(currentWord.exampleSentence)
                } label: {
                    HStack(spacing: 8) {
                        // ZStack with fixed slot keeps button width
                        // stable when the icon is swapped for a spinner
                        // — see ReadingPracticeView for full rationale.
                        ZStack {
                            if isSpeakerLoading {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .tint(.blue)
                            } else {
                                Image(systemName: "speaker.wave.2.fill")
                            }
                        }
                        .frame(width: 18, height: 18)
                        Text(s.writingPlayAgainBtn)
                    }
                    .font(.subheadline.bold())
                    .foregroundColor(.blue)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(Color.blue.opacity(0.15)))
                }
                .disabled(isSpeakerLoading)
            }

            // Text input
            TextField(s.writingInputPlaceholder, text: $userInput)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.sentences)
                .disableAutocorrection(true)
                .focused($inputFocused)
                .padding(.horizontal, 24)

            // Check button
            if lastDiff == nil {
                Button {
                    checkAnswer()
                } label: {
                    Text(s.writingCheckBtn)
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
            if let diff = lastDiff {
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        Text(isCorrect ? s.writingCorrectLabel : s.writingIncorrectLabel)
                    }
                    .font(.title3.bold())
                    .foregroundColor(isCorrect ? .green : .red)

                    Text(String(format: s.writingWordsCorrectFormat,
                                diff.wordsCorrect, diff.expectedTokens.count))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))

                    if !isCorrect {
                        VStack(spacing: 6) {
                            Text(s.writingCorrectAnswerLabel)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))
                            highlightedDiff(diff)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                        .padding(.horizontal, 16)
                    }

                    Button {
                        nextCard()
                    } label: {
                        Text(s.writingNextBtn)
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
        .onAppear {
            isAppeared = true
            // Warm the cache for the first card before auto-play. Cuts
            // perceived latency on cold launch when the network round-trip
            // would otherwise stack on top of the 0.5s auto-play delay.
            SlowSpeechHelper.shared.prefetch(text: currentWord.exampleSentence)
            // Auto-play the first sentence (F4: skip if view disappeared before firing).
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                guard isAppeared else { return }
                speak(currentWord.exampleSentence)
            }
            // F5: auto-focus the text field a beat after the dictation starts so the
            // keyboard is ready when the user wants to type.
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                guard isAppeared else { return }
                inputFocused = true
            }
        }
        // Prefetch the new card whenever the index advances, so a Play
        // Again tap on the next card is a cache hit. The auto-play in
        // `nextCard` will warm the cache too, but starting the prefetch
        // earlier (the moment index changes) covers the small race
        // where the user taps Play Again before auto-play resolves.
        .onChange(of: currentIndex) { _ in
            SlowSpeechHelper.shared.prefetch(text: currentWord.exampleSentence)
        }
        // Clear the spinner the moment cloud audio actually starts.
        // Safety timeout in `speak()` handles the local-fallback path.
        .onReceive(SlowSpeechHelper.shared.isSpeakingPublisher) { speaking in
            if speaking { isSpeakerLoading = false }
        }
        // C1: stop Learn-mode TTS when user switches to the Test tab or leaves the screen,
        // so it can't overlap with Test Mode's auto-dictation.
        .onDisappear {
            isAppeared = false
            SlowSpeechHelper.shared.stop()
            isSpeakerLoading = false
        }
    }

    private func checkAnswer() {
        lastDiff = WritingDiffRenderer.diff(
            expected: currentWord.exampleSentence,
            input: userInput
        )
    }

    private func nextCard() {
        SlowSpeechHelper.shared.stop()
        isSpeakerLoading = false
        userInput = ""
        lastDiff = nil
        currentIndex += 1
        if currentIndex >= words.count {
            words.shuffle()
            currentIndex = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            guard isAppeared else { return }
            speak(currentWord.exampleSentence)
        }
    }

    private func speak(_ text: String) {
        isSpeakerLoading = true
        speakerLoadNonce &+= 1
        let myNonce = speakerLoadNonce
        SlowSpeechHelper.shared.speak(text, rateMultiplier: 0.8)
        // Safety net for the local-fallback path — see ReadingPracticeView.speak.
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            if speakerLoadNonce == myNonce {
                isSpeakerLoading = false
            }
        }
    }

    /// Render the expected sentence with green = matched-in-order, red = missed-or-out-of-order.
    /// N1: wrong words also get an underline so colorblind users have a non-color cue
    /// (bold + underline together unambiguously indicate "this is wrong").
    private func highlightedDiff(_ diff: WritingDiffRenderer.Diff) -> Text {
        var result = Text("")
        for (idx, word) in diff.expectedTokens.enumerated() {
            let matched = diff.expectedMatches[idx]
            let chunk = Text(word)
                .foregroundColor(matched ? .green : .red)
                .fontWeight(matched ? .regular : .bold)
                .underline(!matched, color: .red)
            result = result + chunk
            if idx < diff.expectedTokens.count - 1 {
                result = result + Text(" ")
            }
        }
        return result
    }
}
