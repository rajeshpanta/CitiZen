import Foundation

/// Every localized UI label the quiz view needs.
///
/// One `QuizStrings` instance exists per language variant. When the user toggles
/// between languages inside a quiz, the view swaps which `QuizStrings` it reads.
struct QuizStrings {

    // -- Progress / question header --
    let questionLabel: String       // "Question" / "प्रश्न" / "Pregunta" / "题目"
    let scoreLabel: String          // "Score" / "स्कोर" / "Puntuación" / "得分"

    // -- TTS intro spoken before listing options --
    let optionsIntro: String        // "Your options are:" / localized

    // -- Mic / transcription area --
    let yourAnswer: String          // "Your Answer:" / "तपाईंको उत्तर:" / etc.

    // -- Answer feedback --
    let correct: String             // "Correct! 🎉" or "✅ सही!" etc.
    let wrong: String               // "Wrong ❌" or "❌ गलत!" etc.
    let mistakesLabel: String       // "Mistakes:" / "गलत:" / "Errores:" / etc.

    // -- Navigation buttons --
    let nextQuestion: String        // "Next Question" / "अर्को प्रश्न" / etc.
    let previous: String            // "Previous" / "अघिल्लो" / "Anterior" / etc.
    let skip: String                // "Skip" / "छोड्नुहोस्" / "Saltar" / etc.

    // -- Quit flow --
    let quit: String                // "Quit" / "छोड्नुहोस्" / "Salir" / "退出"
    let quitTitle: String           // "Quit Quiz?" / localized
    let quitMessage: String         // "Are you sure you want to quit?" / localized
    let quitYes: String             // "Yes" / "हो" / "Sí" / "是"
    let quitNo: String              // "No" / "होइन" / "No" / "否"

    // -- Result screen --
    let completed: String           // "Quiz Completed!" / "क्विज सम्पन्न!" / etc.
    let failedTitle: String         // "You reached 4 mistakes." / localized
    let failedSubtitle: String      // "Better luck next time!" / localized
    let correctLabel: String        // "Correct:" / "सही:" / "Correctas:" / etc.
    let incorrectLabel: String      // "Incorrect:" / "गलत:" / "Incorrectas:" / etc.
    let restartQuiz: String         // "Restart Quiz" / "पुनः सुरु" / etc.

    // -- Mic permission alert --
    let micPermissionAlert: String  // localized mic-denied message
}

// MARK: - Factory methods for each language

extension QuizStrings {

    static let english = QuizStrings(
        questionLabel:      "Question",
        scoreLabel:         "Score",
        optionsIntro:       "Your options are:",
        yourAnswer:         "Your Answer:",
        correct:            "Correct! 🎉",
        wrong:              "Wrong ❌",
        mistakesLabel:      "Mistakes:",
        nextQuestion:       "Next Question",
        previous:           "Previous",
        skip:               "Skip",
        quit:               "Quit",
        quitTitle:          "Quit Quiz?",
        quitMessage:        "Are you sure you want to quit?",
        quitYes:            "Yes",
        quitNo:             "No",
        completed:          "Congratulations! You completed the quiz!",
        failedTitle:        "You reached 4 mistakes.",
        failedSubtitle:     "Better luck next time!",
        correctLabel:       "Correct:",
        incorrectLabel:     "Incorrect:",
        restartQuiz:        "Restart Quiz",
        micPermissionAlert: "Speech Recognition Disabled"
    )

    /// English strings used inside bilingual/trilingual quizzes.
    /// Slightly different emoji style from the monolingual English set.
    static let englishBilingual = QuizStrings(
        questionLabel:      "Question",
        scoreLabel:         "Score",
        optionsIntro:       "Your options are:",
        yourAnswer:         "Your Answer:",
        correct:            "✅ Correct!",
        wrong:              "❌ Wrong!",
        mistakesLabel:      "Mistakes:",
        nextQuestion:       "Next Question",
        previous:           "Previous",
        skip:               "Skip",
        quit:               "Quit",
        quitTitle:          "Quit Quiz?",
        quitMessage:        "Are you sure you want to quit?",
        quitYes:            "Yes",
        quitNo:             "No",
        completed:          "Quiz Completed!",
        failedTitle:        "You reached 4 mistakes.",
        failedSubtitle:     "Better luck next time!",
        correctLabel:       "Correct:",
        incorrectLabel:     "Incorrect:",
        restartQuiz:        "Restart Quiz",
        micPermissionAlert: "Speech Recognition Disabled"
    )

