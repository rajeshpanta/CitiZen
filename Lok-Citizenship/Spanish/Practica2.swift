import SwiftUI
import Combine
import AVFoundation
import Speech

// ─────────────────────────────────────────────────────────────
// MARK:  Práctica 2  (English ↔︎ Spanish)
// ─────────────────────────────────────────────────────────────
struct Practica2: View {

    // 1 ▸ STATE & MODEL ──────────────────────────────────────
    @StateObject private var quizLogic = QuizLogica()

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
    
    let questions: [BilingualQuestionES] = [

        BilingualQuestionES(
            englishText:  "Who wrote the Declaration of Independence?",
            spanishText:  "¿Quién redactó la Declaración de Independencia?",
            englishOptions: ["George Washington", "Abraham Lincoln", "Benjamin Franklin", "Thomas Jefferson"],
            spanishOptions: ["George Washington", "Abraham Lincoln", "Benjamin Franklin", "Thomas Jefferson"],
            correctAnswer: 3
        ),

        BilingualQuestionES(
            englishText:  "How many U.S. Senators are there?",
            spanishText:  "¿Cuántos senadores hay en los Estados Unidos?",
            englishOptions: ["50", "100", "435", "200"],
            spanishOptions: ["50", "100", "435", "200"],
            correctAnswer: 1
        ),

        BilingualQuestionES(
            englishText:  "How long is a term for a U.S. Senator?",
            spanishText:  "¿Cuánto dura el mandato de un senador de los Estados Unidos?",
            englishOptions: ["4 years", "2 years", "6 years", "8 years"],
            spanishOptions: ["4 años", "2 años", "6 años", "8 años"],
            correctAnswer: 2
        ),

        BilingualQuestionES(
            englishText:  "What is one responsibility of a U.S. citizen?",
            spanishText:  "¿Cuál es una responsabilidad de un ciudadano de los Estados Unidos?",
            englishOptions: ["Vote in elections", "Own a business", "Pay for health insurance", "Travel abroad"],
            spanishOptions: ["Votar en las elecciones",
                             "Tener un negocio",
                             "Pagar un seguro médico",
                             "Viajar al extranjero"],
            correctAnswer: 0
        ),

        BilingualQuestionES(
            englishText:  "Who is the Father of Our Country?",
            spanishText:  "¿Quién es el Padre de la Patria?",
            englishOptions: ["George Washington", "Thomas Jefferson", "Abraham Lincoln", "John Adams"],
            spanishOptions: ["George Washington", "Thomas Jefferson", "Abraham Lincoln", "John Adams"],
            correctAnswer: 0
        ),

        BilingualQuestionES(
            englishText:  "What is one promise you make when you become a U.S. citizen?",
            spanishText:  "¿Cuál es una promesa que hace cuando se convierte en ciudadano de los Estados Unidos?",
            englishOptions: ["Speak only English", "Always vote in elections", "Get a college degree", "Obey the laws of the United States"],
            spanishOptions: ["Hablar solo inglés",
                             "Votar siempre en las elecciones",
                             "Obtener un título universitario",
                             "Obedecer las leyes de los Estados Unidos"],
            correctAnswer: 3
        ),

        BilingualQuestionES(
            englishText:  "What ocean is on the West Coast of the United States?",
            spanishText:  "¿Qué océano está en la costa oeste de los Estados Unidos?",
            englishOptions: ["Atlantic Ocean", "Pacific Ocean", "Indian Ocean", "Arctic Ocean"],
            spanishOptions: ["Océano Atlántico", "Océano Pacífico", "Océano Índico", "Océano Ártico"],
            correctAnswer: 1
        ),

        BilingualQuestionES(
            englishText:  "What is the economic system in the United States?",
            spanishText:  "¿Cuál es el sistema económico de los Estados Unidos?",
            englishOptions: ["Socialism", "Communism", "Capitalism", "Monarchy"],
            spanishOptions: ["Socialismo", "Comunismo", "Capitalismo", "Monarquía"],
            correctAnswer: 2
        ),

        BilingualQuestionES(
            englishText:  "How many voting members are in the House of Representatives?",
            spanishText:  "¿Cuántos miembros con derecho a voto hay en la Cámara de Representantes?",
            englishOptions: ["200", "100", "50", "435"],
            spanishOptions: ["200", "100", "50", "435"],
            correctAnswer: 3
        ),

        BilingualQuestionES(
            englishText:  "What is the rule of law?",
            spanishText:  "¿Qué es el estado de derecho?",
            englishOptions: ["Everyone must follow the law", "The President is above the law", "Judges are above the law", "Only lawmakers follow the law"],
            spanishOptions: ["Todos deben obedecer la ley",
                             "El Presidente está por encima de la ley",
                             "Los jueces están por encima de la ley",
                             "Solo los legisladores obedecen la ley"],
            correctAnswer: 0
        ),

        BilingualQuestionES(
            englishText:  "What is freedom of religion?",
            spanishText:  "¿Qué es la libertad de religión?",
            englishOptions: ["You can only practice major religions", "You must follow the government religion", "You can practice any religion, or not practice a religion", "You can never change your religion"],
            spanishOptions: ["Solo puede practicar religiones principales",
                             "Debe seguir la religión del gobierno",
                             "Puede practicar cualquier religión o no practicar ninguna",
                             "Nunca puede cambiar de religión"],
            correctAnswer: 2
        ),

        BilingualQuestionES(
            englishText:  "What does the Constitution do?",
            spanishText:  "¿Qué hace la Constitución?",
            englishOptions: ["Declares war", "Defines laws for voting", "Sets up the government", "Gives advice to the President"],
            spanishOptions: ["Declara la guerra",
                             "Define leyes para votar",
                             "Establece el gobierno",
                             "Da consejos al Presidente"],
            correctAnswer: 2
        ),

        BilingualQuestionES(
            englishText:  "What stops one branch of government from becoming too powerful?",
            spanishText:  "¿Qué evita que una rama del gobierno se vuelva demasiado poderosa?",
            englishOptions: ["The Supreme Court", "The military", "The people", "Checks and balances"],
            spanishOptions: ["La Corte Suprema",
                             "El ejército",
                             "El pueblo",
                             "Controles y equilibrios"],
            correctAnswer: 3
        ),

        BilingualQuestionES(
            englishText:  "Name one branch or part of the government.",
            spanishText:  "Nombre una rama o parte del gobierno.",
            englishOptions: ["Lawmakers", "Legislative branch (Congress)", "Governors", "The Police"],
            spanishOptions: ["Legisladores",
                             "Rama legislativa (Congreso)",
                             "Gobernadores",
                             "La Policía"],
            correctAnswer: 1
        ),

        BilingualQuestionES(
            englishText:  "What is an amendment?",
            spanishText:  "¿Qué es una enmienda?",
            englishOptions: ["A change to the Constitution", "A law", "A government branch", "A tax"],
            spanishOptions: ["Un cambio a la Constitución",
                             "Una ley",
                             "Una rama del gobierno",
                             "Un impuesto"],
            correctAnswer: 0
        )
    ]
    // Helper: locale for TTS/STT
    private func localeCode() -> String {
        quizLogic.selectedLanguage == .english ? "en-US" : "es-ES"
    }

