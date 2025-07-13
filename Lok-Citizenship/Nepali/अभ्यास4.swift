import SwiftUI
import Combine
import AVFoundation
import Speech

struct अभ्यास4: View {

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
            englishText: "What was the main purpose of the Federalist Papers?",
            nepaliText: "फेडेरलिस्ट पत्रहरूको मुख्य उद्देश्य के थियो?",
            englishOptions: ["To declare independence from Britain", "To promote the ratification of the U.S. Constitution", "To outline the Bill of Rights", "To establish a national bank"],
            nepaliOptions: ["बेलायतबाट स्वतन्त्रता घोषणा गर्न", "अमेरिकी संविधानको अनुमोदन प्रवर्धन गर्न", "अधिकार विधेयकको रूपरेखा प्रस्तुत गर्न", "राष्ट्रिय बैंक स्थापना गर्न"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "Which amendment abolished slavery?",
            nepaliText: "कुन संशोधनले दासत्व अन्त्य गर्यो?",
            englishOptions: ["13th Amendment", "14th Amendment", "15th Amendment", "19th Amendment"],
            nepaliOptions: ["तेह्रौं संशोधन", "चौधौं संशोधन", "पन्ध्रौं संशोधन", "उन्नाइसौं संशोधन"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "What landmark case established judicial review?",
            nepaliText: "कुन ऐतिहासिक मुद्दाले न्यायिक समीक्षा स्थापित गर्यो?",
            englishOptions: ["Marbury v. Madison", "Brown v. Board of Education", "Roe v. Wade", "McCulloch v. Maryland"],
            nepaliOptions: ["मार्बरी बनाम म्याडिसन", "ब्राउन बनाम शिक्षा बोर्ड", "रो बनाम वेड", "म्याक्कालक बनाम मेरील्यान्ड"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "What is the maximum number of years a President can serve?",
            nepaliText: "राष्ट्रपति कति वर्षसम्म सेवा गर्न सक्छन्?",
            englishOptions: ["4 years", "8 years", "10 years", "12 years"],
            nepaliOptions: ["४ वर्ष", "८ वर्ष", "१० वर्ष", "१२ वर्ष"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "What war was fought between the North and South in the U.S.?",
            nepaliText: "संयुक्त राज्य अमेरिकामा उत्तर र दक्षिणबीच भएको युद्ध कुन थियो?",
            englishOptions: ["Revolutionary War", "World War 1", "The Civil War", "The War of 1812"],
            nepaliOptions: ["क्रान्तिकारी युद्ध", "पहिलो विश्वयुद्ध", "गृहयुद्ध", "१८१२ को युद्ध"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "What was the main reason the U.S. entered World War II?",
            nepaliText: "संयुक्त राज्य अमेरिका दोस्रो विश्वयुद्धमा प्रवेश गर्ने मुख्य कारण के थियो?",
            englishOptions: ["To support Britain and France", "To stop the spread of communism", "The attack on Pearl Harbor", "To defend against Germany"],
            nepaliOptions: ["बेलायत र फ्रान्सलाई समर्थन गर्न", "साम्यवादको विस्तार रोक्न", "पर्ल हार्बरमा भएको आक्रमण", "जर्मनीको विरुद्ध रक्षा गर्न"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "What did the Monroe Doctrine declare?",
            nepaliText: "मोनरो सिद्धान्तले के घोषणा गर्यो?",
            englishOptions: ["Europe should not interfere in the Americas", "Slavery is abolished", "The U.S. must remain neutral in global conflicts", "The Louisiana Purchase is legal"],
            nepaliOptions: ["युरोपले अमेरिकामा हस्तक्षेप गर्नु हुँदैन", "दासत्व समाप्त गरियो", "संयुक्त राज्यले विश्वव्यापी द्वन्द्वमा तटस्थ रहनु पर्छ", "ल्यूसियाना खरिद वैध छ"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "Which U.S. President served more than two terms?",
            nepaliText: "कुन अमेरिकी राष्ट्रपतिले दुई कार्यकाल भन्दा बढी सेवा गरे?",
            englishOptions: ["George Washington", "Theodore Roosevelt", "Franklin D. Roosevelt", "Dwight D. Eisenhower"],
            nepaliOptions: ["जर्ज वाशिंगटन", "थियोडोर रूजवेल्ट", "फ्र्याङ्कलिन डी. रूजवेल्ट", "ड्वाइट डी. आइजनहावर"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "What is the term length for a Supreme Court Justice?",
            nepaliText: "सर्वोच्च अदालतको न्यायाधीशको कार्यकाल कति हुन्छ?",
            englishOptions: ["4 years", "8 years", "12 years", "Life"],
            nepaliOptions: ["४ वर्ष", "१२ वर्ष", "८ वर्ष", "जीवनभरि"],
            correctAnswer: 3
        ),

        BilingualQuestion(
            englishText: "Who was the Chief Justice of the Supreme Court in 2023?",
            nepaliText: "सन् २०२३ मा सर्वोच्च अदालतका प्रधान न्यायाधीश को थिए?",
            englishOptions: ["John G. Roberts", "Clarence Thomas", "Sonia Sotomayor", "Amy Coney Barrett"],
            nepaliOptions: ["जोहन जी. रोबर्ट्स", "क्लरेन्स थोमस", "सोनिया सोतोमयोर", "एमी कोनी ब्यारेट"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "Which branch of government has the power to declare war?",
            nepaliText: "सरकारको कुन शाखासँग युद्ध घोषणा गर्ने अधिकार छ?",
            englishOptions: ["The President", "The Supreme Court", "Congress", "The Vice President"],
            nepaliOptions: ["राष्ट्रपति", "सर्वोच्च अदालत", "कांग्रेस", "उपराष्ट्रपति"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "What was the purpose of the Marshall Plan?",
            nepaliText: "मार्शल योजनाको उद्देश्य के थियो?",
            englishOptions: ["To rebuild Europe after World War 2", "To prevent communism in the U.S.", "To provide U.S. military aid", "To negotiate peace with Japan"],
            nepaliOptions: ["दोस्रो विश्वयुद्धपछि युरोप पुनर्निर्माण गर्न", "संयुक्त राज्य अमेरिकामा साम्यवाद रोक्न", "संयुक्त राज्य सैन्य सहायता प्रदान गर्न", "जापानसँग शान्ति सम्झौता गर्न"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "Which constitutional amendment granted women the right to vote?",
            nepaliText: "कुन संवैधानिक संशोधनले महिलाहरूलाई मतदान अधिकार प्रदान गर्यो?",
            englishOptions: ["15th Amendment", "19th Amendment", "21st Amendment", "26th Amendment"],
            nepaliOptions: ["पन्ध्रौं संशोधन", "उन्नाइसौं संशोधन", "एक्काइसौं संशोधन", "छब्बिसौं संशोधन"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "Which U.S. state was an independent republic before joining the Union?",
            nepaliText: "संयुक्त राज्य अमेरिकामा सामेल हुनुअघि कुन राज्य स्वतन्त्र गणतन्त्र थियो?",
            englishOptions: ["Hawaii", "California", "Texas", "Alaska"],
            nepaliOptions: ["हवाई", "क्यालिफोर्निया", "टेक्सास", "अलास्का"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "Who was President during the Great Depression and World War II?",
            nepaliText: "महामन्दी र दोस्रो विश्वयुद्धको समयमा राष्ट्रपति को थिए?",
            englishOptions: ["Woodrow Wilson", "Herbert Hoover", "Franklin D. Roosevelt", "Harry Truman"],
            nepaliOptions: ["वुड्रो विल्सन", "हर्बर्ट हूवर", "फ्र्याङ्कलिन डी. रूजवेल्ट", "ह्यारी ट्रुम्यान"],
            correctAnswer: 2
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
