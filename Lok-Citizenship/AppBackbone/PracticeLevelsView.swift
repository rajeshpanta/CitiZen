//
//  PracticeLevelsView.swift
//
//  Hosts the 5 practice-level cards extracted from PracticeSelectionView so
//  the parent screen stays uncluttered. Behavior is identical to the prior
//  inline section: same paywall gate (Practice 3+ requires Pro), same
//  recommendation badge, same `LazyView` lazy-init pattern that keeps
//  throwaway STT services from being constructed on every body render.
//

import SwiftUI

// MARK: - Cross-view navigation intent
//
// Lightweight value-passing mechanism so QuizView's result screen can
// hand an "open level N next" signal back up to PracticeLevelsView
// without forcing PracticeLevelsView to observe a publisher. The long
// comment further down in PracticeLevelsView explains why this view
// must never observe state that mutates during an active quiz: any
// publish-driven re-render rebuilds the NavigationLink destinations
// and pops the active QuizView mid-quiz.
//
// Therefore this class is intentionally NOT an ObservableObject and
// the property is NOT @Published. QuizView writes the level; the
// PracticeLevelsView reads it inside `.onAppear` after the pop has
// completed, then immediately clears it so it can't re-fire.
final class NavigationIntent {
    static let shared = NavigationIntent()
    /// When set, PracticeLevelsView will programmatically push the
    /// matching level on its next .onAppear. Cleared on consumption.
    var pendingPracticeLevel: Int?
    /// Phase 2: After finishing a Reading or Writing test, the user can
    /// tap a "Try the other one" button. This carries the target, and
    /// PracticeSelectionView pushes the matching destination on its next
    /// .onAppear. Cleared on consumption.
    var pendingReadingWriting: ReadingWritingTarget?
    private init() {}

    enum ReadingWritingTarget { case reading, writing }
}

// MARK: - Helper struct to bundle each destination
private struct PracticeItem: Identifiable, Hashable {
    var id: Int { level }
    let title: String
    /// Builds the destination view on demand. Stored as a closure rather
    /// than an `AnyView` so the wrapped `QuizView` (which allocates a
    /// `UnifiedQuizLogic`, a `WhisperSTTService`, and a
    /// `VoiceQuizController` in its `init`) is only constructed when the
    /// user actually navigates into a level — not on every body render of
    /// the selection screen.
    let buildView: () -> AnyView
    let level: Int   // 1-5 (or 1-8 for English), used for gating

    static func == (lhs: PracticeItem, rhs: PracticeItem) -> Bool { lhs.level == rhs.level }
    func hash(into hasher: inout Hasher) { hasher.combine(level) }
}

// MARK: - Per-language item caches (file-scope, computed once)
//
// These arrays must be `let` constants — NOT a computed property on
// PracticeLevelsView. SwiftUI re-evaluates `body` whenever a parent
// re-renders or any observed object publishes (e.g.
// `PracticeSelectionView` observes `QuestionTracker.shared`, which
// publishes on every quiz answer). If the items array were computed
// inside `body`, every re-render would build new `PracticeItem`
// instances with brand-new `buildView` closures. SwiftUI would treat
// the NavigationLink destination as having changed identity and pop
// the currently-active QuizView mid-quiz — causing the user-visible
// "tap an answer → quiz exits" bug.
//
// Storing the arrays at file scope guarantees that the closure
// identities are stable across the entire app lifetime, so an active
// quiz survives any cascading re-render of its ancestor screens.

