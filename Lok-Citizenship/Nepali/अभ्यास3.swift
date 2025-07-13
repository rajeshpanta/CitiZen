import SwiftUI
import Combine
import AVFoundation
import Speech

struct अभ्यास3: View {

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
            englishText: "What do we call the first ten amendments to the Constitution?",
            nepaliText: "संविधानका पहिलो १० संशोधनहरूलाई के भनिन्छ?",
            englishOptions: ["The Declaration of Independence", "The Bill of Rights", "The Articles of Confederation", "The Federalist Papers"],
            nepaliOptions: ["स्वतन्त्रताको घोषणा-पत्र ", "अधिकारको विधेयक", "संघीय अनुच्छेद", "फेडेरलिस्ट पत्रहरू"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "What is the capital of your state?",
            nepaliText: "तपाईँको राज्यको राजधानी के हो?",
            englishOptions: ["Depends on your state", "New York", "Los Angeles", "Chicago"],
            nepaliOptions: ["तपाईँको राज्यमा भर पर्छ", "न्यूयोर्क", "लस एन्जलस", "शिकागो"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "Who was the first President of the United States?",
            nepaliText: "संयुक्त राज्य अमेरिकाका पहिलो राष्ट्रपति को थिए?",
            englishOptions: ["John Adams", "Thomas Jefferson", "George Washington", "Benjamin Franklin"],
            nepaliOptions: ["जोहन एडम्स", "थोमस जेफरसन", "जर्ज वाशिंगटन", "बेंजामिन फ्र्याङ्कलिन"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "What did the Emancipation Proclamation do?",
            nepaliText: "मुक्ति घोषणाले के गर्यो?",
            englishOptions: ["Ended the Civil War", "Freed the slaves", "Established a national bank", "Declared independence from Britain"],
            nepaliOptions: ["गृहयुद्ध समाप्त गर्यो", "दासहरूलाई स्वतन्त्र गर्यो", "राष्ट्रिय बैंक स्थापना गर्यो", "बेलायतबाट स्वतन्त्रता घोषणा गर्यो"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "Who is the Speaker of the House of Representatives now?",
            nepaliText: "हाल प्रतिनिधि सभाका सभामुख को हुन्?",
            englishOptions: ["Nancy Pelosi", "Kevin McCarthy", "Mitch McConnell", "Mike Johnson"],
            nepaliOptions: ["न्यान्सी पेलोसी", "केभिन म्याकार्थी", "मिच म्याककोनेल", "माइक जोन्सन"],
            correctAnswer: 3
        ),

        BilingualQuestion(
            englishText: "How many justices are on the Supreme Court?",
            nepaliText: "सर्वोच्च अदालतमा कति जना न्यायाधीशहरू छन्?",
            englishOptions: ["7", "9", "11", "13"],
            nepaliOptions: ["७", "९", "११", "१३"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "What did Susan B. Anthony do?",
            nepaliText: "सुसान बी. एन्थोनीले के गरिन्?",
            englishOptions: ["Fought for women's rights", "Wrote the Constitution", "Discovered America", "Became the first female President"],
            nepaliOptions: ["महिलाहरूका अधिकारका लागि लडिन्", "संविधान लेखिन्", "अमेरिका पत्ता लगाइन्", "पहिलो महिला राष्ट्रपति बनिन्"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "What movement tried to end racial discrimination?",
            nepaliText: "कुन आन्दोलनले जातीय भेदभाव अन्त्य गर्ने प्रयास गर्यो?",
            englishOptions: ["The Civil Rights Movement", "The Women's Movement", "The American Revolution", "The Abolitionist Movement"],
            nepaliOptions: ["नागरिक अधिकार आन्दोलन", "महिला आन्दोलन", "अमेरिकी क्रान्ति", "दास उन्मूलन आन्दोलन"],
            correctAnswer: 0
        ),

        BilingualQuestion(
            englishText: "What was one important thing that Abraham Lincoln did?",
            nepaliText: "अब्राहम लिंकनले गरेको एउटा महत्त्वपूर्ण काम के हो?",
            englishOptions: ["Established the U.S. Navy", "Freed the slaves", "Fought in the Revolutionary War", "Wrote the Bill of Rights"],
            nepaliOptions: ["संयुक्त राज्यको नौसेना स्थापना गरे", "दासहरूलाई स्वतन्त्र गराए", "क्रान्तिकारी युद्ध लडे", "अधिकारको विधेयक लेखे"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "Why does the U.S. flag have 50 stars?",
            nepaliText: "अमेरिकी झण्डामा ५० वटा तारा किन छन्?",
            englishOptions: ["For the 50 Presidents", "For the 50 states", "For the 50 amendments", "For the 50 years of independence"],
            nepaliOptions: ["५० जना राष्ट्रपतिहरूका लागि", "५० वटा राज्यहरूका लागि", "५० वटा संशोधनहरूका लागि", "५० वर्षको स्वतन्त्रताका लागि"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "When do we vote for President?",
            nepaliText: "हामी कहिले राष्ट्रपतिको लागि मतदान गर्छौं?",
            englishOptions: ["January", "March", "November", "December"],
            nepaliOptions: ["जनवरी", "मार्च", "नोभेम्बर", "डिसेम्बर"],
            correctAnswer: 2
        ),

        BilingualQuestion(
            englishText: "What is one reason colonists came to America?",
            nepaliText: "बेलायती उपनिवेशहरू किन अमेरिका आए?",
            englishOptions: ["To escape taxes", "Religious freedom", "To join the military", "To find gold"],
            nepaliOptions: ["करबाट बच्न", "धार्मिक स्वतन्त्रता", "सेनामा भर्ती हुन", "सुन खोज्न"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "Who wrote the Federalist Papers?",
            nepaliText: "फेडेरलिस्ट पत्रहरू कसले लेखे?",
            englishOptions: ["Thomas Jefferson", "James Madison, Alexander Hamilton, John Jay", "George Washington", "Ben Franklin"],
            nepaliOptions: ["थोमस जेफरसन", "जेम्स म्याडिसन, एलेक्जेन्डर ह्यामिल्टन, जोन जे", "जर्ज वाशिंगटन", "बेन फ्र्याङ्कलिन"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "Who was the President during World War I?",
            nepaliText: "प्रथम विश्वयुद्धको समयमा संयुक्त राज्य अमेरिकाका राष्ट्रपति को थिए?",
            englishOptions: ["Franklin D. Roosevelt", "Woodrow Wilson", "Harry Truman", "Dwight D. Eisenhower"],
            nepaliOptions: ["फ्र्याङ्कलिन डी. रूजवेल्ट", "वुड्रो विल्सन", "ह्यारी ट्रुम्यान", "ड्वाइट डी. आइजनहावर"],
            correctAnswer: 1
        ),

        BilingualQuestion(
            englishText: "What is one U.S. territory?",
            nepaliText: "संयुक्त राज्य अमेरिकाको एउटा क्षेत्र कुन हो?",
            englishOptions: ["Hawaii", "Puerto Rico", "Alaska", "Canada"],
            nepaliOptions: ["हवाई", "प्युर्टो रिको", "अलास्का", "क्यानडा"],
            correctAnswer: 1
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
