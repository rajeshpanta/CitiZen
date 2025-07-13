//
//  PracticeCN1.swift
//  Citizenship Quiz — English ⇄ 中文（简 / 繁）
//

import SwiftUI
import Combine
import AVFoundation
import Speech

struct PracticeCN2: View {

    // 1) our tri-lingual engine
    @StateObject private var quizLogic = QuizCNLogic()

    // 2) view state
    @State private var selectedAnswer      : Int?
    @State private var showAnswerFeedback  = false
    @State private var isAnswerCorrect     = false
    @State private var isAnswered          = false

    // 3) TTS / STT state
    @State private var isSpeaking           = false
    @State private var isRecording          = false
    @State private var transcription        = ""
    @State private var authorizationStatus : SFSpeechRecognizerAuthorizationStatus = .notDetermined
    @State private var micPermissionDenied  = false
    @State private var ttsChain             : AnyCancellable?

    // 4) quit alert
    @State private var showQuitConfirmation = false
    @Environment(\.presentationMode) private var presentationMode

    // 5) services
    private let tts: TextToSpeechService = ServiceLocator.shared.ttsService
    private let stt: SpeechToTextService = ServiceLocator.shared.sttService

    // 6) helper for STT locale
    private func localeCode() -> String {
        switch quizLogic.selectedLanguage {
        case .english:     return "en-US"
        case .simplified:  return "zh-CN"
        case .traditional: return "zh-TW"
        }
    }
    private let offlineOnly = true

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // language toggle
                HStack {
                    triLangButton("🇺🇸 English",   .english)
                    Spacer()
                    triLangButton("🇨🇳 简体",      .simplified)
                    Spacer()
                    triLangButton("🇹🇼 繁體",      .traditional)
                }
                .padding(.horizontal)

                // progress
                VStack {
                    ProgressView(
                        value: Double(quizLogic.attemptedQuestions),
                        total: Double(max(quizLogic.totalQuestions,1))
                    )
                    .accentColor(.green)

                    Text(quizLogic.progressLabel)
                        .font(.subheadline)
                        .foregroundColor(.yellow)
                }