    static let nepali = QuizStrings(
        questionLabel:      "प्रश्न",
        scoreLabel:         "स्कोर",
        optionsIntro:       "तपाईंका विकल्पहरू:",
        yourAnswer:         "तपाईंको उत्तर:",
        correct:            "✅ सही!",
        wrong:              "❌ गलत!",
        mistakesLabel:      "गलत:",
        nextQuestion:       "अर्को प्रश्न",
        previous:           "अघिल्लो",
        skip:               "छोड्नुहोस्",
        quit:               "छोड्नुहोस्",
        quitTitle:          "क्विज छोड्नुहुन्छ?",
        quitMessage:        "के तपाईँ पक्का छोड्न चाहनुहुन्छ?",
        quitYes:            "हो",
        quitNo:             "होइन",
        completed:          "क्विज सम्पन्न!",
        failedTitle:        "तपाईंले ४ गल्ती गर्नुभयो।",
        failedSubtitle:     "अर्को पटक सफल हुनुहोस्!",
        correctLabel:       "सही:",
        incorrectLabel:     "गलत:",
        restartQuiz:        "पुनः सुरु",
        micPermissionAlert: "🎙️ माइक्रोफोन अनुमति छैन"
    )

    static let spanish = QuizStrings(
        questionLabel:      "Pregunta",
        scoreLabel:         "Puntuación",
        optionsIntro:       "Tus opciones son:",
        yourAnswer:         "Tu respuesta:",
        correct:            "✅ ¡Correcto!",
        wrong:              "❌ ¡Incorrecto!",
        mistakesLabel:      "Errores:",
        nextQuestion:       "Siguiente pregunta",
        previous:           "Anterior",
        skip:               "Saltar",
        quit:               "Salir",
        quitTitle:          "¿Salir del cuestionario?",
        quitMessage:        "¿Seguro que deseas salir?",
        quitYes:            "Sí",
        quitNo:             "No",
        completed:          "¡Cuestionario completado!",
        failedTitle:        "Has cometido 4 errores.",
        failedSubtitle:     "¡Mejor suerte la próxima vez!",
        correctLabel:       "Correctas:",
        incorrectLabel:     "Incorrectas:",
        restartQuiz:        "Reiniciar",
        micPermissionAlert: "🎙️ Speech recognition not allowed"
    )

    static let chineseSimplified = QuizStrings(
        questionLabel:      "题目",
        scoreLabel:         "得分",
        optionsIntro:       "你的选项是：",
        yourAnswer:         "你的回答：",
        correct:            "✅ 正确!",
        wrong:              "❌ 错误!",
        mistakesLabel:      "错误:",
        nextQuestion:       "下一题",
        previous:           "上一题",
        skip:               "跳过",
        quit:               "退出",
        quitTitle:          "确定退出？",
        quitMessage:        "你确定要退出吗？",
        quitYes:            "是",
        quitNo:             "否",
        completed:          "测验完成！",
        failedTitle:        "你已经错了 4 题。",
        failedSubtitle:     "再接再厉！",
        correctLabel:       "正确：",
        incorrectLabel:     "错误：",
        restartQuiz:        "重新开始",
        micPermissionAlert: "🎙️ 语音识别受限"
    )

    static let chineseTraditional = QuizStrings(
        questionLabel:      "題目",
        scoreLabel:         "得分",
        optionsIntro:       "你的選項是：",
        yourAnswer:         "你的回答：",
        correct:            "✅ 正確!",
        wrong:              "❌ 錯誤!",
        mistakesLabel:      "錯誤:",
        nextQuestion:       "下一題",
        previous:           "上一題",
        skip:               "跳過",
        quit:               "退出",
        quitTitle:          "確定退出？",
        quitMessage:        "你確定要退出嗎？",
        quitYes:            "是",
        quitNo:             "否",
        completed:          "測驗完成！",
        failedTitle:        "你已經錯了 4 題。",
        failedSubtitle:     "再接再厲！",
        correctLabel:       "正確：",
        incorrectLabel:     "錯誤：",
        restartQuiz:        "重新開始",
        micPermissionAlert: "🎙️ 語音識別受限"
    )
}
