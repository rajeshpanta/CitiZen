import Foundation
import Combine
import Speech
import AVFoundation

/// Thin wrapper around `LocalSTTService` for free-form speech capture.
///
/// `VoiceQuizController` is the richer wrapper used by the quiz flow — it auto-stops
/// on matched answer options. Reading Test Mode needs the opposite: let the user
/// speak a full sentence, transcribe everything, and only stop when the user taps
/// Done (or the recognizer reports `isFinal` from silence).
final class FreeformSTTController: ObservableObject {

    @Published private(set) var isRecording = false
    @Published private(set) var transcription = ""
    @Published private(set) var authorizationStatus: SFSpeechRecognizerAuthorizationStatus = .notDetermined

    private let stt: SpeechToTextService
    private var subs = Set<AnyCancellable>()

    init(stt: SpeechToTextService = LocalSTTService()) {
        // M5: use a dedicated STT instance instead of the app-wide shared service
        // so Reading Test doesn't share state with Mock Interview / Audio-Only.
        // The default value can still be overridden by tests or callers.
        self.stt = stt

        stt.isRecordingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.isRecording = $0 }
            .store(in: &subs)

        stt.transcriptionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.transcription = $0 }
            .store(in: &subs)

        stt.authorizationStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.authorizationStatus = $0 }
            .store(in: &subs)

        observeAudioInterruptions()
    }

    /// Halt recording on `AVAudioSession.interruptionNotification` (.began).
    /// Without this, an incoming phone call / Siri / FaceTime / alarm during
    /// a Reading or Writing test rips the audio engine out from under
    /// `SFSpeechRecognizer`, freezes the on-screen partial transcript, and
    /// — if the user taps Done after returning from the call — commits the
    /// stale partial as their answer. Mirrors the observer in
    /// `VoiceQuizController.observeAudioInterruptions`.
    ///
    /// We deliberately ignore `.ended`: iOS' `shouldResume` hint is meant
    /// for media players, and silently re-arming the mic while the user
    /// is still wrapping up a call is worse UX than letting them tap mic
    /// again when ready.
    private func observeAudioInterruptions() {
        NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)
            .receive(on: DispatchQueue.main)  // AVAudioSession posts off main
            .sink { [weak self] notification in
                guard let self,
                      let info = notification.userInfo,
                      let raw = info[AVAudioSessionInterruptionTypeKey] as? UInt,
                      let type = AVAudioSession.InterruptionType(rawValue: raw),
                      type == .began
                else { return }

                // Only act if we're actually recording. `stop()` is
                // idempotent against the underlying STT service, so
                // calling it on an idle controller is safe — but
                // `LocalSTTService.stopRecording` still goes through
                // `engine.stop` + tap removal + `task.cancel`, which is
                // wasted work when there was nothing to record.
                guard self.isRecording else { return }
                self.stop()
            }
            .store(in: &subs)
    }

    func requestAuthorization() {
        stt.requestAuthorization()
    }

    /// Start capturing free-form speech. No options → the underlying service won't
    /// auto-stop on any spoken phrase; recording only ends on `stop()`, silence
    /// (via `isFinal`), or error.
    func start(localeCode: String = "en-US") {
        transcription = ""
        stt.startRecording(withOptions: [], localeCode: localeCode, offlineOnly: true)
    }

    func stop() {
        stt.stopRecording()
    }

    /// Reset the visible transcription without touching recording state.
    func clearTranscription() {
        transcription = ""
    }
}
