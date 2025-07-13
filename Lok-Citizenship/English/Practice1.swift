import SwiftUI
import Combine
import AVFoundation
import Speech

struct Question {
    let text: String
    let options: [String]
    let correctAnswer: Int
}

struct Practice1: View {

    // 1 ▸ STATE & MODEL ──────────────────────────────────────
    @StateObject private var quizLogic = QuizLogic()

    @State private var selectedAnswer: Int?
    @State private var showAnswerFeedback = false
    @State private var isAnswerCorrect   = false
    @State private var isAnswered        = false

    // 2 ▸ ALERTS ─────────────────────────────────────────────
    enum ActiveAlert: Identifiable { case quit, permission; var id: Self { self } }
    @State private var activeAlert: ActiveAlert?
    @Environment(\.presentationMode) private var presentationMode

    // 3 ▸ LIVE TTS / STT ─────────────────────────────────────
    @State private var isSpeaking  = false
    @State private var isRecording = false
    @State private var transcription = ""
    @State private var authorizationStatus: SFSpeechRecognizerAuthorizationStatus = .notDetermined
    @State private var ttsChain: AnyCancellable?

    // 4 ▸ SERVICES ───────────────────────────────────────────
    private let tts = ServiceLocator.shared.ttsService
    private let stt = ServiceLocator.shared.sttService

    let questions: [Question] = [
                        Question(text: "What is the supreme law of the land?", options: ["The Bill of Rights", "The Declaration","The Constitution", "The Articles"],
                                 correctAnswer: 2),
                        
                        Question(text: "Who makes federal laws?", options: ["The President", "Congress", "The Supreme Court", "The Military"],
                                 correctAnswer: 1),
                        
                        Question(text: "What are the two parts of the U.S. Congress?", options: ["The Senate and The House", "The House and The President", "The Cabinet", "The Military"],
                                 correctAnswer: 0),
                        
                        Question(text: "What is the capital of the United States?", options: ["New York", "Washington D.C.", "Los Angeles", "Chicago"],
                                 correctAnswer: 1),
                        
                        Question(text: "What are the two major political parties?", options: ["Democrats and Libertarians", "Federalists and Republicans", "Libertarians and Tories", "Democrats and Republicans"],
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

    // 6 ▸ CONSTANTS ─────────────────────────────────────────
    private let locale      = "en-US"
    private let offlineOnly = true      // 100 % on-device STT

    // ─────────────────────────────────────────────────────────
    // MARK:  BODY
    // ─────────────────────────────────────────────────────────
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                /* live progress + counters */
                VStack {
                    ProgressView(value: Double(quizLogic.attemptedQuestions),
                                 total: Double(max(quizLogic.totalQuestions, 1)))
                        .accentColor(.green)
                    Text("\(quizLogic.attemptedQuestions)/\(quizLogic.totalQuestions)  •  "
                         + "Score \(quizLogic.scorePercentage)%")
                        .font(.subheadline).foregroundColor(.yellow)
                }
                .padding(.horizontal)

                questionHeader
                transcriptionBox

                if quizLogic.showResult || quizLogic.hasFailed {
                    resultCard
                } else {
                    optionsCard
                }
            }
            .padding(.bottom, 40)
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Quit", role: .destructive) { activeAlert = .quit }
            }
        }
        .background(
            ZStack {
                Image("BackgroundImage").resizable().scaledToFill()
                Color.black.opacity(0.8)
            }.ignoresSafeArea()
        )

        /* lifecycle */
        .onAppear {
            quizLogic.questions = questions
            quizLogic.startQuiz()
            stt.requestAuthorization()
        }
        .onReceive(tts.isSpeakingPublisher)          { isSpeaking  = $0 }
        .onReceive(stt.isRecordingPublisher)         { rec in
            if isRecording && !rec { checkVoiceAnswer() }
            isRecording = rec
        }
        .onReceive(stt.transcriptionPublisher)       { transcription       = $0 }
        .onReceive(stt.authorizationStatusPublisher) { authorizationStatus = $0 }

        /* Alerts */
        .alert(item: $activeAlert) { which in
            switch which {
            case .quit:
                return Alert(
                    title: Text("Quit Quiz?"),
                    message: Text("Are you sure you want to quit?"),
                    primaryButton: .destructive(Text("Yes")) {
                        stopAllAudio(); presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel()
                )
            case .permission:
                return Alert(
                    title: Text("Speech Recognition Disabled"),
                    message: Text("Enable Microphone & Speech Recognition in Settings ▸ Privacy."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

// ════════════════════════════════════════════════════════════
// MARK:  SUB-VIEWS
// ════════════════════════════════════════════════════════════
private extension Practice1 {

    // 🔊 Question text + speaker
    var questionHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(quizLogic.currentQuestionIndex + 1).  \(quizLogic.currentQuestion.text)")
                .font(.title).bold().foregroundColor(.white)

            HStack {
                Spacer()
                if isSpeaking {
                    Button { stopAllAudio() } label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.system(size: 28)).foregroundColor(.red)
                    }
                    .padding(.trailing, 24)
                } else {
                    Button {
                        stopAllAudio()
                        speakQuestionAndOptions()
                    } label: {
                        Image(systemName: "speaker.wave.1.fill")
                            .font(.system(size: 28)).foregroundColor(.blue)
                    }
                    .padding(.trailing, 24)
                    .disabled(isRecording || isAnswered)
                }
            }
        }
        .padding(.horizontal)
    }

    // 🎤 mic + live transcript
    var transcriptionBox: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Your Answer:")
                    .font(.headline).foregroundColor(.white)
                Spacer()
                micButton
            }

            ScrollView {
                Text(transcription)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
            }
            .frame(maxHeight: 120)
        }
        .padding(.horizontal)
    }

    /* mic button */
    var micButton: some View {
        Group {
            if isRecording {
                Button { stopAllAudio() } label: {
                    Image(systemName: "mic.circle.fill")
                        .font(.system(size: 40)).foregroundColor(.red)
                }
            } else {
                Button {
                    guard authorizationStatus == .authorized, !isAnswered else {
                        if authorizationStatus != .authorized { activeAlert = .permission }
                        return
                    }
                    stopAllAudio()
                    stt.startRecording(withOptions: quizLogic.currentQuestion.options,
                                       localeCode : locale,
                                       offlineOnly: offlineOnly)
                } label: {
                    Image(systemName: "mic.circle")
                        .font(.system(size: 40)).foregroundColor(.blue)
                }
                .disabled(isSpeaking || isAnswered)
            }
        }
        .padding(.trailing, 24)
    }

    // Multiple-choice buttons + nav
    var optionsCard: some View {
        VStack(spacing: 12) {
            ForEach(quizLogic.currentQuestion.options.indices, id: \.self) { idx in
                Button {
                    stopAllAudio()
                    guard !isAnswered else { return }
                    selectedAnswer     = idx
                    isAnswerCorrect    = quizLogic.answerQuestion(idx)
                    showAnswerFeedback = true
                    isAnswered         = true
                } label: {
                    Text(quizLogic.currentQuestion.options[idx])
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(
                            isAnswered
                            ? (idx == quizLogic.currentQuestion.correctAnswer ? Color.green : Color.red)
                            : Color.blue
                        )
                        .cornerRadius(10)
                }
                .disabled(isAnswered)
            }

            if showAnswerFeedback {
                VStack(spacing: 4) {
                    Text(isAnswerCorrect ? "Correct! 🎉" : "Wrong ❌")
                        .font(.headline).foregroundColor(isAnswerCorrect ? .green : .red)
                    Text("Mistakes: \(quizLogic.incorrectAnswers)/4")
                        .foregroundColor(.orange)
                }
                .padding(.bottom, 4)

                Button("Next Question") {
                    stopAllAudio()
                    quizLogic.moveToNextQuestion()
                    resetPerQuestionState()
                }
                .padding().background(Color.orange).foregroundColor(.white).cornerRadius(10)

            } else {
                HStack {
                    Button("Previous") {
                        stopAllAudio()
                        quizLogic.previousQuestion()
                        resetPerQuestionState()
                    }
                    .disabled(quizLogic.currentQuestionIndex == 0)
                    .foregroundColor(.white)
                    .padding().background(Color.gray).cornerRadius(10)

                    Spacer()

                    Button("Skip") {
                        stopAllAudio()
                        quizLogic.moveToNextQuestion()
                        resetPerQuestionState()
                    }
                    .disabled(quizLogic.showResult || quizLogic.hasFailed)
                    .foregroundColor(.white)
                    .padding().background(Color.orange).cornerRadius(10)
                }
            }
        }
    }

    // Result / fail card
    var resultCard: some View {
        VStack(spacing: 8) {
            if quizLogic.hasFailed {
                Text("You reached 4 mistakes.")
                    .font(.largeTitle).bold().foregroundColor(.red)
                Text("Better luck next time!").foregroundColor(.white)
            } else {
                Text("Congratulations! You completed the quiz!")
                    .font(.largeTitle).bold().foregroundColor(.white)
            }

            Text("Correct: \(quizLogic.correctAnswers)").foregroundColor(.green)
            Text("Incorrect: \(quizLogic.incorrectAnswers)").foregroundColor(.red)
            Text("Score: \(quizLogic.scorePercentage)%")
                .font(.headline).foregroundColor(.yellow)

            Button("Restart Quiz") {
                stopAllAudio()
                quizLogic.startQuiz()
                resetPerQuestionState()
            }
            .padding().background(Color.blue).foregroundColor(.white).cornerRadius(10)
        }
    }
}

