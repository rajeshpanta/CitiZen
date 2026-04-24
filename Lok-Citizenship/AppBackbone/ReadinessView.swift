import SwiftUI

/// Dashboard showing how ready the user is for the citizenship test.
struct ReadinessView: View {

    let language: AppLanguage

    private let tracker = QuestionTracker.shared
    private let progress = ProgressManager.shared
    private let totalPerLevel = 15
    private let levelCount = 5

    private var totalQuestions: Int { totalPerLevel * levelCount }

    private var s: UIStrings { UIStrings.forLanguage(language) }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // Overall readiness ring
                readinessRing
                    .padding(.top, 20)

                // Stats row
                statsRow

                // Interview countdown
                if let date = progress.interviewDate, date > Date() {
                    countdownCard(to: date)
                }

                // Per-level breakdown
                VStack(alignment: .leading, spacing: 12) {
                    Text(s.readinessProgressByLevel)
                        .font(.caption.bold())
                        .foregroundColor(.white.opacity(0.4))
                        .textCase(.uppercase)
                        .tracking(1)

                    ForEach(1...levelCount, id: \.self) { level in
                        levelProgressRow(level: level)
                    }
                }
                .padding(.horizontal, 20)

                // F6: English reading & writing test pass-rate section.
                englishSkillsSection
                    .padding(.horizontal, 20)

                // Streak section
                streakSection
                    .padding(.horizontal, 20)

