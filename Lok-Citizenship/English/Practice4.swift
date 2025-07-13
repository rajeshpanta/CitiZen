import SwiftUI
import Combine
import AVFoundation
import Speech

struct Practice4: View {

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
private extension Practice4 {

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
private extension Practice4 {

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
