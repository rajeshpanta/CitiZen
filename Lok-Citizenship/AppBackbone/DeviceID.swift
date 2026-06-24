import Foundation
import Security

/// Stable per-install identifier used as the rate-limit key for the Whisper
/// edge function. Stored in the Keychain so it survives app deletes (on iOS,
/// Keychain entries persist across reinstalls until the device is reset).
///
/// Not authentication. Anyone can rotate this header — its job is to stop
/// accidental loops and give us per-install usage telemetry, not to thwart
/// determined abuse. Real abuse protection would be App Attest.
enum DeviceID {

    private static let account = "citizen.device.id.v1"

    // Swift guarantees this lazy initializer runs exactly once regardless of
    // concurrent first-callers — eliminates the race where two threads each
    // generate a fresh UUID and write to the Keychain simultaneously.
    static let current: String = {
        if let existing = read() { return existing }
        let new = UUID().uuidString
        write(new)
        return new
    }()

    private static func read() -> String? {
        let q: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        var item: CFTypeRef?
        guard SecItemCopyMatching(q as CFDictionary, &item) == errSecSuccess,
              let data = item as? Data,
              let string = String(data: data, encoding: .utf8)
        else { return nil }
        return string
    }

    private static func write(_ id: String) {
        guard let data = id.data(using: .utf8) else { return }
        let q: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
        ]
        SecItemDelete(q as CFDictionary)
        var add = q
        add[kSecValueData as String] = data
        add[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
        let status = SecItemAdd(add as CFDictionary, nil)
        #if DEBUG
        if status != errSecSuccess { print("[DeviceID] Keychain write failed: \(status)") }
        #endif
    }
}
