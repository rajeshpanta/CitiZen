import SwiftUI

struct Practice5: View {
    @StateObject var quizLogic = QuizLogic()
    @State private var selectedAnswer: Int? = nil
    @State private var showAnswerFeedback: Bool = false
    @State private var isAnswerCorrect: Bool = false
    @State private var navigateToPracticeSelection = false
    
    @State private var showQuitConfirmation: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var isAnswered: Bool = false
    
    let questions: [Question] = [
        Question(text: "The House of Representatives has how many voting members?",
                 options: ["100", "435", "50", "200"],
                 correctAnswer: 1),

        Question(text: "If both the President and the Vice President can no longer serve, who becomes President?",
                 options: ["The Speaker of the House", "The Chief Justice", "The Secretary of State", "The Senate Majority Leader"],
                 correctAnswer: 0),

        Question(text: "Under the Constitution, some powers belong to the federal government. What is one power of the federal government?",
                 options: ["To issue driver’s licenses", "To create an army", "To set up schools", "To regulate marriages"],
                 correctAnswer: 1),

        Question(text: "Under our Constitution, some powers belong to the states. What is one power of the states?",
                 options: ["To make treaties", "To create an army", "To print money", "Establish and run public schools"],
                 correctAnswer: 3),

        Question(text: "Who is the Commander in Chief of the military?",
                 options: ["The President", "The Vice President", "The Secretary of Defense", "The Speaker of the House"],
                 correctAnswer: 0),

        Question(text: "What are two rights in the Declaration of Independence?",
                 options: ["Right to bear arms & right to vote", "Right to work & right to protest", "Life and Liberty", "Freedom of speech & freedom of religion"],
                 correctAnswer: 2),

        Question(text: "What is the ‘rule of law’?",
                 options: ["The government can ignore laws", "No one is above the law", "Only federal judges follow the law", "The Constitution is not legally binding"],
                 correctAnswer: 1),

        Question(text: "What does the judicial branch do?",
                 options: ["Makes laws", "Controls the military", "Elects the President", "Interprets the law"],
                 correctAnswer: 3),

        Question(text: "There are four amendments to the Constitution about who can vote. Describe one of them.",
                 options: ["Only landowners can vote", "Only white men can vote", "Citizens 18 and older can vote", "Voting is mandatory"],
                 correctAnswer: 2),

        Question(text: "Why do some states have more Representatives than other states?",
                 options: ["Because they are bigger", "Because they have more people", "Because they were part of the original 13 colonies", "Because they have more senators"],
                 correctAnswer: 1),

        Question(text: "What was the main concern of the United States during the Cold War?",
                 options: ["Nuclear disarmament", "Terrorism", "Communism", "World War III"],
                 correctAnswer: 2),

        Question(text: "What major event happened on September 11, 2001, in the United States?",
                 options: ["Terrorists attacked the United States", "The U.S. declared war on Iraq", "The Great Recession began", "Hurricane Katrina struck"],
                 correctAnswer: 0),

        Question(text: "What are two rights of everyone living in the United States?",
                 options: ["Right to vote & right to work", "Right to drive & right to a free education", "Right to own land & right to healthcare", "Freedom of speech & freedom of religion"],
                 correctAnswer: 3),

        Question(text: "What did the Civil Rights Movement do?",
                 options: ["Fought for women’s rights", "Fought for the end of segregation and racial discrimination", "Fought for U.S. independence", "Fought for workers' rights"],
                 correctAnswer: 1),

        Question(text: "What is one promise you make when you become a U.S. citizen?",
                 options: ["To always vote", "To support your birth country", "To obey U.S. laws", "To join the U.S. military"],
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
                    
                    // Display Answer Options
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
                    Text("Practice 5")
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
