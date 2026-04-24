//
//  PracticeSelectionView.swift
//

import SwiftUI

// MARK: - Helper struct to bundle each destination
private struct PracticeItem: Identifiable {
    var id: Int { level }
    let title: String
    let view: AnyView
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
                    view: AnyView(QuizView(config: .english(questions: EnglishQuestions.practice1), level: 1)),
                    minHeight: 20,
                    fontSize: 16,
                    level: 1
                ),
                PracticeItem(
                    title: "Practice 2 – Easy",
                    view: AnyView(QuizView(config: .english(questions: EnglishQuestions.practice2), level: 2)),
                    minHeight: 25,
                    fontSize: 18,
                    level: 2
                ),
                PracticeItem(
                    title: "Practice 3 – Medium",
                    view: AnyView(QuizView(config: .english(questions: EnglishQuestions.practice3), level: 3)),
                    minHeight: 30,
                    fontSize: 20,
                    level: 3
                ),
                PracticeItem(
                    title: "Practice 4 – Hard",
                    view: AnyView(QuizView(config: .english(questions: EnglishQuestions.practice4), level: 4)),
                    minHeight: 35,
                    fontSize: 22,
                    level: 4
                ),
                PracticeItem(
                    title: "Practice 5 – Expert",
                    view: AnyView(QuizView(config: .english(questions: EnglishQuestions.practice5), level: 5)),
                    minHeight: 40,
                    fontSize: 24,
                    level: 5
                )
            ]

        case .nepali:
            return [
                PracticeItem(
                    title: "पहिलो अभ्यास – सजिलो प्रश्नहरू",
                    view: AnyView(QuizView(config: .nepali(questions: NepaliQuestions.practice1), level: 1)),
                    minHeight: 20,
                    fontSize: 16,
                    level: 1
                ),
                PracticeItem(
                    title: "दोस्रो अभ्यास – सजिलो प्रश्नहरू",
                    view: AnyView(QuizView(config: .nepali(questions: NepaliQuestions.practice2), level: 2)),
                    minHeight: 25,
                    fontSize: 18,
                    level: 2
                ),
                PracticeItem(
                    title: "तेस्रो अभ्यास – मध्यम प्रश्नहरू",
                    view: AnyView(QuizView(config: .nepali(questions: NepaliQuestions.practice3), level: 3)),
                    minHeight: 30,
                    fontSize: 20,
                    level: 3
                ),
                PracticeItem(
                    title: "चौथो अभ्यास – कठिन प्रश्नहरू",
                    view: AnyView(QuizView(config: .nepali(questions: NepaliQuestions.practice4), level: 4)),
                    minHeight: 35,
                    fontSize: 22,
                    level: 4
                ),
                PracticeItem(
                    title: "पाँचौं अभ्यास – अति कठिन प्रश्नहरू",
                    view: AnyView(QuizView(config: .nepali(questions: NepaliQuestions.practice5), level: 5)),
                    minHeight: 40,
                    fontSize: 24,
                    level: 5
                )
            ]

        case .spanish:
            return [
                PracticeItem(
                    title: "Práctica 1 – Preguntas fáciles",
                    view: AnyView(QuizView(config: .spanish(questions: SpanishQuestions.practice1), level: 1)),
                    minHeight: 20,
                    fontSize: 16,
                    level: 1
                ),
                PracticeItem(
                    title: "Práctica 2 – Preguntas fáciles",
                    view: AnyView(QuizView(config: .spanish(questions: SpanishQuestions.practice2), level: 2)),
                    minHeight: 25,
                    fontSize: 18,
                    level: 2
                ),
                PracticeItem(
                    title: "Práctica 3 – Preguntas intermedias",
                    view: AnyView(QuizView(config: .spanish(questions: SpanishQuestions.practice3), level: 3)),
                    minHeight: 30,
                    fontSize: 20,
                    level: 3
                ),
                PracticeItem(
                    title: "Práctica 4 – Preguntas difíciles",
                    view: AnyView(QuizView(config: .spanish(questions: SpanishQuestions.practice4), level: 4)),
                    minHeight: 35,
                    fontSize: 22,
                    level: 4
                ),
                PracticeItem(
                    title: "Práctica 5 – Preguntas muy difíciles",
                    view: AnyView(QuizView(config: .spanish(questions: SpanishQuestions.practice5), level: 5)),
                    minHeight: 40,
                    fontSize: 24,
                    level: 5
                )
            ]

        case .chinese:
            return [
                PracticeItem(
                    title: "练习 1 – 简单问题",
                    view: AnyView(QuizView(config: .chinese(questions: ChineseQuestions.practice1), level: 1)),
                    minHeight: 20,
                    fontSize: 16,
                    level: 1
                ),
                PracticeItem(
                    title: "练习 2 – 简单问题",
                    view: AnyView(QuizView(config: .chinese(questions: ChineseQuestions.practice2), level: 2)),
                    minHeight: 25,
                    fontSize: 18,
                    level: 2
                ),
                PracticeItem(
                    title: "练习 3 – 中等问题",
                    view: AnyView(QuizView(config: .chinese(questions: ChineseQuestions.practice3), level: 3)),
                    minHeight: 30,
                    fontSize: 20,
                    level: 3
                ),
                PracticeItem(
                    title: "练习 4 – 困难问题",
                    view: AnyView(QuizView(config: .chinese(questions: ChineseQuestions.practice4), level: 4)),
                    minHeight: 35,
                    fontSize: 22,
                    level: 4
                ),
                PracticeItem(
                    title: "练习 5 – 最难问题",
                    view: AnyView(QuizView(config: .chinese(questions: ChineseQuestions.practice5), level: 5)),
                    minHeight: 40,
                    fontSize: 24,
                    level: 5
                )
            ]
        }
    }

    // MARK: - Language-specific UI

    private var s: UIStrings { UIStrings.forLanguage(language) }

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
                    VStack(spacing: 6) {
                        Text(s.pickPractice)
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 12)

                    // Language selector
                    Menu {
                        ForEach(AppLanguage.allCases) { lang in
                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) { language = lang }
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
                        HStack(spacing: 8) {
                            Text("\(language.flag) \(language.displayName)")
                                .font(.subheadline.bold())
                                .foregroundColor(.white)
                            Image(systemName: "chevron.down")
                                .font(.caption.bold())
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.08))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                    }

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

                    // Interview countdown banner
                    if let date = ProgressManager.shared.interviewDate, date > Date() {
                        let days = max(0, Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0)
                        NavigationLink(destination: InterviewChecklistView().navigationTitle(s.navInterviewChecklist)) {
                            HStack(spacing: 12) {
                                Image(systemName: "calendar.badge.clock")
                                    .font(.system(size: 22))
                                    .foregroundColor(.blue)
                                Text(String(format: s.daysUntilInterviewFormat, days))
                                    .font(.subheadline.bold())
                                    .foregroundColor(.white)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white.opacity(0.4))
                            }
                            .padding(14)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue.opacity(0.15)))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.blue.opacity(0.3), lineWidth: 1))
                        }
                        .padding(.horizontal, 20)
                    }

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
                    ForEach(items) { item in
                        let locked = item.level >= 4 && !store.isPro
                        let meta = levelMeta(item.level)

                        if locked {
                            Button {
                                paywallTrigger = "locked_level"
                                showPaywall = true
                            } label: { levelRow(item: item, meta: meta, locked: true) }
                        } else {
                            NavigationLink(
                                destination: item.view
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
        .navigationTitle(s.navPracticeSelection)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
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

    // MARK: - Readiness Card

    private var readinessCard: some View {
        let tracker = tracker
        let total = 75 // questions per language
        let mastered = tracker.masteredCount
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
        let records = tracker.records
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
