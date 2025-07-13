import Foundation

/// A central holder for any “shared” services—offline TTS/STT in our case.
final class ServiceLocator {
    // 1) The single, shared instance of the locator
    static let shared = ServiceLocator()

    // 2) Lazily created TTS and STT services
    private(set) lazy var ttsService: TextToSpeechService = LocalTTSService()
    private(set) lazy var sttService: SpeechToTextService = LocalSTTService()

    // 3) Make the initializer private so nobody else can create another locator.
    private init() { }
}

