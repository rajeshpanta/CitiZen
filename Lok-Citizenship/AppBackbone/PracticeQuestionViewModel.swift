import Foundation
import Combine
import Speech

/// Drives a single practice question’s TTS / STT logic.
final class PracticeQuestionViewModel: ObservableObject {

    // MARK: - Initialization data
    let questionID   : Int
    let questionText : String
    let language     : AppLanguage          // 👈 NEW

    // MARK: - Outputs for SwiftUI bindings
    @Published var isSpeaking          = false
    @Published var isRecording         = false
    @Published var transcription       = ""
    @Published var authorizationStatus : SFSpeechRecognizerAuthorizationStatus = .notDetermined
    @Published var showAuthorizationAlert = false

    // MARK: - Private
    private var cancellables = Set<AnyCancellable>()
    private let ttsService : TextToSpeechService
    private let sttService : SpeechToTextService

    // MARK: - Init
    init(
        questionID: Int,
        questionText: String,
        language: AppLanguage,                              // 👈 NEW PARAM
        ttsService: TextToSpeechService = ServiceLocator.shared.ttsService,
        sttService: SpeechToTextService = ServiceLocator.shared.sttService
    ) {
        self.questionID   = questionID
        self.questionText = questionText
        self.language     = language
        self.ttsService   = ttsService
        self.sttService   = sttService

        // TTS → isSpeaking
        ttsService.isSpeakingPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.isSpeaking, on: self)
            .store(in: &cancellables)

        // STT → isRecording
        sttService.isRecordingPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.isRecording, on: self)
            .store(in: &cancellables)

        // STT → transcription
        sttService.transcriptionPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.transcription, on: self)
            .store(in: &cancellables)

        // STT → authorization
        sttService.authorizationStatusPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.authorizationStatus, on: self)
            .store(in: &cancellables)
    }

    // MARK: - Public helpers ------------------------------------------------

    /// Speak the question text.
    func speakQuestion() {
        ttsService
            .speak(questionText, languageCode: language.ttsLocale)  // 👈 pass locale
            .sink { _ in }
            .store(in: &cancellables)
    }

    /// Ask for mic + speech-recognition permission.
    func requestSpeechPermissions() {
        sttService.requestAuthorization()
        sttService.authorizationStatusPublisher
            .map { $0 == .authorized }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] granted in
                self?.showAuthorizationAlert = !granted
            }
            .store(in: &cancellables)
    }

    /// Start listening for one of the four multiple-choice options.
    /// - Parameters:
    ///   - options:         exact option strings
    ///   - offlineOnly:     set to `true` if you want **strict** on-device STT
    func startRecording(withOptions options: [String], offlineOnly: Bool = true) {
        guard authorizationStatus == .authorized else {
            showAuthorizationAlert = true
            return
        }
        sttService.startRecording(
            withOptions : options,
            localeCode  : language.sttLocale,     // 👈 pass mapped locale
            offlineOnly : offlineOnly
        )
    }

    /// Stop listening.
    func stopRecording() {
        sttService.stopRecording()
    }
}
