import SwiftUI

/// USCIS interview preparation checklist with toggleable items.
///
/// Localized per `AppLanguage`. Section titles, item text, and the
/// progress label all come from `localizedSections(for:)`. The `id`
/// strings under each item stay stable across languages so a user who
/// checks an item in Spanish keeps it checked when they switch to
/// English (UserDefaults persists by id, not by display text).
struct InterviewChecklistView: View {

    let language: AppLanguage

    @State private var checked: Set<String> = {
        let saved = UserDefaults.standard.stringArray(forKey: "pm_checklist") ?? []
        return Set(saved)
    }()

    private var s: UIStrings { UIStrings.forLanguage(language) }
    private var sections: [(title: String, items: [(id: String, text: String)])] {
        Self.localizedSections(for: language)
    }

    var body: some View {
        List {
            // Progress header
            Section {
                let total = sections.flatMap(\.items).count
                let done = checked.count
                VStack(spacing: 8) {
                    ProgressView(value: Double(done), total: Double(total))
                        .accentColor(.green)
                    Text(String(format: s.checklistProgressFormat, done, total))
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
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(s.navInterviewChecklist)
    }

    private func toggle(_ id: String) {
        if checked.contains(id) {
            checked.remove(id)
        } else {
            checked.insert(id)
        }
        UserDefaults.standard.set(Array(checked), forKey: "pm_checklist")
    }

    // MARK: - Localized data

    /// Returns the section/item content in the user's language. Item `id`s
    /// are language-agnostic stable keys (`doc_greencard`, `prep_study`,
    /// etc.) so a user who toggles items in one language and later switches
    /// to another keeps their checked state.
    private static func localizedSections(
        for language: AppLanguage
    ) -> [(title: String, items: [(id: String, text: String)])] {
        switch language {
        case .english: return englishSections
        case .spanish: return spanishSections
        case .nepali:  return nepaliSections
        case .chinese: return chineseSections
        }
    }

    private static let englishSections: [(title: String, items: [(id: String, text: String)])] = [
        ("Documents to Bring", [
            ("doc_greencard", "Permanent Resident Card (Green Card)"),
            ("doc_passport", "Valid passport and travel documents"),
            ("doc_photos", "Two passport-style photos"),
            ("doc_n400", "Form N-400 appointment notice"),
            ("doc_tax", "Tax returns (last 5 years)"),
            ("doc_travel", "Travel history records"),
        ]),
        ("Before the Interview", [
            ("prep_study", "Review all civics questions"),
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

    private static let spanishSections: [(title: String, items: [(id: String, text: String)])] = [
        ("Documentos para llevar", [
            ("doc_greencard", "Tarjeta de Residente Permanente (Green Card)"),
            ("doc_passport", "Pasaporte vigente y documentos de viaje"),
            ("doc_photos", "Dos fotografías tipo pasaporte"),
            ("doc_n400", "Aviso de cita del Formulario N-400"),
            ("doc_tax", "Declaraciones de impuestos (últimos 5 años)"),
            ("doc_travel", "Registros de tu historial de viajes"),
        ]),
        ("Antes de la entrevista", [
            ("prep_study", "Repasa todas las preguntas de civismo"),
            ("prep_reading", "Practica leer frases en inglés"),
            ("prep_writing", "Practica escribir frases en inglés"),
            ("prep_bio", "Repasa las respuestas de tu N-400"),
            ("prep_route", "Planea cómo llegar a la oficina de USCIS"),
            ("prep_outfit", "Prepara ropa formal o de negocios"),
        ]),
        ("El día de la entrevista", [
            ("day_early", "Llega 30 minutos antes"),
            ("day_phone", "Apaga el teléfono antes de entrar"),
            ("day_calm", "Mantén la calma y habla con claridad"),
            ("day_honest", "Responde todas las preguntas con honestidad"),
            ("day_ask", "Pide al oficial que repita si es necesario"),
        ]),
        ("Después de la entrevista", [
            ("after_oath", "Asiste a tu Ceremonia de Juramento (si te aprueban)"),
            ("after_register", "Regístrate para votar"),
            ("after_passport", "Solicita un pasaporte estadounidense"),
        ])
    ]

    private static let nepaliSections: [(title: String, items: [(id: String, text: String)])] = [
        ("ल्याउनुपर्ने कागजातहरू", [
            ("doc_greencard", "स्थायी निवासी कार्ड (ग्रीन कार्ड)"),
            ("doc_passport", "मान्य राहदानी र यात्रा कागजातहरू"),
            ("doc_photos", "दुई वटा राहदानी आकारका फोटोहरू"),
            ("doc_n400", "फारम N-400 अपोइन्टमेन्ट नोटिस"),
            ("doc_tax", "कर विवरणहरू (विगत ५ वर्षको)"),
            ("doc_travel", "यात्रा इतिहासको अभिलेख"),
        ]),
        ("अन्तर्वार्ता अघि", [
            ("prep_study", "सबै नागरिक शिक्षाका प्रश्नहरू समीक्षा गर्नुहोस्"),
            ("prep_reading", "अंग्रेजी वाक्यहरू पढ्ने अभ्यास गर्नुहोस्"),
            ("prep_writing", "अंग्रेजी वाक्यहरू लेख्ने अभ्यास गर्नुहोस्"),
            ("prep_bio", "आफ्नो N-400 आवेदनका उत्तरहरू समीक्षा गर्नुहोस्"),
            ("prep_route", "USCIS कार्यालय जाने बाटो योजना बनाउनुहोस्"),
            ("prep_outfit", "व्यावसायिक पहिरन तयार पार्नुहोस्"),
        ]),
        ("अन्तर्वार्ताको दिन", [
            ("day_early", "३० मिनेट चाँडो पुग्नुहोस्"),
            ("day_phone", "भित्र पस्नु अघि फोन बन्द गर्नुहोस्"),
            ("day_calm", "शान्त रहनुहोस् र स्पष्ट बोल्नुहोस्"),
            ("day_honest", "सबै प्रश्नहरूको इमानदारीपूर्वक उत्तर दिनुहोस्"),
            ("day_ask", "आवश्यक भएमा अफिसरलाई दोहोर्‍याउन भन्नुहोस्"),
        ]),
        ("अन्तर्वार्ता पछि", [
            ("after_oath", "आफ्नो शपथ समारोहमा सहभागी हुनुहोस् (स्वीकृत भएमा)"),
            ("after_register", "मतदानका लागि दर्ता गर्नुहोस्"),
            ("after_passport", "अमेरिकी राहदानीका लागि आवेदन दिनुहोस्"),
        ])
    ]

    private static let chineseSections: [(title: String, items: [(id: String, text: String)])] = [
        ("需要携带的文件", [
            ("doc_greencard", "永久居民卡（绿卡）"),
            ("doc_passport", "有效护照和旅行证件"),
            ("doc_photos", "两张护照尺寸照片"),
            ("doc_n400", "N-400 表面试预约通知"),
            ("doc_tax", "纳税申报表（最近 5 年）"),
            ("doc_travel", "旅行记录"),
        ]),
        ("面试前准备", [
            ("prep_study", "复习所有公民常识题"),
            ("prep_reading", "练习朗读英文句子"),
            ("prep_writing", "练习书写英文句子"),
            ("prep_bio", "回顾你的 N-400 申请答案"),
            ("prep_route", "规划前往 USCIS 办公室的路线"),
            ("prep_outfit", "准备商务休闲着装"),
        ]),
        ("面试当天", [
            ("day_early", "提前 30 分钟到达"),
            ("day_phone", "进入前关闭手机"),
            ("day_calm", "保持冷静,清晰表达"),
            ("day_honest", "诚实回答所有问题"),
            ("day_ask", "如有需要请官员重复"),
        ]),
        ("面试之后", [
            ("after_oath", "参加宣誓仪式(获批后)"),
            ("after_register", "登记选民"),
            ("after_passport", "申请美国护照"),
        ])
    ]
}
