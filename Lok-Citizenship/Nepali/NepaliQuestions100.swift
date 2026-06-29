/// Nepali (English ↔ नेपाली) quiz question sets — the 100 official 2008 USCIS
/// naturalization civics questions in 10 interview-style sets of 10 questions each.
/// IDs match EnglishQuestions100. 2 variants per question: [English, Nepali].
enum NepaliQuestions100 {

    // MARK: - Practice Set 1: Principles of Democracy (Q1–Q10)
    static let practice1: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_001", correctAnswer: 2, variants: [
            .init(text: "What is the supreme law of the land?",
                  options: ["The Declaration of Independence", "The Bill of Rights", "The Constitution", "The Federalist Papers"],
                  explanation: "The Constitution is the supreme law of the United States. All other laws must be consistent with it."),
            .init(text: "देशको सर्वोच्च कानुन के हो?",
                  options: ["स्वतन्त्रताको घोषणापत्र", "अधिकारको विधेयक", "संविधान", "फेडेरलिस्ट पेपर्स"],
                  explanation: "संविधान संयुक्त राज्यको सर्वोच्च कानुन हो। अन्य सबै कानुन यससँग अनुकूल हुनुपर्छ।")
        ]),
        UnifiedQuestion(id: "q_08_002", correctAnswer: 1, variants: [
            .init(text: "What does the Constitution do?",
                  options: ["Establishes the U.S. military", "Sets up the government and protects basic rights of Americans", "Lists every federal law", "Declares independence from Britain"],
                  explanation: "The Constitution defines the structure of the U.S. government and protects the basic rights of all Americans."),
            .init(text: "संविधानले के गर्छ?",
                  options: ["अमेरिकी सेना स्थापना गर्छ", "सरकार स्थापना गर्छ र अमेरिकीहरूका मूलभूत अधिकार सुरक्षित गर्छ", "सबै संघीय कानुनहरू सूचीबद्ध गर्छ", "बेलायतबाट स्वतन्त्रता घोषणा गर्छ"],
                  explanation: "संविधानले अमेरिकी सरकारको संरचना परिभाषित गर्छ र सबै अमेरिकीहरूका मूलभूत अधिकार सुरक्षित गर्छ।")
        ]),
        UnifiedQuestion(id: "q_08_003", correctAnswer: 1, variants: [
            .init(text: "The idea of self-government is in the first three words of the Constitution. What are these words?",
                  options: ["Life and Liberty", "We the People", "Equal Justice Under Law", "In God We Trust"],
                  explanation: "'We the People' opens the Preamble, establishing that all government authority comes from the citizens."),
            .init(text: "स्व-शासनको विचार संविधानका पहिला तीन शब्दमा छ। ती शब्दहरू के हुन्?",
                  options: ["जीवन र स्वतन्त्रता", "हामी जनता", "सबैका लागि समान न्याय", "हामी ईश्वरमा विश्वास गर्छौं"],
                  explanation: "'हामी जनता' ले प्रस्तावनाको सुरुआत गर्छ, जसले स्थापित गर्छ कि सरकारको सबै अधिकार नागरिकहरूबाट आउँछ।")
        ]),
        UnifiedQuestion(id: "q_08_004", correctAnswer: 2, variants: [
            .init(text: "What is an amendment?",
                  options: ["A federal court ruling", "A presidential executive order", "A change or addition to the Constitution", "A temporary law passed by Congress"],
                  explanation: "An amendment is a formal change or addition to the Constitution. The amendment process requires approval by two-thirds of Congress and three-fourths of states."),
            .init(text: "संशोधन के हो?",
                  options: ["संघीय अदालतको फैसला", "राष्ट्रपतिको कार्यकारी आदेश", "संविधानमा परिवर्तन वा थप", "कांग्रेसले पारित गरेको अस्थायी कानुन"],
                  explanation: "संशोधन भनेको संविधानमा औपचारिक परिवर्तन वा थप हो। संशोधन प्रक्रियामा कांग्रेसको दुई-तिहाई र राज्यहरूको तीन-चौथाई अनुमोदन चाहिन्छ।")
        ]),
        UnifiedQuestion(id: "q_08_005", correctAnswer: 3, variants: [
            .init(text: "What do we call the first ten amendments to the Constitution?",
                  options: ["The Federalist Papers", "The Articles of Confederation", "The Declaration of Rights", "The Bill of Rights"],
                  explanation: "The first ten amendments are the Bill of Rights, ratified in 1791. They guarantee fundamental individual freedoms such as speech, religion, and fair trial."),
            .init(text: "संविधानका पहिलो दश संशोधनलाई हामी के भन्छौं?",
                  options: ["फेडेरलिस्ट पेपर्स", "परिसंघका धाराहरू", "अधिकारको घोषणापत्र", "अधिकारको विधेयक"],
                  explanation: "पहिलो दश संशोधनहरू अधिकारको विधेयक हुन्, जुन सन् १७९१ मा अनुमोदित भयो। यसले बोली, धर्म र निष्पक्ष सुनुवाइ जस्ता मौलिक व्यक्तिगत स्वतन्त्रताहरू ग्यारेन्टी गर्छ।")
        ]),
        UnifiedQuestion(id: "q_08_006", correctAnswer: 1, variants: [
            .init(text: "What is one right or freedom from the First Amendment?",
                  options: ["Right to bear arms", "Freedom of speech", "Right to vote", "Right to a trial by jury"],
                  explanation: "The First Amendment protects five freedoms: religion, speech, press, assembly, and the right to petition the government."),
            .init(text: "पहिलो संशोधनको एउटा अधिकार वा स्वतन्त्रता के हो?",
                  options: ["हतियार बोक्ने अधिकार", "बोलीको स्वतन्त्रता", "मतदानको अधिकार", "जुरीद्वारा सुनुवाइको अधिकार"],
                  explanation: "पहिलो संशोधनले पाँच स्वतन्त्रताहरू सुरक्षित गर्छ: धर्म, बोली, प्रेस, सभा र सरकारसँग निवेदन गर्ने अधिकार।")
        ]),
        UnifiedQuestion(id: "q_08_007", correctAnswer: 2, variants: [
            .init(text: "How many amendments does the Constitution have?",
                  options: ["10", "21", "27", "33"],
                  explanation: "The Constitution has been amended 27 times. The first 10 (the Bill of Rights) were ratified in 1791; the most recent (27th) was ratified in 1992."),
            .init(text: "संविधानमा कतिवटा संशोधन छन्?",
                  options: ["१०", "२१", "२७", "३३"],
                  explanation: "संविधान २७ पटक संशोधन गरिएको छ। पहिलो १० (अधिकारको विधेयक) सन् १७९१ मा अनुमोदित भए; सबैभन्दा हालको (२७औं) सन् १९९२ मा अनुमोदित भयो।")
        ]),
        UnifiedQuestion(id: "q_08_008", correctAnswer: 1, variants: [
            .init(text: "What did the Declaration of Independence do?",
                  options: ["Created the U.S. Constitution", "Announced and declared our independence from Great Britain", "Established the Bill of Rights", "Set up the three branches of government"],
                  explanation: "The Declaration of Independence, adopted July 4, 1776, formally announced separation from British rule and stated the principles of liberty and equality."),
            .init(text: "स्वतन्त्रताको घोषणापत्रले के गर्यो?",
                  options: ["अमेरिकी संविधान बनायो", "ग्रेट ब्रिटेनबाट हाम्रो स्वतन्त्रता घोषणा गर्यो", "अधिकारको विधेयक स्थापना गर्यो", "सरकारका तीन शाखाहरू स्थापना गर्यो"],
                  explanation: "जुलाई ४, १७७६ मा अपनाइएको स्वतन्त्रताको घोषणापत्रले ब्रिटिश शासनबाट औपचारिक विच्छेदको घोषणा गर्यो र स्वतन्त्रता र समानताका सिद्धान्तहरू व्यक्त गर्यो।")
        ]),
        UnifiedQuestion(id: "q_08_009", correctAnswer: 1, variants: [
            .init(text: "What are two rights in the Declaration of Independence?",
                  options: ["Free speech and religion", "Life and liberty (or pursuit of happiness)", "Right to vote and bear arms", "Trial by jury and free press"],
                  explanation: "USCIS accepts any two of: life / liberty / pursuit of happiness. The Declaration states these as 'unalienable rights' — the most famous words in American founding history."),
            .init(text: "स्वतन्त्रताको घोषणापत्रमा उल्लेखित दुई अधिकार के हुन्?",
                  options: ["बोलीको स्वतन्त्रता र धर्म", "जीवन र स्वतन्त्रता (वा खुसीको खोज)", "मत दिने र हतियार बोक्ने अधिकार", "जुरीद्वारा सुनुवाइ र स्वतन्त्र प्रेस"],
                  explanation: "USCIS ले कुनै दुईलाई स्वीकार गर्छ: जीवन / स्वतन्त्रता / खुसीको खोज। घोषणापत्रले यिनीहरूलाई 'अहस्तान्तरणीय अधिकार' भनेको छ।")
        ]),
        UnifiedQuestion(id: "q_08_010", correctAnswer: 2, variants: [
            .init(text: "What is freedom of religion?",
                  options: ["The government selects an official religion for all citizens", "You may only practice one of several approved religions", "You can practice any religion, or not practice a religion", "Religious leaders help run the government"],
                  explanation: "Freedom of religion means you can practice any faith — or no faith — without any government interference. This was a core reason many colonists came to America."),
            .init(text: "धर्मको स्वतन्त्रता के हो?",
                  options: ["सरकारले सबै नागरिकको लागि एउटा आधिकारिक धर्म छनोट गर्छ", "तपाईं केवल अनुमोदित धर्महरूमध्ये एउटा मात्र पालन गर्न सक्नुहुन्छ", "तपाईं कुनै पनि धर्म पालन गर्न वा नगर्न सक्नुहुन्छ", "धर्मगुरुहरूले सरकार चलाउन मद्दत गर्छन्"],
                  explanation: "धर्मको स्वतन्त्रता भनेको तपाईं कुनै पनि सरकारी हस्तक्षेपबिना कुनै पनि आस्था पालन गर्न — वा नगर्न — सक्नुहुन्छ। यो धेरै उपनिवेशवादीहरू अमेरिका आउनुको मुख्य कारण थियो।")
        ]),
    ]

    // MARK: - Practice Set 2: Government Structure (Q11–Q20)
    static let practice2: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_011", correctAnswer: 1, variants: [
            .init(text: "What is the economic system in the United States?",
                  options: ["Socialist economy", "Capitalist economy / market economy", "Communist economy", "Mixed feudal economy"],
                  explanation: "The United States has a capitalist, free market economy where businesses and prices are largely driven by supply, demand, and private ownership."),
            .init(text: "संयुक्त राज्यको आर्थिक प्रणाली के हो?",
                  options: ["समाजवादी अर्थतन्त्र", "पुँजीवादी अर्थतन्त्र / बजार अर्थतन्त्र", "साम्यवादी अर्थतन्त्र", "मिश्रित सामन्तवादी अर्थतन्त्र"],
                  explanation: "संयुक्त राज्यमा पुँजीवादी, खुला बजार अर्थतन्त्र छ जहाँ व्यवसाय र मूल्यहरू मुख्यतया आपूर्ति, माग र निजी स्वामित्वले चलाउँछ।")
        ]),
        UnifiedQuestion(id: "q_08_012", correctAnswer: 2, variants: [
            .init(text: "What is the 'rule of law'?",
                  options: ["Kings and rulers make all the laws", "Only criminals must follow the law", "Everyone must follow the law, including government leaders", "Laws apply only to citizens, not visitors"],
                  explanation: "Under the rule of law, everyone — including the President and Congress — must obey the same laws. No one is above the law."),
            .init(text: "कानुनको शासन के हो?",
                  options: ["राजा र शासकहरूले सबै कानुन बनाउँछन्", "केवल अपराधीहरूले कानुन पालन गर्नुपर्छ", "सरकारी नेताहरू सहित सबैले कानुन पालन गर्नुपर्छ", "कानुन केवल नागरिकहरूमा लागू हुन्छ, पाहुनाहरूमा होइन"],
                  explanation: "कानुनको शासनअन्तर्गत राष्ट्रपति र कांग्रेस सहित सबैले एउटै कानुन मान्नुपर्छ। कोही पनि कानुनभन्दा माथि छैन।")
        ]),
        UnifiedQuestion(id: "q_08_013", correctAnswer: 1, variants: [
            .init(text: "Name one branch or part of the government.",
                  options: ["The Army", "Congress (legislative branch)", "The FBI", "The Department of the Treasury"],
                  explanation: "The three branches are: Legislative (Congress — makes laws), Executive (President — enforces laws), and Judicial (courts — interprets laws)."),
            .init(text: "सरकारको एउटा शाखा वा भागको नाम लिनुहोस्।",
                  options: ["सेना", "कांग्रेस (विधायिका शाखा)", "एफबीआई", "खजाना विभाग"],
                  explanation: "तीन शाखाहरू हुन्: विधायिका (कांग्रेस — कानुन बनाउँछ), कार्यपालिका (राष्ट्रपति — कानुन लागू गर्छ) र न्यायपालिका (अदालतहरू — कानुन व्याख्या गर्छ)।")
        ]),
        UnifiedQuestion(id: "q_08_014", correctAnswer: 1, variants: [
            .init(text: "What stops one branch of government from becoming too powerful?",
                  options: ["Popular vote", "Checks and balances / separation of powers", "The military", "State governments"],
                  explanation: "Checks and balances allow each branch to limit the others. For example, Congress makes laws, the President can veto them, and the courts can strike them down if unconstitutional."),
            .init(text: "सरकारको एउटा शाखालाई अत्यधिक शक्तिशाली हुनबाट के रोक्छ?",
                  options: ["जनताको मत", "नियन्त्रण र सन्तुलन / शक्तिको विभाजन", "सेना", "राज्य सरकारहरू"],
                  explanation: "नियन्त्रण र सन्तुलनले प्रत्येक शाखालाई अरूलाई सीमित गर्न अनुमति दिन्छ। उदाहरणका लागि, कांग्रेसले कानुन बनाउँछ, राष्ट्रपतिले भेटो गर्न सक्छन् र अदालतले संविधानविपरित भए खारेज गर्न सक्छ।")
        ]),
        UnifiedQuestion(id: "q_08_015", correctAnswer: 2, variants: [
            .init(text: "Who is in charge of the executive branch?",
                  options: ["The Speaker of the House", "The Chief Justice of the Supreme Court", "The President", "The Secretary of State"],
                  explanation: "The President leads the executive branch, which carries out and enforces laws passed by Congress."),
            .init(text: "कार्यपालिका शाखाको प्रमुख को हो?",
                  options: ["प्रतिनिधि सभाका सभामुख", "सर्वोच्च अदालतका प्रधान न्यायाधीश", "राष्ट्रपति", "विदेश सचिव"],
                  explanation: "राष्ट्रपतिले कार्यपालिका शाखाको नेतृत्व गर्छन्, जसले कांग्रेसले पारित कानुनहरू कार्यान्वयन र लागू गर्छ।")
        ]),
        UnifiedQuestion(id: "q_08_016", correctAnswer: 2, variants: [
            .init(text: "Who makes federal laws?",
                  options: ["The President", "The Supreme Court", "Congress (Senate and House of Representatives)", "State governors"],
                  explanation: "Congress — the legislative branch made up of the Senate and House of Representatives — is the federal lawmaking body."),
            .init(text: "संघीय कानुन को बनाउँछ?",
                  options: ["राष्ट्रपति", "सर्वोच्च अदालत", "कांग्रेस (सेनेट र प्रतिनिधि सभा)", "राज्यका गभर्नरहरू"],
                  explanation: "कांग्रेस — सेनेट र प्रतिनिधि सभाले मिलेर बनेको विधायिका शाखा — संघीय कानुन बनाउने निकाय हो।")
        ]),
        UnifiedQuestion(id: "q_08_017", correctAnswer: 1, variants: [
            .init(text: "What are the two parts of the U.S. Congress?",
                  options: ["The President and Vice President", "The Senate and House of Representatives", "The Supreme Court and Congress", "The Democratic and Republican parties"],
                  explanation: "Congress is bicameral: the Senate (100 members, 2 per state) and the House of Representatives (435 members, apportioned by population)."),
            .init(text: "अमेरिकी कांग्रेसका दुई भाग के हुन्?",
                  options: ["राष्ट्रपति र उपराष्ट्रपति", "सेनेट र प्रतिनिधि सभा", "सर्वोच्च अदालत र कांग्रेस", "डेमोक्र्याटिक र रिपब्लिकन पार्टीहरू"],
                  explanation: "कांग्रेस द्विसदनीय छ: सेनेट (१०० सदस्य, प्रति राज्य २) र प्रतिनिधि सभा (४३५ सदस्य, जनसङ्ख्या अनुसार)।")
        ]),
        UnifiedQuestion(id: "q_08_018", correctAnswer: 1, variants: [
            .init(text: "How many U.S. Senators are there?",
                  options: ["50", "100", "435", "535"],
                  explanation: "There are 100 U.S. Senators — exactly two from each of the 50 states, regardless of the state's population."),
            .init(text: "कति जना अमेरिकी सिनेटर छन्?",
                  options: ["५०", "१००", "४३५", "५३५"],
                  explanation: "१०० जना अमेरिकी सिनेटर छन् — जनसङ्ख्या जेसुकै भए पनि ५० राज्य प्रत्येकबाट ठिक दुई जना।")
        ]),
        UnifiedQuestion(id: "q_08_019", correctAnswer: 2, variants: [
            .init(text: "We elect a U.S. Senator for how many years?",
                  options: ["2 years", "4 years", "6 years", "8 years"],
                  explanation: "U.S. Senators serve 6-year terms. Elections are staggered so roughly one-third of Senate seats are contested every two years."),
            .init(text: "अमेरिकी सिनेटर कति वर्षको लागि चुनिन्छन्?",
                  options: ["२ वर्ष", "४ वर्ष", "६ वर्ष", "८ वर्ष"],
                  explanation: "अमेरिकी सिनेटरहरू ६ वर्षको कार्यकालको लागि सेवा गर्छन्। निर्वाचनहरू क्रमबद्ध गरिएका छन् ताकि हरेक दुई वर्षमा लगभग एक-तिहाई सेनेट सिटहरूमा प्रतिस्पर्धा हुन्छ।")
        ]),
        UnifiedQuestion(id: "q_08_020", correctAnswer: 0, variants: [
            .init(text: "Who is one of your state's U.S. Senators now?",
                  options: ["Answers will vary — research your state", "Elizabeth Warren", "Marco Rubio", "Mitch McConnell"],
                  explanation: "U.S. Senators represent their state. The correct answer depends on which state you live in. Look up your two current senators at senate.gov before your interview."),
            .init(text: "अहिले तपाईंको राज्यका एक अमेरिकी सिनेटर को हुन्?",
                  options: ["उत्तर फरक पर्छ — आफ्नो राज्य खोज्नुहोस्", "एलिजाबेथ वारेन", "मार्को रुबियो", "मिच म्याककोनेल"],
                  explanation: "अमेरिकी सिनेटरहरूले आफ्नो राज्यको प्रतिनिधित्व गर्छन्। सही उत्तर तपाईं कुन राज्यमा बस्नुहुन्छ त्यसमा निर्भर गर्छ। अन्तर्वार्ताअघि senate.gov मा आफ्ना दुई हालका सिनेटरहरू खोज्नुहोस्।")
        ]),
    ]

    // MARK: - Practice Set 3: Congress and Elections (Q21–Q30)
    static let practice3: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_021", correctAnswer: 2, variants: [
            .init(text: "The House of Representatives has how many voting members?",
                  options: ["100", "270", "435", "538"],
                  explanation: "The House has 435 voting members. The number from each state is based on population as counted by the census every 10 years."),
            .init(text: "प्रतिनिधि सभामा कति मतदान गर्ने सदस्य छन्?",
                  options: ["१००", "२७०", "४३५", "५३८"],
                  explanation: "प्रतिनिधि सभामा ४३५ मतदान गर्ने सदस्य छन्। प्रत्येक राज्यबाट सदस्य संख्या हरेक १० वर्षमा जनगणनाले गणना गरेको जनसङ्ख्यामा आधारित हुन्छ।")
        ]),
        UnifiedQuestion(id: "q_08_022", correctAnswer: 0, variants: [
            .init(text: "We elect a U.S. Representative for how many years?",
                  options: ["2 years", "4 years", "6 years", "8 years"],
                  explanation: "U.S. Representatives serve 2-year terms. Because they must run every two years, all 435 House seats are on the ballot in every election cycle."),
            .init(text: "अमेरिकी प्रतिनिधि कति वर्षको लागि चुनिन्छन्?",
                  options: ["२ वर्ष", "४ वर्ष", "६ वर्ष", "८ वर्ष"],
                  explanation: "अमेरिकी प्रतिनिधिहरू २ वर्षको कार्यकालको लागि सेवा गर्छन्। हरेक दुई वर्षमा निर्वाचन लड्नुपर्ने हुनाले, सबै ४३५ प्रतिनिधि सभा सिटहरू हरेक निर्वाचन चक्रमा मतपत्रमा हुन्छन्।")
        ]),
        UnifiedQuestion(id: "q_08_023", correctAnswer: 0, variants: [
            .init(text: "Name your U.S. Representative.",
                  options: ["Answers will vary — research your district", "Nancy Pelosi", "Kevin McCarthy", "Hakeem Jeffries"],
                  explanation: "Your U.S. Representative represents your specific congressional district. Look up your representative at house.gov before your interview."),
            .init(text: "तपाईंको अमेरिकी प्रतिनिधिको नाम लिनुहोस्।",
                  options: ["उत्तर फरक पर्छ — आफ्नो क्षेत्र खोज्नुहोस्", "न्यान्सी पेलोसी", "केभिन म्याककार्थी", "हकिम जेफ्रीज"],
                  explanation: "तपाईंको अमेरिकी प्रतिनिधिले तपाईंको विशेष कांग्रेसनल क्षेत्रको प्रतिनिधित्व गर्छन्। अन्तर्वार्ताअघि house.gov मा आफ्नो प्रतिनिधि खोज्नुहोस्।")
        ]),
        UnifiedQuestion(id: "q_08_024", correctAnswer: 1, variants: [
            .init(text: "Who does a U.S. Senator represent?",
                  options: ["Only the voters who elected them", "All the people of their state", "Their political party's supporters", "The federal government"],
                  explanation: "Each U.S. Senator represents ALL residents of their state — not just those who voted for them or belong to their party."),
            .init(text: "अमेरिकी सिनेटरले कसलाई प्रतिनिधित्व गर्छन्?",
                  options: ["केवल उनलाई चुन्ने मतदाताहरूलाई", "उनको राज्यका सबै मानिसहरूलाई", "उनको राजनीतिक पार्टीका समर्थकहरूलाई", "संघीय सरकारलाई"],
                  explanation: "प्रत्येक अमेरिकी सिनेटरले आफ्नो राज्यका सबै बासिन्दाहरूको प्रतिनिधित्व गर्छन् — केवल उनलाई मत दिनेहरू वा उनको पार्टीका सदस्यहरू मात्र होइन।")
        ]),
        UnifiedQuestion(id: "q_08_025", correctAnswer: 2, variants: [
            .init(text: "Why do some states have more Representatives than other states?",
                  options: ["Because of the state's geographic size", "Because of the state's wealth and tax revenue", "Because of the state's population", "Because of how long the state has been in the Union"],
                  explanation: "House seats are apportioned by population. California, the most populous state, has the most Representatives; states like Wyoming have just one."),
            .init(text: "केही राज्यहरूमा अन्य राज्यहरूभन्दा किन बढी प्रतिनिधि छन्?",
                  options: ["राज्यको भौगोलिक आकारको कारण", "राज्यको सम्पत्ति र करको कारण", "राज्यको जनसङ्ख्याको कारण", "राज्य संघमा कति समयदेखि छ त्यसको कारण"],
                  explanation: "प्रतिनिधि सभाका सिटहरू जनसङ्ख्याको आधारमा बाँडिन्छन्। सबैभन्दा बढी जनसङ्ख्या भएको राज्य क्यालिफोर्नियामा सबैभन्दा बढी प्रतिनिधि छन्; व्यायोमिङ जस्ता राज्यहरूमा केवल एक जना छन्।")
        ]),
        UnifiedQuestion(id: "q_08_026", correctAnswer: 2, variants: [
            .init(text: "We elect a President for how many years?",
                  options: ["2 years", "3 years", "4 years", "6 years"],
                  explanation: "The President serves a 4-year term. The 22nd Amendment (1951) limits the President to two terms (maximum 8 years) in office."),
            .init(text: "राष्ट्रपति कति वर्षको लागि चुनिन्छन्?",
                  options: ["२ वर्ष", "३ वर्ष", "४ वर्ष", "६ वर्ष"],
                  explanation: "राष्ट्रपति ४ वर्षको कार्यकालको लागि सेवा गर्छन्। २२औं संशोधन (१९५१) ले राष्ट्रपतिलाई दुई कार्यकाल (अधिकतम ८ वर्ष) मा सीमित गर्छ।")
        ]),
        UnifiedQuestion(id: "q_08_027", correctAnswer: 2, variants: [
            .init(text: "In what month do we vote for President?",
                  options: ["September", "October", "November", "December"],
                  explanation: "Presidential elections are held on the first Tuesday after the first Monday in November every four years. In 2024, the election was November 5."),
            .init(text: "राष्ट्रपतिको लागि कुन महिनामा मतदान गर्छौं?",
                  options: ["सेप्टेम्बर", "अक्टोबर", "नोभेम्बर", "डिसेम्बर"],
                  explanation: "राष्ट्रपतीय निर्वाचन हरेक चार वर्षमा नोभेम्बरको पहिलो सोमवारपछिको पहिलो मंगलवारमा हुन्छ। सन् २०२४ मा निर्वाचन नोभेम्बर ५ मा थियो।")
        ]),
        UnifiedQuestion(id: "q_08_028", correctAnswer: 2, variants: [
            .init(text: "What is the name of the President of the United States now?",
                  options: ["Joe Biden", "Barack Obama", "Donald Trump", "Kamala Harris"],
                  explanation: "Donald Trump is the 47th President of the United States, having taken office in January 2025 for his second term."),
            .init(text: "हालका अमेरिकी राष्ट्रपतिको नाम के हो?",
                  options: ["जो बाइडेन", "बराक ओबामा", "डोनाल्ड ट्रम्प", "कमला ह्यारिस"],
                  explanation: "डोनाल्ड ट्रम्प अमेरिकाका ४७औं राष्ट्रपति हुन्, जसले आफ्नो दोस्रो कार्यकालको लागि जनवरी २०२५ मा पद ग्रहण गरे।")
        ]),
        UnifiedQuestion(id: "q_08_029", correctAnswer: 2, variants: [
            .init(text: "What is the name of the Vice President of the United States now?",
                  options: ["Kamala Harris", "Mike Pence", "JD Vance", "Tim Walz"],
                  explanation: "JD Vance is the 50th Vice President of the United States, serving alongside President Trump since January 2025."),
            .init(text: "हालका अमेरिकी उपराष्ट्रपतिको नाम के हो?",
                  options: ["कमला ह्यारिस", "माइक पेन्स", "जेडी भान्स", "टिम वाल्ज"],
                  explanation: "जेडी भान्स अमेरिकाका ५०औं उपराष्ट्रपति हुन्, जसले जनवरी २०२५ देखि राष्ट्रपति ट्रम्पसँगै सेवा गरिरहेका छन्।")
        ]),
        UnifiedQuestion(id: "q_08_030", correctAnswer: 3, variants: [
            .init(text: "If the President can no longer serve, who becomes President?",
                  options: ["The Speaker of the House", "The Chief Justice", "The Secretary of State", "The Vice President"],
                  explanation: "The Vice President becomes President if the President is unable to serve, per the 25th Amendment (1967)."),
            .init(text: "राष्ट्रपतिले सेवा गर्न नसके को राष्ट्रपति बन्छन्?",
                  options: ["प्रतिनिधि सभाका सभामुख", "प्रधान न्यायाधीश", "विदेश सचिव", "उपराष्ट्रपति"],
                  explanation: "२५औं संशोधन (१९६७) अनुसार राष्ट्रपतिले सेवा गर्न नसके उपराष्ट्रपति राष्ट्रपति बन्छन्।")
        ]),
    ]

    // MARK: - Practice Set 4: Executive and Judicial Branches (Q31–Q40)
    static let practice4: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_031", correctAnswer: 1, variants: [
            .init(text: "If both the President and the Vice President can no longer serve, who becomes President?",
                  options: ["The Secretary of State", "The Speaker of the House", "The President pro tempore of the Senate", "The Chief Justice of the Supreme Court"],
                  explanation: "By the Presidential Succession Act, the Speaker of the House is second in the line of succession, after the Vice President."),
            .init(text: "राष्ट्रपति र उपराष्ट्रपति दुवैले सेवा गर्न नसके को राष्ट्रपति बन्छन्?",
                  options: ["विदेश सचिव", "प्रतिनिधि सभाका सभामुख", "सेनेटका अस्थायी अध्यक्ष", "सर्वोच्च अदालतका प्रधान न्यायाधीश"],
                  explanation: "राष्ट्रपतीय उत्तराधिकार ऐन अनुसार, प्रतिनिधि सभाका सभामुख उपराष्ट्रपतिपछि उत्तराधिकारको दोस्रो क्रममा हुन्छन्।")
        ]),
        UnifiedQuestion(id: "q_08_032", correctAnswer: 2, variants: [
            .init(text: "Who is the Commander in Chief of the military?",
                  options: ["The Secretary of Defense", "A four-star general", "The President", "The Chairman of the Joint Chiefs of Staff"],
                  explanation: "The President serves as Commander in Chief of all U.S. armed forces, ensuring civilian control of the military — a key democratic principle."),
            .init(text: "सेनाका प्रधान सेनापति को हुन्?",
                  options: ["रक्षा सचिव", "चार तारे जनरल", "राष्ट्रपति", "संयुक्त सैन्य प्रमुखका अध्यक्ष"],
                  explanation: "राष्ट्रपति सबै अमेरिकी सशस्त्र बलका प्रधान सेनापतिको रूपमा कार्य गर्छन्, जसले सेनाको नागरिक नियन्त्रण सुनिश्चित गर्छ — एक प्रमुख लोकतान्त्रिक सिद्धान्त।")
        ]),
        UnifiedQuestion(id: "q_08_033", correctAnswer: 2, variants: [
            .init(text: "Who signs bills to become laws?",
                  options: ["The Speaker of the House", "The Vice President", "The President", "The Chief Justice"],
                  explanation: "After Congress passes a bill, it goes to the President. If signed, it becomes law. If the President vetoes it, Congress can attempt to override with a two-thirds majority."),
            .init(text: "विधेयकलाई कानुन बनाउन कसले हस्ताक्षर गर्छन्?",
                  options: ["प्रतिनिधि सभाका सभामुख", "उपराष्ट्रपति", "राष्ट्रपति", "प्रधान न्यायाधीश"],
                  explanation: "कांग्रेसले विधेयक पारित गरेपछि, यो राष्ट्रपतिकहाँ जान्छ। हस्ताक्षर भएमा, यो कानुन बन्छ। राष्ट्रपतिले भेटो गरेमा, कांग्रेसले दुई-तिहाई बहुमतले अस्वीकृति रद्द गर्न सक्छ।")
        ]),
        UnifiedQuestion(id: "q_08_034", correctAnswer: 3, variants: [
            .init(text: "Who vetoes bills?",
                  options: ["The Senate Majority Leader", "The Supreme Court", "The Speaker of the House", "The President"],
                  explanation: "The President can veto (reject) legislation passed by Congress. Congress may override a veto with a two-thirds vote in both the Senate and House."),
            .init(text: "विधेयक अस्वीकार (भेटो) गर्न को सक्छन्?",
                  options: ["सेनेटका बहुमत नेता", "सर्वोच्च अदालत", "प्रतिनिधि सभाका सभामुख", "राष्ट्रपति"],
                  explanation: "राष्ट्रपतिले कांग्रेसले पारित गरेको कानुनलाई भेटो (अस्वीकार) गर्न सक्छन्। कांग्रेसले सेनेट र प्रतिनिधि सभा दुवैमा दुई-तिहाई मतले भेटो रद्द गर्न सक्छ।")
        ]),
        UnifiedQuestion(id: "q_08_035", correctAnswer: 1, variants: [
            .init(text: "What does the President's Cabinet do?",
                  options: ["Makes federal laws", "Advises the President", "Elects the Vice President", "Oversees the Supreme Court"],
                  explanation: "The Cabinet is made up of the heads of 15 executive departments (like State, Defense, Treasury) who advise the President on major policy decisions."),
            .init(text: "राष्ट्रपतिको मन्त्रिपरिषद्ले के गर्छ?",
                  options: ["संघीय कानुन बनाउँछ", "राष्ट्रपतिलाई सल्लाह दिन्छ", "उपराष्ट्रपति चुन्छ", "सर्वोच्च अदालतको निरीक्षण गर्छ"],
                  explanation: "मन्त्रिपरिषद् १५ कार्यकारी विभागका प्रमुखहरूले बनेको हुन्छ (जस्तै विदेश, रक्षा, खजाना) जसले राष्ट्रपतिलाई प्रमुख नीति निर्णयहरूमा सल्लाह दिन्छन्।")
        ]),
        UnifiedQuestion(id: "q_08_036", correctAnswer: 2, variants: [
            .init(text: "What are two Cabinet-level positions?",
                  options: ["Senator and Representative", "Governor and Mayor", "Secretary of State and Secretary of Defense", "Chief Justice and Speaker of the House"],
                  explanation: "Cabinet positions include the Vice President and 15 department heads such as Secretary of State, Defense, Treasury, and the Attorney General. (Chief Justice and Speaker lead judicial/legislative branches — not Cabinet.)"),
            .init(text: "दुई मन्त्रिपरिषद् स्तरका पदहरू के हुन्?",
                  options: ["सिनेटर र प्रतिनिधि", "गभर्नर र मेयर", "विदेश सचिव र रक्षा सचिव", "प्रधान न्यायाधीश र प्रतिनिधि सभाका सभामुख"],
                  explanation: "मन्त्रिपरिषद् पदहरूमा उपराष्ट्रपति र विदेश सचिव, रक्षा सचिव, खजाना सचिव र महान्यायाधिवक्ता जस्ता १५ विभाग प्रमुखहरू समावेश छन्। (प्रधान न्यायाधीश र प्रतिनिधि सभाका सभामुख न्यायिक/व्यवस्थापिका शाखाका नेता हुन्, मन्त्रिपरिषद्का होइनन्।)")
        ]),
        UnifiedQuestion(id: "q_08_037", correctAnswer: 3, variants: [
            .init(text: "What does the judicial branch do?",
                  options: ["Makes federal laws", "Enforces laws and manages the military", "Collects taxes and prints money", "Reviews laws and decides if they are constitutional"],
                  explanation: "The judicial branch interprets laws, resolves legal disputes, and — crucially — determines whether laws are consistent with the Constitution."),
            .init(text: "न्यायिक शाखाले के गर्छ?",
                  options: ["संघीय कानुन बनाउँछ", "कानुन लागू गर्छ र सेना व्यवस्थापन गर्छ", "कर उठाउँछ र पैसा छाप्छ", "कानुनहरूको समीक्षा गर्छ र ती संविधानसम्मत छन् कि छैनन् निर्णय गर्छ"],
                  explanation: "न्यायिक शाखाले कानुनहरूको व्याख्या गर्छ, कानुनी विवादहरू समाधान गर्छ र — महत्त्वपूर्ण रूपमा — कानुनहरू संविधानसँग अनुकूल छन् कि छैनन् निर्धारण गर्छ।")
        ]),
        UnifiedQuestion(id: "q_08_038", correctAnswer: 3, variants: [
            .init(text: "What is the highest court in the United States?",
                  options: ["The Federal Appeals Court", "The State Supreme Court", "The Federal District Court", "The Supreme Court"],
                  explanation: "The U.S. Supreme Court is the highest court in the land. Its decisions are final and binding on all lower courts throughout the country."),
            .init(text: "संयुक्त राज्यको सर्वोच्च अदालत कुन हो?",
                  options: ["संघीय पुनरावेदन अदालत", "राज्यको सर्वोच्च अदालत", "संघीय जिल्ला अदालत", "सर्वोच्च अदालत"],
                  explanation: "अमेरिकी सर्वोच्च अदालत देशको सर्वोच्च अदालत हो। यसका फैसलाहरू अन्तिम हुन्छन् र देशभरका सबै तल्लो अदालतहरूमा बाध्यकारी हुन्छन्।")
        ]),
        UnifiedQuestion(id: "q_08_039", correctAnswer: 1, variants: [
            .init(text: "How many justices are on the Supreme Court?",
                  options: ["7", "9", "11", "13"],
                  explanation: "The Supreme Court has 9 justices: one Chief Justice and eight Associate Justices. This number has been set by law since 1869."),
            .init(text: "सर्वोच्च अदालतमा कति न्यायाधीश छन्?",
                  options: ["७", "९", "११", "१३"],
                  explanation: "सर्वोच्च अदालतमा ९ न्यायाधीश छन्: एक प्रधान न्यायाधीश र आठ सहायक न्यायाधीश। यो संख्या सन् १८६९ देखि कानुनद्वारा निर्धारित गरिएको छ।")
        ]),
        UnifiedQuestion(id: "q_08_040", correctAnswer: 2, variants: [
            .init(text: "Who is the Chief Justice of the United States now?",
                  options: ["Sonia Sotomayor", "Clarence Thomas", "John Roberts", "Elena Kagan"],
                  explanation: "John G. Roberts Jr. has served as Chief Justice of the United States since 2005, appointed by President George W. Bush."),
            .init(text: "हालका अमेरिकाका प्रधान न्यायाधीश को हुन्?",
                  options: ["सोनिया सोटोमेयर", "क्लेरेन्स थोमस", "जोन रोबर्ट्स", "एलेना कागान"],
                  explanation: "जोन जी. रोबर्ट्स जुनियर सन् २००५ देखि अमेरिकाका प्रधान न्यायाधीशको रूपमा सेवा गरिरहेका छन्, जसलाई राष्ट्रपति जर्ज डब्ल्यू. बुशले नियुक्त गरेका थिए।")
        ]),
    ]

    // MARK: - Practice Set 5: Powers and Rights (Q41–Q50)
    static let practice5: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_041", correctAnswer: 2, variants: [
            .init(text: "Under our Constitution, some powers belong to the federal government. What is one power of the federal government?",
                  options: ["Issue driver's licenses", "Set local zoning laws", "To print money", "Provide fire protection"],
                  explanation: "Exclusive federal powers include printing money, declaring war, creating an army, and making treaties with other countries."),
            .init(text: "हाम्रो संविधान अन्तर्गत, केही अधिकारहरू संघीय सरकारका हुन्। संघीय सरकारको एउटा अधिकार के हो?",
                  options: ["ड्राइभिङ लाइसेन्स जारी गर्नु", "स्थानीय जोनिङ कानुन बनाउनु", "पैसा छाप्नु", "दमकल सेवा प्रदान गर्नु"],
                  explanation: "एकल संघीय अधिकारहरूमा पैसा छाप्नु, युद्ध घोषणा गर्नु, सेना बनाउनु र अन्य देशहरूसँग सन्धि गर्नु समावेश छन्।")
        ]),
        UnifiedQuestion(id: "q_08_042", correctAnswer: 3, variants: [
            .init(text: "Under our Constitution, some powers belong to the states. What is one power of the states?",
                  options: ["Declare war", "Print money", "Make treaties with foreign nations", "Provide schooling and education"],
                  explanation: "State powers include providing education, police protection, fire departments, driver's licenses, and zoning/land use decisions."),
            .init(text: "हाम्रो संविधान अन्तर्गत, केही अधिकारहरू राज्यहरूका हुन्। राज्यको एउटा अधिकार के हो?",
                  options: ["युद्ध घोषणा गर्नु", "पैसा छाप्नु", "विदेशी राष्ट्रहरूसँग सन्धि गर्नु", "शिक्षा र विद्यालय प्रदान गर्नु"],
                  explanation: "राज्य अधिकारहरूमा शिक्षा, प्रहरी सुरक्षा, दमकल विभाग, ड्राइभिङ लाइसेन्स र जोनिङ/भूमि प्रयोग निर्णयहरू प्रदान गर्नु समावेश छन्।")
        ]),
        UnifiedQuestion(id: "q_08_043", correctAnswer: 0, variants: [
            .init(text: "Who is the Governor of your state now?",
                  options: ["Answers will vary — research your state", "Ron DeSantis", "Gavin Newsom", "Greg Abbott"],
                  explanation: "The Governor is the chief executive of a state. Look up your current Governor before your interview — USCIS will ask about YOUR state."),
            .init(text: "अहिले तपाईंको राज्यका गभर्नर को हुन्?",
                  options: ["उत्तर फरक पर्छ — आफ्नो राज्य खोज्नुहोस्", "रोन डिसान्टिस", "ग्याभिन न्युसम", "ग्रेग अब्बोट"],
                  explanation: "गभर्नर राज्यका प्रमुख कार्यकारी हुन्। अन्तर्वार्ताअघि आफ्नो हालका गभर्नर खोज्नुहोस् — USCIS ले तपाईंको राज्यबारे सोध्नेछ।")
        ]),
        UnifiedQuestion(id: "q_08_044", correctAnswer: 0, variants: [
            .init(text: "What is the capital of your state?",
                  options: ["Answers will vary — research your state", "New York City", "Los Angeles", "Chicago"],
                  explanation: "Each state has its own capital city. Note: state capitals are often NOT the largest cities (e.g., Albany is NY's capital, not New York City)."),
            .init(text: "तपाईंको राज्यको राजधानी कहाँ हो?",
                  options: ["उत्तर फरक पर्छ — आफ्नो राज्य खोज्नुहोस्", "न्यू योर्क सिटी", "लस एन्जेलस", "शिकागो"],
                  explanation: "प्रत्येक राज्यको आफ्नै राजधानी शहर छ। नोट: राज्यका राजधानीहरू प्रायः सबैभन्दा ठूला शहरहरू हुँदैनन् (उदाहरणका लागि, अल्बानी न्यू योर्कको राजधानी हो, न्यू योर्क सिटी होइन)।")
        ]),
        UnifiedQuestion(id: "q_08_045", correctAnswer: 2, variants: [
            .init(text: "What are the two major political parties in the United States?",
                  options: ["Liberal and Conservative", "Federalist and Democratic-Republican", "Democratic and Republican", "Independent and Green"],
                  explanation: "The Democratic Party and Republican Party are the two dominant parties in U.S. politics, though other parties (Libertarian, Green, etc.) also exist."),
            .init(text: "संयुक्त राज्यका दुई प्रमुख राजनीतिक दलहरू के हुन्?",
                  options: ["उदारवादी र रूढिवादी", "फेडेरलिस्ट र डेमोक्र्याटिक-रिपब्लिकन", "डेमोक्र्याटिक र रिपब्लिकन", "स्वतन्त्र र हरित"],
                  explanation: "डेमोक्र्याटिक पार्टी र रिपब्लिकन पार्टी अमेरिकी राजनीतिमा दुई प्रमुख दलहरू हुन्, यद्यपि अन्य दलहरू (लिबर्टेरियन, हरित, आदि) पनि अवस्थित छन्।")
        ]),
        UnifiedQuestion(id: "q_08_046", correctAnswer: 1, variants: [
            .init(text: "What is the political party of the President now?",
                  options: ["Democratic Party", "Republican Party", "Independent", "Libertarian Party"],
                  explanation: "Donald Trump, the current President, is a member of the Republican Party."),
            .init(text: "हालका राष्ट्रपतिको राजनीतिक दल कुन हो?",
                  options: ["डेमोक्र्याटिक पार्टी", "रिपब्लिकन पार्टी", "स्वतन्त्र", "लिबर्टेरियन पार्टी"],
                  explanation: "हालका राष्ट्रपति डोनाल्ड ट्रम्प रिपब्लिकन पार्टीका सदस्य हुन्।")
        ]),
        UnifiedQuestion(id: "q_08_047", correctAnswer: 2, variants: [
            .init(text: "What is the name of the Speaker of the House of Representatives now?",
                  options: ["Kevin McCarthy", "Nancy Pelosi", "Mike Johnson", "Hakeem Jeffries"],
                  explanation: "Mike Johnson of Louisiana has served as Speaker of the House since October 2023. The Speaker is second in the line of presidential succession."),
            .init(text: "हालका प्रतिनिधि सभाका सभामुखको नाम के हो?",
                  options: ["केभिन म्याककार्थी", "न्यान्सी पेलोसी", "माइक जोन्सन", "हकिम जेफ्रीज"],
                  explanation: "लुइजियानाका माइक जोन्सनले अक्टोबर २०२३ देखि प्रतिनिधि सभाका सभामुखको रूपमा सेवा गरेका छन्। सभामुख राष्ट्रपतीय उत्तराधिकारको दोस्रो क्रममा हुन्छन्।")
        ]),
        UnifiedQuestion(id: "q_08_048", correctAnswer: 1, variants: [
            .init(text: "There are four amendments to the Constitution about who can vote. Describe one of them.",
                  options: ["All people age 16 and older can vote", "Citizens eighteen (18) and older can vote", "Only property owners can vote", "Only taxpayers can vote"],
                  explanation: "Four voting amendments: 15th (1870, race), 19th (1920, women), 24th (1964, no poll tax), and 26th (1971, age 18+)."),
            .init(text: "संविधानमा मतदानसम्बन्धी चारवटा संशोधन छन्। ती मध्ये एउटाको वर्णन गर्नुहोस्।",
                  options: ["१६ वर्ष र माथिका सबै मानिसले मत दिन सक्छन्", "१८ वर्ष र माथिका नागरिकले मत दिन सक्छन्", "केवल सम्पत्तिवालाहरूले मत दिन सक्छन्", "केवल करदाताहरूले मत दिन सक्छन्"],
                  explanation: "चार मतदान संशोधनहरू: १५औं (१८७०, जाति), १९औं (१९२०, महिला), २४औं (१९६४, मतदान कर छैन) र २६औं (१९७१, १८ वर्ष र माथि)।")
        ]),
        UnifiedQuestion(id: "q_08_049", correctAnswer: 2, variants: [
            .init(text: "What is one responsibility that is only for United States citizens?",
                  options: ["Pay taxes", "Follow federal and state laws", "Serve on a jury", "Obey local ordinances"],
                  explanation: "Serving on a jury and voting in federal elections are civic responsibilities reserved exclusively for U.S. citizens. All residents must pay taxes and follow the law."),
            .init(text: "केवल अमेरिकी नागरिकको मात्र एउटा जिम्मेवारी के हो?",
                  options: ["कर तिर्नु", "संघीय र राज्य कानुन पालन गर्नु", "जुरीमा सेवा गर्नु", "स्थानीय नियमहरू मान्नु"],
                  explanation: "जुरीमा सेवा गर्नु र संघीय निर्वाचनमा मत दिनु केवल अमेरिकी नागरिकहरूका लागि आरक्षित नागरिक जिम्मेवारीहरू हुन्। सबै बासिन्दाहरूले कर तिर्नुपर्छ र कानुन पालन गर्नुपर्छ।")
        ]),
        UnifiedQuestion(id: "q_08_050", correctAnswer: 2, variants: [
            .init(text: "Name one right only for United States citizens.",
                  options: ["Freedom of speech", "Right to a fair trial", "Vote in a federal election", "Freedom of religion"],
                  explanation: "Only U.S. citizens may vote in federal elections and run for federal office. Rights like free speech, fair trial, and religious freedom extend to everyone in the U.S."),
            .init(text: "केवल अमेरिकी नागरिकको मात्र एउटा अधिकार नाम लिनुहोस्।",
                  options: ["बोलीको स्वतन्त्रता", "निष्पक्ष सुनुवाइको अधिकार", "संघीय निर्वाचनमा मत दिनु", "धर्मको स्वतन्त्रता"],
                  explanation: "केवल अमेरिकी नागरिकहरूले संघीय निर्वाचनमा मत दिन र संघीय पदमा उम्मेदवार बन्न सक्छन्। बोलीको स्वतन्त्रता, निष्पक्ष सुनुवाइ र धार्मिक स्वतन्त्रता जस्ता अधिकारहरू अमेरिकामा सबैलाई लागू हुन्छन्।")
        ]),
    ]

    // MARK: - Practice Set 6: Rights & Civic Responsibilities (Q51–Q60)
    static let practice6: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_051", correctAnswer: 1, variants: [
            .init(text: "What are two rights of everyone living in the United States?",
                  options: ["Right to vote and run for federal office", "Freedom of speech and freedom of religion", "Free government housing and employment", "The right to bear arms and vote in local elections"],
                  explanation: "Everyone in the U.S. — citizens and non-citizens — has rights including freedom of expression, speech, assembly, petition, religion, and the right to bear arms."),
            .init(text: "संयुक्त राज्यमा बस्ने सबैका दुई अधिकार के हुन्?",
                  options: ["मत दिने र संघीय पदमा उम्मेदवार बन्ने अधिकार", "बोलीको स्वतन्त्रता र धर्मको स्वतन्त्रता", "सरकारी आवास र रोजगारी", "हतियार बोक्ने र स्थानीय निर्वाचनमा मत दिने अधिकार"],
                  explanation: "अमेरिकामा बस्ने सबै — नागरिक र गैर-नागरिक — लाई अभिव्यक्ति, बोली, सभा, निवेदन, धर्म र हतियार बोक्ने स्वतन्त्रता सहित अधिकारहरू छन्।")
        ]),
        UnifiedQuestion(id: "q_08_052", correctAnswer: 2, variants: [
            .init(text: "What do we show loyalty to when we say the Pledge of Allegiance?",
                  options: ["The President of the United States", "The U.S. Constitution and the courts", "The United States and the flag", "The military and veterans"],
                  explanation: "The Pledge of Allegiance is a declaration of loyalty to the United States and to its flag — the national symbol — pledging allegiance to 'one nation, under God, indivisible.'"),
            .init(text: "निष्ठाको प्रतिज्ञा गर्दा हामी कसप्रति वफादारी देखाउँछौं?",
                  options: ["अमेरिकी राष्ट्रपतिप्रति", "अमेरिकी संविधान र अदालतहरूप्रति", "संयुक्त राज्य र झण्डाप्रति", "सेना र युद्धका वीरहरूप्रति"],
                  explanation: "निष्ठाको प्रतिज्ञा संयुक्त राज्य र यसको झण्डाप्रति वफादारीको घोषणा हो — राष्ट्रिय प्रतीक — 「एक राष्ट्र, ईश्वरको अधीनमा, अविभाज्य」 प्रति निष्ठाको प्रतिज्ञा।")
        ]),
        UnifiedQuestion(id: "q_08_053", correctAnswer: 1, variants: [
            .init(text: "What is one promise you make when you become a United States citizen?",
                  options: ["Never leave the United States", "Give up loyalty to other countries", "Always vote in every election", "Pay an extra citizenship tax"],
                  explanation: "The Oath of Allegiance includes: giving up loyalty to foreign nations, defending the Constitution, obeying U.S. laws, and serving the country if needed."),
            .init(text: "अमेरिकी नागरिक बन्दा तपाईं एउटा प्रतिज्ञा के गर्नुहुन्छ?",
                  options: ["कहिले पनि अमेरिका नछोड्नु", "अन्य देशहरूप्रतिको वफादारी त्याग्नु", "हरेक निर्वाचनमा मत दिनु", "थप नागरिकता कर तिर्नु"],
                  explanation: "निष्ठाको शपथमा समावेश छ: विदेशी राष्ट्रहरूप्रतिको वफादारी त्याग्नु, संविधानको रक्षा गर्नु, अमेरिकी कानुन मान्नु र आवश्यक भएमा देशको सेवा गर्नु।")
        ]),
        UnifiedQuestion(id: "q_08_054", correctAnswer: 2, variants: [
            .init(text: "How old do citizens have to be to vote for President?",
                  options: ["16 and older", "21 and older", "18 and older", "25 and older"],
                  explanation: "The 26th Amendment (1971) set the minimum voting age at 18 for all U.S. elections, including presidential elections."),
            .init(text: "राष्ट्रपतिको लागि मत दिन नागरिकको कति उमेर हुनुपर्छ?",
                  options: ["१६ वर्ष र माथि", "२१ वर्ष र माथि", "१८ वर्ष र माथि", "२५ वर्ष र माथि"],
                  explanation: "२६औं संशोधन (१९७१) ले राष्ट्रपतीय निर्वाचन सहित सबै अमेरिकी निर्वाचनहरूको लागि न्यूनतम मतदान उमेर १८ वर्ष निर्धारण गर्यो।")
        ]),
        UnifiedQuestion(id: "q_08_055", correctAnswer: 1, variants: [
            .init(text: "What are two ways that Americans can participate in their democracy?",
                  options: ["Pay taxes and read the news", "Vote and join a civic group", "Work for the government and serve in the military", "Study history and learn English"],
                  explanation: "Americans can participate by voting, joining political parties, running for office, joining civic groups, contacting elected officials, writing to newspapers, and more."),
            .init(text: "अमेरिकीहरू आफ्नो लोकतन्त्रमा भाग लिने दुई तरिका के हुन्?",
                  options: ["कर तिर्नु र समाचार पढ्नु", "मत दिनु र नागरिक समूहमा सामेल हुनु", "सरकारको लागि काम गर्नु र सेनामा सेवा गर्नु", "इतिहास अध्ययन गर्नु र अंग्रेजी सिक्नु"],
                  explanation: "अमेरिकीहरू मत दिएर, राजनीतिक दलहरूमा सामेल भएर, पदमा उम्मेदवार बनेर, नागरिक समूहहरूमा सामेल भएर, निर्वाचित पदाधिकारीहरूलाई सम्पर्क गरेर र थप तरिकाहरूले भाग लिन सक्छन्।")
        ]),
        UnifiedQuestion(id: "q_08_056", correctAnswer: 2, variants: [
            .init(text: "When is the last day you can send in federal income tax forms?",
                  options: ["January 31", "March 15", "April 15", "June 30"],
                  explanation: "Federal income tax returns (Form 1040) are due on April 15 each year. You can file for an automatic extension, but any taxes owed are still due by April 15."),
            .init(text: "संघीय आयकर फारम पठाउने अन्तिम दिन कहिले हो?",
                  options: ["जनवरी ३१", "मार्च १५", "अप्रिल १५", "जुन ३०"],
                  explanation: "संघीय आयकर विवरण (फारम १०४०) हरेक वर्ष अप्रिल १५ सम्म बुझाउनु पर्छ। स्वतः विस्तारको लागि निवेदन दिन सकिन्छ, तर बक्यौता कर अझै पनि अप्रिल १५ सम्म तिर्नुपर्छ।")
        ]),
        UnifiedQuestion(id: "q_08_057", correctAnswer: 2, variants: [
            .init(text: "When must all men register for the Selective Service?",
                  options: ["At age 16", "At age 21", "At age 18 (between 18 and 26)", "Only during wartime when required"],
                  explanation: "All male U.S. residents (citizens and most non-citizens) must register with the Selective Service System within 30 days of turning 18, and by age 26."),
            .init(text: "सबै पुरुषले सेलेक्टिभ सर्भिसमा कहिले दर्ता गर्नुपर्छ?",
                  options: ["१६ वर्षको उमेरमा", "२१ वर्षको उमेरमा", "१८ वर्षको उमेरमा (१८ देखि २६ वर्षको बीचमा)", "केवल युद्धको समयमा आवश्यक भएमा"],
                  explanation: "सबै पुरुष अमेरिकी बासिन्दाहरू (नागरिक र अधिकांश गैर-नागरिक) ले १८ वर्ष पूरा भएको ३० दिनभित्र र २६ वर्षसम्म सेलेक्टिभ सर्भिस प्रणालीमा दर्ता गर्नुपर्छ।")
        ]),
        UnifiedQuestion(id: "q_08_058", correctAnswer: 2, variants: [
            .init(text: "What is one reason colonists came to America?",
                  options: ["To find gold and return to Europe", "To trade exclusively with Native Americans", "For religious freedom and political liberty", "To establish a European monarchy in the New World"],
                  explanation: "Colonists came for religious freedom, political liberty, economic opportunity, and to escape persecution in Europe. Many sought a fresh start."),
            .init(text: "उपनिवेशवादीहरू अमेरिका आउनुको एउटा कारण के थियो?",
                  options: ["सुन खोज्न र युरोप फर्कन", "मूल निवासी अमेरिकीहरूसँग मात्र व्यापार गर्न", "धार्मिक स्वतन्त्रता र राजनीतिक स्वतन्त्रताका लागि", "नयाँ संसारमा युरोपेली राजतन्त्र स्थापना गर्न"],
                  explanation: "उपनिवेशवादीहरू धार्मिक स्वतन्त्रता, राजनीतिक स्वतन्त्रता, आर्थिक अवसर र युरोपमा उत्पीडनबाट बच्न आएका थिए। धेरैले नयाँ सुरुआत खोजेका थिए।")
        ]),
        UnifiedQuestion(id: "q_08_059", correctAnswer: 2, variants: [
            .init(text: "Who lived in America before the Europeans arrived?",
                  options: ["Spanish explorers", "Settlers from Africa", "American Indians (Native Americans)", "Settlers from Asia"],
                  explanation: "American Indians (Native Americans) lived in North America for thousands of years before European colonization began in the late 1400s and 1500s."),
            .init(text: "यूरोपेलीहरू आउनुअघि अमेरिकामा को बस्थे?",
                  options: ["स्पेनी खोजकर्ताहरू", "अफ्रिकाबाट आएका बासिन्दाहरू", "अमेरिकी आदिवासीहरू (मूल निवासी अमेरिकीहरू)", "एसियाबाट आएका बासिन्दाहरू"],
                  explanation: "अमेरिकी आदिवासीहरू (मूल निवासी अमेरिकीहरू) १४०० को दशकको अन्त्य र १५०० को दशकमा युरोपेली उपनिवेशीकरण सुरु हुनुअघि हजारौं वर्षदेखि उत्तर अमेरिकामा बस्थे।")
        ]),
        UnifiedQuestion(id: "q_08_060", correctAnswer: 3, variants: [
            .init(text: "What group of people was taken to America and sold as slaves?",
                  options: ["People from Asia", "People from Europe", "People from South America", "People from Africa"],
                  explanation: "Millions of Africans were forcibly brought to America from the 16th through 19th centuries and sold into slavery — one of the greatest injustices in history."),
            .init(text: "कुन समूहका मानिसहरूलाई अमेरिका ल्याएर दास बनाएर बेचिन्थ्यो?",
                  options: ["एसियाबाट आएका मानिसहरू", "युरोपबाट आएका मानिसहरू", "दक्षिण अमेरिकाबाट आएका मानिसहरू", "अफ्रिकाबाट आएका मानिसहरू"],
                  explanation: "१६औं देखि १९औं शताब्दीसम्म लाखौं अफ्रिकीहरूलाई जबरजस्ती अमेरिका ल्याइयो र दासत्वमा बेचिन्थ्यो — इतिहासको सबैभन्दा ठूला अन्यायहरूमध्ये एक।")
        ]),
    ]

    // MARK: - Practice Set 7: Colonial History & Independence (Q61–Q70)
    static let practice7: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_061", correctAnswer: 2, variants: [
            .init(text: "Why did the colonists fight the British?",
                  options: ["To gain more land in the Western territories", "They wanted to become part of Canada", "Because of high taxes and no self-government (taxation without representation)", "To protect themselves from Native American raids"],
                  explanation: "Key causes of the Revolution: taxation without representation, British troops quartered in colonists' homes, and colonists having no vote in British Parliament."),
            .init(text: "उपनिवेशवादीहरूले बेलायतीहरूसँग किन लडे?",
                  options: ["पश्चिमी भूभागमा थप जमिन पाउनका लागि", "उनीहरू क्यानडाको हिस्सा बन्न चाहन्थे", "उच्च कर र स्व-शासनको अभावले (प्रतिनिधित्वबिना कर)", "मूल निवासी अमेरिकीको आक्रमणबाट आफूलाई बचाउन"],
                  explanation: "क्रान्तिका मुख्य कारणहरू: प्रतिनिधित्वबिना कर, उपनिवेशवादीहरूका घरमा बेलायती सैनिकहरूको जबरजस्ती बसाइ र उपनिवेशवादीहरूको बेलायती संसदमा मत नहुनु।")
        ]),
        UnifiedQuestion(id: "q_08_062", correctAnswer: 2, variants: [
            .init(text: "Who wrote the Declaration of Independence?",
                  options: ["George Washington", "Benjamin Franklin", "Thomas Jefferson", "John Adams"],
                  explanation: "Thomas Jefferson was the principal author of the Declaration of Independence, adopted July 4, 1776. A committee including Franklin and Adams helped revise it."),
            .init(text: "स्वतन्त्रताको घोषणापत्र कसले लेखे?",
                  options: ["जर्ज वाशिङ्टन", "बेन्जामिन फ्र्याङ्कलिन", "थोमस जेफर्सन", "जोन एडम्स"],
                  explanation: "थोमस जेफर्सन जुलाई ४, १७७६ मा अपनाइएको स्वतन्त्रताको घोषणापत्रका मुख्य लेखक थिए। फ्र्याङ्कलिन र एडम्स सहितको समितिले यसलाई संशोधन गर्न मद्दत गर्यो।")
        ]),
        UnifiedQuestion(id: "q_08_063", correctAnswer: 0, variants: [
            .init(text: "When was the Declaration of Independence adopted?",
                  options: ["July 4, 1776", "September 17, 1787", "April 19, 1775", "March 4, 1789"],
                  explanation: "July 4, 1776 — now celebrated as Independence Day — is when the Continental Congress formally adopted the Declaration of Independence."),
            .init(text: "स्वतन्त्रताको घोषणापत्र कहिले अपनाइयो?",
                  options: ["जुलाई ४, १७७६", "सेप्टेम्बर १७, १७८७", "अप्रिल १९, १७७५", "मार्च ४, १७८९"],
                  explanation: "जुलाई ४, १७७६ — अहिले स्वतन्त्रता दिवसको रूपमा मनाइन्छ — जुन दिन कन्टिनेन्टल कांग्रेसले स्वतन्त्रताको घोषणापत्र औपचारिक रूपमा अपनायो।")
        ]),
        UnifiedQuestion(id: "q_08_064", correctAnswer: 2, variants: [
            .init(text: "There were 13 original states. Name three.",
                  options: ["Florida, Texas, and California", "Maine, Michigan, and Ohio", "Virginia, Pennsylvania, and New York", "Arizona, Nevada, and Utah"],
                  explanation: "The 13 original states: NH, MA, RI, CT, NY, NJ, PA, DE, MD, VA, NC, SC, and GA — all former British colonies that declared independence in 1776."),
            .init(text: "तेह्र मूल राज्यहरू थिए। तीनवटाको नाम लिनुहोस्।",
                  options: ["फ्लोरिडा, टेक्सस र क्यालिफोर्निया", "मेन, मिशिगन र ओहायो", "भर्जिनिया, पेन्सिल्भानिया र न्यू योर्क", "एरिजोना, नेभादा र युटाह"],
                  explanation: "१३ मूल राज्यहरू: NH, MA, RI, CT, NY, NJ, PA, DE, MD, VA, NC, SC र GA — सन् १७७६ मा स्वतन्त्रता घोषणा गर्ने सबै पूर्व बेलायती उपनिवेशहरू।")
        ]),
        UnifiedQuestion(id: "q_08_065", correctAnswer: 2, variants: [
            .init(text: "What happened at the Constitutional Convention?",
                  options: ["The Declaration of Independence was signed", "The Civil War ended", "The Constitution was written", "Slavery was abolished throughout the country"],
                  explanation: "The Constitutional Convention met in Philadelphia in 1787 where the Founding Fathers drafted the U.S. Constitution to replace the weak Articles of Confederation."),
            .init(text: "संवैधानिक सम्मेलनमा के भयो?",
                  options: ["स्वतन्त्रताको घोषणापत्रमा हस्ताक्षर भयो", "गृहयुद्ध समाप्त भयो", "संविधान लेखियो", "सम्पूर्ण देशमा दासप्रथा उन्मूलन गरियो"],
                  explanation: "संवैधानिक सम्मेलन सन् १७८७ मा फिलाडेल्फियामा भेला भयो जहाँ संस्थापक पिताहरूले कमजोर परिसंघका धाराहरूको ठाउँमा अमेरिकी संविधानको मस्यौदा तयार गरे।")
        ]),
        UnifiedQuestion(id: "q_08_066", correctAnswer: 2, variants: [
            .init(text: "When was the Constitution written?",
                  options: ["1776", "1781", "1787", "1791"],
                  explanation: "The Constitution was written at the Constitutional Convention in Philadelphia in 1787 and ratified by the required nine states in 1788."),
            .init(text: "संविधान कहिले लेखियो?",
                  options: ["१७७६", "१७८१", "१७८७", "१७९१"],
                  explanation: "संविधान सन् १७८७ मा फिलाडेल्फियाको संवैधानिक सम्मेलनमा लेखियो र सन् १७८८ मा आवश्यक नौ राज्यहरूद्वारा अनुमोदित भयो।")
        ]),
        UnifiedQuestion(id: "q_08_067", correctAnswer: 2, variants: [
            .init(text: "The Federalist Papers supported the passage of the U.S. Constitution. Name one of the writers.",
                  options: ["Thomas Jefferson", "John Adams", "Hamilton, Madison, or Jay (Publius)", "Benjamin Franklin"],
                  explanation: "The Federalist Papers were written by Alexander Hamilton, James Madison, and John Jay under the pen name 'Publius.' USCIS accepts any of their names."),
            .init(text: "फेडरलिस्ट पेपर्सले अमेरिकी संविधानको अनुमोदनलाई समर्थन गरेको थियो। एक लेखकको नाम बताउनुहोस्।",
                  options: ["थोमस जेफर्सन", "जोन एडम्स", "ह्यामिल्टन, म्याडिसन वा जे (Publius)", "बेन्जामिन फ्र्याङ्कलिन"],
                  explanation: "फेडरलिस्ट पेपर्स Alexander Hamilton, James Madison र John Jay ले 'Publius' नाममा लेखेका थिए। USCIS ले तिनीहरूमध्ये कुनै एकको नाम स्वीकार गर्दछ।")
        ]),
        UnifiedQuestion(id: "q_08_068", correctAnswer: 2, variants: [
            .init(text: "What is one thing Benjamin Franklin is famous for?",
                  options: ["Writing the Declaration of Independence", "Being the first President of the United States", "Being the first U.S. Postmaster General", "Leading the Union Army during the Civil War"],
                  explanation: "Benjamin Franklin was a diplomat, inventor (lightning rod, bifocals), writer (Poor Richard's Almanac), and the first Postmaster General. He was also the oldest delegate at the Constitutional Convention."),
            .init(text: "बेन्जामिन फ्र्याङ्कलिन केका लागि प्रसिद्ध छन्?",
                  options: ["स्वतन्त्रताको घोषणापत्र लेख्नु", "अमेरिकाका पहिलो राष्ट्रपति हुनु", "पहिलो अमेरिकी पोस्टमास्टर जनरल हुनु", "गृहयुद्धमा संघीय सेनाको नेतृत्व गर्नु"],
                  explanation: "बेन्जामिन फ्र्याङ्कलिन राजनयिक, आविष्कारक (विद्युत छड, बाइफोकल), लेखक (पुअर रिचार्डस् अल्मान्याक) र पहिलो पोस्टमास्टर जनरल थिए। उनी संवैधानिक सम्मेलनका सबैभन्दा उमेरदार प्रतिनिधि पनि थिए।")
        ]),
        UnifiedQuestion(id: "q_08_069", correctAnswer: 3, variants: [
            .init(text: "Who is the 'Father of Our Country'?",
                  options: ["Benjamin Franklin", "Thomas Jefferson", "John Adams", "George Washington"],
                  explanation: "George Washington is called the 'Father of Our Country' for commanding the Continental Army to victory in the Revolution and serving as the nation's first President."),
            .init(text: "राष्ट्रका जनक को हुन्?",
                  options: ["बेन्जामिन फ्र्याङ्कलिन", "थोमस जेफर्सन", "जोन एडम्स", "जर्ज वाशिङ्टन"],
                  explanation: "जर्ज वाशिङ्टनलाई क्रान्तिमा कन्टिनेन्टल सेनाको जयका लागि नेतृत्व गरेर र राष्ट्रका पहिलो राष्ट्रपतिको रूपमा सेवा गरेर 「राष्ट्रका जनक」 भनिन्छ।")
        ]),
        UnifiedQuestion(id: "q_08_070", correctAnswer: 3, variants: [
            .init(text: "Who was the first President?",
                  options: ["John Adams", "Thomas Jefferson", "Benjamin Franklin", "George Washington"],
                  explanation: "George Washington became the first President of the United States in 1789 and served two terms until 1797, setting important precedents for the office."),
            .init(text: "पहिलो राष्ट्रपति को थिए?",
                  options: ["जोन एडम्स", "थोमस जेफर्सन", "बेन्जामिन फ्र्याङ्कलिन", "जर्ज वाशिङ्टन"],
                  explanation: "जर्ज वाशिङ्टन सन् १७८९ मा अमेरिकाका पहिलो राष्ट्रपति बने र सन् १७९७ सम्म दुई कार्यकाल सेवा गरे, पदका लागि महत्त्वपूर्ण मिसाल कायम गरे।")
        ]),
    ]

    // MARK: - Practice Set 8: The 1800s & Civil War (Q71–Q80)
    static let practice8: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_071", correctAnswer: 3, variants: [
            .init(text: "What territory did the United States buy from France in 1803?",
                  options: ["Texas Territory", "Florida Territory", "Alaska Territory", "The Louisiana Territory"],
                  explanation: "The Louisiana Purchase (1803) nearly doubled the size of the U.S. — about 828,000 square miles purchased from Napoleon's France for approximately $15 million."),
            .init(text: "अमेरिकाले सन् १८०३ मा फ्रान्सबाट कुन भूभाग किन्यो?",
                  options: ["टेक्सस भूभाग", "फ्लोरिडा भूभाग", "अलास्का भूभाग", "लुइजियाना भूभाग"],
                  explanation: "लुइजियाना खरिद (१८०३) ले अमेरिकाको आकार लगभग दोब्बर गर्यो — नेपोलियनको फ्रान्सबाट लगभग १५ मिलियन डलरमा किनिएको लगभग ८२८,००० वर्ग माइल।")
        ]),
        UnifiedQuestion(id: "q_08_072", correctAnswer: 2, variants: [
            .init(text: "Name one war fought by the United States in the 1800s.",
                  options: ["World War I", "Korean War", "The Civil War", "Vietnam War"],
                  explanation: "U.S. wars in the 1800s: War of 1812, Mexican-American War (1846-48), Civil War (1861-65), and Spanish-American War (1898)."),
            .init(text: "अमेरिकाले १८०० को दशकमा लडेको एउटा युद्धको नाम लिनुहोस्।",
                  options: ["पहिलो विश्वयुद्ध", "कोरियाली युद्ध", "गृहयुद्ध", "भियतनाम युद्ध"],
                  explanation: "१८०० को दशकमा अमेरिकी युद्धहरू: १८१२ को युद्ध, मेक्सिकन-अमेरिकी युद्ध (१८४६-४८), गृहयुद्ध (१८६१-६५) र स्पेनी-अमेरिकी युद्ध (१८९८)।")
        ]),
        UnifiedQuestion(id: "q_08_073", correctAnswer: 2, variants: [
            .init(text: "Name the U.S. war between the North and the South.",
                  options: ["The Revolutionary War", "The War of 1812", "The Civil War", "The Spanish-American War"],
                  explanation: "The Civil War (1861-1865) was fought between the Northern states (Union) and Southern states (Confederacy) primarily over slavery, states' rights, and economic differences."),
            .init(text: "उत्तर र दक्षिणबीचको अमेरिकी युद्धको नाम बताउनुहोस्।",
                  options: ["क्रान्तिकारी युद्ध", "१८१२ को युद्ध", "गृहयुद्ध", "स्पेनी-अमेरिकी युद्ध"],
                  explanation: "गृहयुद्ध (१८६१-१८६५) उत्तरी राज्यहरू (संघ) र दक्षिणी राज्यहरू (परिसंघ) बीच मुख्यतया दासप्रथा, राज्य अधिकार र आर्थिक मतभेदलाई लिएर लडिएको थियो।")
        ]),
        UnifiedQuestion(id: "q_08_074", correctAnswer: 2, variants: [
            .init(text: "Name one problem that led to the Civil War.",
                  options: ["A dispute solely about tariffs", "A foreign invasion of U.S. territory", "Slavery", "A conflict over the Constitution's legality"],
                  explanation: "The Civil War's causes included slavery, economic differences between the industrialized North and agricultural South, and fierce debates over states' rights."),
            .init(text: "गृहयुद्धतर्फ लैजाने एउटा समस्याको नाम लिनुहोस्।",
                  options: ["केवल महसुलसम्बन्धी विवाद", "अमेरिकी भूभागमा विदेशी आक्रमण", "दासप्रथा", "संविधानको वैधतासम्बन्धी विवाद"],
                  explanation: "गृहयुद्धका कारणहरूमा दासप्रथा, औद्योगिक उत्तर र कृषि दक्षिणबीचको आर्थिक मतभेद र राज्य अधिकारबारे कडा बहसहरू समावेश थिए।")
        ]),
        UnifiedQuestion(id: "q_08_075", correctAnswer: 2, variants: [
            .init(text: "What was one important thing that Abraham Lincoln did?",
                  options: ["Wrote the U.S. Constitution", "Won the Spanish-American War", "Freed the slaves (Emancipation Proclamation)", "Purchased Alaska from Russia"],
                  explanation: "Lincoln issued the Emancipation Proclamation (1863), freeing enslaved people in Confederate states. He also preserved the Union and led the U.S. through the Civil War."),
            .init(text: "अब्राहम लिंकनले गरेको एउटा महत्त्वपूर्ण कार्य के थियो?",
                  options: ["अमेरिकी संविधान लेखे", "स्पेनी-अमेरिकी युद्ध जिते", "दासहरूलाई मुक्त गरे (मुक्ति घोषणापत्र)", "रुसबाट अलास्का किने"],
                  explanation: "लिंकनले मुक्ति घोषणापत्र (१८६३) जारी गरे, परिसंघीय राज्यहरूमा दासत्वमा रहेका मानिसहरूलाई मुक्त गरे। उनले संघलाई पनि एकजुट राखे र गृहयुद्धमा अमेरिकाको नेतृत्व गरे।")
        ]),
        UnifiedQuestion(id: "q_08_076", correctAnswer: 2, variants: [
            .init(text: "What did the Emancipation Proclamation do?",
                  options: ["Officially ended the Civil War", "Gave women the right to vote", "Freed the slaves in Confederate states", "Created the Republican Party"],
                  explanation: "The Emancipation Proclamation (January 1, 1863) declared all enslaved people in Confederate states to be free, transforming the war into a fight to end slavery."),
            .init(text: "मुक्ति घोषणापत्रले के गर्यो?",
                  options: ["आधिकारिक रूपमा गृहयुद्ध समाप्त गर्यो", "महिलाहरूलाई मताधिकार दियो", "परिसंघीय राज्यहरूका दासहरूलाई मुक्त गर्यो", "रिपब्लिकन पार्टी स्थापना गर्यो"],
                  explanation: "मुक्ति घोषणापत्र (जनवरी १, १८६३) ले परिसंघीय राज्यहरूमा दासत्वमा रहेका सबै मानिसहरूलाई स्वतन्त्र घोषणा गर्यो, जसले युद्धलाई दासप्रथा अन्त्य गर्ने लडाइँमा परिणत गर्यो।")
        ]),
        UnifiedQuestion(id: "q_08_077", correctAnswer: 3, variants: [
            .init(text: "What did Susan B. Anthony do?",
                  options: ["Led the Underground Railroad to free enslaved people", "Wrote the Emancipation Proclamation", "Was the first woman elected to the U.S. Congress", "Fought for women's rights and civil rights"],
                  explanation: "Susan B. Anthony was a leading suffragist who campaigned tirelessly for women's right to vote. The 19th Amendment (1920) is sometimes called the 'Susan B. Anthony Amendment.'"),
            .init(text: "सुसन बी. एन्थोनीले के गरिन्?",
                  options: ["दासहरूलाई मुक्त गर्न अन्डरग्राउन्ड रेलरोडको नेतृत्व गरिन्", "मुक्ति घोषणापत्र लेखिन्", "अमेरिकी कांग्रेसमा चुनिएकी पहिलो महिला थिइन्", "महिला अधिकार र नागरिक अधिकारका लागि लडिन्"],
                  explanation: "सुसन बी. एन्थोनी एक प्रमुख मताधिकारवादी थिइन् जसले महिलाहरूको मत दिने अधिकारका लागि अथक अभियान चलाइन्। १९औं संशोधन (१९२०) लाई कहिलेकाहीँ 「सुसन बी. एन्थोनी संशोधन」 भनिन्छ।")
        ]),
        UnifiedQuestion(id: "q_08_078", correctAnswer: 3, variants: [
            .init(text: "Name one war fought by the United States in the 1900s.",
                  options: ["The Civil War", "The Revolutionary War", "The War of 1812", "World War I"],
                  explanation: "U.S. wars in the 1900s: WWI (1917-18), WWII (1941-45), Korean War (1950-53), Vietnam War (1964-75), and Persian Gulf War (1991)."),
            .init(text: "अमेरिकाले १९०० को दशकमा लडेको एउटा युद्धको नाम लिनुहोस्।",
                  options: ["गृहयुद्ध", "क्रान्तिकारी युद्ध", "१८१२ को युद्ध", "पहिलो विश्वयुद्ध"],
                  explanation: "१९०० को दशकमा अमेरिकी युद्धहरू: पहिलो विश्वयुद्ध (१९१७-१८), दोस्रो विश्वयुद्ध (१९४१-४५), कोरियाली युद्ध (१९५०-५३), भियतनाम युद्ध (१९६४-७५) र फारसी खाडी युद्ध (१९९१)।")
        ]),
        UnifiedQuestion(id: "q_08_079", correctAnswer: 2, variants: [
            .init(text: "Who was President during World War I?",
                  options: ["Theodore Roosevelt", "Abraham Lincoln", "Woodrow Wilson", "Franklin Roosevelt"],
                  explanation: "Woodrow Wilson was the 28th President. He led the United States through World War I (1917–1918) and proposed the League of Nations to maintain world peace after the war."),
            .init(text: "पहिलो विश्वयुद्धको समयमा अमेरिकाको राष्ट्रपति को थिए?",
                  options: ["थियोडोर रुजभेल्ट", "अब्राहम लिंकन", "वुडरो विल्सन", "फ्र्याङ्कलिन रुजभेल्ट"],
                  explanation: "वुडरो विल्सन २८ औं राष्ट्रपति थिए। उनले पहिलो विश्वयुद्ध (१९१७–१९१८) को समयमा अमेरिकाको नेतृत्व गरे र युद्धपछि विश्व शान्ति कायम राख्न लिग अफ नेसन्सको प्रस्ताव गरे।")
        ]),
        UnifiedQuestion(id: "q_08_080", correctAnswer: 3, variants: [
            .init(text: "Who was President during the Great Depression and World War II?",
                  options: ["Herbert Hoover", "Calvin Coolidge", "Harry Truman", "Franklin Roosevelt"],
                  explanation: "Franklin D. Roosevelt (FDR), the 32nd President, led the nation through both the Great Depression and World War II. He served four terms — the most of any President."),
            .init(text: "महामन्दी र दोस्रो विश्वयुद्धको समयमा राष्ट्रपति को थिए?",
                  options: ["हर्बर्ट हुभर", "क्यालभिन कुलिज", "ह्यारी ट्रुम्यान", "फ्र्याङ्कलिन रुजभेल्ट"],
                  explanation: "फ्र्याङ्कलिन डी. रुजभेल्ट (FDR), ३२ औं राष्ट्रपति, महामन्दी र दोस्रो विश्वयुद्ध दुवैमा देशको नेतृत्व गरे। उनी चार पटक निर्वाचित भए — कुनै पनि राष्ट्रपतिभन्दा बढी।")
        ]),
    ]

    // MARK: - Practice Set 9: 20th Century History & U.S. Geography (Q81–Q90)
    static let practice9: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_081", correctAnswer: 2, variants: [
            .init(text: "Who did the United States fight in World War II?",
                  options: ["Germany, Russia, and China", "Japan, France, and Italy", "Japan, Germany, and Italy", "Britain, France, and Germany"],
                  explanation: "The U.S. fought the Axis Powers: Japan, Germany, and Italy. The U.S. entered WWII after Japan's attack on Pearl Harbor, Hawaii, on December 7, 1941."),
            .init(text: "संयुक्त राज्यले दोस्रो विश्वयुद्धमा कोसँग लडेको थियो?",
                  options: ["जर्मनी, रुस र चीन", "जापान, फ्रान्स र इटाली", "जापान, जर्मनी र इटाली", "बेलायत, फ्रान्स र जर्मनी"],
                  explanation: "अमेरिकाले अक्ष शक्तिहरूसँग लड्यो: जापान, जर्मनी र इटाली। डिसेम्बर ७, १९४१ मा जापानले हवाईको पर्ल हार्बरमा आक्रमण गरेपछि अमेरिका दोस्रो विश्वयुद्धमा सामेल भयो।")
        ]),
        UnifiedQuestion(id: "q_08_082", correctAnswer: 1, variants: [
            .init(text: "Before he was President, Eisenhower was a general. What war was he in?",
                  options: ["World War I", "World War II", "Korean War", "Vietnam War"],
                  explanation: "Dwight D. Eisenhower served as Supreme Commander of Allied Forces in Europe during WWII. He later became the 34th President, serving from 1953 to 1961."),
            .init(text: "राष्ट्रपति बन्नुअघि आइजनहावर जनरल थिए। कुन युद्धमा?",
                  options: ["पहिलो विश्वयुद्ध", "दोस्रो विश्वयुद्ध", "कोरियाली युद्ध", "भियतनाम युद्ध"],
                  explanation: "ड्वाइट डी. आइजनहावरले दोस्रो विश्वयुद्धमा युरोपमा मित्र राष्ट्रका बलका सर्वोच्च कमाण्डरको रूपमा सेवा गरे। उनी पछि ३४औं राष्ट्रपति बने, सन् १९५३ देखि १९६१ सम्म सेवा गरे।")
        ]),
        UnifiedQuestion(id: "q_08_083", correctAnswer: 3, variants: [
            .init(text: "During the Cold War, what was the main concern of the United States?",
                  options: ["Economic recession and unemployment", "Climate change and pollution", "Illegal immigration", "Communism / the spread of communism and nuclear war"],
                  explanation: "The Cold War (1947-1991) was a global ideological conflict between the democratic U.S. and communist Soviet Union, centered on nuclear weapons, arms races, and spreading influence."),
            .init(text: "शीतयुद्धको समयमा अमेरिकाको मुख्य चिन्ता के थियो?",
                  options: ["आर्थिक मन्दी र बेरोजगारी", "जलवायु परिवर्तन र प्रदूषण", "अवैध आप्रवासन", "साम्यवाद / साम्यवादको फैलावट र परमाणु युद्ध"],
                  explanation: "शीतयुद्ध (१९४७-१९९१) लोकतान्त्रिक अमेरिका र साम्यवादी सोभियत संघबीचको विश्वव्यापी वैचारिक संघर्ष थियो, जुन परमाणु हतियार, हतियार दौड र प्रभाव फैलाउनेमा केन्द्रित थियो।")
        ]),
        UnifiedQuestion(id: "q_08_084", correctAnswer: 2, variants: [
            .init(text: "What movement tried to end racial discrimination?",
                  options: ["The Temperance Movement", "The Labor Movement", "The Civil Rights Movement", "The Women's Suffrage Movement"],
                  explanation: "The Civil Rights Movement of the 1950s-1960s fought to end racial segregation and discrimination, resulting in landmark laws like the Civil Rights Act of 1964 and Voting Rights Act of 1965."),
            .init(text: "कुन आन्दोलनले जातीय भेदभाव अन्त्य गर्न खोज्यो?",
                  options: ["संयम आन्दोलन", "श्रम आन्दोलन", "नागरिक अधिकार आन्दोलन", "महिला मताधिकार आन्दोलन"],
                  explanation: "१९५० र १९६० को दशकको नागरिक अधिकार आन्दोलनले जातीय अलगाव र भेदभाव अन्त्य गर्न लड्यो, जसले १९६४ को नागरिक अधिकार ऐन र १९६५ को मतदान अधिकार ऐन जस्ता ऐतिहासिक कानुनहरू ल्यायो।")
        ]),
        UnifiedQuestion(id: "q_08_085", correctAnswer: 2, variants: [
            .init(text: "What did Martin Luther King, Jr. do?",
                  options: ["Led the Underground Railroad to free enslaved people", "Served as the first Black President of the NAACP", "Fought for civil rights and equality for all Americans", "Wrote the Civil Rights Act of 1964"],
                  explanation: "Dr. Martin Luther King, Jr. was the most prominent leader of the Civil Rights Movement, advocating nonviolent protest. He received the Nobel Peace Prize in 1964."),
            .init(text: "मार्टिन लुथर किङ जुनियरले के गरे?",
                  options: ["दासहरूलाई मुक्त गर्न अन्डरग्राउन्ड रेलरोडको नेतृत्व गरे", "NAACP का पहिलो अश्वेत अध्यक्ष भए", "सबै अमेरिकीहरूका लागि नागरिक अधिकार र समानताका लागि लडे", "१९६४ को नागरिक अधिकार ऐन लेखे"],
                  explanation: "डा. मार्टिन लुथर किङ जुनियर नागरिक अधिकार आन्दोलनका सबैभन्दा प्रमुख नेता थिए, जसले अहिंसात्मक विरोधको वकालत गरे। उनले सन् १९६४ मा नोबेल शान्ति पुरस्कार पाए।")
        ]),
        UnifiedQuestion(id: "q_08_086", correctAnswer: 2, variants: [
            .init(text: "What major event happened on September 11, 2001, in the United States?",
                  options: ["A major hurricane struck the East Coast", "A financial crisis closed the stock market", "Terrorists attacked the United States", "The United States declared war on Iraq"],
                  explanation: "On September 11, 2001, al-Qaeda terrorists hijacked four planes and attacked the World Trade Center (New York) and the Pentagon (Virginia). Nearly 3,000 people were killed."),
            .init(text: "सन् २००१ को सेप्टेम्बर ११ मा अमेरिकामा कुन ठूलो घटना भयो?",
                  options: ["पूर्वी तटमा ठूलो आँधी आयो", "वित्तीय संकटले सेयर बजार बन्द भयो", "आतंकवादीहरूले अमेरिकामाथि आक्रमण गरे", "अमेरिकाले इराकविरुद्ध युद्ध घोषणा गर्‍यो"],
                  explanation: "सन् २००१ को सेप्टेम्बर ११ मा, अल-कायदाका आतंकवादीहरूले चारवटा विमान अपहरण गरी न्यूयोर्कको वर्ल्ड ट्रेड सेन्टर र भर्जिनियाको पेन्टागनमा आक्रमण गरे। करिब ३,००० मानिसहरू मारिए।")
        ]),
        UnifiedQuestion(id: "q_08_087", correctAnswer: 3, variants: [
            .init(text: "Name one American Indian tribe in the United States.",
                  options: ["Aztec", "Maya", "Inca", "Cherokee or Navajo"],
                  explanation: "USCIS accepts many tribes: Cherokee, Navajo, Sioux, Chippewa, Choctaw, Pueblo, Apache, Iroquois, Creek, Blackfeet, Seminole, Cheyenne, Shawnee, Lakota, Crow, Hopi, Inuit, and others."),
            .init(text: "संयुक्त राज्य अमेरिकामा एउटा अमेरिकन इन्डियन जनजातिको नाम बताउनुहोस्।",
                  options: ["Aztec", "Maya", "Inca", "Cherokee वा Navajo"],
                  explanation: "USCIS ले धेरै जनजातिहरू स्वीकार गर्दछ: Cherokee, Navajo, Sioux, Chippewa, Choctaw, Pueblo, Apache, Iroquois, Creek, Blackfeet, Seminole, Cheyenne, Shawnee, Lakota, Crow, Hopi, Inuit र अन्य। (Aztec/Maya/Inca ल्याटिन अमेरिकी हुन्, अमेरिकी होइनन्।)")
        ]),
        UnifiedQuestion(id: "q_08_088", correctAnswer: 2, variants: [
            .init(text: "Name one of the two longest rivers in the United States.",
                  options: ["The Colorado River or the Rio Grande", "The Ohio River or the Columbia River", "The Missouri River or the Mississippi River", "The Hudson River or the Tennessee River"],
                  explanation: "The Missouri River (~2,341 miles) and Mississippi River (~2,340 miles) are the two longest rivers in the United States. The Mississippi drains the central U.S. into the Gulf of Mexico."),
            .init(text: "अमेरिकाका दुई सबैभन्दा लामा नदीहरूमध्ये एउटाको नाम लिनुहोस्।",
                  options: ["कोलोराडो नदी वा रिओ ग्रान्डे", "ओहायो नदी वा कोलम्बिया नदी", "मिसुरी नदी वा मिसिसिपी नदी", "हडसन नदी वा टेनेसी नदी"],
                  explanation: "मिसुरी नदी (लगभग २,३४१ माइल) र मिसिसिपी नदी (लगभग २,३४० माइल) अमेरिकाका दुई सबैभन्दा लामा नदीहरू हुन्। मिसिसिपीले केन्द्रीय अमेरिकाको पानी मेक्सिकोको खाडीमा बगाउँछ।")
        ]),
        UnifiedQuestion(id: "q_08_089", correctAnswer: 3, variants: [
            .init(text: "What ocean is on the West Coast of the United States?",
                  options: ["Atlantic Ocean", "Indian Ocean", "Arctic Ocean", "Pacific Ocean"],
                  explanation: "The Pacific Ocean borders the West Coast of the United States, including California, Oregon, Washington, and Alaska. It is the world's largest ocean."),
            .init(text: "अमेरिकाको पश्चिमी तटमा कुन महासागर छ?",
                  options: ["अटलान्टिक महासागर", "हिन्द महासागर", "आर्कटिक महासागर", "प्रशान्त महासागर"],
                  explanation: "प्रशान्त महासागर क्यालिफोर्निया, ओरेगन, वाशिङ्टन र अलास्का सहित अमेरिकाको पश्चिमी तटमा सिमाना बनाउँछ। यो विश्वको सबैभन्दा ठूलो महासागर हो।")
        ]),
        UnifiedQuestion(id: "q_08_090", correctAnswer: 2, variants: [
            .init(text: "What ocean is on the East Coast of the United States?",
                  options: ["Pacific Ocean", "Indian Ocean", "Atlantic Ocean", "Arctic Ocean"],
                  explanation: "The Atlantic Ocean borders the East Coast of the United States, from Maine down to Florida. The early colonists crossed the Atlantic to reach America from Europe."),
            .init(text: "अमेरिकाको पूर्वी तटमा कुन महासागर छ?",
                  options: ["प्रशान्त महासागर", "हिन्द महासागर", "अटलान्टिक महासागर", "आर्कटिक महासागर"],
                  explanation: "अटलान्टिक महासागर मेनदेखि फ्लोरिडासम्म अमेरिकाको पूर्वी तटमा सिमाना बनाउँछ। प्रारम्भिक उपनिवेशवादीहरूले युरोपबाट अमेरिका पुग्न अटलान्टिक पार गरे।")
        ]),
    ]

    // MARK: - Practice Set 10: Geography, Symbols & Holidays (Q91–Q100)
    static let practice10: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_091", correctAnswer: 1, variants: [
            .init(text: "Name one U.S. territory.",
                  options: ["Cuba", "Puerto Rico", "Dominican Republic", "Philippines"],
                  explanation: "U.S. territories include Puerto Rico, U.S. Virgin Islands, American Samoa, Guam, and the Northern Mariana Islands. Residents are U.S. nationals; Puerto Ricans are U.S. citizens."),
            .init(text: "अमेरिकाको एउटा क्षेत्र (टेरिटरी) को नाम लिनुहोस्।",
                  options: ["क्युबा", "पुएर्टो रिको", "डोमिनिकन गणतन्त्र", "फिलिपिन्स"],
                  explanation: "अमेरिकी क्षेत्रहरूमा पुएर्टो रिको, अमेरिकी भर्जिन आइल्याण्ड्स, अमेरिकी सामोआ, गुआम र उत्तरी मारियाना आइल्याण्ड्स समावेश छन्। यी क्षेत्रका बासिन्दाहरू अमेरिकी राष्ट्रिक (नेसनल) हुन्; पुएर्टो रिकोका बासिन्दाहरू अमेरिकी नागरिक हुन्।")
        ]),
        UnifiedQuestion(id: "q_08_092", correctAnswer: 3, variants: [
            .init(text: "Name one state that borders Canada.",
                  options: ["California", "Florida", "Texas", "Minnesota"],
                  explanation: "States bordering Canada: Maine, New Hampshire, Vermont, New York, Pennsylvania, Ohio, Michigan, Minnesota, North Dakota, Montana, Idaho, Washington, and Alaska."),
            .init(text: "क्यानडासँग सिमाना लाग्ने एउटा राज्यको नाम लिनुहोस्।",
                  options: ["क्यालिफोर्निया", "फ्लोरिडा", "टेक्सस", "मिनेसोटा"],
                  explanation: "क्यानडासँग सिमाना लाग्ने राज्यहरू: मेन, न्यू ह्याम्पशायर, भर्मन्ट, न्यू योर्क, पेन्सिल्भानिया, ओहायो, मिशिगन, मिनेसोटा, नर्थ डाकोटा, मोन्टाना, इडाहो, वाशिङ्टन र अलास्का।")
        ]),
        UnifiedQuestion(id: "q_08_093", correctAnswer: 3, variants: [
            .init(text: "Name one state that borders Mexico.",
                  options: ["Florida", "Louisiana", "Nevada", "Texas"],
                  explanation: "Four states share a border with Mexico: California, Arizona, New Mexico, and Texas. The U.S.-Mexico border stretches nearly 2,000 miles."),
            .init(text: "मेक्सिकोसँग सिमाना लाग्ने एउटा राज्यको नाम लिनुहोस्।",
                  options: ["फ्लोरिडा", "लुइजियाना", "नेभादा", "टेक्सस"],
                  explanation: "चार राज्यहरूले मेक्सिकोसँग सिमाना साझा गर्छन्: क्यालिफोर्निया, एरिजोना, न्यू मेक्सिको र टेक्सस। अमेरिका-मेक्सिको सिमाना लगभग २,००० माइल फैलिएको छ।")
        ]),
        UnifiedQuestion(id: "q_08_094", correctAnswer: 3, variants: [
            .init(text: "What is the capital of the United States?",
                  options: ["New York City", "Los Angeles", "Chicago", "Washington, D.C."],
                  explanation: "Washington, D.C. (District of Columbia) has been the nation's capital since 1800. It is not part of any state and was named after President George Washington."),
            .init(text: "संयुक्त राज्यको राजधानी कहाँ हो?",
                  options: ["न्यू योर्क सिटी", "लस एन्जेलस", "शिकागो", "वाशिङ्टन, डी.सी."],
                  explanation: "वाशिङ्टन, डी.सी. (कोलम्बिया जिल्ला) सन् १८०० देखि राष्ट्रको राजधानी हो। यो कुनै राज्यको हिस्सा होइन र राष्ट्रपति जर्ज वाशिङ्टनको नाममा राखिएको छ।")
        ]),
        UnifiedQuestion(id: "q_08_095", correctAnswer: 2, variants: [
            .init(text: "Where is the Statue of Liberty?",
                  options: ["Philadelphia, Pennsylvania", "Boston, Massachusetts", "New York (Harbor) / Liberty Island", "Washington, D.C."],
                  explanation: "The Statue of Liberty stands on Liberty Island in New York Harbor. A gift from France, it was dedicated in 1886 and symbolizes freedom and democracy."),
            .init(text: "स्वतन्त्रताको प्रतिमा कहाँ छ?",
                  options: ["फिलाडेल्फिया, पेन्सिल्भानिया", "बोस्टन, म्यासाचुसेट्स", "न्यू योर्क (बन्दरगाह) / लिबर्टी आइल्याण्ड", "वाशिङ्टन, डी.सी."],
                  explanation: "स्वतन्त्रताको प्रतिमा न्यू योर्क बन्दरगाहमा लिबर्टी आइल्याण्डमा उभिएको छ। फ्रान्सबाट उपहार, यसलाई सन् १८८६ मा समर्पण गरिएको थियो र यो स्वतन्त्रता र लोकतन्त्रको प्रतीक हो।")
        ]),
        UnifiedQuestion(id: "q_08_096", correctAnswer: 2, variants: [
            .init(text: "Why does the flag have 13 stripes?",
                  options: ["For the 13 presidents who served before Lincoln", "For the 13 amendments that form the Bill of Rights", "Because there were 13 original colonies", "For the 13 original Supreme Court justices"],
                  explanation: "The 13 alternating red and white stripes represent the original 13 colonies that declared independence from Britain and became the nation's first 13 states."),
            .init(text: "झण्डामा १३ धारा किन छन्?",
                  options: ["लिंकनअघि सेवा गरेका १३ राष्ट्रपतिका लागि", "अधिकारको विधेयकका १३ संशोधनका लागि", "किनभने १३ मूल उपनिवेशहरू थिए", "मूल १३ सर्वोच्च अदालतका न्यायाधीशहरूका लागि"],
                  explanation: "एकान्तरे रातो र सेतो १३ धाराहरूले बेलायतबाट स्वतन्त्रता घोषणा गरेका र राष्ट्रका पहिलो १३ राज्यहरू बनेका मूल १३ उपनिवेशहरूको प्रतिनिधित्व गर्छन्।")
        ]),
        UnifiedQuestion(id: "q_08_097", correctAnswer: 3, variants: [
            .init(text: "Why does the flag have 50 stars?",
                  options: ["For the 50 largest U.S. cities", "For the 50 years since independence", "For the 50 most important federal laws", "Because there is one star for each state"],
                  explanation: "Each of the 50 stars represents one U.S. state. The current 50-star flag was adopted on July 4, 1960, after Hawaii became the 50th state in 1959."),
            .init(text: "झण्डामा ५० तारा किन छन्?",
                  options: ["अमेरिकाका ५० सबैभन्दा ठूला शहरहरूका लागि", "स्वतन्त्रताका ५० वर्षका लागि", "५० सबैभन्दा महत्त्वपूर्ण संघीय कानुनहरूका लागि", "किनभने प्रत्येक राज्यको एउटा तारा हो"],
                  explanation: "५० ताराहरूमध्ये प्रत्येकले एउटा अमेरिकी राज्यको प्रतिनिधित्व गर्छ। हालको ५०-तारे झण्डा जुलाई ४, १९६० मा अपनाइएको थियो, सन् १९५९ मा हवाई ५०औं राज्य बनेपछि।")
        ]),
        UnifiedQuestion(id: "q_08_098", correctAnswer: 3, variants: [
            .init(text: "What is the name of the national anthem?",
                  options: ["America the Beautiful", "God Bless America", "My Country, 'Tis of Thee", "The Star-Spangled Banner"],
                  explanation: "'The Star-Spangled Banner,' written by Francis Scott Key during the War of 1812, was officially designated the national anthem by Congress in 1931."),
            .init(text: "राष्ट्रिय गानको नाम के हो?",
                  options: ["अमेरिका द ब्युटिफुल", "गड ब्लेस अमेरिका", "माय कन्ट्री, टिस अफ थी", "द स्टार-स्प्याङ्गल्ड ब्यानर"],
                  explanation: "१८१२ को युद्धको समयमा फ्रान्सिस स्कट कीले लेखेको 「द स्टार-स्प्याङ्गल्ड ब्यानर」 लाई सन् १९३१ मा कांग्रेसद्वारा आधिकारिक रूपमा राष्ट्रिय गान घोषणा गरियो।")
        ]),
        UnifiedQuestion(id: "q_08_099", correctAnswer: 1, variants: [
            .init(text: "When do we celebrate Independence Day?",
                  options: ["July 1", "July 4", "September 4", "October 31"],
                  explanation: "Independence Day (July 4th) celebrates the adoption of the Declaration of Independence on July 4, 1776 — the birth of the United States as a nation."),
            .init(text: "स्वतन्त्रता दिवस कहिले मनाउँछौं?",
                  options: ["जुलाई १", "जुलाई ४", "सेप्टेम्बर ४", "अक्टोबर ३१"],
                  explanation: "स्वतन्त्रता दिवस (जुलाई ४) जुलाई ४, १७७६ मा स्वतन्त्रताको घोषणापत्रको अपनाइलाई मनाउँछ — एक राष्ट्रको रूपमा संयुक्त राज्यको जन्म।")
        ]),
        UnifiedQuestion(id: "q_08_100", correctAnswer: 1, variants: [
            .init(text: "Name two national U.S. holidays.",
                  options: ["Valentine's Day and Easter", "Independence Day and Thanksgiving", "Hanukkah and Kwanzaa", "New Year's Eve and April Fool's Day"],
                  explanation: "Federal holidays include New Year's Day, MLK Day, Presidents' Day, Memorial Day, Independence Day, Labor Day, Columbus Day, Veterans Day, Thanksgiving, and Christmas."),
            .init(text: "दुई राष्ट्रिय अमेरिकी बिदाहरूको नाम लिनुहोस्।",
                  options: ["भ्यालेन्टाइन्स डे र इस्टर", "स्वतन्त्रता दिवस र थान्क्सगिभिङ", "हनुका र क्वान्जा", "नयाँ वर्षको साँझ र अप्रिल फुल्स डे"],
                  explanation: "संघीय बिदाहरूमा नयाँ वर्ष दिवस, MLK दिवस, राष्ट्रपति दिवस, स्मृति दिवस, स्वतन्त्रता दिवस, श्रम दिवस, कोलम्बस दिवस, भूतपूर्व सैनिक दिवस, थान्क्सगिभिङ र क्रिसमस समावेश छन्।")
        ]),
    ]
}