private let englishPracticeItems: [PracticeItem] = [
    PracticeItem(
        title: "Practice 1 – Government Basics & Symbols",
        buildView: { AnyView(QuizView(config: .english(questions: EnglishQuestions.practice1), level: 1)) },
        level: 1
    ),
    PracticeItem(
        title: "Practice 2 – Constitution & Amendments",
        buildView: { AnyView(QuizView(config: .english(questions: EnglishQuestions.practice2), level: 2)) },
        level: 2
    ),
    PracticeItem(
        title: "Practice 3 – Congress: Structure & Powers",
        buildView: { AnyView(QuizView(config: .english(questions: EnglishQuestions.practice3), level: 3)) },
        level: 3
    ),
    PracticeItem(
        title: "Practice 4 – Congress & Executive",
        buildView: { AnyView(QuizView(config: .english(questions: EnglishQuestions.practice4), level: 4)) },
        level: 4
    ),
    PracticeItem(
        title: "Practice 5 – Judicial, Federalism & Rights",
        buildView: { AnyView(QuizView(config: .english(questions: EnglishQuestions.practice5), level: 5)) },
        level: 5
    ),
    PracticeItem(
        title: "Practice 6 – Founding Era & Revolution",
        buildView: { AnyView(QuizView(config: .english(questions: EnglishQuestions.practice6), level: 6)) },
        level: 6
    ),
    PracticeItem(
        title: "Practice 7 – 1800s & National Identity",
        buildView: { AnyView(QuizView(config: .english(questions: EnglishQuestions.practice7), level: 7)) },
        level: 7
    ),
    PracticeItem(
        title: "Practice 8 – 1900s & Modern History",
        buildView: { AnyView(QuizView(config: .english(questions: EnglishQuestions.practice8), level: 8)) },
        level: 8
    )
]

private let nepaliPracticeItems: [PracticeItem] = [
    PracticeItem(
        title: "अभ्यास १ – सरकारी आधार र प्रतीकहरू",
        buildView: { AnyView(QuizView(config: .nepali(questions: NepaliQuestions.practice1), level: 1)) },
        level: 1
    ),
    PracticeItem(
        title: "अभ्यास २ – संविधान र संशोधनहरू",
        buildView: { AnyView(QuizView(config: .nepali(questions: NepaliQuestions.practice2), level: 2)) },
        level: 2
    ),
    PracticeItem(
        title: "अभ्यास ३ – कांग्रेस: संरचना र शक्ति",
        buildView: { AnyView(QuizView(config: .nepali(questions: NepaliQuestions.practice3), level: 3)) },
        level: 3
    ),
    PracticeItem(
        title: "अभ्यास ४ – कांग्रेस र कार्यपालिका",
        buildView: { AnyView(QuizView(config: .nepali(questions: NepaliQuestions.practice4), level: 4)) },
        level: 4
    ),
    PracticeItem(
        title: "अभ्यास ५ – न्यायपालिका, संघीयता र अधिकार",
        buildView: { AnyView(QuizView(config: .nepali(questions: NepaliQuestions.practice5), level: 5)) },
        level: 5
    ),
    PracticeItem(
        title: "अभ्यास ६ – स्थापना युग र क्रान्ति",
        buildView: { AnyView(QuizView(config: .nepali(questions: NepaliQuestions.practice6), level: 6)) },
        level: 6
    ),
    PracticeItem(
        title: "अभ्यास ७ – १८०० का दशक र राष्ट्रिय पहिचान",
        buildView: { AnyView(QuizView(config: .nepali(questions: NepaliQuestions.practice7), level: 7)) },
        level: 7
    ),
    PracticeItem(
        title: "अभ्यास ८ – १९०० का दशक र आधुनिक इतिहास",
        buildView: { AnyView(QuizView(config: .nepali(questions: NepaliQuestions.practice8), level: 8)) },
        level: 8
    )
]

