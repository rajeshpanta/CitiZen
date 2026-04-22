import Foundation

/// All Nepali (English ↔ Nepali) quiz question sets.
/// Each question has 2 variants: [English, Nepali].
enum NepaliQuestions {

    // MARK: - Practice 1

    static let practice1: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_1_01", correctAnswer: 2, variants: [
            .init(text: "What is the supreme law of the land?", options: ["The Bill of Rights", "The Declaration", "The Constitution", "The Articles"]),
            .init(text: "देशको सर्वोच्च कानुन के हो?", options: ["अधिकारको विधेयक", "घोषणा", "संविधान", "लेखहरू"])
        ]),
        UnifiedQuestion(id: "q_1_02", correctAnswer: 1, variants: [
            .init(text: "Who makes federal laws?", options: ["The President", "Congress", "The Supreme Court", "The Military"]),
            .init(text: "संघीय कानूनहरू को बनाउँछ?", options: ["राष्ट्रपति", "कांग्रेस", "सर्वोच्च अदालत", "सैन्य"])
        ]),
        UnifiedQuestion(id: "q_1_03", correctAnswer: 0, variants: [
            .init(text: "What are the two parts of the U.S. Congress?", options: ["The Senate & The House", "The House & The President", "The Senate & The Cabinet", "The Military & The President"]),
            .init(text: "अमेरिकी काँग्रेसका दुई भागहरू कुन-कुन हुन्?", options: ["सेनेट र प्रतिनिधि सभा", "प्रतिनिधि सभा र राष्ट्रपति", "सेनेट र मन्त्रिपरिषद", "सैन्य र राष्ट्रपति"])
        ]),
        UnifiedQuestion(id: "q_1_04", correctAnswer: 1, variants: [
            .init(text: "What is the capital of the United States?", options: ["New York", "Washington D.C.", "Los Angeles", "Chicago"]),
            .init(text: "संयुक्त राज्य अमेरिकाको राजधानी के हो?", options: ["न्यूयोर्क", "वाशिङ्टन डी.सी.", "लस एन्जलस", "शिकागो"])
        ]),
        UnifiedQuestion(id: "q_1_05", correctAnswer: 3, variants: [
            .init(text: "What are the two major political parties?", options: ["Democrats & Libertarian", "Federalists & Republicans", "Libertarian & Tories", "Democrats & Republicans"]),
            .init(text: "दुई प्रमुख राजनीतिक दलहरू कुन-कुन हुन्?", options: ["डेमोक्र्याट्स र लिबर्टेरियन", "फेडेरलिस्ट्स र रिपब्लिकनहरू", "लिबर्टेरियन र टोरीहरू", "डेमोक्र्याट्स र रिपब्लिकनहरू"])
        ]),
        UnifiedQuestion(id: "q_1_06", correctAnswer: 1, variants: [
            .init(text: "What color are the stars on the American flag?", options: ["Blue", "White", "Red", "Yellow"]),
            .init(text: "अमेरिकी झण्डाका ताराहरू कुन रंगका हुन्छन्?", options: ["नीलो", "सेतो", "रातो", "पहेंलो"])
        ]),
        UnifiedQuestion(id: "q_1_07", correctAnswer: 3, variants: [
            .init(text: "How many states are there in the United States?", options: ["51", "49", "52", "50"]),
            .init(text: "संयुक्त राज्य अमेरिकामा कति वटा राज्यहरू छन्?", options: ["५१", "४९", "५२", "५०"])
        ]),
        UnifiedQuestion(id: "q_1_08", correctAnswer: 3, variants: [
            .init(text: "What is the name of the President of the United States?", options: ["Joe Biden", "George Bush", "Barack Obama", "Donald J. Trump"]),
            .init(text: "संयुक्त राज्य अमेरिकाका राष्ट्रपति को हुन्?", options: ["जो बाइडेन", "जर्ज बुश", "बराक ओबामा", "डोनाल्ड जे. ट्रम्प"])
        ]),
        UnifiedQuestion(id: "q_1_09", correctAnswer: 3, variants: [
            .init(text: "What is the name of the Vice President of the United States?", options: ["Kamala Harris", "Mike Pence", "Nancy Pelosi", "JD Vance"]),
            .init(text: "संयुक्त राज्य अमेरिकाका उपराष्ट्रपति को हुन्?", options: ["कमला ह्यारिस", "माइक पेन्स", "न्यान्सी पेलोसी", "जेडि भेन्स"])
        ]),
        UnifiedQuestion(id: "q_1_10", correctAnswer: 2, variants: [
            .init(text: "What is one right in the First Amendment?", options: ["Freedom to travel", "Right to vote", "Freedom of speech", "Right to education"]),
            .init(text: "प्रथम संशोधनमा रहेको एउटा अधिकार के हो?", options: ["यात्रा गर्ने स्वतन्त्रता", "मतदान गर्ने अधिकार", "बोल्ने स्वतन्त्रता", "शिक्षा प्राप्त गर्ने अधिकार"])
        ]),
        UnifiedQuestion(id: "q_1_11", correctAnswer: 1, variants: [
            .init(text: "What do we celebrate on July 4th?", options: ["Memorial Day", "Independence Day", "Labor Day", "Thanksgiving"]),
            .init(text: "हामी जुलाई ४ मा के मनाउँछौं?", options: ["स्मृति दिवस", "स्वतन्त्रता दिवस", "श्रम दिवस", "धन्यबाद दिवस"])
        ]),
        UnifiedQuestion(id: "q_1_12", correctAnswer: 0, variants: [
            .init(text: "Who is the Commander in Chief of the military?", options: ["The President", "The Vice President", "The Senate", "The Supreme Court"]),
            .init(text: "सैन्य प्रमुख कमाण्डर को हुन्?", options: ["राष्ट्रपति", "उपराष्ट्रपति", "सेनेट", "सर्वोच्च अदालत"])
        ]),
        UnifiedQuestion(id: "q_1_13", correctAnswer: 3, variants: [
            .init(text: "What is the name of the national anthem?", options: ["This Land is Your Land", "God Bless America", "America the Beautiful", "The Star-Spangled Banner"]),
            .init(text: "राष्ट्रिय गानको नाम के हो?", options: ["यो भूमि तिमीहरूको हो", "भगवानले अमेरिका रक्षा गरुन", "अमेरिका सुन्दर छ", "द स्टार स्पैङ्गल्ड ब्यानर"])
        ]),
        UnifiedQuestion(id: "q_1_14", correctAnswer: 3, variants: [
            .init(text: "What do the 13 stripes on the U.S. flag represent?", options: ["The 13 amendments", "The number of wars", "The 13 states", "The original 13 colonies"]),
            .init(text: "अमेरिकी झण्डामा रहेका १३ वटा धर्साहरू के प्रतिनिधित्व गर्छन्?", options: ["१३ वटा संशोधनहरू", "युद्धहरूको संख्या", "१३ राज्यहरू", "मौलिक १३ उपनिवेशहरू"])
        ]),
        UnifiedQuestion(id: "q_1_15", correctAnswer: 0, variants: [
            .init(text: "What is the highest court in the United States?", options: ["The Supreme Court", "The Federal Court", "The Court of Appeals", "The Civil Court"]),
            .init(text: "संयुक्त राज्य अमेरिकाको सबैभन्दा उच्च अदालत कुन हो?", options: ["सर्वोच्च अदालत", "संघीय अदालत", "अपिल अदालत", "नागरिक अदालत"])
        ])
    ]

    // MARK: - Practice 2

    static let practice2: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_2_01", correctAnswer: 3, variants: [
            .init(text: "Who wrote the Declaration of Independence?", options: ["George Washington", "Abraham Lincoln", "Benjamin Franklin", "Thomas Jefferson"]),
            .init(text: "स्वतन्त्रताको घोषणापत्र कसले लेखेका थिए?", options: ["जर्ज वाशिंगटन", "अब्राहम लिंकन", "बेंजामिन फ्र्याङ्कलिन", "थॉमस जेफरसनले"])
        ]),
        UnifiedQuestion(id: "q_2_02", correctAnswer: 1, variants: [
            .init(text: "How many U.S. Senators are there?", options: ["50", "100", "435", "200"]),
            .init(text: "संयुक्त राज्य अमेरिकामा कुल कति जना सिनेटर छन्?", options: ["५०", "१००", "४३५", "२००"])
        ]),
        UnifiedQuestion(id: "q_2_03", correctAnswer: 2, variants: [
            .init(text: "How long is a term for a U.S. Senator?", options: ["4 years", "2 years", "6 years", "8 years"]),
            .init(text: "अमेरिकी सिनेटरको कार्यकाल कति समयको हुन्छ?", options: ["४ वर्ष", "२ वर्ष", "६ वर्ष", "८ वर्ष"])
        ]),
        UnifiedQuestion(id: "q_2_04", correctAnswer: 0, variants: [
            .init(text: "What is one responsibility of a U.S. citizen?", options: ["Vote in elections", "Own a business", "Pay for health insurance", "Travel abroad"]),
            .init(text: "संयुक्त राज्य अमेरिकाको नागरिकको एउटा जिम्मेवारी के हो?", options: ["निर्वाचनमा मतदान गर्ने", "व्यवसाय संचालन गर्ने", "स्वास्थ्य बिमा तिर्ने", "विदेश यात्रा गर्ने"])
        ]),
        UnifiedQuestion(id: "q_2_05", correctAnswer: 0, variants: [
            .init(text: "Who is the Father of Our Country?", options: ["George Washington", "Thomas Jefferson", "Abraham Lincoln", "John Adams"]),
            .init(text: "हाम्रो देशका पिता को हुन्?", options: ["जर्ज वाशिंगटन", "थोमस जेफरसन", "अब्राहम लिंकन", "जोहन एडम्स"])
        ]),
        UnifiedQuestion(id: "q_2_06", correctAnswer: 3, variants: [
            .init(text: "What is one promise you make when you become a U.S. citizen?", options: ["Speak only English", "Always vote in elections", "Get a college degree", "Obey the laws of the United States"]),
            .init(text: "संयुक्त राज्य अमेरिकाको नागरिक हुँदा तपाईँले गर्ने एउटा प्रतिज्ञा के हो?", options: ["सिर्फ अंग्रेजी बोल्ने", "सधैं चुनावमा मतदान गर्ने", "कलेज डिग्री प्राप्त गर्ने", "संयुक्त राज्य अमेरिकाको कानुन मान्ने"])
        ]),
        UnifiedQuestion(id: "q_2_07", correctAnswer: 1, variants: [
            .init(text: "What ocean is on the West Coast of the United States?", options: ["Atlantic Ocean", "Pacific Ocean", "Indian Ocean", "Arctic Ocean"]),
            .init(text: "संयुक्त राज्य अमेरिकाको पश्चिमी तटमा कुन महासागर छ?", options: ["एट्लान्टिक महासागर", "प्रशान्त महासागर", "भारतीय महासागर", "आर्कटिक महासागर"])
        ]),
        UnifiedQuestion(id: "q_2_08", correctAnswer: 2, variants: [
            .init(text: "What is the economic system in the United States?", options: ["Socialism", "Communism", "Capitalism", "Monarchy"]),
            .init(text: "संयुक्त राज्य अमेरिकाको आर्थिक प्रणाली के हो?", options: ["समाजवाद", "साम्यवाद", "पूँजीवाद", "राजतन्त्र"])
        ]),
        UnifiedQuestion(id: "q_2_09", correctAnswer: 3, variants: [
            .init(text: "How many voting members are in the House of Representatives?", options: ["200", "100", "50", "435"]),
            .init(text: "प्रतिनिधि सभामा कति जना मतदान सदस्यहरू छन्?", options: ["२००", "१००", "५०", "४३५"])
        ]),
        UnifiedQuestion(id: "q_2_10", correctAnswer: 0, variants: [
            .init(text: "What is the rule of law?", options: ["Everyone must follow the law", "The President is above the law", "Judges are above the law", "Only lawmakers follow the law"]),
            .init(text: "कानुनको शासन भनेको के हो?", options: ["सबैले कानुन मान्नुपर्छ", "राष्ट्रपति कानुनभन्दा माथि छन्", "न्यायाधीशहरू कानुनभन्दा माथि छन्", "सिर्फ कानुन निर्माताहरू कानुन पालना गर्छन्"])
        ]),
        UnifiedQuestion(id: "q_2_11", correctAnswer: 2, variants: [
            .init(text: "What is freedom of religion?", options: ["You can only practice major religions", "You must follow the government religion", "You can practice any religion, or not practice a religion", "You can never change your religion"]),
            .init(text: "धर्मको स्वतन्त्रता भनेको के हो?", options: ["तपाईं केवल प्रमुख धर्महरू मात्र अभ्यास गर्न सक्नुहुन्छ", "तपाईं सरकारको धर्म पालना गर्नैपर्छ", "तपाईं कुनै पनि धर्म अभ्यास गर्न सक्नुहुन्छ, वा कुनै पनि धर्म अभ्यास नगर्न सक्नुहुन्छ", "तपाईं आफ्नो धर्म कहिल्यै परिवर्तन गर्न सक्नुहुन्न"])
        ]),
        UnifiedQuestion(id: "q_2_12", correctAnswer: 2, variants: [
            .init(text: "What does the Constitution do?", options: ["Declares war", "Defines laws for voting", "Sets up the government", "Gives advice to the President"]),
            .init(text: "संविधानले के गर्छ?", options: ["युद्ध घोषणा गर्छ", "मतदानका लागि कानुन परिभाषित गर्छ", "सरकार गठन गर्छ", "राष्ट्रपतिलाई सल्लाह दिन्छ"])
        ]),
        UnifiedQuestion(id: "q_2_13", correctAnswer: 3, variants: [
            .init(text: "What stops one branch of government from becoming too powerful?", options: ["The Supreme Court", "The military", "The people", "Checks and balances"]),
            .init(text: "सरकारको एउटा शाखालाई अत्यधिक शक्तिशाली बन्नबाट केले रोक्छ?", options: ["सर्वोच्च अदालत", "सेना", "जनता", "जाँच र सन्तुलन"])
        ]),
        UnifiedQuestion(id: "q_2_14", correctAnswer: 1, variants: [
            .init(text: "Name one branch or part of the government.", options: ["Lawmakers", "Legislative branch (Congress)", "Governors", "The Police"]),
            .init(text: "सरकारको एउटा शाखा वा भागको नाम लिनुहोस्।", options: ["कानुन निर्माता", "विधायिका शाखा (कांग्रेस)", "राज्यपालहरू", "प्रहरी"])
        ]),
        UnifiedQuestion(id: "q_2_15", correctAnswer: 0, variants: [
            .init(text: "What is an amendment?", options: ["A change to the Constitution", "A law", "A government branch", "A tax"]),
            .init(text: "संशोधन भनेको के हो?", options: ["संविधानमा परिवर्तन", "एउटा कानुन", "एउटा सरकारी शाखा", "एउटा कर"])
        ])
    ]

    // MARK: - Practice 3

    static let practice3: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_3_01", correctAnswer: 1, variants: [
            .init(text: "What do we call the first ten amendments to the Constitution?", options: ["The Declaration of Independence", "The Bill of Rights", "The Articles of Confederation", "The Federalist Papers"]),
            .init(text: "संविधानका पहिलो १० संशोधनहरूलाई के भनिन्छ?", options: ["स्वतन्त्रताको घोषणा-पत्र ", "अधिकारको विधेयक", "संघीय अनुच्छेद", "फेडेरलिस्ट पत्रहरू"])
        ]),
        UnifiedQuestion(id: "q_3_02", correctAnswer: 0, variants: [
            .init(text: "What is the capital of your state?", options: ["Depends on your state", "New York", "Los Angeles", "Chicago"]),
            .init(text: "तपाईँको राज्यको राजधानी के हो?", options: ["तपाईँको राज्यमा भर पर्छ", "न्यूयोर्क", "लस एन्जलस", "शिकागो"])
        ]),
        UnifiedQuestion(id: "q_3_03", correctAnswer: 2, variants: [
            .init(text: "Who was the first President of the United States?", options: ["John Adams", "Thomas Jefferson", "George Washington", "Benjamin Franklin"]),
            .init(text: "संयुक्त राज्य अमेरिकाका पहिलो राष्ट्रपति को थिए?", options: ["जोहन एडम्स", "थोमस जेफरसन", "जर्ज वाशिंगटन", "बेंजामिन फ्र्याङ्कलिन"])
        ]),
        UnifiedQuestion(id: "q_3_04", correctAnswer: 1, variants: [
            .init(text: "What did the Emancipation Proclamation do?", options: ["Ended the Civil War", "Freed the slaves", "Established a national bank", "Declared independence from Britain"]),
            .init(text: "मुक्ति घोषणाले के गर्यो?", options: ["गृहयुद्ध समाप्त गर्यो", "दासहरूलाई स्वतन्त्र गर्यो", "राष्ट्रिय बैंक स्थापना गर्यो", "बेलायतबाट स्वतन्त्रता घोषणा गर्यो"])
        ]),
        UnifiedQuestion(id: "q_3_05", correctAnswer: 3, variants: [
            .init(text: "Who is the Speaker of the House of Representatives now?", options: ["Nancy Pelosi", "Kevin McCarthy", "Mitch McConnell", "Mike Johnson"]),
            .init(text: "हाल प्रतिनिधि सभाका सभामुख को हुन्?", options: ["न्यान्सी पेलोसी", "केभिन म्याकार्थी", "मिच म्याककोनेल", "माइक जोन्सन"])
        ]),
        UnifiedQuestion(id: "q_3_06", correctAnswer: 1, variants: [
            .init(text: "How many justices are on the Supreme Court?", options: ["7", "9", "11", "13"]),
            .init(text: "सर्वोच्च अदालतमा कति जना न्यायाधीशहरू छन्?", options: ["७", "९", "११", "१३"])
        ]),
        UnifiedQuestion(id: "q_3_07", correctAnswer: 0, variants: [
            .init(text: "What did Susan B. Anthony do?", options: ["Fought for women's rights", "Wrote the Constitution", "Discovered America", "Became the first female President"]),
            .init(text: "सुसान बी. एन्थोनीले के गरिन्?", options: ["महिलाहरूका अधिकारका लागि लडिन्", "संविधान लेखिन्", "अमेरिका पत्ता लगाइन्", "पहिलो महिला राष्ट्रपति बनिन्"])
        ]),
        UnifiedQuestion(id: "q_3_08", correctAnswer: 0, variants: [
            .init(text: "What movement tried to end racial discrimination?", options: ["The Civil Rights Movement", "The Women's Movement", "The American Revolution", "The Abolitionist Movement"]),
            .init(text: "कुन आन्दोलनले जातीय भेदभाव अन्त्य गर्ने प्रयास गर्यो?", options: ["नागरिक अधिकार आन्दोलन", "महिला आन्दोलन", "अमेरिकी क्रान्ति", "दास उन्मूलन आन्दोलन"])
        ]),
        UnifiedQuestion(id: "q_3_09", correctAnswer: 1, variants: [
            .init(text: "What was one important thing that Abraham Lincoln did?", options: ["Established the U.S. Navy", "Freed the slaves", "Fought in the Revolutionary War", "Wrote the Bill of Rights"]),
            .init(text: "अब्राहम लिंकनले गरेको एउटा महत्त्वपूर्ण काम के हो?", options: ["संयुक्त राज्यको नौसेना स्थापना गरे", "दासहरूलाई स्वतन्त्र गराए", "क्रान्तिकारी युद्ध लडे", "अधिकारको विधेयक लेखे"])
        ]),
        UnifiedQuestion(id: "q_3_10", correctAnswer: 1, variants: [
            .init(text: "Why does the U.S. flag have 50 stars?", options: ["For the 50 Presidents", "For the 50 states", "For the 50 amendments", "For the 50 years of independence"]),
            .init(text: "अमेरिकी झण्डामा ५० वटा तारा किन छन्?", options: ["५० जना राष्ट्रपतिहरूका लागि", "५० वटा राज्यहरूका लागि", "५० वटा संशोधनहरूका लागि", "५० वर्षको स्वतन्त्रताका लागि"])
        ]),
        UnifiedQuestion(id: "q_3_11", correctAnswer: 2, variants: [
            .init(text: "When do we vote for President?", options: ["January", "March", "November", "December"]),
            .init(text: "हामी कहिले राष्ट्रपतिको लागि मतदान गर्छौं?", options: ["जनवरी", "मार्च", "नोभेम्बर", "डिसेम्बर"])
        ]),
        UnifiedQuestion(id: "q_3_12", correctAnswer: 1, variants: [
            .init(text: "What is one reason colonists came to America?", options: ["To escape taxes", "Religious freedom", "To join the military", "To find gold"]),
            .init(text: "बेलायती उपनिवेशहरू किन अमेरिका आए?", options: ["करबाट बच्न", "धार्मिक स्वतन्त्रता", "सेनामा भर्ती हुन", "सुन खोज्न"])
        ]),
        UnifiedQuestion(id: "q_3_13", correctAnswer: 1, variants: [
            .init(text: "Who wrote the Federalist Papers?", options: ["Thomas Jefferson", "James Madison, Alexander Hamilton, John Jay", "George Washington", "Ben Franklin"]),
            .init(text: "फेडेरलिस्ट पत्रहरू कसले लेखे?", options: ["थोमस जेफरसन", "जेम्स म्याडिसन, एलेक्जेन्डर ह्यामिल्टन, जोन जे", "जर्ज वाशिंगटन", "बेन फ्र्याङ्कलिन"])
        ]),
        UnifiedQuestion(id: "q_3_14", correctAnswer: 1, variants: [
            .init(text: "Who was the President during World War I?", options: ["Franklin D. Roosevelt", "Woodrow Wilson", "Harry Truman", "Dwight D. Eisenhower"]),
            .init(text: "प्रथम विश्वयुद्धको समयमा संयुक्त राज्य अमेरिकाका राष्ट्रपति को थिए?", options: ["फ्र्याङ्कलिन डी. रूजवेल्ट", "वुड्रो विल्सन", "ह्यारी ट्रुम्यान", "ड्वाइट डी. आइजनहावर"])
        ]),
        UnifiedQuestion(id: "q_3_15", correctAnswer: 1, variants: [
            .init(text: "What is one U.S. territory?", options: ["Hawaii", "Puerto Rico", "Alaska", "Canada"]),
            .init(text: "संयुक्त राज्य अमेरिकाको एउटा क्षेत्र कुन हो?", options: ["हवाई", "प्युर्टो रिको", "अलास्का", "क्यानडा"])
        ])
    ]

    // MARK: - Practice 4

    static let practice4: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_4_01", correctAnswer: 1, variants: [
            .init(text: "What was the main purpose of the Federalist Papers?", options: ["To declare independence from Britain", "To promote the ratification of the U.S. Constitution", "To outline the Bill of Rights", "To establish a national bank"]),
            .init(text: "फेडेरलिस्ट पत्रहरूको मुख्य उद्देश्य के थियो?", options: ["बेलायतबाट स्वतन्त्रता घोषणा गर्न", "अमेरिकी संविधानको अनुमोदन प्रवर्धन गर्न", "अधिकार विधेयकको रूपरेखा प्रस्तुत गर्न", "राष्ट्रिय बैंक स्थापना गर्न"])
        ]),
        UnifiedQuestion(id: "q_4_02", correctAnswer: 0, variants: [
            .init(text: "Which amendment abolished slavery?", options: ["13th Amendment", "14th Amendment", "15th Amendment", "19th Amendment"]),
            .init(text: "कुन संशोधनले दासत्व अन्त्य गर्यो?", options: ["तेह्रौं संशोधन", "चौधौं संशोधन", "पन्ध्रौं संशोधन", "उन्नाइसौं संशोधन"])
        ]),
        UnifiedQuestion(id: "q_4_03", correctAnswer: 0, variants: [
            .init(text: "What landmark case established judicial review?", options: ["Marbury v. Madison", "Brown v. Board of Education", "Roe v. Wade", "McCulloch v. Maryland"]),
            .init(text: "कुन ऐतिहासिक मुद्दाले न्यायिक समीक्षा स्थापित गर्यो?", options: ["मार्बरी बनाम म्याडिसन", "ब्राउन बनाम शिक्षा बोर्ड", "रो बनाम वेड", "म्याक्कालक बनाम मेरील्यान्ड"])
        ]),
        UnifiedQuestion(id: "q_4_04", correctAnswer: 1, variants: [
            .init(text: "How many years can a President serve in total?", options: ["4 years", "8 years", "10 years", "12 years"]),
            .init(text: "राष्ट्रपति कति वर्षसम्म सेवा गर्न सक्छन्?", options: ["४ वर्ष", "८ वर्ष", "१० वर्ष", "१२ वर्ष"])
        ]),
        UnifiedQuestion(id: "q_4_05", correctAnswer: 2, variants: [
            .init(text: "What war was fought between the North and South in the U.S.?", options: ["Revolutionary War", "World War 1", "The Civil War", "The War of 1812"]),
            .init(text: "संयुक्त राज्य अमेरिकामा उत्तर र दक्षिणबीच भएको युद्ध कुन थियो?", options: ["क्रान्तिकारी युद्ध", "पहिलो विश्वयुद्ध", "गृहयुद्ध", "१८१२ को युद्ध"])
        ]),
        UnifiedQuestion(id: "q_4_06", correctAnswer: 2, variants: [
            .init(text: "What was the main reason the U.S. entered World War II?", options: ["To support Britain and France", "To stop the spread of communism", "The attack on Pearl Harbor", "To defend against Germany"]),
            .init(text: "संयुक्त राज्य अमेरिका दोस्रो विश्वयुद्धमा प्रवेश गर्ने मुख्य कारण के थियो?", options: ["बेलायत र फ्रान्सलाई समर्थन गर्न", "साम्यवादको विस्तार रोक्न", "पर्ल हार्बरमा भएको आक्रमण", "जर्मनीको विरुद्ध रक्षा गर्न"])
        ]),
        UnifiedQuestion(id: "q_4_07", correctAnswer: 0, variants: [
            .init(text: "What did the Monroe Doctrine declare?", options: ["Europe should not interfere in the Americas", "Slavery is abolished", "The U.S. must remain neutral in global conflicts", "The Louisiana Purchase is legal"]),
            .init(text: "मोनरो सिद्धान्तले के घोषणा गर्यो?", options: ["युरोपले अमेरिकामा हस्तक्षेप गर्नु हुँदैन", "दासत्व समाप्त गरियो", "संयुक्त राज्यले विश्वव्यापी द्वन्द्वमा तटस्थ रहनु पर्छ", "ल्यूसियाना खरिद वैध छ"])
        ]),
        UnifiedQuestion(id: "q_4_08", correctAnswer: 2, variants: [
            .init(text: "Which U.S. President served more than two terms?", options: ["George Washington", "Theodore Roosevelt", "Franklin D. Roosevelt", "Dwight D. Eisenhower"]),
            .init(text: "कुन अमेरिकी राष्ट्रपतिले दुई कार्यकाल भन्दा बढी सेवा गरे?", options: ["जर्ज वाशिंगटन", "थियोडोर रूजवेल्ट", "फ्र्याङ्कलिन डी. रूजवेल्ट", "ड्वाइट डी. आइजनहावर"])
        ]),
        UnifiedQuestion(id: "q_4_09", correctAnswer: 3, variants: [
            .init(text: "What is the term length for a Supreme Court Justice?", options: ["4 years", "8 years", "12 years", "Life"]),
            .init(text: "सर्वोच्च अदालतको न्यायाधीशको कार्यकाल कति हुन्छ?", options: ["४ वर्ष", "८ वर्ष", "१२ वर्ष", "जीवनभरि"])
        ]),
        UnifiedQuestion(id: "q_4_10", correctAnswer: 0, variants: [
            .init(text: "Who was the Chief Justice of the Supreme Court in 2023?", options: ["John G. Roberts", "Clarence Thomas", "Sonia Sotomayor", "Amy Coney Barrett"]),
            .init(text: "सन् २०२३ मा सर्वोच्च अदालतका प्रधान न्यायाधीश को थिए?", options: ["जोहन जी. रोबर्ट्स", "क्लरेन्स थोमस", "सोनिया सोतोमयोर", "एमी कोनी ब्यारेट"])
        ]),
        UnifiedQuestion(id: "q_4_11", correctAnswer: 2, variants: [
            .init(text: "Which branch of government has the power to declare war?", options: ["The President", "The Supreme Court", "Congress", "The Vice President"]),
            .init(text: "सरकारको कुन शाखासँग युद्ध घोषणा गर्ने अधिकार छ?", options: ["राष्ट्रपति", "सर्वोच्च अदालत", "कांग्रेस", "उपराष्ट्रपति"])
        ]),
        UnifiedQuestion(id: "q_4_12", correctAnswer: 0, variants: [
            .init(text: "What was the purpose of the Marshall Plan?", options: ["To rebuild Europe after World War 2", "To prevent communism in the U.S.", "To provide U.S. military aid", "To negotiate peace with Japan"]),
            .init(text: "मार्शल योजनाको उद्देश्य के थियो?", options: ["दोस्रो विश्वयुद्धपछि युरोप पुनर्निर्माण गर्न", "संयुक्त राज्य अमेरिकामा साम्यवाद रोक्न", "संयुक्त राज्य सैन्य सहायता प्रदान गर्न", "जापानसँग शान्ति सम्झौता गर्न"])
        ]),
        UnifiedQuestion(id: "q_4_13", correctAnswer: 1, variants: [
            .init(text: "Which constitutional amendment granted women the right to vote?", options: ["15th Amendment", "19th Amendment", "21st Amendment", "26th Amendment"]),
            .init(text: "कुन संवैधानिक संशोधनले महिलाहरूलाई मतदान अधिकार प्रदान गर्यो?", options: ["पन्ध्रौं संशोधन", "उन्नाइसौं संशोधन", "एक्काइसौं संशोधन", "छब्बिसौं संशोधन"])
        ]),
        UnifiedQuestion(id: "q_4_14", correctAnswer: 2, variants: [
            .init(text: "Which U.S. state was an independent republic before joining the Union?", options: ["Hawaii", "California", "Texas", "Alaska"]),
            .init(text: "संयुक्त राज्य अमेरिकामा सामेल हुनुअघि कुन राज्य स्वतन्त्र गणतन्त्र थियो?", options: ["हवाई", "क्यालिफोर्निया", "टेक्सास", "अलास्का"])
        ]),
        UnifiedQuestion(id: "q_4_15", correctAnswer: 2, variants: [
            .init(text: "Who was President during the Great Depression and World War II?", options: ["Woodrow Wilson", "Herbert Hoover", "Franklin D. Roosevelt", "Harry Truman"]),
            .init(text: "महामन्दी र दोस्रो विश्वयुद्धको समयमा राष्ट्रपति को थिए?", options: ["वुड्रो विल्सन", "हर्बर्ट हूवर", "फ्र्याङ्कलिन डी. रूजवेल्ट", "ह्यारी ट्रुम्यान"])
        ])
    ]

    // MARK: - Practice 5

    static let practice5: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_5_01", correctAnswer: 1, variants: [
            .init(text: "The House of Representatives has how many voting members?", options: ["100", "435", "50", "200"]),
            .init(text: "प्रतिनिधि सभामा कति मतदान सदस्यहरू छन्?", options: ["१००", "४३५", "५०", "२००"])
        ]),
        UnifiedQuestion(id: "q_5_02", correctAnswer: 0, variants: [
            .init(text: "If both the President and the Vice President can no longer serve, who becomes President?", options: ["The Speaker of the House", "The Chief Justice", "The Secretary of State", "The Senate Majority Leader"]),
            .init(text: "यदि राष्ट्रपति र उपराष्ट्रपति दुबै सेवा गर्न नसक्ने भए, को राष्ट्रपति बन्छ?", options: ["प्रतिनिधि सभाका सभामुख", "प्रधान न्यायाधीश", "राज्य सचिव", "सीनेट बहुमत नेता"])
        ]),
        UnifiedQuestion(id: "q_5_03", correctAnswer: 1, variants: [
            .init(text: "Under the Constitution, some powers belong to the federal government. What is one power of the federal government?", options: ["To issue driver's licenses", "To create an army", "To set up schools", "To regulate marriages"]),
            .init(text: "संविधान अनुसार, केही शक्तिहरू संघीय सरकारको हुन्छन्। संघीय सरकारको एउटा शक्ति के हो?", options: ["ड्राइभरको लाइसेन्स जारी गर्न", "सेना बनाउन", "विद्यालय स्थापना गर्न", "विवाह नियमन गर्न"])
        ]),
        UnifiedQuestion(id: "q_5_04", correctAnswer: 3, variants: [
            .init(text: "Under our Constitution, some powers belong to the states. What is one power of the states?", options: ["To make treaties", "To create an army", "To print money", "Establish and run public schools"]),
            .init(text: "हाम्रो संविधान अनुसार, केही शक्तिहरू राज्यहरूको हुन्छ। राज्यहरूको एउटा शक्ति के हो?", options: ["सन्धिहरू बनाउन", "सेना स्थापना गर्न", "पैसा छाप्न", "सार्वजनिक विद्यालयहरू स्थापना र सञ्चालन गर्ने"])
        ]),
        UnifiedQuestion(id: "q_5_05", correctAnswer: 0, variants: [
            .init(text: "Who is the Commander in Chief of the military?", options: ["The President", "The Vice President", "The Secretary of Defense", "The Speaker of the House"]),
            .init(text: "सेनाको प्रधान सेनापति को हुन्?", options: ["राष्ट्रपति", "उपराष्ट्रपति", "रक्षा सचिव", "प्रतिनिधि सभाका सभामुख"])
        ]),
        UnifiedQuestion(id: "q_5_06", correctAnswer: 2, variants: [
            .init(text: "What are two rights in the Declaration of Independence?", options: ["Right to bear arms and right to vote", "Right to work and right to protest", "Life and Liberty", "Freedom of speech and freedom of religion"]),
            .init(text: "स्वतन्त्रता घोषणापत्रमा उल्लेखित दुई अधिकार के हुन्?", options: ["हतियार बोक्ने अधिकार र मतदान गर्ने अधिकार", "काम गर्ने अधिकार र विरोध गर्ने अधिकार", "जीवन र स्वतन्त्रता", "बोल्ने स्वतन्त्रता र धर्मको स्वतन्त्रता"])
        ]),
        UnifiedQuestion(id: "q_5_07", correctAnswer: 1, variants: [
            .init(text: "What is the 'rule of law'?", options: ["The government can ignore laws", "No one is above the law", "Only federal judges follow the law", "The Constitution is not legally binding"]),
            .init(text: "'कानुनको शासन' के हो?", options: ["सरकारले कानुन बेवास्ता गर्न सक्छ", "कुनै पनि व्यक्ति कानुनभन्दा माथि छैन", "सिर्फ संघीय न्यायाधीशहरूले कानुन पालन गर्छन्", "संविधान कानुनी रूपमा बाध्यकारी छैन"])
        ]),
        UnifiedQuestion(id: "q_5_08", correctAnswer: 1, variants: [
            .init(text: "What does the judicial branch do?", options: ["Makes laws", "Interprets the law", "Elects the President", "Controls the military"]),
            .init(text: "न्यायिक शाखाले के गर्छ?", options: ["कानुन बनाउँछ", "कानुनको व्याख्या गर्छ", "राष्ट्रपति चयन गर्छ", "सेनालाई नियन्त्रण गर्छ"])
        ]),
        UnifiedQuestion(id: "q_5_09", correctAnswer: 2, variants: [
            .init(text: "There are four amendments to the Constitution about who can vote. Describe one of them.", options: ["Only landowners can vote", "Only white men can vote", "Citizens 18 and older can vote", "Voting is mandatory"]),
            .init(text: "मतदान गर्न सक्ने व्यक्तिहरूसम्बन्धी संविधानमा चार संशोधनहरू छन्। तीमध्ये एउटा वर्णन गर्नुहोस्।", options: ["सिर्फ जग्गाधनीहरू मतदान गर्न सक्छन्", "सिर्फ गोरा पुरुषहरूले मतदान गर्न सक्छन्", "१८ वर्ष वा सोभन्दा माथिका नागरिकहरूले मतदान गर्न सक्छन्", "मतदान अनिवार्य छ"])
        ]),
        UnifiedQuestion(id: "q_5_10", correctAnswer: 1, variants: [
            .init(text: "Why do some states have more Representatives than other states?", options: ["Because they are bigger", "Because they have more people", "Because they were part of the original 13 colonies", "Because they have more senators"]),
            .init(text: "केही राज्यहरूमा अन्य राज्यहरूभन्दा धेरै प्रतिनिधिहरू किन छन्?", options: ["किनभने तिनीहरू ठूला छन्", "किनभने तिनीहरूको जनसंख्या बढी छ", "किनभने तिनीहरू मूल १३ उपनिवेशहरूको भाग थिए", "किनभने तिनीहरूसँग बढी सिनेटरहरू छन्"])
        ]),
        UnifiedQuestion(id: "q_5_11", correctAnswer: 2, variants: [
            .init(text: "What was the main concern of the United States during the Cold War?", options: ["Nuclear disarmament", "Terrorism", "The spread of communism", "World War 3"]),
            .init(text: "शीत युद्धको समयमा संयुक्त राज्य अमेरिकाको मुख्य चिन्ता के थियो?", options: ["परमाणु निःशस्त्रीकरण", "आतंकवाद", "साम्यवादको फैलावट", "तेस्रो विश्वयुद्ध"])
        ]),
        UnifiedQuestion(id: "q_5_12", correctAnswer: 1, variants: [
            .init(text: "What major event happened on September 11, 2001, in the United States?", options: ["The U.S. declared war on Iraq", "Terrorists attacked the United States", "The Great Recession began", "Hurricane Katrina struck"]),
            .init(text: "सेप्टेम्बर ११, २००१ मा संयुक्त राज्य अमेरिकामा के ठूलो घटना भयो?", options: ["संयुक्त राज्यले इराकसँग युद्ध घोषणा गर्यो", "आतंकवादीहरूले संयुक्त राज्य अमेरिकामा आक्रमण गरे", "महामन्दी सुरु भयो", "हरिकेन कट्रीना आयो"])
        ]),
        UnifiedQuestion(id: "q_5_13", correctAnswer: 1, variants: [
            .init(text: "What are two rights of everyone living in the United States?", options: ["Right to vote & right to work", "Freedom of speech & freedom of religion", "Right to own land & right to healthcare", "Right to drive & right to a free education"]),
            .init(text: "संयुक्त राज्य अमेरिकामा बस्ने सबै व्यक्तिहरूका दुई अधिकार के हुन्?", options: ["मतदान गर्ने अधिकार र काम गर्ने अधिकार", "बोल्ने स्वतन्त्रता र धर्मको स्वतन्त्रता", "जग्गा स्वामित्वको अधिकार र स्वास्थ्य सेवाको अधिकार", "गाडी चलाउने अधिकार र निःशुल्क शिक्षाको अधिकार"])
        ]),
        UnifiedQuestion(id: "q_5_14", correctAnswer: 1, variants: [
            .init(text: "What did the Civil Rights Movement do?", options: ["Fought for women's rights", "Fought for the end of segregation and racial discrimination", "Fought for U.S. independence", "Fought for workers' rights"]),
            .init(text: "नागरिक अधिकार आन्दोलनले के गर्यो?", options: ["महिलाको अधिकारको लागि लडाइँ गर्यो", "जातीय विभाजन र भेदभाव अन्त्य गर्न लडाइँ गर्यो", "संयुक्त राज्यको स्वतन्त्रताका लागि लडाइँ गर्यो", "कामदारहरूको अधिकारको लागि लडाइँ गर्यो"])
        ]),
        UnifiedQuestion(id: "q_5_15", correctAnswer: 2, variants: [
            .init(text: "What is one promise you make when you become a U.S. citizen?", options: ["To always vote", "To support your birth country", "To obey U.S. laws", "To join the U.S. military"]),
            .init(text: "तपाईं संयुक्त राज्यको नागरिक हुँदा गर्ने एउटा वाचा के हो?", options: ["सधैं मतदान गर्ने", "आफ्नो जन्मभूमिलाई समर्थन गर्ने", "संयुक्त राज्यको कानुन मान्ने", "संयुक्त राज्यको सैन्य सेवामा सामेल हुने"])
        ])
    ]
}
