//
//  PracticeSelectionView.swift
//

import SwiftUI

// MARK: - Helper struct to bundle each destination
private struct PracticeItem: Identifiable {
    var id: Int { level }
    let title: String
    /// Builds the destination view on demand. Stored as a closure rather
    /// than an `AnyView` so the wrapped `QuizView` (which allocates a
    /// `UnifiedQuizLogic`, a `WhisperSTTService`, and a
    /// `VoiceQuizController` in its `init`) is only constructed when the
    /// user actually navigates into a level — not on every body render of
    /// the selection screen. Combined with `LazyView` at the call site,
    /// this keeps the 5 destination links from churning ~5 throwaway STT
    /// services + interruption observers per re-render.
    let buildView: () -> AnyView
    let minHeight: CGFloat
    let fontSize: CGFloat
    let level: Int   // 1-5, used for gating
}

struct PracticeSelectionView: View {
    @State var language: AppLanguage

    @ObservedObject private var store = StoreManager.shared
    @ObservedObject private var tracker = QuestionTracker.shared
    @State private var showPaywall = false
    @State private var paywallTrigger = "locked_level"

    /// Per-language dismissal flag for the "voice pack missing" banner. Reading
    /// from UserDefaults on every eval is cheap enough; setting when dismissed.
    @State private var voicePackBannerBump = 0  // invalidates the computed property on dismiss

    private var voicePackBannerDismissedKey: String {
        "pm_voicePackWarningDismissed_\(language.rawValue)"
    }

    private var shouldShowVoicePackBanner: Bool {
        _ = voicePackBannerBump  // depend on state so SwiftUI re-evaluates after dismiss
        guard language != .english else { return false }
        guard !VoiceAvailability.hasUsableVoice(for: language.rawValue) else { return false }
        return !UserDefaults.standard.bool(forKey: voicePackBannerDismissedKey)
    }

