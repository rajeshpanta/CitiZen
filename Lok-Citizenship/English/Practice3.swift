import SwiftUI

struct Practice3: View {
    @StateObject var quizLogic = QuizLogic()
    @State private var selectedAnswer: Int? = nil
    @State private var showAnswerFeedback: Bool = false
    @State private var isAnswerCorrect: Bool = false
    
    @State private var showQuitConfirmation: Bool = false
     @Environment(\.presentationMode) var presentationMode
    @State private var isAnswered: Bool = false

    let questions: [Question] = [
        Question(text: "What do we call the first ten amendments to the Constitution?",
                 options: ["The Federalist Papers", "The Declaration of Independence", "The Articles of Confederation", "The Bill of Rights"],
                 correctAnswer: 3),

        Question(text: "What is the capital of your state?",
                 options: ["Depends on your state", "New York", "Los Angeles", "Chicago"],
                 correctAnswer: 0),

        Question(text: "Who was the first President of the United States?",
                 options: ["John Adams", "Thomas Jefferson", "George Washington", "Benjamin Franklin"],
                 correctAnswer: 2),

        Question(text: "What did the Emancipation Proclamation do?",
                 options: ["Ended the Civil War", "Freed the slaves", "Established a national bank", "Declared independence from Britain"],
                 correctAnswer: 1),

        Question(text: "Who is the Speaker of the House of Representatives now?",
                 options: ["Nancy Pelosi", "Kevin McCarthy", "Mitch McConnell", "Mike Johnson"],
                 correctAnswer: 3),

        Question(text: "How many justices are on the Supreme Court?",
                 options: ["7", "11", "9", "13"],
                 correctAnswer: 1),

        Question(text: "What did Susan B. Anthony do?",
                 options: ["Fought for women's rights", "Wrote the Constitution", "Discovered America", "Became the first female President"],
                 correctAnswer: 0),

        Question(text: "What movement tried to end racial discrimination?",
                 options: ["The Civil Rights Movement", "The Women's Movement", "The American Revolution", "The Abolitionist Movement"],
                 correctAnswer: 0),

        Question(text: "What was one important thing that Abraham Lincoln did?",
                 options: ["Established the U.S. Navy", "Freed the slaves", "Fought in the Revolutionary War", "Wrote the Bill of Rights"],
                 correctAnswer: 1),

        Question(text: "Why does the U.S. flag have 50 stars?",
                 options: ["For the 50 Presidents", "For the 50 years of independence", "For the 50 amendments", "For the 50 states"],
                 correctAnswer: 3),

        Question(text: "When do we vote for President?",
                 options: ["January", "March", "November", "December"],
                 correctAnswer: 2),

        Question(text: "What is one reason colonists came to America?",
                 options: ["To escape taxes", "To practice their religion freely", "To join the military", "To find gold"],
                 correctAnswer: 1),

        Question(text: "Who wrote the Federalist Papers?",
                 options: ["Thomas Jefferson", "James Madison, Alexander Hamilton, John Jay", "George Washington", "Ben Franklin"],
                 correctAnswer: 1),

        Question(text: "Who was the President during World War I?",
                 options: ["Harry Truman", "Woodrow Wilson", "Franklin D. Roosevelt", "Dwight D. Eisenhower"],
                 correctAnswer: 2),

        Question(text: "What is one U.S. territory?",
                 options: ["Alaska", "Puerto Rico", "Hawaii", "Canada"],
                 correctAnswer: 0)
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
                    Text("Practice 3")
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
