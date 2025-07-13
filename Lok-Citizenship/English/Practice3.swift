import SwiftUI
import Combine
import AVFoundation
import Speech

struct Practice3: View {

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
private extension Practice3 {

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
private extension Practice3 {

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
