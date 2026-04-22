import SwiftUI

struct SettingsView: View {

    @ObservedObject private var notifications = NotificationManager.shared
    @ObservedObject private var store = StoreManager.shared
    private let progress = ProgressManager.shared

    @State private var showPrivacy = false
    @State private var showTerms = false
    @State private var interviewDate: Date = ProgressManager.shared.interviewDate ?? Date()
    @State private var hasInterview: Bool = ProgressManager.shared.interviewDate != nil

    var body: some View {
        Form {
            // MARK: - Study Reminders
            Section {
                if notifications.isAuthorized {
                    Toggle("Daily Reminder", isOn: Binding(
                        get: { notifications.isEnabled },
                        set: { notifications.isEnabled = $0 }
                    ))

                    if notifications.isEnabled {
                        DatePicker(
                            "Reminder Time",
                            selection: Binding(
                                get: { notifications.reminderTime },
                                set: { notifications.reminderTime = $0 }
                            ),
                            displayedComponents: .hourAndMinute
                        )
                    }
                } else {
                    Button("Enable Notifications") {
                        notifications.requestPermission()
                    }

                    Text("Get daily reminders to study and streak alerts.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } header: {
                Text("Study Reminders")
            }

            // MARK: - Interview Date
            Section {
                Toggle("I have a scheduled interview", isOn: $hasInterview)
                    .onChange(of: hasInterview) { enabled in
                        if enabled {
                            progress.interviewDate = interviewDate
                        } else {
                            progress.interviewDate = nil
                        }
                    }

                if hasInterview {
                    DatePicker(
                        "Interview Date",
                        selection: $interviewDate,
                        in: Date()...,
                        displayedComponents: .date
                    )
                    .onChange(of: interviewDate) { date in
                        progress.interviewDate = date
                    }
                }
            } header: {
                Text("Interview")
            }

            // MARK: - Purchases
            Section {
                if store.isPro {
                    HStack {
                        Text("CitiZen Pro")
                        Spacer()
                        Text("Active")
                            .foregroundColor(.green)
                            .bold()
                    }
                } else {
                    Button("Restore Purchases") {
                        Task { await store.restorePurchases() }
                    }
                }
            } header: {
                Text("Subscription")
            }

            // MARK: - Legal
            Section {
                Button("Privacy Policy") { showPrivacy = true }
                Button("Terms of Use") { showTerms = true }
            } header: {
                Text("Legal")
            }

            // MARK: - About
            Section {
                HStack {
                    Text("Version")
                    Spacer()
                    Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                        .foregroundColor(.secondary)
                }
            } header: {
                Text("About")
            }
        }
        .navigationTitle("Settings")
        .sheet(isPresented: $showPrivacy) { PrivacyPolicyView() }
        .sheet(isPresented: $showTerms) { TermsOfUseView() }
        .onAppear {
            notifications.checkAuthorization()
        }
    }
}
