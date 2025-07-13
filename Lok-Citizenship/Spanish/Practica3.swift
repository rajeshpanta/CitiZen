import SwiftUI
import Combine
import AVFoundation
import Speech

// ─────────────────────────────────────────────────────────────
// MARK:  Práctica 3  (English ↔︎ Spanish)
// ─────────────────────────────────────────────────────────────
struct Practica3: View {

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
            englishText:  "What do we call the first ten amendments to the Constitution?",
            spanishText:  "¿Cómo llamamos a las primeras diez enmiendas de la Constitución?",
            englishOptions: ["The Declaration of Independence", "The Bill of Rights", "The Articles of Confederation", "The Federalist Papers"],
            spanishOptions: ["La Declaración de Independencia",
                             "La Carta de Derechos",
                             "Los Artículos de la Confederación",
                             "Los Documentos Federalistas"],
            correctAnswer: 1
        ),

        BilingualQuestionES(
            englishText:  "What is the capital of your state?",
            spanishText:  "¿Cuál es la capital de su estado?",
            englishOptions: ["Depends on your state", "New York", "Los Angeles", "Chicago"],
            spanishOptions: ["Depende de su estado", "Nueva York", "Los Ángeles", "Chicago"],
            correctAnswer: 0
        ),

        BilingualQuestionES(
            englishText:  "Who was the first President of the United States?",
            spanishText:  "¿Quién fue el primer Presidente de los Estados Unidos?",
            englishOptions: ["John Adams", "Thomas Jefferson", "George Washington", "Benjamin Franklin"],
            spanishOptions: ["John Adams", "Thomas Jefferson", "George Washington", "Benjamin Franklin"],
            correctAnswer: 2
        ),

        BilingualQuestionES(
            englishText:  "What did the Emancipation Proclamation do?",
            spanishText:  "¿Qué hizo la Proclamación de Emancipación?",
            englishOptions: ["Ended the Civil War", "Freed the slaves", "Established a national bank", "Declared independence from Britain"],
            spanishOptions: ["Terminó la Guerra Civil",
                             "Liberó a los esclavos",
                             "Estableció un banco nacional",
                             "Declaró la independencia de Gran Bretaña"],
            correctAnswer: 1
        ),

        BilingualQuestionES(
            englishText:  "Who is the Speaker of the House of Representatives now?",
            spanishText:  "¿Quién es actualmente el Presidente de la Cámara de Representantes?",
            englishOptions: ["Nancy Pelosi", "Kevin McCarthy", "Mitch McConnell", "Mike Johnson"],
            spanishOptions: ["Nancy Pelosi", "Kevin McCarthy", "Mitch McConnell", "Mike Johnson"],
            correctAnswer: 3
        ),

        BilingualQuestionES(
            englishText:  "How many justices are on the Supreme Court?",
            spanishText:  "¿Cuántos jueces hay en la Corte Suprema?",
            englishOptions: ["7", "9", "11", "13"],
            spanishOptions: ["7", "9", "11", "13"],
            correctAnswer: 1
        ),

        BilingualQuestionES(
            englishText:  "What did Susan B. Anthony do?",
            spanishText:  "¿Qué hizo Susan B. Anthony?",
            englishOptions: ["Fought for women's rights", "Wrote the Constitution", "Discovered America", "Became the first female President"],
            spanishOptions: ["Luchó por los derechos de las mujeres",
                             "Escribió la Constitución",
                             "Descubrió América",
                             "Se convirtió en la primera Presidenta"],
            correctAnswer: 0
        ),

        BilingualQuestionES(
            englishText:  "What movement tried to end racial discrimination?",
            spanishText:  "¿Qué movimiento intentó acabar con la discriminación racial?",
            englishOptions: ["The Civil Rights Movement", "The Women's Movement", "The American Revolution", "The Abolitionist Movement"],
            spanishOptions: ["El Movimiento por los Derechos Civiles",
                             "El Movimiento de Mujeres",
                             "La Revolución Americana",
                             "El Movimiento Abolicionista"],
            correctAnswer: 0
        ),

        BilingualQuestionES(
            englishText:  "What was one important thing that Abraham Lincoln did?",
            spanishText:  "¿Cuál fue una cosa importante que hizo Abraham Lincoln?",
            englishOptions: ["Established the U.S. Navy", "Freed the slaves", "Fought in the Revolutionary War", "Wrote the Bill of Rights"],
            spanishOptions: ["Estableció la Armada de EE. UU.",
                             "Liberó a los esclavos",
                             "Luchó en la Guerra de la Independencia",
                             "Escribió la Carta de Derechos"],
            correctAnswer: 1
        ),

        BilingualQuestionES(
            englishText:  "Why does the U.S. flag have 50 stars?",
            spanishText:  "¿Por qué la bandera de EE. UU. tiene 50 estrellas?",
            englishOptions: ["For the 50 Presidents", "For the 50 states", "For the 50 amendments", "For the 50 years of independence"],
            spanishOptions: ["Por los 50 Presidentes",
                             "Por los 50 estados",
                             "Por las 50 enmiendas",
                             "Por los 50 años de independencia"],
            correctAnswer: 1
        ),

        BilingualQuestionES(
            englishText:  "When do we vote for President?",
            spanishText:  "¿Cuándo votamos para Presidente?",
            englishOptions: ["January", "March", "November", "December"],
            spanishOptions: ["Enero", "Marzo", "Noviembre", "Diciembre"],
            correctAnswer: 2
        ),

        BilingualQuestionES(
            englishText:  "What is one reason colonists came to America?",
            spanishText:  "¿Cuál es una razón por la que los colonos vinieron a América?",
            englishOptions: ["To escape taxes", "Religious freedom", "To join the military", "To find gold"],
            spanishOptions: ["Para escapar de los impuestos",
                             "Libertad religiosa",
                             "Para unirse al ejército",
                             "Para encontrar oro"],
            correctAnswer: 1
        ),

        BilingualQuestionES(
            englishText:  "Who wrote the Federalist Papers?",
            spanishText:  "¿Quién escribió los Documentos Federalistas?",
            englishOptions: ["Thomas Jefferson", "James Madison, Alexander Hamilton, John Jay", "George Washington", "Ben Franklin"],
            spanishOptions: ["Thomas Jefferson",
                             "James Madison, Alexander Hamilton, John Jay",
                             "George Washington",
                             "Ben Franklin"],
            correctAnswer: 1
        ),

        BilingualQuestionES(
            englishText:  "Who was the President during World War I?",
            spanishText:  "¿Quién era el Presidente durante la Primera Guerra Mundial?",
            englishOptions: ["Franklin D. Roosevelt", "Woodrow Wilson", "Harry Truman", "Dwight D. Eisenhower"],
            spanishOptions: ["Franklin D. Roosevelt", "Woodrow Wilson", "Harry Truman", "Dwight D. Eisenhower"],
            correctAnswer: 1
        ),

        BilingualQuestionES(
            englishText:  "What is one U.S. territory?",
            spanishText:  "¿Cuál es un territorio de los Estados Unidos?",
            englishOptions: ["Hawaii", "Puerto Rico", "Alaska", "Canada"],
            spanishOptions: ["Hawái", "Puerto Rico", "Alaska", "Canadá"],
            correctAnswer: 1
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
