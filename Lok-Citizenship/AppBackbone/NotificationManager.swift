import Foundation
import UserNotifications

/// Manages local push notifications for study reminders and streak alerts.
final class NotificationManager: ObservableObject {

    static let shared = NotificationManager()

    private let center = UNUserNotificationCenter.current()
    private let defaults = UserDefaults.standard

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
            if newValue { scheduleAll() } else { cancelAll() }
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

    func requestPermission() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            DispatchQueue.main.async {
                self?.isAuthorized = granted
                if granted {
                    self?.isEnabled = true
                }
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

    func scheduleAll() {
        cancelAll()
        guard isEnabled else { return }
        scheduleDailyReminder()
        scheduleStreakReminder()
    }

    private func scheduleDailyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Time to study!"
        content.body = "A few minutes of practice keeps you on track for your citizenship test."
        content.sound = .default

        var dateComps = DateComponents()
        dateComps.hour = reminderHour
        dateComps.minute = reminderMinute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComps, repeats: true)
        let request = UNNotificationRequest(identifier: "citizen.daily_reminder", content: content, trigger: trigger)
        center.add(request)
    }

    private func scheduleStreakReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Don't lose your streak!"
        content.body = "Complete a quick quiz today to keep your study streak alive."
        content.sound = .default

        var dateComps = DateComponents()
        dateComps.hour = 20 // 8 PM
        dateComps.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComps, repeats: true)
        let request = UNNotificationRequest(identifier: "citizen.streak_reminder", content: content, trigger: trigger)
        center.add(request)
    }

    // MARK: - Cancel

    func cancelAll() {
        center.removeAllPendingNotificationRequests()
    }
}