private let spanishPracticeItems: [PracticeItem] = [
    PracticeItem(
        title: "Práctica 1 – Gobierno básico y símbolos",
        buildView: { AnyView(QuizView(config: .spanish(questions: SpanishQuestions.practice1), level: 1)) },
        level: 1
    ),
    PracticeItem(
        title: "Práctica 2 – Constitución y enmiendas",
        buildView: { AnyView(QuizView(config: .spanish(questions: SpanishQuestions.practice2), level: 2)) },
        level: 2
    ),
    PracticeItem(
        title: "Práctica 3 – Congreso: estructura y poderes",
        buildView: { AnyView(QuizView(config: .spanish(questions: SpanishQuestions.practice3), level: 3)) },
        level: 3
    ),
    PracticeItem(
        title: "Práctica 4 – Congreso y ejecutivo",
        buildView: { AnyView(QuizView(config: .spanish(questions: SpanishQuestions.practice4), level: 4)) },
        level: 4
    ),
    PracticeItem(
        title: "Práctica 5 – Judicial, federalismo y derechos",
        buildView: { AnyView(QuizView(config: .spanish(questions: SpanishQuestions.practice5), level: 5)) },
        level: 5
    ),
    PracticeItem(
        title: "Práctica 6 – Era fundacional y revolución",
        buildView: { AnyView(QuizView(config: .spanish(questions: SpanishQuestions.practice6), level: 6)) },
        level: 6
    ),
    PracticeItem(
        title: "Práctica 7 – Siglo XIX e identidad nacional",
        buildView: { AnyView(QuizView(config: .spanish(questions: SpanishQuestions.practice7), level: 7)) },
        level: 7
    ),
    PracticeItem(
        title: "Práctica 8 – Siglo XX e historia moderna",
        buildView: { AnyView(QuizView(config: .spanish(questions: SpanishQuestions.practice8), level: 8)) },
        level: 8
    )
]

private let chinesePracticeItems: [PracticeItem] = [
    PracticeItem(
        title: "练习 1 – 政府基础与符号",
        buildView: { AnyView(QuizView(config: .chinese(questions: ChineseQuestions.practice1), level: 1)) },
        level: 1
    ),
    PracticeItem(
        title: "练习 2 – 宪法与修正案",
        buildView: { AnyView(QuizView(config: .chinese(questions: ChineseQuestions.practice2), level: 2)) },
        level: 2
    ),
    PracticeItem(
        title: "练习 3 – 国会:结构与权力",
        buildView: { AnyView(QuizView(config: .chinese(questions: ChineseQuestions.practice3), level: 3)) },
        level: 3
    ),
    PracticeItem(
        title: "练习 4 – 国会与行政",
        buildView: { AnyView(QuizView(config: .chinese(questions: ChineseQuestions.practice4), level: 4)) },
        level: 4
    ),
    PracticeItem(
        title: "练习 5 – 司法、联邦制与权利",
        buildView: { AnyView(QuizView(config: .chinese(questions: ChineseQuestions.practice5), level: 5)) },
        level: 5
    ),
    PracticeItem(
        title: "练习 6 – 建国时期与革命",
        buildView: { AnyView(QuizView(config: .chinese(questions: ChineseQuestions.practice6), level: 6)) },
        level: 6
    ),
    PracticeItem(
        title: "练习 7 – 19 世纪与国家认同",
        buildView: { AnyView(QuizView(config: .chinese(questions: ChineseQuestions.practice7), level: 7)) },
        level: 7
    ),
    PracticeItem(
        title: "练习 8 – 20 世纪与现代史",
        buildView: { AnyView(QuizView(config: .chinese(questions: ChineseQuestions.practice8), level: 8)) },
        level: 8
    )
]

struct PracticeLevelsView: View {
    let language: AppLanguage

    @ObservedObject private var store = StoreManager.shared
    @State private var showPaywall = false
    @State private var paywallTrigger = "locked_level"

    // MARK: - Programmatic next-level push state
    //
    // Driven by `NavigationIntent.shared.pendingPracticeLevel` consumed
    // on `.onAppear`. Both @State vars are set synchronously in the same
    // SwiftUI update cycle (no asyncAfter) so there is no window where a
    // parent re-render can nil pendingPushItem while pushNext is still true.
    @State private var pendingPushItem: PracticeItem?
    @State private var pushNext: Bool = false

    private var s: UIStrings { UIStrings.forLanguage(language) }

    /// Returns the cached per-language items array. The arrays themselves
    /// are file-scope `let` constants (above) so that closure identities
    /// stay stable across body re-renders — see the long comment near
    /// `englishPracticeItems` for the bug history.
    private var items: [PracticeItem] {
        switch language {
        case .english: return englishPracticeItems
        case .nepali:  return nepaliPracticeItems
        case .spanish: return spanishPracticeItems
        case .chinese: return chinesePracticeItems
        }
    }