                // quiz or results
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
        .background(
            ZStack {
                Image("USAChina").resizable().scaledToFill()
                Color.black.opacity(0.8)
            }.ignoresSafeArea()
        )
        .navigationBarBackButtonHidden(true)
        .toolbar { ToolbarItem(placement: .navigationBarTrailing) { quitButton } }
        .alert(isPresented: $showQuitConfirmation, content: quitAlert)
        .alert("🎙️ 语音识别受限", isPresented: $micPermissionDenied) {
            Button("OK", role: .cancel) { }
        }
        .onAppear {
            // fill in your 15 questions here
            quizLogic.questions = [
                    TrilingualQuestionCN(
                        englishText:            "Who wrote the Declaration of Independence?",
                        chineseSimplifiedText:  "谁起草了《独立宣言》？",
                        chineseTraditionalText: "誰起草了《獨立宣言》？",
                        englishOptions:            ["George Washington", "Abraham Lincoln", "Benjamin Franklin", "Thomas Jefferson"],
                        chineseSimplifiedOptions:  ["乔治·华盛顿",      "亚伯拉罕·林肯",   "本杰明·富兰克林",  "托马斯·杰斐逊"],
                        chineseTraditionalOptions: ["喬治·華盛頓",      "亞伯拉罕·林肯",   "本傑明·富蘭克林",  "托馬斯·傑斐遜"],
                        correctAnswer: 3
                    ),

                    TrilingualQuestionCN(
                        englishText:            "How many U.S. Senators are there?",
                        chineseSimplifiedText:  "美国有多少参议员？",
                        chineseTraditionalText: "美國有多少參議員？",
                        englishOptions:            ["50", "100", "435", "200"],
                        chineseSimplifiedOptions:  ["50",  "100",  "435",  "200"],
                        chineseTraditionalOptions: ["50",  "100",  "435",  "200"],
                        correctAnswer: 1
                    ),

                    TrilingualQuestionCN(
                        englishText:            "How long is a term for a U.S. Senator?",
                        chineseSimplifiedText:  "美国参议员的任期是多久？",
                        chineseTraditionalText: "美國參議員的任期是多久？",
                        englishOptions:            ["4 years", "2 years", "6 years", "8 years"],
                        chineseSimplifiedOptions:  ["4年",      "2年",      "6年",      "8年"],
                        chineseTraditionalOptions: ["4年",      "2年",      "6年",      "8年"],
                        correctAnswer: 2
                    ),

                    TrilingualQuestionCN(
                        englishText:            "What is one responsibility of a U.S. citizen?",
                        chineseSimplifiedText:  "美国公民的一项责任是什么？",
                        chineseTraditionalText: "美國公民的一項責任是什麼？",
                        englishOptions:            ["Vote in elections", "Own a business", "Pay for health insurance", "Travel abroad"],
                        chineseSimplifiedOptions:  ["在选举中投票",      "拥有企业",            "支付健康保险",        "出国旅行"],
                        chineseTraditionalOptions: ["在選舉中投票",      "擁有企業",            "支付健康保險",        "出國旅行"],
                        correctAnswer: 0
                    ),

                    TrilingualQuestionCN(
                        englishText:            "Who is the Father of Our Country?",
                        chineseSimplifiedText:  "谁是我们国家之父？",
                        chineseTraditionalText: "誰是我們國家之父？",
                        englishOptions:            ["George Washington", "Thomas Jefferson", "Abraham Lincoln", "John Adams"],
                        chineseSimplifiedOptions:  ["乔治·华盛顿",      "托马斯·杰斐逊",   "亚伯拉罕·林肯",    "约翰·亚当斯"],
                        chineseTraditionalOptions: ["喬治·華盛頓",      "托馬斯·傑斐遜",   "亞伯拉罕·林肯",    "約翰·亞當斯"],
                        correctAnswer: 0
                    ),

                    TrilingualQuestionCN(
                        englishText:            "What is one promise you make when you become a U.S. citizen?",
                        chineseSimplifiedText:  "成为美国公民时，你做出的一个承诺是什么？",
                        chineseTraditionalText: "成為美國公民時，你做出的一個承諾是什麼？",
                        englishOptions:            ["Speak only English", "Always vote in elections", "Get a college degree", "Obey the laws of the United States"],
                        chineseSimplifiedOptions:  ["只讲英语",          "始终参加选举并投票", "获得大学学位",        "遵守美国法律"],
                        chineseTraditionalOptions: ["只講英語",          "始終參加選舉並投票", "獲得大學學位",        "遵守美國法律"],
                        correctAnswer: 3
                    ),

                    TrilingualQuestionCN(
                        englishText:            "What ocean is on the West Coast of the United States?",
                        chineseSimplifiedText:  "美国西海岸濒临哪个海洋？",
                        chineseTraditionalText: "美國西海岸濱臨哪個海洋？",
                        englishOptions:            ["Atlantic Ocean", "Pacific Ocean", "Indian Ocean", "Arctic Ocean"],
                        chineseSimplifiedOptions:  ["大西洋",          "太平洋",          "印度洋",          "北冰洋"],
                        chineseTraditionalOptions: ["大西洋",          "太平洋",          "印度洋",          "北冰洋"],
                        correctAnswer: 1
                    ),

                    TrilingualQuestionCN(
                        englishText:            "What is the economic system in the United States?",
                        chineseSimplifiedText:  "美国的经济制度是什么？",
                        chineseTraditionalText: "美國的經濟制度是什麼？",
                        englishOptions:            ["Socialism", "Communism", "Capitalism", "Monarchy"],
                        chineseSimplifiedOptions:  ["社会主义",  "共产主义",   "资本主义",  "君主制"],
                        chineseTraditionalOptions: ["社會主義",  "共產主義",   "資本主義",  "君主制"],
                        correctAnswer: 2
                    ),

                    TrilingualQuestionCN(
                        englishText:            "How many voting members are in the House of Representatives?",
                        chineseSimplifiedText:  "众议院有多少投票成员？",
                        chineseTraditionalText: "眾議院有多少投票成員？",
                        englishOptions:            ["200", "100", "50", "435"],
                        chineseSimplifiedOptions:  ["200",  "100",  "50",    "435"],
                        chineseTraditionalOptions: ["200",  "100",  "50",    "435"],
                        correctAnswer: 3
                    ),

                    TrilingualQuestionCN(
                        englishText:            "What is the rule of law?",
                        chineseSimplifiedText:  "法治是什么？",
                        chineseTraditionalText: "法治是什麼？",
                        englishOptions:            ["Everyone must follow the law", "The President is above the law", "Judges are above the law", "Only lawmakers follow the law"],
                        chineseSimplifiedOptions:  ["人人都必须遵守法律",         "总统凌驾于法律之上",       "法官凌驾于法律之上",       "只有立法者遵守法律"],
                        chineseTraditionalOptions: ["人人都必須遵守法律",         "總統凌駕於法律之上",       "法官凌駕於法律之上",       "只有立法者遵守法律"],
                        correctAnswer: 0
                    ),

                    TrilingualQuestionCN(
                        englishText:            "What is freedom of religion?",
                        chineseSimplifiedText:  "宗教自由是什么？",
                        chineseTraditionalText: "宗教自由是什麼？",
                        englishOptions:            ["You can only practice major religions", "You must follow the government religion", "You can practice any religion, or not practice a religion", "You can never change your religion"],
                        chineseSimplifiedOptions:  ["你只能信仰主要宗教",           "你必须信奉政府指定的宗教",   "你可以信仰任何宗教，或者不信仰任何宗教", "你永远不能改变你的宗教信仰"],
                        chineseTraditionalOptions: ["你只能信仰主要宗教",           "你必須信奉政府指定的宗教",   "你可以信仰任何宗教，或者不信仰任何宗教", "你永遠不能改變你的宗教信仰"],
                        correctAnswer: 2
                    ),

                    TrilingualQuestionCN(
                        englishText:            "What does the Constitution do?",
                        chineseSimplifiedText:  "宪法有什么作用？",
                        chineseTraditionalText: "憲法有什麼作用？",
                        englishOptions:            ["Declares war", "Defines laws for voting", "Sets up the government", "Gives advice to the President"],
                        chineseSimplifiedOptions:  ["宣布战争",    "为投票制定法律", "建立政府",    "向总统提供建议"],
                        chineseTraditionalOptions: ["宣布戰爭",    "為投票制定法律", "建立政府",    "向總統提供建議"],
                        correctAnswer: 2
                    ),

                    TrilingualQuestionCN(
                        englishText:            "What stops one branch of government from becoming too powerful?",
                        chineseSimplifiedText:  "是什么阻止了政府某一分支变得过于强大？",
                        chineseTraditionalText: "是什麼阻止了政府某一分支變得過於強大？",
                        englishOptions:            ["The Supreme Court", "The military", "The people", "Checks and balances"],
                        chineseSimplifiedOptions:  ["最高法院",     "军队",         "人民",       "制衡机制"],
                        chineseTraditionalOptions: ["最高法院",     "軍隊",         "人民",       "制衡機制"],
                        correctAnswer: 3
                    ),

                    TrilingualQuestionCN(
                        englishText:            "Name one branch or part of the government.",
                        chineseSimplifiedText:  "说出政府的一个分支或部分。",
                        chineseTraditionalText: "說出政府的一個分支或部分。",
                        englishOptions:            ["Lawmakers", "Legislative branch (Congress)", "Governors", "The Police"],
                        chineseSimplifiedOptions:  ["立法者",    "立法部门（国会）",      "州长",      "警察"],
                        chineseTraditionalOptions: ["立法者",    "立法部門（國會）",      "州長",      "警察"],
                        correctAnswer: 1
                    ),

                    TrilingualQuestionCN(
                        englishText:            "What is an amendment?",
                        chineseSimplifiedText:  "什么是修正案？",
                        chineseTraditionalText: "什麼是修正案？",
                        englishOptions:            ["A change to the Constitution", "A law", "A government branch", "A tax"],
                        chineseSimplifiedOptions:  ["对宪法的修改",          "一项法律",     "一个政府分支", "一种税收"],
                        chineseTraditionalOptions: ["對憲法的修改",          "一項法律",     "一個政府分支", "一種稅收"],
                        correctAnswer: 0
                    )

                ]

            quizLogic.startQuiz()
            stt.requestAuthorization()
        }
        .onReceive(tts.isSpeakingPublisher)  { isSpeaking  = $0 }
        .onReceive(stt.isRecordingPublisher) { rec in
            if isRecording && !rec { checkVoiceAnswer() }
            isRecording = rec
        }
        .onReceive(stt.transcriptionPublisher)         { transcription      = $0 }
        .onReceive(stt.authorizationStatusPublisher)   { authorizationStatus = $0 }
    }

    // ── subviews ───────────────────────────────────────────

    private func triLangButton(_ label: String, _ lang: QuizLanguageCN) -> some View {
        Button(label) {
            stopAllAudio()
            quizLogic.switchLanguage(to: lang)
        }
        .padding(8)
        .background(quizLogic.selectedLanguage == lang ? Color.blue : Color.gray)
        .foregroundColor(.white)
        .cornerRadius(8)
    }

    private var questionCard: some View {
        VStack(spacing: 16) {
            // header
            VStack(alignment: .leading, spacing: 6) {
                Text(
                  quizLogic.questionNumberLabel(
                    index: quizLogic.currentQuestionIndex + 1,
                    total: quizLogic.totalQuestions
                  )
                )
                .font(.subheadline).foregroundColor(.yellow)

                Text(quizLogic.currentText)
                    .font(.title).bold().foregroundColor(.white)

                speakerButton
            }

            // answers
            ForEach(quizLogic.currentOptions.indices, id: \.self) { idx in
                Button {
                    stopAllAudio()
                    guard !isAnswered else { return }
                    selectedAnswer     = idx
                    isAnswerCorrect    = quizLogic.answerQuestion(idx)
                    showAnswerFeedback = true
                    isAnswered         = true
                } label: {
                    Text(quizLogic.currentOptions[idx])
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth:.infinity, minHeight:50)
                        .background(
                          isAnswered
                          ? (idx == quizLogic.currentQuestion.correctAnswer
                              ? Color.green
                              : Color.red)
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

    private var speakerButton: some View {
        HStack {
            Spacer()
            if isSpeaking {
                Button { stopAllAudio() } label: {
                    Image(systemName:"speaker.wave.2.fill")
                        .font(.system(size:28)).foregroundColor(.red)
                }
            } else {
                Button { stopAllAudio(); speakQuestionAndOptions() } label: {
                    Image(systemName:"speaker.wave.1.fill")
                        .font(.system(size:28)).foregroundColor(.blue)
                }
                .disabled(isRecording || isAnswered)
            }
        }
        .padding(.trailing,24)
    }

    private var micBox: some View {
        VStack(alignment:.leading, spacing:8) {
            HStack {
                Text("🎤 " + (quizLogic.selectedLanguage == .english
                             ? "Your Answer:" : "你的回答："))
                    .font(.headline).foregroundColor(.white)
                Spacer()
                if isRecording {
                    Button { stopAllAudio() } label: {
                        Image(systemName:"mic.circle.fill")
                            .font(.system(size:40)).foregroundColor(.red)
                    }
                } else {
                    Button {
                        guard authorizationStatus == .authorized, !isAnswered else {
                            if authorizationStatus != .authorized {
                                micPermissionDenied = true
                            }
                            return
                        }
                        stopAllAudio()
                        stt.startRecording(
                            withOptions: quizLogic.currentOptions,
                            localeCode: localeCode(),
                            offlineOnly: offlineOnly
                        )
                    } label: {
                        Image(systemName:"mic.circle")
                            .font(.system(size:40)).foregroundColor(.blue)
                    }
                    .disabled(isSpeaking || isAnswered)
                }
            }
            .padding(.trailing,24)

            ScrollView {
                Text(transcription)
                    .padding()
                    .frame(maxWidth:.infinity, alignment:.leading)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
            }
            .frame(maxHeight:120)
        }
        .padding(.horizontal)
    }

    private var prevAndSkip: some View {
        HStack {
            Button(quizLogic.selectedLanguage == .english ? "Previous" : "上一题") {
                stopAllAudio(); quizLogic.previousQuestion(); resetPerQuestionState()
            }
            .disabled(quizLogic.currentQuestionIndex == 0)
            .foregroundColor(.white).padding().background(Color.gray).cornerRadius(10)

            Spacer()

            Button(quizLogic.selectedLanguage == .english ? "Skip" : "跳过") {
                stopAllAudio(); quizLogic.moveToNextQuestion(); resetPerQuestionState()
            }
            .disabled(quizLogic.hasFailed || quizLogic.showResult)
            .foregroundColor(.white).padding().background(Color.orange).cornerRadius(10)
        }
    }

    private var feedbackAndNext: some View {
        VStack(spacing:8) {
            Text(isAnswerCorrect
                 ? (quizLogic.selectedLanguage == .english ? "✅ Correct!" : "✅ 正确!")
                 : (quizLogic.selectedLanguage == .english ? "❌ Wrong!"   : "❌ 错误!"))
                .font(.headline)
                .foregroundColor(isAnswerCorrect ? .green : .red)

            Button(quizLogic.selectedLanguage == .english ? "Next Question" : "下一题") {
                stopAllAudio(); quizLogic.moveToNextQuestion(); resetPerQuestionState()
            }
            .padding().background(Color.orange).foregroundColor(.white).cornerRadius(10)
        }
    }

    private var resultOrFailView: some View {
        VStack(spacing:12) {
            if quizLogic.hasFailed {
                Text(quizLogic.selectedLanguage == .english
                     ? "You reached 4 mistakes."
                     : "你已经错了 4 题。")
                    .font(.largeTitle).bold().foregroundColor(.red)
                Text(quizLogic.selectedLanguage == .english
                     ? "Better luck next time!"
                     : "再接再厉！")
                    .foregroundColor(.white)
            } else {
                Text(quizLogic.selectedLanguage == .english
                     ? "Quiz Completed!"
                     : "测验完成！")
                    .font(.largeTitle).bold().foregroundColor(.white)
            }

            Text(quizLogic.selectedLanguage == .english
                 ? "Correct: \(quizLogic.correctAnswers)"
                 : "正确： \(quizLogic.correctAnswers)")
                .foregroundColor(.green)
            Text(quizLogic.selectedLanguage == .english
                 ? "Incorrect: \(quizLogic.incorrectAnswers)"
                 : "错误： \(quizLogic.incorrectAnswers)")
                .foregroundColor(.red)

            Button(quizLogic.selectedLanguage == .english ? "Restart Quiz" : "重新开始") {
                stopAllAudio(); quizLogic.startQuiz(); resetPerQuestionState()
            }
            .padding().background(Color.blue).foregroundColor(.white).cornerRadius(10)
        }
        .padding()
    }

    private var quitButton: some View {
        Button(quizLogic.selectedLanguage == .english ? "Quit" : "退出") {
            stopAllAudio(); showQuitConfirmation = true
        }
        .foregroundColor(.red)
    }

    private func quitAlert() -> Alert {
        Alert(
            title: Text(quizLogic.selectedLanguage == .english ? "Quit Quiz?" : "确定退出？"),
            message: Text(quizLogic.selectedLanguage == .english
                          ? "Are you sure you want to quit?"
                          : "你确定要退出吗？"),
            primaryButton: .destructive(
              Text(quizLogic.selectedLanguage == .english ? "Yes" : "是")
            ) {
                stopAllAudio(); presentationMode.wrappedValue.dismiss()
            },
            secondaryButton: .cancel(
              Text(quizLogic.selectedLanguage == .english ? "No" : "否")
            )
        )
    }

    // ── speech helpers (identical to before) ────────────────

    private func speakQuestionAndOptions() {
        let lc = localeCode()
        var chain: AnyPublisher<Void, Never> = tts
            .speak(quizLogic.currentText, languageCode: lc)
            .flatMap { _ in Just(()).delay(for:.seconds(1.5), scheduler: DispatchQueue.main) }
            .flatMap { tts.speak(quizLogic.optionsIntroText, languageCode: lc) }
            .flatMap { _ in Just(()).delay(for:.seconds(1.0), scheduler: DispatchQueue.main) }
            .eraseToAnyPublisher()

        for opt in quizLogic.currentOptions {
            chain = chain
                .flatMap { tts.speak(opt, languageCode: lc) }
                .flatMap { _ in Just(()).delay(for:.seconds(1.0), scheduler: DispatchQueue.main) }
                .eraseToAnyPublisher()
        }
        ttsChain = chain.sink { _ in }
    }

    private func checkVoiceAnswer() {
        guard !isAnswered else { return }
        let spoken = transcription.lowercased().trimmingCharacters(in:.whitespacesAndNewlines)
        guard let idx = quizLogic
                .currentOptions
                .firstIndex(where: { spoken == $0.lowercased() || spoken.contains($0.lowercased()) })
        else { return }

        stopAllAudio()
        selectedAnswer     = idx
        isAnswerCorrect    = quizLogic.answerQuestion(idx)
        showAnswerFeedback = true
        isAnswered         = true
    }

    private func resetPerQuestionState() {
        selectedAnswer     = nil
        isAnswered         = false
        showAnswerFeedback = false
        transcription      = ""
    }

    private func stopAllAudio() {
        ttsChain?.cancel()
        tts.stopSpeaking()
        stt.stopRecording()
    }
}
