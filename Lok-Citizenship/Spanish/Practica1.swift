//
//  Practica1.swift
//  English ↔︎ Spanish – easy set
//

import SwiftUI
import Combine
import AVFoundation
import Speech

// ─────────────────────────────────────────────────────────────
// MARK:  Práctica 1  (English ↔︎ Spanish)
// ─────────────────────────────────────────────────────────────
struct Practica1: View {

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
            englishText:    "What is the supreme law of the land?",
            spanishText:    "¿Cuál es la ley suprema del país?",
            englishOptions: ["The Bill of Rights", "The Declaration", "The Constitution", "The Articles"],
            spanishOptions: ["La Carta de Derechos", "La Declaración", "La Constitución", "Los Artículos"],
            correctAnswer:  2
        ),

        BilingualQuestionES(
            englishText:    "Who makes federal laws?",
            spanishText:    "¿Quién hace las leyes federales?",
            englishOptions: ["The President", "Congress", "The Supreme Court", "The Military"],
            spanishOptions: ["El Presidente", "El Congreso", "La Corte Suprema", "El Ejército"],
            correctAnswer:  1
        ),

        BilingualQuestionES(
            englishText:    "What are the two parts of the U.S. Congress?",
            spanishText:    "¿Cuáles son las dos partes del Congreso de los Estados Unidos?",
            englishOptions: ["The Senate & The House", "The House & The President", "The Senate & The Cabinet", "The Military & The President"],
            spanishOptions: ["El Senado y la Cámara de Representantes",
                             "La Cámara de Representantes y el Presidente",
                             "El Senado y el Gabinete",
                             "El Ejército y el Presidente"],
            correctAnswer:  0
        ),

        BilingualQuestionES(
            englishText:    "What is the capital of the United States?",
            spanishText:    "¿Cuál es la capital de los Estados Unidos?",
            englishOptions: ["New York", "Washington D.C.", "Los Angeles", "Chicago"],
            spanishOptions: ["Nueva York", "Washington D. C.", "Los Ángeles", "Chicago"],
            correctAnswer:  1
        ),

        BilingualQuestionES(
            englishText:    "What are the two major political parties?",
            spanishText:    "¿Cuáles son los dos partidos políticos principales?",
            englishOptions: ["Democrats & Libertarian", "Federalists & Republicans", "Libertarian & Tories", "Democrats & Republicans"],
            spanishOptions: ["Demócratas y Libertarios",
                             "Federalistas y Republicanos",
                             "Libertarios y Conservadores",
                             "Demócratas y Republicanos"],
            correctAnswer:  3
        ),

        BilingualQuestionES(
            englishText:    "What color are the stars on the American flag?",
            spanishText:    "¿De qué color son las estrellas de la bandera estadounidense?",
            englishOptions: ["Blue", "White", "Red", "Yellow"],
            spanishOptions: ["Azul", "Blanco", "Rojo", "Amarillo"],
            correctAnswer:  1
        ),

        BilingualQuestionES(
            englishText:    "How many states are there in the United States?",
            spanishText:    "¿Cuántos estados hay en los Estados Unidos?",
            englishOptions: ["51", "49", "52", "50"],
            spanishOptions: ["51", "49", "52", "50"],
            correctAnswer:  3
        ),

        BilingualQuestionES(
            englishText:    "What is the name of the President of the United States?",
            spanishText:    "¿Cómo se llama el Presidente de los Estados Unidos?",
            englishOptions: ["Joe Biden", "George Bush", "Barack Obama", "Donald J. Trump"],
            spanishOptions: ["Joe Biden", "George Bush", "Barack Obama", "Donald J. Trump"],
            correctAnswer:  3
        ),

        BilingualQuestionES(
            englishText:    "What is the name of the Vice President of the United States?",
            spanishText:    "¿Cómo se llama la persona que ocupa la Vicepresidencia de los Estados Unidos?",
            englishOptions: ["Kamala Harris", "Mike Pence", "Nancy Pelosi", "JD Vance"],
            spanishOptions: ["Kamala Harris", "Mike Pence", "Nancy Pelosi", "JD Vance"],
            correctAnswer:  3
        ),

        BilingualQuestionES(
            englishText:    "What is one right in the First Amendment?",
            spanishText:    "¿Cuál es un derecho protegido por la Primera Enmienda?",
            englishOptions: ["Freedom to travel", "Right to vote", "Freedom of speech", "Right to education"],
            spanishOptions: ["Libertad de viajar", "Derecho al voto", "Libertad de expresión", "Derecho a la educación"],
            correctAnswer:  2
        ),

        BilingualQuestionES(
            englishText:    "What do we celebrate on July 4th?",
            spanishText:    "¿Qué celebramos el 4 de julio?",
            englishOptions: ["Memorial Day", "Independence Day", "Labor Day", "Thanksgiving"],
            spanishOptions: ["Día de los Caídos", "Día de la Independencia", "Día del Trabajo", "Acción de Gracias"],
            correctAnswer:  1
        ),

        BilingualQuestionES(
            englishText:    "Who is the Commander in Chief of the military?",
            spanishText:    "¿Quién es el Comandante en Jefe de las fuerzas armadas?",
            englishOptions: ["The President", "The Vice President", "The Senate", "The Supreme Court"],
            spanishOptions: ["El Presidente", "El Vicepresidente", "El Senado", "La Corte Suprema"],
            correctAnswer:  0
        ),

        BilingualQuestionES(
            englishText:    "What is the name of the national anthem?",
            spanishText:    "¿Cómo se llama el himno nacional?",
            englishOptions: ["This Land is Your Land", "God Bless America", "America the Beautiful", "The Star-Spangled Banner"],
            spanishOptions: ["Esta tierra es tu tierra",
                             "Dios bendiga a América",
                             "América la Bella",
                             "El estandarte adornado de estrellas"],
            correctAnswer:  3
        ),

        BilingualQuestionES(
            englishText:    "What do the 13 stripes on the U.S. flag represent?",
            spanishText:    "¿Qué representan las 13 franjas de la bandera de EE. UU.?",
            englishOptions: ["The 13 amendments", "The number of wars", "The 13 states", "The original 13 colonies"],
            spanishOptions: ["Las 13 enmiendas", "El número de guerras", "Los 13 estados", "Las 13 colonias originales"],
            correctAnswer:  3
        ),

        BilingualQuestionES(
            englishText:    "What is the highest court in the United States?",
            spanishText:    "¿Cuál es el tribunal más alto de los Estados Unidos?",
            englishOptions: ["The Supreme Court", "The Federal Court", "The Court of Appeals", "The Civil Court"],
            spanishOptions: ["La Corte Suprema", "El Tribunal Federal", "El Tribunal de Apelaciones", "El Tribunal Civil"],
            correctAnswer:  0
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
