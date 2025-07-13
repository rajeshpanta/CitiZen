import SwiftUI
import Combine
import AVFoundation
import Speech

struct PracticeCN5: View {

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
                        englishText:             "The House of Representatives has how many voting members?",
                        chineseSimplifiedText:   "众议院有多少名有投票权的成员？",
                        chineseTraditionalText:  "眾議院有多少名有投票權的成員？",
                        englishOptions:          ["100", "435", "50", "200"],
                        chineseSimplifiedOptions:["100", "435", "50", "200"],
                        chineseTraditionalOptions:["100", "435", "50", "200"],
                        correctAnswer:           1
                    ),

                    TrilingualQuestionCN(
                        englishText:             "If both the President and the Vice President can no longer serve, who becomes President?",
                        chineseSimplifiedText:   "如果总统和副总统都无法履职，谁将成为总统？",
                        chineseTraditionalText:  "如果總統和副總統都無法履職，誰將成為總統？",
                        englishOptions:          ["The Speaker of the House",
                                                  "The Chief Justice",
                                                  "The Secretary of State",
                                                  "The Senate Majority Leader"],
                        chineseSimplifiedOptions:["众议院议长",
                                                  "首席大法官",
                                                  "国务卿",
                                                  "参议院多数党领袖"],
                        chineseTraditionalOptions:["眾議院議長",
                                                  "首席大法官",
                                                  "國務卿",
                                                  "參議院多數黨領袖"],
                        correctAnswer:           0
                    ),

                    TrilingualQuestionCN(
                        englishText:             "Under the Constitution, some powers belong to the federal government. What is one power of the federal government?",
                        chineseSimplifiedText:   "根据宪法，某些权力属于联邦政府。联邦政府的一个权力是什么？",
                        chineseTraditionalText:  "根據憲法，某些權力屬於聯邦政府。聯邦政府的一項權力是什麼？",
                        englishOptions:          ["To issue driver’s licenses",
                                                  "To create an army",
                                                  "To set up schools",
                                                  "To regulate marriages"],
                        chineseSimplifiedOptions:["颁发驾驶执照",
                                                  "组建军队",
                                                  "建立学校",
                                                  "管理婚姻"],
                        chineseTraditionalOptions:["頒發駕駛執照",
                                                  "組建軍隊",
                                                  "建立學校",
                                                  "管理婚姻"],
                        correctAnswer:           1
                    ),

                    TrilingualQuestionCN(
                        englishText:             "Under our Constitution, some powers belong to the states. What is one power of the states?",
                        chineseSimplifiedText:   "根据我们的宪法，某些权力属于各州。各州的一个权力是什么？",
                        chineseTraditionalText:  "根據我們的憲法，某些權力屬於各州。各州的一項權力是什麼？",
                        englishOptions:          ["To make treaties",
                                                  "To create an army",
                                                  "To print money",
                                                  "Establish and run public schools"],
                        chineseSimplifiedOptions:["缔结条约",
                                                  "组建军队",
                                                  "印制货币",
                                                  "建立和管理公立学校"],
                        chineseTraditionalOptions:["締結條約",
                                                  "組建軍隊",
                                                  "印製貨幣",
                                                  "建立和管理公立學校"],
                        correctAnswer:           3
                    ),

                    TrilingualQuestionCN(
                        englishText:             "Who is the Commander in Chief of the military?",
                        chineseSimplifiedText:   "谁是军队的最高统帅？",
                        chineseTraditionalText:  "誰是軍隊的最高統帥？",
                        englishOptions:          ["The President", "The Vice President", "The Secretary of Defense", "The Speaker of the House"],
                        chineseSimplifiedOptions:["总统",       "副总统",       "国防部长",          "众议院议长"],
                        chineseTraditionalOptions:["總統",       "副總統",       "國防部長",          "眾議院議長"],
                        correctAnswer:           0
                    ),

                    TrilingualQuestionCN(
                        englishText:             "What are two rights in the Declaration of Independence?",
                        chineseSimplifiedText:   "《独立宣言》中提到的两项权利是什么？",
                        chineseTraditionalText:  "《獨立宣言》中提到的兩項權利是什麼？",
                        englishOptions:          ["Right to bear arms and right to vote",
                                                  "Right to work and right to protest",
                                                  "Life and Liberty",
                                                  "Freedom of speech and freedom of religion"],
                        chineseSimplifiedOptions:["持有武器权和投票权",
                                                  "工作权和抗议权",
                                                  "生命与自由",
                                                  "言论自由和宗教自由"],
                        chineseTraditionalOptions:["持有武器權和投票權",
                                                  "工作權和抗議權",
                                                  "生命與自由",
                                                  "言論自由和宗教自由"],
                        correctAnswer:           2
                    ),

                    TrilingualQuestionCN(
                        englishText:             "What is the ‘rule of law’?",
                        chineseSimplifiedText:   "什么是“法治”？",
                        chineseTraditionalText:  "什麼是「法治」？",
                        englishOptions:          ["The government can ignore laws",
                                                  "No one is above the law",
                                                  "Only federal judges follow the law",
                                                  "The Constitution is not legally binding"],
                        chineseSimplifiedOptions:["政府可以无视法律",
                                                  "没有人可以凌驾于法律之上",
                                                  "只有联邦法官遵守法律",
                                                  "宪法不具法律约束力"],
                        chineseTraditionalOptions:["政府可以無視法律",
                                                  "沒有人可以凌駕於法律之上",
                                                  "只有聯邦法官遵守法律",
                                                  "憲法不具法律約束力"],
                        correctAnswer:           1
                    ),

                    TrilingualQuestionCN(
                        englishText:             "What does the judicial branch do?",
                        chineseSimplifiedText:   "司法部门做什么？",
                        chineseTraditionalText:  "司法部門做什麼？",
                        englishOptions:          ["Makes laws", "Interprets the law", "Elects the President", "Controls the military"],
                        chineseSimplifiedOptions:["制定法律",   "解释法律",     "选举总统",      "控制军队"],
                        chineseTraditionalOptions:["制定法律",   "解釋法律",     "選舉總統",      "控制軍隊"],
                        correctAnswer:           1
                    ),

                    TrilingualQuestionCN(
                        englishText:             "There are four amendments to the Constitution about who can vote. Describe one of them.",
                        chineseSimplifiedText:   "宪法中有四项修正案涉及谁可以投票。请描述其中一项。",
                        chineseTraditionalText:  "憲法中有四項修正案涉及誰可以投票。請描述其中一項。",
                        englishOptions:          ["Only landowners can vote",
                                                  "Only white men can vote",
                                                  "Citizens 18 and older can vote",
                                                  "Voting is mandatory"],
                        chineseSimplifiedOptions:["只有土地所有者可以投票",
                                                  "只有白人男性可以投票",
                                                  "18岁及以上公民可以投票",
                                                  "投票是强制性的"],
                        chineseTraditionalOptions:["只有土地所有者可以投票",
                                                  "只有白人男性可以投票",
                                                  "18歲及以上公民可以投票",
                                                  "投票是強制性的"],
                        correctAnswer:           2
                    ),

                    TrilingualQuestionCN(
                        englishText:             "Why do some states have more Representatives than other states?",
                        chineseSimplifiedText:   "为什么有些州比其他州拥有更多众议员？",
                        chineseTraditionalText:  "為什麼有些州比其他州擁有更多眾議員？",
                        englishOptions:          ["Because they are bigger",
                                                  "Because they have more people",
                                                  "Because they were part of the original 13 colonies",
                                                  "Because they have more senators"],
                        chineseSimplifiedOptions:["因为面积更大",
                                                  "因为人口更多",
                                                  "因为它们是最初13个殖民地的一部分",
                                                  "因为它们拥有更多参议员"],
                        chineseTraditionalOptions:["因為面積更大",
                                                  "因為人口更多",
                                                  "因為它們是最初13個殖民地的一部分",
                                                  "因為它們擁有更多參議員"],
                        correctAnswer:           1
                    ),

                    TrilingualQuestionCN(
                        englishText:             "What was the main concern of the United States during the Cold War?",
                        chineseSimplifiedText:   "冷战期间美国的主要关切是什么？",
                        chineseTraditionalText:  "冷戰期間美國的主要關切是什麼？",
                        englishOptions:          ["Nuclear disarmament",
                                                  "Terrorism",
                                                  "The spread of communism",
                                                  "World War 3"],
                        chineseSimplifiedOptions:["核裁军",
                                                  "恐怖主义",
                                                  "共产主义的扩散",
                                                  "第三次世界大战"],
                        chineseTraditionalOptions:["核裁軍",
                                                  "恐怖主義",
                                                  "共產主義的擴散",
                                                  "第三次世界大戰"],
                        correctAnswer:           2
                    ),

                    TrilingualQuestionCN(
                        englishText:             "What major event happened on September 11, 2001, in the United States?",
                        chineseSimplifiedText:   "2001年9月11日，美国发生了什么重大事件？",
                        chineseTraditionalText:  "2001年9月11日，美國發生了什麼重大事件？",
                        englishOptions:          ["The U.S. declared war on Iraq",
                                                  "Terrorists attacked the United States",
                                                  "The Great Recession began",
                                                  "Hurricane Katrina struck"],
                        chineseSimplifiedOptions:["美國對伊拉克宣戰",
                                                  "恐怖分子袭击美国",
                                                  "大萧条开始",
                                                  "卡特里娜飓风袭击"],
                        chineseTraditionalOptions:["美國對伊拉克宣戰",
                                                  "恐怖分子襲擊美國",
                                                  "大蕭條開始",
                                                  "卡特里娜颶風襲擊"],
                        correctAnswer:           1
                    ),

                    TrilingualQuestionCN(
                        englishText:             "What are two rights of everyone living in the United States?",
                        chineseSimplifiedText:   "居住在美国的每个人有哪些两项权利？",
                        chineseTraditionalText:  "居住在美國的每個人有哪些兩項權利？",
                        englishOptions:          ["Right to vote & right to work",
                                                  "Freedom of speech & freedom of religion",
                                                  "Right to own land & right to healthcare",
                                                  "Right to drive & right to a free education"],
                        chineseSimplifiedOptions:["投票权和工作权",
                                                  "言论自由和宗教自由",
                                                  "土地所有权和医疗保健权",
                                                  "驾车权和免费教育权"],
                        chineseTraditionalOptions:["投票權和工作權",
                                                  "言論自由和宗教自由",
                                                  "土地所有權和醫療保健權",
                                                  "駕車權和免費教育權"],
                        correctAnswer:           1
                    ),

                    TrilingualQuestionCN(
                        englishText:             "What did the Civil Rights Movement do?",
                        chineseSimplifiedText:   "民权运动做了什么？",
                        chineseTraditionalText:  "民權運動做了什麼？",
                        englishOptions:          ["Fought for women’s rights",
                                                  "Fought for workers' rights",
                                                  "Fought for U.S. independence",
                                                  "Fought for the end of segregation and racial discrimination"],
                        chineseSimplifiedOptions:["为女性权利而斗争",
                                                  "为工人权利而斗争",
                                                  "为美国独立而斗争",
                                                  "为结束种族隔离和歧视而斗争"],
                        chineseTraditionalOptions:["為女性權利而鬥爭",
                                                  "為工人權利而鬥爭",
                                                  "為美國獨立而鬥爭",
                                                  "為結束種族隔離和歧視而鬥爭"],
                        correctAnswer:           3
                    ),

                    TrilingualQuestionCN(
                        englishText:             "What is one promise you make when you become a U.S. citizen?",
                        chineseSimplifiedText:   "成为美国公民时你会做出的一个承诺是什么？",
                        chineseTraditionalText:  "成為美國公民時你會做出的一個承諾是什麼？",
                        englishOptions:          ["To always vote",
                                                  "To support your birth country",
                                                  "To obey U.S. laws",
                                                  "To join the U.S. military"],
                        chineseSimplifiedOptions:["始终投票",
                                                  "支持你的出生国",
                                                  "遵守美国法律",
                                                  "加入美军"],
                        chineseTraditionalOptions:["始終投票",
                                                  "支持你的出生國",
                                                  "遵守美國法律",
                                                  "加入美軍"],
                        correctAnswer:           2
                    ),
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
