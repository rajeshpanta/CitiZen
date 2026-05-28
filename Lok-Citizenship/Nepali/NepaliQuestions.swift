import Foundation

/// All Nepali (English ↔ नेपाली) quiz question sets — the 128 official 2025
/// USCIS naturalization civics questions, regrouped thematically across 8
/// practice levels of exactly 16 questions each. IDs (`q_25_NNN`) match the
/// official USCIS question numbering 1-128 and mirror EnglishQuestions.swift
/// so a learner's mastery is interchangeable between the two languages.
///
/// Each question has 2 variants: [English, Nepali]. The English variant
/// (index 0) is byte-identical to the same-ID question in EnglishQuestions,
/// so bilingual learners can toggle mid-quiz without breaking spaced
/// repetition.
///
/// USCIS has not published official Nepali civics test materials, so Nepali
/// terminology follows widely-accepted Nepali political/civic vocabulary:
/// संविधान (Constitution), कांग्रेस (Congress), सेनेट (Senate), प्रतिनिधि सभा
/// (House of Representatives), सर्वोच्च अदालत (Supreme Court), राष्ट्रपति
/// (President), उपराष्ट्रपति (Vice President), संशोधन (Amendment), अधिकारको
/// विधेयक (Bill of Rights), स्वतन्त्रताको घोषणापत्र (Declaration of
/// Independence), etc.
enum NepaliQuestions {

