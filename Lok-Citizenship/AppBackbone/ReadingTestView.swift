import SwiftUI
import Speech

/// USCIS-style Reading Test simulation.
///
/// Picks 3 random sentences from the reading vocabulary pool. For each sentence the
/// user reads aloud (STT transcribes), the transcription is graded with the same
/// `WritingDiffRenderer` that drives Writing Practice so both paths use identical,
/// ESL-friendly grading. Session passes when the user reads at least 1 of 3 correctly
/// — matching the real USCIS reading-test scoring rule.
struct ReadingTestView: View {

    let language: AppLanguage
    let pool: [ReadingWritingWord]
    /// M2: bound to the parent `ReadingPracticeView` so it can show a confirm
    /// dialog when the user taps Back during an in-progress test session.
    @Binding var sessionActive: Bool

    @StateObject private var session: TestSessionEngine
    @StateObject private var voice = FreeformSTTController()

    @State private var lastDiff: WritingDiffRenderer.Diff?
    @State private var micDenied: Bool = false
    /// F3: separate alert path for `.restricted` — the mic permission may be fine,
    /// but the speech recognizer itself isn't available on this device.
    @State private var speechUnavailable: Bool = false
    /// C2: set when user tapped mic before granting permission. Cleared once the
    /// permission prompt completes — if granted, we auto-start recording so the
    /// user doesn't have to tap twice.
    @State private var pendingAutoStart: Bool = false
    /// C3: set when user tapped Done without any transcribed speech. Replaces the
    /// normal "tap the mic" prompt with a gentle retry message; does not advance
    /// the session so the user doesn't lose a sentence to an accidental tap.
    @State private var showEmptyWarning: Bool = false
    /// F6: ensures each completed session is recorded to ProgressManager exactly
    /// once — even if SwiftUI fires `onChange(of: session.isFinished)` multiple times.
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
            excludingRecent: ProgressManager.shared.recentReadingSentenceIDs
        )
        let sentences = words.map { $0.exampleSentence }
        _session = StateObject(wrappedValue: TestSessionEngine(sentences: sentences))
        ProgressManager.shared.rememberReadingSentences(words.map { $0.id })
    }

    var body: some View {
        Group {
            if session.isFinished {
                sessionSummary
            } else if let diff = lastDiff {
                perSentenceResult(diff)
            } else {
                readingPrompt
            }
        }
        .onAppear {
            voice.requestAuthorization()
            // Leave the picker enabled on entry — user hasn't made any
            // progress yet, so switching back to Learn loses nothing.
            // The flag flips to true the moment they actually engage
            // (mic-tap or completed sentence) via the onChange handlers
            // below; only then does the parent disable the picker.
            sessionActive = false
        }
        .onDisappear {
            voice.stop()
            SlowSpeechHelper.shared.stop()
            // M2: clear the active flag so the parent stops gating the back button.
            sessionActive = false
        }
        // First mic tap counts as engagement — they're producing audio that
        // would be lost if they switched away.
        .onChange(of: voice.isRecording) { recording in
            if recording { sessionActive = true }
        }
        // Any submitted answer counts as engagement — even if they then
        // stop recording, the result is in `attempts` and abandoning would
        // discard real progress.
        .onChange(of: session.attempts.filter(\.attempted).count) { count in
            if count > 0 { sessionActive = true }
        }
        .onChange(of: session.isFinished) { finished in
            // Session finished → back button becomes freely tappable;
            // sessionActive returns to false. Try-Again restart leaves
            // sessionActive at false until the user engages with the new
            // round (the two onChange handlers above re-flip it).
            if finished { sessionActive = false }
            // F6: record the session outcome to ProgressManager, exactly once.
            if finished && !sessionRecorded {
                sessionRecorded = true
                ProgressManager.shared.recordReadingTestSession(passed: session.sessionPassed)
            }
        }
        // C2: after the OS permission prompt resolves, if a mic tap was pending,
        // auto-start so the user doesn't have to tap the mic a second time.
        .onChange(of: voice.authorizationStatus) { status in
            guard pendingAutoStart else { return }
            pendingAutoStart = false
            switch status {
            case .authorized:
                showEmptyWarning = false
                voice.start(localeCode: "en-US")
            case .denied:
                micDenied = true
            case .restricted:
                // F3: recognizer unavailable — different message than mic-permission.
                speechUnavailable = true
            default:
                break
            }
        }
        .alert(s.testModeMicPermission, isPresented: $micDenied) {
            Button(s.resultDone, role: .cancel) { }
        }
        .alert(s.testModeSpeechUnavailable, isPresented: $speechUnavailable) {
            Button(s.resultDone, role: .cancel) { }
        }
    }

    // MARK: - Reading prompt (the main flow)

    private var readingPrompt: some View {
        VStack(spacing: 20) {
            // Progress header
            HStack {
                Text(String(format: s.testModeSentenceOfFormat,
                            session.currentIndex + 1,
                            session.attempts.count))
                    .font(.subheadline.bold())
                    .foregroundColor(.cyan)
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

            // Sentence card
            Text(session.currentSentence)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.vertical, 28)
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 18).fill(Color.white.opacity(0.08)))
                .padding(.horizontal, 20)

            // Live transcription (only while / after recording)
            if !voice.transcription.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text(s.testModeWeHeard)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                    Text(voice.transcription)
                        .font(.body)
                        .foregroundColor(.yellow)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
            }

            Spacer()

            // Instructions / mic button
            VStack(spacing: 12) {
                // C3: if the user tapped Done without speaking, surface a gentle
                // retry message in warm orange instead of the usual white prompt.
                if showEmptyWarning && !voice.isRecording {
                    Label(s.testModeNoSpeechHeard, systemImage: "ear.trianglebadge.exclamationmark")
                        .font(.subheadline.bold())
                        .foregroundColor(.orange)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                } else {
                    Text(voice.isRecording ? s.testModeRecording : s.testModeTapToStart)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }

                Button {
                    toggleMic()
                } label: {
                    Image(systemName: voice.isRecording ? "stop.fill" : "mic.fill")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 76, height: 76)
                        .background(
                            Circle().fill(voice.isRecording ? Color.red : Color.blue)
                        )
                        .overlay(Circle().stroke(Color.white.opacity(0.25), lineWidth: 2))
                }
                .accessibilityLabel(voice.isRecording ? s.a11yStopRecording : s.a11yStartRecording)

                if voice.isRecording {
                    Button(s.testModeStopBtn) {
                        finishSentence()
                    }
                    .font(.headline.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 24).padding(.vertical, 10)
                    .background(Capsule().fill(Color.red.opacity(0.85)))
                }
            }
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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

            // Colored expected sentence (same renderer as Writing)
            VStack(spacing: 6) {
                Text(s.writingCorrectAnswerLabel)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
                highlightedDiff(diff)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }

            // What the STT actually heard
            VStack(spacing: 6) {
                Text(s.testModeWeHeard)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
                Text(voice.transcription.isEmpty ? "—" : voice.transcription)
                    .font(.body)
                    .foregroundColor(.yellow)
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
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.04))
                    )
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

    private func toggleMic() {
        if voice.isRecording {
            finishSentence()
            return
        }
        switch voice.authorizationStatus {
        case .authorized:
            showEmptyWarning = false
            voice.start(localeCode: "en-US")
        case .notDetermined:
            // C2: flag the tap so `onChange(of: voice.authorizationStatus)` can
            // auto-start recording once the user responds to the OS prompt.
            pendingAutoStart = true
            voice.requestAuthorization()
        case .restricted:
            // F3: recognizer itself isn't available; different from mic denial.
            speechUnavailable = true
        default:
            micDenied = true
        }
    }

    private func finishSentence() {
        voice.stop()
        let transcription = voice.transcription.trimmingCharacters(in: .whitespacesAndNewlines)
        // C3: empty transcription (user tapped Done without speaking) doesn't
        // cost them a sentence — show a gentle retry banner and stay on the same one.
        guard !transcription.isEmpty else {
            showEmptyWarning = true
            return
        }
        let diff = WritingDiffRenderer.diff(
            expected: session.currentSentence,
            input: transcription
        )
        let passed = diff.ratio >= WritingDiffRenderer.passThreshold(expectedTokenCount: diff.expectedTokens.count)
        session.recordAttempt(userAnswer: transcription, passed: passed)
        lastDiff = diff
    }

    private func advanceSession() {
        lastDiff = nil
        showEmptyWarning = false
        voice.clearTranscription()
        session.advance()
    }

    private func restartSession() {
        lastDiff = nil
        showEmptyWarning = false
        sessionRecorded = false  // F6: new session = new record on completion
        voice.clearTranscription()
        let words = TestSentencePicker.pick(
            from: pool,
            excludingRecent: ProgressManager.shared.recentReadingSentenceIDs
        )
        ProgressManager.shared.rememberReadingSentences(words.map { $0.id })
        session.restart(with: words.map { $0.exampleSentence })
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
