//
//  PracticeSelectionView.swift
//

import SwiftUI

struct PracticeSelectionView: View {
    @State var language: AppLanguage

    @ObservedObject private var store = StoreManager.shared
    /// `QuestionTracker.shared` is accessed as a plain reference — NOT
    /// observed — because @ObservedObject re-renders this view on every
    /// `records` publish, which fires on every quiz answer. That cascading
    /// re-render recreates the `PracticeLevelsView(language:)` value at
    /// the NavigationLink destination; under iOS 26 NavigationView, the
    /// new destination identity pops the currently-active QuizView two
    /// levels down ("tap an answer → quiz exits" bug). Fresh data is
    /// pulled into `readinessCard`, `reviewMistakesCard`, and the
    /// interview hero by bumping `trackerVersion` on `.onAppear`, which
    /// makes those computed properties re-evaluate when the user returns
    /// from a quiz.
    private let tracker = QuestionTracker.shared
    @State private var trackerVersion = 0
    @State private var showPaywall = false
    @State private var paywallTrigger = "locked_level"

    /// Per-language dismissal flag for the "voice pack missing" banner. Reading
    /// from UserDefaults on every eval is cheap enough; setting when dismissed.
    @State private var voicePackBannerBump = 0  // invalidates the computed property on dismiss

    // MARK: - Phase 2: Reading↔Writing programmatic push state
    //
    // After finishing a Reading test, the user can tap "Try Writing
    // Practice" — that sets `NavigationIntent.shared.pendingReadingWriting`
    // and dismisses the Reading flow. We consume the intent in
    // `.onAppear` (running after the pop completes) and programmatically
    // push the matching destination. Same shape as the Phase 1
    // PracticeLevelsView pattern.
    @State private var pendingReadingWritingTarget: NavigationIntent.ReadingWritingTarget?
    @State private var pushReadingWriting: Bool = false

    private var voicePackBannerDismissedKey: String {
        "pm_voicePackWarningDismissed_\(language.rawValue)"
    }

    private var shouldShowVoicePackBanner: Bool {
        _ = voicePackBannerBump  // depend on state so SwiftUI re-evaluates after dismiss
        guard language != .english else { return false }
        guard !VoiceAvailability.hasUsableVoice(for: language.rawValue) else { return false }
        return !UserDefaults.standard.bool(forKey: voicePackBannerDismissedKey)
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
                                // Append the lifetime display price when StoreKit
                                // has loaded products — gives the user a concrete
                                // anchor on the card itself instead of forcing
                                // them to open the paywall sheet to find out what
                                // unlocking costs. Falls back to the plain locked
                                // copy if products aren't ready yet (network
                                // hiccup or cold launch).
                                let subtitle: String = {
                                    if let lifetime = store.products.first(where: { $0.id == StoreManager.lifetimeID }) {
                                        return "\(s.mockSubtitleLocked) · \(lifetime.displayPrice)"
                                    }
                                    return s.mockSubtitleLocked
                                }()
                                mockCard(locked: true, subtitle: subtitle)
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

                    // Civics Practice hub: opens a sub-screen with all
                    // practice levels. Replaces the inline 5-card section
                    // so the main page stays scannable as the question bank
                    // grows beyond the original 75.
                    NavigationLink(
                        destination: PracticeLevelsView(language: language)
                    ) {
                        civicsPracticeCard
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
            // Force the body to re-evaluate `readinessCard`,
            // `reviewMistakesCard`, and the interview hero so they read
            // fresh tracker data after the user returns from a quiz.
            // Using a @State bump (instead of observing the tracker via
            // @ObservedObject) avoids the cascading mid-quiz re-renders
            // that previously popped the active QuizView.
            trackerVersion &+= 1
            consumeReadingWritingIntent()
        }
        .task {
            // Eagerly load StoreKit products so the locked Mock Interview
            // card can render its price subtitle without waiting for the
            // user to tap the card and open the paywall. `loadProducts`
            // is idempotent (cached after first success), so re-runs on
            // every view appearance are cheap.
            await store.loadProducts()
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(trigger: paywallTrigger, language: language)
        }
        // Phase 2: programmatic push to the "other" practice (Reading or
        // Writing) after the user finishes one and taps the transition
        // button. Coexists with the inline NavigationLinks for the
        // user-tap path.
        .navigationDestination(isPresented: $pushReadingWriting) {
            switch pendingReadingWritingTarget {
            case .reading: ReadingPracticeView(language: language)
            case .writing: WritingPracticeView(language: language)
            case .none:    EmptyView()
            }
        }
    }

