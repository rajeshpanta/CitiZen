import SwiftUI

struct अभ्यास3: View {
    @StateObject var quizLogic = Quizतर्क()
    @State private var selectedAnswer: Int? = nil
    @State private var showAnswerFeedback: Bool = false
    @State private var isAnswerCorrect: Bool = false
    
    @State private var showQuitConfirmation: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var isAnswered: Bool = false
    
    let questions: [BilingualQuestion] = [
        BilingualQuestion(
            englishText: "What do we call the first ten amendments to the Constitution?",
            nepaliText: "संविधानका पहिलो १० संशोधनहरूलाई के भनिन्छ?",
            englishOptions: ["The Declaration of Independence", "The Bill of Rights", "The Articles of Confederation", "The Federalist Papers"],
            nepaliOptions: ["स्वतन्त्रताको घोषणा-पत्र ", "अधिकारको विधेयक", "संघीय अनुच्छेद", "फेडेरलिस्ट पत्रहरू"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "What is the capital of your state?",
            nepaliText: "तपाईँको राज्यको राजधानी के हो?",
            englishOptions: ["Depends on your state", "New York", "Los Angeles", "Chicago"],
            nepaliOptions: ["तपाईँको राज्यमा भर पर्छ", "न्यूयोर्क", "लस एन्जलस", "शिकागो"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "Who was the first President of the United States?",
            nepaliText: "संयुक्त राज्य अमेरिकाका पहिलो राष्ट्रपति को थिए?",
            englishOptions: ["John Adams", "Thomas Jefferson", "George Washington", "Benjamin Franklin"],
            nepaliOptions: ["जोहन एडम्स", "थोमस जेफरसन", "जर्ज वाशिंगटन", "बेंजामिन फ्र्याङ्कलिन"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "What did the Emancipation Proclamation do?",
            nepaliText: "मुक्ति घोषणाले के गर्यो?",
            englishOptions: ["Ended the Civil War", "Freed the slaves", "Established a national bank", "Declared independence from Britain"],
            nepaliOptions: ["गृहयुद्ध समाप्त गर्यो", "दासहरूलाई स्वतन्त्र गर्यो", "राष्ट्रिय बैंक स्थापना गर्यो", "बेलायतबाट स्वतन्त्रता घोषणा गर्यो"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "Who is the Speaker of the House of Representatives now?",
            nepaliText: "हाल प्रतिनिधि सभाका सभामुख को हुन्?",
            englishOptions: ["Nancy Pelosi", "Kevin McCarthy", "Mitch McConnell", "Mike Johnson"],
            nepaliOptions: ["न्यान्सी पेलोसी", "केभिन म्याकार्थी", "मिच म्याककोनेल", "माइक जोन्सन"],
            correctAnswer: 3
        ),

        BilingualQuestion(
            englishText: "How many justices are on the Supreme Court?",
            nepaliText: "सर्वोच्च अदालतमा कति जना न्यायाधीशहरू छन्?",
            englishOptions: ["7", "9", "11", "13"],
            nepaliOptions: ["७", "९", "११", "१३"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "What did Susan B. Anthony do?",
            nepaliText: "सुसान बी. एन्थोनीले के गरिन्?",
            englishOptions: ["Fought for women's rights", "Wrote the Constitution", "Discovered America", "Became the first female President"],
            nepaliOptions: ["महिलाहरूका अधिकारका लागि लडिन्", "संविधान लेखिन्", "अमेरिका पत्ता लगाइन्", "पहिलो महिला राष्ट्रपति बनिन्"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "What movement tried to end racial discrimination?",
            nepaliText: "कुन आन्दोलनले जातीय भेदभाव अन्त्य गर्ने प्रयास गर्यो?",
            englishOptions: ["The Civil Rights Movement", "The Women's Movement", "The American Revolution", "The Abolitionist Movement"],
            nepaliOptions: ["नागरिक अधिकार आन्दोलन", "महिला आन्दोलन", "अमेरिकी क्रान्ति", "दास उन्मूलन आन्दोलन"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "What was one important thing that Abraham Lincoln did?",
            nepaliText: "अब्राहम लिंकनले गरेको एउटा महत्त्वपूर्ण काम के हो?",
            englishOptions: ["Established the U.S. Navy", "Freed the slaves", "Fought in the Revolutionary War", "Wrote the Bill of Rights"],
            nepaliOptions: ["संयुक्त राज्यको नौसेना स्थापना गरे", "दासहरूलाई स्वतन्त्र गराए", "क्रान्तिकारी युद्ध लडे", "अधिकारको विधेयक लेखे"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "Why does the U.S. flag have 50 stars?",
            nepaliText: "अमेरिकी झण्डामा ५० वटा तारा किन छन्?",
            englishOptions: ["For the 50 Presidents", "For the 50 states", "For the 50 amendments", "For the 50 years of independence"],
            nepaliOptions: ["५० जना राष्ट्रपतिहरूका लागि", "५० वटा राज्यहरूका लागि", "५० वटा संशोधनहरूका लागि", "५० वर्षको स्वतन्त्रताका लागि"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "When do we vote for President?",
            nepaliText: "हामी कहिले राष्ट्रपतिको लागि मतदान गर्छौं?",
            englishOptions: ["January", "March", "November", "December"],
            nepaliOptions: ["जनवरी", "मार्च", "नोभेम्बर", "डिसेम्बर"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "What is one reason colonists came to America?",
            nepaliText: "बेलायती उपनिवेशहरू किन अमेरिका आए?",
            englishOptions: ["To escape taxes", "Religious freedom", "To join the military", "To find gold"],
            nepaliOptions: ["करबाट बच्न", "धार्मिक स्वतन्त्रता", "सेनामा भर्ती हुन", "सुन खोज्न"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "Who wrote the Federalist Papers?",
            nepaliText: "फेडेरलिस्ट पत्रहरू कसले लेखे?",
            englishOptions: ["Thomas Jefferson", "James Madison, Alexander Hamilton, John Jay", "George Washington", "Ben Franklin"],
            nepaliOptions: ["थोमस जेफरसन", "जेम्स म्याडिसन, एलेक्जेन्डर ह्यामिल्टन, जोन जे", "जर्ज वाशिंगटन", "बेन फ्र्याङ्कलिन"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "Who was the President during World War I?",
            nepaliText: "प्रथम विश्वयुद्धको समयमा संयुक्त राज्य अमेरिकाका राष्ट्रपति को थिए?",
            englishOptions: ["Franklin D. Roosevelt", "Woodrow Wilson", "Harry Truman", "Dwight D. Eisenhower"],
            nepaliOptions: ["फ्र्याङ्कलिन डी. रूजवेल्ट", "वुड्रो विल्सन", "ह्यारी ट्रुम्यान", "ड्वाइट डी. आइजनहावर"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "What is one U.S. territory?",
            nepaliText: "संयुक्त राज्य अमेरिकाको एउटा क्षेत्र कुन हो?",
            englishOptions: ["Hawaii", "Puerto Rico", "Alaska", "Canada"],
            nepaliOptions: ["हवाई", "प्युर्टो रिको", "अलास्का", "क्यानडा"],
            correctAnswer: 1
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
                    Text(quizLogic.selectedLanguage == .english ? "Practice 3" : "अभ्यास ३")
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