    private var items: [PracticeItem] {
        switch language {
        case .english:
            return [
                PracticeItem(
                    title: "Practice 1 – Very Easy",
                    buildView: { AnyView(QuizView(config: .english(questions: EnglishQuestions.practice1), level: 1)) },
                    minHeight: 20,
                    fontSize: 16,
                    level: 1
                ),
                PracticeItem(
                    title: "Practice 2 – Easy",
                    buildView: { AnyView(QuizView(config: .english(questions: EnglishQuestions.practice2), level: 2)) },
                    minHeight: 25,
                    fontSize: 18,
                    level: 2
                ),
                PracticeItem(
                    title: "Practice 3 – Medium",
                    buildView: { AnyView(QuizView(config: .english(questions: EnglishQuestions.practice3), level: 3)) },
                    minHeight: 30,
                    fontSize: 20,
                    level: 3
                ),
                PracticeItem(
                    title: "Practice 4 – Hard",
                    buildView: { AnyView(QuizView(config: .english(questions: EnglishQuestions.practice4), level: 4)) },
                    minHeight: 35,
                    fontSize: 22,
                    level: 4
                ),
                PracticeItem(
                    title: "Practice 5 – Expert",
                    buildView: { AnyView(QuizView(config: .english(questions: EnglishQuestions.practice5), level: 5)) },
                    minHeight: 40,
                    fontSize: 24,
                    level: 5
                )
            ]

        case .nepali:
            return [
                PracticeItem(
                    title: "पहिलो अभ्यास – सजिलो प्रश्नहरू",
                    buildView: { AnyView(QuizView(config: .nepali(questions: NepaliQuestions.practice1), level: 1)) },
                    minHeight: 20,
                    fontSize: 16,
                    level: 1
                ),
                PracticeItem(
                    title: "दोस्रो अभ्यास – सजिलो प्रश्नहरू",
                    buildView: { AnyView(QuizView(config: .nepali(questions: NepaliQuestions.practice2), level: 2)) },
                    minHeight: 25,
                    fontSize: 18,
                    level: 2
                ),
                PracticeItem(
                    title: "तेस्रो अभ्यास – मध्यम प्रश्नहरू",
                    buildView: { AnyView(QuizView(config: .nepali(questions: NepaliQuestions.practice3), level: 3)) },
                    minHeight: 30,
                    fontSize: 20,
                    level: 3
                ),
                PracticeItem(
                    title: "चौथो अभ्यास – कठिन प्रश्नहरू",
                    buildView: { AnyView(QuizView(config: .nepali(questions: NepaliQuestions.practice4), level: 4)) },
                    minHeight: 35,
                    fontSize: 22,
                    level: 4
                ),
                PracticeItem(
                    title: "पाँचौं अभ्यास – अति कठिन प्रश्नहरू",
                    buildView: { AnyView(QuizView(config: .nepali(questions: NepaliQuestions.practice5), level: 5)) },
                    minHeight: 40,
                    fontSize: 24,
                    level: 5
                )
            ]

        case .spanish:
            return [
                PracticeItem(
                    title: "Práctica 1 – Preguntas fáciles",
                    buildView: { AnyView(QuizView(config: .spanish(questions: SpanishQuestions.practice1), level: 1)) },
                    minHeight: 20,
                    fontSize: 16,
                    level: 1
                ),
                PracticeItem(
                    title: "Práctica 2 – Preguntas fáciles",
                    buildView: { AnyView(QuizView(config: .spanish(questions: SpanishQuestions.practice2), level: 2)) },
                    minHeight: 25,
                    fontSize: 18,
                    level: 2
                ),
                PracticeItem(
                    title: "Práctica 3 – Preguntas intermedias",
                    buildView: { AnyView(QuizView(config: .spanish(questions: SpanishQuestions.practice3), level: 3)) },
                    minHeight: 30,
                    fontSize: 20,
                    level: 3
                ),
                PracticeItem(
                    title: "Práctica 4 – Preguntas difíciles",
                    buildView: { AnyView(QuizView(config: .spanish(questions: SpanishQuestions.practice4), level: 4)) },
                    minHeight: 35,
                    fontSize: 22,
                    level: 4
                ),
                PracticeItem(
                    title: "Práctica 5 – Preguntas muy difíciles",
                    buildView: { AnyView(QuizView(config: .spanish(questions: SpanishQuestions.practice5), level: 5)) },
                    minHeight: 40,
                    fontSize: 24,
                    level: 5
                )
            ]

        case .chinese:
            return [
                PracticeItem(
                    title: "练习 1 – 简单问题",
                    buildView: { AnyView(QuizView(config: .chinese(questions: ChineseQuestions.practice1), level: 1)) },
                    minHeight: 20,
                    fontSize: 16,
                    level: 1
                ),
                PracticeItem(
                    title: "练习 2 – 简单问题",
                    buildView: { AnyView(QuizView(config: .chinese(questions: ChineseQuestions.practice2), level: 2)) },
                    minHeight: 25,
                    fontSize: 18,
                    level: 2
                ),
                PracticeItem(
                    title: "练习 3 – 中等问题",
                    buildView: { AnyView(QuizView(config: .chinese(questions: ChineseQuestions.practice3), level: 3)) },
                    minHeight: 30,
                    fontSize: 20,
                    level: 3
                ),
                PracticeItem(
                    title: "练习 4 – 困难问题",
                    buildView: { AnyView(QuizView(config: .chinese(questions: ChineseQuestions.practice4), level: 4)) },
                    minHeight: 35,
                    fontSize: 22,
                    level: 4
                ),
                PracticeItem(
                    title: "练习 5 – 最难问题",
                    buildView: { AnyView(QuizView(config: .chinese(questions: ChineseQuestions.practice5), level: 5)) },
                    minHeight: 40,
                    fontSize: 24,
                    level: 5
                )
            ]
        }
    }

    // MARK: - Language-specific UI

    private var s: UIStrings { UIStrings.forLanguage(language) }

    /// 2-letter abbreviation for the toolbar language chip. Mirrors what the
    /// flag emoji already conveys, so a returning user sees both at a glance:
    /// 🇺🇸 EN · 🇳🇵 NP · 🇪🇸 ES · 🇨🇳 CN. Country codes (NP/ES/CN) match the
    /// flags directly; English uses "EN" rather than "US" since the language
    /// abbreviation is more universally readable than the country one.
    private func shortCode(for lang: AppLanguage) -> String {
        switch lang {
        case .english: return "EN"
        case .nepali:  return "NP"
        case .spanish: return "ES"
        case .chinese: return "CN"
        }
    }

