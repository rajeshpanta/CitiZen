//
//  अभ्यास1.swift
//  English ↔︎ Nepali quiz
//

import SwiftUI
import Combine
import AVFoundation
import Speech

// ─────────────────────────────────────────────────────────────
// MARK:  अभ्यास १  (English ↔︎ Nepali)
// ─────────────────────────────────────────────────────────────
struct अभ्यास1: View {

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
                    englishText: "What is the supreme law of the land?",
                    nepaliText: "देशको सर्वोच्च कानुन के हो?",
                    englishOptions: ["The Bill of Rights", "The Declaration", "The Constitution", "The Articles"],
                    nepaliOptions: ["अधिकारको विधेयक", "घोषणा", "संविधान", "लेखहरू"],
                    correctAnswer: 2
                ),
                
                BilingualQuestion(
                    englishText: "Who makes federal laws?",
                    nepaliText: "संघीय कानूनहरू को बनाउँछ?",
                    englishOptions: ["The President", "Congress", "The Supreme Court", "The Military"],
                    nepaliOptions: ["राष्ट्रपति", "कांग्रेस", "सर्वोच्च अदालत", "सैन्य"],
                    correctAnswer: 1
                ),
                
                BilingualQuestion(
                    englishText: "What are the two parts of the U.S. Congress?",
                    nepaliText: "अमेरिकी काँग्रेसका दुई भागहरू कुन-कुन हुन्?",
                    englishOptions: ["The Senate & The House", "The House & The President", "The Senate & The Cabinet", "The Military & The President"],
                    nepaliOptions: ["सेनेट र प्रतिनिधि सभा", "प्रतिनिधि सभा र राष्ट्रपति", "सेनेट र मन्त्रिपरिषद", "सैन्य र राष्ट्रपति"],
                    correctAnswer: 0
                ),
                
                BilingualQuestion(
                    englishText: "What is the capital of the United States?",
                    nepaliText: "संयुक्त राज्य अमेरिकाको राजधानी के हो?",
                    englishOptions: ["New York", "Washington D.C.", "Los Angeles", "Chicago"],
                    nepaliOptions: ["न्यूयोर्क", "वाशिङ्टन डी.सी.", "लस एन्जलस", "शिकागो"],
                    correctAnswer: 1
                ),
                
                BilingualQuestion(
                    englishText: "What are the two major political parties?",
                    nepaliText: "दुई प्रमुख राजनीतिक दलहरू कुन-कुन हुन्?",
                    englishOptions: ["Democrats & Libertarian", "Federalists & Republicans", "Libertarian & Tories", "Democrats & Republicans"],
                    nepaliOptions: ["डेमोक्र्याट्स र लिबर्टेरियन", "फेडेरलिस्ट्स र रिपब्लिकनहरू", "लिबर्टेरियन र टोरीहरू", "डेमोक्र्याट्स र रिपब्लिकनहरू"],
                    correctAnswer: 3
                ),
                
                BilingualQuestion(
                    englishText: "What color are the stars on the American flag?",
                    nepaliText: "अमेरिकी झण्डाका ताराहरू कुन रंगका हुन्छन्?",
                    englishOptions: ["Blue", "White", "Red", "Yellow"],
                    nepaliOptions: ["नीलो", "सेतो", "रातो", "पहेंलो"],
                    correctAnswer: 1
                ),
                
                BilingualQuestion(
                    englishText: "How many states are there in the United States?",
                    nepaliText: "संयुक्त राज्य अमेरिकामा कति वटा राज्यहरू छन्?",
                    englishOptions: ["51", "49", "52", "50"],
                    nepaliOptions: ["५१", "४९", "५२", "५०"],
                    correctAnswer: 3
                ),
                
                BilingualQuestion(
                    englishText: "What is the name of the President of the United States?",
                    nepaliText: "संयुक्त राज्य अमेरिकाका राष्ट्रपति को हुन्?",
                    englishOptions: ["Joe Biden", "George Bush", "Barack Obama", "Donald J. Trump"],
                    nepaliOptions: ["जो बाइडेन", "जर्ज बुश", "बराक ओबामा", "डोनाल्ड जे. ट्रम्प"],
                    correctAnswer: 3
                ),
                
                BilingualQuestion(
                    englishText: "What is the name of the Vice President of the United States?",
                    nepaliText: "संयुक्त राज्य अमेरिकाका उपराष्ट्रपति को हुन्?",
                    englishOptions: ["Kamala Harris", "Mike Pence", "Nancy Pelosi", "JD Vance"],
                    nepaliOptions: ["कमला ह्यारिस", "माइक पेन्स", "न्यान्सी पेलोसी", "जेडि भेन्स"],
                    correctAnswer: 3
                ),
                
                BilingualQuestion(
                    englishText: "What is one right in the First Amendment?",
                    nepaliText: "प्रथम संशोधनमा रहेको एउटा अधिकार के हो?",
                    englishOptions: ["Freedom to travel", "Right to vote", "Freedom of speech", "Right to education"],
                    nepaliOptions: ["यात्रा गर्ने स्वतन्त्रता", "मतदान गर्ने अधिकार", "बोल्ने स्वतन्त्रता", "शिक्षा प्राप्त गर्ने अधिकार"],
                    correctAnswer: 2
                ),
                
                BilingualQuestion(
                    englishText: "What do we celebrate on July 4th?",
                    nepaliText: "हामी जुलाई ४ मा के मनाउँछौं?",
                    englishOptions: ["Memorial Day", "Independence Day", "Labor Day", "Thanksgiving"],
                    nepaliOptions: ["स्मृति दिवस", "स्वतन्त्रता दिवस", "श्रम दिवस", "धन्यबाद दिवस"],
                    correctAnswer: 1
                ),
                
                BilingualQuestion(
                    englishText: "Who is the Commander in Chief of the military?",
                    nepaliText: "सैन्य प्रमुख कमाण्डर को हुन्?",
                    englishOptions: ["The President", "The Vice President", "The Senate", "The Supreme Court"],
                    nepaliOptions: ["राष्ट्रपति", "उपराष्ट्रपति", "सेनेट", "सर्वोच्च अदालत"],
                    correctAnswer: 0
                ),
                
                BilingualQuestion(
                    englishText: "What is the name of the national anthem?",
                    nepaliText: "राष्ट्रिय गानको नाम के हो?",
                    englishOptions: ["This Land is Your Land", "God Bless America", "America the Beautiful", "The Star-Spangled Banner"],
                    nepaliOptions: ["यो भूमि तिमीहरूको हो", "भगवानले अमेरिका रक्षा गरुन", "अमेरिका सुन्दर छ", "द स्टार स्पैङ्गल्ड ब्यानर"],
                    correctAnswer: 3
                ),
                
                BilingualQuestion(
                    englishText: "What do the 13 stripes on the U.S. flag represent?",
                    nepaliText: "अमेरिकी झण्डामा रहेका १३ वटा धर्साहरू के प्रतिनिधित्व गर्छन्?",
                    englishOptions: ["The 13 amendments", "The number of wars", "The 13 states", "The original 13 colonies"],
                    nepaliOptions: ["१३ वटा संशोधनहरू", "युद्धहरूको संख्या", "१३ राज्यहरू", "मौलिक १३ उपनिवेशहरू"],
                    correctAnswer: 3
                ),
                
                BilingualQuestion(
                    englishText: "What is the highest court in the United States?",
                    nepaliText: "संयुक्त राज्य अमेरिकाको सबैभन्दा उच्च अदालत कुन हो?",
                    englishOptions: ["The Supreme Court", "The Federal Court", "The Court of Appeals", "The Civil Court"],
                    nepaliOptions: ["सर्वोच्च अदालत", "संघीय अदालत", "अपिल अदालत", "नागरिक अदालत"],
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
