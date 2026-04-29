import Foundation
import UserNotifications

/// Manages local push notifications for study reminders and streak alerts.
final class NotificationManager: ObservableObject {

    static let shared = NotificationManager()

    private let center = UNUserNotificationCenter.current()
    private let defaults = UserDefaults.standard

    /// Serializes all cancel + add work so that rapid toggles (Settings
    /// switch flipped quickly, or time picker scrubbed) cannot interleave
    /// a `removeAllPendingNotificationRequests` from one call with the
    /// `add` from another. Both UN center methods are async on
    /// a private queue inside the framework, and the framework does not
    /// guarantee ordering between independent calls. Without this queue
    /// a "OFF then ON" flip could end up with no scheduled requests
    /// (the late cancel wins), and a time edit could leave the previous
    /// time scheduled. Serializing through one FIFO queue makes the
    /// outcome match the user's last action.
    private let scheduleQueue = DispatchQueue(label: "com.citizen.notifications.schedule")

    // MARK: - Published state

    @Published var isAuthorized = false

    // MARK: - UserDefaults keys

    private let enabledKey  = "pm_notificationsEnabled"
    private let hourKey     = "pm_reminderHour"
    private let minuteKey   = "pm_reminderMinute"

    // MARK: - Preferences

    var isEnabled: Bool {
        get { defaults.bool(forKey: enabledKey) }
        set {
            defaults.set(newValue, forKey: enabledKey)
            objectWillChange.send()
            scheduleAll()
        }
    }

    var reminderHour: Int {
        get { defaults.integer(forKey: hourKey) }
        set {
            defaults.set(newValue, forKey: hourKey)
            objectWillChange.send()
            if isEnabled { scheduleAll() }
        }
    }

    var reminderMinute: Int {
        get { defaults.integer(forKey: minuteKey) }
        set {
            defaults.set(newValue, forKey: minuteKey)
            objectWillChange.send()
            if isEnabled { scheduleAll() }
        }
    }

    /// Convenience: the reminder time as a Date for DatePicker binding.
    var reminderTime: Date {
        get {
            var comps = DateComponents()
            comps.hour = reminderHour
            comps.minute = reminderMinute
            return Calendar.current.date(from: comps) ?? Date()
        }
        set {
            let comps = Calendar.current.dateComponents([.hour, .minute], from: newValue)
            reminderHour = comps.hour ?? 9
            reminderMinute = comps.minute ?? 0
        }
    }

    // MARK: - Init

    private init() {
        // First-run defaults: daily reminder ON at 6:00 PM.
        // `register(defaults:)` only applies when the user hasn't explicitly set a value,
        // so toggling off / changing the time still persists.
        UserDefaults.standard.register(defaults: [
            enabledKey: true,
            hourKey: 18,
            minuteKey: 0
        ])
        checkAuthorization()
    }

    // MARK: - Permission

    /// Request notification permission. The optional `completion` fires on
    /// main *after* the OS prompt resolves (granted or denied) — callers
    /// that need to chain follow-up UI (e.g. onboarding's "Enable
    /// Notifications" → next screen) should use it instead of an
    /// `asyncAfter` delay, which races against slow user dismissals.
    func requestPermission(completion: (() -> Void)? = nil) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            DispatchQueue.main.async {
                self?.isAuthorized = granted
                if granted {
                    self?.isEnabled = true
                }
                completion?()
            }
        }
    }

    func checkAuthorization() {
        center.getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }

    // MARK: - Schedule

    /// Cancel and (re)schedule all notifications. The cancel + add work
    /// runs on `scheduleQueue` (FIFO) so concurrent callers can't interleave.
    /// `enabled` is captured synchronously from the caller's queue so the
    /// dispatched block reflects the toggle state at call time, not at
    /// execution time — important when the user flips the switch fast
    /// enough that two `scheduleAll` calls are queued back-to-back.
    func scheduleAll() {
        let enabled = isEnabled
        scheduleQueue.async { [weak self] in
            guard let self else { return }
            self.center.removeAllPendingNotificationRequests()
            guard enabled else { return }
            self.scheduleDailyReminder()
            self.scheduleStreakReminder()
        }
    }

    /// Look up strings for the user's chosen onboarding language. Read at
    /// schedule time so that a language change (today only via re-onboarding,
    /// but future-proof) takes effect on the next `scheduleAll`. Falls back
    /// to English if the saved value isn't a known `AppLanguage`.
    ///
    /// Reads UserDefaults directly rather than going through
    /// `ProgressManager.shared.preferredLanguage` because `ProgressManager`
    /// is `@MainActor`-isolated and this property is invoked from
    /// `scheduleDailyReminder` / `scheduleStreakReminder` which run in a
    /// nonisolated context. The key string mirrors the one in
    /// `ProgressManager.preferredLanguage`.
    private var localizedStrings: UIStrings {
        let raw = UserDefaults.standard.string(forKey: "pm_preferredLanguage")
        if let raw, let lang = AppLanguage(rawValue: raw) {
            return UIStrings.forLanguage(lang)
        }
        return UIStrings.forLanguage(.english)
    }

    private func scheduleDailyReminder() {
        let s = localizedStrings
        let content = UNMutableNotificationContent()
        content.title = s.notifDailyTitle
        content.body = s.notifDailyBody
        content.sound = .default

        var dateComps = DateComponents()
        dateComps.hour = reminderHour
        dateComps.minute = reminderMinute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComps, repeats: true)
        let request = UNNotificationRequest(identifier: "citizen.daily_reminder", content: content, trigger: trigger)
        center.add(request)
    }

    private func scheduleStreakReminder() {
        let s = localizedStrings
        let content = UNMutableNotificationContent()
        content.title = s.notifStreakTitle
        content.body = s.notifStreakBody
        content.sound = .default

        var dateComps = DateComponents()
        dateComps.hour = 20 // 8 PM
        dateComps.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComps, repeats: true)
        let request = UNNotificationRequest(identifier: "citizen.streak_reminder", content: content, trigger: trigger)
        center.add(request)
    }
}
