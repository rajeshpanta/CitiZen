import Foundation
import AVFoundation

/// Centralized AVAudioSession configuration + prewarming for the whole app.
///
/// Every TTS / STT entry point (LocalTTSService, OpenAITTSService,
/// LocalSTTService, WhisperSTTService, SlowSpeechHelper) calls
/// `configureSession()` so the category, mode, options, and output route
/// are configured in exactly one place. This eliminates the divergence
/// the app previously had between five copies of the same setCategory
/// block — and fixes two real bugs that came from the old config:
///
/// 1. **Background music wouldn't duck.** The old options included
///    `.defaultToSpeaker`, which forces a speaker-route override that
///    competes with `.duckOthers` on `.playAndRecord` sessions. Dropping
///    `.defaultToSpeaker` lets the duck policy engage cleanly.
///
/// 2. **Bluetooth speakers were ignored.** Apple's docs are explicit:
///    `.defaultToSpeaker` routes to the built-in speaker *"even if a
///    headset or other accessory is in use."* So when the user had a BT
///    speaker connected, our TTS forced playback back to the iPhone
///    speaker. Dropping the option (and adding `.allowBluetoothA2DP` for
///    stereo BT output) means iOS routes to BT correctly when present.
///
/// Replacement strategy for the speaker route: after `setActive`, query
/// the current route. If no external output (BT, headphones, AirPlay,
/// car audio, line-out) is connected, override to the speaker — because
/// `.playAndRecord`'s default is the receiver (earpiece), which is wrong
/// for hands-free study. If something external IS connected, clear any
/// prior override so the BT/headphone route takes effect.
enum AudioSessionPrewarmer {

    // MARK: - Unified options

    /// The single canonical option set used everywhere in the app.
    /// Adding/removing options here propagates to every audio path.
    private static let categoryOptions: AVAudioSession.CategoryOptions = [
        .duckOthers,
        .allowBluetoothA2DP,   // stereo BT output (high-quality TTS)
        .allowBluetoothHFP     // BT mic input + telephony-grade BT output
    ]

    // MARK: - Pending prewarm continuation

    /// In-flight scheduled continuation, if any. Held so the next
    /// `prewarm` (or an explicit `cancel`) can supersede it before it
    /// fires — without this, a Start tap → Back tap within 200 ms would
    /// still kick off TTS on a dismissed view.
    private static var pending: DispatchWorkItem?

    // MARK: - Public API

    /// Configure category/mode/options, activate the session, and apply
    /// the route override. Idempotent and cheap on the hot path: the
    /// system treats setCategory as a no-op when nothing's changing, and
    /// the route check is a one-pass scan over `currentRoute.outputs`.
    ///
    /// Called from every TTS speak() / STT startRecording() entry point
    /// so the session state is always consistent — without this each
    /// service had its own copy of the config block, and they had drifted
    /// apart over time.
    @discardableResult
    static func configureSession() -> Bool {
        let session = AVAudioSession.sharedInstance()
        do {
            // Set category only when the current config doesn't already
            // match. Reapplying identical options is technically safe but
            // can produce audible artifacts on some devices during
            // back-to-back TTS↔STT cycles; the guard keeps the hot path
            // a no-op once the session is correctly configured for the
            // process lifetime.
            if session.category != .playAndRecord
                || session.mode != .spokenAudio
                || !session.categoryOptions.isSuperset(of: categoryOptions) {
                try session.setCategory(
                    .playAndRecord,
                    mode: .spokenAudio,
                    options: categoryOptions
                )
            }
            try session.setActive(true)
            applyRouteOverride()
            return true
        } catch {
            #if DEBUG
            print("[AudioSession] configure failed: \(error)")
            #endif
            return false
        }
    }

    /// Configure + activate the session, then call `continuation` after
    /// 200 ms so `.duckOthers` has time to engage on background music
    /// apps before the first audio buffer of TTS plays. iOS engages the
    /// duck on `setActive(true)`, but propagating it to the other app's
    /// output is asynchronous — without the wait, ~150–300 ms of music
    /// overlaps the start of the first question.
    ///
    /// Use at the entry point of any voice-using flow that's about to
    /// speak immediately: Mock Interview "Start"/"Try Again", Audio-Only
    /// session start, Practice Quiz "Listen" button. Repeat calls
    /// supersede the prior pending continuation — most recent intent wins.
    static func prewarm(then continuation: @escaping () -> Void) {
        cancel()
        configureSession()

        let item = DispatchWorkItem {
            pending = nil
            continuation()
        }
        pending = item
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: item)
    }

    /// Drop any pending continuation. Called from
    /// `VoiceQuizController.stopAudio` so an End/Back/Stop/option-tap
    /// during the 200 ms duck-settle window doesn't trigger a stale TTS
    /// start after the user has already moved on.
    static func cancel() {
        pending?.cancel()
        pending = nil
    }

    // MARK: - Route override

    /// Override output to the built-in speaker when nothing external is
    /// connected. With `.playAndRecord` the default route is the receiver
    /// (earpiece), which is wrong for hands-free study. When BT /
    /// headphones / AirPlay / car / line-out IS connected, clear any
    /// prior `.speaker` override so the external route takes effect.
    private static func applyRouteOverride() {
        let session = AVAudioSession.sharedInstance()
        let hasExternalOutput = session.currentRoute.outputs.contains { out in
            switch out.portType {
            case .bluetoothA2DP, .bluetoothHFP, .bluetoothLE,
                 .headphones, .headsetMic,
                 .lineOut, .airPlay, .HDMI, .carAudio,
                 .usbAudio:
                return true
            default:
                return false
            }
        }
        // `.none` clears any prior override and restores default routing
        // (which honors BT / headphones); `.speaker` forces the loud
        // speaker. Calling `.none` when there's no override pending is a
        // no-op, so this branch is always safe to call.
        try? session.overrideOutputAudioPort(hasExternalOutput ? .none : .speaker)
    }
}
