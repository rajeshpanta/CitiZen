import SwiftUI

struct SettingsView: View {

    /// Picked by the parent (PracticeSelectionView). Drives all section labels so
    /// the Settings screen matches the user's selected app language.
    let language: AppLanguage

    @ObservedObject private var notifications = NotificationManager.shared
    @ObservedObject private var store = StoreManager.shared
    private let progress = ProgressManager.shared

    @State private var showPrivacy = false
    @State private var showTerms = false
    @State private var interviewDate: Date = ProgressManager.shared.interviewDate ?? Date()
    @State private var hasInterview: Bool = ProgressManager.shared.interviewDate != nil
    @Environment(\.scenePhase) private var scenePhase
    private var s: UIStrings { UIStrings.forLanguage(language) }

    var body: some View {
        Form {
            // MARK: - Study Reminders
            Section {
                if notifications.isAuthorized {
                    Toggle(s.settingsDailyReminder, isOn: Binding(
                        get: { notifications.isEnabled },
                        set: { notifications.isEnabled = $0 }
                    ))

                    if notifications.isEnabled {
                        DatePicker(
                            s.settingsReminderTime,
                            selection: Binding(
                                get: { notifications.reminderTime },
                                set: { notifications.reminderTime = $0 }
                            ),
                            displayedComponents: .hourAndMinute
                        )
                    }
                } else {
                    Button(s.settingsEnableNotifications) {
                        notifications.requestPermission()
                    }

                    Text(s.settingsRemindersCaption)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } header: {
                Text(s.settingsRemindersHeader)
            }

            // MARK: - Interview Date
            Section {
                Toggle(s.settingsHasScheduledInterview, isOn: $hasInterview)
                    .onChange(of: hasInterview) { enabled in
                        if enabled {
                            progress.interviewDate = interviewDate
                        } else {
                            progress.interviewDate = nil
                        }
                    }

                if hasInterview {
                    DatePicker(
                        s.settingsInterviewDate,
                        selection: $interviewDate,
                        in: Date()...,
                        displayedComponents: .date
                    )
                    .onChange(of: interviewDate) { date in
                        progress.interviewDate = date
                    }
                }
            } header: {
                Text(s.settingsInterviewHeader)
            }

            // MARK: - Purchases
            Section {
                if store.isPro {
                    HStack {
                        Text("CitiZen Pro")
                        Spacer()
                        Text(s.settingsProActive)
                            .foregroundColor(.green)
                            .bold()
                    }
                } else {
                    Button(s.settingsRestorePurchases) {
                        Task { await store.restorePurchases() }
                    }
                }
            } header: {
                Text(s.settingsSubscriptionHeader)
            }

            // MARK: - Legal
            Section {
                Button(s.settingsPrivacyPolicy) { showPrivacy = true }
                Button(s.settingsTermsOfUse) { showTerms = true }
            } header: {
                Text(s.settingsLegalHeader)
            }

            // MARK: - About
            Section {
                HStack {
                    Text(s.settingsVersionLabel)
                    Spacer()
                    Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                        .foregroundColor(.secondary)
                }
            } header: {
                Text(s.settingsAboutHeader)
            }

            #if DEBUG
            // MARK: - Developer
            Section {
                Toggle("Force Pro (dev only)", isOn: Binding(
                    get: { store.isDevForcePro },
                    set: { store.setDevForcePro($0) }
                ))
                Button("Reset Onboarding") {
                    progress.hasCompletedOnboarding = false
                }
                .foregroundColor(.orange)
            } header: {
                Text("Developer")
            } footer: {
                Text("DEBUG builds only. Unlocks all Pro features without a real purchase.")
                    .font(.caption2)
            }
            #endif
        }
        .navigationTitle(s.navSettings)
        .sheet(isPresented: $showPrivacy) { PrivacyPolicyView() }
        .sheet(isPresented: $showTerms) { TermsOfUseView() }
        .onAppear {
            notifications.checkAuthorization()
            // Refresh local @State from persisted state. The @State init
            // expressions only run once per view identity, so a freshly
            // mounted Settings (e.g. user popped to PracticeSelection then
            // re-pushed Settings, or another flow wrote to `interviewDate`
            // in between) would otherwise display stale local copies.
            // Toggle-off keeps the locally-shown date untouched so the
            // picker remembers the user's last pick within the session.
            if let saved = progress.interviewDate {
                interviewDate = saved
                hasInterview = true
            } else {
                hasInterview = false
            }
        }
        // Re-query notification permission when the user comes back from
        // the OS Settings app. Without this, tapping "Enable Notifications"
        // → opening Settings → toggling permission → returning leaves the
        // toggle in its old state until the user navigates away and back.
        // Mirrors the scenePhase pattern in MockInterviewView / AudioOnlyView.
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                notifications.checkAuthorization()
            }
        }
    }

}
