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
    @State private var showPaywall = false
    @State private var showTrackPicker = false
    @State private var interviewDate: Date = Date()
    @State private var hasInterview: Bool = false
    @AppStorage("pm_questionSet") private var questionSetRaw: String = "2008"
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.openURL) private var openURL
    /// Triggers the App Store review prompt from the "Rate CitiZen" row.
    /// Same iOS-managed prompt as the one fired from MockInterviewView's
    /// post-pass moment, so iOS's 3-per-365-day quota covers both.
    @Environment(\.requestReview) private var requestReview
    private var s: UIStrings { UIStrings.forLanguage(language) }

    var body: some View {
        ZStack {
            // Match the deep-blue gradient used by PracticeSelectionView /
            // ReadinessView so Settings doesn't read as "a different app."
            // Form keeps its native rows + accessibility — only the
            // backdrop and color scheme change.
            LinearGradient(
                colors: [
                    Color(red: 0.0, green: 0.12, blue: 0.35),
                    Color(red: 0.0, green: 0.06, blue: 0.2),
                    Color.black
                ],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

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
                        Text(s.settingsStreakReminderCaption)
                            .font(.caption)
                            .foregroundColor(.secondary)
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
                        // Two-year ceiling — see the matching comment in
                        // OnboardingView. Stops the readiness "X days until
                        // your interview" copy from rendering nonsense
                        // when a user picks a far-future date.
                        in: Date()...(Calendar.current.date(byAdding: .year, value: 2, to: Date()) ?? Date()),
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
                    // Plan label — only when we have a real transaction.
                    // DEBUG dev-force leaves activeProductID nil so this
                    // row hides instead of misreporting "Lifetime".
                    if let plan = planDisplayLabel(for: store.activeProductID) {
                        HStack {
                            Text(s.settingsPlanLabel)
                            Spacer()
                            Text(plan)
                                .foregroundColor(.secondary)
                        }
                    }
                    // Renewable subscriptions only — Apple's guideline
                    // 3.1.2 requires an in-app management entry. Lifetime
                    // doesn't auto-renew, so the link would just confuse.
                    if store.activeProductID == StoreManager.monthlyID {
                        Button(s.settingsManageSubscription) {
                            if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
                                openURL(url)
                            }
                        }
                    }
                    Button(s.settingsRestorePurchases) {
                        Task { await store.restorePurchases() }
                    }
                } else {
                    Button(s.settingsUpgradeToPro) {
                        showPaywall = true
                    }
                    .bold()
                    Button(s.settingsRestorePurchases) {
                        Task { await store.restorePurchases() }
                    }
                }
            } header: {
                Text(s.settingsSubscriptionHeader)
            }

            // MARK: - Study Track
            Section {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(trackLabel)
                            .font(.body)
                        Text(trackDetail)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Button(switchTrackLabel) {
                        showTrackPicker = true
                    }
                    .font(.callout)
                    .buttonStyle(.borderless)
                    .foregroundColor(.accentColor)
                }
            } header: {
                Text(studyTrackHeader)
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
                // Persistent rating entry point. Complements the
                // post-mock-pass auto-prompt by giving users who
                // already decided to leave a review a one-tap path.
                // Same iOS-managed sheet, same 3-per-year cap.
                Button(s.settingsRateApp) {
                    requestReview()
                }
                // Contact support — surfaces the email that's
                // otherwise buried in the Privacy Policy text.
                // Pre-fills subject so inbound tickets are easier
                // to triage.
                Button(s.settingsContactSupport) {
                    let subject = "CitiZen App Feedback"
                    let encoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? subject
                    if let url = URL(string: "mailto:support@citizenapp.us?subject=\(encoded)") {
                        openURL(url)
                    }
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
                    progress.hasChosenQuestionSet = false
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
            // Hide Form's default grouped-list backdrop so the gradient
            // shows through. Without this we'd see the standard system
            // gray (Light) or near-black (Dark) behind the rows.
            .scrollContentBackground(.hidden)
        }
        // Force dark color scheme so native controls (Toggle, DatePicker,
        // Buttons inside Form) render their dark-mode variants regardless
        // of the user's system setting — matching the rest of the app,
        // which is hardcoded dark.
        .preferredColorScheme(.dark)
        .navigationTitle(s.navSettings)
        .sheet(isPresented: $showPrivacy) { PrivacyPolicyView(language: language) }
        .sheet(isPresented: $showTerms) { TermsOfUseView(language: language) }
        .sheet(isPresented: $showPaywall) {
            PaywallView(trigger: "settings_upgrade", language: language)
        }
        .sheet(isPresented: $showTrackPicker) {
            QuestionSetPickerView(language: language) { _ in
                showTrackPicker = false
            }
        }
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

    /// Localized human-readable name for the user's current plan, derived
    /// from the StoreKit product ID. Returns `nil` for unrecognized IDs
    /// (e.g. a future SKU we haven't shipped strings for, or DEBUG
    /// dev-force where there is no real transaction) — callers should
    /// hide the row in that case rather than show a raw product ID.
    private func planDisplayLabel(for productID: String?) -> String? {
        switch productID {
        case StoreManager.monthlyID:  return s.settingsPlanMonthly
        case StoreManager.lifetimeID: return s.settingsPlanLifetime
        default: return nil
        }
    }

    // MARK: - Study Track copy

    private var is100Track: Bool { questionSetRaw == "2008" }

    private var studyTrackHeader: String {
        switch language {
        case .english: return "Study Track"
        case .nepali:  return "अध्ययन ट्र्याक"
        case .spanish: return "Vía de estudio"
        case .chinese: return "学习方向"
        }
    }

    private var trackLabel: String {
        switch language {
        case .english: return is100Track ? "100 Questions (2008 USCIS)" : "128 Questions (2020 USCIS)"
        case .nepali:  return is100Track ? "१०० प्रश्न (२००८ USCIS)" : "१२८ प्रश्न (२०२० USCIS)"
        case .spanish: return is100Track ? "100 preguntas (USCIS 2008)" : "128 preguntas (USCIS 2020)"
        case .chinese: return is100Track ? "100道题（2008年USCIS）" : "128道题（2020年USCIS）"
        }
    }

    private var trackDetail: String {
        switch language {
        case .english: return is100Track ? "10 interview sets · Pass 6/10" : "8 practice sets · Pass 12/16"
        case .nepali:  return is100Track ? "१० अन्तर्वार्ता सेट · ६/१० पास" : "८ अभ्यास सेट · १२/१६ पास"
        case .spanish: return is100Track ? "10 entrevistas · Pasa 6/10" : "8 prácticas · Pasa 12/16"
        case .chinese: return is100Track ? "10组面试 · 通过需6/10" : "8组练习 · 通过需12/16"
        }
    }

    private var switchTrackLabel: String {
        switch language {
        case .english: return "Switch"
        case .nepali:  return "परिवर्तन"
        case .spanish: return "Cambiar"
        case .chinese: return "切换"
        }
    }
}
