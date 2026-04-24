import SwiftUI

/// USCIS-style Writing Test simulation.
///
/// Picks 3 random sentences from the writing vocabulary pool. For each sentence the
/// TTS dictates it (once automatically, with a Play Again button). The user types
/// what they heard, the typed answer is graded with `WritingDiffRenderer` (same
/// logic as Writing Practice Learn Mode), and the session passes if at least 1 of 3
/// sentences is written correctly — matching real USCIS scoring.
struct WritingTestView: View {

    let language: AppLanguage
    let pool: [ReadingWritingWord]
    /// M2: bound to the parent `WritingPracticeView` so it can show a confirm
    /// dialog when the user taps Back during an in-progress test session.
    @Binding var sessionActive: Bool

    @StateObject private var session: TestSessionEngine

    @State private var userInput: String = ""
    @State private var lastDiff: WritingDiffRenderer.Diff?
    // F5: auto-focus the typing field after dictation starts.
    @FocusState private var inputFocused: Bool
    // F4: guard for delayed auto-speak — don't fire if the view already disappeared.
    @State private var isAppeared: Bool = false
    // F6: exactly-once guard for recording this session's outcome to ProgressManager.
    @State private var sessionRecorded: Bool = false

    private var s: UIStrings { UIStrings.forLanguage(language) }

    init(language: AppLanguage,
         pool: [ReadingWritingWord],
         sessionActive: Binding<Bool>) {
        self.language = language
        self.pool = pool
        self._sessionActive = sessionActive
        let words = TestSentencePicker.pick(
            from: pool,
            excludingRecent: ProgressManager.shared.recentWritingSentenceIDs
        )
        let sentences = words.map { $0.exampleSentence }
        _session = StateObject(wrappedValue: TestSessionEngine(sentences: sentences))
        ProgressManager.shared.rememberWritingSentences(words.map { $0.id })
    }

