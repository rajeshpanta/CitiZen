import SwiftUI
import Combine
import AVFoundation
import Speech

struct अभ्यास2: View {

    // 1 ▸ STATE & MODEL ──────────────────────────────────────
    @StateObject private var quizLogic = Quizतर्क()

    @State private var selectedAnswer: Int?
    @State private var showAnswerFeedback = false
    @State private var isAnswerCorrect   = false
    @State private var isAnswered        = false

    // Live TTS / STT
    @State private var isSpeaking  = false
    @State private var isRecording = false
    @State private var transcription = ""
    @State private var authorizationStatus: SFSpeechRecognizerAuthorizationStatus = .notDetermined
    @State private var micPermissionDenied = false
    @State private var ttsChain: AnyCancellable?

    // Quit alert
    @State private var showQuitConfirmation = false
    @Environment(\.presentationMode) private var presentationMode

    // 2 ▸ SERVICES ───────────────────────────────────────────
    private let tts: TextToSpeechService = ServiceLocator.shared.ttsService
    private let stt: SpeechToTextService = ServiceLocator.shared.sttService

    
    let questions: [BilingualQuestion] = [
        BilingualQuestion(
            englishText: "Who wrote the Declaration of Independence?",
            nepaliText: "स्वतन्त्रताको घोषणापत्र कसले लेखेका थिए?",
            englishOptions: ["George Washington", "Abraham Lincoln", "Benjamin Franklin", "Thomas Jefferson"],
            nepaliOptions: ["जर्ज वाशिंगटन", "अब्राहम लिंकन", "बेंजामिन फ्र्याङ्कलिन", "थॉमस जेफरसनले"],
            correctAnswer: 3
        ),

        BilingualQuestion(
            englishText: "How many U.S. Senators are there?",
            nepaliText: "संयुक्त राज्य अमेरिकामा कुल कति जना सिनेटर छन्?",
            englishOptions: ["50", "100", "435", "200"],
            nepaliOptions: ["५०", "१००", "४३५", "२००"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "How long is a term for a U.S. Senator?",
            nepaliText: "अमेरिकी सिनेटरको कार्यकाल कति समयको हुन्छ?",
            englishOptions: ["4 years", "2 years", "6 years", "8 years"],
            nepaliOptions: ["४ वर्ष", "२ वर्ष", "६ वर्ष", "८ वर्ष"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "What is one responsibility of a U.S. citizen?",
            nepaliText: "संयुक्त राज्य अमेरिकाको नागरिकको एउटा जिम्मेवारी के हो?",
            englishOptions: ["Vote in elections", "Own a business", "Pay for health insurance", "Travel abroad"],
            nepaliOptions: ["निर्वाचनमा मतदान गर्ने", "व्यवसाय संचालन गर्ने", "स्वास्थ्य बिमा तिर्ने", "विदेश यात्रा गर्ने"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "Who is the Father of Our Country?",
            nepaliText: "हाम्रो देशका पिता को हुन्?",
            englishOptions: ["George Washington", "Thomas Jefferson", "Abraham Lincoln", "John Adams"],
            nepaliOptions: ["जर्ज वाशिंगटन", "थोमस जेफरसन", "अब्राहम लिंकन", "जोहन एडम्स"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "What is one promise you make when you become a U.S. citizen?",
            nepaliText: "संयुक्त राज्य अमेरिकाको नागरिक हुँदा तपाईँले गर्ने एउटा प्रतिज्ञा के हो?",
            englishOptions: ["Speak only English", "Always vote in elections", "Get a college degree", "Obey the laws of the United States"],
            nepaliOptions: ["सिर्फ अंग्रेजी बोल्ने", "सधैं चुनावमा मतदान गर्ने", "कलेज डिग्री प्राप्त गर्ने", "संयुक्त राज्य अमेरिकाको कानुन मान्ने"],
            correctAnswer: 3
        ),

        BilingualQuestion(
            englishText: "What ocean is on the West Coast of the United States?",
            nepaliText: "संयुक्त राज्य अमेरिकाको पश्चिमी तटमा कुन महासागर छ?",
            englishOptions: ["Atlantic Ocean", "Pacific Ocean", "Indian Ocean", "Arctic Ocean"],
            nepaliOptions: ["एट्लान्टिक महासागर", "प्रशान्त महासागर", "भारतीय महासागर", "आर्कटिक महासागर"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "What is the economic system in the United States?",
            nepaliText: "संयुक्त राज्य अमेरिकाको आर्थिक प्रणाली के हो?",
            englishOptions: ["Socialism", "Communism", "Capitalism", "Monarchy"],
            nepaliOptions: ["साम्यवाद", "साम्यवाद", "पूँजीवाद", "राजतन्त्र"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "How many voting members are in the House of Representatives?",
            nepaliText: "प्रतिनिधि सभामा कति जना मतदान सदस्यहरू छन्?",
            englishOptions: ["200", "100", "50", "435"],
            nepaliOptions: ["२००", "१००", "५०", "४३५"],
            correctAnswer: 3
        ),

        BilingualQuestion(
            englishText: "What is the rule of law?",
            nepaliText: "कानुनको शासन भनेको के हो?",
            englishOptions: ["Everyone must follow the law", "The President is above the law", "Judges are above the law", "Only lawmakers follow the law"],
            nepaliOptions: ["सबैले कानुन मान्नुपर्छ", "राष्ट्रपति कानुनभन्दा माथि छन्", "न्यायाधीशहरू कानुनभन्दा माथि छन्", "सिर्फ कानुन निर्माताहरू कानुन पालना गर्छन्"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "What is freedom of religion?",
            nepaliText: "धर्मको स्वतन्त्रता भनेको के हो?",
            englishOptions: ["You can only practice major religions", "You must follow the government religion", "You can practice any religion, or not practice a religion", "You can never change your religion"],
            nepaliOptions: ["तपाईं केवल प्रमुख धर्महरू मात्र अभ्यास गर्न सक्नुहुन्छ", "तपाईं सरकारको धर्म पालना गर्नैपर्छ", "तपाईं कुनै पनि धर्म अभ्यास गर्न सक्नुहुन्छ, वा कुनै पनि धर्म अभ्यास नगर्न सक्नुहुन्छ", "तपाईं आफ्नो धर्म कहिल्यै परिवर्तन गर्न सक्नुहुन्न"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "What does the Constitution do?",
            nepaliText: "संविधानले के गर्छ?",
            englishOptions: ["Declares war", "Defines laws for voting", "Sets up the government", "Gives advice to the President"],
            nepaliOptions: ["युद्ध घोषणा गर्छ", "मतदानका लागि कानुन परिभाषित गर्छ", "सरकार गठन गर्छ", "राष्ट्रपतिलाई सल्लाह दिन्छ"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "What stops one branch of government from becoming too powerful?",
            nepaliText: "सरकारको एउटा शाखालाई अत्यधिक शक्तिशाली बन्नबाट केले रोक्छ?",
            englishOptions: ["The Supreme Court", "The military", "The people", "Checks and balances"],
            nepaliOptions: ["सर्वोच्च अदालत", "सेना", "जनता", "जाँच र सन्तुलन"],
            correctAnswer: 3
        ),

        BilingualQuestion(
            englishText: "Name one branch or part of the government.",
            nepaliText: "सरकारको एउटा शाखा वा भागको नाम लिनुहोस्।",
            englishOptions: ["Lawmakers", "Legislative branch (Congress)", "Governors", "The Police"],
            nepaliOptions: ["कानुन निर्माता", "विधायिका शाखा (कांग्रेस)", "राज्यपालहरू", "प्रहरी"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "What is an amendment?",
            nepaliText: "संशोधन भनेको के हो?",
            englishOptions: ["A change to the Constitution", "A law", "A government branch", "A tax"],
            nepaliOptions: ["संविधानमा परिवर्तन", "एउटा कानुन", "एउटा सरकारी शाखा", "एउटा कर"],
            correctAnswer: 0
        )
    ]

 
    // Helper: locale for TTS/STT
    private func localeCode() -> String {
        quizLogic.selectedLanguage == .english ? "en-US" : "hi-IN"
    }

    // ─────────────────────────────────────────────────────────
    // MARK:  BODY
    // ─────────────────────────────────────────────────────────
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                languageToggle

                /* live progress bar & counters */
                VStack {
                    ProgressView(value: Double(quizLogic.attemptedQuestions),
                                 total: Double(max(quizLogic.totalQuestions, 1)))
                        .accentColor(.green)
                    Text("\(quizLogic.attemptedQuestions)/\(quizLogic.totalQuestions)  •  " +
                         (quizLogic.selectedLanguage == .english
                          ? "Score \(quizLogic.scorePercentage)%"
                          : "स्कोर \(quizLogic.scorePercentage)%"))
                        .font(.subheadline)
                        .foregroundColor(.yellow)
                }
                .padding(.horizontal)

                if quizLogic.showResult || quizLogic.hasFailed {
                    resultOrFailView
                } else {
                    questionCard
                    micBox
                }
            }
            .padding(.bottom, 40)
        }
        .padding()
        .background(background)
        .navigationBarBackButtonHidden(true)
        .toolbar { ToolbarItem(placement: .navigationBarTrailing) { quitButton } }
        .alert(isPresented: $showQuitConfirmation, content: quitAlert)
        .alert("🎙️ माइक्रोफोन अनुमति छैन", isPresented: $micPermissionDenied) {
            Button("OK", role: .cancel) {}
        }

        /* lifecycle */
        .onAppear {
            quizLogic.questions = questions
            quizLogic.startQuiz()
            stt.requestAuthorization()
        }
        .onReceive(tts.isSpeakingPublisher)  { isSpeaking  = $0 }
        .onReceive(stt.isRecordingPublisher) { rec in
            if isRecording && !rec { checkVoiceAnswer() }
            isRecording = rec
        }
        .onReceive(stt.transcriptionPublisher)       { transcription      = $0 }
        .onReceive(stt.authorizationStatusPublisher) { authorizationStatus = $0 }
    }

    // ════════════════════════════════════════════════════════
    // MARK:  SUB-VIEWS
    // ════════════════════════════════════════════════════════

    /* language toggle */
    private var languageToggle: some View {
        HStack {
            langButton("🇺🇸 English", .english)
            Spacer()
            langButton("🇳🇵 नेपाली",  .nepali)
        }
        .padding(.horizontal)
    }

    private func langButton(_ label: String, _ lang: AppLanguage) -> some View {
        Button(label) {
            stopAllAudio(); quizLogic.switchLanguage(to: lang)
        }
        .padding()
        .background(quizLogic.selectedLanguage == lang ? Color.blue : Color.gray)
        .foregroundColor(.white)
        .cornerRadius(10)
    }

    /* question + answers */
    private var questionCard: some View {
        VStack(spacing: 20) {

            /* Question + 🔊 */
            VStack(alignment: .leading, spacing: 6) {
                Text("\(quizLogic.selectedLanguage == .english ? "Question" : "प्रश्न") " +
                     "\(quizLogic.currentQuestionIndex + 1)/\(quizLogic.totalQuestions)")
                    .font(.subheadline).foregroundColor(.yellow)

                Text(textQuestion())
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
                            stopAllAudio(); speakQuestionAndOptions()
                        } label: {
                            Image(systemName: "speaker.wave.1.fill")
                                .font(.system(size: 28)).foregroundColor(.blue)
                        }
                        .padding(.trailing, 24)
                        .disabled(isRecording || isAnswered)
                    }
                }
            }

            /* answer buttons */
            ForEach(quizLogic.currentQuestion.englishOptions.indices, id: \.self) { idx in
                Button {
                    stopAllAudio()
                    guard !isAnswered else { return }
                    selectedAnswer     = idx
                    isAnswerCorrect    = quizLogic.answerQuestion(idx)
                    showAnswerFeedback = true
                    isAnswered         = true
                } label: {
                    Text(textOption(idx))
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

            if showAnswerFeedback { feedbackAndNext } else { prevAndSkip }
        }
        .padding(.horizontal)
    }

    /* mic + transcript */
    private var micBox: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("🎤 " + (quizLogic.selectedLanguage == .english ? "Your Answer:" : "तपाईंको उत्तर:"))
                    .font(.headline).foregroundColor(.white)
                Spacer()
                micButton
            }

            ScrollView {
                Text(transcription)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
            }
            .frame(maxHeight: 120)
        }
        .padding(.horizontal)
    }

    private var micButton: some View {
        Group {
            if isRecording {
                Button { stopAllAudio() } label: {
                    Image(systemName: "mic.circle.fill")
                        .font(.system(size: 40)).foregroundColor(.red)
                }
            } else {
                Button {
                    guard authorizationStatus == .authorized, !isAnswered else {
                        if authorizationStatus != .authorized { micPermissionDenied = true }
                        return
                    }
                    stopAllAudio()
                    stt.startRecording(withOptions: optionsForCurrentLanguage(),
                                       localeCode : localeCode(),
                                       offlineOnly: (quizLogic.selectedLanguage == .english))
                } label: {
                    Image(systemName: "mic.circle")
                        .font(.system(size: 40)).foregroundColor(.blue)
                }
                .disabled(isSpeaking || isAnswered)
            }
        }
        .padding(.trailing, 24)
    }

    /* nav buttons when NOT answered yet */
    private var prevAndSkip: some View {
        HStack {
            Button(quizLogic.selectedLanguage == .english ? "Previous" : "अघिल्लो") {
                stopAllAudio(); quizLogic.previousQuestion(); resetPerQuestionState()
            }
            .disabled(quizLogic.currentQuestionIndex == 0)
            .foregroundColor(.white).padding().background(Color.gray).cornerRadius(10)

            Spacer()

            Button(quizLogic.selectedLanguage == .english ? "Skip" : "छोड्नुहोस्") {
                stopAllAudio(); quizLogic.moveToNextQuestion(); resetPerQuestionState()
            }
            .disabled(quizLogic.hasFailed || quizLogic.showResult)
            .foregroundColor(.white).padding().background(Color.orange).cornerRadius(10)
        }
    }

    /* feedback view when answered */
    private var feedbackAndNext: some View {
        VStack(spacing: 8) {
            Text(isAnswerCorrect
                 ? (quizLogic.selectedLanguage == .english ? "✅ Correct!" : "✅ सही!")
                 : (quizLogic.selectedLanguage == .english ? "❌ Wrong!"   : "❌ गलत!"))
                .font(.headline).foregroundColor(isAnswerCorrect ? .green : .red)

            Text(quizLogic.selectedLanguage == .english
                 ? "Mistakes: \(quizLogic.incorrectAnswers)/4"
                 : "गलत: \(quizLogic.incorrectAnswers)/4")
                .foregroundColor(.orange)

            Button(quizLogic.selectedLanguage == .english ? "Next Question" : "अर्को प्रश्न") {
                stopAllAudio(); quizLogic.moveToNextQuestion(); resetPerQuestionState()
            }
            .padding().background(Color.orange).foregroundColor(.white).cornerRadius(10)
        }
    }

    /* result / fail */
    private var resultOrFailView: some View {
        VStack(spacing: 12) {

            if quizLogic.hasFailed {
                Text(quizLogic.selectedLanguage == .english
                     ? "You reached 4 mistakes."
                     : "तपाईंले ४ गल्ती गर्नुभयो।")
                    .font(.largeTitle).bold().foregroundColor(.red)
                Text(quizLogic.selectedLanguage == .english
                     ? "Better luck next time!"
                     : "अर्को पटक सफल हुनुहोस्!")
                    .foregroundColor(.white)
            } else {
                Text(quizLogic.selectedLanguage == .english
                     ? "Quiz Completed!"
                     : "क्विज सम्पन्न!")
                    .font(.largeTitle).bold().foregroundColor(.white)
            }

            Text(quizLogic.selectedLanguage == .english
                 ? "Correct: \(quizLogic.correctAnswers)"
                 : "सही: \(quizLogic.correctAnswers)")
                .foregroundColor(.green)

            Text(quizLogic.selectedLanguage == .english
                 ? "Incorrect: \(quizLogic.incorrectAnswers)"
                 : "गलत: \(quizLogic.incorrectAnswers)")
                .foregroundColor(.red)

            Text(quizLogic.selectedLanguage == .english
                 ? "Score: \(quizLogic.scorePercentage)%"
                 : "स्कोर: \(quizLogic.scorePercentage)%")
                .font(.headline).foregroundColor(.yellow)

            Button(quizLogic.selectedLanguage == .english ? "Restart Quiz" : "पुनः सुरु") {
                stopAllAudio(); quizLogic.startQuiz(); resetPerQuestionState()
            }
            .padding().background(Color.blue).foregroundColor(.white).cornerRadius(10)
        }
        .padding()
    }

    // Background
    private var background: some View {
        ZStack {
            Image("USANepal").resizable().scaledToFill()
            Color.black.opacity(0.8)
        }
        .ignoresSafeArea()
    }

    /* quit button + alert */
    private var quitButton: some View {
        Button(quizLogic.selectedLanguage == .english ? "Quit" : "छोड्नुहोस्") {
            stopAllAudio(); showQuitConfirmation = true
        }
        .foregroundColor(.red)
    }

    private func quitAlert() -> Alert {
        Alert(
            title: Text(quizLogic.selectedLanguage == .english ? "Quit Quiz?" : "क्विज छोड्नुहुन्छ?"),
            message: Text(quizLogic.selectedLanguage == .english ? "Are you sure you want to quit?" : "के तपाईँ पक्का छोड्न चाहनुहुन्छ?"),
            primaryButton: .destructive(Text(quizLogic.selectedLanguage == .english ? "Yes" : "हो")) {
                stopAllAudio(); presentationMode.wrappedValue.dismiss()
            },
            secondaryButton: .cancel(Text(quizLogic.selectedLanguage == .english ? "No" : "होइन"))
        )
    }

    // ════════════════════════════════════════════════════════
    // MARK:  SPEECH HELPERS
    // ════════════════════════════════════════════════════════

    private func speakQuestionAndOptions() {
        let lc = localeCode()
        var chain: AnyPublisher<Void, Never> = tts
            .speak(textQuestion(), languageCode: lc)
            .flatMap { _ in Just(()).delay(for: .seconds(1.5), scheduler: DispatchQueue.main) }
            .flatMap { tts.speak(optionsIntroText(), languageCode: lc) }
            .flatMap { _ in Just(()).delay(for: .seconds(1.0), scheduler: DispatchQueue.main) }
            .eraseToAnyPublisher()

        for opt in optionsForCurrentLanguage() {
            chain = chain
                .flatMap { tts.speak(opt, languageCode: lc) }
                .flatMap { _ in Just(()).delay(for: .seconds(1.0), scheduler: DispatchQueue.main) }
                .eraseToAnyPublisher()
        }
        ttsChain = chain.sink { _ in }
    }

    private func checkVoiceAnswer() {
        guard !isAnswered else { return }
        let spoken = transcription.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        guard let idx = optionsForCurrentLanguage().firstIndex(where: {
            let lcOpt = $0.lowercased()
            return spoken == lcOpt || spoken.contains(lcOpt)
        }) else { return }

        stopAllAudio()
        isAnswered         = true
        selectedAnswer     = idx
        isAnswerCorrect    = quizLogic.answerQuestion(idx)
        showAnswerFeedback = true
    }

    private func resetPerQuestionState() {
        selectedAnswer     = nil
        isAnswered         = false
        showAnswerFeedback = false
        transcription      = ""
    }

    private func stopAllAudio() {
        ttsChain?.cancel(); ttsChain = nil
        tts.stopSpeaking(); stt.stopRecording()
    }

    // Helpers – language‐specific strings --------------------
    private func textQuestion() -> String {
        quizLogic.selectedLanguage == .english
        ? quizLogic.currentQuestion.englishText
        : quizLogic.currentQuestion.nepaliText
    }

    private func textOption(_ idx: Int) -> String {
        quizLogic.selectedLanguage == .english
        ? quizLogic.currentQuestion.englishOptions[idx]
        : quizLogic.currentQuestion.nepaliOptions[idx]
    }

    private func optionsIntroText() -> String {
        quizLogic.selectedLanguage == .english ? "Your options are:" : "तपाईंका विकल्पहरू:"
    }

    private func optionsForCurrentLanguage() -> [String] {
        quizLogic.selectedLanguage == .english
        ? quizLogic.currentQuestion.englishOptions
        : quizLogic.currentQuestion.nepaliOptions
    }
}
