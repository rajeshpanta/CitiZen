import SwiftUI
import Combine
import AVFoundation
import Speech

// ─────────────────────────────────────────────────────────────
// MARK:  Práctica 5  (English ↔︎ Spanish)
// ─────────────────────────────────────────────────────────────
struct Practica5: View {

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
            englishText:  "The House of Representatives has how many voting members?",
            spanishText:  "¿Cuántos miembros con derecho a voto hay en la Cámara de Representantes?",
            englishOptions: ["100", "435", "50", "200"],
            spanishOptions:  ["100", "435", "50", "200"],
            correctAnswer: 1
        ),

        BilingualQuestionES(
            englishText:  "If both the President and the Vice President can no longer serve, who becomes President?",
            spanishText:  "Si el Presidente y el Vicepresidente ya no pueden servir, ¿quién se convierte en Presidente?",
            englishOptions: ["The Speaker of the House", "The Chief Justice", "The Secretary of State", "The Senate Majority Leader"],
            spanishOptions:  ["El Presidente de la Cámara", "El Presidente del Tribunal Supremo", "El Secretario de Estado", "El líder de la mayoría del Senado"],
            correctAnswer: 0
        ),

        BilingualQuestionES(
            englishText:  "Under the Constitution, some powers belong to the federal government. What is one power of the federal government?",
            spanishText:  "Según la Constitución, algunos poderes pertenecen al gobierno federal. ¿Cuál es un poder del gobierno federal?",
            englishOptions: ["To issue driver’s licenses", "To create an army", "To set up schools", "To regulate marriages"],
            spanishOptions:  ["Expedir licencias de conducir", "Crear un ejército", "Establecer escuelas", "Regular matrimonios"],
            correctAnswer: 1
        ),

        BilingualQuestionES(
            englishText:  "Under our Constitution, some powers belong to the states. What is one power of the states?",
            spanishText:  "Según nuestra Constitución, algunos poderes pertenecen a los estados. ¿Cuál es un poder de los estados?",
            englishOptions: ["To make treaties", "To create an army", "To print money", "Establish and run public schools"],
            spanishOptions:  ["Hacer tratados", "Crear un ejército", "Imprimir dinero", "Establecer y administrar escuelas públicas"],
            correctAnswer: 3
        ),

        BilingualQuestionES(
            englishText:  "Who is the Commander in Chief of the military?",
            spanishText:  "¿Quién es el Comandante en Jefe de las fuerzas armadas?",
            englishOptions: ["The President", "The Vice President", "The Secretary of Defense", "The Speaker of the House"],
            spanishOptions:  ["El Presidente", "El Vicepresidente", "El Secretario de Defensa", "El Presidente de la Cámara"],
            correctAnswer: 0
        ),

        BilingualQuestionES(
            englishText:  "What are two rights in the Declaration of Independence?",
            spanishText:  "¿Cuáles son dos derechos en la Declaración de Independencia?",
            englishOptions: ["Right to bear arms and right to vote",
                             "Right to work and right to protest",
                             "Life and Liberty",
                             "Freedom of speech and freedom of religion"],
            spanishOptions:  ["Derecho a portar armas y derecho a votar",
                              "Derecho al trabajo y derecho a protestar",
                              "Vida y Libertad",
                              "Libertad de expresión y libertad de religión"],
            correctAnswer: 2
        ),

        BilingualQuestionES(
            englishText:  "What is the ‘rule of law’?",
            spanishText:  "¿Qué es el ‘estado de derecho’?",
            englishOptions: ["The government can ignore laws",
                             "No one is above the law",
                             "Only federal judges follow the law",
                             "The Constitution is not legally binding"],
            spanishOptions:  ["El gobierno puede ignorar las leyes",
                              "Nadie está por encima de la ley",
                              "Solo los jueces federales cumplen la ley",
                              "La Constitución no es jurídicamente vinculante"],
            correctAnswer: 1
        ),

        BilingualQuestionES(
            englishText:  "What does the judicial branch do?",
            spanishText:  "¿Qué hace la rama judicial?",
            englishOptions: ["Makes laws", "Interprets the law", "Elects the President", "Controls the military"],
            spanishOptions:  ["Hace leyes", "Interpreta la ley", "Elige al Presidente", "Controla las fuerzas armadas"],
            correctAnswer: 1
        ),

        BilingualQuestionES(
            englishText:  "There are four amendments to the Constitution about who can vote. Describe one of them.",
            spanishText:  "Hay cuatro enmiendas a la Constitución sobre quién puede votar. Describa una de ellas.",
            englishOptions: ["Only landowners can vote",
                             "Only white men can vote",
                             "Citizens 18 and older can vote",
                             "Voting is mandatory"],
            spanishOptions:  ["Solo los propietarios pueden votar",
                              "Solo los hombres blancos pueden votar",
                              "Los ciudadanos de 18 años o más pueden votar",
                              "El voto es obligatorio"],
            correctAnswer: 2
        ),

        BilingualQuestionES(
            englishText:  "Why do some states have more Representatives than other states?",
            spanishText:  "¿Por qué algunos estados tienen más Representantes que otros?",
            englishOptions: ["Because they are bigger",
                             "Because they have more people",
                             "Because they were part of the original 13 colonies",
                             "Because they have more senators"],
            spanishOptions:  ["Porque son más grandes",
                              "Porque tienen más población",
                              "Porque formaban parte de las 13 colonias originales",
                              "Porque tienen más senadores"],
            correctAnswer: 1
        ),

        BilingualQuestionES(
            englishText:  "What was the main concern of the United States during the Cold War?",
            spanishText:  "¿Cuál fue la principal preocupación de EE. UU. durante la Guerra Fría?",
            englishOptions: ["Nuclear disarmament", "Terrorism", "The spread of communism", "World War 3"],
            spanishOptions:  ["El desarme nuclear", "El terrorismo", "La expansión del comunismo", "Una Tercera Guerra Mundial"],
            correctAnswer: 2
        ),

        BilingualQuestionES(
            englishText:  "What major event happened on September 11, 2001, in the United States?",
            spanishText:  "¿Qué hecho importante ocurrió el 11 de septiembre de 2001 en los Estados Unidos?",
            englishOptions: ["The U.S. declared war on Iraq",
                             "Terrorists attacked the United States",
                             "The Great Recession began",
                             "Hurricane Katrina struck"],
            spanishOptions:  ["EE. UU. declaró la guerra a Irak",
                              "Terroristas atacaron los Estados Unidos",
                              "Comenzó la Gran Recesión",
                              "El huracán Katrina golpeó"],
            correctAnswer: 1
        ),

        BilingualQuestionES(
            englishText:  "What are two rights of everyone living in the United States?",
            spanishText:  "¿Cuáles son dos derechos de todas las personas que viven en los Estados Unidos?",
            englishOptions: ["Right to vote & right to work",
                             "Freedom of speech & freedom of religion",
                             "Right to own land & right to healthcare",
                             "Right to drive & right to a free education"],
            spanishOptions:  ["Derecho a votar y derecho a trabajar",
                              "Libertad de expresión y libertad de religión",
                              "Derecho a poseer tierras y derecho a la atención médica",
                              "Derecho a conducir y derecho a una educación gratuita"],
            correctAnswer: 1
        ),

        BilingualQuestionES(
            englishText:  "What did the Civil Rights Movement do?",
            spanishText:  "¿Qué hizo el Movimiento por los Derechos Civiles?",
            englishOptions: ["Fought for women’s rights",
                             "Fought for workers' rights",
                             "Fought for U.S. independence",
                             "Fought for the end of segregation and racial discrimination"],
            spanishOptions:  ["Luchó por los derechos de las mujeres",
                              "Luchó por los derechos de los trabajadores",
                              "Luchó por la independencia de EE. UU.",
                              "Luchó por el fin de la segregación y la discriminación racial"],
            correctAnswer: 3
        ),

        BilingualQuestionES(
            englishText:  "What is one promise you make when you become a U.S. citizen?",
            spanishText:  "¿Cuál es una promesa que hace cuando se convierte en ciudadano de EE. UU.?",
            englishOptions: ["To always vote",
                             "To support your birth country",
                             "To obey U.S. laws",
                             "To join the U.S. military"],
            spanishOptions:  ["Votar siempre",
                              "Apoyar a su país de nacimiento",
                              "Obedecer las leyes de EE. UU.",
                              "Unirse a las fuerzas armadas de EE. UU."],
            correctAnswer: 2
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
