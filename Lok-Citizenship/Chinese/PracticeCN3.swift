//
//  PracticeCN1.swift
//  Citizenship Quiz — English ⇄ 中文（简 / 繁）
//

import SwiftUI
import Combine
import AVFoundation
import Speech

struct PracticeCN3: View {

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
                        englishText:             "What do we call the first ten amendments to the Constitution?",
                        chineseSimplifiedText:   "我们把宪法前十条修正案称为什么？",
                        chineseTraditionalText:  "我們把憲法前十條修正案稱為什麼？",
                        englishOptions:             ["The Declaration of Independence", "The Bill of Rights", "The Articles of Confederation", "The Federalist Papers"],
                        chineseSimplifiedOptions:   ["《独立宣言》",                "《权利法案》",             "《邦联条例》",                   "《联邦党人文集》"],
                        chineseTraditionalOptions:  ["《獨立宣言》",                "《權利法案》",             "《邦聯條例》",                   "《聯邦黨人文集》"],
                        correctAnswer: 1
                    ),

                    TrilingualQuestionCN(
                        englishText:             "What is the capital of your state?",
                        chineseSimplifiedText:   "你所在州的首府是什么？",
                        chineseTraditionalText:  "你所在州的首府是什麼？",
                        englishOptions:             ["Depends on your state", "New York", "Los Angeles", "Chicago"],
                        chineseSimplifiedOptions:   ["取决于你所在的州",           "纽约",             "洛杉矶",               "芝加哥"],
                        chineseTraditionalOptions:  ["取決於你所在的州",           "紐約",             "洛杉磯",               "芝加哥"],
                        correctAnswer: 0
                    ),

                    TrilingualQuestionCN(
                        englishText:             "Who was the first President of the United States?",
                        chineseSimplifiedText:   "谁是美国的第一任总统？",
                        chineseTraditionalText:  "誰是美國的第一任總統？",
                        englishOptions:             ["John Adams", "Thomas Jefferson", "George Washington", "Benjamin Franklin"],
                        chineseSimplifiedOptions:   ["约翰·亚当斯",       "托马斯·杰斐逊",    "乔治·华盛顿",         "本杰明·富兰克林"],
                        chineseTraditionalOptions:  ["約翰·亞當斯",       "托馬斯·傑斐遜",    "喬治·華盛頓",         "本傑明·富蘭克林"],
                        correctAnswer: 2
                    ),

                    TrilingualQuestionCN(
                        englishText:             "What did the Emancipation Proclamation do?",
                        chineseSimplifiedText:   "《解放奴隶宣言》做了什么？",
                        chineseTraditionalText:  "《解放奴隸宣言》做了什麼？",
                        englishOptions:             ["Ended the Civil War", "Freed the slaves", "Established a national bank", "Declared independence from Britain"],
                        chineseSimplifiedOptions:   ["结束了内战",        "解放了奴隶",        "建立了国家银行",          "宣布脱离英国独立"],
                        chineseTraditionalOptions:  ["結束了內戰",        "解放了奴隸",        "建立了國家銀行",          "宣布脫離英國獨立"],
                        correctAnswer: 1
                    ),

                    TrilingualQuestionCN(
                        englishText:             "Who is the Speaker of the House of Representatives now?",
                        chineseSimplifiedText:   "现任众议院议长是谁？",
                        chineseTraditionalText:  "現任眾議院議長是誰？",
                        englishOptions:             ["Nancy Pelosi", "Kevin McCarthy", "Mitch McConnell", "Mike Johnson"],
                        chineseSimplifiedOptions:   ["南希·佩洛西",       "凯文·麦卡锡",      "米奇·麦康奈尔",         "迈克·约翰逊"],
                        chineseTraditionalOptions:  ["南希·佩洛西",       "凱文·麥卡錫",      "米奇·麥康納爾",         "邁克·約翰遜"],
                        correctAnswer: 3
                    ),

                    TrilingualQuestionCN(
                        englishText:             "How many justices are on the Supreme Court?",
                        chineseSimplifiedText:   "最高法院有多少位大法官？",
                        chineseTraditionalText:  "最高法院有多少位大法官？",
                        englishOptions:             ["7", "9", "11", "13"],
                        chineseSimplifiedOptions:   ["7",  "9",  "11", "13"],
                        chineseTraditionalOptions:  ["7",  "9",  "11", "13"],
                        correctAnswer: 1
                    ),

                    TrilingualQuestionCN(
                        englishText:             "What did Susan B. Anthony do?",
                        chineseSimplifiedText:   "苏珊·B·安东尼做了什么？",
                        chineseTraditionalText:  "蘇珊·B·安東尼做了什麼？",
                        englishOptions:             ["Fought for women's rights", "Wrote the Constitution", "Discovered America", "Became the first female President"],
                        chineseSimplifiedOptions:   ["为妇女权利而斗争",      "撰写宪法",         "发现了美洲",           "成为第一位女性总统"],
                        chineseTraditionalOptions:  ["為婦女權利而鬥爭",      "撰寫憲法",         "發現了美洲",           "成為第一位女性總統"],
                        correctAnswer: 0
                    ),

                    TrilingualQuestionCN(
                        englishText:             "What movement tried to end racial discrimination?",
                        chineseSimplifiedText:   "哪个运动试图结束种族歧视？",
                        chineseTraditionalText:  "哪個運動試圖結束種族歧視？",
                        englishOptions:             ["The Civil Rights Movement", "The Women's Movement", "The American Revolution", "The Abolitionist Movement"],
                        chineseSimplifiedOptions:   ["民权运动",            "妇女运动",          "美国独立战争",         "废奴运动"],
                        chineseTraditionalOptions:  ["民權運動",            "婦女運動",          "美國獨立戰爭",         "廢奴運動"],
                        correctAnswer: 0
                    ),

                    TrilingualQuestionCN(
                        englishText:             "What was one important thing that Abraham Lincoln did?",
                        chineseSimplifiedText:   "亚伯拉罕·林肯做的一件重要事情是什么？",
                        chineseTraditionalText:  "亞伯拉罕·林肯做的一件重要事情是什麼？",
                        englishOptions:             ["Established the U.S. Navy", "Freed the slaves", "Fought in the Revolutionary War", "Wrote the Bill of Rights"],
                        chineseSimplifiedOptions:   ["建立了美国海军",       "解放了奴隶",        "参加了独立战争",       "撰写了权利法案"],
                        chineseTraditionalOptions:  ["建立了美國海軍",       "解放了奴隸",        "參加了獨立戰爭",       "撰寫了權利法案"],
                        correctAnswer: 1
                    ),

                    TrilingualQuestionCN(
                        englishText:             "Why does the U.S. flag have 50 stars?",
                        chineseSimplifiedText:   "美国国旗为什么有50颗星？",
                        chineseTraditionalText:  "美國國旗為什麼有50顆星？",
                        englishOptions:             ["For the 50 Presidents", "For the 50 states", "For the 50 amendments", "For the 50 years of independence"],
                        chineseSimplifiedOptions:   ["代表50位总统",        "代表50个州",         "代表50条修正案",         "代表50年的独立"],
                        chineseTraditionalOptions:  ["代表50位總統",        "代表50個州",         "代表50條修正案",         "代表50年的獨立"],
                        correctAnswer: 1
                    ),

                    TrilingualQuestionCN(
                        englishText:             "When do we vote for President?",
                        chineseSimplifiedText:   "我们什么时候投票选总统？",
                        chineseTraditionalText:  "我們什麼時候投票選總統？",
                        englishOptions:             ["January", "March", "November", "December"],
                        chineseSimplifiedOptions:   ["一月",    "三月",    "十一月",     "十二月"],
                        chineseTraditionalOptions:  ["一月",    "三月",    "十一月",     "十二月"],
                        correctAnswer: 2
                    ),

                    TrilingualQuestionCN(
                        englishText:             "What is one reason colonists came to America?",
                        chineseSimplifiedText:   "殖民者来到美洲的一个原因是什么？",
                        chineseTraditionalText:  "殖民者來到美洲的一個原因是什麼？",
                        englishOptions:             ["To escape taxes", "Religious freedom", "To join the military", "To find gold"],
                        chineseSimplifiedOptions:   ["逃避税收",     "宗教自由",        "参军",            "寻找黄金"],
                        chineseTraditionalOptions:  ["逃避稅收",     "宗教自由",        "參軍",            "尋找黃金"],
                        correctAnswer: 1
                    ),

                    TrilingualQuestionCN(
                        englishText:             "Who wrote the Federalist Papers?",
                        chineseSimplifiedText:   "谁撰写了《联邦党人文集》？",
                        chineseTraditionalText:  "誰撰寫了《聯邦黨人文集》？",
                        englishOptions:             ["Thomas Jefferson", "James Madison, Alexander Hamilton, John Jay", "George Washington", "Ben Franklin"],
                        chineseSimplifiedOptions:   ["托马斯·杰斐逊",       "詹姆斯·麦迪逊、亚历山大·汉密尔顿和约翰·杰伊", "乔治·华盛顿",      "本杰明·富兰克林"],
                        chineseTraditionalOptions:  ["托馬斯·傑斐遜",       "詹姆斯·麥迪遜、亞歷山大·漢密爾頓和約翰·傑伊", "喬治·華盛頓",      "本傑明·富蘭克林"],
                        correctAnswer: 1
                    ),

                    TrilingualQuestionCN(
                        englishText:             "Who was the President during World War I?",
                        chineseSimplifiedText:   "第一次世界大战期间谁是总统？",
                        chineseTraditionalText:  "第一次世界大戰期間誰是總統？",
                        englishOptions:             ["Franklin D. Roosevelt", "Woodrow Wilson", "Harry Truman", "Dwight D. Eisenhower"],
                        chineseSimplifiedOptions:   ["富兰克林·D·罗斯福",  "伍德罗·威尔逊",    "哈里·杜鲁门",      "德怀特·D·艾森豪威尔"],
                        chineseTraditionalOptions:  ["富蘭克林·D·羅斯福",  "伍德羅·威爾遜",    "哈里·杜魯門",      "德懷特·D·艾森豪威爾"],
                        correctAnswer: 1
                    ),

                    TrilingualQuestionCN(
                        englishText:             "What is one U.S. territory?",
                        chineseSimplifiedText:   "美国的一个领地是什么？",
                        chineseTraditionalText:  "美國的一個領地是什麼？",
                        englishOptions:             ["Hawaii", "Puerto Rico", "Alaska", "Canada"],
                        chineseSimplifiedOptions:   ["夏威夷",    "波多黎各",    "阿拉斯加",    "加拿大"],
                        chineseTraditionalOptions:  ["夏威夷",    "波多黎各",    "阿拉斯加",    "加拿大"],
                        correctAnswer: 1
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