    /// Phase 2 helper. Reads `NavigationIntent.shared.pendingReadingWriting`
    /// (set by ReadingTestView's "Try Writing" or WritingTestView's "Try
    /// Reading" button) and programmatically pushes the matching
    /// destination. Intent is cleared on read so it cannot fire twice.
    /// Safe to call on every appearance — a nil intent is a no-op.
    ///
    /// Defensive paywall re-check: Reading/Writing are Pro-only here in
    /// the same view (lines 202/211 gate the inline tap path). The
    /// transition button can only be reached *from* Reading/Writing
    /// itself — which a free user can't enter — so this guard is
    /// belt-and-braces protection for the corner case where a Pro
    /// user's entitlement lapses mid-session (StoreKit publishes
    /// `isPro = false` while they're still on the test result screen).
    /// Without it, the transition button would silently bypass the
    /// paywall.
    private func consumeReadingWritingIntent() {
        guard let target = NavigationIntent.shared.pendingReadingWriting else { return }
        NavigationIntent.shared.pendingReadingWriting = nil
        guard store.isPro else {
            paywallTrigger = "locked_level"
            showPaywall = true
            return
        }
        pendingReadingWritingTarget = target
        // Same 50 ms defer as the Phase 1 practice-level path — lets the
        // pop animation complete before the push, avoiding a visual jump
        // on iOS 16.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            pushReadingWriting = true
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
            } else {
                // Saved date is in the past (user passed their interview
                // date and either forgot to clear it or hasn't returned).
                // Fall back to the first-time hero so they see a forward
                // CTA instead of an empty header.
                firstTimeHero
            }
        } else if isFirstTimeUser {
            firstTimeHero
        }
    }

    /// True for a user with no scheduled date AND no questions yet
    /// mastered in the current language. Drives the first-time hero
    /// affordance so the home screen has a clear starting point on
    /// cold install instead of leading with a locked Mock card and
    /// a 0/128 readiness row.
    private var isFirstTimeUser: Bool {
        _ = trackerVersion
        let pool = QuestionPool.allQuestions(for: language)
        return tracker.masteredCount(for: language.rawValue, inPool: pool) == 0
    }

    /// Coaching CTA: routes the user into the Civics Practice levels
    /// hub (which lists Practice 1–8). Using a NavigationLink that
    /// targets `PracticeLevelsView` mirrors the existing Civics card's
    /// destination so the destination stays one screen, not two.
    private var firstTimeHero: some View {
        NavigationLink(destination: PracticeLevelsView(language: language)) {
            HStack(alignment: .center, spacing: 14) {
                Image(systemName: "hand.point.right.fill")
                    .font(.system(size: 26))
                    .foregroundColor(.white)
                    .frame(width: 36)
                VStack(alignment: .leading, spacing: 4) {
                    Text(s.firstTimeHeroTitle)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    Text(s.firstTimeHeroSubtitle)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.85))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.subheadline.bold())
                    .foregroundColor(.white.opacity(0.55))
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [Color.cyan.opacity(0.55), Color.blue.opacity(0.25)],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.cyan.opacity(0.5), lineWidth: 1)
            )
        }
        .padding(.horizontal, 20)
    }

    private func interviewHeroFuture(days: Int, date: Date) -> some View {
        // Re-evaluate when the user returns from a quiz (`trackerVersion`
        // is bumped in `.onAppear`). We don't observe the tracker directly
        // because mid-quiz publishes would cascade re-renders and pop the
        // active QuizView two levels down.
        _ = trackerVersion
        // All four supported languages now use the 128-question 2025 USCIS
        // bank. Reading from `QuestionPool` keeps this in sync as more
        // languages are added.
        // Passing the pool to `masteredCount` filters out orphaned records
        // from the pre-migration English layout so the % isn't inflated for
        // returning users.
        let pool = QuestionPool.allQuestions(for: language)
        let total = pool.count
        let mastered = tracker.masteredCount(for: language.rawValue, inPool: pool)
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
        // See `interviewHeroFuture` — bump-based refresh instead of
        // observation so mid-quiz tracker publishes don't pop the quiz.
        _ = trackerVersion
        let tracker = tracker
        // All four supported languages use the 128-question 2025 USCIS bank.
        // Reading from `QuestionPool` keeps this card in sync as additional
        // languages are added. Passing the pool to `masteredCount` filters
        // orphaned records so a returning user's % isn't inflated by the
        // pre-migration question layout.
        let pool = QuestionPool.allQuestions(for: language)
        let total = pool.count
        // Per-language mastered count — a learner studying in Spanish
        // sees mastery of Spanish questions only, not their English or
        // Nepali progress. Mirrors the readiness ring inside
        // `ReadinessView` so the card and the dashboard always agree.
        let mastered = tracker.masteredCount(for: language.rawValue, inPool: pool)
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
        // See `interviewHeroFuture` — bump-based refresh instead of
        // observation so mid-quiz tracker publishes don't pop the quiz.
        // `let _ =` (not bare `_ =`) is required inside @ViewBuilder.
        let _ = trackerVersion
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

    // MARK: - Civics Practice Hub Card

    private var civicsPracticeCard: some View {
        HStack(spacing: 14) {
            Image(systemName: "building.columns.fill")
                .font(.system(size: 26))
                .foregroundColor(.white)
                .frame(width: 40)
            VStack(alignment: .leading, spacing: 3) {
                Text(s.civicsPractice)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(s.civicsPracticeSubtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.85))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.55))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(LinearGradient(colors: [.indigo.opacity(0.55), .indigo.opacity(0.25)],
                                     startPoint: .leading, endPoint: .trailing))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.indigo.opacity(0.4), lineWidth: 1)
        )
    }
}
