import SwiftUI

struct अभ्यास1: View {
    @StateObject var quizLogic = Quizतर्क() // ✅ Using the new Quiz Logic
    @State private var selectedAnswer: Int? = nil
    @State private var showAnswerFeedback: Bool = false
    @State private var isAnswerCorrect: Bool = false
    
    @State private var showQuitConfirmation: Bool = false // ✅ Quit confirmation pop-up
    @Environment(\.presentationMode) var presentationMode // ✅ For navigation back
    @State private var isAnswered: Bool = false // ✅ Prevents multiple answers
    
    
    let questions: [BilingualQuestion] = [
        BilingualQuestion(
            englishText: "What is the supreme law of the land?",
            nepaliText: "देशको सर्वोच्च कानुन के हो?",
            englishOptions: ["The Bill of Rights", "The Declaration", "The Constitution", "The Articles"],
            nepaliOptions: ["अधिकारको विधेयक", "घोषणा", "संविधान", "लेखहरू"],
            correctAnswer: 2
        ),
        
        BilingualQuestion(
            englishText: "Who makes federal laws?",
            nepaliText: "संघीय कानूनहरू को बनाउँछ?",
            englishOptions: ["The President", "Congress", "The Supreme Court", "The Military"],
            nepaliOptions: ["राष्ट्रपति", "कांग्रेस", "सर्वोच्च अदालत", "सैन्य"],
            correctAnswer: 1
        ),
        
        BilingualQuestion(
            englishText: "What are the two parts of the U.S. Congress?",
            nepaliText: "अमेरिकी काँग्रेसका दुई भागहरू कुन-कुन हुन्?",
            englishOptions: ["The Senate & The House", "The House & The President", "The Senate & The Cabinet", "The Military & The President"],
            nepaliOptions: ["सेनेट र प्रतिनिधि सभा", "प्रतिनिधि सभा र राष्ट्रपति", "सेनेट र मन्त्रिपरिषद", "सैन्य र राष्ट्रपति"],
            correctAnswer: 0
        ),
        
        BilingualQuestion(
            englishText: "What is the capital of the United States?",
            nepaliText: "संयुक्त राज्य अमेरिकाको राजधानी के हो?",
            englishOptions: ["New York", "Washington D.C.", "Los Angeles", "Chicago"],
            nepaliOptions: ["न्यूयोर्क", "वाशिङ्टन डी.सी.", "लस एन्जलस", "शिकागो"],
            correctAnswer: 1
        ),
        
        BilingualQuestion(
            englishText: "What are the two major political parties?",
            nepaliText: "दुई प्रमुख राजनीतिक दलहरू कुन-कुन हुन्?",
            englishOptions: ["Democrats & Libertarian", "Federalists & Republicans", "Libertarian & Tories", "Democrats & Republicans"],
            nepaliOptions: ["डेमोक्र्याट्स र लिबर्टेरियन", "फेडेरलिस्ट्स र रिपब्लिकनहरू", "लिबर्टेरियन र टोरीहरू", "डेमोक्र्याट्स र रिपब्लिकनहरू"],
            correctAnswer: 3
        ),
        
        BilingualQuestion(
            englishText: "What color are the stars on the American flag?",
            nepaliText: "अमेरिकी झण्डाका ताराहरू कुन रंगका हुन्छन्?",
            englishOptions: ["Blue", "White", "Red", "Yellow"],
            nepaliOptions: ["नीलो", "सेतो", "रातो", "पहेंलो"],
            correctAnswer: 1
        ),
        
        BilingualQuestion(
            englishText: "How many states are there in the United States?",
            nepaliText: "संयुक्त राज्य अमेरिकामा कति वटा राज्यहरू छन्?",
            englishOptions: ["51", "49", "52", "50"],
            nepaliOptions: ["५१", "४९", "५२", "५०"],
            correctAnswer: 3
        ),
        
        BilingualQuestion(
            englishText: "What is the name of the President of the United States?",
            nepaliText: "संयुक्त राज्य अमेरिकाका राष्ट्रपति को हुन्?",
            englishOptions: ["Joe Biden", "George Bush", "Barack Obama", "Donald J. Trump"],
            nepaliOptions: ["जो बाइडेन", "जर्ज बुश", "बराक ओबामा", "डोनाल्ड जे. ट्रम्प"],
            correctAnswer: 3
        ),
        
        BilingualQuestion(
            englishText: "What is the name of the Vice President of the United States?",
            nepaliText: "संयुक्त राज्य अमेरिकाका उपराष्ट्रपति को हुन्?",
            englishOptions: ["Kamala Harris", "Mike Pence", "Nancy Pelosi", "JD Vance"],
            nepaliOptions: ["कमला ह्यारिस", "माइक पेन्स", "न्यान्सी पेलोसी", "जेडि भेन्स"],
            correctAnswer: 3
        ),
        
        BilingualQuestion(
            englishText: "What is one right in the First Amendment?",
            nepaliText: "प्रथम संशोधनमा रहेको एउटा अधिकार के हो?",
            englishOptions: ["Freedom to travel", "Right to vote", "Freedom of speech", "Right to education"],
            nepaliOptions: ["यात्रा गर्ने स्वतन्त्रता", "मतदान गर्ने अधिकार", "बोल्ने स्वतन्त्रता", "शिक्षा प्राप्त गर्ने अधिकार"],
            correctAnswer: 2
        ),
        
        BilingualQuestion(
            englishText: "What do we celebrate on July 4th?",
            nepaliText: "हामी जुलाई ४ मा के मनाउँछौं?",
            englishOptions: ["Memorial Day", "Independence Day", "Labor Day", "Thanksgiving"],
            nepaliOptions: ["स्मृति दिवस", "स्वतन्त्रता दिवस", "श्रम दिवस", "धन्यबाद दिवस"],
            correctAnswer: 1
        ),
        
        BilingualQuestion(
            englishText: "Who is the Commander in Chief of the military?",
            nepaliText: "सैन्य प्रमुख कमाण्डर को हुन्?",
            englishOptions: ["The President", "The Vice President", "The Senate", "The Supreme Court"],
            nepaliOptions: ["राष्ट्रपति", "उपराष्ट्रपति", "सेनेट", "सर्वोच्च अदालत"],
            correctAnswer: 0
        ),
        
        BilingualQuestion(
            englishText: "What is the name of the national anthem?",
            nepaliText: "राष्ट्रिय गानको नाम के हो?",
            englishOptions: ["This Land is Your Land", "God Bless America", "America the Beautiful", "The Star-Spangled Banner"],
            nepaliOptions: ["यो भूमि तिमीहरूको हो", "भगवानले अमेरिका रक्षा गरुन", "अमेरिका सुन्दर छ", "द स्टार स्पैङ्गल्ड ब्यानर"],
            correctAnswer: 3
        ),
        
        BilingualQuestion(
            englishText: "What do the 13 stripes on the U.S. flag represent?",
            nepaliText: "अमेरिकी झण्डामा रहेका १३ वटा धर्साहरू के प्रतिनिधित्व गर्छन्?",
            englishOptions: ["The 13 amendments", "The number of wars", "The 13 states", "The original 13 colonies"],
            nepaliOptions: ["१३ वटा संशोधनहरू", "युद्धहरूको संख्या", "१३ राज्यहरू", "मौलिक १३ उपनिवेशहरू"],
            correctAnswer: 3
        ),
        
        BilingualQuestion(
            englishText: "What is the highest court in the United States?",
            nepaliText: "संयुक्त राज्य अमेरिकाको सबैभन्दा उच्च अदालत कुन हो?",
            englishOptions: ["The Supreme Court", "The Federal Court", "The Court of Appeals", "The Civil Court"],
            nepaliOptions: ["सर्वोच्च अदालत", "संघीय अदालत", "अपिल अदालत", "नागरिक अदालत"],
            correctAnswer: 0
        )
    ]
    
    
    var body: some View {
        ScrollView { // ✅ Enables scrolling
            VStack(spacing: 20) {
                // ✅ Language Selection Toggle
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
                    // ✅ Quiz Completion View
                    Text(quizLogic.selectedLanguage == .english ? "Quiz Completed!" : "क्विज समाप्त भयो!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text(quizLogic.selectedLanguage == .english ? "Correct Answers: \(quizLogic.correctAnswers)" : "सही उत्तरहरू: \(quizLogic.correctAnswers)")
                        .foregroundColor(.green)
                    Text(quizLogic.selectedLanguage == .english ? "Incorrect Answers: \(quizLogic.incorrectAnswers)" : "गलत उत्तरहरू: \(quizLogic.incorrectAnswers)")
                        .foregroundColor(.red)
                    
                    Button(quizLogic.selectedLanguage == .english ? "Restart Quiz" : "पुन: सुरु गर्नुहोस्") {
                        quizLogic.startQuiz() // ✅ Reset & shuffle quiz
                        selectedAnswer = nil
                        showAnswerFeedback = false
                        isAnswered = false
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                } else {
                    // ✅ Current Question View
                    Text("\(quizLogic.currentQuestionIndex + 1). \(quizLogic.selectedLanguage == .english ? quizLogic.currentQuestion.englishText : quizLogic.currentQuestion.nepaliText)")
                        .font(.title).bold()
                        .foregroundColor(.white)
                        .padding()
                        .padding(.bottom, 20)
                    
                    // ✅ Show options based on selected language
                    ForEach(0..<quizLogic.currentQuestion.englishOptions.count, id: \.self) { index in
                        Button(action: {
                            if !isAnswered { // ✅ Prevent multiple answers
                                selectedAnswer = index
                                isAnswerCorrect = quizLogic.answerQuestion(index)
                                showAnswerFeedback = true
                                isAnswered = true // ✅ Locks the answer after first attempt
                            }
                        }) {
                            Text(quizLogic.selectedLanguage == .english ?
                                 quizLogic.currentQuestion.englishOptions[index] :
                                    quizLogic.currentQuestion.nepaliOptions[index]) // ✅ Show correct language
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(
                                isAnswered
                                ? (index == quizLogic.currentQuestion.correctAnswer ? Color.green : Color.red) // ✅ Lock color after answer
                                : Color.blue
                            )
                            .cornerRadius(10)
                        }
                        .disabled(isAnswered) // ✅ Disable button after first selection
                    }
                    
                    if showAnswerFeedback {
                        // ✅ Answer Feedback View
                        Text(isAnswerCorrect ? "✅ \(quizLogic.selectedLanguage == .english ? "Correct!" : "सही!")" : "❌ \(quizLogic.selectedLanguage == .english ? "Wrong!" : "गलत!")")
                            .font(.headline)
                            .foregroundColor(isAnswerCorrect ? .green : .red)
                            .padding()
                        
                        Button(quizLogic.selectedLanguage == .english ? "Next Question" : "अर्को प्रश्न") {
                            quizLogic.moveToNextQuestion()
                            showAnswerFeedback = false
                            selectedAnswer = nil
                            isAnswered = false // ✅ Reset for new question
                        }
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                    } else {
                        // ✅ Previous, Skip, and Next Buttons
                        HStack {
                            // Previous Question Button
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
                            
                            // Skip Question Button
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
                            .disabled(quizLogic.showResult) // ✅ Prevent skipping if quiz is done
                        }
                        
                        .padding()
                    }
                    
                }
            }
        }
            .navigationBarBackButtonHidden(true) // ✅ Disables the back button
            .padding()
            .onAppear {
                quizLogic.questions = questions // ✅ Ensure questions are assigned first
                quizLogic.startQuiz() // ✅ Now shuffle and reset
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // ✅ Full-screen coverage
            .background(
                Image("USANepal") // ✅ Background image for bilingual quiz
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .overlay(Color.black.opacity(0.8))
            )
        
            .toolbar {
                ToolbarItem(placement: .principal) { // ✅ Dynamic Title Based on Language
                    Text(quizLogic.selectedLanguage == .english ? "Practice 1" : "अभ्यास १")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    }
                }
            .navigationBarItems(trailing:
            Button(action: {
                showQuitConfirmation = true // ✅ Show confirmation pop-up
            }) {
                Text(quizLogic.selectedLanguage == .english ? "Quit" : "छोड्नुहोस्")
                    .foregroundColor(.red)
                    .font(.title)
            }
            )
            // ✅ Quit Confirmation Alert
            .alert(isPresented: $showQuitConfirmation) {
                Alert(
                    title: Text(quizLogic.selectedLanguage == .english ? "Quit Quiz?" : "क्विज छोड्नुहुन्छ?"),
                    message: Text(quizLogic.selectedLanguage == .english ? "Are you sure you want to quit?" : "के तपाईँ पक्का छोड्न चाहनुहुन्छ?"),
                    primaryButton: .destructive(Text(quizLogic.selectedLanguage == .english ? "Yes" : "हो")) {
                        presentationMode.wrappedValue.dismiss() // ✅ Navigate back to PracticeSelection
                    },
                    secondaryButton: .cancel(Text(quizLogic.selectedLanguage == .english ? "No" : "होइन")) // ✅ Resume quiz
                )
            }
        }
    }
