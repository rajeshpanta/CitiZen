import SwiftUI

struct Practice2: View {
    @StateObject var quizLogic = QuizLogic()
    @State private var selectedAnswer: Int? = nil
    @State private var showAnswerFeedback: Bool = false
    @State private var isAnswerCorrect: Bool = false
    
    @State private var showQuitConfirmation: Bool = false
    @State private var isAnswered: Bool = false
     @Environment(\.presentationMode) var presentationMode

    
    let questions: [Question] = [
        Question(text: "Who wrote the Declaration of Independence?", options: ["George Washington", "Abraham Lincoln", "Benjamin Franklin", "Thomas Jefferson"],
                 correctAnswer: 3),
        
        Question(text: "How many U.S. Senators are there?", options: ["50", "100", "435", "200"],
                 correctAnswer: 1),
        
        Question(text: "How long is a term for a U.S. Senator?", options: ["4 years", "2 years", "6 years", "8 years"],
                 correctAnswer: 2),
        
        Question(text: "What is one responsibility of a U.S. citizen?", options: ["Vote in elections", "Own a business", "Pay for health insurance", "Travel abroad"],
                 correctAnswer: 0),
        
        Question(text: "Who is the Father of Our Country?", options: ["George Washington", "Thomas Jefferson", "Abraham Lincoln", "John Adams"],
                 correctAnswer: 0),
        
        Question(text: "What is one promise you make when you become a U.S. citizen?", options: ["Speak only English", "Always vote in elections", "Get a college degree","Obey the laws of the United States"],
                 correctAnswer: 3),
        
        Question(text: "What ocean is on the West Coast of the United States?", options: ["Atlantic Ocean", "Pacific Ocean", "Indian Ocean", "Arctic Ocean"],
                 correctAnswer: 1),
        
        Question(text: "What is the economic system in the United States?", options: ["Socialism", "Communism", "Capitalism", "Monarchy"],
                 correctAnswer: 2),
        
        Question(text: "How many voting members are in the House of Representatives?", options: ["435", "100", "50", "200"],
                 correctAnswer: 0),
        
        Question(text: "What is the rule of law?", options: ["Everyone must follow the law", "The President is above the law", "Judges are above the law", "Only lawmakers follow the law"],
                 correctAnswer: 0),
        
        Question(text: "What is freedom of religion?", options: ["You can only practice major religions", "You must follow the government religion", "You can practice any religion, or not practice a religion", "You can never change your religion"],
                 correctAnswer: 2),
        
        Question(text: "What does the Constitution do?", options: ["Gives advice to the President", "Defines laws for voting", "Declares war", "Sets up the government"],
                 correctAnswer: 3),
        
        Question(text: "What stops one branch of government from becoming too powerful?", options: ["The Supreme Court", "The military", "The people", "Checks and balances"],
                 correctAnswer: 3),
        
        Question(text: "Name one branch or part of the government.", options: ["Congress", "Lawmakers", "Governors", "The Police"],
                 correctAnswer: 0),
        
        Question(text: "What is an amendment?", options: ["A law", "A change to the Constitution", "A government branch", "A tax"],
                 correctAnswer: 1)
    ]
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if quizLogic.showResult {
                    // Quiz Completion View
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
                        .font(.title).bold()
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
                            .padding()
                        
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
                    Text("Practice 2")
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
                                .font(.title)
                                .foregroundColor(.red)
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