    // MARK: - Practice 1: Government Basics & Symbols (16 questions)
    static let practice1: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_001", correctAnswer: 0, variants: [
            .init(text: "What is the form of government of the United States?",
                  options: ["Republic", "Monarchy", "Dictatorship", "Direct democracy"],
                  explanation: "The U.S. is a constitution-based federal republic — a representative democracy where citizens elect officials to govern."),
            .init(text: "संयुक्त राज्य अमेरिकाको शासन व्यवस्था कस्तो हो?",
                  options: ["गणतन्त्र", "राजतन्त्र", "तानाशाही", "प्रत्यक्ष लोकतन्त्र"],
                  explanation: "अमेरिका संविधानमा आधारित संघीय गणतन्त्र हो — एक प्रतिनिधिमूलक लोकतन्त्र जहाँ नागरिकहरूले शासन गर्न पदाधिकारीहरू निर्वाचित गर्छन्।")
        ]),
        UnifiedQuestion(id: "q_25_012", correctAnswer: 2, variants: [
            .init(text: "What is the economic system of the United States?",
                  options: ["Socialism", "Communism", "Capitalism", "Feudalism"],
                  explanation: "The U.S. operates a capitalist (free market) economy, where businesses and prices are largely determined by supply and demand."),
            .init(text: "संयुक्त राज्य अमेरिकाको आर्थिक प्रणाली के हो?",
                  options: ["समाजवाद", "साम्यवाद", "पुँजीवाद", "सामन्तवाद"],
                  explanation: "अमेरिका पुँजीवादी (खुला बजार) अर्थतन्त्र चलाउँछ, जहाँ व्यवसाय र मूल्यहरू मुख्यतया आपूर्ति र माग अनुसार निर्धारण हुन्छन्।")
        ]),
        UnifiedQuestion(id: "q_25_016", correctAnswer: 1, variants: [
            .init(text: "Name the three branches of government.",
                  options: ["Federal, state, local", "Legislative, executive, and judicial", "President, Senate, House", "Republican, Democrat, Independent"],
                  explanation: "The three branches are the Legislative (Congress), Executive (President), and Judicial (the courts), each with separate powers."),
            .init(text: "सरकारका तीन शाखाहरूको नाम लिनुहोस्।",
                  options: ["संघीय, राज्य, स्थानीय", "विधायिका, कार्यपालिका र न्यायपालिका", "राष्ट्रपति, सेनेट, प्रतिनिधि सभा", "रिपब्लिकन, डेमोक्र्याट, स्वतन्त्र"],
                  explanation: "तीन शाखाहरू हुन्: विधायिका (कांग्रेस), कार्यपालिका (राष्ट्रपति) र न्यायपालिका (अदालतहरू)। प्रत्येकको आ-आफ्नै छुट्टै अधिकार छ।")
        ]),
        UnifiedQuestion(id: "q_25_017", correctAnswer: 2, variants: [
            .init(text: "The President of the United States is in charge of which branch of government?",
                  options: ["Legislative branch", "Judicial branch", "Executive branch", "Military branch"],
                  explanation: "The President leads the Executive branch, which enforces the laws passed by Congress."),
            .init(text: "अमेरिकी राष्ट्रपति सरकारको कुन शाखाको प्रमुख हुन्छन्?",
                  options: ["विधायिका शाखा", "न्यायपालिका शाखा", "कार्यपालिका शाखा", "सैन्य शाखा"],
                  explanation: "राष्ट्रपति कार्यपालिका शाखाको नेतृत्व गर्छन्, जसले कांग्रेसले पारित गरेका कानूनहरू कार्यान्वयन गर्छ।")
        ]),
        UnifiedQuestion(id: "q_25_038", correctAnswer: 2, variants: [
            .init(text: "What is the name of the President of the United States now?",
                  options: ["Joe Biden", "Barack Obama", "Donald Trump", "George W. Bush"],
                  explanation: "Donald Trump is the current President, serving his second term beginning January 2025."),
            .init(text: "हाल अमेरिकाका राष्ट्रपतिको नाम के हो?",
                  options: ["जो बाइडेन", "बराक ओबामा", "डोनाल्ड ट्रम्प", "जर्ज डब्ल्यू बुश"],
                  explanation: "डोनाल्ड ट्रम्प वर्तमान राष्ट्रपति हुन्। उनी जनवरी २०२५ देखि सुरु भएको आफ्नो दोस्रो कार्यकाल चलाइरहेका छन्।")
        ]),
        UnifiedQuestion(id: "q_25_039", correctAnswer: 1, variants: [
            .init(text: "What is the name of the Vice President of the United States now?",
                  options: ["Kamala Harris", "JD Vance", "Mike Pence", "Joe Biden"],
                  explanation: "JD Vance became Vice President in January 2025, serving alongside President Trump."),
            .init(text: "हाल अमेरिकाका उपराष्ट्रपतिको नाम के हो?",
                  options: ["कमला ह्यारिस", "जेडि भेन्स", "माइक पेन्स", "जो बाइडेन"],
                  explanation: "जेडि भेन्स जनवरी २०२५ मा उपराष्ट्रपति बने र राष्ट्रपति ट्रम्पसँगै काम गरिरहेका छन्।")
        ]),
        UnifiedQuestion(id: "q_25_040", correctAnswer: 1, variants: [
            .init(text: "If the President can no longer serve, who becomes President?",
                  options: ["The Speaker of the House", "The Vice President", "The Secretary of State", "The Chief Justice"],
                  explanation: "The Vice President becomes President if the President can no longer serve, per the 25th Amendment."),
            .init(text: "यदि राष्ट्रपतिले काम गर्न सक्दैनन् भने, राष्ट्रपति को बन्छन्?",
                  options: ["प्रतिनिधि सभाका सभामुख", "उपराष्ट्रपति", "विदेश मन्त्री", "प्रधान न्यायाधीश"],
                  explanation: "२५औं संशोधन अनुसार, यदि राष्ट्रपतिले काम गर्न सक्दैनन् भने उपराष्ट्रपति राष्ट्रपति बन्छन्।")
        ]),
        UnifiedQuestion(id: "q_25_042", correctAnswer: 0, variants: [
            .init(text: "Who is Commander in Chief of the U.S. military?",
                  options: ["The President", "The Secretary of Defense", "A military general", "The Vice President"],
                  explanation: "The President serves as Commander in Chief, which keeps the military under civilian control."),
            .init(text: "अमेरिकी सेनाका प्रमुख कमाण्डर को हुन्?",
                  options: ["राष्ट्रपति", "रक्षा मन्त्री", "एक सैनिक जनरल", "उपराष्ट्रपति"],
                  explanation: "राष्ट्रपति प्रमुख कमाण्डरको रूपमा सेवा गर्छन्, जसले सेनालाई नागरिक नियन्त्रणमा राख्छ।")
        ]),
        UnifiedQuestion(id: "q_25_052", correctAnswer: 2, variants: [
            .init(text: "What is the highest court in the United States?",
                  options: ["Federal Court", "Court of Appeals", "Supreme Court", "Circuit Court"],
                  explanation: "The Supreme Court is the highest court in the U.S. Its decisions are final and apply to all lower courts."),
            .init(text: "अमेरिकाको सबैभन्दा उच्च अदालत कुन हो?",
                  options: ["संघीय अदालत", "पुनरावेदन अदालत", "सर्वोच्च अदालत", "क्षेत्रीय अदालत"],
                  explanation: "सर्वोच्च अदालत अमेरिकाको सबैभन्दा उच्च अदालत हो। यसका निर्णयहरू अन्तिम हुन्छन् र सबै तल्ला अदालतहरूमा लागू हुन्छन्।")
        ]),
        UnifiedQuestion(id: "q_25_053", correctAnswer: 1, variants: [
            .init(text: "How many seats are on the Supreme Court?",
                  options: ["7", "9", "11", "13"],
                  explanation: "The Supreme Court has 9 seats: one Chief Justice and eight Associate Justices, set by the Judiciary Act of 1869."),
            .init(text: "सर्वोच्च अदालतमा कति वटा सिटहरू छन्?",
                  options: ["७", "९", "११", "१३"],
                  explanation: "सर्वोच्च अदालतमा ९ वटा सिटहरू छन्: एक प्रधान न्यायाधीश र आठ सहायक न्यायाधीशहरू। यो १८६९ को न्यायपालिका ऐनद्वारा निर्धारित गरिएको हो।")
        ]),
        UnifiedQuestion(id: "q_25_066", correctAnswer: 2, variants: [
            .init(text: "What do we show loyalty to when we say the Pledge of Allegiance?",
                  options: ["The President", "The state government", "The United States and the flag", "The military"],
                  explanation: "The Pledge of Allegiance shows loyalty to the United States and to the U.S. flag — symbols of the nation as a whole."),
            .init(text: "हामीले निष्ठाको शपथ खाँदा कसप्रति निष्ठा देखाउँछौं?",
                  options: ["राष्ट्रपति", "राज्य सरकार", "संयुक्त राज्य अमेरिका र झण्डा", "सेना"],
                  explanation: "निष्ठाको शपथले संयुक्त राज्य अमेरिका र अमेरिकी झण्डा — समग्र राष्ट्रको प्रतीकहरू — प्रति निष्ठा देखाउँछ।")
        ]),
        UnifiedQuestion(id: "q_25_119", correctAnswer: 1, variants: [
            .init(text: "What is the capital of the United States?",
                  options: ["New York City", "Washington, D.C.", "Philadelphia", "Boston"],
                  explanation: "Washington, D.C. has been the U.S. capital since 1800. The District of Columbia is named after Christopher Columbus."),
            .init(text: "संयुक्त राज्य अमेरिकाको राजधानी के हो?",
                  options: ["न्यूयोर्क सहर", "वाशिङ्टन, डी.सी.", "फिलाडेल्फिया", "बोस्टन"],
                  explanation: "वाशिङ्टन, डी.सी. १८०० देखि अमेरिकाको राजधानी रहेको छ। डिस्ट्रिक्ट अफ कोलम्बियाको नाम क्रिस्टोफर कोलम्बसको नाममा राखिएको हो।")
        ]),
        UnifiedQuestion(id: "q_25_121", correctAnswer: 2, variants: [
            .init(text: "Why does the flag have 13 stripes?",
                  options: ["For the 13 amendments", "For the 13 states bordering the ocean", "Because there were 13 original colonies", "For the 13 founding fathers"],
                  explanation: "The 13 stripes represent the 13 original colonies that declared independence and became the first U.S. states."),
            .init(text: "झण्डामा १३ वटा धर्साहरू किन छन्?",
                  options: ["१३ वटा संशोधनहरूका लागि", "समुद्रसँग जोडिएका १३ राज्यहरूका लागि", "किनभने १३ वटा मौलिक उपनिवेशहरू थिए", "१३ संस्थापक पिताहरूका लागि"],
                  explanation: "१३ धर्साहरूले स्वतन्त्रता घोषणा गरेर अमेरिकाका पहिलो राज्यहरू बनेका मौलिक १३ उपनिवेशहरूको प्रतिनिधित्व गर्छन्।")
        ]),
        UnifiedQuestion(id: "q_25_122", correctAnswer: 1, variants: [
            .init(text: "Why does the flag have 50 stars?",
                  options: ["For the 50 founding fathers", "There is one star for each state", "For 50 years of independence", "For each amendment"],
                  explanation: "Each star represents one of the 50 U.S. states. A new star is added when a state joins the Union."),
            .init(text: "झण्डामा ५० वटा ताराहरू किन छन्?",
                  options: ["५० संस्थापक पिताहरूका लागि", "प्रत्येक राज्यका लागि एउटा तारा छ", "स्वतन्त्रताका ५० वर्षका लागि", "प्रत्येक संशोधनका लागि"],
                  explanation: "प्रत्येक ताराले अमेरिकाका ५० राज्यहरू मध्ये एउटाको प्रतिनिधित्व गर्छ। नयाँ राज्य संघमा सामेल हुँदा नयाँ तारा थपिन्छ।")
        ]),
        UnifiedQuestion(id: "q_25_123", correctAnswer: 2, variants: [
            .init(text: "What is the name of the national anthem?",
                  options: ["America the Beautiful", "God Bless America", "The Star-Spangled Banner", "My Country, 'Tis of Thee"],
                  explanation: "\"The Star-Spangled Banner\" was written by Francis Scott Key in 1814 and became the official national anthem in 1931."),
            .init(text: "राष्ट्रिय गानको नाम के हो?",
                  options: ["अमेरिका द ब्युटिफुल", "गड ब्लेस अमेरिका", "द स्टार-स्पैङ्ग्ल्ड ब्यानर", "माई कन्ट्री, टिस अफ थी"],
                  explanation: "«द स्टार-स्पैङ्ग्ल्ड ब्यानर» फ्रान्सिस स्कट कीद्वारा १८१४ मा लेखिएको थियो र १९३१ मा आधिकारिक राष्ट्रिय गान बनेको थियो।")
        ]),
        UnifiedQuestion(id: "q_25_124", correctAnswer: 1, variants: [
            .init(text: "The Nation's first motto was \"E Pluribus Unum.\" What does that mean?",
                  options: ["In God We Trust", "Out of many, one", "Liberty and justice for all", "We the People"],
                  explanation: "\"E Pluribus Unum\" (Latin) means \"Out of many, one.\" It refers to the union of many states forming one nation."),
            .init(text: "राष्ट्रको पहिलो आदर्श वाक्य «E Pluribus Unum» थियो। यसको अर्थ के हो?",
                  options: ["हामी ईश्वरमा विश्वास गर्छौं", "धेरैबाट, एक", "सबैका लागि स्वतन्त्रता र न्याय", "हामी जनताहरू"],
                  explanation: "«E Pluribus Unum» (ल्याटिन) को अर्थ «धेरैबाट, एक» हो। यसले धेरै राज्यहरूको संघले एक राष्ट्र बनाएको कुरालाई जनाउँछ।")
        ])
    ]

    // MARK: - Practice 2: Constitution & Amendments (16 questions)
    static let practice2: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_002", correctAnswer: 2, variants: [
            .init(text: "What is the supreme law of the land?",
                  options: ["The Bill of Rights", "The Declaration of Independence", "The U.S. Constitution", "The Articles of Confederation"],
                  explanation: "The U.S. Constitution is the supreme law of the land. All other laws must comply with it."),
            .init(text: "देशको सर्वोच्च कानून के हो?",
                  options: ["अधिकारको विधेयक", "स्वतन्त्रताको घोषणापत्र", "अमेरिकी संविधान", "महासंघका लेखहरू"],
                  explanation: "अमेरिकी संविधान देशको सर्वोच्च कानून हो। अन्य सबै कानूनहरू यसको अनुपालनमा हुनुपर्छ।")
        ]),
        UnifiedQuestion(id: "q_25_003", correctAnswer: 1, variants: [
            .init(text: "Name one thing the U.S. Constitution does.",
                  options: ["Declares war on Britain", "Forms the government and protects rights", "Lists all U.S. citizens", "Establishes the national religion"],
                  explanation: "The Constitution forms the government, defines its powers and parts, and protects the rights of the people."),
            .init(text: "अमेरिकी संविधानले गर्ने एउटा काम भन्नुहोस्।",
                  options: ["बेलायतविरुद्ध युद्ध घोषणा गर्छ", "सरकारको गठन गर्छ र अधिकारहरूको रक्षा गर्छ", "सबै अमेरिकी नागरिकहरूको सूची बनाउँछ", "राष्ट्रिय धर्म स्थापना गर्छ"],
                  explanation: "संविधानले सरकार गठन गर्छ, यसका शक्ति र अंगहरू परिभाषित गर्छ, र जनताका अधिकारहरूको रक्षा गर्छ।")
        ]),
        UnifiedQuestion(id: "q_25_004", correctAnswer: 1, variants: [
            .init(text: "The U.S. Constitution starts with the words \"We the People.\" What does \"We the People\" mean?",
                  options: ["Only landowners", "Self-government and consent of the governed", "Only U.S. citizens", "The President alone"],
                  explanation: "\"We the People\" expresses self-government, popular sovereignty, and consent of the governed — government's power comes from the people."),
            .init(text: "अमेरिकी संविधान «हामी जनताहरू» शब्दबाट सुरु हुन्छ। «हामी जनताहरू» को अर्थ के हो?",
                  options: ["केवल जग्गाधनीहरू", "स्व-शासन र शासित जनताको सहमति", "केवल अमेरिकी नागरिकहरू", "एक्लै राष्ट्रपति"],
                  explanation: "«हामी जनताहरू» ले स्व-शासन, लोकप्रिय सार्वभौमिकता र शासित जनताको सहमति व्यक्त गर्छ — सरकारको शक्ति जनताबाट आउँछ।")
        ]),
        UnifiedQuestion(id: "q_25_005", correctAnswer: 1, variants: [
            .init(text: "How are changes made to the U.S. Constitution?",
                  options: ["By presidential order", "Through the amendment process", "By Supreme Court ruling", "By state vote alone"],
                  explanation: "Changes are made through amendments. An amendment requires a two-thirds vote in Congress and ratification by three-fourths of the states."),
            .init(text: "अमेरिकी संविधानमा परिवर्तन कसरी गरिन्छ?",
                  options: ["राष्ट्रपतिको आदेशद्वारा", "संशोधन प्रक्रियाद्वारा", "सर्वोच्च अदालतको फैसलाद्वारा", "केवल राज्य मतदानद्वारा"],
                  explanation: "परिवर्तनहरू संशोधनहरू मार्फत गरिन्छन्। एक संशोधनलाई कांग्रेसमा दुई-तिहाई मत र तीन-चौथाई राज्यहरूको अनुमोदन चाहिन्छ।")
        ]),
        UnifiedQuestion(id: "q_25_006", correctAnswer: 1, variants: [
            .init(text: "What does the Bill of Rights protect?",
                  options: ["Government property", "The basic rights of Americans", "Foreign trade only", "State borders"],
                  explanation: "The Bill of Rights — the first 10 amendments — protects the basic rights of Americans, including speech, religion, and due process."),
            .init(text: "अधिकारको विधेयकले के संरक्षण गर्छ?",
                  options: ["सरकारी सम्पत्ति", "अमेरिकीहरूका आधारभूत अधिकारहरू", "केवल विदेशी व्यापार", "राज्यका सिमाहरू"],
                  explanation: "अधिकारको विधेयक — पहिलो १० संशोधनहरू — ले अमेरिकीहरूका आधारभूत अधिकारहरूको संरक्षण गर्छ, जसमा अभिव्यक्ति, धर्म र उचित प्रक्रिया समावेश छन्।")
        ]),
        UnifiedQuestion(id: "q_25_007", correctAnswer: 2, variants: [
            .init(text: "How many amendments does the U.S. Constitution have?",
                  options: ["10", "17", "27", "50"],
                  explanation: "The Constitution has 27 amendments. The first 10 are the Bill of Rights; the most recent (27th) was ratified in 1992."),
            .init(text: "अमेरिकी संविधानमा कति वटा संशोधनहरू छन्?",
                  options: ["१०", "१७", "२७", "५०"],
                  explanation: "संविधानमा २७ वटा संशोधनहरू छन्। पहिलो १० वटा अधिकारको विधेयक हुन्; सबैभन्दा हालसालैको (२७औं) १९९२ मा अनुमोदन भएको थियो।")
        ]),
        UnifiedQuestion(id: "q_25_008", correctAnswer: 1, variants: [
            .init(text: "Why is the Declaration of Independence important?",
                  options: ["It established the U.S. dollar", "It says all people are created equal and identifies inherent rights", "It ended World War II", "It created the Supreme Court"],
                  explanation: "The Declaration of Independence states America is free from British control, says all people are created equal, and identifies inherent rights and individual freedoms."),
            .init(text: "स्वतन्त्रताको घोषणापत्र किन महत्वपूर्ण छ?",
                  options: ["यसले अमेरिकी डलर स्थापना गर्‍यो", "यसले सबै मानिसहरू समान रूपमा सिर्जना भएका छन् भन्छ र अन्तर्निहित अधिकारहरू पहिचान गर्छ", "यसले दोस्रो विश्वयुद्ध अन्त्य गर्‍यो", "यसले सर्वोच्च अदालत सिर्जना गर्‍यो"],
                  explanation: "स्वतन्त्रताको घोषणापत्रले अमेरिका बेलायती नियन्त्रणबाट मुक्त छ भन्छ, सबै मानिसहरू समान रूपमा सिर्जना भएका छन् भन्छ, र अन्तर्निहित अधिकार तथा व्यक्तिगत स्वतन्त्रताहरू पहिचान गर्छ।")
        ]),
        UnifiedQuestion(id: "q_25_009", correctAnswer: 1, variants: [
            .init(text: "What founding document said the American colonies were free from Britain?",
                  options: ["The U.S. Constitution", "The Declaration of Independence", "The Bill of Rights", "The Federalist Papers"],
                  explanation: "The Declaration of Independence (1776) declared the 13 American colonies free from British rule."),
            .init(text: "कुन स्थापक दस्तावेजले अमेरिकी उपनिवेशहरू बेलायतबाट स्वतन्त्र छन् भनेको थियो?",
                  options: ["अमेरिकी संविधान", "स्वतन्त्रताको घोषणापत्र", "अधिकारको विधेयक", "फेडेरलिस्ट पेपर्स"],
                  explanation: "स्वतन्त्रताको घोषणापत्र (१७७६) ले १३ अमेरिकी उपनिवेशहरू बेलायती शासनबाट स्वतन्त्र भएको घोषणा गरेको थियो।")
        ]),
        UnifiedQuestion(id: "q_25_010", correctAnswer: 1, variants: [
            .init(text: "Name two important ideas from the Declaration of Independence and the U.S. Constitution.",
                  options: ["Monarchy and aristocracy", "Equality and liberty", "Slavery and segregation", "Foreign rule and conquest"],
                  explanation: "Important ideas include equality, liberty, social contract, natural rights, limited government, and self-government."),
            .init(text: "स्वतन्त्रताको घोषणापत्र र अमेरिकी संविधानबाट दुई महत्वपूर्ण विचारहरूको नाम लिनुहोस्।",
                  options: ["राजतन्त्र र कुलीनतन्त्र", "समानता र स्वतन्त्रता", "दासत्व र विभेद", "विदेशी शासन र विजय"],
                  explanation: "महत्वपूर्ण विचारहरूमा समानता, स्वतन्त्रता, सामाजिक करार, प्राकृतिक अधिकारहरू, सीमित सरकार र स्व-शासन समावेश छन्।")
        ]),
        UnifiedQuestion(id: "q_25_011", correctAnswer: 2, variants: [
            .init(text: "The words \"Life, Liberty, and the pursuit of Happiness\" are in what founding document?",
                  options: ["U.S. Constitution", "Bill of Rights", "Declaration of Independence", "Articles of Confederation"],
                  explanation: "These famous words appear in the Declaration of Independence, written by Thomas Jefferson in 1776."),
            .init(text: "«जीवन, स्वतन्त्रता र खुशीको खोजी» शब्दहरू कुन स्थापक दस्तावेजमा छन्?",
                  options: ["अमेरिकी संविधान", "अधिकारको विधेयक", "स्वतन्त्रताको घोषणापत्र", "महासंघका लेखहरू"],
                  explanation: "यी प्रसिद्ध शब्दहरू थोमस जेफरसनद्वारा १७७६ मा लेखिएको स्वतन्त्रताको घोषणापत्रमा देखा पर्छन्।")
        ]),
        UnifiedQuestion(id: "q_25_013", correctAnswer: 2, variants: [
            .init(text: "What is the rule of law?",
                  options: ["The President can do anything", "The richest people make the rules", "Everyone must follow the law, including leaders", "Only judges follow the law"],
                  explanation: "The rule of law means everyone must obey the law — including leaders, the government, and ordinary citizens. No one is above the law."),
            .init(text: "कानूनको शासन भनेको के हो?",
                  options: ["राष्ट्रपतिले जे पनि गर्न सक्छन्", "धनी मानिसहरूले नियमहरू बनाउँछन्", "नेताहरू सहित सबैले कानून पालना गर्नुपर्छ", "केवल न्यायाधीशहरूले कानून पालना गर्छन्"],
                  explanation: "कानूनको शासन भनेको सबैले कानून पालना गर्नुपर्छ — नेताहरू, सरकार र सामान्य नागरिकहरू सहित। कोही पनि कानूनभन्दा माथि छैन।")
        ]),
        UnifiedQuestion(id: "q_25_014", correctAnswer: 1, variants: [
            .init(text: "Many documents influenced the U.S. Constitution. Name one.",
                  options: ["The Treaty of Paris", "The Federalist Papers", "The Monroe Doctrine", "The Marshall Plan"],
                  explanation: "Documents that influenced the Constitution include the Declaration of Independence, Articles of Confederation, Federalist Papers, Virginia Declaration of Rights, Mayflower Compact, and Iroquois Great Law of Peace."),
            .init(text: "धेरै दस्तावेजहरूले अमेरिकी संविधानलाई प्रभावित गरे। एउटाको नाम लिनुहोस्।",
                  options: ["प्यारिसको सन्धि", "फेडेरलिस्ट पेपर्स", "मोनरो सिद्धान्त", "मार्शल योजना"],
                  explanation: "संविधानलाई प्रभाव पारेका दस्तावेजहरूमा स्वतन्त्रताको घोषणापत्र, महासंघका लेखहरू, फेडेरलिस्ट पेपर्स, भर्जिनिया अधिकार घोषणापत्र, मेफ्लावर सम्झौता र इरोक्वोइस महान शान्ति कानून समावेश छन्।")
        ]),
        UnifiedQuestion(id: "q_25_015", correctAnswer: 1, variants: [
            .init(text: "There are three branches of government. Why?",
                  options: ["To create more jobs", "So one part does not become too powerful", "Because the colonies wanted three", "Because three is a lucky number"],
                  explanation: "Three branches with checks and balances ensure no single branch becomes too powerful — the principle of separation of powers."),
            .init(text: "सरकारका तीन शाखाहरू छन्। किन?",
                  options: ["थप रोजगारी सिर्जना गर्न", "कुनै एक शाखा अत्यधिक शक्तिशाली नबनोस् भनेर", "किनभने उपनिवेशहरूले तीन चाहन्थे", "किनभने तीन भाग्यशाली संख्या हो"],
                  explanation: "जाँच र सन्तुलनसहितका तीन शाखाहरूले कुनै पनि एक शाखा अत्यधिक शक्तिशाली नबनोस् भन्ने सुनिश्चित गर्छन् — यो शक्ति पृथकीकरणको सिद्धान्त हो।")
        ]),
        UnifiedQuestion(id: "q_25_060", correctAnswer: 1, variants: [
            .init(text: "What is the purpose of the 10th Amendment?",
                  options: ["To give all power to the federal government", "Powers not given to the federal government belong to the states or the people", "To establish religious freedom", "To allow free speech"],
                  explanation: "The 10th Amendment reserves any powers not delegated to the federal government — and not prohibited to states — for the states or the people."),
            .init(text: "१०औं संशोधनको उद्देश्य के हो?",
                  options: ["सबै शक्ति संघीय सरकारलाई दिने", "संघीय सरकारलाई नदिइएका शक्तिहरू राज्य वा जनतामा रहन्छन्", "धार्मिक स्वतन्त्रता स्थापना गर्ने", "स्वतन्त्र बोल्ने अनुमति दिने"],
                  explanation: "१०औं संशोधनले संघीय सरकारलाई नदिइएका — र राज्यहरूलाई निषेध नगरिएका — कुनै पनि शक्तिहरू राज्य वा जनताका लागि सुरक्षित राख्छ।")
        ]),
        UnifiedQuestion(id: "q_25_097", correctAnswer: 1, variants: [
            .init(text: "What amendment says all persons born or naturalized in the United States, and subject to the jurisdiction thereof, are U.S. citizens?",
                  options: ["13th Amendment", "14th Amendment", "15th Amendment", "19th Amendment"],
                  explanation: "The 14th Amendment (1868) grants citizenship to all persons born or naturalized in the United States — known as birthright citizenship."),
            .init(text: "कुन संशोधनले अमेरिकामा जन्मेका वा प्राकृतिकीकरण भएका र यसको अधिकार क्षेत्रमा रहेका सबै व्यक्तिहरू अमेरिकी नागरिक हुन् भन्छ?",
                  options: ["१३औं संशोधन", "१४औं संशोधन", "१५औं संशोधन", "१९औं संशोधन"],
                  explanation: "१४औं संशोधन (१८६८) ले अमेरिकामा जन्मेका वा प्राकृतिकीकरण भएका सबै व्यक्तिहरूलाई नागरिकता प्रदान गर्छ — यसलाई जन्मजात नागरिकता भनिन्छ।")
        ]),
        UnifiedQuestion(id: "q_25_102", correctAnswer: 2, variants: [
            .init(text: "When did all women get the right to vote?",
                  options: ["1865", "1870", "1920 (with the 19th Amendment)", "1965"],
                  explanation: "The 19th Amendment, ratified in 1920, gave women the right to vote nationwide after a long suffrage movement."),
            .init(text: "सबै महिलाहरूले मतदानको अधिकार कहिले पाए?",
                  options: ["१८६५", "१८७०", "१९२० (१९औं संशोधनसँगै)", "१९६५"],
                  explanation: "१९२० मा अनुमोदन भएको १९औं संशोधनले लामो मताधिकार आन्दोलनपछि महिलाहरूलाई देशभर मतदानको अधिकार दियो।")
        ])
    ]

    // MARK: - Practice 3: Congress: Structure & Powers (16 questions)
    static let practice3: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_018", correctAnswer: 2, variants: [
            .init(text: "What part of the federal government writes laws?",
                  options: ["The Supreme Court", "The President", "U.S. Congress (legislative branch)", "The Cabinet"],
                  explanation: "Congress — the Senate and House of Representatives — is the legislative branch responsible for writing federal laws."),
            .init(text: "संघीय सरकारको कुन भागले कानूनहरू बनाउँछ?",
                  options: ["सर्वोच्च अदालत", "राष्ट्रपति", "अमेरिकी कांग्रेस (विधायिका शाखा)", "मन्त्रिपरिषद"],
                  explanation: "कांग्रेस — सेनेट र प्रतिनिधि सभा — विधायिका शाखा हो जुन संघीय कानूनहरू लेख्न जिम्मेवार छ।")
        ]),
        UnifiedQuestion(id: "q_25_019", correctAnswer: 0, variants: [
            .init(text: "What are the two parts of the U.S. Congress?",
                  options: ["Senate and House of Representatives", "Cabinet and Senate", "President and Vice President", "House and Cabinet"],
                  explanation: "Congress is bicameral, made up of the Senate (100 members) and the House of Representatives (435 voting members)."),
            .init(text: "अमेरिकी कांग्रेसका दुई भागहरू कुन-कुन हुन्?",
                  options: ["सेनेट र प्रतिनिधि सभा", "मन्त्रिपरिषद र सेनेट", "राष्ट्रपति र उपराष्ट्रपति", "प्रतिनिधि सभा र मन्त्रिपरिषद"],
                  explanation: "कांग्रेस द्विसदनीय छ, जसमा सेनेट (१०० सदस्य) र प्रतिनिधि सभा (४३५ मतदान सदस्यहरू) समावेश छन्।")
        ]),
        UnifiedQuestion(id: "q_25_020", correctAnswer: 2, variants: [
            .init(text: "Name one power of the U.S. Congress.",
                  options: ["Veto bills", "Decides Supreme Court cases", "Writes laws", "Commands the military"],
                  explanation: "Powers of Congress include writing laws, declaring war, and making the federal budget."),
            .init(text: "अमेरिकी कांग्रेसको एउटा शक्तिको नाम लिनुहोस्।",
                  options: ["विधेयक भिटो गर्ने", "सर्वोच्च अदालतका मुद्दाहरू निर्णय गर्ने", "कानूनहरू लेख्ने", "सेनाको आदेश गर्ने"],
                  explanation: "कांग्रेसका शक्तिहरूमा कानूनहरू लेख्ने, युद्ध घोषणा गर्ने र संघीय बजेट बनाउने समावेश छन्।")
        ]),
        UnifiedQuestion(id: "q_25_021", correctAnswer: 1, variants: [
            .init(text: "How many U.S. senators are there?",
                  options: ["50", "100", "435", "200"],
                  explanation: "There are 100 U.S. Senators — two from each of the 50 states, ensuring equal representation regardless of state size."),
            .init(text: "अमेरिकी सेनेटरहरू कति जना छन्?",
                  options: ["५०", "१००", "४३५", "२००"],
                  explanation: "अमेरिकामा १०० सेनेटरहरू छन् — ५० राज्यबाट दुई-दुई जना, राज्यको आकार जे भए पनि बराबर प्रतिनिधित्व सुनिश्चित गर्दै।")
        ]),
        UnifiedQuestion(id: "q_25_022", correctAnswer: 2, variants: [
            .init(text: "How long is a term for a U.S. senator?",
                  options: ["2 years", "4 years", "6 years", "Life"],
                  explanation: "Senators serve 6-year terms. About one-third of the Senate is up for election every two years."),
            .init(text: "अमेरिकी सेनेटरको कार्यकाल कति वर्ष हुन्छ?",
                  options: ["२ वर्ष", "४ वर्ष", "६ वर्ष", "जीवनभर"],
                  explanation: "सेनेटरहरूले ६ वर्षको कार्यकाल पूरा गर्छन्। हरेक दुई वर्षमा करिब एक-तिहाई सेनेट निर्वाचनको लागि उठ्छ।")
        ]),
        UnifiedQuestion(id: "q_25_023", correctAnswer: 0, variants: [
            .init(text: "Who is one of your state's U.S. senators now?",
                  options: ["Depends on your state", "Joe Biden", "Donald Trump", "Ron DeSantis"],
                  explanation: "Each state has 2 U.S. Senators. Look up your state's current Senators at senate.gov before your interview. (D.C. and U.S. territories have no voting Senators.)"),
            .init(text: "तपाईंको राज्यका हालका एक अमेरिकी सेनेटर को हुन्?",
                  options: ["तपाईंको राज्यमा निर्भर", "जो बाइडेन", "डोनाल्ड ट्रम्प", "रोन डिसान्टिस"],
                  explanation: "हरेक राज्यमा २ जना अमेरिकी सेनेटरहरू छन्। अन्तर्वार्ता अघि senate.gov मा तपाईंको राज्यका हालका सेनेटरहरूको जानकारी लिनुहोस्। (डि.सी. र अमेरिकी क्षेत्रहरूमा मतदान गर्ने सेनेटरहरू छैनन्।)")
        ]),
        UnifiedQuestion(id: "q_25_024", correctAnswer: 2, variants: [
            .init(text: "How many voting members are in the House of Representatives?",
                  options: ["100", "200", "435", "538"],
                  explanation: "The House has 435 voting members. Seats are apportioned by population, recalculated after each census."),
            .init(text: "प्रतिनिधि सभामा कति मतदान सदस्यहरू छन्?",
                  options: ["१००", "२००", "४३५", "५३८"],
                  explanation: "प्रतिनिधि सभामा ४३५ मतदान सदस्यहरू छन्। सिटहरू जनसंख्याको आधारमा बाँडिन्छन्, हरेक जनगणनापछि पुन: गणना गरिन्छ।")
        ]),
        UnifiedQuestion(id: "q_25_025", correctAnswer: 0, variants: [
            .init(text: "How long is a term for a member of the House of Representatives?",
                  options: ["2 years", "4 years", "6 years", "8 years"],
                  explanation: "House members serve 2-year terms. The entire House faces re-election every two years to keep them close to the people."),
            .init(text: "प्रतिनिधि सभाका सदस्यको कार्यकाल कति वर्ष हुन्छ?",
                  options: ["२ वर्ष", "४ वर्ष", "६ वर्ष", "८ वर्ष"],
                  explanation: "प्रतिनिधि सभाका सदस्यहरूको कार्यकाल २ वर्षको हुन्छ। जनतासँग नजिक रहन सम्पूर्ण सभाले हरेक दुई वर्षमा पुन: निर्वाचन सामना गर्छ।")
        ]),
        UnifiedQuestion(id: "q_25_026", correctAnswer: 1, variants: [
            .init(text: "Why do U.S. representatives serve shorter terms than U.S. senators?",
                  options: ["To save government money", "To more closely follow public opinion", "Because they have less power", "Because they are appointed, not elected"],
                  explanation: "Representatives serve shorter (2-year) terms so they remain closely accountable to the public's current opinions."),
            .init(text: "अमेरिकी प्रतिनिधिहरूले सेनेटरहरूको तुलनामा छोटो कार्यकाल किन सेवा गर्छन्?",
                  options: ["सरकारको पैसा बचाउन", "जनमतलाई बढी नजिकबाट पछ्याउन", "किनभने उनीहरूको शक्ति कम छ", "किनभने उनीहरू नियुक्त गरिएका हुन्, निर्वाचित होइनन्"],
                  explanation: "प्रतिनिधिहरूले छोटो (२ वर्षको) कार्यकाल सेवा गर्छन् ताकि उनीहरू जनताका वर्तमान विचारहरूप्रति नजिकबाट उत्तरदायी रहून्।")
        ]),
        UnifiedQuestion(id: "q_25_027", correctAnswer: 1, variants: [
            .init(text: "How many senators does each state have?",
                  options: ["1", "2", "3", "Depends on population"],
                  explanation: "Each state has 2 Senators, regardless of population. This was the Great Compromise to ensure equal state representation."),
            .init(text: "प्रत्येक राज्यमा कति जना सेनेटरहरू छन्?",
                  options: ["१", "२", "३", "जनसंख्यामा निर्भर"],
                  explanation: "प्रत्येक राज्यमा जनसंख्या जे भए पनि २ जना सेनेटरहरू छन्। यो राज्यहरूको बराबर प्रतिनिधित्व सुनिश्चित गर्न गरिएको «महान सम्झौता» थियो।")
        ]),
        UnifiedQuestion(id: "q_25_028", correctAnswer: 0, variants: [
            .init(text: "Why does each state have two senators?",
                  options: ["For equal representation of small and large states (the Great Compromise)", "Because the Senate is the more important chamber", "To save election costs", "Because the Constitution forgot to specify"],
                  explanation: "Each state has 2 Senators for equal representation. This was the Great Compromise (Connecticut Compromise), balancing small-state and large-state interests."),
            .init(text: "प्रत्येक राज्यमा दुई सेनेटरहरू किन छन्?",
                  options: ["साना र ठूला राज्यहरूको बराबर प्रतिनिधित्वका लागि (महासम्झौता)", "किनभने सेनेट बढी महत्वपूर्ण सदन हो", "निर्वाचन खर्च बचाउन", "किनभने संविधानले उल्लेख गर्न बिर्सियो"],
                  explanation: "प्रत्येक राज्यमा बराबर प्रतिनिधित्वका लागि २ जना सेनेटरहरू छन्। यो महासम्झौता (कनेक्टिकट सम्झौता) थियो, जसले साना र ठूला राज्यका हितहरूलाई सन्तुलन गर्‍यो।")
        ]),
        UnifiedQuestion(id: "q_25_029", correctAnswer: 0, variants: [
            .init(text: "Name your U.S. representative.",
                  options: ["Depends on your congressional district", "Mike Johnson", "Nancy Pelosi", "Kevin McCarthy"],
                  explanation: "Each congressional district has one Representative. Find yours at house.gov by entering your ZIP code."),
            .init(text: "तपाईंको अमेरिकी प्रतिनिधिको नाम भन्नुहोस्।",
                  options: ["तपाईंको कांग्रेसनल जिल्लामा निर्भर", "माइक जोनसन", "न्यान्सी पेलोसी", "केभिन म्याकार्थी"],
                  explanation: "प्रत्येक कांग्रेसनल जिल्लामा एक प्रतिनिधि हुन्छ। आफ्नो जिप कोड house.gov मा प्रविष्ट गरेर आफ्नो प्रतिनिधि पत्ता लगाउनुहोस्।")
        ]),
        UnifiedQuestion(id: "q_25_030", correctAnswer: 2, variants: [
            .init(text: "What is the name of the Speaker of the House of Representatives now?",
                  options: ["Nancy Pelosi", "Kevin McCarthy", "Mike Johnson", "Mitch McConnell"],
                  explanation: "Mike Johnson has been Speaker of the House since 2023. The Speaker leads the House and is second in line for presidential succession."),
            .init(text: "हाल प्रतिनिधि सभाका सभामुखको नाम के हो?",
                  options: ["न्यान्सी पेलोसी", "केभिन म्याकार्थी", "माइक जोनसन", "मिच म्याकोनेल"],
                  explanation: "माइक जोनसन २०२३ देखि प्रतिनिधि सभाका सभामुख हुन्। सभामुखले सभाको नेतृत्व गर्छन् र राष्ट्रपति उत्तराधिकारको पंक्तिमा दोस्रो स्थानमा छन्।")
        ]),
        UnifiedQuestion(id: "q_25_031", correctAnswer: 1, variants: [
            .init(text: "Who does a U.S. senator represent?",
                  options: ["Only the President's party", "Citizens of their state", "Federal employees only", "The Supreme Court"],
                  explanation: "A U.S. Senator represents all the citizens (people) of their state."),
            .init(text: "अमेरिकी सेनेटरले कसको प्रतिनिधित्व गर्छन्?",
                  options: ["केवल राष्ट्रपतिको पार्टी", "आफ्नो राज्यका नागरिकहरू", "केवल संघीय कर्मचारीहरू", "सर्वोच्च अदालत"],
                  explanation: "अमेरिकी सेनेटरले आफ्नो राज्यका सबै नागरिकहरूको (जनताको) प्रतिनिधित्व गर्छन्।")
        ]),
        UnifiedQuestion(id: "q_25_032", correctAnswer: 2, variants: [
            .init(text: "Who elects U.S. senators?",
                  options: ["State legislatures", "The President", "Citizens from their state", "Other Senators"],
                  explanation: "Citizens from each state elect their Senators. Before the 17th Amendment (1913), Senators were chosen by state legislatures."),
            .init(text: "अमेरिकी सेनेटरहरूलाई कसले चुन्छ?",
                  options: ["राज्य विधायिकाहरू", "राष्ट्रपति", "आफ्नो राज्यका नागरिकहरू", "अन्य सेनेटरहरू"],
                  explanation: "प्रत्येक राज्यका नागरिकहरूले आफ्ना सेनेटरहरूलाई चुन्छन्। १७औं संशोधन (१९१३) अघि सेनेटरहरू राज्य विधायिकाहरूले छनोट गर्थे।")
        ]),
        UnifiedQuestion(id: "q_25_033", correctAnswer: 0, variants: [
            .init(text: "Who does a member of the House of Representatives represent?",
                  options: ["Citizens of their congressional district", "All U.S. citizens", "Their political party", "The President"],
                  explanation: "A House member represents the citizens (people) of their congressional district. House districts are based on population."),
            .init(text: "प्रतिनिधि सभाका सदस्यले कसको प्रतिनिधित्व गर्छन्?",
                  options: ["आफ्नो कांग्रेसनल जिल्लाका नागरिकहरू", "सबै अमेरिकी नागरिकहरू", "आफ्नो राजनीतिक पार्टी", "राष्ट्रपति"],
                  explanation: "प्रतिनिधि सभाका सदस्यले आफ्नो कांग्रेसनल जिल्लाका नागरिकहरू (जनता) को प्रतिनिधित्व गर्छन्। सभाका जिल्लाहरू जनसंख्यामा आधारित हुन्छन्।")
        ])
    ]

    // MARK: - Practice 4: Congress & Executive (16 questions)
    static let practice4: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_034", correctAnswer: 1, variants: [
            .init(text: "Who elects members of the House of Representatives?",
                  options: ["The state governor", "Citizens from their congressional district", "The President", "The Senate"],
                  explanation: "Citizens from each congressional district elect their Representative every two years."),
            .init(text: "प्रतिनिधि सभाका सदस्यहरूलाई कसले चुन्छ?",
                  options: ["राज्य गभर्नर", "आफ्नो कांग्रेसनल जिल्लाका नागरिकहरू", "राष्ट्रपति", "सेनेट"],
                  explanation: "प्रत्येक कांग्रेसनल जिल्लाका नागरिकहरूले हरेक दुई वर्षमा आफ्नो प्रतिनिधि चुन्छन्।")
        ]),
        UnifiedQuestion(id: "q_25_035", correctAnswer: 1, variants: [
            .init(text: "Some states have more representatives than other states. Why?",
                  options: ["Because they were states first", "Because of the state's population", "Because they pay more taxes", "Because they have more land"],
                  explanation: "House seats are apportioned by population. California has 52 representatives; small states like Wyoming have just 1."),
            .init(text: "कतिपय राज्यहरूमा अरूभन्दा बढी प्रतिनिधिहरू किन छन्?",
                  options: ["किनभने तिनीहरू पहिले राज्य भएका थिए", "राज्यको जनसंख्याका कारण", "किनभने तिनीहरू बढी कर तिर्छन्", "किनभने तिनीहरूको जमिन बढी छ"],
                  explanation: "प्रतिनिधि सभाका सिटहरू जनसंख्याको आधारमा बाँडिन्छन्। क्यालिफोर्नियामा ५२ प्रतिनिधिहरू छन्; वायोमिङ जस्ता साना राज्यहरूमा केवल १ छ।")
        ]),
        UnifiedQuestion(id: "q_25_036", correctAnswer: 1, variants: [
            .init(text: "The President of the United States is elected for how many years?",
                  options: ["2 years", "4 years", "6 years", "Life"],
                  explanation: "The President serves a 4-year term, established by Article II of the Constitution."),
            .init(text: "अमेरिकी राष्ट्रपति कति वर्षको लागि निर्वाचित हुन्छन्?",
                  options: ["२ वर्ष", "४ वर्ष", "६ वर्ष", "जीवनभर"],
                  explanation: "राष्ट्रपतिले ४ वर्षको कार्यकाल सेवा गर्छन्, जुन संविधानको धारा २ द्वारा स्थापित गरिएको हो।")
        ]),
        UnifiedQuestion(id: "q_25_037", correctAnswer: 1, variants: [
            .init(text: "The President of the United States can serve only two terms. Why?",
                  options: ["To save campaign costs", "Because of the 22nd Amendment (to prevent too much power)", "Because of tradition only", "Because the President gets too old"],
                  explanation: "The 22nd Amendment (1951) limits Presidents to two elected terms, preventing any one person from accumulating too much power. It was passed after FDR served four terms."),
            .init(text: "अमेरिकी राष्ट्रपति केवल दुई कार्यकाल मात्र सेवा गर्न सक्छन्। किन?",
                  options: ["प्रचार खर्च बचाउन", "२२औं संशोधनका कारण (अत्यधिक शक्ति रोक्न)", "केवल परम्पराका कारण", "किनभने राष्ट्रपति धेरै बुढो हुन्छन्"],
                  explanation: "२२औं संशोधन (१९५१) ले राष्ट्रपतिहरूलाई दुई निर्वाचित कार्यकालमा सीमित गर्छ, कुनै एक व्यक्तिले अत्यधिक शक्ति सञ्चय गर्नबाट रोक्छ। यो एफडिआरले चार कार्यकाल सेवा गरेपछि पारित भएको थियो।")
        ]),
        UnifiedQuestion(id: "q_25_041", correctAnswer: 1, variants: [
            .init(text: "Name one power of the President.",
                  options: ["Writes federal laws", "Vetoes bills", "Decides Supreme Court cases", "Declares war"],
                  explanation: "Presidential powers include vetoing bills, signing bills into law, enforcing laws, serving as Commander in Chief, and appointing federal judges."),
            .init(text: "राष्ट्रपतिको एउटा शक्तिको नाम भन्नुहोस्।",
                  options: ["संघीय कानूनहरू लेख्ने", "विधेयक भिटो गर्ने", "सर्वोच्च अदालतका मुद्दाहरू निर्णय गर्ने", "युद्ध घोषणा गर्ने"],
                  explanation: "राष्ट्रपतिका शक्तिहरूमा विधेयक भिटो गर्ने, विधेयकमा हस्ताक्षर गरेर कानून बनाउने, कानून कार्यान्वयन गर्ने, प्रमुख कमाण्डर सेवा गर्ने र संघीय न्यायाधीशहरू नियुक्त गर्ने समावेश छन्।")
        ]),
        UnifiedQuestion(id: "q_25_043", correctAnswer: 2, variants: [
            .init(text: "Who signs bills to become laws?",
                  options: ["The Speaker of the House", "The Vice President", "The President", "The Chief Justice"],
                  explanation: "After Congress passes a bill, the President signs it into law. The President can also veto a bill, returning it to Congress."),
            .init(text: "विधेयकलाई कानून बनाउन कसले हस्ताक्षर गर्छ?",
                  options: ["प्रतिनिधि सभाका सभामुख", "उपराष्ट्रपति", "राष्ट्रपति", "प्रधान न्यायाधीश"],
                  explanation: "कांग्रेसले विधेयक पारित गरेपछि राष्ट्रपतिले त्यसमा हस्ताक्षर गरेर कानून बनाउँछन्। राष्ट्रपतिले विधेयक भिटो गरेर पनि कांग्रेसमा फिर्ता पठाउन सक्छन्।")
        ]),
        UnifiedQuestion(id: "q_25_044", correctAnswer: 2, variants: [
            .init(text: "Who vetoes bills?",
                  options: ["The Senate", "The Supreme Court", "The President", "The Cabinet"],
                  explanation: "The President vetoes bills passed by Congress. Congress can override a veto with a two-thirds vote in both chambers."),
            .init(text: "विधेयकहरू कसले भिटो गर्छ?",
                  options: ["सेनेट", "सर्वोच्च अदालत", "राष्ट्रपति", "मन्त्रिपरिषद"],
                  explanation: "कांग्रेसले पारित गरेका विधेयकहरू राष्ट्रपतिले भिटो गर्छन्। कांग्रेसले दुवै सदनमा दुई-तिहाई मतले भिटो उल्ट्याउन सक्छ।")
        ]),
        UnifiedQuestion(id: "q_25_045", correctAnswer: 2, variants: [
            .init(text: "Who appoints federal judges?",
                  options: ["The Speaker of the House", "The Chief Justice", "The President", "Congress"],
                  explanation: "The President appoints federal judges, including Supreme Court Justices. The Senate must confirm these appointments."),
            .init(text: "संघीय न्यायाधीशहरू कसले नियुक्त गर्छ?",
                  options: ["प्रतिनिधि सभाका सभामुख", "प्रधान न्यायाधीश", "राष्ट्रपति", "कांग्रेस"],
                  explanation: "राष्ट्रपतिले सर्वोच्च अदालतका न्यायाधीशहरू सहित संघीय न्यायाधीशहरू नियुक्त गर्छन्। सेनेटले यी नियुक्तिहरू पुष्टि गर्नैपर्छ।")
        ]),
        UnifiedQuestion(id: "q_25_046", correctAnswer: 1, variants: [
            .init(text: "The executive branch has many parts. Name one.",
                  options: ["The Supreme Court", "The President's Cabinet", "The Senate", "Congress"],
                  explanation: "Parts of the Executive branch include the President, the Cabinet, and federal departments and agencies (like the FBI, EPA, IRS)."),
            .init(text: "कार्यपालिका शाखाका धेरै भागहरू छन्। एउटाको नाम लिनुहोस्।",
                  options: ["सर्वोच्च अदालत", "राष्ट्रपतिको मन्त्रिपरिषद", "सेनेट", "कांग्रेस"],
                  explanation: "कार्यपालिका शाखाका भागहरूमा राष्ट्रपति, मन्त्रिपरिषद, र संघीय विभाग तथा एजेन्सीहरू (एफबिआई, ईपीए, आईआरएस जस्ता) समावेश छन्।")
        ]),
        UnifiedQuestion(id: "q_25_047", correctAnswer: 1, variants: [
            .init(text: "What does the President's Cabinet do?",
                  options: ["Writes laws", "Advises the President", "Decides court cases", "Elects the next President"],
                  explanation: "The Cabinet is a group of advisors to the President, made up of the heads of the federal departments (like Secretary of State, Secretary of Defense)."),
            .init(text: "राष्ट्रपतिको मन्त्रिपरिषदले के गर्छ?",
                  options: ["कानून लेख्छ", "राष्ट्रपतिलाई सल्लाह दिन्छ", "अदालतका मुद्दाहरू निर्णय गर्छ", "अर्को राष्ट्रपति चुन्छ"],
                  explanation: "मन्त्रिपरिषद राष्ट्रपतिका सल्लाहकारहरूको समूह हो, जुन संघीय विभागहरूका प्रमुखहरूले बनेको हुन्छ (विदेश मन्त्री, रक्षा मन्त्री जस्ता)।")
        ]),
        UnifiedQuestion(id: "q_25_048", correctAnswer: 0, variants: [
            .init(text: "What are two Cabinet-level positions?",
                  options: ["Secretary of State and Attorney General", "Speaker of the House and Senate Majority Leader", "Chief Justice and Vice President", "Governor and Mayor"],
                  explanation: "Cabinet-level positions include Secretary of State, Attorney General, Secretary of Defense, Secretary of the Treasury, Secretary of Homeland Security, and many others."),
            .init(text: "दुई मन्त्रिपरिषद स्तरका पदहरू कुन-कुन हुन्?",
                  options: ["विदेश मन्त्री र महान्यायाधिवक्ता", "प्रतिनिधि सभाका सभामुख र सेनेट बहुमत नेता", "प्रधान न्यायाधीश र उपराष्ट्रपति", "गभर्नर र मेयर"],
                  explanation: "मन्त्रिपरिषद स्तरका पदहरूमा विदेश मन्त्री, महान्यायाधिवक्ता, रक्षा मन्त्री, अर्थ मन्त्री, गृह सुरक्षा मन्त्री र अरू धेरै समावेश छन्।")
        ]),
        UnifiedQuestion(id: "q_25_049", correctAnswer: 0, variants: [
            .init(text: "Why is the Electoral College important?",
                  options: ["It decides who is elected President", "It chooses Supreme Court Justices", "It teaches government in college", "It runs federal elections"],
                  explanation: "The Electoral College decides who is elected President. It is a compromise between popular election and congressional selection of the President."),
            .init(text: "निर्वाचक मण्डल किन महत्वपूर्ण छ?",
                  options: ["यसले राष्ट्रपति को निर्वाचित हुन्छन् भन्ने निर्णय गर्छ", "यसले सर्वोच्च अदालतका न्यायाधीशहरू छनोट गर्छ", "यसले कलेजमा सरकार पढाउँछ", "यसले संघीय निर्वाचनहरू सञ्चालन गर्छ"],
                  explanation: "निर्वाचक मण्डलले राष्ट्रपति को निर्वाचित हुन्छन् भन्ने निर्णय गर्छ। यो राष्ट्रपतिको लोकप्रिय निर्वाचन र कांग्रेसको चयनबीचको सम्झौता हो।")
        ]),
        UnifiedQuestion(id: "q_25_050", correctAnswer: 2, variants: [
            .init(text: "What is one part of the judicial branch?",
                  options: ["The Senate", "The Cabinet", "The Supreme Court", "The Pentagon"],
                  explanation: "The judicial branch includes the Supreme Court and the federal courts (district courts and courts of appeals)."),
            .init(text: "न्यायपालिका शाखाको एउटा भाग कुन हो?",
                  options: ["सेनेट", "मन्त्रिपरिषद", "सर्वोच्च अदालत", "पेन्टागन"],
                  explanation: "न्यायपालिका शाखामा सर्वोच्च अदालत र संघीय अदालतहरू (जिल्ला अदालत र पुनरावेदन अदालतहरू) समावेश छन्।")
        ]),
        UnifiedQuestion(id: "q_25_051", correctAnswer: 1, variants: [
            .init(text: "What does the judicial branch do?",
                  options: ["Writes laws", "Reviews and explains laws", "Commands the military", "Collects taxes"],
                  explanation: "The judicial branch reviews laws, explains them, resolves disputes, and decides if a law goes against the Constitution."),
            .init(text: "न्यायपालिका शाखाले के गर्छ?",
                  options: ["कानूनहरू लेख्छ", "कानूनहरू समीक्षा गर्छ र व्याख्या गर्छ", "सेनाको आदेश गर्छ", "कर उठाउँछ"],
                  explanation: "न्यायपालिका शाखाले कानूनहरू समीक्षा गर्छ, व्याख्या गर्छ, विवादहरू समाधान गर्छ, र कुनै कानून संविधान विरुद्ध छ कि छैन निर्णय गर्छ।")
        ]),
        UnifiedQuestion(id: "q_25_054", correctAnswer: 1, variants: [
            .init(text: "How many Supreme Court justices are usually needed to decide a case?",
                  options: ["3", "6 (a quorum)", "9 (all)", "5"],
                  explanation: "Per 28 U.S.C. §1, six (6) Justices constitute a quorum — the minimum number required to hear and decide a Supreme Court case. This is the official USCIS answer."),
            .init(text: "मुद्दा निर्णय गर्न सर्वोच्च अदालतका कति न्यायाधीशहरू सामान्यतया आवश्यक हुन्छन्?",
                  options: ["३", "६ (कोरम)", "९ (सबै)", "५"],
                  explanation: "२८ U.S.C. §१ अनुसार, सर्वोच्च अदालतमा मुद्दा सुन्न र निर्णय गर्न आवश्यक न्यूनतम न्यायाधीशको संख्या — कोरम — ६ हो। यो USCIS को आधिकारिक उत्तर हो।")
        ]),
        UnifiedQuestion(id: "q_25_055", correctAnswer: 3, variants: [
            .init(text: "How long do Supreme Court justices serve?",
                  options: ["4 years", "8 years", "12 years", "For life (lifetime appointment)"],
                  explanation: "Supreme Court Justices serve for life or until retirement. Lifetime appointments shield them from political pressure."),
            .init(text: "सर्वोच्च अदालतका न्यायाधीशहरूले कति समयसम्म सेवा गर्छन्?",
                  options: ["४ वर्ष", "८ वर्ष", "१२ वर्ष", "जीवनभर (जीवनकालीन नियुक्ति)"],
                  explanation: "सर्वोच्च अदालतका न्यायाधीशहरूले जीवनभर वा अवकाशसम्म सेवा गर्छन्। जीवनकालीन नियुक्तिले उनीहरूलाई राजनीतिक दबाबबाट जोगाउँछ।")
        ])
    ]

    // MARK: - Practice 5: Judicial, Federalism & Rights (16 questions)
    static let practice5: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_056", correctAnswer: 1, variants: [
            .init(text: "Supreme Court justices serve for life. Why?",
                  options: ["To save retirement costs", "To be independent of politics", "Because they cannot be replaced", "Because they're appointed by the people"],
                  explanation: "Lifetime appointments protect Justices from political pressure, allowing them to interpret the Constitution independently."),
            .init(text: "सर्वोच्च अदालतका न्यायाधीशहरूले जीवनभर सेवा गर्छन्। किन?",
                  options: ["अवकाश खर्च बचाउन", "राजनीतिबाट स्वतन्त्र हुन", "किनभने उनीहरूलाई प्रतिस्थापन गर्न सकिँदैन", "किनभने उनीहरू जनताद्वारा नियुक्त गरिएका छन्"],
                  explanation: "जीवनकालीन नियुक्तिले न्यायाधीशहरूलाई राजनीतिक दबाबबाट जोगाउँछ, जसले उनीहरूलाई संविधानको स्वतन्त्र व्याख्या गर्न दिन्छ।")
        ]),
        UnifiedQuestion(id: "q_25_057", correctAnswer: 0, variants: [
            .init(text: "Who is the Chief Justice of the United States now?",
                  options: ["John Roberts", "Clarence Thomas", "Amy Coney Barrett", "Sonia Sotomayor"],
                  explanation: "John Roberts has been Chief Justice since 2005. He presides over the Supreme Court and over presidential impeachment trials."),
            .init(text: "हाल अमेरिकाका प्रधान न्यायाधीश को हुन्?",
                  options: ["जोन रोबर्ट्स", "क्लारेन्स थोमस", "एमी कोनी ब्यारेट", "सोनिया सोटोमायोर"],
                  explanation: "जोन रोबर्ट्स २००५ देखि प्रधान न्यायाधीश हुन्। उनले सर्वोच्च अदालत र राष्ट्रपति महाभियोगका सुनुवाइहरूको अध्यक्षता गर्छन्।")
        ]),
        UnifiedQuestion(id: "q_25_058", correctAnswer: 2, variants: [
            .init(text: "Name one power that is only for the federal government.",
                  options: ["Issue driver's licenses", "Run public schools", "Declare war (or print money)", "Provide police services"],
                  explanation: "Federal-only powers include declaring war, printing paper money, minting coins, creating an army, making treaties, and setting foreign policy."),
            .init(text: "केवल संघीय सरकारको लागि भएको एउटा शक्तिको नाम लिनुहोस्।",
                  options: ["सवारी चालक अनुमतिपत्र जारी गर्ने", "सार्वजनिक विद्यालयहरू सञ्चालन गर्ने", "युद्ध घोषणा गर्ने (वा पैसा छाप्ने)", "प्रहरी सेवा प्रदान गर्ने"],
                  explanation: "केवल संघीय शक्तिहरूमा युद्ध घोषणा गर्ने, कागजी मुद्रा छाप्ने, सिक्का बनाउने, सेना सिर्जना गर्ने, सन्धि बनाउने र विदेश नीति स्थापना गर्ने समावेश छन्।")
        ]),
        UnifiedQuestion(id: "q_25_059", correctAnswer: 2, variants: [
            .init(text: "Name one power that is only for the states.",
                  options: ["Print money", "Declare war", "Provide schooling and police protection", "Sign treaties"],
                  explanation: "State-only powers include providing education and schools, police and fire protection, issuing driver's licenses, and approving zoning."),
            .init(text: "केवल राज्यका लागि भएको एउटा शक्तिको नाम लिनुहोस्।",
                  options: ["पैसा छाप्ने", "युद्ध घोषणा गर्ने", "शिक्षा र प्रहरी सुरक्षा प्रदान गर्ने", "सन्धिहरूमा हस्ताक्षर गर्ने"],
                  explanation: "केवल राज्यका शक्तिहरूमा शिक्षा र विद्यालयहरू, प्रहरी र अग्निशामक सेवा, सवारी चालक अनुमतिपत्र जारी गर्ने र क्षेत्र विभाजन अनुमोदन गर्ने समावेश छन्।")
        ]),
        UnifiedQuestion(id: "q_25_061", correctAnswer: 0, variants: [
            .init(text: "Who is the governor of your state now?",
                  options: ["Depends on your state", "Donald Trump", "Joe Biden", "Gavin Newsom"],
                  explanation: "Each state has its own Governor. Look up your current Governor on your state government's website. (Territories have appointed governors; D.C. has a mayor instead.)"),
            .init(text: "तपाईंको राज्यका हालका गभर्नर को हुन्?",
                  options: ["तपाईंको राज्यमा निर्भर", "डोनाल्ड ट्रम्प", "जो बाइडेन", "ग्याभिन न्युसम"],
                  explanation: "प्रत्येक राज्यको आफ्नै गभर्नर हुन्छ। आफ्नो राज्य सरकारको वेबसाइटमा हालका गभर्नरको जानकारी हेर्नुहोस्। (क्षेत्रहरूका गभर्नरहरू नियुक्त गरिएका हुन्छन्; डि.सी. मा गभर्नरको सट्टा मेयर हुन्छ।)")
        ]),
        UnifiedQuestion(id: "q_25_062", correctAnswer: 0, variants: [
            .init(text: "What is the capital of your state?",
                  options: ["Depends on your state", "Washington, D.C.", "New York City", "Los Angeles"],
                  explanation: "Each state has its own capital city. Know your state's capital before your interview. (D.C. is the U.S. capital, not a state. Territories also have capitals.)"),
            .init(text: "तपाईंको राज्यको राजधानी के हो?",
                  options: ["तपाईंको राज्यअनुसार फरक", "वाशिङ्टन, डी.सी.", "न्यूयोर्क सहर", "लस एन्जलस"],
                  explanation: "प्रत्येक राज्यको आफ्नै राजधानी सहर हुन्छ। अन्तर्वार्ता अघि आफ्नो राज्यको राजधानी थाहा पाउनुहोस्। (डि.सी. अमेरिकी राजधानी हो, राज्य होइन। क्षेत्रहरूको पनि आफ्नै राजधानी हुन्छन्।)")
        ]),
        UnifiedQuestion(id: "q_25_063", correctAnswer: 1, variants: [
            .init(text: "There are four amendments to the U.S. Constitution about who can vote. Describe one of them.",
                  options: ["Only homeowners can vote", "Citizens 18 and older can vote", "Only male citizens can vote", "Voting requires a literacy test"],
                  explanation: "The 26th Amendment (1971) lowered the voting age to 18. Other voting amendments are the 15th (men of any race), 19th (women), and 24th (no poll tax)."),
            .init(text: "अमेरिकी संविधानमा को मतदान गर्न सक्छ भन्ने बारेमा चार वटा संशोधनहरू छन्। एउटाको वर्णन गर्नुहोस्।",
                  options: ["केवल घरधनीहरूले मतदान गर्न सक्छन्", "१८ वर्ष वा माथिका नागरिकहरूले मतदान गर्न सक्छन्", "केवल पुरुष नागरिकहरूले मतदान गर्न सक्छन्", "मतदान गर्न साक्षरता परीक्षा आवश्यक छ"],
                  explanation: "२६औं संशोधन (१९७१) ले मतदानको उमेर १८ वर्षमा झार्‍यो। अन्य मतदान सम्बन्धी संशोधनहरू १५औं (कुनै पनि जातिका पुरुष), १९औं (महिला) र २४औं (मतदान कर हटाउने) हुन्।")
        ]),
        UnifiedQuestion(id: "q_25_064", correctAnswer: 1, variants: [
            .init(text: "Who can vote in federal elections, run for federal office, and serve on a jury in the United States?",
                  options: ["All adults", "U.S. citizens only", "Anyone with a passport", "Only military veterans"],
                  explanation: "Only U.S. citizens have the rights to vote in federal elections, run for federal office, and serve on a jury."),
            .init(text: "अमेरिकामा संघीय निर्वाचनमा मतदान गर्न, संघीय पदका लागि उम्मेदवारी दिन र जुरीमा सेवा गर्न को सक्छ?",
                  options: ["सबै वयस्कहरू", "केवल अमेरिकी नागरिकहरू", "राहदानी भएका जो कोही", "केवल सैनिक भूतपूर्व सैनिकहरू"],
                  explanation: "केवल अमेरिकी नागरिकहरूले संघीय निर्वाचनमा मतदान गर्ने, संघीय पदका लागि उम्मेदवारी दिने र जुरीमा सेवा गर्ने अधिकार राख्छन्।")
        ]),
        UnifiedQuestion(id: "q_25_065", correctAnswer: 1, variants: [
            .init(text: "What are three rights of everyone living in the United States?",
                  options: ["Free housing, free food, free healthcare", "Freedom of speech, freedom of religion, and freedom of assembly", "Right to vote, run for office, and own land", "Right to drive, own a gun, and choose any job"],
                  explanation: "Rights of everyone living in the U.S. (citizen or not) include freedom of speech, religion, assembly, the press, and to petition the government."),
            .init(text: "अमेरिकामा बस्ने सबैका तीन अधिकारहरू के हुन्?",
                  options: ["निःशुल्क आवास, निःशुल्क खाना, निःशुल्क स्वास्थ्य सेवा", "बोल्ने स्वतन्त्रता, धर्मको स्वतन्त्रता र भेला हुने स्वतन्त्रता", "मतदान, उम्मेदवारी र जग्गा स्वामित्वको अधिकार", "गाडी चलाउने, बन्दुक राख्ने र कुनै पनि काम छनोट गर्ने अधिकार"],
                  explanation: "अमेरिकामा बस्ने सबैका (नागरिक भए पनि नभए पनि) अधिकारहरूमा बोल्ने स्वतन्त्रता, धर्म, भेला, प्रेस र सरकारलाई बिन्तीपत्र दिने स्वतन्त्रता समावेश छन्।")
        ]),
        UnifiedQuestion(id: "q_25_067", correctAnswer: 1, variants: [
            .init(text: "Name two promises that new citizens make in the Oath of Allegiance.",
                  options: ["Pay extra taxes and vote in every election", "Give up loyalty to other countries and obey U.S. laws", "Speak only English and serve in the military", "Become Christian and own property"],
                  explanation: "The Oath includes giving up loyalty to other countries, defending the Constitution, obeying U.S. laws, and serving the nation when needed."),
            .init(text: "नयाँ नागरिकहरूले निष्ठाको शपथमा गर्ने दुई वाचाहरूको नाम लिनुहोस्।",
                  options: ["अतिरिक्त कर तिर्ने र हरेक निर्वाचनमा मतदान गर्ने", "अन्य देशहरूप्रति निष्ठा त्याग्ने र अमेरिकी कानूनहरू पालना गर्ने", "केवल अंग्रेजी बोल्ने र सेनामा सेवा गर्ने", "इसाई बन्ने र सम्पत्ति स्वामित्व गर्ने"],
                  explanation: "शपथमा अन्य देशहरूप्रति निष्ठा त्याग्ने, संविधानको रक्षा गर्ने, अमेरिकी कानूनहरू पालना गर्ने र आवश्यक परेमा देशको सेवा गर्ने समावेश छ।")
        ]),
        UnifiedQuestion(id: "q_25_068", correctAnswer: 1, variants: [
            .init(text: "How can people become United States citizens?",
                  options: ["Only by being born in the U.S.", "By naturalization or being born in the U.S. (under certain conditions)", "Only by marrying a U.S. citizen", "Only by joining the military"],
                  explanation: "People become U.S. citizens by being born in the U.S. (under conditions of the 14th Amendment), through naturalization, or by deriving citizenship through their parents."),
            .init(text: "मानिसहरू कसरी अमेरिकी नागरिक बन्न सक्छन्?",
                  options: ["केवल अमेरिकामा जन्मेर", "प्राकृतिकीकरण वा अमेरिकामा जन्मेर (निश्चित शर्तहरूमा)", "केवल अमेरिकी नागरिकसँग विवाह गरेर", "केवल सेनामा सामेल भएर"],
                  explanation: "मानिसहरू अमेरिकामा जन्मेर (१४औं संशोधनको शर्तहरूमा), प्राकृतिकीकरणद्वारा, वा आफ्ना अभिभावकमार्फत नागरिकता प्राप्त गरेर अमेरिकी नागरिक बन्छन्।")
        ]),
        UnifiedQuestion(id: "q_25_069", correctAnswer: 1, variants: [
            .init(text: "What are two examples of civic participation in the United States?",
                  options: ["Eating at restaurants and watching TV", "Voting and joining a community group", "Working a job and paying rent", "Driving a car and owning a home"],
                  explanation: "Civic participation includes voting, running for office, joining a political party or community group, contacting elected officials, and supporting/opposing issues."),
            .init(text: "अमेरिकामा नागरिक सहभागिताका दुई उदाहरण के-के हुन्?",
                  options: ["रेस्टुरेन्टमा खानु र टिभी हेर्नु", "मतदान गर्नु र सामुदायिक समूहमा सामेल हुनु", "काम गर्नु र भाडा तिर्नु", "गाडी चलाउनु र घरको स्वामित्व राख्नु"],
                  explanation: "नागरिक सहभागितामा मतदान गर्ने, उम्मेदवारी दिने, राजनीतिक पार्टी वा सामुदायिक समूहमा सामेल हुने, निर्वाचित पदाधिकारीहरूलाई सम्पर्क गर्ने र विषयहरूको समर्थन/विरोध गर्ने समावेश छन्।")
        ]),
        UnifiedQuestion(id: "q_25_070", correctAnswer: 1, variants: [
            .init(text: "What is one way Americans can serve their country?",
                  options: ["Get a high-paying job", "Serve in the military, work for the government, or pay taxes", "Travel abroad as a tourist", "Buy U.S.-made products"],
                  explanation: "Americans can serve by voting, paying taxes, obeying the law, serving in the military, running for office, or working for local, state, or federal government."),
            .init(text: "अमेरिकीहरूले आफ्नो देशको सेवा गर्ने एउटा तरिका के हो?",
                  options: ["राम्रो तलब हुने जागिर लिने", "सेनामा सेवा गर्ने, सरकारका लागि काम गर्ने, वा कर तिर्ने", "पर्यटकको रूपमा विदेश यात्रा गर्ने", "अमेरिकी उत्पादनहरू किन्ने"],
                  explanation: "अमेरिकीहरूले मतदान गरेर, कर तिरेर, कानून पालना गरेर, सेनामा सेवा गरेर, उम्मेदवारी दिएर, वा स्थानीय, राज्य वा संघीय सरकारमा काम गरेर सेवा गर्न सक्छन्।")
        ]),
        UnifiedQuestion(id: "q_25_071", correctAnswer: 1, variants: [
            .init(text: "Why is it important to pay federal taxes?",
                  options: ["Because tax money goes to other countries", "It is required by law and funds the federal government", "Only wealthy citizens pay taxes", "Taxes are voluntary in the U.S."],
                  explanation: "Paying federal taxes is required by law and funds the federal government. The 16th Amendment (1913) authorized the federal income tax."),
            .init(text: "संघीय कर तिर्नु किन महत्वपूर्ण छ?",
                  options: ["किनभने करको पैसा अन्य देशहरूमा जान्छ", "यो कानूनद्वारा आवश्यक छ र संघीय सरकारलाई बजेट जुटाउँछ", "केवल धनी नागरिकहरूले कर तिर्छन्", "अमेरिकामा कर स्वैच्छिक छ"],
                  explanation: "संघीय कर तिर्नु कानूनद्वारा आवश्यक छ र संघीय सरकारलाई बजेट जुटाउँछ। १६औं संशोधन (१९१३) ले संघीय आयकरलाई अधिकार दिएको थियो।")
        ]),
        UnifiedQuestion(id: "q_25_072", correctAnswer: 1, variants: [
            .init(text: "It is important for all men age 18 through 25 to register for the Selective Service. Name one reason why.",
                  options: ["To get a free college education", "It is required by law (to make a draft fair if needed)", "To receive Social Security benefits", "To get a passport"],
                  explanation: "Selective Service registration is required by law for men ages 18-25. It allows the government to conduct a fair draft if one becomes necessary."),
            .init(text: "१८ देखि २५ वर्ष उमेरका सबै पुरुषहरूले छनोट सेवामा दर्ता गर्नु महत्वपूर्ण छ। एउटा कारण भन्नुहोस्।",
                  options: ["निःशुल्क कलेज शिक्षाका लागि", "यो कानूनद्वारा आवश्यक छ (आवश्यक परे निष्पक्ष भर्ना सुनिश्चित गर्न)", "सामाजिक सुरक्षा सुविधा प्राप्त गर्न", "राहदानी प्राप्त गर्न"],
                  explanation: "१८-२५ वर्ष उमेरका पुरुषहरूका लागि छनोट सेवा दर्ता कानूनद्वारा आवश्यक छ। यसले सरकारलाई आवश्यक परेमा निष्पक्ष भर्ना सञ्चालन गर्न दिन्छ।")
        ]),
        UnifiedQuestion(id: "q_25_125", correctAnswer: 1, variants: [
            .init(text: "What is Independence Day?",
                  options: ["A holiday for Christopher Columbus", "A holiday celebrating U.S. independence from Britain", "A holiday honoring veterans", "A holiday for the Constitution"],
                  explanation: "Independence Day (July 4) celebrates the adoption of the Declaration of Independence in 1776 — the country's birthday."),
            .init(text: "स्वतन्त्रता दिवस के हो?",
                  options: ["क्रिस्टोफर कोलम्बसका लागि बिदा", "बेलायतबाट अमेरिकी स्वतन्त्रता मनाउने बिदा", "भूतपूर्व सैनिकहरूको सम्मानमा बिदा", "संविधानका लागि बिदा"],
                  explanation: "स्वतन्त्रता दिवस (जुलाई ४) ले १७७६ मा स्वतन्त्रताको घोषणापत्र पारित भएको — देशको जन्मदिन — मनाउँछ।")
        ])
    ]

    // MARK: - Practice 6: Founding Era & Revolution (16 questions)
    static let practice6: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_073", correctAnswer: 1, variants: [
            .init(text: "The colonists came to America for many reasons. Name one.",
                  options: ["To start a new civilization", "Religious freedom", "To find gold only", "To meet Native Americans"],
                  explanation: "Many colonists came seeking religious freedom, escaping persecution. Others came for political liberty or economic opportunity."),
            .init(text: "उपनिवेशीहरू धेरै कारणले अमेरिका आएका थिए। एउटा कारण भन्नुहोस्।",
                  options: ["नयाँ सभ्यता सुरु गर्न", "धार्मिक स्वतन्त्रता", "केवल सुन खोज्न", "मूल अमेरिकीहरूलाई भेट्न"],
                  explanation: "धेरै उपनिवेशीहरू धार्मिक स्वतन्त्रता खोज्दै, उत्पीडनबाट उम्किन आएका थिए। अरूहरू राजनीतिक स्वतन्त्रता वा आर्थिक अवसरका लागि आए।")
        ]),
        UnifiedQuestion(id: "q_25_074", correctAnswer: 2, variants: [
            .init(text: "Who lived in America before the Europeans arrived?",
                  options: ["African settlers", "Asian immigrants", "American Indians (Native Americans)", "European explorers"],
                  explanation: "American Indians (Native Americans) lived across the Americas for thousands of years before European arrival."),
            .init(text: "युरोपेलीहरू आउनुअघि अमेरिकामा को बस्थे?",
                  options: ["अफ्रिकी बासिन्दा", "एसियाली आप्रवासीहरू", "अमेरिकी आदिवासी (मूल अमेरिकीहरू)", "युरोपेली अन्वेषकहरू"],
                  explanation: "युरोपेलीहरू आउनुअघि हजारौं वर्षदेखि अमेरिकी आदिवासीहरू (मूल अमेरिकीहरू) अमेरिकाहरूभर बस्दै आएका थिए।")
        ]),
        UnifiedQuestion(id: "q_25_075", correctAnswer: 2, variants: [
            .init(text: "What group of people was taken and sold as slaves?",
                  options: ["Native Americans", "Europeans", "Africans (people from Africa)", "Asians"],
                  explanation: "Africans were taken from their homelands and sold as slaves in the Americas, primarily from the 1500s to the 1800s."),
            .init(text: "कुन समूहका मानिसहरूलाई लगिएर दास बनाएर बेचियो?",
                  options: ["मूल अमेरिकीहरू", "युरोपेलीहरू", "अफ्रिकीहरू (अफ्रिकाबाट आएका मानिसहरू)", "एसियालीहरू"],
                  explanation: "मुख्य रूपमा १५०० देखि १८०० सम्म अफ्रिकीहरूलाई आफ्नो मातृभूमिबाट लगिएर अमेरिकाहरूमा दासको रूपमा बेचिएको थियो।")
        ]),
        UnifiedQuestion(id: "q_25_076", correctAnswer: 1, variants: [
            .init(text: "What war did the Americans fight to win independence from Britain?",
                  options: ["The Civil War", "The American Revolution (Revolutionary War)", "The War of 1812", "World War I"],
                  explanation: "The American Revolution (1775-1783) won the colonies' independence from Britain, formalized by the Treaty of Paris in 1783."),
            .init(text: "बेलायतबाट स्वतन्त्रता जित्न अमेरिकीहरूले कुन युद्ध लडे?",
                  options: ["गृहयुद्ध", "अमेरिकी क्रान्ति (क्रान्तिकारी युद्ध)", "१८१२ को युद्ध", "पहिलो विश्वयुद्ध"],
                  explanation: "अमेरिकी क्रान्ति (१७७५-१७८३) ले उपनिवेशहरूलाई बेलायतबाट स्वतन्त्रता दिलायो, जुन १७८३ मा प्यारिसको सन्धिले औपचारिक बनायो।")
        ]),
        UnifiedQuestion(id: "q_25_077", correctAnswer: 1, variants: [
            .init(text: "Name one reason why the Americans declared independence from Britain.",
                  options: ["Britain treated colonists too well", "High taxes (taxation without representation)", "The colonies wanted to merge with France", "British food was unhealthy"],
                  explanation: "Reasons included high taxes (taxation without representation), British soldiers in colonial homes, lack of self-government, the Boston Massacre, and the Boston Tea Party."),
            .init(text: "अमेरिकीहरूले बेलायतबाट स्वतन्त्रता घोषणा गर्नुको एउटा कारण भन्नुहोस्।",
                  options: ["बेलायतले उपनिवेशीहरूलाई धेरै राम्रो व्यवहार गर्थ्यो", "उच्च कर (प्रतिनिधित्व बिनाको कर)", "उपनिवेशहरू फ्रान्ससँग जोडिन चाहन्थे", "बेलायती खाना अस्वस्थ थियो"],
                  explanation: "कारणहरूमा उच्च कर (प्रतिनिधित्व बिनाको कर), बेलायती सिपाहीहरू उपनिवेशी घरमा बस्ने, स्व-शासनको अभाव, बोस्टन नरसंहार र बोस्टन चियाको पार्टी समावेश थिए।")
        ]),
        UnifiedQuestion(id: "q_25_078", correctAnswer: 1, variants: [
            .init(text: "Who wrote the Declaration of Independence?",
                  options: ["George Washington", "Thomas Jefferson", "Benjamin Franklin", "John Adams"],
                  explanation: "Thomas Jefferson was the principal author of the Declaration of Independence, drafted in 1776 at age 33."),
            .init(text: "स्वतन्त्रताको घोषणापत्र कसले लेखेका थिए?",
                  options: ["जर्ज वाशिंगटन", "थोमस जेफरसन", "बेन्जामिन फ्र्याङ्कलिन", "जोन एडम्स"],
                  explanation: "थोमस जेफरसन स्वतन्त्रताको घोषणापत्रका मुख्य लेखक थिए, जुन उनले ३३ वर्षको उमेरमा १७७६ मा लेखेका थिए।")
        ]),
        UnifiedQuestion(id: "q_25_079", correctAnswer: 1, variants: [
            .init(text: "When was the Declaration of Independence adopted?",
                  options: ["July 4, 1775", "July 4, 1776", "July 4, 1789", "July 4, 1812"],
                  explanation: "The Declaration of Independence was adopted on July 4, 1776 — celebrated annually as Independence Day."),
            .init(text: "स्वतन्त्रताको घोषणापत्र कहिले अंगिकार गरिएको थियो?",
                  options: ["जुलाई ४, १७७५", "जुलाई ४, १७७६", "जुलाई ४, १७८९", "जुलाई ४, १८१२"],
                  explanation: "स्वतन्त्रताको घोषणापत्र जुलाई ४, १७७६ मा अंगिकार गरिएको थियो — यो प्रत्येक वर्ष स्वतन्त्रता दिवसको रूपमा मनाइन्छ।")
        ]),
        UnifiedQuestion(id: "q_25_080", correctAnswer: 1, variants: [
            .init(text: "The American Revolution had many important events. Name one.",
                  options: ["The Battle of Gettysburg", "The Declaration of Independence (1776)", "Pearl Harbor attack", "Fall of the Berlin Wall"],
                  explanation: "Important Revolution events include the Battle of Bunker Hill, the Declaration of Independence, Washington crossing the Delaware, Valley Forge, and the Battle of Yorktown."),
            .init(text: "अमेरिकी क्रान्तिमा धेरै महत्वपूर्ण घटनाहरू भएका थिए। एउटाको नाम लिनुहोस्।",
                  options: ["गेटिसबर्गको लडाई", "स्वतन्त्रताको घोषणापत्र (१७७६)", "पर्ल हार्बर आक्रमण", "बर्लिन पर्खालको पतन"],
                  explanation: "क्रान्तिका महत्वपूर्ण घटनाहरूमा बङ्कर हिलको लडाई, स्वतन्त्रताको घोषणापत्र, वाशिङ्टनको डेलावेयर पार, भ्याली फोर्ज र योर्कटाउनको लडाई समावेश छन्।")
        ]),
        UnifiedQuestion(id: "q_25_081", correctAnswer: 1, variants: [
            .init(text: "There were 13 original states. Name five.",
                  options: ["California, Texas, Florida, Hawaii, Alaska", "Virginia, Massachusetts, New York, Pennsylvania, Georgia", "Ohio, Michigan, Illinois, Indiana, Wisconsin", "Maine, Vermont, West Virginia, Oregon, Iowa"],
                  explanation: "The 13 original states were New Hampshire, Massachusetts, Rhode Island, Connecticut, New York, New Jersey, Pennsylvania, Delaware, Maryland, Virginia, North Carolina, South Carolina, and Georgia."),
            .init(text: "१३ वटा मौलिक राज्यहरू थिए। पाँचको नाम लिनुहोस्।",
                  options: ["क्यालिफोर्निया, टेक्सास, फ्लोरिडा, हवाई, अलास्का", "भर्जिनिया, म्यासाचुसेट्स, न्यूयोर्क, पेन्सिल्भेनिया, जर्जिया", "ओहायो, मिशिगन, इलिनोइस, इन्डियाना, विस्कन्सिन", "मेन, भर्मन्ट, पश्चिम भर्जिनिया, ओरेगन, आयोवा"],
                  explanation: "१३ मौलिक राज्यहरू न्यू ह्याम्पशायर, म्यासाचुसेट्स, रोड आइल्यान्ड, कनेक्टिकट, न्यूयोर्क, न्यू जर्सी, पेन्सिल्भेनिया, डेलावेयर, म्यारिल्यान्ड, भर्जिनिया, उत्तर क्यारोलिना, दक्षिण क्यारोलिना र जर्जिया थिए।")
        ]),
        UnifiedQuestion(id: "q_25_082", correctAnswer: 1, variants: [
            .init(text: "What founding document was written in 1787?",
                  options: ["The Declaration of Independence", "The U.S. Constitution", "The Bill of Rights", "The Articles of Confederation"],
                  explanation: "The U.S. Constitution was written at the Constitutional Convention in Philadelphia in 1787 and ratified in 1788."),
            .init(text: "१७८७ मा कुन स्थापक दस्तावेज लेखिएको थियो?",
                  options: ["स्वतन्त्रताको घोषणापत्र", "अमेरिकी संविधान", "अधिकारको विधेयक", "महासंघका लेखहरू"],
                  explanation: "अमेरिकी संविधान १७८७ मा फिलाडेल्फियाको संवैधानिक सम्मेलनमा लेखिएको थियो र १७८८ मा अनुमोदन भएको थियो।")
        ]),
        UnifiedQuestion(id: "q_25_083", correctAnswer: 1, variants: [
            .init(text: "The Federalist Papers supported the passage of the U.S. Constitution. Name one of the writers.",
                  options: ["Thomas Jefferson", "James Madison (or Hamilton, or Jay)", "George Washington", "Benjamin Franklin"],
                  explanation: "The Federalist Papers were written by James Madison, Alexander Hamilton, and John Jay (under the pen name \"Publius\") to argue for ratifying the Constitution."),
            .init(text: "फेडेरलिस्ट पेपर्सले अमेरिकी संविधानको पारित हुनलाई समर्थन गरेको थियो। यसका एक लेखकको नाम लिनुहोस्।",
                  options: ["थोमस जेफरसन", "जेम्स म्याडिसन (वा ह्यामिल्टन, वा जे)", "जर्ज वाशिंगटन", "बेन्जामिन फ्र्याङ्कलिन"],
                  explanation: "फेडेरलिस्ट पेपर्स जेम्स म्याडिसन, अलेक्जान्डर ह्यामिल्टन र जोन जेले (कलमी नाम «पब्लियस» मा) संविधान अनुमोदनको पक्षमा तर्क गर्न लेखेका थिए।")
        ]),
        UnifiedQuestion(id: "q_25_084", correctAnswer: 1, variants: [
            .init(text: "Why were the Federalist Papers important?",
                  options: ["They led to the American Revolution", "They helped people understand and supported passing the Constitution", "They started the Civil War", "They wrote new amendments"],
                  explanation: "The 85 Federalist essays explained how the new Constitution would work and persuaded states (especially New York) to ratify it."),
            .init(text: "फेडेरलिस्ट पेपर्स किन महत्वपूर्ण थिए?",
                  options: ["यिनले अमेरिकी क्रान्तिको नेतृत्व गरे", "यिनले जनतालाई बुझ्न सहयोग गरे र संविधान पारित गर्न समर्थन गरे", "यिनले गृहयुद्ध सुरु गरे", "यिनले नयाँ संशोधनहरू लेखे"],
                  explanation: "८५ फेडेरलिस्ट निबन्धहरूले नयाँ संविधान कसरी काम गर्छ भनेर व्याख्या गरे र राज्यहरूलाई (विशेष गरी न्यूयोर्कलाई) अनुमोदन गर्न मनाए।")
        ]),
        UnifiedQuestion(id: "q_25_085", correctAnswer: 1, variants: [
            .init(text: "Benjamin Franklin is famous for many things. Name one.",
                  options: ["First President", "First Postmaster General and inventor", "Wrote the Declaration of Independence alone", "First Chief Justice"],
                  explanation: "Franklin was the first Postmaster General, an inventor, a U.S. diplomat, founder of the first free public libraries, and helped write the Declaration of Independence."),
            .init(text: "बेन्जामिन फ्र्याङ्कलिन धेरै कुराका लागि प्रसिद्ध छन्। एउटाको नाम लिनुहोस्।",
                  options: ["पहिलो राष्ट्रपति", "पहिलो हुलाक महानिर्देशक र आविष्कारक", "स्वतन्त्रताको घोषणापत्र एक्लै लेखे", "पहिलो प्रधान न्यायाधीश"],
                  explanation: "फ्र्याङ्कलिन पहिलो हुलाक महानिर्देशक, आविष्कारक, अमेरिकी कूटनीतिज्ञ, पहिलो निःशुल्क सार्वजनिक पुस्तकालयका संस्थापक थिए, र स्वतन्त्रताको घोषणापत्र लेख्न मद्दत गरेका थिए।")
        ]),
        UnifiedQuestion(id: "q_25_086", correctAnswer: 1, variants: [
            .init(text: "George Washington is famous for many things. Name one.",
                  options: ["Wrote the Declaration of Independence", "First President of the United States", "Discovered America", "Wrote the Star-Spangled Banner"],
                  explanation: "Washington is called the \"Father of Our Country.\" He led the Continental Army and was the first U.S. President (1789-1797)."),
            .init(text: "जर्ज वाशिंगटन धेरै कुराका लागि प्रसिद्ध छन्। एउटाको नाम लिनुहोस्।",
                  options: ["स्वतन्त्रताको घोषणापत्र लेखे", "अमेरिकाका पहिलो राष्ट्रपति", "अमेरिका पत्ता लगाए", "स्टार-स्पैङ्ग्ल्ड ब्यानर लेखे"],
                  explanation: "वाशिंगटनलाई «राष्ट्रको पिता» भनिन्छ। उनले महाद्वीपीय सेनाको नेतृत्व गरे र अमेरिकाका पहिलो राष्ट्रपति (१७८९-१७९७) थिए।")
        ]),
        UnifiedQuestion(id: "q_25_087", correctAnswer: 1, variants: [
            .init(text: "Thomas Jefferson is famous for many things. Name one.",
                  options: ["Discovered electricity", "Wrote the Declaration of Independence and was 3rd President", "Led the Confederacy in the Civil War", "Invented the cotton gin"],
                  explanation: "Jefferson wrote the Declaration of Independence, was the 3rd President, doubled the U.S. with the Louisiana Purchase, and founded the University of Virginia."),
            .init(text: "थोमस जेफरसन धेरै कुराका लागि प्रसिद्ध छन्। एउटाको नाम लिनुहोस्।",
                  options: ["बिजुली पत्ता लगाए", "स्वतन्त्रताको घोषणापत्र लेखे र तेस्रो राष्ट्रपति थिए", "गृहयुद्धमा कन्फेडेरेसीको नेतृत्व गरे", "कपास जीन आविष्कार गरे"],
                  explanation: "जेफरसनले स्वतन्त्रताको घोषणापत्र लेखे, तेस्रो राष्ट्रपति थिए, लुइसियाना खरिदद्वारा अमेरिकाको आकार दोब्बर बनाए, र भर्जिनिया विश्वविद्यालय स्थापना गरे।")
        ]),
        UnifiedQuestion(id: "q_25_088", correctAnswer: 0, variants: [
            .init(text: "James Madison is famous for many things. Name one.",
                  options: ["Father of the Constitution and 4th President", "Led the Underground Railroad", "Discovered America", "Founded Boston"],
                  explanation: "Madison is called the \"Father of the Constitution.\" He was the 4th President, served during the War of 1812, and was a writer of the Federalist Papers."),
            .init(text: "जेम्स म्याडिसन धेरै कुराका लागि प्रसिद्ध छन्। एउटाको नाम लिनुहोस्।",
                  options: ["संविधानका पिता र चौथो राष्ट्रपति", "अन्डरग्राउन्ड रेलवेको नेतृत्व गरे", "अमेरिका पत्ता लगाए", "बोस्टन स्थापना गरे"],
                  explanation: "म्याडिसनलाई «संविधानका पिता» भनिन्छ। उनी चौथो राष्ट्रपति थिए, १८१२ को युद्धको समयमा सेवा गरे, र फेडेरलिस्ट पेपर्सका लेखक थिए।")
        ])
    ]

    // MARK: - Practice 7: 1800s & National Identity (16 questions)
    static let practice7: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_089", correctAnswer: 1, variants: [
            .init(text: "Alexander Hamilton is famous for many things. Name one.",
                  options: ["First President of the U.S.", "First Secretary of the Treasury and Federalist Papers writer", "Discovered penicillin", "Wrote the Star-Spangled Banner"],
                  explanation: "Hamilton was the first Secretary of the Treasury, a writer of the Federalist Papers, helped establish the First Bank of the United States, and was an aide to General Washington."),
            .init(text: "अलेक्जान्डर ह्यामिल्टन धेरै कुराका लागि प्रसिद्ध छन्। एउटाको नाम लिनुहोस्।",
                  options: ["अमेरिकाका पहिलो राष्ट्रपति", "पहिलो अर्थ मन्त्री र फेडेरलिस्ट पेपर्सका लेखक", "पेनिसिलिन पत्ता लगाए", "स्टार-स्पैङ्ग्ल्ड ब्यानर लेखे"],
                  explanation: "ह्यामिल्टन पहिलो अर्थ मन्त्री, फेडेरलिस्ट पेपर्सका लेखक, अमेरिकाको पहिलो बैंक स्थापना गर्न सहयोग गर्ने, र जनरल वाशिंगटनका सहायक थिए।")
        ]),
        UnifiedQuestion(id: "q_25_090", correctAnswer: 1, variants: [
            .init(text: "What territory did the United States buy from France in 1803?",
                  options: ["Florida", "Louisiana Territory", "Alaska", "Texas"],
                  explanation: "President Jefferson bought the Louisiana Territory from France in 1803 for $15 million, doubling the size of the United States."),
            .init(text: "अमेरिकाले १८०३ मा फ्रान्सबाट कुन क्षेत्र किनेको थियो?",
                  options: ["फ्लोरिडा", "लुइसियाना क्षेत्र", "अलास्का", "टेक्सास"],
                  explanation: "राष्ट्रपति जेफरसनले १८०३ मा फ्रान्सबाट लुइसियाना क्षेत्र १.५ करोड डलरमा किने, जसले अमेरिकाको आकार दोब्बर बनायो।")
        ]),
        UnifiedQuestion(id: "q_25_091", correctAnswer: 1, variants: [
            .init(text: "Name one war fought by the United States in the 1800s.",
                  options: ["World War I", "Civil War (or War of 1812, Mexican-American War, Spanish-American War)", "Vietnam War", "Korean War"],
                  explanation: "Wars fought by the U.S. in the 1800s include the War of 1812, the Mexican-American War, the Civil War, and the Spanish-American War."),
            .init(text: "१८०० का दशकमा अमेरिकाले लडेको एक युद्धको नाम लिनुहोस्।",
                  options: ["पहिलो विश्वयुद्ध", "गृहयुद्ध (वा १८१२ को युद्ध, मेक्सिकन-अमेरिकी युद्ध, स्पेनिश-अमेरिकी युद्ध)", "भियतनाम युद्ध", "कोरियाली युद्ध"],
                  explanation: "१८०० का दशकमा अमेरिकाले लडेका युद्धहरूमा १८१२ को युद्ध, मेक्सिकन-अमेरिकी युद्ध, गृहयुद्ध र स्पेनिश-अमेरिकी युद्ध समावेश छन्।")
        ]),
        UnifiedQuestion(id: "q_25_092", correctAnswer: 2, variants: [
            .init(text: "Name the U.S. war between the North and the South.",
                  options: ["The Revolutionary War", "The War of 1812", "The Civil War", "The Mexican-American War"],
                  explanation: "The Civil War (1861-1865) was fought between the Northern Union states and the Southern Confederate states, primarily over slavery."),
            .init(text: "उत्तर र दक्षिणबीचको अमेरिकी युद्धको नाम भन्नुहोस्।",
                  options: ["क्रान्तिकारी युद्ध", "१८१२ को युद्ध", "गृहयुद्ध", "मेक्सिकन-अमेरिकी युद्ध"],
                  explanation: "गृहयुद्ध (१८६१-१८६५) उत्तरी संघीय राज्यहरू र दक्षिणी कन्फेडेरेट राज्यहरूबीच मुख्यतया दासत्वको विषयमा लडिएको थियो।")
        ]),
        UnifiedQuestion(id: "q_25_093", correctAnswer: 1, variants: [
            .init(text: "The Civil War had many important events. Name one.",
                  options: ["The bombing of Pearl Harbor", "The Battle of Gettysburg (or Emancipation Proclamation, Surrender at Appomattox)", "Construction of the Panama Canal", "The first moon landing"],
                  explanation: "Important Civil War events include the Battle of Fort Sumter, Emancipation Proclamation, Battle of Gettysburg, Sherman's March, and the Surrender at Appomattox."),
            .init(text: "गृहयुद्धमा धेरै महत्वपूर्ण घटनाहरू थिए। एउटाको नाम लिनुहोस्।",
                  options: ["पर्ल हार्बरको बम विस्फोट", "गेटिसबर्गको लडाई (वा मुक्तिको घोषणा, अप्पोम्याटक्समा आत्मसमर्पण)", "पनामा नहरको निर्माण", "पहिलो चन्द्रमामा अवतरण"],
                  explanation: "गृहयुद्धका महत्वपूर्ण घटनाहरूमा फोर्ट सम्टरको लडाई, मुक्तिको घोषणा, गेटिसबर्गको लडाई, शेर्म्यानको मार्च र अप्पोम्याटक्समा आत्मसमर्पण समावेश छन्।")
        ]),
        UnifiedQuestion(id: "q_25_094", correctAnswer: 1, variants: [
            .init(text: "Abraham Lincoln is famous for many things. Name one.",
                  options: ["Wrote the Constitution", "Freed the slaves and preserved the Union", "Discovered electricity", "Founded the Republican Party"],
                  explanation: "Lincoln freed the slaves with the Emancipation Proclamation, preserved the Union during the Civil War, and was the 16th President."),
            .init(text: "अब्राहम लिङ्कन धेरै कुराका लागि प्रसिद्ध छन्। एउटाको नाम लिनुहोस्।",
                  options: ["संविधान लेखे", "दासहरूलाई मुक्त गरे र संघलाई जोगाए", "बिजुली पत्ता लगाए", "रिपब्लिकन पार्टी स्थापना गरे"],
                  explanation: "लिङ्कनले मुक्तिको घोषणासँगै दासहरूलाई मुक्त गरे, गृहयुद्धमा संघलाई जोगाए, र १६औं राष्ट्रपति थिए।")
        ]),
        UnifiedQuestion(id: "q_25_095", correctAnswer: 1, variants: [
            .init(text: "What did the Emancipation Proclamation do?",
                  options: ["Started the Civil War", "Freed the slaves in the Confederate states", "Granted women the right to vote", "Ended World War II"],
                  explanation: "President Lincoln's Emancipation Proclamation (1863) declared slaves in the Confederate states to be free."),
            .init(text: "मुक्तिको घोषणाले के गर्‍यो?",
                  options: ["गृहयुद्ध सुरु गर्‍यो", "कन्फेडेरेट राज्यहरूका दासहरूलाई मुक्त गर्‍यो", "महिलाहरूलाई मतदान अधिकार दियो", "दोस्रो विश्वयुद्ध अन्त्य गर्‍यो"],
                  explanation: "राष्ट्रपति लिङ्कनको मुक्तिको घोषणा (१८६३) ले कन्फेडेरेट राज्यहरूका दासहरूलाई मुक्त घोषणा गरेको थियो।")
        ]),
        UnifiedQuestion(id: "q_25_096", correctAnswer: 2, variants: [
            .init(text: "What U.S. war ended slavery?",
                  options: ["The Revolutionary War", "The War of 1812", "The Civil War", "World War I"],
                  explanation: "The Civil War ended slavery. The 13th Amendment, ratified in 1865 after the war, formally abolished slavery throughout the United States."),
            .init(text: "अमेरिकाको कुन युद्धले दासत्वलाई अन्त्य गर्‍यो?",
                  options: ["क्रान्तिकारी युद्ध", "१८१२ को युद्ध", "गृहयुद्ध", "पहिलो विश्वयुद्ध"],
                  explanation: "गृहयुद्धले दासत्वलाई अन्त्य गर्‍यो। युद्धपछि १८६५ मा अनुमोदन भएको १३औं संशोधनले अमेरिकाभर औपचारिक रूपमा दासत्व उन्मूलन गर्‍यो।")
        ]),
        UnifiedQuestion(id: "q_25_098", correctAnswer: 1, variants: [
            .init(text: "When did all men get the right to vote?",
                  options: ["At the start of the country (1776)", "After the Civil War (15th Amendment, 1870)", "After World War I (1920)", "Only in 1965"],
                  explanation: "The 15th Amendment (1870), ratified after the Civil War, prohibited denying the vote based on race — extending voting rights to men of all races."),
            .init(text: "सबै पुरुषहरूले मतदान गर्ने अधिकार कहिले पाए?",
                  options: ["देशको सुरुमा (१७७६)", "गृहयुद्धपछि (१५औं संशोधन, १८७०)", "पहिलो विश्वयुद्धपछि (१९२०)", "केवल १९६५ मा"],
                  explanation: "गृहयुद्धपछि अनुमोदन भएको १५औं संशोधन (१८७०) ले जातिको आधारमा मतदान अधिकारको अस्वीकृति निषेध गर्‍यो — सबै जातिका पुरुषहरूलाई मतदान अधिकार दिलायो।")
        ]),
        UnifiedQuestion(id: "q_25_099", correctAnswer: 1, variants: [
            .init(text: "Name one leader of the women's rights movement in the 1800s.",
                  options: ["Eleanor Roosevelt", "Susan B. Anthony", "Hillary Clinton", "Sandra Day O'Connor"],
                  explanation: "Leaders of the 1800s women's rights movement included Susan B. Anthony, Elizabeth Cady Stanton, Sojourner Truth, Harriet Tubman, and Lucretia Mott."),
            .init(text: "१८०० का दशकको महिला अधिकार आन्दोलनकी एक नेताको नाम लिनुहोस्।",
                  options: ["एलिनोर रुजवेल्ट", "सुजान बी. एन्थोनी", "हिलारी क्लिन्टन", "स्यान्ड्रा डे ओ'कोनर"],
                  explanation: "१८०० का दशकको महिला अधिकार आन्दोलनकी नेताहरूमा सुजान बी. एन्थोनी, एलिजाबेथ क्याडी स्टेन्टन, सोजोर्नर ट्रुथ, ह्यारिएट टब्म्यान र लुक्रेसिया मट समावेश थिए।")
        ]),
        UnifiedQuestion(id: "q_25_117", correctAnswer: 1, variants: [
            .init(text: "Name one American Indian tribe in the United States.",
                  options: ["The Egyptians", "Cherokee (or Navajo, Sioux, Apache, Hopi)", "The Vikings", "The Mongols"],
                  explanation: "Recognized American Indian tribes include the Cherokee, Navajo, Sioux, Apache, Hopi, Blackfeet, Choctaw, Pueblo, and many others."),
            .init(text: "अमेरिकामा रहेको एक अमेरिकी आदिवासी जातिको नाम लिनुहोस्।",
                  options: ["इजिप्शियनहरू", "चेरोकी (वा नाभाहो, सियु, आपाची, होपी)", "भाइकिङहरू", "मङ्गोलहरू"],
                  explanation: "मान्यता प्राप्त अमेरिकी आदिवासी जातिहरूमा चेरोकी, नाभाहो, सियु, आपाची, होपी, ब्ल्याकफिट, चोक्टा, पुएब्लो र अरू धेरै समावेश छन्।")
        ]),
        UnifiedQuestion(id: "q_25_118", correctAnswer: 1, variants: [
            .init(text: "Name one example of an American innovation.",
                  options: ["The wheel", "The airplane (or light bulb, automobile, skyscraper)", "Paper", "Pottery"],
                  explanation: "American innovations include the light bulb (Edison), the airplane (Wright Brothers), the automobile assembly line (Ford), skyscrapers, and the integrated circuit."),
            .init(text: "अमेरिकी आविष्कारको एक उदाहरणको नाम लिनुहोस्।",
                  options: ["चक्का", "हवाइजहाज (वा बिजुलीको बत्ती, मोटरगाडी, अग्लो भवन)", "कागज", "माटोको भाँडा"],
                  explanation: "अमेरिकी आविष्कारहरूमा बिजुलीको बत्ती (एडिसन), हवाइजहाज (राइट दाजुभाइ), मोटरगाडी असेम्बली लाइन (फोर्ड), अग्ला भवनहरू र एकीकृत सर्किट समावेश छन्।")
        ]),
        UnifiedQuestion(id: "q_25_120", correctAnswer: 1, variants: [
            .init(text: "Where is the Statue of Liberty?",
                  options: ["Boston Harbor", "New York Harbor (Liberty Island)", "Chesapeake Bay", "Los Angeles"],
                  explanation: "The Statue of Liberty stands on Liberty Island in New York Harbor. It was a gift from France in 1886 and a symbol of freedom for immigrants arriving by sea."),
            .init(text: "स्वतन्त्रताको मूर्ति कहाँ छ?",
                  options: ["बोस्टन बन्दरगाह", "न्यूयोर्क बन्दरगाह (लिबर्टी टापु)", "चेसापीक खाडी", "लस एन्जलस"],
                  explanation: "स्वतन्त्रताको मूर्ति न्यूयोर्क बन्दरगाहको लिबर्टी टापुमा छ। यो १८८६ मा फ्रान्सको उपहार थियो र समुद्रबाट आउने आप्रवासीहरूका लागि स्वतन्त्रताको प्रतीक थियो।")
        ]),
        UnifiedQuestion(id: "q_25_126", correctAnswer: 1, variants: [
            .init(text: "Name three national U.S. holidays.",
                  options: ["Halloween, Valentine's Day, Earth Day", "Independence Day, Thanksgiving, and Christmas", "Mother's Day, Father's Day, Easter", "Black Friday, Cyber Monday, Tax Day"],
                  explanation: "U.S. national holidays include New Year's Day, MLK Jr. Day, Presidents Day, Memorial Day, Juneteenth, Independence Day, Labor Day, Columbus Day, Veterans Day, Thanksgiving, and Christmas."),
            .init(text: "तीन अमेरिकी राष्ट्रिय बिदाहरूको नाम लिनुहोस्।",
                  options: ["ह्यालोवीन, भ्यालेन्टाइन्स डे, अर्थ डे", "स्वतन्त्रता दिवस, धन्यबाद दिवस र क्रिसमस", "मातृ दिवस, पितृ दिवस, इस्टर", "ब्ल्याक फ्राइडे, साइबर मन्डे, ट्याक्स डे"],
                  explanation: "अमेरिकी राष्ट्रिय बिदाहरूमा नयाँ वर्ष दिवस, मार्टिन लुथर किङ जुनियर दिवस, राष्ट्रपति दिवस, स्मृति दिवस, जुनटिन्थ, स्वतन्त्रता दिवस, श्रम दिवस, कोलम्बस दिवस, भूतपूर्व सैनिक दिवस, धन्यबाद दिवस र क्रिसमस समावेश छन्।")
        ]),
        UnifiedQuestion(id: "q_25_127", correctAnswer: 2, variants: [
            .init(text: "What is Memorial Day?",
                  options: ["A holiday to honor veterans still living", "A holiday to celebrate independence", "A holiday to honor soldiers who died in military service", "A holiday for state founders"],
                  explanation: "Memorial Day (last Monday in May) honors U.S. military service members who died in service to their country."),
            .init(text: "स्मृति दिवस के हो?",
                  options: ["जीवित भूतपूर्व सैनिकहरूलाई सम्मान गर्ने बिदा", "स्वतन्त्रता मनाउने बिदा", "सैन्य सेवामा मरेका सिपाहीहरूलाई सम्मान गर्ने बिदा", "राज्य संस्थापकहरूका लागि बिदा"],
                  explanation: "स्मृति दिवस (मेको अन्तिम सोमबार) ले देशको सेवामा मरेका अमेरिकी सैन्य सदस्यहरूलाई सम्मान गर्छ।")
        ]),
        UnifiedQuestion(id: "q_25_128", correctAnswer: 1, variants: [
            .init(text: "What is Veterans Day?",
                  options: ["A holiday for active military only", "A holiday to honor people who have served in the U.S. military", "A holiday for fallen soldiers only", "A holiday for new immigrants"],
                  explanation: "Veterans Day (November 11) honors all people who have served in the U.S. military, both living and deceased."),
            .init(text: "भूतपूर्व सैनिक दिवस के हो?",
                  options: ["केवल सक्रिय सैनिकहरूका लागि बिदा", "अमेरिकी सेनामा सेवा गरेका मानिसहरूलाई सम्मान गर्ने बिदा", "केवल मरेका सिपाहीहरूका लागि बिदा", "नयाँ आप्रवासीहरूका लागि बिदा"],
                  explanation: "भूतपूर्व सैनिक दिवस (नोभेम्बर ११) ले अमेरिकी सेनामा सेवा गरेका जीवित र मृत सबै मानिसहरूलाई सम्मान गर्छ।")
        ])
    ]

    // MARK: - Practice 8: 1900s & Modern History (16 questions)
    static let practice8: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_100", correctAnswer: 1, variants: [
            .init(text: "Name one war fought by the United States in the 1900s.",
                  options: ["The Civil War", "World War II (or WWI, Korean War, Vietnam War, Persian Gulf War)", "American Revolution", "War of 1812"],
                  explanation: "U.S. wars in the 1900s include World War I, World War II, the Korean War, the Vietnam War, and the Persian Gulf War."),
            .init(text: "१९०० का दशकमा अमेरिकाले लडेको एक युद्धको नाम लिनुहोस्।",
                  options: ["गृहयुद्ध", "दोस्रो विश्वयुद्ध (वा पहिलो विश्वयुद्ध, कोरियाली युद्ध, भियतनाम युद्ध, फारसी खाडी युद्ध)", "अमेरिकी क्रान्ति", "१८१२ को युद्ध"],
                  explanation: "१९०० का दशकमा अमेरिकाले लडेका युद्धहरूमा पहिलो विश्वयुद्ध, दोस्रो विश्वयुद्ध, कोरियाली युद्ध, भियतनाम युद्ध र फारसी खाडी युद्ध समावेश छन्।")
        ]),
        UnifiedQuestion(id: "q_25_101", correctAnswer: 1, variants: [
            .init(text: "Why did the United States enter World War I?",
                  options: ["To help Germany", "Because Germany attacked U.S. civilian ships (and to support the Allies)", "To gain new territory", "To stop the spread of communism"],
                  explanation: "The U.S. entered WWI in 1917 because Germany attacked U.S. civilian ships and to support the Allied Powers (England, France, Italy, and Russia)."),
            .init(text: "अमेरिका पहिलो विश्वयुद्धमा किन सामेल भयो?",
                  options: ["जर्मनीलाई सहयोग गर्न", "जर्मनीले अमेरिकी नागरिक जहाजहरूमा आक्रमण गरेकाले (र मित्र शक्तिहरूलाई समर्थन गर्न)", "नयाँ क्षेत्र प्राप्त गर्न", "साम्यवादको फैलावट रोक्न"],
                  explanation: "जर्मनीले अमेरिकी नागरिक जहाजहरूमा आक्रमण गरेकाले र मित्र शक्तिहरू (बेलायत, फ्रान्स, इटाली र रूस) लाई समर्थन गर्न अमेरिका १९१७ मा पहिलो विश्वयुद्धमा सामेल भयो।")
        ]),
        UnifiedQuestion(id: "q_25_103", correctAnswer: 1, variants: [
            .init(text: "What was the Great Depression?",
                  options: ["A war fought in the 1930s", "The longest economic recession in modern history", "A famous government program", "A presidential election"],
                  explanation: "The Great Depression was the longest and deepest economic recession in modern history, with mass unemployment and bank failures throughout the 1930s."),
            .init(text: "महामन्दी के थियो?",
                  options: ["१९३० का दशकमा लडिएको एक युद्ध", "आधुनिक इतिहासको सबैभन्दा लामो आर्थिक मन्दी", "एक प्रसिद्ध सरकारी कार्यक्रम", "एक राष्ट्रपति निर्वाचन"],
                  explanation: "महामन्दी आधुनिक इतिहासको सबैभन्दा लामो र गहिरो आर्थिक मन्दी थियो, १९३० का दशकमा व्यापक बेरोजगारी र बैंक विफलताहरूका साथ।")
        ]),
        UnifiedQuestion(id: "q_25_104", correctAnswer: 1, variants: [
            .init(text: "When did the Great Depression start?",
                  options: ["With World War I (1917)", "With the Great Crash of 1929 (stock market crash)", "After World War II (1945)", "1933"],
                  explanation: "The Great Depression began with the stock market crash of October 1929 (the Great Crash), and lasted until the early 1940s."),
            .init(text: "महामन्दी कहिले सुरु भयो?",
                  options: ["पहिलो विश्वयुद्धसँगै (१९१७)", "१९२९ को महापतनका साथ (शेयर बजार पतन)", "दोस्रो विश्वयुद्धपछि (१९४५)", "१९३३"],
                  explanation: "महामन्दी अक्टोबर १९२९ को शेयर बजार पतन (महापतन) सँग सुरु भयो र १९४० का दशकको सुरुसम्म चल्यो।")
        ]),
        UnifiedQuestion(id: "q_25_105", correctAnswer: 1, variants: [
            .init(text: "Who was president during the Great Depression and World War II?",
                  options: ["Theodore Roosevelt", "Franklin D. Roosevelt (FDR)", "Harry Truman", "Herbert Hoover"],
                  explanation: "Franklin D. Roosevelt (FDR) served as President from 1933 until his death in 1945. He led the New Deal response to the Depression and led the U.S. through most of WWII."),
            .init(text: "महामन्दी र दोस्रो विश्वयुद्धको समयमा राष्ट्रपति को थिए?",
                  options: ["थियोडोर रुजवेल्ट", "फ्र्याङ्क्लिन डी. रुजवेल्ट (एफडिआर)", "ह्यारी ट्रुम्यान", "हर्बर्ट हुभर"],
                  explanation: "फ्र्याङ्क्लिन डी. रुजवेल्ट (एफडिआर) १९३३ देखि १९४५ मा आफ्नो मृत्यु नभएसम्म राष्ट्रपति रहे। उनले मन्दीप्रति न्यू डिल प्रतिक्रिया नेतृत्व गरे र दोस्रो विश्वयुद्धको अधिकांश समय अमेरिकाको नेतृत्व गरे।")
        ]),
        UnifiedQuestion(id: "q_25_106", correctAnswer: 1, variants: [
            .init(text: "Why did the United States enter World War II?",
                  options: ["To help Germany", "Because Japan bombed Pearl Harbor", "To gain new colonies", "To establish trade routes"],
                  explanation: "The U.S. entered WWII after Japan attacked Pearl Harbor on December 7, 1941. The U.S. then joined the Allied Powers against the Axis Powers."),
            .init(text: "अमेरिका दोस्रो विश्वयुद्धमा किन सामेल भयो?",
                  options: ["जर्मनीलाई सहयोग गर्न", "जापानले पर्ल हार्बरमा बम विस्फोट गरेकाले", "नयाँ उपनिवेशहरू प्राप्त गर्न", "व्यापार मार्गहरू स्थापना गर्न"],
                  explanation: "जापानले डिसेम्बर ७, १९४१ मा पर्ल हार्बरमा आक्रमण गरेपछि अमेरिका दोस्रो विश्वयुद्धमा सामेल भयो। त्यसपछि अमेरिकाले अक्षशक्तिविरुद्ध मित्र शक्तिहरूमा भाग लियो।")
        ]),
        UnifiedQuestion(id: "q_25_107", correctAnswer: 1, variants: [
            .init(text: "Dwight Eisenhower is famous for many things. Name one.",
                  options: ["Founded Microsoft", "General during World War II and 34th President", "Wrote the Constitution", "Discovered penicillin"],
                  explanation: "Eisenhower was a top general in WWII (commanded D-Day), the 34th President (1953-61), president when the Korean War ended, and signed the law creating the Interstate Highway System."),
            .init(text: "ड्वाइट आइजनहावर धेरै कुराका लागि प्रसिद्ध छन्। एउटाको नाम लिनुहोस्।",
                  options: ["माइक्रोसफ्ट स्थापना गरे", "दोस्रो विश्वयुद्धका जनरल र ३४औं राष्ट्रपति", "संविधान लेखे", "पेनिसिलिन पत्ता लगाए"],
                  explanation: "आइजनहावर दोस्रो विश्वयुद्धका शीर्ष जनरल थिए (डि-डेको कमान्ड गरे), ३४औं राष्ट्रपति (१९५३-६१), कोरियाली युद्ध अन्त्य भएको समयका राष्ट्रपति, र अन्तरराज्य राजमार्ग प्रणाली सिर्जना गर्ने कानूनमा हस्ताक्षर गरे।")
        ]),
        UnifiedQuestion(id: "q_25_108", correctAnswer: 2, variants: [
            .init(text: "Who was the United States' main rival during the Cold War?",
                  options: ["Germany", "China", "The Soviet Union (USSR)", "Japan"],
                  explanation: "The Soviet Union (USSR) was the main U.S. rival during the Cold War (1947-1991), a period of geopolitical tension without direct military conflict."),
            .init(text: "शीतयुद्धको समयमा अमेरिकाको मुख्य प्रतिद्वन्द्वी को थियो?",
                  options: ["जर्मनी", "चीन", "सोभियत संघ (युएसएसआर)", "जापान"],
                  explanation: "शीतयुद्ध (१९४७-१९९१) को समयमा सोभियत संघ (युएसएसआर) अमेरिकाको मुख्य प्रतिद्वन्द्वी थियो, जुन प्रत्यक्ष सैन्य द्वन्द्व नभएको भू-राजनीतिक तनावको अवधि थियो।")
        ]),
        UnifiedQuestion(id: "q_25_109", correctAnswer: 1, variants: [
            .init(text: "During the Cold War, what was one main concern of the United States?",
                  options: ["Trade deficits", "Communism (and nuclear war)", "Immigration", "Energy independence"],
                  explanation: "Main U.S. concerns during the Cold War were the spread of communism and the threat of nuclear war between the superpowers."),
            .init(text: "शीतयुद्धको समयमा अमेरिकाको मुख्य चिन्ता के थियो?",
                  options: ["व्यापार घाटा", "साम्यवाद (र आणविक युद्ध)", "आप्रवासन", "ऊर्जा स्वतन्त्रता"],
                  explanation: "शीतयुद्धको समयमा अमेरिकाका मुख्य चिन्ताहरू साम्यवादको फैलावट र महाशक्तिहरूबीचको आणविक युद्धको खतरा थिए।")
        ]),
        UnifiedQuestion(id: "q_25_110", correctAnswer: 1, variants: [
            .init(text: "Why did the United States enter the Korean War?",
                  options: ["To gain Korean territory", "To stop the spread of communism", "To support the Korean monarchy", "To rescue American hostages"],
                  explanation: "The U.S. entered the Korean War (1950-53) to stop the spread of communism after North Korea (communist) invaded South Korea."),
            .init(text: "अमेरिका कोरियाली युद्धमा किन सामेल भयो?",
                  options: ["कोरियाली क्षेत्र प्राप्त गर्न", "साम्यवादको फैलावट रोक्न", "कोरियाली राजतन्त्रलाई समर्थन गर्न", "अमेरिकी बन्धकहरूलाई बचाउन"],
                  explanation: "उत्तर कोरिया (साम्यवादी) ले दक्षिण कोरियामा आक्रमण गरेपछि अमेरिका साम्यवादको फैलावट रोक्न कोरियाली युद्ध (१९५०-५३) मा सामेल भयो।")
        ]),
        UnifiedQuestion(id: "q_25_111", correctAnswer: 1, variants: [
            .init(text: "Why did the United States enter the Vietnam War?",
                  options: ["To gain Vietnamese territory", "To stop the spread of communism", "To establish a U.S. naval base", "To enforce a trade agreement"],
                  explanation: "The U.S. entered the Vietnam War (1955-75) to stop the spread of communism in Southeast Asia."),
            .init(text: "अमेरिका भियतनाम युद्धमा किन सामेल भयो?",
                  options: ["भियतनामी क्षेत्र प्राप्त गर्न", "साम्यवादको फैलावट रोक्न", "अमेरिकी नौसेना अड्डा स्थापना गर्न", "व्यापार सम्झौता लागू गर्न"],
                  explanation: "अमेरिका दक्षिण-पूर्व एसियामा साम्यवादको फैलावट रोक्न भियतनाम युद्ध (१९५५-७५) मा सामेल भयो।")
        ]),
        UnifiedQuestion(id: "q_25_112", correctAnswer: 1, variants: [
            .init(text: "What did the civil rights movement do?",
                  options: ["Won the right to vote for women", "Fought to end racial discrimination", "Brought independence from Britain", "Established Social Security"],
                  explanation: "The civil rights movement (1950s-1960s) fought to end racial discrimination and segregation. It led to the Civil Rights Act of 1964 and Voting Rights Act of 1965."),
            .init(text: "नागरिक अधिकार आन्दोलनले के गर्‍यो?",
                  options: ["महिलाहरूका लागि मतदान अधिकार जित्यो", "जातीय विभेद अन्त्य गर्न लड्यो", "बेलायतबाट स्वतन्त्रता ल्यायो", "सामाजिक सुरक्षा स्थापना गर्‍यो"],
                  explanation: "नागरिक अधिकार आन्दोलन (१९५० र १९६० का दशक) जातीय विभेद र विभाजन अन्त्य गर्न लड्यो। यसले १९६४ को नागरिक अधिकार ऐन र १९६५ को मतदान अधिकार ऐन ल्यायो।")
        ]),
        UnifiedQuestion(id: "q_25_113", correctAnswer: 1, variants: [
            .init(text: "Martin Luther King, Jr. is famous for many things. Name one.",
                  options: ["Invented the airplane", "Fought for civil rights and equality for all Americans", "First African American President", "Wrote the Declaration of Independence"],
                  explanation: "Dr. King fought for civil rights using nonviolent methods, worked for equality, and delivered the famous \"I Have a Dream\" speech. He was awarded the Nobel Peace Prize in 1964."),
            .init(text: "मार्टिन लुथर किङ, जुनियर धेरै कुराका लागि प्रसिद्ध छन्। एउटाको नाम लिनुहोस्।",
                  options: ["हवाइजहाज आविष्कार गरे", "नागरिक अधिकार र सबै अमेरिकीहरूको समानताका लागि लडे", "पहिलो अफ्रिकी-अमेरिकी राष्ट्रपति", "स्वतन्त्रताको घोषणापत्र लेखे"],
                  explanation: "डा. किङले अहिंसात्मक तरिकाले नागरिक अधिकारका लागि लडे, समानताका लागि काम गरे, र प्रसिद्ध «आई ह्याभ अ ड्रिम» भाषण दिए। उनी १९६४ मा नोबेल शान्ति पुरस्कारबाट सम्मानित भएका थिए।")
        ]),
        UnifiedQuestion(id: "q_25_114", correctAnswer: 1, variants: [
            .init(text: "Why did the United States enter the Persian Gulf War?",
                  options: ["To support Iraq", "To force the Iraqi military from Kuwait", "To establish a U.S. embassy", "To rescue American tourists"],
                  explanation: "The U.S. led an international coalition in the Persian Gulf War (1990-91) to force the Iraqi military out of Kuwait, which Iraq had invaded."),
            .init(text: "अमेरिका फारसी खाडी युद्धमा किन सामेल भयो?",
                  options: ["इराकलाई समर्थन गर्न", "इराकी सेनालाई कुवेतबाट बाहिर निकाल्न", "अमेरिकी राजदूतावास स्थापना गर्न", "अमेरिकी पर्यटकहरूलाई बचाउन"],
                  explanation: "इराकले कुवेतमा आक्रमण गरेपछि अमेरिकाले फारसी खाडी युद्ध (१९९०-९१) मा इराकी सेनालाई कुवेतबाट बाहिर निकाल्न अन्तरराष्ट्रिय गठबन्धनको नेतृत्व गर्‍यो।")
        ]),
        UnifiedQuestion(id: "q_25_115", correctAnswer: 1, variants: [
            .init(text: "What major event happened on September 11, 2001 in the United States?",
                  options: ["A presidential election", "Terrorists attacked the United States", "A natural disaster", "A peace agreement was signed"],
                  explanation: "On 9/11, terrorists hijacked four planes, crashing two into the World Trade Center, one into the Pentagon, and one in a Pennsylvania field. Nearly 3,000 people died."),
            .init(text: "सेप्टेम्बर ११, २००१ मा अमेरिकामा कुन ठूलो घटना भयो?",
                  options: ["राष्ट्रपतिको निर्वाचन", "आतंकवादीहरूले अमेरिकामा आक्रमण गरे", "प्राकृतिक प्रकोप", "शान्ति सम्झौतामा हस्ताक्षर भयो"],
                  explanation: "९/११ मा आतंकवादीहरूले चार वटा हवाइजहाजहरू अपहरण गरेर दुई वटा विश्व व्यापार केन्द्रमा, एउटा पेन्टागनमा र अर्को पेन्सिल्भेनियाको खेतमा खसाले। लगभग ३,००० मानिसहरूको मृत्यु भयो।")
        ]),
        UnifiedQuestion(id: "q_25_116", correctAnswer: 2, variants: [
            .init(text: "Name one U.S. military conflict after the September 11, 2001 attacks.",
                  options: ["The Korean War", "The Vietnam War", "The War in Afghanistan (or War in Iraq, War on Terror)", "The Civil War"],
                  explanation: "U.S. conflicts after 9/11 include the Global War on Terror, the War in Afghanistan (2001-2021), and the War in Iraq (2003-2011)."),
            .init(text: "सेप्टेम्बर ११, २००१ का आक्रमणपछिको एक अमेरिकी सैन्य द्वन्द्वको नाम लिनुहोस्।",
                  options: ["कोरियाली युद्ध", "भियतनाम युद्ध", "अफगानिस्तानको युद्ध (वा इराकको युद्ध, आतंकविरुद्धको युद्ध)", "गृहयुद्ध"],
                  explanation: "९/११ पछिका अमेरिकी द्वन्द्वहरूमा वैश्विक आतंकविरुद्धको युद्ध, अफगानिस्तानको युद्ध (२००१-२०२१) र इराकको युद्ध (२००३-२०११) समावेश छन्।")
        ])
    ]
}
