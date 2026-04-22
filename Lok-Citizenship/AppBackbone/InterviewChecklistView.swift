import SwiftUI

/// USCIS interview preparation checklist with toggleable items.
struct InterviewChecklistView: View {

    @State private var checked: Set<String> = {
        let saved = UserDefaults.standard.stringArray(forKey: "pm_checklist") ?? []
        return Set(saved)
    }()

    private let sections: [(title: String, items: [(id: String, text: String)])] = [
        ("Documents to Bring", [
            ("doc_greencard", "Permanent Resident Card (Green Card)"),
            ("doc_passport", "Valid passport and travel documents"),
            ("doc_photos", "Two passport-style photos"),
            ("doc_n400", "Form N-400 appointment notice"),
            ("doc_tax", "Tax returns (last 5 years)"),
            ("doc_travel", "Travel history records"),
        ]),
        ("Before the Interview", [
            ("prep_study", "Review all 100 civics questions"),
            ("prep_reading", "Practice reading English sentences"),
            ("prep_writing", "Practice writing English sentences"),
            ("prep_bio", "Review your N-400 application answers"),
            ("prep_route", "Plan your route to the USCIS office"),
            ("prep_outfit", "Prepare business casual attire"),
        ]),
        ("Day of the Interview", [
            ("day_early", "Arrive 30 minutes early"),
            ("day_phone", "Turn off phone before entering"),
            ("day_calm", "Stay calm and speak clearly"),
            ("day_honest", "Answer all questions honestly"),
            ("day_ask", "Ask the officer to repeat if needed"),
        ]),
        ("After the Interview", [
            ("after_oath", "Attend your Oath Ceremony (if approved)"),
            ("after_register", "Register to vote"),
            ("after_passport", "Apply for a U.S. passport"),
        ])
    ]

    var body: some View {
        List {
            // Progress header
            Section {
                let total = sections.flatMap(\.items).count
                let done = checked.count
                VStack(spacing: 8) {
                    ProgressView(value: Double(done), total: Double(total))
                        .accentColor(.green)
                    Text("\(done) of \(total) completed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }

            ForEach(sections, id: \.title) { section in
                Section(header: Text(section.title)) {
                    ForEach(section.items, id: \.id) { item in
                        Button {
                            toggle(item.id)
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: checked.contains(item.id) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(checked.contains(item.id) ? .green : .gray)
                                    .font(.title3)
                                Text(item.text)
                                    .foregroundColor(checked.contains(item.id) ? .secondary : .primary)
                                    .strikethrough(checked.contains(item.id))
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Interview Checklist")
    }

    private func toggle(_ id: String) {
        if checked.contains(id) {
            checked.remove(id)
        } else {
            checked.insert(id)
        }
        UserDefaults.standard.set(Array(checked), forKey: "pm_checklist")
    }
}
