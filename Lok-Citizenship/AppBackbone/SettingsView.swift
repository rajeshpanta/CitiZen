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
    @State private var openAIKey: String = UserDefaults.standard.string(forKey: "openai_api_key") ?? ""

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

            // MARK: - Voice (OpenAI TTS)
            Section {
                SecureField("sk-…", text: $openAIKey)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .font(.system(.footnote, design: .monospaced))
                HStack {
                    Button("Save") {
                        let trimmed = openAIKey.trimmingCharacters(in: .whitespacesAndNewlines)
                        UserDefaults.standard.set(trimmed, forKey: "openai_api_key")
                    }
                    Spacer()
                    if !openAIKey.isEmpty {
                        Button("Clear", role: .destructive) {
                            openAIKey = ""
                            UserDefaults.standard.removeObject(forKey: "openai_api_key")
                        }
                    }
                }
                HStack {
                    Text("Status")
                    Spacer()
                    Text(savedKeyPresent ? "Using OpenAI voice (nova)" : "Using on-device voice")
                        .font(.caption)
                        .foregroundColor(savedKeyPresent ? .green : .secondary)
                }
            } header: {
                Text("Voice")
            } footer: {
                Text("Paste an OpenAI API key to use the 'nova' voice. Leave empty to use the on-device voice. Audio is cached per question so each key is charged once.")
                    .font(.caption2)
            }
            #endif
        }
        .navigationTitle(s.navSettings)
        .sheet(isPresented: $showPrivacy) { PrivacyPolicyView() }
        .sheet(isPresented: $showTerms) { TermsOfUseView() }
        .onAppear {
            notifications.checkAuthorization()
        }
    }

    private var savedKeyPresent: Bool {
        let k = UserDefaults.standard.string(forKey: "openai_api_key") ?? ""
        return !k.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
