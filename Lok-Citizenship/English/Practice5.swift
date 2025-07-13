import SwiftUI
import Combine
import AVFoundation
import Speech

struct Practice5: View {

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
private extension Practice5 {

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
private extension Practice5 {

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
