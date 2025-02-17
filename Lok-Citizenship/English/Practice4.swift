import SwiftUI

struct Practice4: View {
    @StateObject var quizLogic = QuizLogic()
    @State private var selectedAnswer: Int? = nil
    @State private var showAnswerFeedback: Bool = false
    @State private var isAnswerCorrect: Bool = false
    
    @State private var showQuitConfirmation: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var isAnswered: Bool = false
    
    
    let questions: [Question] = [
        Question(text: "What was the main purpose of the Federalist Papers?",
                 options: ["To declare independence from Britain", "To promote the ratification of the U.S. Constitution", "To outline the Bill of Rights", "To establish a national bank"],
                 correctAnswer: 1),

        Question(text: "Which amendment abolished slavery?",
                 options: ["13th Amendment", "14th Amendment", "15th Amendment", "19th Amendment"],
                 correctAnswer: 0),

        Question(text: "What landmark case established judicial review?",
                 options: ["Marbury v. Madison", "Brown v. Board of Education", "Roe v. Wade", "McCulloch v. Maryland"],
                 correctAnswer: 0),

        Question(text: "What is the maximum number of years a President can serve?",
                 options: ["4 years", "12 years", "2 years", "8 years"],
                 correctAnswer: 3),

        Question(text: "What war was fought between the North and South in the U.S.?",
                 options: ["Revolutionary War", "World War I", "The Civil War", "The War of 1812"],
                 correctAnswer: 2),

        Question(text: "What was the main reason the U.S. entered World War II?",
                 options: ["To support Britain and France", "To stop the spread of communism", "The attack on Pearl Harbor", "To defend against Germany"],
                 correctAnswer: 2),

        Question(text: "What did the Monroe Doctrine declare?",
                 options: ["Europe should not interfere in the Americas", "Slavery is abolished", "The U.S. must remain neutral in global conflicts", "The Louisiana Purchase is legal"],
                 correctAnswer: 0),

        Question(text: "Which U.S. President served more than two terms?",
                 options: ["George Washington", "Franklin D. Roosevelt", "Theodore Roosevelt", "Dwight D. Eisenhower"],
                 correctAnswer: 1),

        Question(text: "What is the term length for a Supreme Court Justice?",
                 options: ["4 years", "8 years", "12 years", "Life"],
                 correctAnswer: 3),

        Question(text: "Who is the Chief Justice of the Supreme Court?",
                 options: ["John Roberts", "Clarence Thomas", "Sonia Sotomayor", "Amy Coney Barrett"],
                 correctAnswer: 0),

        Question(text: "Which branch of government has the power to declare war?",
                 options: ["The President", "The Supreme Court", "Congress", "The Vice President"],
                 correctAnswer: 2),

        Question(text: "What was the purpose of the Marshall Plan?",
                 options: ["To rebuild Europe after World War II", "To prevent communism in the U.S.", "To provide U.S. military aid", "To negotiate peace with Japan"],
                 correctAnswer: 0),

        Question(text: "Which constitutional amendment granted women the right to vote?",
                 options: ["15th Amendment", "19th Amendment", "21st Amendment", "26th Amendment"],
                 correctAnswer: 1),

        Question(text: "Which U.S. state was an independent republic before joining the Union?",
                 options: ["Hawaii", "California", "Texas", "Alaska"],
                 correctAnswer: 2),

        Question(text: "Who was President during the Great Depression and World War II?",
                 options: ["Woodrow Wilson", "Herbert Hoover", "Franklin D. Roosevelt", "Harry Truman"],
                 correctAnswer: 2)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if quizLogic.showResult {
                    Text("Congratulations! You have completed the quiz!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("Correct Answers: \(quizLogic.correctAnswers)")
                        .foregroundColor(.green)
                    Text("Incorrect Answers: \(quizLogic.incorrectAnswers)")
                        .foregroundColor(.red)
                    
                    Button("Restart Quiz") {
                        quizLogic.startQuiz()
                        selectedAnswer = nil
                        showAnswerFeedback = false
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                } else {
                    Text("\(quizLogic.currentQuestionIndex + 1). \(quizLogic.currentQuestion.text)")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.bottom, 20)
                    
                    ForEach(0..<quizLogic.currentQuestion.options.count, id: \.self) { index in
                        Button(action: {
                            if !isAnswered {
                                selectedAnswer = index
                                isAnswerCorrect = quizLogic.answerQuestion(index)
                                showAnswerFeedback = true
                                isAnswered = true
                            }
                        }) {
                            Text(quizLogic.currentQuestion.options[index])
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
                        Text(isAnswerCorrect ? "Correct! 🎉" : "Wrong ❌")
                            .font(.headline)
                            .foregroundColor(isAnswerCorrect ? .green : .red)
                        
                        Button("Next Question") {
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
                            }) {
                                Text("Previous")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.gray)
                                    .cornerRadius(10)
                            }
                            .disabled(quizLogic.currentQuestionIndex == 0)
                            
                            Spacer()
                                .padding()
                            
                            Button(action: {
                                quizLogic.moveToNextQuestion()
                                selectedAnswer = nil
                                showAnswerFeedback = false
                            }) {
                                Text("Skip")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.orange)
                                    .cornerRadius(10)
                            }
                            .disabled(quizLogic.showResult)
                            
                            Spacer()
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
                Image("BackgroundImage")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .overlay(
                        Color.black.opacity(0.8)
                )
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Practice 4")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
            }
            .navigationBarItems(trailing:
                        Button(action: {
                            showQuitConfirmation = true
                        }) {
                            Text("Quit")
                                .foregroundColor(.red)
                                .font(.title)
                        }
                    )
                    .alert(isPresented: $showQuitConfirmation) {
                        Alert(
                            title: Text("Quit Quiz?"),
                            message: Text("Are you sure you want to quit?"),
                            primaryButton: .destructive(Text("Yes")) {
                                presentationMode.wrappedValue.dismiss()
                            },
                            secondaryButton: .cancel(Text("No"))
                        )
                    }
        }
    }
