import SwiftUI
import Combine
import AVFoundation
import Speech

struct अभ्यास5: View {

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
            englishText: "The House of Representatives has how many voting members?",
            nepaliText: "प्रतिनिधि सभामा कति मतदान सदस्यहरू छन्?",
            englishOptions: ["100", "435", "50", "200"],
            nepaliOptions: ["१००", "४३५", "५०", "२००"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "If both the President and the Vice President can no longer serve, who becomes President?",
            nepaliText: "यदि राष्ट्रपति र उपराष्ट्रपति दुबै सेवा गर्न नसक्ने भए, को राष्ट्रपति बन्छ?",
            englishOptions: ["The Speaker of the House", "The Chief Justice", "The Secretary of State", "The Senate Majority Leader"],
            nepaliOptions: ["प्रतिनिधि सभाका सभामुख", "प्रधान न्यायाधीश", "राज्य सचिव", "सीनेट बहुमत नेता"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "Under the Constitution, some powers belong to the federal government. What is one power of the federal government?",
            nepaliText: "संविधान अनुसार, केही शक्तिहरू संघीय सरकारको हुन्छन्। संघीय सरकारको एउटा शक्ति के हो?",
            englishOptions: ["To issue driver’s licenses", "To create an army", "To set up schools", "To regulate marriages"],
            nepaliOptions: ["ड्राइभरको लाइसेन्स जारी गर्न", "सेना बनाउन", "विद्यालय स्थापना गर्न", "विवाह नियमन गर्न"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "Under our Constitution, some powers belong to the states. What is one power of the states?",
            nepaliText: "हाम्रो संविधान अनुसार, केही शक्तिहरू राज्यहरूको हुन्छ। राज्यहरूको एउटा शक्ति के हो?",
            englishOptions: ["To make treaties", "To create an army", "To print money", "Establish and run public schools"],
            nepaliOptions: ["सन्धिहरू बनाउन", "सेना स्थापना गर्न", "पैसा छाप्न", "सार्वजनिक विद्यालयहरू स्थापना र सञ्चालन गर्ने"],
            correctAnswer: 3
        ),

        BilingualQuestion(
            englishText: "Who is the Commander in Chief of the military?",
            nepaliText: "सेनाको प्रधान सेनापति को हुन्?",
            englishOptions: ["The President", "The Vice President", "The Secretary of Defense", "The Speaker of the House"],
            nepaliOptions: ["राष्ट्रपति", "उपराष्ट्रपति", "रक्षा सचिव", "प्रतिनिधि सभाका सभामुख"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "What are two rights in the Declaration of Independence?",
            nepaliText: "स्वतन्त्रता घोषणापत्रमा उल्लेखित दुई अधिकार के हुन्?",
            englishOptions: ["Right to bear arms and right to vote", "Right to work and right to protest", "Life and Liberty", "Freedom of speech and freedom of religion"],
            nepaliOptions: ["हतियार बोक्ने अधिकार र मतदान गर्ने अधिकार", "काम गर्ने अधिकार र विरोध गर्ने अधिकार", "जीवन र स्वतन्त्रता", "बोल्ने स्वतन्त्रता र धर्मको स्वतन्त्रता"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "What is the ‘rule of law’?",
            nepaliText: "‘कानुनको शासन’ के हो?",
            englishOptions: ["The government can ignore laws", "No one is above the law", "Only federal judges follow the law", "The Constitution is not legally binding"],
            nepaliOptions: ["सरकारले कानुन बेवास्ता गर्न सक्छ", "कुनै पनि व्यक्ति कानुनभन्दा माथि छैन", "सिर्फ संघीय न्यायाधीशहरूले कानुन पालन गर्छन्", "संविधान कानुनी रूपमा बाध्यकारी छैन"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "What does the judicial branch do?",
            nepaliText: "न्यायिक शाखाले के गर्छ?",
            englishOptions: ["Makes laws", "Interprets the law", "Elects the President", "Controls the military"],
            nepaliOptions: ["कानुन बनाउँछ", "कानुनको व्याख्या गर्छ", "राष्ट्रपति चयन गर्छ", "सेनालाई नियन्त्रण गर्छ"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "There are four amendments to the Constitution about who can vote. Describe one of them.",
            nepaliText: "मतदान गर्न सक्ने व्यक्तिहरूसम्बन्धी संविधानमा चार संशोधनहरू छन्। तीमध्ये एउटा वर्णन गर्नुहोस्।",
            englishOptions: ["Only landowners can vote", "Only white men can vote", "Citizens 18 and older can vote", "Voting is mandatory"],
            nepaliOptions: ["सिर्फ जग्गाधनीहरू मतदान गर्न सक्छन्", "सिर्फ गोरा पुरुषहरूले मतदान गर्न सक्छन्", "१८ वर्ष वा सोभन्दा माथिका नागरिकहरूले मतदान गर्न सक्छन्", "मतदान अनिवार्य छ"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "Why do some states have more Representatives than other states?",
            nepaliText: "केही राज्यहरूमा अन्य राज्यहरूभन्दा धेरै प्रतिनिधिहरू किन छन्?",
            englishOptions: ["Because they are bigger", "Because they have more people", "Because they were part of the original 13 colonies", "Because they have more senators"],
            nepaliOptions: ["किनभने तिनीहरू ठूला छन्", "किनभने तिनीहरूको जनसंख्या बढी छ", "किनभने तिनीहरू मूल १३ उपनिवेशहरूको भाग थिए", "किनभने तिनीहरूसँग बढी सिनेटरहरू छन्"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "What was the main concern of the United States during the Cold War?",
            nepaliText: "शीत युद्धको समयमा संयुक्त राज्य अमेरिकाको मुख्य चिन्ता के थियो?",
            englishOptions: ["Nuclear disarmament", "Terrorism", "The spread of communism", "World War 3"],
            nepaliOptions: ["परमाणु निःशस्त्रीकरण", "आतंकवाद", "साम्यवादको फैलावट", "तेस्रो विश्वयुद्ध"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "What major event happened on September 11, 2001, in the United States?",
            nepaliText: "सेप्टेम्बर ११, २००१ मा संयुक्त राज्य अमेरिकामा के ठूलो घटना भयो?",
            englishOptions: ["The U.S. declared war on Iraq", "Terrorists attacked the United States", "The Great Recession began", "Hurricane Katrina struck"],
            nepaliOptions: ["संयुक्त राज्यले इराकसँग युद्ध घोषणा गर्यो", "आतंकवादीहरूले संयुक्त राज्य अमेरिकामा आक्रमण गरे", "महामन्दी सुरु भयो", "हरिकेन कट्रीना आयो"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "What are two rights of everyone living in the United States?",
            nepaliText: "संयुक्त राज्य अमेरिकामा बस्ने सबै व्यक्तिहरूका दुई अधिकार के हुन्?",
            englishOptions: ["Right to vote & right to work", "Freedom of speech & freedom of religion", "Right to own land & right to healthcare", "Right to drive & right to a free education"],
            nepaliOptions: ["मतदान गर्ने अधिकार र काम गर्ने अधिकार", "बोल्ने स्वतन्त्रता र धर्मको स्वतन्त्रता", "जग्गा स्वामित्वको अधिकार र स्वास्थ्य सेवाको अधिकार", "गाडी चलाउने अधिकार र निःशुल्क शिक्षाको अधिकार"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "What did the Civil Rights Movement do?",
            nepaliText: "नागरिक अधिकार आन्दोलनले के गर्यो?",
            englishOptions: ["Fought for women’s rights", "Fought for workers' rights", "Fought for U.S. independence", "Fought for the end of segregation and racial discrimination"],
            nepaliOptions: ["महिलाको अधिकारको लागि लडाइँ गर्यो", "जातीय विभाजन र भेदभाव अन्त्य गर्न लडाइँ गर्यो", "संयुक्त राज्यको स्वतन्त्रताका लागि लडाइँ गर्यो", "कामदारहरूको अधिकारको लागि लडाइँ गर्यो"],
            correctAnswer: 3
        ),
        BilingualQuestion(
            englishText: "What is one promise you make when you become a U.S. citizen?",
            nepaliText: "तपाईं संयुक्त राज्यको नागरिक हुँदा गर्ने एउटा वाचा के हो?",
            englishOptions: ["To always vote", "To support your birth country", "To obey U.S. laws", "To join the U.S. military"],
            nepaliOptions: ["सधैं मतदान गर्ने", "आफ्नो जन्मभूमिलाई समर्थन गर्ने", "संयुक्त राज्यको कानुन मान्ने", "संयुक्त राज्यको सैन्य सेवामा सामेल हुने"],
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