                Spacer().frame(height: 40)
            }
        }
        .background(
            LinearGradient(
                colors: [Color(red: 0, green: 0.1, blue: 0.3), .black],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }

    // MARK: - Readiness Ring

    private var readinessRing: some View {
        let mastered = tracker.masteredCount
        let pct = totalQuestions > 0 ? Double(mastered) / Double(totalQuestions) : 0

        return VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 12)
                    .frame(width: 140, height: 140)
                Circle()
                    .trim(from: 0, to: pct)
                    .stroke(readinessColor(pct), style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 2) {
                    Text("\(Int(pct * 100))%")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                    Text(s.readinessReadyLabel)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                }
            }

            Text(String(format: s.readinessMasteredFormat, mastered, totalQuestions))
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.6))
        }
    }

    // MARK: - Stats Row

    private var statsRow: some View {
        HStack(spacing: 0) {
            statItem(value: "\(tracker.masteredCount)", label: s.readinessStatMastered, color: .green)
            Divider().frame(height: 36).background(Color.white.opacity(0.2))
            statItem(value: "\(tracker.learningCount)", label: s.readinessStatLearning, color: .yellow)
            Divider().frame(height: 36).background(Color.white.opacity(0.2))
            let notStarted = max(0, totalQuestions - tracker.masteredCount - tracker.learningCount)
            statItem(value: "\(notStarted)", label: s.readinessStatNew, color: .white.opacity(0.5))
        }
        .padding(.vertical, 14)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.06)))
        .padding(.horizontal, 20)
    }

    private func statItem(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3.bold())
                .foregroundColor(color)
            Text(label)
                .font(.caption2)
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Level Progress

    private func levelProgressRow(level: Int) -> some View {
        let levelQuestions = questionsForLevel(level)
        let masteredInLevel = levelQuestions.filter { q in
            (tracker.record(for: q.id)?.consecutiveCorrect ?? 0) >= 3
        }.count
        let pct = Double(masteredInLevel) / Double(totalPerLevel)
        let labels = ["", s.levelEasy, s.levelMedium, s.levelHard, s.levelAdvanced, s.levelExpert]
        let colors: [Color] = [.clear, .green, .green, .yellow, .orange, .red]

        return HStack(spacing: 12) {
            Text("L\(level)")
                .font(.caption.bold())
                .foregroundColor(colors[level])
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(labels[level])
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                    Spacer()
                    Text("\(masteredInLevel)/\(totalPerLevel)")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.5))
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.1))
                        RoundedRectangle(cornerRadius: 4)
                            .fill(colors[level])
                            .frame(width: geo.size.width * pct)
                    }
                }
                .frame(height: 6)
            }
        }
        .padding(.vertical, 4)
    }

    // MARK: - Countdown

    private func countdownCard(to date: Date) -> some View {
        let days = max(0, Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0)

        return HStack(spacing: 14) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: 28))
                .foregroundColor(.blue)
            VStack(alignment: .leading, spacing: 2) {
                Text(String(format: s.daysUntilInterviewFormat, days))
                    .font(.headline)
                    .foregroundColor(.white)
                Text(date, style: .date)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
            }
            Spacer()
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.blue.opacity(0.15)))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.blue.opacity(0.3), lineWidth: 1))
        .padding(.horizontal, 20)
    }

    // MARK: - Streak

    private var streakSection: some View {
        HStack(spacing: 20) {
            VStack(spacing: 4) {
                Text("\(progress.currentStreak)")
                    .font(.title.bold())
                    .foregroundColor(.orange)
                Text(s.readinessCurrentStreak)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.5))
            }
            .frame(maxWidth: .infinity)

            VStack(spacing: 4) {
                Text("\(progress.longestStreak)")
                    .font(.title.bold())
                    .foregroundColor(.yellow)
                Text(s.readinessBestStreak)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.5))
            }
            .frame(maxWidth: .infinity)

            VStack(spacing: 4) {
                Text("\(progress.accuracyPercentage)%")
                    .font(.title.bold())
                    .foregroundColor(.green)
                Text(s.readinessAccuracy)
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.5))
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 16)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.06)))
    }

    // MARK: - Helpers

    private func readinessColor(_ pct: Double) -> Color {
        switch pct {
        case 0..<0.3:  return .red
        case 0.3..<0.6: return .orange
        case 0.6..<0.8: return .yellow
        default:        return .green
        }
    }

    private func questionsForLevel(_ level: Int) -> [UnifiedQuestion] {
        switch language {
        case .english:
            return [EnglishQuestions.practice1, EnglishQuestions.practice2, EnglishQuestions.practice3,
                    EnglishQuestions.practice4, EnglishQuestions.practice5][level - 1]
        case .nepali:
            return [NepaliQuestions.practice1, NepaliQuestions.practice2, NepaliQuestions.practice3,
                    NepaliQuestions.practice4, NepaliQuestions.practice5][level - 1]
        case .spanish:
            return [SpanishQuestions.practice1, SpanishQuestions.practice2, SpanishQuestions.practice3,
                    SpanishQuestions.practice4, SpanishQuestions.practice5][level - 1]
        case .chinese:
            return [ChineseQuestions.practice1, ChineseQuestions.practice2, ChineseQuestions.practice3,
                    ChineseQuestions.practice4, ChineseQuestions.practice5][level - 1]
        }
    }

    // MARK: - English Reading & Writing Skills (F6)

    /// Renders a pair of rows showing pass rate for Reading Test and Writing Test,
    /// reusing the existing "Reading & Writing" section label and the same progress-bar
    /// styling as the per-level breakdown above it. Empty state when no sessions taken.
    private var englishSkillsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(s.readingWriting)
                .font(.caption.bold())
                .foregroundColor(.white.opacity(0.4))
                .textCase(.uppercase)
                .tracking(1)

            englishTestRow(
                icon: "book.fill",
                color: .purple,
                title: s.readinessReadingTitle,
                taken: progress.readingTestsTaken,
                passed: progress.readingTestsPassed,
                passRate: progress.readingTestPassRatePercent
            )

            englishTestRow(
                icon: "pencil.line",
                color: .indigo,
                title: s.readinessWritingTitle,
                taken: progress.writingTestsTaken,
                passed: progress.writingTestsPassed,
                passRate: progress.writingTestPassRatePercent
            )
        }
    }

    private func englishTestRow(
        icon: String,
        color: Color,
        title: String,
        taken: Int,
        passed: Int,
        passRate: Int?
    ) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline.bold())
                .foregroundColor(color)
                .frame(width: 28, height: 28)
                .background(Circle().fill(color.opacity(0.15)))

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.caption.bold())
                        .foregroundColor(.white.opacity(0.85))
                    Spacer()
                    if passRate != nil {
                        Text("\(passed)/\(taken)")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.5))
                    }
                }

                if let rate = passRate {
                    // Matches levelProgressRow's bar styling exactly.
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.1))
                            RoundedRectangle(cornerRadius: 4)
                                .fill(readinessColor(Double(rate) / 100.0))
                                .frame(width: geo.size.width * Double(rate) / 100.0)
                        }
                    }
                    .frame(height: 6)

                    Text(String(format: s.readinessSessionsFormat, passed, taken, rate))
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.5))
                } else {
                    // Empty state — user hasn't taken a session yet.
                    Text(s.readinessNotStarted)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.4))
                        .padding(.top, 2)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