// ════════════════════════════════════════════════════════════
// MARK:  SPEECH HELPERS & UTIL
// ════════════════════════════════════════════════════════════
private extension Practice1 {

    /// TTS chain  “question → wait → each option”
    func speakQuestionAndOptions() {
        let q = quizLogic.currentQuestion
        var chain: AnyPublisher<Void, Never> = tts
            .speak(q.text, languageCode: locale)
            .flatMap { _ in Just(()).delay(for: .seconds(2), scheduler: DispatchQueue.main) }
            .flatMap { tts.speak("Your options are:", languageCode: locale) }
            .flatMap { _ in Just(()).delay(for: .seconds(1), scheduler: DispatchQueue.main) }
            .eraseToAnyPublisher()

        for opt in q.options {
            chain = chain
                .flatMap { tts.speak(opt, languageCode: locale) }
                .flatMap { _ in Just(()).delay(for: .seconds(1), scheduler: DispatchQueue.main) }
                .eraseToAnyPublisher()
        }
        ttsChain = chain.sink { _ in }
    }

    func checkVoiceAnswer() {
        guard !isAnswered else { return }
        let spoken = transcription.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        guard let idx = quizLogic.currentQuestion.options.firstIndex(where: {
            let lc = $0.lowercased()
            return spoken == lc || spoken.contains(lc)
        }) else { return }

        stopAllAudio()
        isAnswered         = true
        selectedAnswer     = idx
        isAnswerCorrect    = quizLogic.answerQuestion(idx)
        showAnswerFeedback = true
    }

    func resetPerQuestionState() {
        selectedAnswer = nil
        isAnswered = false
        showAnswerFeedback = false
        transcription = ""
    }

    func stopAllAudio() {
        ttsChain?.cancel();  ttsChain = nil
        tts.stopSpeaking()
        stt.stopRecording()
    }
}
