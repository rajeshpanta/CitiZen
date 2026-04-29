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

    /// True after the user has stopped speaking but before the Whisper
    /// transcript has arrived (the cloud-STT processing window). Mirrors
    /// `stt.isProcessingPublisher`. Views read this to flip status text
    /// from "Listening" to "Processing" so the user knows the app is
    /// thinking, not still waiting on them. Always false for synchronous
    /// services (LocalSTT) — protocol default returns `Just(false)`.
    @Published private(set) var isProcessingTranscript = false

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

    /// Max seconds the auto-advance feedback chain (speak feedback → delay
    /// → advance) is allowed to take before a watchdog force-advances.
    /// Set to 0 to disable. Audio-only uses 8s as a safety net against TTS
    /// publisher stalls. Mock Interview leaves it at 0 (it's intentionally
    /// tap-to-continue on wrong answers).
    var feedbackWatchdogTimeout: TimeInterval = 0

    /// Audio-only only: when true, an empty STT transcript triggers a
    /// "didn't hear you, try again" retry instead of dead-ending in `.idle`.
    /// After `emptySpokenRetryLimit` consecutive empty transcripts the
    /// question is marked wrong and the session advances. Mock Interview
    /// leaves this at false (its view shows a "didn't hear you" banner
    /// with manual mic-tap retry).
    var retryOnEmptySpoken = false
    var emptySpokenRetryLimit = 1

    // MARK: - Private

    private var ttsChain: AnyCancellable?
    private var delayTask: AnyCancellable?
    private var timeoutTask: AnyCancellable?
    /// Upper bound on recording duration once speech has actually started.
    /// Armed when the first non-empty STT partial arrives; cancelled by
    /// `stopAudio`. On fire, calls `stt.stopRecording()` (graceful — finalizes
    /// and uploads what was captured, unlike the original `listeningTimeout`
    /// which used `cancelRecording` and dropped the audio). Safety net for
    /// the case where SF can't detect end-of-speech (background noise,
    /// hesitation, mumbled trailing words) and would otherwise leave the
    /// mic open until SF's ~60 s internal cap. 8 s is comfortably above the
    /// longest realistic citizenship answer (~5 s) plus SF's ~1.5 s silence
    /// window — when SF detects silence first, this timer is irrelevant.
    private var speechMaxTask: AnyCancellable?
    /// Watchdog for the audio-only "speak feedback then advance" chain.
    /// If the chain (TTS → delay → advanceToNextQuestion) doesn't reach the
    /// advance call within `feedbackWatchdogTimeout` seconds, this fires and
    /// force-advances. Belt-and-suspenders against the prior silent-stall
    /// failure mode where TTS would not complete its publisher and the
    /// session sat in `.awaitingContinue` forever (back button quietly
    /// appeared after `phase` drifted to `.idle` via a stale binding).
    /// Only armed in the auto-advance + spoken-feedback configuration
    /// (audio-only). Mock Interview leaves it at zero — its wrong-answer
    /// flow is intentionally tap-to-continue.
    private var feedbackWatchdog: AnyCancellable?
    /// Counts consecutive listening attempts on the current question that
    /// returned no transcript (silence / inaudible). Reset on every
    /// successful match, on a non-empty transcript, on `replayQuestion`,
    /// and on `advanceToNextQuestion`. Used by audio-only's "didn't hear
    /// you, try again" retry path so the question only gets marked wrong
    /// after the second silence in a row.
    private var emptySpokenRetries: Int = 0
    /// In-flight `AnswerMatcher.match` Task. Held so `stopAudio` can cancel
    /// it when the user taps End / Back / Skip during the up-to-12 s GPT
    /// round-trip. The result is already discarded by a phase-mismatch
    /// guard inside the Task, so cancellation is mostly about not keeping
    /// the Task and its captures around longer than needed.
    private var matchingTask: Task<Void, Never>?
    private var subscribers = Set<AnyCancellable>()

    /// Set in the audio-interruption observer when an incoming call /
    /// Siri / FaceTime forces us to stop an active audio phase. Read on
    /// the matching `.ended` so we only auto-replay the question for
    /// users who were actually interrupted — not for users who happened
    /// to be idle (e.g., on the "didn't hear you" recovery banner) when
    /// the system posted an unrelated `.ended` (some interruption types
    /// fire `.ended` without a paired `.began` we acted on).
    private var wasInterruptedDuringActivePhase = false

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
    /// pending prewarm, and flips phase back to `.idle`.
    ///
    /// On `.ended`, when iOS hints `.shouldResume` AND we were the cause
    /// of the stop (i.e. `.began` interrupted us in an active audio
    /// phase), we auto-replay the current question in autoAdvance modes
    /// (Mock Interview / Audio-Only). Practice quizzes don't auto-resume
    /// — they have no "currently being read" question concept; the user
    /// taps the speaker button when they're ready. The
    /// `wasInterruptedDuringActivePhase` flag is what guarantees we
    /// don't misfire a replay for a user who happened to be idle when
    /// `.ended` arrived.
    private func observeAudioInterruptions() {
        NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)
            .receive(on: DispatchQueue.main)  // AVAudioSession posts off main
            .sink { [weak self] notification in
                guard let self,
                      let info = notification.userInfo,
                      let raw = info[AVAudioSessionInterruptionTypeKey] as? UInt,
                      let type = AVAudioSession.InterruptionType(rawValue: raw)
                else { return }

                switch type {
                case .began:
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
                        // Mark that we're the reason audio stopped, so the
                        // matching `.ended` knows to auto-replay. Set BEFORE
                        // `stop()` because `stop()` resets phase to `.idle`,
                        // which would otherwise look identical to "user was
                        // already idle" by the time `.ended` arrives.
                        self.wasInterruptedDuringActivePhase = true
                        self.stop()
                    case .idle, .awaitingContinue, .finished:
                        break
                    }
                case .ended:
                    // Only auto-resume if WE caused the stop. This guards
                    // against system-emitted `.ended` events for which we
                    // never saw a paired actionable `.began`.
                    guard self.wasInterruptedDuringActivePhase else { return }
                    self.wasInterruptedDuringActivePhase = false

                    // Honor iOS' `shouldResume` hint — when missing, the
                    // system is telling us the user is still busy (e.g.
                    // wrapping up a call) and resuming would step on
                    // them. Without this guard, mid-call `.ended` events
                    // would auto-replay the question over the call audio.
                    guard let optRaw = info[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
                    let opts = AVAudioSession.InterruptionOptions(rawValue: optRaw)
                    guard opts.contains(.shouldResume) else { return }

                    // Practice mode (autoAdvance == false) has no "current
                    // question being read" concept — the user explicitly
                    // tapped Listen, and re-arming after an interruption
                    // would feel surprising. Replay only auto-advance modes.
                    guard self.autoAdvance, !self.quizLogic.isFinished else { return }

                    // `replayQuestion` is the same path used by the
                    // Replay/Try-Again UI buttons — stops any residual
                    // audio (no-op, already stopped) and re-speaks the
                    // current question, which then auto-starts listening
                    // via the existing `onTTSFinished` flow.
                    self.replayQuestion()
                @unknown default:
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

    /// Drop any latent state that the interruption observer might use to
    /// auto-resume after `.ended`. Call from a view's `.onDisappear`
    /// (after `stop()`) so that an `.ended` notification arriving in
    /// the small window between view dismissal and StateObject
    /// deallocation can't trigger a `replayQuestion()` that would emit
    /// TTS into a screen the user has already left.
    ///
    /// Separate from `stop()` because the interruption handler itself
    /// calls `stop()` between `.began` and `.ended` — clearing the
    /// flag in `stop()` would prevent the legitimate auto-resume path.
    func cancelPendingInterruptionResume() {
        wasInterruptedDuringActivePhase = false
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
        emptySpokenRetries = 0
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
        emptySpokenRetries = 0
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
            listeningStartedAt = nil
            Analytics.track(.voiceTimeout(language: localeCode))

            // Audio-only retry path: the prior behavior (drop straight to
            // `.idle`) is what made the session feel dead — phase=.idle
            // unhid the back button and the user had no audio cue what
            // happened. With `retryOnEmptySpoken`, the controller speaks
            // a short "didn't hear you, try again" prompt and re-listens,
            // up to `emptySpokenRetryLimit` times. After the cap is hit,
            // we mark the question wrong (Int.max → standard wrong-answer
            // flow), which keeps the session moving instead of stalling.
            if retryOnEmptySpoken && autoAdvance {
                emptySpokenRetries += 1
                if emptySpokenRetries <= emptySpokenRetryLimit {
                    didTimeout = true
                    // Move to .processingAnswer for the duration of the
                    // "didn't hear you, try again" TTS so the view's
                    // phase-indicator reads "Processing…" instead of
                    // "Speak your answer." Without this transition the
                    // user would think they should speak over the prompt.
                    // Side benefit: `onTTSFinished` is guarded to
                    // .speakingQuestion, so being in .processingAnswer
                    // here keeps the bound subscriber from racing with
                    // our explicit `.sink` continuation below.
                    phase = .processingAnswer
                    let strings = UIStrings.forLocaleCode(localeCode)
                    ttsChain = tts.speak(strings.audioOnlyDidntHearTryAgain,
                                         languageCode: localeCode)
                        .flatMap { _ in
                            Just(()).delay(for: .seconds(0.3),
                                           scheduler: DispatchQueue.main)
                        }
                        .sink { [weak self] _ in
                            // Bail if the user tore down the session
                            // (voice.stop() flips phase to .idle) or
                            // the session naturally finished mid-TTS.
                            guard let self,
                                  self.phase == .processingAnswer
                            else { return }
                            self.didTimeout = false
                            self.autoStartListening()
                        }
                    return
                }
                // Cap exhausted — fall through to mark-wrong below so the
                // session keeps moving. The wrong-answer feedback chain
                // already speaks "the answer is X" and advances.
                didTimeout = true
                emptySpokenRetries = 0
                recordAnswer(Int.max, spokenText: nil)
                return
            }

            didTimeout = true
            phase = .idle
            return
        }
        emptySpokenRetries = 0

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
                if self.autoAdvance {
                    // The user spoke clearly enough for STT to produce a
                    // transcript (the empty case is filtered above), but
                    // the answer doesn't match any option — paraphrased
                    // nonsense, off-topic, or a genuinely wrong answer
                    // the matcher couldn't reconcile. Record it as a
                    // wrong attempt with `Int.max` (an out-of-range
                    // index that `UnifiedQuizLogic.answerQuestion` logs
                    // as `userAnswer = nil` while still incrementing the
                    // wrong counter and triggering the standard
                    // wrong-answer flow). Without this, mock interview
                    // and audio-only sat silently after a clearly-spoken
                    // wrong answer until the user tapped Skip — the user
                    // perception was "the app is waiting for the right
                    // answer." The transcription is already shown in the
                    // banner, so the user can see what was captured
                    // alongside the correct-answer reveal.
                    //
                    // `spokenText: spoken` propagates the heard text into
                    // the answer log so the result-screen review row can
                    // show "you answered: 'Lincoln'" instead of the
                    // misleading "no answer given" we'd otherwise get
                    // from a `userAnswer == nil` log entry.
                    self.recordAnswer(Int.max, spokenText: spoken)
                } else {
                    // Practice mode: keep the existing "didn't hear you"
                    // banner so the user can tap an option, retry voice,
                    // or replay. Auto-recording wrong here would conflict
                    // with practice's view-driven answer flow.
                    self.didTimeout = true
                    self.phase = .idle
                }
            }
        }
    }

    /// Record an answer on the current question, but don't advance yet.
    /// - Correct: auto-advance after a short delay.
    /// - Wrong: stay on the question so the view can show the correct answer; the view
    ///   must call `continueAfterWrong()` to proceed.
    ///
    /// `spokenText` is forwarded to the quiz log only on the voice-no-match
    /// path (where `answerIndex` is `Int.max` and we want the review screen
    /// to show what the user said). All other callers omit it.
    private func recordAnswer(_ answerIndex: Int, spokenText: String? = nil) {
        stopAudio()

        // Snapshot data about the CURRENT question before mutating state.
        let answeredQuestion = quizLogic.currentQuestion
        lastAnswerExplanation = answeredQuestion.variants.first?.explanation ?? ""
        lastCorrectIndex = answeredQuestion.correctAnswer
        let correctOptionText = currentVariant().options[safe: answeredQuestion.correctAnswer] ?? ""

        let correct = quizLogic.answerQuestion(answerIndex, userSpokenText: spokenText)
        lastAnswerCorrect = correct

        if quizLogic.isFinished {
            phase = .finished
            return
        }

        phase = .awaitingContinue
        // Audio-only safety net: if the feedback chain stalls (TTS publisher
        // never completes, network hiccup, etc.), this watchdog force-advances
        // the session instead of leaving the user staring at a silent screen.
        // Mock Interview's tap-to-continue path leaves `feedbackWatchdogTimeout`
        // at 0 so this is a no-op there. See `armFeedbackWatchdog`.
        armFeedbackWatchdog()

        let strings = UIStrings.forLocaleCode(localeCode)

        if correct {
            // Auto-advance after short pause. Audio-only reinforces the
            // option text alongside the "Correct" affirmation — the user
            // is hands-free, often eyes-off, and hearing the answer they
            // just got right is a small but real study reinforcement
            // (mirrors how the wrong-answer branch already recites it).
            if speakAnswerFeedback {
                let phrase = String(format: strings.audioFeedbackCorrectAnswerIsFormat,
                                    correctOptionText)
                ttsChain = tts.speak(phrase, languageCode: localeCode)
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
        feedbackWatchdog?.cancel(); feedbackWatchdog = nil
        emptySpokenRetries = 0
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

    /// Arm the audio-only feedback watchdog. If `feedbackWatchdogTimeout`
    /// elapses while we're still in `.awaitingContinue`, force-advance.
    /// This is the safety net for the prior failure mode where the wrong-
    /// answer TTS chain didn't complete its publisher and the session
    /// stalled silently. No-op when timeout is 0 (mock interview path).
    private func armFeedbackWatchdog() {
        feedbackWatchdog?.cancel(); feedbackWatchdog = nil
        guard feedbackWatchdogTimeout > 0 else { return }
        feedbackWatchdog = Just(())
            .delay(for: .seconds(feedbackWatchdogTimeout), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self, self.phase == .awaitingContinue else { return }
                // Don't fire if a tap-to-continue (Mock Interview) is the
                // intended UX. `feedbackWatchdogTimeout > 0` already gates
                // this, but `requireContinueOnWrong` is the semantic source
                // of truth — guard explicitly so a future config tweak
                // can't accidentally auto-skip a Mock Interview question.
                guard !self.requireContinueOnWrong else { return }
                self.advanceToNextQuestion()
            }
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
                self.listeningStartedAt = nil

                // Audio-only is hands-free, so dropping to `.idle` (which
                // hides the mic and forces a tap to retry) breaks the
                // mode's promise. Instead, replay the question once and
                // re-listen; on a second silence, log it as missed and
                // move on with a brief "Moving on" cue so the user
                // (likely away from the device) knows the session is
                // still alive. Gated by `retryOnEmptySpoken && autoAdvance`
                // so Mock Interview and Practice keep their existing
                // tap-to-retry behavior.
                if self.retryOnEmptySpoken && self.autoAdvance {
                    self.handleSilentTimeout()
                    return
                }

                self.didTimeout = true
                self.phase = .idle
            }
    }

    /// Audio-only handling for total-silence timeout.
    ///
    /// First silence on a question replays the question to give the user
    /// another shot. Second silence skips with a short "Moving on"
    /// announcement and records the question as missed (Int.max →
    /// `userAnswer = nil` in the answer log, surfaced as "no answer
    /// captured" in the post-session Review Missed sheet).
    ///
    /// Shares the `emptySpokenRetries` counter with the post-Whisper
    /// empty-transcript path — both are "no usable answer captured"
    /// cases from the user's POV, so a silence followed by a mumble (or
    /// vice-versa) correctly counts as two attempts rather than one of
    /// each.
    private func handleSilentTimeout() {
        emptySpokenRetries += 1
        if emptySpokenRetries <= emptySpokenRetryLimit {
            // Replay path. `.processingAnswer` while the question
            // re-reads keeps the view's status text on "Processing…"
            // instead of "Speak your answer," which would invite the
            // user to talk over the replay.
            didTimeout = false
            let text = currentVariant().text
            guard !text.isEmpty else {
                // Defensive: empty question shouldn't happen, but if
                // it does, fall through to the legacy idle behavior
                // rather than speaking nothing and hanging.
                emptySpokenRetries = 0
                didTimeout = true
                phase = .idle
                return
            }
            phase = .processingAnswer
            ttsChain = tts.speak(text, languageCode: localeCode)
                .flatMap { _ in
                    Just(()).delay(for: .seconds(0.3),
                                   scheduler: DispatchQueue.main)
                }
                .sink { [weak self] _ in
                    guard let self, self.phase == .processingAnswer else { return }
                    self.autoStartListening()
                }
            return
        }

        // Cap exhausted — mark missed, announce "Moving on", advance.
        emptySpokenRetries = 0
        didTimeout = false
        _ = quizLogic.answerQuestion(Int.max)
        if quizLogic.isFinished {
            phase = .finished
            return
        }
        phase = .processingAnswer
        let strings = UIStrings.forLocaleCode(localeCode)
        ttsChain = tts.speak(strings.audioOnlyMovingOn, languageCode: localeCode)
            .flatMap { _ in
                Just(()).delay(for: .seconds(0.3),
                               scheduler: DispatchQueue.main)
            }
            .sink { [weak self] _ in self?.advanceToNextQuestion() }
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
        speechMaxTask?.cancel(); speechMaxTask = nil
        matchingTask?.cancel(); matchingTask = nil
        // Cancel the audio-only watchdog too — otherwise tearing down via
        // End/Back/Skip could leave a pending advance fire on a session
        // the user has already left.
        feedbackWatchdog?.cancel(); feedbackWatchdog = nil
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
                // Once any non-empty partial arrives, the user has clearly
                // spoken — cancel the listening timeout so a slow Whisper
                // upload can't get aborted mid-flight at the 10s mark. The
                // upload doesn't release `rec` (and therefore doesn't move
                // phase out of `.listening`) until the cloud round-trip
                // returns, so for wrong answers — which skip the SF
                // early-exit path — total time (speech + 1.5s silence +
                // 3–5s Whisper) routinely exceeded `listeningTimeout`.
                // When that fired, `cancelRecording()` killed the in-flight
                // upload and phase dropped to `.idle` with no transcript
                // ever delivered, leaving the session stalled silently.
                if !text.isEmpty, self.phase == .listening {
                    self.timeoutTask?.cancel()
                    self.timeoutTask = nil
                    // Arm the max-speech-duration safety net once. If SF
                    // never decides the user stopped (noise, hesitation),
                    // graceful-stop after 8 s so Whisper still gets the
                    // audio and the answer flow keeps moving instead of
                    // hanging the mic indefinitely. Gated to autoAdvance
                    // (audio-only, mock interview) — practice mode is
                    // user-driven (tap mic, tap again to stop) and a
                    // hard cap could cut off a user who pauses mid-answer
                    // to think.
                    if self.autoAdvance, self.speechMaxTask == nil {
                        self.speechMaxTask = Just(())
                            .delay(for: .seconds(8), scheduler: DispatchQueue.main)
                            .sink { [weak self] _ in
                                guard let self, self.phase == .listening else { return }
                                self.speechMaxTask = nil
                                self.stt.stopRecording()
                            }
                    }
                }
            }
            .store(in: &subscribers)

        stt.authorizationStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.authorizationStatus = status
            }
            .store(in: &subscribers)

        stt.isProcessingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] processing in
                self?.isProcessingTranscript = processing
            }
            .store(in: &subscribers)
    }
}
