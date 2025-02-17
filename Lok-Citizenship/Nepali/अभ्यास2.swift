import SwiftUI

struct अभ्यास2: View {
    @StateObject var quizLogic = Quizतर्क()
    @State private var selectedAnswer: Int? = nil
    @State private var showAnswerFeedback: Bool = false
    @State private var isAnswerCorrect: Bool = false
    
    @State private var showQuitConfirmation: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var isAnswered: Bool = false
    
    let questions: [BilingualQuestion] = [
        BilingualQuestion(
            englishText: "Who wrote the Declaration of Independence?",
            nepaliText: "स्वतन्त्रताको घोषणापत्र कसले लेखेका थिए?",
            englishOptions: ["George Washington", "Abraham Lincoln", "Benjamin Franklin", "Thomas Jefferson"],
            nepaliOptions: ["जर्ज वाशिंगटन", "अब्राहम लिंकन", "बेंजामिन फ्र्याङ्कलिन", "थॉमस जेफरसनले"],
            correctAnswer: 3
        ),

        BilingualQuestion(
            englishText: "How many U.S. Senators are there?",
            nepaliText: "संयुक्त राज्य अमेरिकामा कुल कति जना सिनेटर छन्?",
            englishOptions: ["50", "100", "435", "200"],
            nepaliOptions: ["५०", "१००", "४३५", "२००"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "How long is a term for a U.S. Senator?",
            nepaliText: "अमेरिकी सिनेटरको कार्यकाल कति समयको हुन्छ?",
            englishOptions: ["4 years", "2 years", "6 years", "8 years"],
            nepaliOptions: ["४ वर्ष", "२ वर्ष", "६ वर्ष", "८ वर्ष"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "What is one responsibility of a U.S. citizen?",
            nepaliText: "संयुक्त राज्य अमेरिकाको नागरिकको एउटा जिम्मेवारी के हो?",
            englishOptions: ["Vote in elections", "Own a business", "Pay for health insurance", "Travel abroad"],
            nepaliOptions: ["निर्वाचनमा मतदान गर्ने", "व्यवसाय संचालन गर्ने", "स्वास्थ्य बिमा तिर्ने", "विदेश यात्रा गर्ने"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "Who is the Father of Our Country?",
            nepaliText: "हाम्रो देशका पिता को हुन्?",
            englishOptions: ["George Washington", "Thomas Jefferson", "Abraham Lincoln", "John Adams"],
            nepaliOptions: ["जर्ज वाशिंगटन", "थोमस जेफरसन", "अब्राहम लिंकन", "जोहन एडम्स"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "What is one promise you make when you become a U.S. citizen?",
            nepaliText: "संयुक्त राज्य अमेरिकाको नागरिक हुँदा तपाईँले गर्ने एउटा प्रतिज्ञा के हो?",
            englishOptions: ["Speak only English", "Always vote in elections", "Get a college degree", "Obey the laws of the United States"],
            nepaliOptions: ["सिर्फ अंग्रेजी बोल्ने", "सधैं चुनावमा मतदान गर्ने", "कलेज डिग्री प्राप्त गर्ने", "संयुक्त राज्य अमेरिकाको कानुन मान्ने"],
            correctAnswer: 3
        ),

        BilingualQuestion(
            englishText: "What ocean is on the West Coast of the United States?",
            nepaliText: "संयुक्त राज्य अमेरिकाको पश्चिमी तटमा कुन महासागर छ?",
            englishOptions: ["Atlantic Ocean", "Pacific Ocean", "Indian Ocean", "Arctic Ocean"],
            nepaliOptions: ["एट्लान्टिक महासागर", "प्रशान्त महासागर", "भारतीय महासागर", "आर्कटिक महासागर"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "What is the economic system in the United States?",
            nepaliText: "संयुक्त राज्य अमेरिकाको आर्थिक प्रणाली के हो?",
            englishOptions: ["Socialism", "Communism", "Capitalism", "Monarchy"],
            nepaliOptions: ["साम्यवाद", "साम्यवाद", "पूँजीवाद", "राजतन्त्र"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "How many voting members are in the House of Representatives?",
            nepaliText: "प्रतिनिधि सभामा कति जना मतदान सदस्यहरू छन्?",
            englishOptions: ["200", "100", "50", "435"],
            nepaliOptions: ["२००", "१००", "५०", "४३५"],
            correctAnswer: 3
        ),

        BilingualQuestion(
            englishText: "What is the rule of law?",
            nepaliText: "कानुनको शासन भनेको के हो?",
            englishOptions: ["Everyone must follow the law", "The President is above the law", "Judges are above the law", "Only lawmakers follow the law"],
            nepaliOptions: ["सबैले कानुन मान्नुपर्छ", "राष्ट्रपति कानुनभन्दा माथि छन्", "न्यायाधीशहरू कानुनभन्दा माथि छन्", "सिर्फ कानुन निर्माताहरू कानुन पालना गर्छन्"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "What is freedom of religion?",
            nepaliText: "धर्मको स्वतन्त्रता भनेको के हो?",
            englishOptions: ["You can only practice major religions", "You must follow the government religion", "You can practice any religion, or not practice a religion", "You can never change your religion"],
            nepaliOptions: ["तपाईं केवल प्रमुख धर्महरू मात्र अभ्यास गर्न सक्नुहुन्छ", "तपाईं सरकारको धर्म पालना गर्नैपर्छ", "तपाईं कुनै पनि धर्म अभ्यास गर्न सक्नुहुन्छ, वा कुनै पनि धर्म अभ्यास नगर्न सक्नुहुन्छ", "तपाईं आफ्नो धर्म कहिल्यै परिवर्तन गर्न सक्नुहुन्न"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "What does the Constitution do?",
            nepaliText: "संविधानले के गर्छ?",
            englishOptions: ["Declares war", "Defines laws for voting", "Sets up the government", "Gives advice to the President"],
            nepaliOptions: ["युद्ध घोषणा गर्छ", "मतदानका लागि कानुन परिभाषित गर्छ", "सरकार गठन गर्छ", "राष्ट्रपतिलाई सल्लाह दिन्छ"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "What stops one branch of government from becoming too powerful?",
            nepaliText: "सरकारको एउटा शाखालाई अत्यधिक शक्तिशाली बन्नबाट केले रोक्छ?",
            englishOptions: ["The Supreme Court", "The military", "The people", "Checks and balances"],
            nepaliOptions: ["सर्वोच्च अदालत", "सेना", "जनता", "जाँच र सन्तुलन"],
            correctAnswer: 3
        ),

        BilingualQuestion(
            englishText: "Name one branch or part of the government.",
            nepaliText: "सरकारको एउटा शाखा वा भागको नाम लिनुहोस्।",
            englishOptions: ["Lawmakers", "Legislative branch (Congress)", "Governors", "The Police"],
            nepaliOptions: ["कानुन निर्माता", "विधायिका शाखा (कांग्रेस)", "राज्यपालहरू", "प्रहरी"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "What is an amendment?",
            nepaliText: "संशोधन भनेको के हो?",
            englishOptions: ["A change to the Constitution", "A law", "A government branch", "A tax"],
            nepaliOptions: ["संविधानमा परिवर्तन", "एउटा कानुन", "एउटा सरकारी शाखा", "एउटा कर"],
            correctAnswer: 0
        )
    ]

    
    var body: some View {
        ScrollView {
        VStack(spacing: 20) {
            HStack {
                Button(action: { quizLogic.switchLanguage(to: .english) }) {
                    Text("🇺🇸 English")
                        .padding()
                        .background(quizLogic.selectedLanguage == .english ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer()
                
                Button(action: { quizLogic.switchLanguage(to: .nepali) }) {
                    Text("🇳🇵 नेपाली")
                        .padding()
                        .background(quizLogic.selectedLanguage == .nepali ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            
            if quizLogic.showResult {
                Text(quizLogic.selectedLanguage == .english ? "Quiz Completed!" : "क्विज समाप्त भयो!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(quizLogic.selectedLanguage == .english ? "Correct Answers: \(quizLogic.correctAnswers)" : "सही उत्तरहरू: \(quizLogic.correctAnswers)")
                    .foregroundColor(.green)
                Text(quizLogic.selectedLanguage == .english ? "Incorrect Answers: \(quizLogic.incorrectAnswers)" : "गलत उत्तरहरू: \(quizLogic.incorrectAnswers)")
                    .foregroundColor(.red)
                
                Button(quizLogic.selectedLanguage == .english ? "Restart Quiz" : "पुन: सुरु गर्नुहोस्") {
                    quizLogic.startQuiz()
                    selectedAnswer = nil
                    showAnswerFeedback = false
                    isAnswered = false
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
            } else {
                Text("\(quizLogic.currentQuestionIndex + 1). \(quizLogic.selectedLanguage == .english ? quizLogic.currentQuestion.englishText : quizLogic.currentQuestion.nepaliText)")
                    .font(.title).bold()
                    .foregroundColor(.white)
                    .padding()
                    .padding(.bottom, 20)

                ForEach(0..<quizLogic.currentQuestion.englishOptions.count, id: \.self) { index in
                    Button(action: {
                        if !isAnswered {
                            selectedAnswer = index
                            isAnswerCorrect = quizLogic.answerQuestion(index)
                            showAnswerFeedback = true
                            isAnswered = true
                        }
                    }) {
                        Text(quizLogic.selectedLanguage == .english ?
                             quizLogic.currentQuestion.englishOptions[index] :
                                quizLogic.currentQuestion.nepaliOptions[index])
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(
                            isAnswered
                            ? (index == quizLogic.currentQuestion.correctAnswer ? Color.green : Color.red)
                            : Color.blue
                        )
                        .cornerRadius(10)
                    }
                    .disabled(isAnswered)
                }
                
                if showAnswerFeedback {
                    
                    Text(isAnswerCorrect ? "✅ \(quizLogic.selectedLanguage == .english ? "Correct!" : "सही!")✅" : "❌ \(quizLogic.selectedLanguage == .english ? "Wrong!" : "गलत!")❌")
                        .font(.headline)
                        .foregroundColor(isAnswerCorrect ? .green : .red)
                        .padding()
                    
                    Button(quizLogic.selectedLanguage == .english ? "Next Question" : "अर्को प्रश्न") {
                        quizLogic.moveToNextQuestion()
                        showAnswerFeedback = false
                        selectedAnswer = nil
                        isAnswered = false
                    }
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                } else {
                    HStack {
                        Button(action: {
                            quizLogic.previousQuestion()
                            selectedAnswer = nil
                            showAnswerFeedback = false
                            isAnswered = false
                        }) {
                            Text(quizLogic.selectedLanguage == .english ? "Previous" : "अघिल्लो")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.gray)
                                .cornerRadius(10)
                        }
                        .disabled(quizLogic.currentQuestionIndex == 0)
                        
                        Spacer()
                        
                        Button(action: {
                            quizLogic.moveToNextQuestion()
                            selectedAnswer = nil
                            showAnswerFeedback = false
                            isAnswered = false
                        }) {
                            Text(quizLogic.selectedLanguage == .english ? "Skip" : "छोड्नुहोस्")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(10)
                        }
                        .disabled(quizLogic.showResult)
                    }
                    .padding()
                }
            }
        }
    }
            .navigationBarBackButtonHidden(true)
            .padding()
            .onAppear {
                quizLogic.questions = questions
                quizLogic.startQuiz()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image("USANepal")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .overlay(Color.black.opacity(0.8))
            )
        
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(quizLogic.selectedLanguage == .english ? "Practice 2" : "अभ्यास २")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    }
                }
        
            .navigationBarItems(trailing:
                Button(action: {
                    showQuitConfirmation = true
                }) {
                    Text(quizLogic.selectedLanguage == .english ? "Quit" : "छोड्नुहोस्")
                        .foregroundColor(.red)
                        .font(.title)
                }
            )
            .alert(isPresented: $showQuitConfirmation) {
                Alert(
                    title: Text(quizLogic.selectedLanguage == .english ? "Quit Quiz?" : "क्विज छोड्नुहुन्छ?"),
                    message: Text(quizLogic.selectedLanguage == .english ? "Are you sure you want to quit?" : "के तपाईँ पक्का छोड्न चाहनुहुन्छ?"),
                    primaryButton: .destructive(Text(quizLogic.selectedLanguage == .english ? "Yes" : "हो")) {
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel(Text(quizLogic.selectedLanguage == .english ? "No" : "होइन"))
                )
            }
        }
    }
