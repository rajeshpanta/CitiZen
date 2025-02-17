import SwiftUI

struct अभ्यास4: View {
    @StateObject var quizLogic = Quizतर्क()
    @State private var selectedAnswer: Int? = nil
    @State private var showAnswerFeedback: Bool = false
    @State private var isAnswerCorrect: Bool = false
    
    @State private var showQuitConfirmation: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var isAnswered: Bool = false
    
    let questions: [BilingualQuestion] = [
        BilingualQuestion(
            englishText: "What was the main purpose of the Federalist Papers?",
            nepaliText: "फेडेरलिस्ट पत्रहरूको मुख्य उद्देश्य के थियो?",
            englishOptions: ["To declare independence from Britain", "To promote the ratification of the U.S. Constitution", "To outline the Bill of Rights", "To establish a national bank"],
            nepaliOptions: ["बेलायतबाट स्वतन्त्रता घोषणा गर्न", "अमेरिकी संविधानको अनुमोदन प्रवर्धन गर्न", "अधिकार विधेयकको रूपरेखा प्रस्तुत गर्न", "राष्ट्रिय बैंक स्थापना गर्न"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "Which amendment abolished slavery?",
            nepaliText: "कुन संशोधनले दासत्व अन्त्य गर्यो?",
            englishOptions: ["13th Amendment", "14th Amendment", "15th Amendment", "19th Amendment"],
            nepaliOptions: ["तेह्रौं संशोधन", "चौधौं संशोधन", "पन्ध्रौं संशोधन", "उन्नाइसौं संशोधन"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "What landmark case established judicial review?",
            nepaliText: "कुन ऐतिहासिक मुद्दाले न्यायिक समीक्षा स्थापित गर्यो?",
            englishOptions: ["Marbury v. Madison", "Brown v. Board of Education", "Roe v. Wade", "McCulloch v. Maryland"],
            nepaliOptions: ["मार्बरी बनाम म्याडिसन", "ब्राउन बनाम शिक्षा बोर्ड", "रो बनाम वेड", "म्याक्कालक बनाम मेरील्यान्ड"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "What is the maximum number of years a President can serve?",
            nepaliText: "राष्ट्रपति कति वर्षसम्म सेवा गर्न सक्छन्?",
            englishOptions: ["4 years", "8 years", "10 years", "12 years"],
            nepaliOptions: ["४ वर्ष", "८ वर्ष", "१० वर्ष", "१२ वर्ष"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "What war was fought between the North and South in the U.S.?",
            nepaliText: "संयुक्त राज्य अमेरिकामा उत्तर र दक्षिणबीच भएको युद्ध कुन थियो?",
            englishOptions: ["Revolutionary War", "World War I", "The Civil War", "The War of 1812"],
            nepaliOptions: ["क्रान्तिकारी युद्ध", "पहिलो विश्वयुद्ध", "गृहयुद्ध", "१८१२ को युद्ध"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "What was the main reason the U.S. entered World War II?",
            nepaliText: "संयुक्त राज्य अमेरिका दोस्रो विश्वयुद्धमा प्रवेश गर्ने मुख्य कारण के थियो?",
            englishOptions: ["To support Britain and France", "To stop the spread of communism", "The attack on Pearl Harbor", "To defend against Germany"],
            nepaliOptions: ["बेलायत र फ्रान्सलाई समर्थन गर्न", "साम्यवादको विस्तार रोक्न", "पर्ल हार्बरमा भएको आक्रमण", "जर्मनीको विरुद्ध रक्षा गर्न"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "What did the Monroe Doctrine declare?",
            nepaliText: "मोनरो सिद्धान्तले के घोषणा गर्यो?",
            englishOptions: ["Europe should not interfere in the Americas", "Slavery is abolished", "The U.S. must remain neutral in global conflicts", "The Louisiana Purchase is legal"],
            nepaliOptions: ["युरोपले अमेरिकामा हस्तक्षेप गर्नु हुँदैन", "दासत्व समाप्त गरियो", "संयुक्त राज्यले विश्वव्यापी द्वन्द्वमा तटस्थ रहनु पर्छ", "ल्यूसियाना खरिद वैध छ"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "Which U.S. President served more than two terms?",
            nepaliText: "कुन अमेरिकी राष्ट्रपतिले दुई कार्यकाल भन्दा बढी सेवा गरे?",
            englishOptions: ["George Washington", "Theodore Roosevelt", "Franklin D. Roosevelt", "Dwight D. Eisenhower"],
            nepaliOptions: ["जर्ज वाशिंगटन", "थियोडोर रूजवेल्ट", "फ्र्याङ्कलिन डी. रूजवेल्ट", "ड्वाइट डी. आइजनहावर"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "What is the term length for a Supreme Court Justice?",
            nepaliText: "सर्वोच्च अदालतको न्यायाधीशको कार्यकाल कति हुन्छ?",
            englishOptions: ["4 years", "8 years", "12 years", "Life"],
            nepaliOptions: ["४ वर्ष", "१२ वर्ष", "८ वर्ष", "जीवनभरि"],
            correctAnswer: 3
        ),

        BilingualQuestion(
            englishText: "Who was the Chief Justice of the Supreme Court in 2023?",
            nepaliText: "सन् २०२३ मा सर्वोच्च अदालतका प्रधान न्यायाधीश को थिए?",
            englishOptions: ["John G. Roberts", "Clarence Thomas", "Sonia Sotomayor", "Amy Coney Barrett"],
            nepaliOptions: ["जोहन जी. रोबर्ट्स", "क्लरेन्स थोमस", "सोनिया सोतोमयोर", "एमी कोनी ब्यारेट"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "Which branch of government has the power to declare war?",
            nepaliText: "सरकारको कुन शाखासँग युद्ध घोषणा गर्ने अधिकार छ?",
            englishOptions: ["The President", "The Supreme Court", "Congress", "The Vice President"],
            nepaliOptions: ["राष्ट्रपति", "सर्वोच्च अदालत", "कांग्रेस", "उपराष्ट्रपति"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "What was the purpose of the Marshall Plan?",
            nepaliText: "मार्शल योजनाको उद्देश्य के थियो?",
            englishOptions: ["To rebuild Europe after World War II", "To prevent communism in the U.S.", "To provide U.S. military aid", "To negotiate peace with Japan"],
            nepaliOptions: ["दोस्रो विश्वयुद्धपछि युरोप पुनर्निर्माण गर्न", "संयुक्त राज्य अमेरिकामा साम्यवाद रोक्न", "संयुक्त राज्य सैन्य सहायता प्रदान गर्न", "जापानसँग शान्ति सम्झौता गर्न"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "Which constitutional amendment granted women the right to vote?",
            nepaliText: "कुन संवैधानिक संशोधनले महिलाहरूलाई मतदान अधिकार प्रदान गर्यो?",
            englishOptions: ["15th Amendment", "19th Amendment", "21st Amendment", "26th Amendment"],
            nepaliOptions: ["पन्ध्रौं संशोधन", "उन्नाइसौं संशोधन", "एक्काइसौं संशोधन", "छब्बिसौं संशोधन"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "Which U.S. state was an independent republic before joining the Union?",
            nepaliText: "संयुक्त राज्य अमेरिकामा सामेल हुनुअघि कुन राज्य स्वतन्त्र गणतन्त्र थियो?",
            englishOptions: ["Hawaii", "California", "Texas", "Alaska"],
            nepaliOptions: ["हवाई", "क्यालिफोर्निया", "टेक्सास", "अलास्का"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "Who was President during the Great Depression and World War II?",
            nepaliText: "महामन्दी र दोस्रो विश्वयुद्धको समयमा राष्ट्रपति को थिए?",
            englishOptions: ["Woodrow Wilson", "Herbert Hoover", "Franklin D. Roosevelt", "Harry Truman"],
            nepaliOptions: ["वुड्रो विल्सन", "हर्बर्ट हूवर", "फ्र्याङ्कलिन डी. रूजवेल्ट", "ह्यारी ट्रुम्यान"],
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
                        Text(isAnswerCorrect ? "✅ \(quizLogic.selectedLanguage == .english ? "Correct!" : "सही!")" : "❌ \(quizLogic.selectedLanguage == .english ? "Wrong!" : "गलत!")")
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
                    Text(quizLogic.selectedLanguage == .english ? "Practice 4" : "अभ्यास ४")
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
