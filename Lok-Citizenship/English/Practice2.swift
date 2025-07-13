import SwiftUI
import Combine
import AVFoundation
import Speech

struct Practice2: View {

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
private extension Practice2 {

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
private extension Practice2 {

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
