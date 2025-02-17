import SwiftUI

struct Question {
    let text: String
    let options: [String]
    let correctAnswer: Int
}

struct Practice1: View {
    @StateObject var quizLogic = QuizLogic()
    @State private var selectedAnswer: Int? = nil
    @State private var showAnswerFeedback: Bool = false
    @State private var isAnswerCorrect: Bool = false
    
    @State private var showQuitConfirmation: Bool = false // ✅ State for quit pop-up
     @Environment(\.presentationMode) var presentationMode // ✅ Used for navigation back
    @State private var isAnswered: Bool = false // ✅ Prevents multiple answers


    
    let questions: [Question] = [
        Question(text: "What is the supreme law of the land?", options: ["The Bill of Rights", "The Declaration","The Constitution", "The Articles"],
                 correctAnswer: 2),
        
        Question(text: "Who makes federal laws?", options: ["The President", "Congress", "The Supreme Court", "The Military"],
                 correctAnswer: 1),
        
        Question(text: "What are the two parts of the U.S. Congress?", options: ["The Senate & The House", "The House & The President", "The Cabinet", "The Military"],
                 correctAnswer: 0),
        
        Question(text: "What is the capital of the United States?", options: ["New York", "Washington D.C.", "Los Angeles", "Chicago"],
                 correctAnswer: 1),
        
        Question(text: "What are the two major political parties?", options: ["Democrats & Libertarians", "Federalists & Republicans", "Libertarians & Tories", "Democrats & Republicans"],
                 correctAnswer: 3),
        
        Question(text: "What color are the stars on the American flag?", options: ["Blue", "White", "Red", "Yellow"],
                 correctAnswer: 1),
        
        Question(text: "How many states are there in the United States?", options: ["51", "49", "50", "52"],
                 correctAnswer: 2),
        
        Question(text: "What is the name of the President of the United States?", options: ["Donald J Trump", "George Bush", "Barack Obama", "Joe Biden"],
                 correctAnswer: 0),
        
        Question(text: "What is the name of the Vice President of the United States?", options: ["Kamala Harris", "Mike Pence", "Nancy Pelosi", "JD Vance"],
                 correctAnswer: 3),
        
        Question(text: "What is one right in the First Amendment?", options: ["Freedom to travel", "Right to vote","Freedom of speech", "Right to education"],
                 correctAnswer: 2),
        
        Question(text: "What do we celebrate on July 4th?", options: ["Memorial Day", "Independence Day", "Labor Day", "Thanksgiving"],
                 correctAnswer: 1),
        
        Question(text: "Who is the Commander in Chief of the military?", options: ["The President", "The Vice President", "The Senate", "The Supreme Court"],
                 correctAnswer: 0),
        
        Question(text: "What is the name of the national anthem?", options: ["This Land is Your Land", "God Bless America", "America the Beautiful","The Star-Spangled Banner"],
                 correctAnswer: 3),
        
        Question(text: "What do the 13 stripes on the flag represent?", options: ["The 13 amendments", "The number of wars", "The 13 states","The original 13 colonies"],
                 correctAnswer: 3),
        
        Question(text: "What is the highest court in the United States?", options: ["The Supreme Court", "The Federal Court", "The Court of Appeals", "The Civil Court"],
                 correctAnswer: 0)
    ]
    
    var body: some View {
        ScrollView { // ✅ Enables scrolling
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
                        quizLogic.startQuiz() // ✅ Use `startQuiz()` to reset & shuffle
                        selectedAnswer = nil
                        showAnswerFeedback = false
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
//                    NavigationLink(destination: Practice3()) { // ✅ Added NavigationLink
//                        Text("Next Level")
//                        .padding()
//                        .background(Color.green)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                    }
                    
                } else {
                    // Current Question View
                    Text("\(quizLogic.currentQuestionIndex + 1). \(quizLogic.currentQuestion.text)")
                        .font(.title).bold()
                        .foregroundColor(.white)
                        .padding()
                        .padding(.bottom, 20)
                    
                    // Display Answer Options
                    ForEach(0..<quizLogic.currentQuestion.options.count, id: \.self) { index in
                        Button(action: {
                            if !isAnswered { // ✅ Prevent multiple answers
                                selectedAnswer = index
                                isAnswerCorrect = quizLogic.answerQuestion(index)
                                showAnswerFeedback = true
                                isAnswered = true // ✅ Locks the answer after first attempt
                                
                            }
                            
                        }) {
                            Text(quizLogic.currentQuestion.options[index])
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
                        // Answer Feedback View
                        Text(isAnswerCorrect ? "Correct! 🎉" : "Wrong ❌")
                            .font(.headline)
                            .foregroundColor(isAnswerCorrect ? .green : .red)
                            .padding()
                        
                        Button("Next Question") {
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
                        // Previous, Skip, and Next Buttons
                        HStack {
                            // Previous Question Button
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
                            
                            // Skip Question Button
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
                            .disabled(quizLogic.showResult) // ✅ Prevent skipping if quiz is done
                            
                            Spacer()
                        }
                        .padding()
                    }
                }
            }
        }
            .navigationBarBackButtonHidden(true) // Disables the back button
            .padding()
            .onAppear {
                quizLogic.questions = questions // ✅ Ensure questions are assigned first
                quizLogic.startQuiz() // ✅ Now shuffle and reset
            }
        
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensure full-screen coverage
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
                ToolbarItem(placement: .principal) { // ✅ Center title in nav bar
                    Text("Practice 1")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green) // ✅ Set text color to green
                }
            }
        
            .navigationBarItems(trailing:
                        Button(action: {
                            showQuitConfirmation = true // ✅ Show confirmation pop-up
                        }) {
                            Text("Quit")
                                .font(.title)
                                .foregroundColor(.red)
                        }
                    )
                    // ✅ Quit Confirmation Alert
                    .alert(isPresented: $showQuitConfirmation) {
                        Alert(
                            title: Text("Quit Quiz?"),
                            message: Text("Are you sure you want to quit?"),
                            primaryButton: .destructive(Text("Yes")) {
                                presentationMode.wrappedValue.dismiss() // ✅ Navigate back to PracticeSelection
                            },
                            secondaryButton: .cancel(Text("No")) // ✅ Resume quiz
                        )
                    }
        }
    }
