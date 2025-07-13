//
//  PracticeCN1.swift
//  Citizenship Quiz — English ⇄ 中文（简 / 繁）
//

import SwiftUI
import Combine
import AVFoundation
import Speech

struct PracticeCN4: View {

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
                        englishText:              "What was the main purpose of the Federalist Papers?",
                        chineseSimplifiedText:    "《联邦党人文集》的主要目的是什么？",
                        chineseTraditionalText:   "《聯邦黨人文集》的主要目的是什麼？",
                        englishOptions:           ["To declare independence from Britain",
                                                   "To promote the ratification of the U.S. Constitution",
                                                   "To outline the Bill of Rights",
                                                   "To establish a national bank"],
                        chineseSimplifiedOptions: ["宣布脱离英国独立",
                                                   "促进美国宪法的批准",
                                                   "概述《权利法案》",
                                                   "建立国家银行"],
                        chineseTraditionalOptions:["宣佈脫離英國獨立",
                                                   "促進美國憲法的批准",
                                                   "概述《權利法案》",
                                                   "建立國家銀行"],
                        correctAnswer: 1
                    ),

                    TrilingualQuestionCN(
                        englishText:              "Which amendment abolished slavery?",
                        chineseSimplifiedText:    "哪一条修正案废除了奴隶制？",
                        chineseTraditionalText:   "哪一條修正案廢除了奴隸制？",
                        englishOptions:           ["13th Amendment", "14th Amendment", "15th Amendment", "19th Amendment"],
                        chineseSimplifiedOptions: ["第十三修正案",    "第十四修正案",    "第十五修正案",    "第十九修正案"],
                        chineseTraditionalOptions:["第十三修正案",    "第十四修正案",    "第十五修正案",    "第十九修正案"],
                        correctAnswer: 0
                    ),

                    TrilingualQuestionCN(
                        englishText:              "What landmark case established judicial review?",
                        chineseSimplifiedText:    "哪一起具有里程碑意义的案件确立了司法审查权？",
                        chineseTraditionalText:   "哪一起具有里程碑意義的案件確立了司法審查權？",
                        englishOptions:           ["Marbury v. Madison",
                                                   "Brown v. Board of Education",
                                                   "Roe v. Wade",
                                                   "McCulloch v. Maryland"],
                        chineseSimplifiedOptions: ["马伯里诉麦迪逊案",
                                                   "布朗诉教育委员会案",
                                                   "罗诉韦德案",
                                                   "麦卡洛诉马里兰案"],
                        chineseTraditionalOptions:["馬伯里訴麥迪遜案",
                                                   "布朗訴教育委員會案",
                                                   "羅訴韋德案",
                                                   "麥卡洛訴馬里蘭案"],
                        correctAnswer: 0
                    ),

                    TrilingualQuestionCN(
                        englishText:              "What is the maximum number of years a President can serve?",
                        chineseSimplifiedText:    "总统最多可以任职多少年？",
                        chineseTraditionalText:   "總統最多可以任職多少年？",
                        englishOptions:           ["4 years", "8 years", "10 years", "12 years"],
                        chineseSimplifiedOptions: ["4年",    "8年",    "10年",   "12年"],
                        chineseTraditionalOptions:["4年",    "8年",    "10年",   "12年"],
                        correctAnswer: 1
                    ),

                    TrilingualQuestionCN(
                        englishText:              "What war was fought between the North and South in the U.S.?",
                        chineseSimplifiedText:    "美国北方和南方之间爆发的是哪场战争？",
                        chineseTraditionalText:   "美國北方和南方之間爆發的是哪場戰爭？",
                        englishOptions:           ["Revolutionary War", "World War 1", "The Civil War", "The War of 1812"],
                        chineseSimplifiedOptions: ["美国独立战争",      "第一次世界大战",    "内战",             "1812年战争"],
                        chineseTraditionalOptions:["美國獨立戰爭",      "第一次世界大戰",    "內戰",             "1812年戰爭"],
                        correctAnswer: 2
                    ),

                    TrilingualQuestionCN(
                        englishText:              "What was the main reason the U.S. entered World War II?",
                        chineseSimplifiedText:    "美国参战第二次世界大战的主要原因是什么？",
                        chineseTraditionalText:   "美國參戰第二次世界大戰的主要原因是什麼？",
                        englishOptions:           ["To support Britain and France",
                                                   "To stop the spread of communism",
                                                   "The attack on Pearl Harbor",
                                                   "To defend against Germany"],
                        chineseSimplifiedOptions: ["支持英國和法國",
                                                   "阻止共产主义蔓延",
                                                   "珍珠港袭击",
                                                   "抵御德国"],
                        chineseTraditionalOptions:["支持英國和法國",
                                                   "阻止共產主義蔓延",
                                                   "珍珠港襲擊",
                                                   "抵禦德國"],
                        correctAnswer: 2
                    ),

                    TrilingualQuestionCN(
                        englishText:              "What did the Monroe Doctrine declare?",
                        chineseSimplifiedText:    "门罗主义宣称了什么？",
                        chineseTraditionalText:   "門羅主義宣稱了什麼？",
                        englishOptions:           ["Europe should not interfere in the Americas",
                                                   "Slavery is abolished",
                                                   "The U.S. must remain neutral in global conflicts",
                                                   "The Louisiana Purchase is legal"],
                        chineseSimplifiedOptions: ["欧洲不应干涉美洲事务",
                                                   "奴隶制被废除",
                                                   "美国必须在全球冲突中保持中立",
                                                   "路易斯安那购地合法"],
                        chineseTraditionalOptions:["歐洲不應干涉美洲事務",
                                                   "奴隸制被廢除",
                                                   "美國必須在全球衝突中保持中立",
                                                   "路易斯安那購地合法"],
                        correctAnswer: 0
                    ),

                    TrilingualQuestionCN(
                        englishText:              "Which U.S. President served more than two terms?",
                        chineseSimplifiedText:    "哪位美国总统任期超过两届？",
                        chineseTraditionalText:   "哪位美國總統任期超過兩屆？",
                        englishOptions:           ["George Washington",
                                                   "Theodore Roosevelt",
                                                   "Franklin D. Roosevelt",
                                                   "Dwight D. Eisenhower"],
                        chineseSimplifiedOptions: ["乔治·华盛顿",
                                                   "西奥多·罗斯福",
                                                   "富兰克林·D·罗斯福",
                                                   "德怀特·D·艾森豪威尔"],
                        chineseTraditionalOptions:["喬治·華盛頓",
                                                   "西奧多·羅斯福",
                                                   "富蘭克林·D·羅斯福",
                                                   "德懷特·D·艾森豪威爾"],
                        correctAnswer: 2
                    ),

                    TrilingualQuestionCN(
                        englishText:              "What is the term length for a Supreme Court Justice?",
                        chineseSimplifiedText:    "最高法院大法官的任期是多久？",
                        chineseTraditionalText:   "最高法院大法官的任期是多久？",
                        englishOptions:           ["4 years", "8 years", "12 years", "Life"],
                        chineseSimplifiedOptions: ["4年",    "8年",    "12年",   "终身"],
                        chineseTraditionalOptions:["4年",    "8年",    "12年",   "終身"],
                        correctAnswer: 3
                    ),

                    TrilingualQuestionCN(
                        englishText:              "Who was the Chief Justice of the Supreme Court in 2023?",
                        chineseSimplifiedText:    "2023年的最高法院首席大法官是谁？",
                        chineseTraditionalText:   "2023年的最高法院首席大法官是誰？",
                        englishOptions:           ["John G. Roberts",
                                                   "Clarence Thomas",
                                                   "Sonia Sotomayor",
                                                   "Amy Coney Barrett"],
                        chineseSimplifiedOptions: ["约翰·G·罗伯茨",
                                                   "克拉伦斯·托马斯",
                                                   "索尼娅·索托马约尔",
                                                   "艾米·科尼·巴雷特"],
                        chineseTraditionalOptions:["約翰·G·羅伯茨",
                                                   "克拉倫斯·托馬斯",
                                                   "索尼婭·索托馬約爾",
                                                   "艾米·科尼·巴雷特"],
                        correctAnswer: 0
                    ),

                    TrilingualQuestionCN(
                        englishText:              "Which branch of government has the power to declare war?",
                        chineseSimplifiedText:    "哪一部门有权宣战？",
                        chineseTraditionalText:   "哪一部門有權宣戰？",
                        englishOptions:           ["The President", "The Supreme Court", "Congress", "The Vice President"],
                        chineseSimplifiedOptions: ["总统",       "最高法院",      "国会",    "副总统"],
                        chineseTraditionalOptions:["總統",       "最高法院",      "國會",    "副總統"],
                        correctAnswer: 2
                    ),

                    TrilingualQuestionCN(
                        englishText:              "What was the purpose of the Marshall Plan?",
                        chineseSimplifiedText:    "马歇尔计划的目的是什么？",
                        chineseTraditionalText:   "馬歇爾計劃的目的是什麼？",
                        englishOptions:           ["To rebuild Europe after World War 2",
                                                   "To prevent communism in the U.S.",
                                                   "To provide U.S. military aid",
                                                   "To negotiate peace with Japan"],
                        chineseSimplifiedOptions: ["二战后重建欧洲",
                                                   "防止共产主义在美国蔓延",
                                                   "提供美国军事援助",
                                                   "与日本谈判和平"],
                        chineseTraditionalOptions:["二戰後重建歐洲",
                                                   "防止共產主義在美國蔓延",
                                                   "提供美國軍事援助",
                                                   "與日本談判和平"],
                        correctAnswer: 0
                    ),

                    TrilingualQuestionCN(
                        englishText:              "Which constitutional amendment granted women the right to vote?",
                        chineseSimplifiedText:    "哪一条宪法修正案赋予妇女投票权？",
                        chineseTraditionalText:   "哪一條憲法修正案賦予婦女投票權？",
                        englishOptions:           ["15th Amendment", "19th Amendment", "21st Amendment", "26th Amendment"],
                        chineseSimplifiedOptions: ["第十五修正案",     "第十九修正案",     "第二十一修正案",    "第二十六修正案"],
                        chineseTraditionalOptions:["第十五修正案",     "第十九修正案",     "第二十一修正案",    "第二十六修正案"],
                        correctAnswer: 1
                    ),

                    TrilingualQuestionCN(
                        englishText:              "Which U.S. state was an independent republic before joining the Union?",
                        chineseSimplifiedText:    "哪个美国州在加入联邦前是独立共和国？",
                        chineseTraditionalText:   "哪個美國州在加入聯邦前是獨立共和國？",
                        englishOptions:           ["Hawaii", "California", "Texas", "Alaska"],
                        chineseSimplifiedOptions: ["夏威夷",   "加利福尼亚",   "德克萨斯",     "阿拉斯加"],
                        chineseTraditionalOptions:["夏威夷",   "加利福尼亞",   "德克薩斯",     "阿拉斯加"],
                        correctAnswer: 2
                    ),

                    TrilingualQuestionCN(
                        englishText:              "Who was President during the Great Depression and World War II?",
                        chineseSimplifiedText:    "大萧条和第二次世界大战期间谁是总统？",
                        chineseTraditionalText:   "大蕭條和第二次世界大戰期間誰是總統？",
                        englishOptions:           ["Woodrow Wilson", "Herbert Hoover", "Franklin D. Roosevelt", "Harry Truman"],
                        chineseSimplifiedOptions: ["伍德罗·威尔逊",      "赫伯特·胡佛",       "富兰克林·D·罗斯福",    "哈里·杜鲁门"],
                        chineseTraditionalOptions:["伍德羅·威爾遜",      "赫伯特·胡佛",       "富蘭克林·D·羅斯福",    "哈里·杜魯門"],
                        correctAnswer: 2
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
