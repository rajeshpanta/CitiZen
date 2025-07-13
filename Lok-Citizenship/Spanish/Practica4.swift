import SwiftUI
import Combine
import AVFoundation
import Speech

// ─────────────────────────────────────────────────────────────
// MARK:  Práctica 4  (English ↔︎ Spanish)
// ─────────────────────────────────────────────────────────────
struct Practica4: View {

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
            englishText:  "What was the main purpose of the Federalist Papers?",
            spanishText:  "¿Cuál fue el propósito principal de los Documentos Federalistas?",
            englishOptions: ["To declare independence from Britain",
                             "To promote the ratification of the U.S. Constitution",
                             "To outline the Bill of Rights",
                             "To establish a national bank"],
            spanishOptions: ["Declarar la independencia de Gran Bretaña",
                             "Promover la ratificación de la Constitución de EE. UU.",
                             "Exponer la Carta de Derechos",
                             "Establecer un banco nacional"],
            correctAnswer: 1
        ),

        BilingualQuestionES(
            englishText:  "Which amendment abolished slavery?",
            spanishText:  "¿Qué enmienda abolió la esclavitud?",
            englishOptions: ["13th Amendment", "14th Amendment", "15th Amendment", "19th Amendment"],
            spanishOptions: ["13.ª Enmienda", "14.ª Enmienda", "15.ª Enmienda", "19.ª Enmienda"],
            correctAnswer: 0
        ),

        BilingualQuestionES(
            englishText:  "What landmark case established judicial review?",
            spanishText:  "¿Qué caso histórico estableció la revisión judicial?",
            englishOptions: ["Marbury v. Madison", "Brown v. Board of Education", "Roe v. Wade", "McCulloch v. Maryland"],
            spanishOptions: ["Marbury v. Madison", "Brown v. Board of Education", "Roe v. Wade", "McCulloch v. Maryland"],
            correctAnswer: 0
        ),

        BilingualQuestionES(
            englishText:  "What is the maximum number of years a President can serve?",
            spanishText:  "¿Cuál es el número máximo de años que puede servir un Presidente?",
            englishOptions: ["4 years", "8 years", "10 years", "12 years"],
            spanishOptions: ["4 años", "8 años", "10 años", "12 años"],
            correctAnswer: 1
        ),

        BilingualQuestionES(
            englishText:  "What war was fought between the North and South in the U.S.?",
            spanishText:  "¿Qué guerra se libró entre el Norte y el Sur en EE. UU.?",
            englishOptions: ["Revolutionary War", "World War 1", "The Civil War", "The War of 1812"],
            spanishOptions: ["Guerra de la Independencia",
                             "Primera Guerra Mundial",
                             "La Guerra Civil",
                             "La Guerra de 1812"],
            correctAnswer: 2
        ),

        BilingualQuestionES(
            englishText:  "What was the main reason the U.S. entered World War II?",
            spanishText:  "¿Cuál fue la principal razón por la que EE. UU. entró en la Segunda Guerra Mundial?",
            englishOptions: ["To support Britain and France",
                             "To stop the spread of communism",
                             "The attack on Pearl Harbor",
                             "To defend against Germany"],
            spanishOptions: ["Apoyar a Gran Bretaña y Francia",
                             "Detener la expansión del comunismo",
                             "El ataque a Pearl Harbor",
                             "Defenderse de Alemania"],
            correctAnswer: 2
        ),

        BilingualQuestionES(
            englishText:  "What did the Monroe Doctrine declare?",
            spanishText:  "¿Qué declaró la Doctrina Monroe?",
            englishOptions: ["Europe should not interfere in the Americas",
                             "Slavery is abolished",
                             "The U.S. must remain neutral in global conflicts",
                             "The Louisiana Purchase is legal"],
            spanishOptions: ["Europa no debe interferir en las Américas",
                             "La esclavitud está abolida",
                             "EE. UU. debe permanecer neutral en los conflictos globales",
                             "La Compra de Luisiana es legal"],
            correctAnswer: 0
        ),

        BilingualQuestionES(
            englishText:  "Which U.S. President served more than two terms?",
            spanishText:  "¿Qué Presidente de EE. UU. sirvió más de dos mandatos?",
            englishOptions: ["George Washington", "Theodore Roosevelt", "Franklin D. Roosevelt", "Dwight D. Eisenhower"],
            spanishOptions: ["George Washington", "Theodore Roosevelt", "Franklin D. Roosevelt", "Dwight D. Eisenhower"],
            correctAnswer: 2
        ),

        BilingualQuestionES(
            englishText:  "What is the term length for a Supreme Court Justice?",
            spanishText:  "¿Cuál es la duración del mandato de un juez de la Corte Suprema?",
            englishOptions: ["4 years", "8 years", "12 years", "Life"],
            spanishOptions: ["4 años", "8 años", "12 años", "De por vida"],
            correctAnswer: 3
        ),

        BilingualQuestionES(
            englishText:  "Who was the Chief Justice of the Supreme Court in 2023?",
            spanishText:  "¿Quién era el Presidente de la Corte Suprema en 2023?",
            englishOptions: ["John G. Roberts", "Clarence Thomas", "Sonia Sotomayor", "Amy Coney Barrett"],
            spanishOptions: ["John G. Roberts", "Clarence Thomas", "Sonia Sotomayor", "Amy Coney Barrett"],
            correctAnswer: 0
        ),

        BilingualQuestionES(
            englishText:  "Which branch of government has the power to declare war?",
            spanishText:  "¿Qué rama del gobierno tiene el poder de declarar la guerra?",
            englishOptions: ["The President", "The Supreme Court", "Congress", "The Vice President"],
            spanishOptions: ["El Presidente", "La Corte Suprema", "El Congreso", "El Vicepresidente"],
            correctAnswer: 2
        ),

        BilingualQuestionES(
            englishText:  "What was the purpose of the Marshall Plan?",
            spanishText:  "¿Cuál fue el propósito del Plan Marshall?",
            englishOptions: ["To rebuild Europe after World War 2",
                             "To prevent communism in the U.S.",
                             "To provide U.S. military aid",
                             "To negotiate peace with Japan"],
            spanishOptions: ["Reconstruir Europa después de la Segunda Guerra Mundial",
                             "Prevenir el comunismo en EE. UU.",
                             "Proporcionar ayuda militar estadounidense",
                             "Negociar la paz con Japón"],
            correctAnswer: 0
        ),

        BilingualQuestionES(
            englishText:  "Which constitutional amendment granted women the right to vote?",
            spanishText:  "¿Qué enmienda constitucional otorgó a las mujeres el derecho al voto?",
            englishOptions: ["15th Amendment", "19th Amendment", "21st Amendment", "26th Amendment"],
            spanishOptions: ["15.ª Enmienda", "19.ª Enmienda", "21.ª Enmienda", "26.ª Enmienda"],
            correctAnswer: 1
        ),

        BilingualQuestionES(
            englishText:  "Which U.S. state was an independent republic before joining the Union?",
            spanishText:  "¿Qué estado de EE. UU. fue una república independiente antes de unirse a la Unión?",
            englishOptions: ["Hawaii", "California", "Texas", "Alaska"],
            spanishOptions: ["Hawái", "California", "Texas", "Alaska"],
            correctAnswer: 2
        ),

        BilingualQuestionES(
            englishText:  "Who was President during the Great Depression and World War II?",
            spanishText:  "¿Quién era Presidente durante la Gran Depresión y la Segunda Guerra Mundial?",
            englishOptions: ["Woodrow Wilson", "Herbert Hoover", "Franklin D. Roosevelt", "Harry Truman"],
            spanishOptions: ["Woodrow Wilson", "Herbert Hoover", "Franklin D. Roosevelt", "Harry Truman"],
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
