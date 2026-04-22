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
    case processingAnswer  // brief pause showing feedback before next question
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
final class VoiceQuizController: ObservableObject {

    // MARK: - Published state

    @Published private(set) var phase: VoiceFlowPhase = .idle
    @Published private(set) var transcription = ""
    @Published private(set) var lastAnswerCorrect: Bool?
    @Published private(set) var lastAnswerExplanation: String = ""
    @Published private(set) var isRecording = false
    @Published private(set) var isSpeaking = false
    @Published var authorizationStatus: SFSpeechRecognizerAuthorizationStatus = .notDetermined

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

    // MARK: - Private

    private var ttsChain: AnyCancellable?
    private var delayTask: AnyCancellable?
    private var timeoutTask: AnyCancellable?
    private var subscribers = Set<AnyCancellable>()

    // MARK: - Init

    init(quizLogic: UnifiedQuizLogic,
         tts: TextToSpeechService = ServiceLocator.shared.ttsService,
         stt: SpeechToTextService = ServiceLocator.shared.sttService) {
        self.quizLogic = quizLogic
        self.tts = tts
        self.stt = stt
        bindPublishers()
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
        stopAudio()
        phase = .idle
    }

    /// Clear the matched answer index after the view has processed it.
    func resetMatch() {
        matchedAnswerIndex = nil
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
        guard phase != .processingAnswer, phase != .speakingQuestion else { return }
        stopAudio()
        recordAnswerAndAdvance(answerIndex)
    }

    /// Reset for a new auto-advance session (e.g. "Try Again").
    func restart() {
        stopAudio()
        lastAnswerCorrect = nil
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
        Analytics.track(.voiceUsed(feature: "tts", language: localeCode))
        guard let first = items.first else { return }

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
        }
    }

    /// Start listening for a voice answer. Used by the mic button in practice mode.
    func startManualListening() {
        stopAudio()
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
            startManualListening()
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
        matchedAnswerIndex = nil

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
        phase = .listening
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
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !spoken.isEmpty else {
            phase = .listening
            return
        }

        let options = currentVariant().options
        if let idx = options.firstIndex(where: {
            let lc = $0.lowercased()
            return spoken == lc || spoken.contains(lc) || lc.contains(spoken)
        }) {
            if autoAdvance {
                recordAnswerAndAdvance(idx)
            } else {
                stopAudio()
                matchedAnswerIndex = idx
                phase = .idle
            }
        } else {
            Analytics.track(.voiceMatchFailed(language: localeCode))
            phase = .listening
        }
    }

    private func recordAnswerAndAdvance(_ answerIndex: Int) {
        stopAudio()

        // Capture data from the CURRENT question BEFORE advancing
        let answeredQuestion = quizLogic.currentQuestion
        lastAnswerExplanation = answeredQuestion.variants.first?.explanation ?? ""
        let correctOptionText = currentVariant().options[safe: answeredQuestion.correctAnswer] ?? ""

        let correct = quizLogic.answerQuestion(answerIndex)
        lastAnswerCorrect = correct

        if quizLogic.isFinished {
            phase = .finished
            return
        }

        quizLogic.moveToNextQuestion()

        if quizLogic.isFinished {
            phase = .finished
            return
        }

        phase = .processingAnswer

        if speakAnswerFeedback {
            // Speak "Correct" or "The answer is X" before advancing
            let feedbackText: String
            if correct {
                feedbackText = "Correct"
            } else {
                feedbackText = "The answer is \(correctOptionText)"
            }
            ttsChain = tts.speak(feedbackText, languageCode: localeCode)
                .flatMap { [weak self] _ -> AnyPublisher<Void, Never> in
                    guard let self else { return Just(()).eraseToAnyPublisher() }
                    return Just(())
                        .delay(for: .seconds(self.postAnswerDelay), scheduler: DispatchQueue.main)
                        .eraseToAnyPublisher()
                }
                .sink { [weak self] _ in
                    self?.speakCurrentQuestion()
                }
        } else {
            delayTask = Just(())
                .delay(for: .seconds(postAnswerDelay), scheduler: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.speakCurrentQuestion()
                }
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
    private func startListeningTimer() {
        timeoutTask?.cancel()
        guard listeningTimeout > 0 else { return }
        timeoutTask = Just(())
            .delay(for: .seconds(listeningTimeout), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self, self.phase == .listening else { return }
                Analytics.track(.voiceTimeout(language: self.localeCode))
                self.stt.stopRecording()
                if self.autoAdvance {
                    // Timeout: record as wrong (use an out-of-range index so no option matches correctAnswer)
                    self.recordAnswerAndAdvance(Int.max)
                } else {
                    self.phase = .idle
                }
            }
    }

    private func stopAudio() {
        ttsChain?.cancel(); ttsChain = nil
        delayTask?.cancel(); delayTask = nil
        timeoutTask?.cancel(); timeoutTask = nil
        tts.stopSpeaking()
        stt.stopRecording()
    }

    // ═════════════════════════════════════════════════════════════
    // MARK: - Combine Bindings
    // ═════════════════════════════════════════════════════════════

    private func bindPublishers() {
        tts.isSpeakingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] speaking in
                guard let self else { return }
                let wasSpeaking = self.isSpeaking
                self.isSpeaking = speaking
                if wasSpeaking && !speaking {
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
                self?.transcription = text
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
