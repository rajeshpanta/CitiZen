import SwiftUI

struct अभ्यास5: View {
    @StateObject var quizLogic = Quizतर्क()
    @State private var selectedAnswer: Int? = nil
    @State private var showAnswerFeedback: Bool = false
    @State private var isAnswerCorrect: Bool = false
    
    @State private var showQuitConfirmation: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var isAnswered: Bool = false
    
    let questions: [BilingualQuestion] = [
        BilingualQuestion(
            englishText: "The House of Representatives has how many voting members?",
            nepaliText: "प्रतिनिधि सभामा कति मतदान सदस्यहरू छन्?",
            englishOptions: ["100", "435", "50", "200"],
            nepaliOptions: ["१००", "४३५", "५०", "२००"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "If both the President and the Vice President can no longer serve, who becomes President?",
            nepaliText: "यदि राष्ट्रपति र उपराष्ट्रपति दुबै सेवा गर्न नसक्ने भए, को राष्ट्रपति बन्छ?",
            englishOptions: ["The Speaker of the House", "The Chief Justice", "The Secretary of State", "The Senate Majority Leader"],
            nepaliOptions: ["प्रतिनिधि सभाका सभामुख", "प्रधान न्यायाधीश", "राज्य सचिव", "सीनेट बहुमत नेता"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "Under the Constitution, some powers belong to the federal government. What is one power of the federal government?",
            nepaliText: "संविधान अनुसार, केही शक्तिहरू संघीय सरकारको हुन्छन्। संघीय सरकारको एउटा शक्ति के हो?",
            englishOptions: ["To issue driver’s licenses", "To create an army", "To set up schools", "To regulate marriages"],
            nepaliOptions: ["ड्राइभरको लाइसेन्स जारी गर्न", "सेना बनाउन", "विद्यालय स्थापना गर्न", "विवाह नियमन गर्न"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "Under our Constitution, some powers belong to the states. What is one power of the states?",
            nepaliText: "हाम्रो संविधान अनुसार, केही शक्तिहरू राज्यहरूको हुन्छ। राज्यहरूको एउटा शक्ति के हो?",
            englishOptions: ["To make treaties", "To create an army", "To print money", "Establish and run public schools"],
            nepaliOptions: ["सन्धिहरू बनाउन", "सेना स्थापना गर्न", "पैसा छाप्न", "सार्वजनिक विद्यालयहरू स्थापना र सञ्चालन गर्ने"],
            correctAnswer: 3
        ),

        BilingualQuestion(
            englishText: "Who is the Commander in Chief of the military?",
            nepaliText: "सेनाको प्रधान सेनापति को हुन्?",
            englishOptions: ["The President", "The Vice President", "The Secretary of Defense", "The Speaker of the House"],
            nepaliOptions: ["राष्ट्रपति", "उपराष्ट्रपति", "रक्षा सचिव", "प्रतिनिधि सभाका सभामुख"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "What are two rights in the Declaration of Independence?",
            nepaliText: "स्वतन्त्रता घोषणापत्रमा उल्लेखित दुई अधिकार के हुन्?",
            englishOptions: ["Right to bear arms & right to vote", "Right to work & right to protest", "Life and Liberty", "Freedom of speech & freedom of religion"],
            nepaliOptions: ["हतियार बोक्ने अधिकार र मतदान गर्ने अधिकार", "काम गर्ने अधिकार र विरोध गर्ने अधिकार", "जीवन र स्वतन्त्रता", "बोल्ने स्वतन्त्रता र धर्मको स्वतन्त्रता"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "What is the ‘rule of law’?",
            nepaliText: "‘कानुनको शासन’ के हो?",
            englishOptions: ["The government can ignore laws", "No one is above the law", "Only federal judges follow the law", "The Constitution is not legally binding"],
            nepaliOptions: ["सरकारले कानुन बेवास्ता गर्न सक्छ", "कुनै पनि व्यक्ति कानुनभन्दा माथि छैन", "सिर्फ संघीय न्यायाधीशहरूले कानुन पालन गर्छन्", "संविधान कानुनी रूपमा बाध्यकारी छैन"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "What does the judicial branch do?",
            nepaliText: "न्यायिक शाखाले के गर्छ?",
            englishOptions: ["Makes laws", "Interprets the law", "Elects the President", "Controls the military"],
            nepaliOptions: ["कानुन बनाउँछ", "कानुनको व्याख्या गर्छ", "राष्ट्रपति चयन गर्छ", "सेनालाई नियन्त्रण गर्छ"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "There are four amendments to the Constitution about who can vote. Describe one of them.",
            nepaliText: "मतदान गर्न सक्ने व्यक्तिहरूसम्बन्धी संविधानमा चार संशोधनहरू छन्। तीमध्ये एउटा वर्णन गर्नुहोस्।",
            englishOptions: ["Only landowners can vote", "Only white men can vote", "Citizens 18 and older can vote", "Voting is mandatory"],
            nepaliOptions: ["सिर्फ जग्गाधनीहरू मतदान गर्न सक्छन्", "सिर्फ गोरा पुरुषहरूले मतदान गर्न सक्छन्", "१८ वर्ष वा सोभन्दा माथिका नागरिकहरूले मतदान गर्न सक्छन्", "मतदान अनिवार्य छ"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "Why do some states have more Representatives than other states?",
            nepaliText: "केही राज्यहरूमा अन्य राज्यहरूभन्दा धेरै प्रतिनिधिहरू किन छन्?",
            englishOptions: ["Because they are bigger", "Because they have more people", "Because they were part of the original 13 colonies", "Because they have more senators"],
            nepaliOptions: ["किनभने तिनीहरू ठूला छन्", "किनभने तिनीहरूको जनसंख्या बढी छ", "किनभने तिनीहरू मूल १३ उपनिवेशहरूको भाग थिए", "किनभने तिनीहरूसँग बढी सिनेटरहरू छन्"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "What was the main concern of the United States during the Cold War?",
            nepaliText: "शीत युद्धको समयमा संयुक्त राज्य अमेरिकाको मुख्य चिन्ता के थियो?",
            englishOptions: ["Nuclear disarmament", "Terrorism", "The spread of communism", "World War III"],
            nepaliOptions: ["परमाणु निःशस्त्रीकरण", "आतंकवाद", "साम्यवादको फैलावट", "तेस्रो विश्वयुद्ध"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "What major event happened on September 11, 2001, in the United States?",
            nepaliText: "सेप्टेम्बर ११, २००१ मा संयुक्त राज्य अमेरिकामा के ठूलो घटना भयो?",
            englishOptions: ["The U.S. declared war on Iraq", "Terrorists attacked the United States", "The Great Recession began", "Hurricane Katrina struck"],
            nepaliOptions: ["संयुक्त राज्यले इराकसँग युद्ध घोषणा गर्यो", "आतंकवादीहरूले संयुक्त राज्य अमेरिकामा आक्रमण गरे", "महामन्दी सुरु भयो", "हरिकेन कट्रीना आयो"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "What are two rights of everyone living in the United States?",
            nepaliText: "संयुक्त राज्य अमेरिकामा बस्ने सबै व्यक्तिहरूका दुई अधिकार के हुन्?",
            englishOptions: ["Right to vote & right to work", "Freedom of speech & freedom of religion", "Right to own land & right to healthcare", "Right to drive & right to a free education"],
            nepaliOptions: ["मतदान गर्ने अधिकार र काम गर्ने अधिकार", "बोल्ने स्वतन्त्रता र धर्मको स्वतन्त्रता", "जग्गा स्वामित्वको अधिकार र स्वास्थ्य सेवाको अधिकार", "गाडी चलाउने अधिकार र निःशुल्क शिक्षाको अधिकार"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "What did the Civil Rights Movement do?",
            nepaliText: "नागरिक अधिकार आन्दोलनले के गर्यो?",
            englishOptions: ["Fought for women’s rights", "Fought for workers' rights", "Fought for U.S. independence", "Fought for the end of segregation and racial discrimination"],
            nepaliOptions: ["महिलाको अधिकारको लागि लडाइँ गर्यो", "जातीय विभाजन र भेदभाव अन्त्य गर्न लडाइँ गर्यो", "संयुक्त राज्यको स्वतन्त्रताका लागि लडाइँ गर्यो", "कामदारहरूको अधिकारको लागि लडाइँ गर्यो"],
            correctAnswer: 3
        ),
        BilingualQuestion(
            englishText: "What is one promise you make when you become a U.S. citizen?",
            nepaliText: "तपाईं संयुक्त राज्यको नागरिक हुँदा गर्ने एउटा वाचा के हो?",
            englishOptions: ["To always vote", "To support your birth country", "To obey U.S. laws", "To join the U.S. military"],
            nepaliOptions: ["सधैं मतदान गर्ने", "आफ्नो जन्मभूमिलाई समर्थन गर्ने", "संयुक्त राज्यको कानुन मान्ने", "संयुक्त राज्यको सैन्य सेवामा सामेल हुने"],
            correctAnswer: 2
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
                    Text(quizLogic.selectedLanguage == .english ? "Practice 5" : "अभ्यास ५")
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