    private func levelMeta(_ level: Int) -> (label: String, color: Color, icon: String) {
        switch level {
        case 1: return (s.levelEasy,     .green,  "1.circle.fill")
        case 2: return (s.levelMedium,   .cyan,   "2.circle.fill")
        case 3: return (s.levelHard,     .orange, "3.circle.fill")
        case 4: return (s.levelAdvanced, .pink,   "4.circle.fill")
        case 5: return (s.levelExpert,   .red,    "5.circle.fill")
        // 6-8 are English-only (other languages stop at 5). Difficulty
        // labels continue the Easy → Expert progression: Master → Elite
        // → Grandmaster, so each card reads as a distinct rung even
        // though the themed title carries the topic.
        case 6: return (s.levelMaster,       .purple, "6.circle.fill")
        case 7: return (s.levelElite,        .indigo, "7.circle.fill")
        case 8: return (s.levelGrandmaster,  .brown,  "8.circle.fill")
        default: return ("", .gray, "circle")
        }
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
                    HStack {
                        Text(s.practiceLevels)
                            .font(.caption.bold())
                            .foregroundColor(.white.opacity(0.35))
                            .textCase(.uppercase)
                            .tracking(1)
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)

                    // Free tier: Practice 1 (Easy) + Practice 2 (Easy) only.
                    // Pro: Practice 3 (Medium), 4 (Hard), 5 (Advanced).
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

                    Spacer().frame(height: 40)
                }
            }
        }
        .navigationTitle(s.navCivicsPractice)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showPaywall) {
            PaywallView(trigger: paywallTrigger, language: language)
        }
        // Programmatic push for the "Next Level" intent from QuizView.
        // Coexists with the inline NavigationLink destinations the
        // levels list uses — those handle user-initiated taps, this
        // handles the back-then-forward auto-push.
        .navigationDestination(isPresented: $pushNext) {
            if let item = pendingPushItem {
                LazyView { item.buildView() }
                    .navigationTitle(item.title)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onAppear { consumeNavigationIntent() }
        // NOTE: deliberately NOT observing `QuestionTracker.shared` here.
        // Every quiz answer publishes a `records` change; if this view
        // observed it, the resulting re-render would rebuild the
        // NavigationLink destinations (`LazyView { item.buildView() }`)
        // and SwiftUI would pop the currently-active QuizView mid-quiz.
        // The screen's only dynamic display — the "Recommended" badge —
        // reads from `ProgressManager.recommendedLevel`, which is set
        // once during onboarding and never mutated by quiz answers, so
        // no live observation is needed.
    }

    /// Reads `NavigationIntent.shared.pendingPracticeLevel` (set by
    /// QuizView's "Next Level" button) and either programmatically
    /// pushes the matching level or shows the paywall if locked. The
    /// intent is cleared on read so it cannot fire twice.
    ///
    /// Called from `.onAppear`, which runs after a child QuizView pops.
    /// Safe to call on every appearance — a nil intent is a no-op so
    /// the initial appearance (and any normal back-navigation) doesn't
    /// trigger anything.
    private func consumeNavigationIntent() {
        guard let nextLevel = NavigationIntent.shared.pendingPracticeLevel else { return }
        NavigationIntent.shared.pendingPracticeLevel = nil
        guard let match = items.first(where: { $0.level == nextLevel }) else { return }
        // Defensive paywall re-check (QuizView already gates, but a
        // belt-and-braces guard ensures any future entry-point that
        // forgets to gate still hits the paywall here).
        if match.level >= 3 && !store.isPro {
            paywallTrigger = "locked_level"
            showPaywall = true
            return
        }
        // Set item and trigger synchronously in the same update cycle so
        // no parent re-render can nil pendingPushItem before pushNext fires.
        pendingPushItem = match
        pushNext = true
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
