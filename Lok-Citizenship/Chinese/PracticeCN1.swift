//
//  PracticeCN1.swift
//  Citizenship Quiz — English ⇄ 中文（简 / 繁）
//

import SwiftUI
import Combine
import AVFoundation
import Speech

struct PracticeCN1: View {

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
                        englishText:              "What is the supreme law of the land?",
                        chineseSimplifiedText:    "美国的最高法律是什么？",
                        chineseTraditionalText:   "美國的最高法律是什麼？",
                        englishOptions:           ["The Bill of Rights", "The Declaration", "The Constitution", "The Articles"],
                        chineseSimplifiedOptions: ["《权利法案》", "《独立宣言》", "《宪法》", "《邦联条例》"],
                        chineseTraditionalOptions:["《權利法案》", "《獨立宣言》", "《憲法》", "《邦聯條例》"],
                        correctAnswer: 2
                    ),

                    TrilingualQuestionCN(
                        englishText:              "Who makes federal laws?",
                        chineseSimplifiedText:    "谁制定联邦法律？",
                        chineseTraditionalText:   "誰制定聯邦法律？",
                        englishOptions:           ["The President", "Congress", "The Supreme Court", "The Military"],
                        chineseSimplifiedOptions: ["总统", "国会", "最高法院", "军队"],
                        chineseTraditionalOptions:["總統", "國會", "最高法院", "軍隊"],
                        correctAnswer: 1
                    ),

                    TrilingualQuestionCN(
                        englishText:              "What are the two parts of the U.S. Congress?",
                        chineseSimplifiedText:    "美国国会由哪两部分组成？",
                        chineseTraditionalText:   "美國國會由哪兩部分組成？",
                        englishOptions:           ["The Senate & The House", "The House & The President", "The Senate & The Cabinet", "The Military & The President"],
                        chineseSimplifiedOptions: ["参议院和众议院", "众议院和总统", "参议院和内阁", "军队和总统"],
                        chineseTraditionalOptions:["參議院和眾議院", "眾議院和總統", "參議院和內閣", "軍隊和總統"],
                        correctAnswer: 0
                    ),

                    TrilingualQuestionCN(
                        englishText:              "What is the capital of the United States?",
                        chineseSimplifiedText:    "美国的首都是什么？",
                        chineseTraditionalText:   "美國的首都是什麼？",
                        englishOptions:           ["New York", "Washington D.C.", "Los Angeles", "Chicago"],
                        chineseSimplifiedOptions: ["纽约", "华盛顿特区", "洛杉矶", "芝加哥"],
                        chineseTraditionalOptions:["紐約", "華盛頓特區", "洛杉磯", "芝加哥"],
                        correctAnswer: 1
                    ),

                    TrilingualQuestionCN(
                        englishText:              "What are the two major political parties?",
                        chineseSimplifiedText:    "美国的两个主要政党是什么？",
                        chineseTraditionalText:   "美國的兩個主要政黨是什麼？",
                        englishOptions:           ["Democrats & Libertarian", "Federalists & Republicans", "Libertarian & Tories", "Democrats & Republicans"],
                        chineseSimplifiedOptions: ["民主党与自由意志党", "联邦党人与共和党人", "自由意志党与保守党", "民主党与共和党"],
                        chineseTraditionalOptions:["民主黨與自由意志黨", "聯邦黨人與共和黨人", "自由意志黨與保守黨", "民主黨與共和黨"],
                        correctAnswer: 3
                    ),

                    TrilingualQuestionCN(
                        englishText:              "What color are the stars on the American flag?",
                        chineseSimplifiedText:    "美国国旗上的星星是什么颜色？",
                        chineseTraditionalText:   "美國國旗上的星星是什麼顏色？",
                        englishOptions:           ["Blue", "White", "Red", "Yellow"],
                        chineseSimplifiedOptions: ["蓝色", "白色", "红色", "黄色"],
                        chineseTraditionalOptions:["藍色", "白色", "紅色", "黃色"],
                        correctAnswer: 1
                    ),

                    TrilingualQuestionCN(
                        englishText:              "How many states are there in the United States?",
                        chineseSimplifiedText:    "美国共有多少个州？",
                        chineseTraditionalText:   "美國共有多少個州？",
                        englishOptions:           ["51", "49", "52", "50"],
                        chineseSimplifiedOptions: ["51", "49", "52", "50"],
                        chineseTraditionalOptions:["51", "49", "52", "50"],
                        correctAnswer: 3
                    ),

                    TrilingualQuestionCN(
                        englishText:              "What is the name of the President of the United States?",
                        chineseSimplifiedText:    "美国总统的名字是什么？",
                        chineseTraditionalText:   "美國總統的名字是什麼？",
                        englishOptions:           ["Joe Biden", "George Bush", "Barack Obama", "Donald J. Trump"],
                        chineseSimplifiedOptions: ["乔·拜登", "乔治·布什", "巴拉克·奥巴马", "唐纳德·J·特朗普"],
                        chineseTraditionalOptions:["喬·拜登", "喬治·布什", "巴拉克·歐巴馬", "唐納德·J·特朗普"],
                        correctAnswer: 3
                    ),

                    TrilingualQuestionCN(
                        englishText:              "What is the name of the Vice President of the United States?",
                        chineseSimplifiedText:    "美国副总统的名字是什么？",
                        chineseTraditionalText:   "美國副總統的名字是什麼？",
                        englishOptions:           ["Kamala Harris", "Mike Pence", "Nancy Pelosi", "JD Vance"],
                        chineseSimplifiedOptions: ["卡马拉·哈里斯", "迈克·彭斯", "南希·佩洛西", "JD·万斯"],
                        chineseTraditionalOptions:["卡馬拉·哈里斯", "邁克·彭斯", "南希·佩洛西", "JD·萬斯"],
                        correctAnswer: 3
                    ),

                    TrilingualQuestionCN(
                        englishText:              "What is one right in the First Amendment?",
                        chineseSimplifiedText:    "第一修正案中的一项权利是什么？",
                        chineseTraditionalText:   "第一修正案中的一項權利是什麼？",
                        englishOptions:           ["Freedom to travel", "Right to vote", "Freedom of speech", "Right to education"],
                        chineseSimplifiedOptions: ["旅行自由", "投票权", "言论自由", "受教育权"],
                        chineseTraditionalOptions:["旅行自由", "投票權", "言論自由", "受教育權"],
                        correctAnswer: 2
                    ),

                    TrilingualQuestionCN(
                        englishText:              "What do we celebrate on July 4th?",
                        chineseSimplifiedText:    "我们在 7 月 4 日庆祝什么？",
                        chineseTraditionalText:   "我們在 7 月 4 日慶祝什麼？",
                        englishOptions:           ["Memorial Day", "Independence Day", "Labor Day", "Thanksgiving"],
                        chineseSimplifiedOptions: ["阵亡将士纪念日", "独立日", "劳动节", "感恩节"],
                        chineseTraditionalOptions:["陣亡將士紀念日", "獨立日", "勞動節", "感恩節"],
                        correctAnswer: 1
                    ),

                    TrilingualQuestionCN(
                        englishText:              "Who is the Commander in Chief of the military?",
                        chineseSimplifiedText:    "谁是军队总司令？",
                        chineseTraditionalText:   "誰是軍隊總司令？",
                        englishOptions:           ["The President", "The Vice President", "The Senate", "The Supreme Court"],
                        chineseSimplifiedOptions: ["总统", "副总统", "参议院", "最高法院"],
                        chineseTraditionalOptions:["總統", "副總統", "參議院", "最高法院"],
                        correctAnswer: 0
                    ),

                    TrilingualQuestionCN(
                        englishText:              "What is the name of the national anthem?",
                        chineseSimplifiedText:    "美国国歌的名字是什么？",
                        chineseTraditionalText:   "美國國歌的名字是什麼？",
                        englishOptions:           ["This Land is Your Land", "God Bless America", "America the Beautiful", "The Star-Spangled Banner"],
                        chineseSimplifiedOptions: ["《这片土地是你的土地》", "《上帝保佑美国》", "《美丽的美国》", "《星条旗永不落》"],
                        chineseTraditionalOptions:["《這片土地是你的土地》", "《上帝保佑美國》", "《美麗的美國》", "《星條旗永不落》"],
                        correctAnswer: 3
                    ),

                    TrilingualQuestionCN(
                        englishText:              "What do the 13 stripes on the U.S. flag represent?",
                        chineseSimplifiedText:    "美国国旗上的 13 条纹代表什么？",
                        chineseTraditionalText:   "美國國旗上的 13 條紋代表什麼？",
                        englishOptions:           ["The 13 amendments", "The number of wars", "The 13 states", "The original 13 colonies"],
                        chineseSimplifiedOptions: ["13 条修正案", "战争数量", "13 个州", "最初的 13 个殖民地"],
                        chineseTraditionalOptions:["13 條修正案", "戰爭數量", "13 個州", "最初的 13 個殖民地"],
                        correctAnswer: 3
                    ),

                    TrilingualQuestionCN(
                        englishText:              "What is the highest court in the United States?",
                        chineseSimplifiedText:    "美国最高的法院是什么？",
                        chineseTraditionalText:   "美國最高的法院是什麼？",
                        englishOptions:           ["The Supreme Court", "The Federal Court", "The Court of Appeals", "The Civil Court"],
                        chineseSimplifiedOptions: ["最高法院", "联邦法院", "上诉法院", "民事法院"],
                        chineseTraditionalOptions:["最高法院", "聯邦法院", "上訴法院", "民事法院"],
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
