import Foundation
import AVFoundation

/// Prepares the shared AVAudioSession so `.duckOthers` engages on background
/// music apps BEFORE the first TTS audio plays.
///
/// Without this, when an interview/quiz starts while Spotify (or any
/// streaming music app) is playing, the user hears ~150–300 ms of overlap
/// between their music and the question being read. iOS engages the duck
/// on `setActive(true)`, but propagating that duck to the other app's
/// audio output is asynchronous — by the time it's in place, our first
/// audio buffer has already played. After the first cycle the duck stays
/// engaged for the rest of the session, so only the FIRST activation
/// needs the delay.
///
/// Use this at the entry point of any voice-using flow that's about to
/// speak immediately: Mock Interview "Start"/"Try Again", Audio-Only
/// session start, Practice Quiz "Listen" button.
enum AudioSessionPrewarmer {

    /// In-flight scheduled continuation, if any. Held so the next
    /// `prewarm` (or an explicit `cancel`) can supersede it before
    /// it fires — without this, a Start tap → Back tap within 200 ms
    /// would still kick off TTS on a dismissed view.
    private static var pending: DispatchWorkItem?

    /// Activate the session, then call `continuation` on main once the
    /// duck has had time to engage. Repeat calls supersede the prior
    /// pending continuation — the most recent intent wins.
    static func prewarm(then continuation: @escaping () -> Void) {
        cancel()

        let session = AVAudioSession.sharedInstance()
        do {
            if session.category != .playAndRecord {
                try session.setCategory(
                    .playAndRecord,
                    mode: .spokenAudio,
                    options: [.duckOthers, .defaultToSpeaker, .allowBluetoothHFP]
                )
            }
            try session.setActive(true)
        } catch {
            #if DEBUG
            print("[AudioSession] prewarm failed: \(error)")
            #endif
        }

        // 200 ms is the smallest delay that reliably eliminates the
        // start-of-TTS overlap with streaming-music apps. Shorter than
        // that and the music still plays for a moment alongside our
        // first question; much longer and the lag after the button tap
        // starts to feel sluggish.
        let item = DispatchWorkItem {
            pending = nil
            continuation()
        }
        pending = item
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: item)
    }

    /// Drop any pending continuation. Called from `VoiceQuizController.stop`
    /// so that End/Back/Stop taken during the 200 ms duck-settle window
    /// don't trigger a stale TTS start after the user has already left
    /// the screen.
    static func cancel() {
        pending?.cancel()
        pending = nil
    }
}
