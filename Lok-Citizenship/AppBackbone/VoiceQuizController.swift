import Foundation
import Combine
import AVFoundation
import Speech

// ═════════════════════════════════════════════════════════════════
// MARK: - Voice Flow Phase
// ═════════════════════════════════════════════════════════════════

enum VoiceFlowPhase: Equatable {
    case idle              // not started or between sessions
    case speakingQuestion  // TTS reading (question, or question+options chain)
    case listening         // STT recording user's answer
    case matching          // STT stopped; evaluating transcription (may include GPT round-trip)
    case awaitingContinue  // answer recorded; waiting (auto for correct, manual for wrong)
    case processingAnswer  // generic "moving to next" state
    case finished          // quiz ended
}

// ═════════════════════════════════════════════════════════════════
// MARK: - Voice Quiz Controller
// ═════════════════════════════════════════════════════════════════

/// Orchestrates TTS and STT for any quiz mode.
///
/// Two usage patterns:
///
/// **Auto-advance mode** (mock interview):
///   Controller drives the full cycle: speak → listen → evaluate → answer → advance → repeat.
///   Set `autoAdvance = true` (default).
///
/// **Manual mode** (practice):
///   View drives the flow. Call `speakSequence()` and `startManualListening()` explicitly.
///   On voice match, controller sets `matchedAnswerIndex` without touching quiz logic.
///   Set `autoAdvance = false`.
///
/// `@MainActor` because every consumer is a SwiftUI view; the controller
/// reads `@MainActor`-isolated `UnifiedQuizLogic` state, mutates `@Published`
/// state that SwiftUI requires from main, and already routes every Combine
/// publisher through `receive(on: DispatchQueue.main)`. Annotating the class
/// makes that already-main-only contract explicit so Swift 6 strict
/// concurrency doesn't flag the cross-isolation calls into the quiz logic.
@MainActor
final class VoiceQuizController: ObservableObject {

    // MARK: - Published state

    @Published private(set) var phase: VoiceFlowPhase = .idle
    @Published private(set) var transcription = ""
    @Published private(set) var lastAnswerCorrect: Bool?
    @Published private(set) var lastAnswerExplanation: String = ""
    @Published private(set) var lastCorrectIndex: Int?
    @Published private(set) var isRecording = false

    /// True whenever the controller intends to be producing audio — either
    /// because the underlying TTS engine is currently emitting samples, or
    /// because we're between clips of a `speakSequence` (the post-question
    /// pause before options are read).
    ///
    /// The two-source design (`ttsCurrentlyPlaying || inSpeechChain`) is the
    /// fix for the QuizView speaker-button flicker: if we mirrored only the
    /// per-utterance signal from `tts.isSpeakingPublisher`, the button would
    /// flip "Stop"→"Listen"→"Stop" every time the chain crossed an
    /// inter-clip delay, and a tap during the gap would *restart* the
    /// sequence instead of stopping it (the action branched on the icon
    /// label). With the chain flag, the icon stays "Stop" for the whole
    /// sequence and a tap reliably halts playback.
    @Published private(set) var isSpeaking = false

    /// Mirrors `tts.isSpeakingPublisher` — true exactly while a single TTS
    /// clip is producing audio. Drives `onTTSFinished` (auto-advance to
    /// listening) on the true→false transition.
    private var ttsCurrentlyPlaying = false

    /// True from `speakSequence` start through the final `.sink` of its
    /// publisher chain. Cleared on `stopAudio` so an interrupted sequence
    /// flips `isSpeaking` to false synchronously.
    private var inSpeechChain = false

    @Published var authorizationStatus: SFSpeechRecognizerAuthorizationStatus = .notDetermined

    /// True if the last listening session ended without a recognized answer (silence/timeout).
    /// View should show a "didn't hear you" banner. Reset on next listen / new question.
    @Published private(set) var didTimeout = false

    /// Timestamp when listening started. View uses this to animate a countdown bar.
    @Published private(set) var listeningStartedAt: Date?

    /// Set when a voice match is found in manual mode. View reads this to handle the answer.
    /// Cleared on `resetMatch()` or when a new question starts speaking.
    @Published private(set) var matchedAnswerIndex: Int?

