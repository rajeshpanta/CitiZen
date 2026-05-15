import Foundation

/// A central holder for any “shared” services—offline TTS/STT in our case.
final class ServiceLocator {
    // 1) The single, shared instance of the locator
    static let shared = ServiceLocator()

    /// One OpenAI TTS instance for the whole app. Previously `TTSRouter`
    /// (used by Quiz / Mock / AudioOnly) and `SlowSpeechHelper` (used by
    /// Reading / Writing practice + test) each instantiated their own,
    /// so neither's `stopSpeaking` reached the other's AVAudioPlayer.
    /// If Reading practice TTS happened to overlap a Mock Interview
    /// prompt (rare but possible — e.g., notification deep-link mid-
    /// playback), two AVAudioPlayers fought over the shared
    /// `AVAudioSession`, producing overlapping speech with no way to
    /// silence one from the other. Sharing one instance gives a single
    /// request-id, a single AVAudioPlayer at a time, and consistent
    /// `isSpeakingPublisher` semantics across both consumers.
    let openAITTS = OpenAITTSService()

    // 2) Lazily created TTS and STT services. The router receives the
    //    shared OpenAI instance so all cloud-TTS calls go through one
    //    state machine.
    private(set) lazy var ttsService: TextToSpeechService = TTSRouter(openAI: openAITTS)
    private(set) lazy var sttService: SpeechToTextService = LocalSTTService()

    // 3) Make the initializer private so nobody else can create another locator.
    private init() { }
}