    private func levelMeta(_ level: Int) -> (label: String, color: Color, icon: String) {
        switch level {
        case 1: return (s.levelEasy,     .green,  "1.circle.fill")
        case 2: return (s.levelMedium,   .cyan,   "2.circle.fill")
        case 3: return (s.levelHard,     .orange, "3.circle.fill")
        case 4: return (s.levelAdvanced, .pink,   "4.circle.fill")
        case 5: return (s.levelExpert,   .red,    "5.circle.fill")
        default: return ("", .gray, "circle")
        }
    }

    /// Warns the user when iOS has no voice pack for their selected language.
    /// Without this, TTS silently falls back to an English voice that garbles
    /// non-English text. Dismissable per-language; flag persists in UserDefaults.
    private var voicePackBanner: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "speaker.slash.fill")
                .font(.footnote)
                .foregroundColor(.orange)
                .padding(.top, 2)
            Text(s.voicePackMissingMessage)
                .font(.caption)
                .foregroundColor(.white.opacity(0.85))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 6)
            Button {
                UserDefaults.standard.set(true, forKey: voicePackBannerDismissedKey)
                withAnimation { voicePackBannerBump &+= 1 }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.5))
            }
            .accessibilityLabel(s.a11yClose)
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.orange.opacity(0.1)))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange.opacity(0.35), lineWidth: 1))
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.0, green: 0.12, blue: 0.35),
                    Color(red: 0.0, green: 0.06, blue: 0.2),
                    Color.black
                ],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 14) {
                    // Header slot: rich hero card when an interview date is
                    // set, otherwise renders nothing (the `.large` nav-bar
                    // title already labels the screen, so a body greeting
                    // would duplicate it).
                    interviewHeroSection
                        .padding(.top, 12)

                    if shouldShowVoicePackBanner {
                        voicePackBanner
                    }

                    // Mock Interview card
                    Group {
                        let canAccess = store.isPro || ProgressManager.shared.canAccessFreeMockInterview
                        if canAccess {
                            NavigationLink(
                                destination: MockInterviewView(language: language)
                                    .navigationTitle(s.navMockInterview)
                                    .navigationBarTitleDisplayMode(.inline)
                            ) {
                                mockCard(
                                    locked: false,
                                    subtitle: store.isPro ? s.mockSubtitlePro : s.mockSubtitleFree
                                )
                            }
                        } else {
                            Button {
                                paywallTrigger = "mock_interview"
                                showPaywall = true
                            } label: {
                                mockCard(locked: true, subtitle: s.mockSubtitleLocked)
                            }
                        }
                    }
                    .padding(.horizontal, 20)

                    // Exam Readiness card
                    NavigationLink(
                        destination: ReadinessView(language: language)
                            .navigationTitle(s.navExamReadiness)
                            .navigationBarTitleDisplayMode(.inline)
                    ) {
                        readinessCard
                    }
                    .padding(.horizontal, 20)

                    // Review Mistakes card
                    reviewMistakesCard
                        .padding(.horizontal, 20)

                    // Section label
                    HStack {
                        Text(s.practiceLevels)
                            .font(.caption.bold())
                            .foregroundColor(.white.opacity(0.35))
                            .textCase(.uppercase)
                            .tracking(1)
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 6)

                    // Level cards
                    //
                    // Free tier: Practice 1 (Easy) + Practice 2 (Easy) only.
                    // Pro: Practice 3 (Medium), 4 (Hard), 5 (Advanced).
                    // Threshold was `>= 4` — bumped to `>= 3` to bring
                    // Medium behind the paywall too. Practice 1 and 2 stay
                    // free so a brand-new user can experience the core
                    // quiz loop before being asked to pay.
                    ForEach(items) { item in
                        let locked = item.level >= 3 && !store.isPro
                        let meta = levelMeta(item.level)

                        if locked {
                            Button {
                                paywallTrigger = "locked_level"
                                showPaywall = true
                            } label: { levelRow(item: item, meta: meta, locked: true) }
                        } else {
                            NavigationLink(
                                destination: LazyView { item.buildView() }
                                    .navigationTitle(item.title)
                                    .navigationBarTitleDisplayMode(.inline)
                            ) { levelRow(item: item, meta: meta, locked: false) }
                        }
                    }
                    .padding(.horizontal, 20)

                    // Reading & Writing section
                    HStack {
                        Text(s.readingWriting)
                            .font(.caption.bold())
                            .foregroundColor(.white.opacity(0.35))
                            .textCase(.uppercase)
                            .tracking(1)
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)

                    Group {
                        if store.isPro {
                            NavigationLink(destination: ReadingPracticeView(language: language)) {
                                featureCard(icon: "book.fill", title: s.readingPractice,
                                            subtitle: s.readingPracticeSubtitle, color: .purple)
                            }
                            NavigationLink(destination: WritingPracticeView(language: language)) {
                                featureCard(icon: "pencil.line", title: s.writingPractice,
                                            subtitle: s.writingPracticeSubtitle, color: .indigo)
                            }
                        } else {
                            Button {
                                paywallTrigger = "locked_level"
                                showPaywall = true
                            } label: {
                                featureCard(icon: "book.fill", title: s.readingPractice,
                                            subtitle: s.unlockWithPro, color: .purple, locked: true)
                            }
                            Button {
                                paywallTrigger = "locked_level"
                                showPaywall = true
                            } label: {
                                featureCard(icon: "pencil.line", title: s.writingPractice,
                                            subtitle: s.unlockWithPro, color: .indigo, locked: true)
                            }
                        }
                    }
                    .padding(.horizontal, 20)

                    // Audio-Only mode
                    HStack {
                        Text(s.handsFree)
                            .font(.caption.bold())
                            .foregroundColor(.white.opacity(0.35))
                            .textCase(.uppercase)
                            .tracking(1)
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)

                    NavigationLink(
                        destination: AudioOnlyView(language: language)
                            .navigationTitle(s.navAudioOnly)
                            .navigationBarTitleDisplayMode(.inline)
                    ) {
                        featureCard(icon: "headphones.circle.fill", title: s.audioOnly,
                                    subtitle: s.audioOnlySubtitle, color: .teal)
                    }
                    .padding(.horizontal, 20)

                    Spacer().frame(height: 40)
                }
            }
        }
        // Nav-bar title carries the screen's purpose ("Pick a Practice")
        // so we don't need a redundant body greeting. Inline display
        // matches the rest of the app's nav-bar style.
        .navigationTitle(s.pickPractice)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Menu {
                    ForEach(AppLanguage.allCases) { lang in
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) { language = lang }
                            // Persist so the choice survives relaunch.
                            // Without this, the picker was session-only
                            // and the next cold launch reverted to the
                            // onboarding-set language.
                            ProgressManager.shared.preferredLanguage = lang.rawValue
                            // Reschedule local notifications so daily /
                            // streak reminders fire in the new language.
                            // `localizedStrings` in NotificationManager
                            // reads `pm_preferredLanguage` at schedule
                            // time, so this only works because we
                            // persisted above.
                            if NotificationManager.shared.isEnabled {
                                NotificationManager.shared.scheduleAll()
                            }
                            Analytics.track(.languageSelected(language: lang.rawValue))
                        } label: {
                            HStack {
                                Text("\(lang.flag) \(lang.displayName)")
                                if language == lang {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(language.flag)
                            .font(.subheadline)
                        Text(shortCode(for: language))
                            .font(.caption.bold())
                            .tracking(0.5)
                            .foregroundColor(.white.opacity(0.85))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.08))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
                }
                .accessibilityLabel(language.displayName)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: SettingsView(language: language)) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.white.opacity(0.6))
                }
                .accessibilityLabel(s.navSettings)
            }
        }
        .onAppear {
            // Force SwiftUI to re-read tracker data when returning from a quiz.
            // NavigationView doesn't always re-render parent views on pop.
            tracker.objectWillChange.send()
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(trigger: paywallTrigger, language: language)
        }
    }

    // MARK: - Sub-views

    private func mockCard(locked: Bool, subtitle: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: "mic.badge.plus")
                .font(.system(size: 26))
                .foregroundColor(locked ? .white.opacity(0.4) : .white)
                .frame(width: 40)
            VStack(alignment: .leading, spacing: 3) {
                Text(s.mockInterview)
                    .font(.headline)
                    .foregroundColor(locked ? .white.opacity(0.5) : .white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(locked ? .white.opacity(0.3) : .white.opacity(0.6))
            }
            Spacer()
            Image(systemName: locked ? "lock.fill" : "chevron.right")
                .foregroundColor(.white.opacity(locked ? 0.3 : 0.4))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.06))
                .opacity(locked ? 1 : 0)
        )
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(LinearGradient(colors: [.blue.opacity(0.6), .blue.opacity(0.3)],
                                     startPoint: .leading, endPoint: .trailing))
                .opacity(locked ? 0 : 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(locked ? Color.white.opacity(0.08) : Color.blue.opacity(0.4), lineWidth: 1)
        )
    }

    // MARK: - Interview Hero Section

    /// Whole-day-aligned days from today to interview. Negative when past.
    /// `startOfDay` on both sides keeps "today" stable through the entire
    /// interview day — picking 09:00 still reads as 0 at 9 PM the same day.
    private func daysUntilInterview(_ date: Date) -> Int {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        let target = cal.startOfDay(for: date)
        return cal.dateComponents([.day], from: today, to: target).day ?? 0
    }

    /// Linear on-track curve: target mastery climbs ~2 percentage points per
    /// day toward 90% on day-of. 30 days out → ≥30% to be on track; 14 days
    /// → ≥62%; 7 days → ≥76%. Behind the curve goes orange — or red if
    /// ≤7 days, since runway to recover is short.
    private func interviewAccent(daysOut: Int, pct: Int) -> Color {
        let target = max(0, 90 - daysOut * 2)
        if pct >= target { return .green }
        return daysOut <= 7 ? .red : .orange
    }

    /// The header slot. Renders the rich hero when an interview date is set
    /// (future or today). When no date is scheduled (or the saved date is in
    /// the past), nothing renders here — the `.large` nav-bar title already
    /// provides the screen header, so adding a body greeting would just be
    /// the same label twice.
    @ViewBuilder
    private var interviewHeroSection: some View {
        if let date = ProgressManager.shared.interviewDate {
            let days = daysUntilInterview(date)
            if days > 0 {
                interviewHeroFuture(days: days, date: date)
            } else if days == 0 {
                interviewHeroToday
            }
        }
    }

    private func interviewHeroFuture(days: Int, date: Date) -> some View {
        let total = 75
        let mastered = tracker.masteredCount(for: language.rawValue)
        let pct = total > 0 ? (mastered * 100) / total : 0
        let remaining = max(0, total - mastered)
        // Ceiling division: 17 questions over 5 days → 4/day, not 3
        // (which would leave the user short on the last day).
        let dailyTarget = days > 0 ? (remaining + days - 1) / days : remaining
        let accent = interviewAccent(daysOut: days, pct: pct)

        return NavigationLink(
            destination: ReadinessView(language: language)
                .navigationTitle(s.navExamReadiness)
                .navigationBarTitleDisplayMode(.inline)
        ) {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                    .frame(width: 36)
                    .padding(.top, 2)
                VStack(alignment: .leading, spacing: 6) {
                    Text(String(format: s.daysUntilInterviewFormat, days))
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    Text(dailyTarget == 0
                         ? s.interviewReadyLabel
                         : String(format: s.dailyTargetSubtitleFormat, pct, dailyTarget))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.85))
                    Text(date, style: .date)
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.55))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.subheadline.bold())
                    .foregroundColor(.white.opacity(0.55))
                    .padding(.top, 4)
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [accent.opacity(0.55), accent.opacity(0.25)],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(accent.opacity(0.5), lineWidth: 1)
            )
        }
        .padding(.horizontal, 20)
    }

    private var interviewHeroToday: some View {
        NavigationLink(
            destination: ReadinessView(language: language)
                .navigationTitle(s.navExamReadiness)
                .navigationBarTitleDisplayMode(.inline)
        ) {
            HStack(alignment: .center, spacing: 14) {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                    .frame(width: 36)
                VStack(alignment: .leading, spacing: 4) {
                    Text(s.interviewTodayTitle)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(s.interviewTodaySubtitle)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.85))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.subheadline.bold())
                    .foregroundColor(.white.opacity(0.55))
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [Color.yellow.opacity(0.6), Color.orange.opacity(0.35)],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.yellow.opacity(0.55), lineWidth: 1)
            )
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Readiness Card

    private var readinessCard: some View {
        let tracker = tracker
        let total = 75 // questions per language
        // Per-language mastered count — a learner studying in Spanish
        // sees mastery of Spanish questions only, not their English or
        // Nepali progress. Mirrors the readiness ring inside
        // `ReadinessView` so the card and the dashboard always agree.
        let mastered = tracker.masteredCount(for: language.rawValue)
        let pct = total > 0 ? (mastered * 100) / total : 0

        return HStack(spacing: 14) {
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 26))
                .foregroundColor(.cyan)
                .frame(width: 40)
            VStack(alignment: .leading, spacing: 3) {
                Text(s.examReadiness)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(String(format: s.examReadinessSubtitleFormat, mastered, total, pct))
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.4))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(LinearGradient(colors: [.cyan.opacity(0.4), .cyan.opacity(0.15)],
                                     startPoint: .leading, endPoint: .trailing))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
        )
    }

    // MARK: - Review Mistakes Card

    @ViewBuilder
    private var reviewMistakesCard: some View {
        let pool = QuestionPool.allQuestions(for: language)
        // Per-language records: the user's mistakes in OTHER languages
        // must NOT show up in this language's review pool. A Nepali
        // learner who got `q_1_01` wrong in Nepali should see it for
        // review when studying in Nepali — but a Spanish learner who
        // never opened the Nepali quiz shouldn't have `q_1_01` show up
        // in their Spanish review queue.
        let records = tracker.recordsForLanguage(language.rawValue)
        let dueCount = SpacedRepetitionEngine.dueCount(from: pool, records: records)

        if dueCount > 0 {
            NavigationLink(
                destination: QuizView(
                    config: .reviewMistakes(
                        questions: SpacedRepetitionEngine.dueQuestions(from: pool, records: records),
                        language: language
                    ),
                    level: 0
                )
                .navigationTitle(s.navReviewMistakes)
                .navigationBarTitleDisplayMode(.inline)
            ) {
                HStack(spacing: 14) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(.system(size: 26))
                        .foregroundColor(.orange)
                        .frame(width: 40)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(s.reviewMistakes)
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(String(format: s.reviewMistakesSubtitleFormat, dueCount))
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    Spacer()
                    Text("\(dueCount)")
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color.orange))
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white.opacity(0.4))
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(LinearGradient(colors: [.orange.opacity(0.4), .orange.opacity(0.15)],
                                             startPoint: .leading, endPoint: .trailing))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
            }
        } else {
            HStack(spacing: 14) {
                Image(systemName: "arrow.counterclockwise.circle")
                    .font(.system(size: 26))
                    .foregroundColor(.white.opacity(0.3))
                    .frame(width: 40)
                VStack(alignment: .leading, spacing: 3) {
                    Text(s.reviewMistakes)
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.4))
                    Text(s.reviewMistakesEmpty)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.3))
                }
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white.opacity(0.03))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
            )
        }
    }

    // MARK: - Feature Card (Reading/Writing/Audio)

    private func featureCard(icon: String, title: String, subtitle: String, color: Color, locked: Bool = false) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(locked ? color.opacity(0.3) : color)
                .frame(width: 32)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(locked ? .white.opacity(0.4) : .white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(locked ? .white.opacity(0.3) : .white.opacity(0.6))
            }
            Spacer()
            Image(systemName: locked ? "lock.fill" : "chevron.right")
                .font(.caption)
                .foregroundColor(.white.opacity(locked ? 0.25 : 0.3))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(locked ? 0.03 : 0.07)))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(locked ? 0.05 : 0.1), lineWidth: 1))
    }

    private func levelRow(item: PracticeItem, meta: (label: String, color: Color, icon: String), locked: Bool) -> some View {
        let isRecommended = ProgressManager.shared.recommendedLevel == item.level && !locked
        return HStack(spacing: 14) {
            Image(systemName: meta.icon)
                .font(.system(size: 24))
                .foregroundColor(locked ? meta.color.opacity(0.3) : meta.color)
                .frame(width: 32)
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(item.title)
                        .font(.subheadline.bold())
                        .foregroundColor(locked ? .white.opacity(0.4) : .white)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    if isRecommended {
                        Text(s.recommendedBadge.uppercased())
                            .font(.caption2.bold())
                            .tracking(0.5)
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(Color.cyan))
                    }
                }
                Text(meta.label)
                    .font(.caption2)
                    .foregroundColor(locked ? meta.color.opacity(0.3) : meta.color)
            }
            Spacer()
            Image(systemName: locked ? "lock.fill" : "chevron.right")
                .font(.caption)
                .foregroundColor(.white.opacity(locked ? 0.25 : 0.3))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isRecommended
                      ? Color.cyan.opacity(0.12)
                      : Color.white.opacity(locked ? 0.03 : 0.07))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isRecommended
                        ? Color.cyan.opacity(0.45)
                        : Color.white.opacity(locked ? 0.05 : 0.1),
                        lineWidth: isRecommended ? 1.5 : 1)
        )
    }
}