    // MARK: - Dependencies

    let quizLogic: UnifiedQuizLogic
    private let tts: TextToSpeechService
    private let stt: SpeechToTextService

    // MARK: - Configuration

    /// When true, controller drives the full cycle (mock interview).
    /// When false, controller only handles TTS/STT — view handles answer flow (practice).
    var autoAdvance = true

    /// Delay between TTS finishing and mic auto-starting. Only used in autoAdvance mode.
    var postSpeakDelay: TimeInterval = 0.3

    /// Delay between answer feedback and next question TTS. Only used in autoAdvance mode.
    var postAnswerDelay: TimeInterval = 1.0

    /// Locale for TTS/STT.
    var localeCode = "en-US"

    /// Whether STT should prefer on-device recognition.
    var offlineSTT = true

    /// Which variant index to read question text from.
    var variantIndex = 0

    /// Max seconds to wait for a voice answer before timing out.
    /// Set to 0 to disable timeout. Default 10s.
    var listeningTimeout: TimeInterval = 10

    /// When true, TTS speaks "Correct" or "The answer is X" before advancing.
    /// Used in audio-only mode for hands-free feedback.
    var speakAnswerFeedback = false

    /// When true (mock interview), wrong answers hold at `.awaitingContinue` until the view
    /// calls `continueAfterWrong()`. When false (audio-only), wrong answers auto-advance.
    var requireContinueOnWrong = false

    // MARK: - Private

    private var ttsChain: AnyCancellable?
    private var delayTask: AnyCancellable?
    private var timeoutTask: AnyCancellable?
    /// In-flight `AnswerMatcher.match` Task. Held so `stopAudio` can cancel
    /// it when the user taps End / Back / Skip during the up-to-12 s GPT
    /// round-trip. The result is already discarded by a phase-mismatch
    /// guard inside the Task, so cancellation is mostly about not keeping
    /// the Task and its captures around longer than needed.
    private var matchingTask: Task<Void, Never>?
    private var subscribers = Set<AnyCancellable>()

    // MARK: - Init

    init(quizLogic: UnifiedQuizLogic,
         tts: TextToSpeechService = ServiceLocator.shared.ttsService,
         stt: SpeechToTextService = ServiceLocator.shared.sttService) {
        self.quizLogic = quizLogic
        self.tts = tts
        self.stt = stt
        bindPublishers()
        observeAudioInterruptions()
    }

    /// Listen for `AVAudioSession.interruptionNotification` so an incoming
    /// phone call / Siri / FaceTime / alarm cleanly halts the quiz instead
    /// of leaving the controller stuck in `.listening` or `.speakingQuestion`
    /// with a dead audio engine. Without this, the user returns from the
    /// call to a screen that *looks* recording but captures nothing —
    /// every question dead-ends at the 10 s timeout.
    ///
    /// On `.began` we call `stop()`, which kills TTS, cancels STT, drops any
    /// pending prewarm, and flips phase back to `.idle`. The user resumes
    /// by tapping the existing Replay or mic button — we deliberately do
    /// NOT auto-resume on `.ended` because iOS' `shouldResume` hint is
    /// meant for media players, and auto-replaying a question while the
    /// user is still wrapping up a call is worse UX than letting them
    /// re-engage manually.
    private func observeAudioInterruptions() {
        NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)
            .receive(on: DispatchQueue.main)  // AVAudioSession posts off main
            .sink { [weak self] notification in
                guard let self,
                      let info = notification.userInfo,
                      let raw = info[AVAudioSessionInterruptionTypeKey] as? UInt,
                      let type = AVAudioSession.InterruptionType(rawValue: raw)
                else { return }

                guard type == .began else {
                    // .ended: intentionally no-op. iOS' shouldResume hint is
                    // for media players — auto-replaying a question while
                    // the user is still wrapping up the call is worse UX
                    // than letting them tap Replay/Mic when ready.
                    return
                }

                // Always drop a pending prewarm on `.began`, even in
                // phases that don't need a full `stop()`. Otherwise a
                // call ringing during the 200 ms duck-settle window
                // after a Start/Try-Again tap would still let the
                // continuation fire and try to TTS into an interrupted
                // session — silent failure that leaves the user
                // looking at a "started" interview with no audio.
                AudioSessionPrewarmer.cancel()

                // Only intervene in phases where audio is actually live.
                // `.awaitingContinue` already has nothing playing (TTS
                // finished, STT idle, GPT result already arrived) — and
                // forcing it to `.idle` would erase the "Next Question"
                // CTA and re-enable the fallback options, letting the
                // user accidentally re-answer the same question.
                // `.idle` / `.finished` have nothing to stop either.
                switch self.phase {
                case .speakingQuestion, .listening, .matching, .processingAnswer:
                    self.stop()
                case .idle, .awaitingContinue, .finished:
                    break
                }
            }
            .store(in: &subscribers)
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: - Public API (both modes)
    // ═════════════════════════════════════════════════════════════