    var body: some View {
        Group {
            if session.isFinished {
                sessionSummary
            } else if let diff = lastDiff {
                perSentenceResult(diff)
            } else {
                dictationPrompt
            }
        }
        .onAppear {
            isAppeared = true
            // Auto-dictate the first sentence after a short delay (F4: skip if disappeared).
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                guard isAppeared else { return }
                speak(session.currentSentence)
            }
            // F5: auto-focus a beat later so the keyboard is up by the time the user starts typing.
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                guard isAppeared else { return }
                inputFocused = true
            }
            // M2: mark session active so the parent's back button will confirm.
            sessionActive = !session.isFinished
        }
        .onDisappear {
            isAppeared = false
            SlowSpeechHelper.shared.stop()
            // M2: clear the flag — user is no longer on the Test tab.
            sessionActive = false
        }
        .onChange(of: session.isFinished) { finished in
            sessionActive = !finished
            // F6: record this session's outcome to ProgressManager, exactly once.
            if finished && !sessionRecorded {
                sessionRecorded = true
                ProgressManager.shared.recordWritingTestSession(passed: session.sessionPassed)
            }
        }
    }

    // MARK: - Dictation prompt (main input flow)

    private var dictationPrompt: some View {
        VStack(spacing: 20) {
            // Progress header
            HStack {
                Text(String(format: s.testModeSentenceOfFormat,
                            session.currentIndex + 1,
                            session.attempts.count))
                    .font(.subheadline.bold())
                    .foregroundColor(.orange)
                Spacer()
                Text(sessionProgressPill)
                    .font(.caption.bold())
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color.white.opacity(0.08)))
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)

            Spacer()

            // Dictation icon + replay button
            VStack(spacing: 14) {
                Image(systemName: "ear.fill")
                    .font(.system(size: 44))
                    .foregroundColor(.blue)
                Text(s.writingHeader)
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                // F7: English-language disclaimer shown in user's app language.
                Text(s.writingEnglishDisclaimer)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                Button {
                    speak(session.currentSentence)
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "speaker.wave.2.fill")
                        Text(s.writingPlayAgainBtn)
                    }
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 20).padding(.vertical, 10)
                    .background(Capsule().fill(Color.blue.opacity(0.85)))
                }
            }

            // Typing input
            TextField(s.writingInputPlaceholder, text: $userInput)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.sentences)
                .disableAutocorrection(true)
                .focused($inputFocused)
                .padding(.horizontal, 24)
                .padding(.top, 8)

            // Check button
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

            Spacer()
        }
    }

    // MARK: - Per-sentence result

    private func perSentenceResult(_ diff: WritingDiffRenderer.Diff) -> some View {
        let passed = diff.ratio >= WritingDiffRenderer.passThreshold(expectedTokenCount: diff.expectedTokens.count)
        return VStack(spacing: 18) {
            HStack(spacing: 10) {
                Image(systemName: passed ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.title2)
                Text(passed ? s.writingCorrectLabel : s.writingIncorrectLabel)
                    .font(.title2.bold())
            }
            .foregroundColor(passed ? .green : .red)
            .padding(.top, 20)

            Text(String(format: s.writingWordsCorrectFormat,
                        diff.wordsCorrect, diff.expectedTokens.count))
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))

            VStack(spacing: 6) {
                Text(s.writingCorrectAnswerLabel)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
                highlightedDiff(diff)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }

            Spacer()

            Button {
                advanceSession()
            } label: {
                Text(s.testModeContinueBtn)
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color.blue))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 30)
        }
    }

    // MARK: - Session summary

    private var sessionSummary: some View {
        let passed = session.sessionPassed
        return VStack(spacing: 20) {
            Spacer()

            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [(passed ? Color.green : Color.orange).opacity(0.4),
                                 (passed ? Color.green : Color.orange).opacity(0.05)],
                        startPoint: .top, endPoint: .bottom))
                    .frame(width: 120, height: 120)
                Image(systemName: passed ? "checkmark.seal.fill" : "arrow.clockwise")
                    .font(.system(size: 52))
                    .foregroundColor(passed ? .green : .orange)
            }

            Text(passed ? s.testModeSessionPassed : s.testModeSessionFailed)
                .font(.largeTitle.bold())
                .foregroundColor(passed ? .green : .orange)
                .multilineTextAlignment(.center)

            Text(String(format: s.testModeScoreFormat,
                        session.sentencesPassed, session.attempts.count))
                .font(.headline)
                .foregroundColor(.white.opacity(0.75))

            // Per-sentence review
            VStack(spacing: 8) {
                ForEach(Array(session.attempts.enumerated()), id: \.element.id) { (idx, attempt) in
                    HStack(spacing: 10) {
                        Image(systemName: attempt.passed ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(attempt.passed ? .green : .red)
                        Text(attempt.sentence)
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.85))
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, 14).padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.04)))
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)

            Spacer()

            Button {
                restartSession()
            } label: {
                Label(s.testModeRestartBtn, systemImage: "arrow.clockwise")
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color.blue))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 30)
        }
    }

    // MARK: - Helpers

    private var sessionProgressPill: String {
        "✓ \(session.sentencesPassed)"
    }

    private func checkAnswer() {
        SlowSpeechHelper.shared.stop()
        let diff = WritingDiffRenderer.diff(
            expected: session.currentSentence,
            input: userInput
        )
        let passed = diff.ratio >= WritingDiffRenderer.passThreshold(expectedTokenCount: diff.expectedTokens.count)
        session.recordAttempt(userAnswer: userInput, passed: passed)
        lastDiff = diff
    }

    private func advanceSession() {
        lastDiff = nil
        userInput = ""
        session.advance()
        if !session.isFinished {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                guard isAppeared else { return }
                speak(session.currentSentence)
            }
        }
    }

    private func restartSession() {
        lastDiff = nil
        userInput = ""
        sessionRecorded = false  // F6: new session = new record on completion
        SlowSpeechHelper.shared.stop()
        let words = TestSentencePicker.pick(
            from: pool,
            excludingRecent: ProgressManager.shared.recentWritingSentenceIDs
        )
        ProgressManager.shared.rememberWritingSentences(words.map { $0.id })
        session.restart(with: words.map { $0.exampleSentence })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            guard isAppeared else { return }
            speak(session.currentSentence)
        }
    }

    private func speak(_ text: String) {
        SlowSpeechHelper.shared.speak(text, rateMultiplier: 0.8)
    }

    // N1: wrong words get bold + underline so colorblind users have a non-color cue.
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