    // ─────────────────────────────────────────────────────────
    // MARK:  BODY
    // ─────────────────────────────────────────────────────────
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                /* language switch */
                languageToggle

                /* live progress bar & counters */
                VStack {
                    ProgressView(value: Double(quizLogic.attemptedQuestions),
                                 total: Double(max(quizLogic.totalQuestions, 1)))
                        .accentColor(.green)
                    Text("\(quizLogic.attemptedQuestions)/\(quizLogic.totalQuestions)  •  " +
                         (quizLogic.selectedLanguage == .english
                          ? "Score \(quizLogic.scorePercentage)%"
                          : "Puntuación \(quizLogic.scorePercentage)%"))
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
        .alert("🎙️ Speech recognition not allowed",
               isPresented: $micPermissionDenied,
               actions: { Button("OK", role: .cancel) {} })
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
            langButton("🇺🇸 English",   .english)
            Spacer()
            langButton("🇪🇸 Español",   .spanish)
        }
        .padding(.horizontal)
    }

    private func langButton(_ label: String, _ lang: AppLanguage) -> some View {
        Button(label) {
            stopAllAudio()
            quizLogic.switchLanguage(to: lang)
        }
        .padding()
        .background(quizLogic.selectedLanguage == lang ? Color.blue : Color.gray)
        .foregroundColor(.white)
        .cornerRadius(10)
    }

    /* question + answers */
    private var questionCard: some View {
        VStack(spacing: 20) {

            /* Question text + 🔊 */
            VStack(alignment: .leading, spacing: 6) {
                Text("\(quizLogic.selectedLanguage == .english ? "Question" : "Pregunta") " +
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
                Text("🎤 " + (quizLogic.selectedLanguage == .english ? "Your Answer:" : "Tu respuesta:"))
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
            Button(quizLogic.selectedLanguage == .english ? "Previous" : "Anterior") {
                stopAllAudio(); quizLogic.previousQuestion(); resetPerQuestionState()
            }
            .disabled(quizLogic.currentQuestionIndex == 0)
            .foregroundColor(.white).padding().background(Color.gray).cornerRadius(10)

            Spacer()

            Button(quizLogic.selectedLanguage == .english ? "Skip" : "Saltar") {
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
                 ? (quizLogic.selectedLanguage == .english ? "✅ Correct!" : "✅ ¡Correcto!")
                 : (quizLogic.selectedLanguage == .english ? "❌ Wrong!"   : "❌ ¡Incorrecto!"))
                .font(.headline).foregroundColor(isAnswerCorrect ? .green : .red)

            Text(quizLogic.selectedLanguage == .english
                 ? "Mistakes: \(quizLogic.incorrectAnswers)/4"
                 : "Errores: \(quizLogic.incorrectAnswers)/4")
                .foregroundColor(.orange)

            Button(quizLogic.selectedLanguage == .english ? "Next Question" : "Siguiente pregunta") {
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
                     : "Has cometido 4 errores.")
                    .font(.largeTitle).bold().foregroundColor(.red)
                Text(quizLogic.selectedLanguage == .english
                     ? "Better luck next time!"
                     : "¡Mejor suerte la próxima vez!")
                    .foregroundColor(.white)
            } else {
                Text(quizLogic.selectedLanguage == .english
                     ? "Quiz Completed!"
                     : "¡Cuestionario completado!")
                    .font(.largeTitle).bold().foregroundColor(.white)
            }

            Text(quizLogic.selectedLanguage == .english
                 ? "Correct: \(quizLogic.correctAnswers)"
                 : "Correctas: \(quizLogic.correctAnswers)")
                .foregroundColor(.green)

            Text(quizLogic.selectedLanguage == .english
                 ? "Incorrect: \(quizLogic.incorrectAnswers)"
                 : "Incorrectas: \(quizLogic.incorrectAnswers)")
                .foregroundColor(.red)

            Text(quizLogic.selectedLanguage == .english
                 ? "Score: \(quizLogic.scorePercentage)%"
                 : "Puntuación: \(quizLogic.scorePercentage)%")
                .font(.headline).foregroundColor(.yellow)

            Button(quizLogic.selectedLanguage == .english ? "Restart Quiz" : "Reiniciar") {
                stopAllAudio(); quizLogic.startQuiz(); resetPerQuestionState()
            }
            .padding().background(Color.blue).foregroundColor(.white).cornerRadius(10)
        }
        .padding()
    }

    // Background
    private var background: some View {
        ZStack {
            Image("BackgroundImage").resizable().scaledToFill()
            Color.black.opacity(0.8)
        }
        .ignoresSafeArea()
    }

    /* quit button + alert */
    private var quitButton: some View {
        Button(quizLogic.selectedLanguage == .english ? "Quit" : "Salir") {
            stopAllAudio(); showQuitConfirmation = true
        }
        .foregroundColor(.red)
    }

    private func quitAlert() -> Alert {
        Alert(
            title: Text(quizLogic.selectedLanguage == .english ? "Quit Quiz?" : "¿Salir del cuestionario?"),
            message: Text(quizLogic.selectedLanguage == .english ? "Are you sure you want to quit?" : "¿Seguro que deseas salir?"),
            primaryButton: .destructive(Text(quizLogic.selectedLanguage == .english ? "Yes" : "Sí")) {
                stopAllAudio(); presentationMode.wrappedValue.dismiss()
            },
            secondaryButton: .cancel(Text(quizLogic.selectedLanguage == .english ? "No" : "No"))
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

    // Helpers to pick the right language strings -------------
    private func textQuestion() -> String {
        quizLogic.selectedLanguage == .english
        ? quizLogic.currentQuestion.englishText
        : quizLogic.currentQuestion.spanishText
    }

    private func textOption(_ idx: Int) -> String {
        quizLogic.selectedLanguage == .english
        ? quizLogic.currentQuestion.englishOptions[idx]
        : quizLogic.currentQuestion.spanishOptions[idx]
    }

    private func optionsIntroText() -> String {
        quizLogic.selectedLanguage == .english ? "Your options are:" : "Tus opciones son:"
    }

    private func optionsForCurrentLanguage() -> [String] {
        quizLogic.selectedLanguage == .english
        ? quizLogic.currentQuestion.englishOptions
        : quizLogic.currentQuestion.spanishOptions
    }
}