    /// Request mic + speech authorization. Call once on view appear.
    func requestAuthorization() {
        stt.requestAuthorization()
    }

    /// Stop all audio and reset to idle.
    func stop() {
        // `stopAudio()` already cancels any pending prewarm continuation,
        // so we don't need a second `AudioSessionPrewarmer.cancel()` here.
        stopAudio()
        phase = .idle
    }

    /// Clear the matched answer index after the view has processed it.
    func resetMatch() {
        matchedAnswerIndex = nil
    }

    /// Clear the displayed transcription. Views call this when advancing to a new
    /// question so the previous answer's text doesn't linger in the mic panel.
    func clearTranscription() {
        transcription = ""
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: - Auto-advance API (mock interview)
    // ═════════════════════════════════════════════════════════════

    /// Begin the auto-advance voice flow: speak current question, listen, evaluate, advance.
    func start() {
        speakCurrentQuestion()
    }

    /// Submit a tap answer in auto-advance mode (fallback buttons).
    func submitTapAnswer(_ answerIndex: Int) {
        guard autoAdvance else { return }
        guard phase != .processingAnswer, phase != .speakingQuestion, phase != .awaitingContinue else { return }
        stopAudio()
        recordAnswer(answerIndex)
    }

    /// Replay the current question's TTS. Can be called during listening or after a timeout.
    func replayQuestion() {
        guard autoAdvance else { return }
        stopAudio()
        didTimeout = false
        speakCurrentQuestion()
    }

    /// Skip the current question (counts as wrong/unanswered). Used when user can't / won't answer.
    func skipCurrent() {
        guard autoAdvance else { return }
        stopAudio()
        recordAnswer(Int.max)
    }

    /// After a wrong answer, the view calls this when the user taps "Next Question".
    func continueAfterWrong() {
        advanceToNextQuestion()
    }

    /// Reset for a new auto-advance session (e.g. "Try Again").
    func restart() {
        stopAudio()
        lastAnswerCorrect = nil
        lastAnswerExplanation = ""
        lastCorrectIndex = nil
        didTimeout = false
        transcription = ""
        matchedAnswerIndex = nil
        speakCurrentQuestion()
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: - Manual API (practice mode)
    // ═════════════════════════════════════════════════════════════

    /// Speak a sequence of texts with delays between them (e.g. question + options).
    /// Used by the speaker button in practice mode.
    func speakSequence(_ items: [(text: String, delay: TimeInterval)]) {
        stopAudio()
        phase = .speakingQuestion
        inSpeechChain = true
        updateIsSpeaking()
        Analytics.track(.voiceUsed(feature: "tts", language: localeCode))
        guard let first = items.first else {
            inSpeechChain = false
            updateIsSpeaking()
            return
        }

        var chain: AnyPublisher<Void, Never> = tts
            .speak(first.text, languageCode: localeCode)
            .flatMap { _ in Just(()).delay(for: .seconds(first.delay),
                                          scheduler: DispatchQueue.main) }
            .eraseToAnyPublisher()

        for item in items.dropFirst() {
            chain = chain
                .flatMap { [tts, localeCode] in tts.speak(item.text, languageCode: localeCode) }
                .flatMap { _ in Just(()).delay(for: .seconds(item.delay),
                                              scheduler: DispatchQueue.main) }
                .eraseToAnyPublisher()
        }

        ttsChain = chain.sink { [weak self] _ in
            self?.phase = .idle
            self?.inSpeechChain = false
            self?.updateIsSpeaking()
        }
    }

    /// Start listening for a voice answer. Used by the mic button in practice mode.
    func startManualListening() {
        stopAudio()
        // Clear any stale transcription from a previous question before the
        // mic panel opens — otherwise old text shows until the new STT result
        // arrives (visible even after the user has tapped Next).
        transcription = ""
        phase = .listening
        let options = currentVariant().options
        stt.startRecording(
            withOptions: options,
            localeCode: localeCode,
            offlineOnly: offlineSTT
        )
        startListeningTimer()
    }

    /// Toggle mic on/off. Works in both modes.
    func toggleMic() {
        if isRecording {
            stt.stopRecording()
        } else if phase == .listening || phase == .idle {
            didTimeout = false
            if autoAdvance {
                autoStartListening()
            } else {
                startManualListening()
            }
        }
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: - Auto-advance Flow (private)
    // ═════════════════════════════════════════════════════════════

    private func speakCurrentQuestion() {
        phase = .speakingQuestion
        transcription = ""
        lastAnswerCorrect = nil
        lastAnswerExplanation = ""
        lastCorrectIndex = nil
        matchedAnswerIndex = nil
        didTimeout = false

        let text = currentVariant().text
        guard !text.isEmpty else { return }

        ttsChain = tts.speak(text, languageCode: localeCode)
            .sink { _ in }
        // Transition to .listening happens in onTTSFinished()
    }

    private func onTTSFinished() {
        guard phase == .speakingQuestion else { return }

        // In manual mode, just go idle after speaking finishes
        guard autoAdvance else {
            phase = .idle
            return
        }

        guard !quizLogic.isFinished else {
            phase = .finished
            return
        }

        delayTask = Just(())
            .delay(for: .seconds(postSpeakDelay), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.autoStartListening()
            }
    }

    private func autoStartListening() {
        guard !quizLogic.isFinished else {
            phase = .finished
            return
        }
        // Clear any stale transcription from the previous question before the
        // new listen starts (mock-interview auto-advance path).
        transcription = ""
        phase = .listening
        listeningStartedAt = Date()
        didTimeout = false
        let options = currentVariant().options
        stt.startRecording(
            withOptions: options,
            localeCode: localeCode,
            offlineOnly: offlineSTT
        )
        startListeningTimer()
        Analytics.track(.voiceUsed(feature: "stt", language: localeCode))
    }

    private func onSTTFinished() {
        guard phase == .listening else { return }
        evaluateTranscription()
    }

    private func evaluateTranscription() {
        let spoken = transcription
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !spoken.isEmpty else {
            // STT auto-stopped (silence/error) or user manually tapped mic to
            // stop, but no audible speech was captured. Surface the
            // "didn't hear" state immediately rather than letting the user
            // wait up to `listeningTimeout` more seconds for the timer to
            // fire. Recording is already stopped at this point (rec.send(false)
            // was emitted before this method ran), so there's no race with
            // an in-flight capture.
            timeoutTask?.cancel()
            timeoutTask = nil
            didTimeout = true
            listeningStartedAt = nil
            phase = .idle
            Analytics.track(.voiceTimeout(language: localeCode))
            return
        }

        phase = .matching
        let options = currentVariant().options
        let question = currentVariant().text

        matchingTask?.cancel()
        // `@MainActor` on the Task body keeps result-handling on main without
        // a nested `MainActor.run`. The previous structure (`Task { [weak
        // self] in ... await MainActor.run { guard let self ... } }`) made
        // the `MainActor.run` closure capture the outer `weak var self`,
        // which Swift 6 strict concurrency flags as "reference to captured
        // var 'self' in concurrently-executing code." With `@MainActor` on
        // the outer Task, the strong-bound `self` from `guard let` lives
        // entirely on the main actor — no inner closure capture, no
        // diagnostic. `await AnswerMatcher.match` still suspends the actor
        // off-main for the network round-trip, so this isn't a behavior
        // change for the user.
        matchingTask = Task { @MainActor [weak self] in
            let match = await AnswerMatcher.match(spoken: spoken, options: options, question: question)
            guard let self, self.phase == .matching else { return }
            if let idx = match {
                if self.autoAdvance {
                    self.recordAnswer(idx)
                } else {
                    self.stopAudio()
                    self.matchedAnswerIndex = idx
                    self.phase = .idle
                }
            } else {
                Analytics.track(.voiceMatchFailed(language: self.localeCode))
                self.didTimeout = true  // show "didn't hear you" banner
                self.phase = .idle
            }
        }
    }

    /// Record an answer on the current question, but don't advance yet.
    /// - Correct: auto-advance after a short delay.
    /// - Wrong: stay on the question so the view can show the correct answer; the view
    ///   must call `continueAfterWrong()` to proceed.
    private func recordAnswer(_ answerIndex: Int) {
        stopAudio()

        // Snapshot data about the CURRENT question before mutating state.
        let answeredQuestion = quizLogic.currentQuestion
        lastAnswerExplanation = answeredQuestion.variants.first?.explanation ?? ""
        lastCorrectIndex = answeredQuestion.correctAnswer
        let correctOptionText = currentVariant().options[safe: answeredQuestion.correctAnswer] ?? ""

        let correct = quizLogic.answerQuestion(answerIndex)
        lastAnswerCorrect = correct

        if quizLogic.isFinished {
            phase = .finished
            return
        }

        phase = .awaitingContinue

        let strings = UIStrings.forLocaleCode(localeCode)

        if correct {
            // Auto-advance after short pause.
            if speakAnswerFeedback {
                ttsChain = tts.speak(strings.audioFeedbackCorrect, languageCode: localeCode)
                    .flatMap { [weak self] _ -> AnyPublisher<Void, Never> in
                        guard let self else { return Just(()).eraseToAnyPublisher() }
                        return Just(()).delay(for: .seconds(self.postAnswerDelay),
                                              scheduler: DispatchQueue.main)
                            .eraseToAnyPublisher()
                    }
                    .sink { [weak self] _ in self?.advanceToNextQuestion() }
            } else {
                delayTask = Just(())
                    .delay(for: .seconds(postAnswerDelay), scheduler: DispatchQueue.main)
                    .sink { [weak self] _ in self?.advanceToNextQuestion() }
            }
        } else {
            // Wrong branch: either hold for tap-to-continue (mock interview) or
            // auto-advance after spoken feedback (audio-only).
            let wrongPhrase = String(format: strings.audioFeedbackTheAnswerIsFormat, correctOptionText)
            if requireContinueOnWrong {
                if speakAnswerFeedback {
                    ttsChain = tts.speak(wrongPhrase, languageCode: localeCode)
                        .sink { _ in }
                }
            } else if speakAnswerFeedback {
                ttsChain = tts.speak(wrongPhrase, languageCode: localeCode)
                    .flatMap { [weak self] _ -> AnyPublisher<Void, Never> in
                        guard let self else { return Just(()).eraseToAnyPublisher() }
                        return Just(()).delay(for: .seconds(self.postAnswerDelay),
                                              scheduler: DispatchQueue.main)
                            .eraseToAnyPublisher()
                    }
                    .sink { [weak self] _ in self?.advanceToNextQuestion() }
            } else {
                delayTask = Just(())
                    .delay(for: .seconds(postAnswerDelay), scheduler: DispatchQueue.main)
                    .sink { [weak self] _ in self?.advanceToNextQuestion() }
            }
        }
    }

    /// Move to the next question and speak it.
    private func advanceToNextQuestion() {
        guard !quizLogic.isFinished else {
            phase = .finished
            return
        }
        quizLogic.moveToNextQuestion()
        if quizLogic.isFinished {
            phase = .finished
            return
        }
        phase = .processingAnswer
        speakCurrentQuestion()
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: - Helpers
    // ═════════════════════════════════════════════════════════════

    private func currentVariant() -> UnifiedQuestion.Variant {
        let q = quizLogic.currentQuestion
        let idx = min(variantIndex, q.variants.count - 1)
        return q.variants[max(idx, 0)]
    }

    /// Start a timer that fires if no valid answer is captured within `listeningTimeout`.
    /// On timeout, we stop recording and surface `didTimeout = true` to the view so it can
    /// show a "didn't hear you" banner. We do NOT auto-mark the question as wrong —
    /// user picks whether to retry (tap replay/mic) or skip.
    private func startListeningTimer() {
        timeoutTask?.cancel()
        guard listeningTimeout > 0 else { return }
        timeoutTask = Just(())
            .delay(for: .seconds(listeningTimeout), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self, self.phase == .listening else { return }
                Analytics.track(.voiceTimeout(language: self.localeCode))
                // 10s of silence — there's nothing useful to send to Whisper.
                // cancelRecording skips the upload (saves a network round-trip
                // we'd just throw away) and tears down state immediately.
                self.stt.cancelRecording()
                self.didTimeout = true
                self.listeningStartedAt = nil
                self.phase = .idle
            }
    }

    private func stopAudio() {
        // Drop any pending `AudioSessionPrewarmer` continuation. Every caller
        // of `stopAudio` (stop, replayQuestion, restart, startManualListening,
        // submitTapAnswer, skipCurrent, recordAnswer, evaluateTranscription's
        // match-success branch, speakSequence's preamble) is starting a fresh
        // audio cycle or tearing the session down — none of them want a
        // 200 ms-old "speak the question" continuation to fire after the new
        // intent has already taken effect. Previously this was only
        // cancelled inside `stop()`, so a Listen-tap immediately followed by
        // a mic-tap let the queued continuation kill the live mic recording
        // mid-sentence (the prewarm fired into `speakSequence` → `stopAudio`
        // → `stt.cancelRecording()`).
        AudioSessionPrewarmer.cancel()

        ttsChain?.cancel(); ttsChain = nil
        delayTask?.cancel(); delayTask = nil
        timeoutTask?.cancel(); timeoutTask = nil
        matchingTask?.cancel(); matchingTask = nil
        tts.stopSpeaking()
        // cancelRecording (not stopRecording) — every caller of stopAudio is a
        // "throw away the recording" path: End, Back, replay, skip, tap-answer,
        // restart, or recordAnswer (after we've already evaluated). None of
        // them want a Whisper upload of stale mic audio. Default protocol impl
        // falls through to stopRecording for non-Whisper services.
        stt.cancelRecording()

        // Clear chain + per-utterance flags synchronously so `isSpeaking`
        // flips false immediately on End/Back/option-tap. The async sink on
        // `tts.isSpeakingPublisher` will fire a moment later with
        // `speaking=false`; pre-clearing `ttsCurrentlyPlaying` here makes
        // its `wasPlaying && !speaking` check return false, which prevents a
        // spurious `onTTSFinished` from advancing state we just tore down.
        inSpeechChain = false
        ttsCurrentlyPlaying = false
        updateIsSpeaking()
    }

    /// Recompute the public `isSpeaking` from its two backing flags. Only
    /// emits a change when the composite actually flips, so SwiftUI doesn't
    /// invalidate views on every `tts.isSpeakingPublisher` tick.
    private func updateIsSpeaking() {
        let new = ttsCurrentlyPlaying || inSpeechChain
        if new != isSpeaking { isSpeaking = new }
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: - Combine Bindings
    // ═════════════════════════════════════════════════════════════

    private func bindPublishers() {
        tts.isSpeakingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] speaking in
                guard let self else { return }
                let wasPlaying = self.ttsCurrentlyPlaying
                self.ttsCurrentlyPlaying = speaking
                self.updateIsSpeaking()
                if wasPlaying && !speaking {
                    self.onTTSFinished()
                }
            }
            .store(in: &subscribers)

        stt.isRecordingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] recording in
                guard let self else { return }
                let wasRecording = self.isRecording
                self.isRecording = recording
                if wasRecording && !recording {
                    self.onSTTFinished()
                }
            }
            .store(in: &subscribers)

        stt.transcriptionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                guard let self else { return }
                // Drop late STT callbacks that fire after listening has ended
                // (SFSpeechRecognizer can emit a final result via endAudio()
                // even after stopRecording has been called — without this guard
                // stale transcription reappears on the next question).
                guard self.phase == .listening || self.phase == .matching else { return }
                self.transcription = text
            }
            .store(in: &subscribers)

        stt.authorizationStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.authorizationStatus = status
            }
            .store(in: &subscribers)
    }
}
