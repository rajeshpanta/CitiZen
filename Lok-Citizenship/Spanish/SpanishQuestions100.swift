/// All Spanish (English ↔ Español) quiz question sets — the 100 official 2008 USCIS
/// naturalization civics questions, organized into 10 interview-style practice sets
/// of exactly 10 questions each. IDs (`q_08_NNN`) match EnglishQuestions100.
///
/// Each question has 2 variants: [English, Spanish]. correctAnswer index is identical
/// across variants — only the text is translated.
enum SpanishQuestions100 {

    // MARK: - Practice Set 1: Principios de la democracia (Q1–Q10)
    static let practice1: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_001", correctAnswer: 2, variants: [
            .init(text: "What is the supreme law of the land?",
                  options: ["The Declaration of Independence", "The Bill of Rights", "The Constitution", "The Federalist Papers"],
                  explanation: "The Constitution is the supreme law of the United States. All other laws must be consistent with it."),
            .init(text: "¿Cuál es la ley suprema de la nación?",
                  options: ["La Declaración de Independencia", "La Carta de Derechos", "La Constitución", "Los Documentos Federalistas"],
                  explanation: "La Constitución es la ley suprema de los Estados Unidos. Todas las demás leyes deben ser compatibles con ella.")
        ]),
        UnifiedQuestion(id: "q_08_002", correctAnswer: 1, variants: [
            .init(text: "What does the Constitution do?",
                  options: ["Establishes the U.S. military", "Sets up the government and protects basic rights of Americans", "Lists every federal law", "Declares independence from Britain"],
                  explanation: "The Constitution defines the structure of the U.S. government and protects the basic rights of all Americans."),
            .init(text: "¿Qué hace la Constitución?",
                  options: ["Establece las fuerzas armadas de EE. UU.", "Organiza el gobierno y protege los derechos básicos de los estadounidenses", "Enumera todas las leyes federales", "Declara la independencia de Gran Bretaña"],
                  explanation: "La Constitución define la estructura del gobierno de EE. UU. y protege los derechos básicos de todos los estadounidenses.")
        ]),
        UnifiedQuestion(id: "q_08_003", correctAnswer: 1, variants: [
            .init(text: "The idea of self-government is in the first three words of the Constitution. What are these words?",
                  options: ["Life and Liberty", "We the People", "Equal Justice Under Law", "In God We Trust"],
                  explanation: "'We the People' opens the Preamble, establishing that all government authority comes from the citizens."),
            .init(text: "La idea del autogobierno está en las primeras tres palabras de la Constitución. ¿Cuáles son esas palabras?",
                  options: ["Vida y Libertad", "Nosotros, el Pueblo", "Igual Justicia ante la Ley", "En Dios Confiamos"],
                  explanation: "«Nosotros, el Pueblo» abre el Preámbulo, estableciendo que toda autoridad del gobierno proviene de los ciudadanos.")
        ]),
        UnifiedQuestion(id: "q_08_004", correctAnswer: 2, variants: [
            .init(text: "What is an amendment?",
                  options: ["A federal court ruling", "A presidential executive order", "A change or addition to the Constitution", "A temporary law passed by Congress"],
                  explanation: "An amendment is a formal change or addition to the Constitution."),
            .init(text: "¿Qué es una enmienda?",
                  options: ["Un fallo de un tribunal federal", "Una orden ejecutiva presidencial", "Un cambio o adición a la Constitución", "Una ley temporal aprobada por el Congreso"],
                  explanation: "Una enmienda es un cambio o adición formal a la Constitución.")
        ]),
        UnifiedQuestion(id: "q_08_005", correctAnswer: 3, variants: [
            .init(text: "What do we call the first ten amendments to the Constitution?",
                  options: ["The Federalist Papers", "The Articles of Confederation", "The Declaration of Rights", "The Bill of Rights"],
                  explanation: "The first ten amendments are the Bill of Rights, ratified in 1791."),
            .init(text: "¿Cómo llamamos a las primeras diez enmiendas de la Constitución?",
                  options: ["Los Documentos Federalistas", "Los Artículos de la Confederación", "La Declaración de Derechos", "La Carta de Derechos"],
                  explanation: "Las primeras diez enmiendas son la Carta de Derechos, ratificada en 1791.")
        ]),
        UnifiedQuestion(id: "q_08_006", correctAnswer: 1, variants: [
            .init(text: "What is one right or freedom from the First Amendment?",
                  options: ["Right to bear arms", "Freedom of speech", "Right to vote", "Right to a trial by jury"],
                  explanation: "The First Amendment protects five freedoms: religion, speech, press, assembly, and the right to petition the government."),
            .init(text: "¿Cuál es un derecho o libertad de la Primera Enmienda?",
                  options: ["Derecho a portar armas", "Libertad de expresión", "Derecho al voto", "Derecho a un juicio por jurado"],
                  explanation: "La Primera Enmienda protege cinco libertades: religión, expresión, prensa, reunión pacífica y el derecho a presentar peticiones al gobierno.")
        ]),
        UnifiedQuestion(id: "q_08_007", correctAnswer: 2, variants: [
            .init(text: "How many amendments does the Constitution have?",
                  options: ["10", "21", "27", "33"],
                  explanation: "The Constitution has been amended 27 times."),
            .init(text: "¿Cuántas enmiendas tiene la Constitución?",
                  options: ["10", "21", "27", "33"],
                  explanation: "La Constitución ha sido enmendada 27 veces.")
        ]),
        UnifiedQuestion(id: "q_08_008", correctAnswer: 1, variants: [
            .init(text: "What did the Declaration of Independence do?",
                  options: ["Created the U.S. Constitution", "Announced and declared our independence from Great Britain", "Established the Bill of Rights", "Set up the three branches of government"],
                  explanation: "The Declaration of Independence, adopted July 4, 1776, formally announced separation from British rule."),
            .init(text: "¿Qué hizo la Declaración de Independencia?",
                  options: ["Creó la Constitución de EE. UU.", "Anunció y declaró nuestra independencia de Gran Bretaña", "Estableció la Carta de Derechos", "Organizó las tres ramas del gobierno"],
                  explanation: "La Declaración de Independencia, adoptada el 4 de julio de 1776, anunció formalmente la separación del dominio británico.")
        ]),
        UnifiedQuestion(id: "q_08_009", correctAnswer: 1, variants: [
            .init(text: "What are two rights in the Declaration of Independence?",
                  options: ["Free speech and religion", "Life and liberty (or pursuit of happiness)", "Right to vote and bear arms", "Trial by jury and free press"],
                  explanation: "USCIS accepts any two of: life / liberty / pursuit of happiness. The Declaration states these as 'unalienable rights' — the most famous words in American founding history."),
            .init(text: "¿Cuáles son dos derechos mencionados en la Declaración de Independencia?",
                  options: ["Libertad de expresión y de religión", "Vida y libertad (o búsqueda de la felicidad)", "Derecho al voto y a portar armas", "Juicio por jurado y libertad de prensa"],
                  explanation: "La USCIS acepta cualquiera de los dos: vida / libertad / búsqueda de la felicidad. La Declaración los describe como derechos 'inalienables'.")
        ]),
        UnifiedQuestion(id: "q_08_010", correctAnswer: 2, variants: [
            .init(text: "What is freedom of religion?",
                  options: ["The government selects an official religion for all citizens", "You may only practice one of several approved religions", "You can practice any religion, or not practice a religion", "Religious leaders help run the government"],
                  explanation: "Freedom of religion means you can practice any faith — or no faith — without any government interference."),
            .init(text: "¿Qué es la libertad de religión?",
                  options: ["El gobierno elige una religión oficial para todos los ciudadanos", "Solo se puede practicar una de varias religiones aprobadas", "Puedes practicar cualquier religión, o no practicar ninguna", "Los líderes religiosos ayudan a gobernar"],
                  explanation: "La libertad de religión significa que puedes practicar cualquier fe —o ninguna— sin ninguna interferencia del gobierno.")
        ])
    ]

    // MARK: - Practice Set 2: Sistema de gobierno (Q11–Q20)
    static let practice2: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_011", correctAnswer: 1, variants: [
            .init(text: "What is the economic system in the United States?",
                  options: ["Socialist economy", "Capitalist economy / market economy", "Communist economy", "Mixed feudal economy"],
                  explanation: "The United States has a capitalist, free market economy."),
            .init(text: "¿Cuál es el sistema económico de los Estados Unidos?",
                  options: ["Economía socialista", "Economía capitalista / economía de mercado", "Economía comunista", "Economía feudal mixta"],
                  explanation: "Los Estados Unidos tienen una economía capitalista y de libre mercado.")
        ]),
        UnifiedQuestion(id: "q_08_012", correctAnswer: 2, variants: [
            .init(text: "What is the 'rule of law'?",
                  options: ["Kings and rulers make all the laws", "Only criminals must follow the law", "Everyone must follow the law, including government leaders", "Laws apply only to citizens, not visitors"],
                  explanation: "Under the rule of law, everyone — including the President and Congress — must obey the same laws."),
            .init(text: "¿Qué es el «estado de derecho»?",
                  options: ["Los reyes y gobernantes hacen todas las leyes", "Solo los delincuentes deben obedecer la ley", "Todos deben obedecer la ley, incluidos los líderes del gobierno", "Las leyes solo se aplican a los ciudadanos, no a los visitantes"],
                  explanation: "Bajo el estado de derecho, todos —incluidos el Presidente y el Congreso— deben obedecer las mismas leyes.")
        ]),
        UnifiedQuestion(id: "q_08_013", correctAnswer: 1, variants: [
            .init(text: "Name one branch or part of the government.",
                  options: ["The Army", "Congress (legislative branch)", "The FBI", "The Department of the Treasury"],
                  explanation: "The three branches are: Legislative (Congress), Executive (President), and Judicial (courts)."),
            .init(text: "Nombre una rama o parte del gobierno.",
                  options: ["El Ejército", "El Congreso (rama legislativa)", "El FBI", "El Departamento del Tesoro"],
                  explanation: "Las tres ramas son: la Legislativa (Congreso), la Ejecutiva (Presidente) y la Judicial (tribunales).")
        ]),
        UnifiedQuestion(id: "q_08_014", correctAnswer: 1, variants: [
            .init(text: "What stops one branch of government from becoming too powerful?",
                  options: ["Popular vote", "Checks and balances / separation of powers", "The military", "State governments"],
                  explanation: "Checks and balances allow each branch to limit the others."),
            .init(text: "¿Qué impide que una rama del gobierno se vuelva demasiado poderosa?",
                  options: ["El voto popular", "Los frenos y contrapesos / separación de poderes", "Las fuerzas armadas", "Los gobiernos estatales"],
                  explanation: "Los frenos y contrapesos permiten que cada rama limite a las demás.")
        ]),
        UnifiedQuestion(id: "q_08_015", correctAnswer: 2, variants: [
            .init(text: "Who is in charge of the executive branch?",
                  options: ["The Speaker of the House", "The Chief Justice of the Supreme Court", "The President", "The Secretary of State"],
                  explanation: "The President leads the executive branch."),
            .init(text: "¿Quién está a cargo de la rama ejecutiva?",
                  options: ["El Presidente de la Cámara", "El Presidente de la Corte Suprema", "El Presidente", "El Secretario de Estado"],
                  explanation: "El Presidente dirige la rama ejecutiva.")
        ]),
        UnifiedQuestion(id: "q_08_016", correctAnswer: 2, variants: [
            .init(text: "Who makes federal laws?",
                  options: ["The President", "The Supreme Court", "Congress (Senate and House of Representatives)", "State governors"],
                  explanation: "Congress — the Senate and House of Representatives — is the federal lawmaking body."),
            .init(text: "¿Quién crea las leyes federales?",
                  options: ["El Presidente", "La Corte Suprema", "El Congreso (Senado y Cámara de Representantes)", "Los gobernadores estatales"],
                  explanation: "El Congreso —el Senado y la Cámara de Representantes— es el órgano legislativo federal.")
        ]),
        UnifiedQuestion(id: "q_08_017", correctAnswer: 1, variants: [
            .init(text: "What are the two parts of the U.S. Congress?",
                  options: ["The President and Vice President", "The Senate and House of Representatives", "The Supreme Court and Congress", "The Democratic and Republican parties"],
                  explanation: "Congress is bicameral: the Senate (100 members) and the House of Representatives (435 members)."),
            .init(text: "¿Cuáles son las dos partes del Congreso de EE. UU.?",
                  options: ["El Presidente y el Vicepresidente", "El Senado y la Cámara de Representantes", "La Corte Suprema y el Congreso", "Los partidos Demócrata y Republicano"],
                  explanation: "El Congreso es bicameral: el Senado (100 miembros) y la Cámara de Representantes (435 miembros).")
        ]),
        UnifiedQuestion(id: "q_08_018", correctAnswer: 1, variants: [
            .init(text: "How many U.S. Senators are there?",
                  options: ["50", "100", "435", "535"],
                  explanation: "There are 100 U.S. Senators — two from each of the 50 states."),
            .init(text: "¿Cuántos senadores hay en EE. UU.?",
                  options: ["50", "100", "435", "535"],
                  explanation: "Hay 100 senadores de EE. UU. — dos por cada uno de los 50 estados.")
        ]),
        UnifiedQuestion(id: "q_08_019", correctAnswer: 2, variants: [
            .init(text: "We elect a U.S. Senator for how many years?",
                  options: ["2 years", "4 years", "6 years", "8 years"],
                  explanation: "U.S. Senators serve 6-year terms."),
            .init(text: "¿Por cuántos años elegimos a un senador de EE. UU.?",
                  options: ["2 años", "4 años", "6 años", "8 años"],
                  explanation: "Los senadores de EE. UU. cumplen mandatos de 6 años.")
        ]),
        UnifiedQuestion(id: "q_08_020", correctAnswer: 0, variants: [
            .init(text: "Who is one of your state's U.S. Senators now?",
                  options: ["Answers will vary — research your state", "Donald Trump", "Joe Biden", "Kamala Harris"],
                  explanation: "The correct answer depends on which state you live in. Look up your two current senators before your interview."),
            .init(text: "¿Quién es actualmente uno de los senadores de EE. UU. de su estado?",
                  options: ["Las respuestas variarán — investigue su estado", "Donald Trump", "Joe Biden", "Kamala Harris"],
                  explanation: "La respuesta correcta depende del estado donde vive. Busque a sus dos senadores actuales antes de su entrevista.")
        ])
    ]

    // MARK: - Practice Set 3: El Congreso y la representación (Q21–Q30)
    static let practice3: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_021", correctAnswer: 2, variants: [
            .init(text: "The House of Representatives has how many voting members?",
                  options: ["100", "270", "435", "538"],
                  explanation: "The House has 435 voting members."),
            .init(text: "¿Cuántos miembros con derecho a voto tiene la Cámara de Representantes?",
                  options: ["100", "270", "435", "538"],
                  explanation: "La Cámara tiene 435 miembros con derecho a voto.")
        ]),
        UnifiedQuestion(id: "q_08_022", correctAnswer: 0, variants: [
            .init(text: "We elect a U.S. Representative for how many years?",
                  options: ["2 years", "4 years", "6 years", "8 years"],
                  explanation: "U.S. Representatives serve 2-year terms."),
            .init(text: "¿Por cuántos años elegimos a un representante de EE. UU.?",
                  options: ["2 años", "4 años", "6 años", "8 años"],
                  explanation: "Los representantes de EE. UU. cumplen mandatos de 2 años.")
        ]),
        UnifiedQuestion(id: "q_08_023", correctAnswer: 0, variants: [
            .init(text: "Name your U.S. Representative.",
                  options: ["Answers will vary — research your district", "Nancy Pelosi", "Kevin McCarthy", "Hakeem Jeffries"],
                  explanation: "Look up your representative at house.gov before your interview."),
            .init(text: "Nombre a su representante de EE. UU.",
                  options: ["Las respuestas variarán — investigue su distrito", "Nancy Pelosi", "Kevin McCarthy", "Hakeem Jeffries"],
                  explanation: "Consulte a su representante en house.gov antes de su entrevista.")
        ]),
        UnifiedQuestion(id: "q_08_024", correctAnswer: 1, variants: [
            .init(text: "Who does a U.S. Senator represent?",
                  options: ["Only the voters who elected them", "All the people of their state", "Their political party's supporters", "The federal government"],
                  explanation: "Each U.S. Senator represents ALL residents of their state."),
            .init(text: "¿A quién representa un senador de EE. UU.?",
                  options: ["Solo a los votantes que lo eligieron", "A toda la población de su estado", "A los simpatizantes de su partido político", "Al gobierno federal"],
                  explanation: "Cada senador de EE. UU. representa a TODOS los residentes de su estado.")
        ]),
        UnifiedQuestion(id: "q_08_025", correctAnswer: 2, variants: [
            .init(text: "Why do some states have more Representatives than other states?",
                  options: ["Because of the state's geographic size", "Because of the state's wealth and tax revenue", "Because of the state's population", "Because of how long the state has been in the Union"],
                  explanation: "House seats are apportioned by population."),
            .init(text: "¿Por qué algunos estados tienen más representantes que otros?",
                  options: ["Por el tamaño geográfico del estado", "Por la riqueza y los ingresos fiscales del estado", "Por la población del estado", "Por el tiempo que lleva el estado en la Unión"],
                  explanation: "Los escaños de la Cámara se asignan según la población.")
        ]),
        UnifiedQuestion(id: "q_08_026", correctAnswer: 2, variants: [
            .init(text: "We elect a President for how many years?",
                  options: ["2 years", "3 years", "4 years", "6 years"],
                  explanation: "The President serves a 4-year term, limited to two terms by the 22nd Amendment."),
            .init(text: "¿Por cuántos años elegimos a un Presidente?",
                  options: ["2 años", "3 años", "4 años", "6 años"],
                  explanation: "El Presidente cumple un mandato de 4 años, limitado a dos mandatos por la 22.ª Enmienda.")
        ]),
        UnifiedQuestion(id: "q_08_027", correctAnswer: 2, variants: [
            .init(text: "In what month do we vote for President?",
                  options: ["September", "October", "November", "December"],
                  explanation: "Presidential elections are held in November every four years."),
            .init(text: "¿En qué mes votamos para elegir al Presidente?",
                  options: ["Septiembre", "Octubre", "Noviembre", "Diciembre"],
                  explanation: "Las elecciones presidenciales se celebran en noviembre cada cuatro años.")
        ]),
        UnifiedQuestion(id: "q_08_028", correctAnswer: 2, variants: [
            .init(text: "What is the name of the President of the United States now?",
                  options: ["Joe Biden", "Barack Obama", "Donald Trump", "Kamala Harris"],
                  explanation: "Donald Trump is the 47th President, serving his second term since January 2025."),
            .init(text: "¿Cómo se llama el actual Presidente de los Estados Unidos?",
                  options: ["Joe Biden", "Barack Obama", "Donald Trump", "Kamala Harris"],
                  explanation: "Donald Trump es el 47.º Presidente, ejerciendo su segundo mandato desde enero de 2025.")
        ]),
        UnifiedQuestion(id: "q_08_029", correctAnswer: 2, variants: [
            .init(text: "What is the name of the Vice President of the United States now?",
                  options: ["Kamala Harris", "Mike Pence", "JD Vance", "Tim Walz"],
                  explanation: "JD Vance is the 50th Vice President, serving since January 2025."),
            .init(text: "¿Cómo se llama el actual Vicepresidente de los Estados Unidos?",
                  options: ["Kamala Harris", "Mike Pence", "JD Vance", "Tim Walz"],
                  explanation: "JD Vance es el 50.º Vicepresidente, en funciones desde enero de 2025.")
        ]),
        UnifiedQuestion(id: "q_08_030", correctAnswer: 3, variants: [
            .init(text: "If the President can no longer serve, who becomes President?",
                  options: ["The Speaker of the House", "The Chief Justice", "The Secretary of State", "The Vice President"],
                  explanation: "The Vice President becomes President if the President is unable to serve."),
            .init(text: "Si el Presidente ya no puede ejercer el cargo, ¿quién se convierte en Presidente?",
                  options: ["El Presidente de la Cámara de Representantes", "El Presidente de la Corte Suprema", "El Secretario de Estado", "El Vicepresidente"],
                  explanation: "El Vicepresidente asume la Presidencia si el Presidente no puede ejercer el cargo.")
        ])
    ]

    // MARK: - Practice Set 4: El poder ejecutivo y judicial (Q31–Q40)
    static let practice4: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_031", correctAnswer: 1, variants: [
            .init(text: "If both the President and the Vice President can no longer serve, who becomes President?",
                  options: ["The Secretary of State", "The Speaker of the House", "The President pro tempore of the Senate", "The Chief Justice of the Supreme Court"],
                  explanation: "The Speaker of the House is second in line of succession."),
            .init(text: "Si tanto el Presidente como el Vicepresidente no pueden ejercer el cargo, ¿quién se convierte en Presidente?",
                  options: ["El Secretario de Estado", "El Presidente de la Cámara de Representantes", "El Presidente pro tempore del Senado", "El Presidente de la Corte Suprema"],
                  explanation: "El Presidente de la Cámara de Representantes ocupa el segundo lugar en la línea de sucesión.")
        ]),
        UnifiedQuestion(id: "q_08_032", correctAnswer: 2, variants: [
            .init(text: "Who is the Commander in Chief of the military?",
                  options: ["The Secretary of Defense", "A four-star general", "The President", "The Chairman of the Joint Chiefs of Staff"],
                  explanation: "The President serves as Commander in Chief of all U.S. armed forces."),
            .init(text: "¿Quién es el Comandante en Jefe de las fuerzas armadas?",
                  options: ["El Secretario de Defensa", "Un general de cuatro estrellas", "El Presidente", "El Presidente del Estado Mayor Conjunto"],
                  explanation: "El Presidente actúa como Comandante en Jefe de todas las fuerzas armadas de EE. UU.")
        ]),
        UnifiedQuestion(id: "q_08_033", correctAnswer: 2, variants: [
            .init(text: "Who signs bills to become laws?",
                  options: ["The Speaker of the House", "The Vice President", "The President", "The Chief Justice"],
                  explanation: "After Congress passes a bill, the President signs it into law or vetoes it."),
            .init(text: "¿Quién firma los proyectos de ley para que se conviertan en leyes?",
                  options: ["El Presidente de la Cámara", "El Vicepresidente", "El Presidente", "El Presidente de la Corte Suprema"],
                  explanation: "Después de que el Congreso aprueba un proyecto de ley, el Presidente lo firma para convertirlo en ley o lo veta.")
        ]),
        UnifiedQuestion(id: "q_08_034", correctAnswer: 3, variants: [
            .init(text: "Who vetoes bills?",
                  options: ["The Senate Majority Leader", "The Supreme Court", "The Speaker of the House", "The President"],
                  explanation: "The President can veto legislation passed by Congress."),
            .init(text: "¿Quién veta los proyectos de ley?",
                  options: ["El Líder de la Mayoría del Senado", "La Corte Suprema", "El Presidente de la Cámara", "El Presidente"],
                  explanation: "El Presidente puede vetar la legislación aprobada por el Congreso.")
        ]),
        UnifiedQuestion(id: "q_08_035", correctAnswer: 1, variants: [
            .init(text: "What does the President's Cabinet do?",
                  options: ["Makes federal laws", "Advises the President", "Elects the Vice President", "Oversees the Supreme Court"],
                  explanation: "The Cabinet is made up of heads of 15 executive departments who advise the President."),
            .init(text: "¿Qué hace el Gabinete del Presidente?",
                  options: ["Crea leyes federales", "Asesora al Presidente", "Elige al Vicepresidente", "Supervisa la Corte Suprema"],
                  explanation: "El Gabinete está compuesto por los jefes de los 15 departamentos ejecutivos, quienes asesoran al Presidente.")
        ]),
        UnifiedQuestion(id: "q_08_036", correctAnswer: 2, variants: [
            .init(text: "What are two Cabinet-level positions?",
                  options: ["Senator and Representative", "Governor and Mayor", "Secretary of State and Secretary of Defense", "Chief Justice and Speaker of the House"],
                  explanation: "Cabinet positions include the Vice President and department heads: Secretary of State, Defense, Treasury, and the Attorney General. (Chief Justice and Speaker lead judicial/legislative branches — not Cabinet.)"),
            .init(text: "¿Cuáles son dos cargos a nivel de Gabinete?",
                  options: ["Senador y Representante", "Gobernador y Alcalde", "Secretario de Estado y Secretario de Defensa", "Presidente de la Corte Suprema y Presidente de la Cámara"],
                  explanation: "Los cargos del Gabinete incluyen al Vicepresidente y jefes de departamento: Secretario de Estado, de Defensa, del Tesoro y el Fiscal General. (El Presidente de la Corte Suprema y el Presidente de la Cámara dirigen ramas distintas, no el Gabinete.)")
        ]),
        UnifiedQuestion(id: "q_08_037", correctAnswer: 3, variants: [
            .init(text: "What does the judicial branch do?",
                  options: ["Makes federal laws", "Enforces laws and manages the military", "Collects taxes and prints money", "Reviews laws and decides if they are constitutional"],
                  explanation: "The judicial branch interprets laws and determines whether they are consistent with the Constitution."),
            .init(text: "¿Qué hace la rama judicial?",
                  options: ["Crea leyes federales", "Hace cumplir las leyes y dirige las fuerzas armadas", "Recauda impuestos e imprime dinero", "Revisa las leyes y decide si son constitucionales"],
                  explanation: "La rama judicial interpreta las leyes y determina si son compatibles con la Constitución.")
        ]),
        UnifiedQuestion(id: "q_08_038", correctAnswer: 3, variants: [
            .init(text: "What is the highest court in the United States?",
                  options: ["The Federal Appeals Court", "The State Supreme Court", "The Federal District Court", "The Supreme Court"],
                  explanation: "The U.S. Supreme Court is the highest court in the land. Its decisions are final."),
            .init(text: "¿Cuál es el tribunal más alto de los Estados Unidos?",
                  options: ["El Tribunal Federal de Apelaciones", "La Corte Suprema Estatal", "El Tribunal Federal de Distrito", "La Corte Suprema"],
                  explanation: "La Corte Suprema de EE. UU. es el tribunal más alto del país. Sus decisiones son definitivas.")
        ]),
        UnifiedQuestion(id: "q_08_039", correctAnswer: 1, variants: [
            .init(text: "How many justices are on the Supreme Court?",
                  options: ["7", "9", "11", "13"],
                  explanation: "The Supreme Court has 9 justices: one Chief Justice and eight Associate Justices."),
            .init(text: "¿Cuántos magistrados integran la Corte Suprema?",
                  options: ["7", "9", "11", "13"],
                  explanation: "La Corte Suprema tiene 9 magistrados: un Presidente del Tribunal y ocho magistrados asociados.")
        ]),
        UnifiedQuestion(id: "q_08_040", correctAnswer: 2, variants: [
            .init(text: "Who is the Chief Justice of the United States now?",
                  options: ["Sonia Sotomayor", "Clarence Thomas", "John Roberts", "Elena Kagan"],
                  explanation: "John G. Roberts Jr. has served as Chief Justice since 2005."),
            .init(text: "¿Quién es actualmente el Presidente de la Corte Suprema de los Estados Unidos?",
                  options: ["Sonia Sotomayor", "Clarence Thomas", "John Roberts", "Elena Kagan"],
                  explanation: "John G. Roberts Jr. es Presidente de la Corte Suprema desde 2005.")
        ])
    ]

    // MARK: - Practice Set 5: Poderes del gobierno y derechos (Q41–Q50)
    static let practice5: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_041", correctAnswer: 2, variants: [
            .init(text: "Under our Constitution, some powers belong to the federal government. What is one power of the federal government?",
                  options: ["Issue driver's licenses", "Set local zoning laws", "To print money", "Provide fire protection"],
                  explanation: "Exclusive federal powers include printing money, declaring war, and making treaties."),
            .init(text: "Bajo nuestra Constitución, algunos poderes pertenecen al gobierno federal. ¿Cuál es un poder del gobierno federal?",
                  options: ["Expedir licencias de conducir", "Establecer leyes locales de zonificación", "Imprimir dinero", "Brindar protección contra incendios"],
                  explanation: "Los poderes exclusivos del gobierno federal incluyen imprimir dinero, declarar la guerra y celebrar tratados.")
        ]),
        UnifiedQuestion(id: "q_08_042", correctAnswer: 3, variants: [
            .init(text: "Under our Constitution, some powers belong to the states. What is one power of the states?",
                  options: ["Declare war", "Print money", "Make treaties with foreign nations", "Provide schooling and education"],
                  explanation: "State powers include providing education, police protection, and driver's licenses."),
            .init(text: "Bajo nuestra Constitución, algunos poderes pertenecen a los estados. ¿Cuál es un poder de los estados?",
                  options: ["Declarar la guerra", "Imprimir dinero", "Celebrar tratados con naciones extranjeras", "Ofrecer educación escolar"],
                  explanation: "Los poderes de los estados incluyen brindar educación, protección policial y licencias de conducir.")
        ]),
        UnifiedQuestion(id: "q_08_043", correctAnswer: 0, variants: [
            .init(text: "Who is the Governor of your state now?",
                  options: ["Answers will vary — research your state", "Donald Trump", "Joe Biden", "Kamala Harris"],
                  explanation: "Look up your current Governor before your interview."),
            .init(text: "¿Quién es actualmente el Gobernador de su estado?",
                  options: ["Las respuestas variarán — investigue su estado", "Donald Trump", "Joe Biden", "Kamala Harris"],
                  explanation: "Consulte quién es su Gobernador actual antes de su entrevista.")
        ]),
        UnifiedQuestion(id: "q_08_044", correctAnswer: 0, variants: [
            .init(text: "What is the capital of your state?",
                  options: ["Answers will vary — research your state", "New York City", "Los Angeles", "Chicago"],
                  explanation: "Each state has its own capital city."),
            .init(text: "¿Cuál es la capital de su estado?",
                  options: ["Las respuestas variarán — investigue su estado", "Nueva York", "Los Ángeles", "Chicago"],
                  explanation: "Cada estado tiene su propia ciudad capital.")
        ]),
        UnifiedQuestion(id: "q_08_045", correctAnswer: 2, variants: [
            .init(text: "What are the two major political parties in the United States?",
                  options: ["Liberal and Conservative", "Federalist and Democratic-Republican", "Democratic and Republican", "Independent and Green"],
                  explanation: "The Democratic Party and Republican Party are the two dominant parties in U.S. politics."),
            .init(text: "¿Cuáles son los dos principales partidos políticos de los Estados Unidos?",
                  options: ["Liberal y Conservador", "Federalista y Demócrata-Republicano", "Demócrata y Republicano", "Independiente y Verde"],
                  explanation: "El Partido Demócrata y el Partido Republicano son los dos partidos dominantes en la política de EE. UU.")
        ]),
        UnifiedQuestion(id: "q_08_046", correctAnswer: 1, variants: [
            .init(text: "What is the political party of the President now?",
                  options: ["Democratic Party", "Republican Party", "Independent", "Libertarian Party"],
                  explanation: "Donald Trump, the current President, is a member of the Republican Party."),
            .init(text: "¿A qué partido político pertenece el actual Presidente?",
                  options: ["Partido Demócrata", "Partido Republicano", "Independiente", "Partido Libertario"],
                  explanation: "Donald Trump, el actual Presidente, es miembro del Partido Republicano.")
        ]),
        UnifiedQuestion(id: "q_08_047", correctAnswer: 2, variants: [
            .init(text: "What is the name of the Speaker of the House of Representatives now?",
                  options: ["Kevin McCarthy", "Nancy Pelosi", "Mike Johnson", "Hakeem Jeffries"],
                  explanation: "Mike Johnson of Louisiana has served as Speaker of the House since October 2023."),
            .init(text: "¿Cómo se llama el actual Presidente de la Cámara de Representantes?",
                  options: ["Kevin McCarthy", "Nancy Pelosi", "Mike Johnson", "Hakeem Jeffries"],
                  explanation: "Mike Johnson, de Luisiana, es Presidente de la Cámara de Representantes desde octubre de 2023.")
        ]),
        UnifiedQuestion(id: "q_08_048", correctAnswer: 1, variants: [
            .init(text: "There are four amendments to the Constitution about who can vote. Describe one of them.",
                  options: ["All people age 16 and older can vote", "Citizens eighteen (18) and older can vote", "Only property owners can vote", "Only taxpayers can vote"],
                  explanation: "Four voting amendments: 15th (race), 19th (women), 24th (no poll tax), and 26th (age 18+)."),
            .init(text: "Hay cuatro enmiendas a la Constitución sobre quién puede votar. Describa una de ellas.",
                  options: ["Todas las personas de 16 años o más pueden votar", "Los ciudadanos de dieciocho (18) años o más pueden votar", "Solo los propietarios pueden votar", "Solo los contribuyentes pueden votar"],
                  explanation: "Las cuatro enmiendas sobre el voto son: la 15.ª (raza), la 19.ª (mujeres), la 24.ª (sin impuesto para votar) y la 26.ª (a partir de los 18 años).")
        ]),
        UnifiedQuestion(id: "q_08_049", correctAnswer: 2, variants: [
            .init(text: "What is one responsibility that is only for United States citizens?",
                  options: ["Pay taxes", "Follow federal and state laws", "Serve on a jury", "Obey local ordinances"],
                  explanation: "Serving on a jury and voting in federal elections are reserved exclusively for U.S. citizens."),
            .init(text: "¿Cuál es una responsabilidad exclusiva de los ciudadanos estadounidenses?",
                  options: ["Pagar impuestos", "Obedecer las leyes federales y estatales", "Servir en un jurado", "Obedecer las ordenanzas locales"],
                  explanation: "Servir en un jurado y votar en las elecciones federales están reservados exclusivamente para los ciudadanos de EE. UU.")
        ]),
        UnifiedQuestion(id: "q_08_050", correctAnswer: 2, variants: [
            .init(text: "Name one right only for United States citizens.",
                  options: ["Freedom of speech", "Right to a fair trial", "Vote in a federal election", "Freedom of religion"],
                  explanation: "Only U.S. citizens may vote in federal elections and run for federal office."),
            .init(text: "Nombre un derecho exclusivo de los ciudadanos de los Estados Unidos.",
                  options: ["Libertad de expresión", "Derecho a un juicio justo", "Votar en una elección federal", "Libertad de religión"],
                  explanation: "Solo los ciudadanos de EE. UU. pueden votar en elecciones federales y postularse a cargos federales.")
        ])
    ]

    // MARK: - Practice Set 6: Derechos, responsabilidades e historia colonial (Q51–Q60)
    static let practice6: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_051", correctAnswer: 1, variants: [
            .init(text: "What are two rights of everyone living in the United States?",
                  options: ["Right to vote and run for federal office", "Freedom of speech and freedom of religion", "Free government housing and employment", "The right to bear arms and vote in local elections"],
                  explanation: "Everyone in the U.S. — citizens and non-citizens — has rights including freedom of expression and religion."),
            .init(text: "¿Cuáles son dos derechos de toda persona que vive en los Estados Unidos?",
                  options: ["Derecho a votar y postularse a cargos federales", "Libertad de expresión y libertad de religión", "Vivienda y empleo gratuitos del gobierno", "Derecho a portar armas y votar en elecciones locales"],
                  explanation: "Todas las personas en EE. UU. —ciudadanos y no ciudadanos— tienen derechos, entre ellos la libertad de expresión y de religión.")
        ]),
        UnifiedQuestion(id: "q_08_052", correctAnswer: 2, variants: [
            .init(text: "What do we show loyalty to when we say the Pledge of Allegiance?",
                  options: ["The President of the United States", "The U.S. Constitution and the courts", "The United States and the flag", "The military and veterans"],
                  explanation: "The Pledge of Allegiance is a declaration of loyalty to the United States and its flag."),
            .init(text: "¿A qué demostramos nuestra lealtad cuando decimos el Juramento de Lealtad?",
                  options: ["Al Presidente de los Estados Unidos", "A la Constitución de EE. UU. y los tribunales", "A los Estados Unidos y a la bandera", "A las fuerzas armadas y a los veteranos"],
                  explanation: "El Juramento de Lealtad es una declaración de fidelidad a los Estados Unidos y a su bandera.")
        ]),
        UnifiedQuestion(id: "q_08_053", correctAnswer: 1, variants: [
            .init(text: "What is one promise you make when you become a United States citizen?",
                  options: ["Never leave the United States", "Give up loyalty to other countries", "Always vote in every election", "Pay an extra citizenship tax"],
                  explanation: "The Oath of Allegiance includes giving up loyalty to foreign nations and defending the Constitution."),
            .init(text: "¿Cuál es una promesa que hace al convertirse en ciudadano de los Estados Unidos?",
                  options: ["Nunca abandonar los Estados Unidos", "Renunciar a la lealtad hacia otros países", "Votar siempre en todas las elecciones", "Pagar un impuesto adicional de ciudadanía"],
                  explanation: "El Juramento de Lealtad incluye renunciar a la fidelidad hacia otras naciones y defender la Constitución.")
        ]),
        UnifiedQuestion(id: "q_08_054", correctAnswer: 2, variants: [
            .init(text: "How old do citizens have to be to vote for President?",
                  options: ["16 and older", "21 and older", "18 and older", "25 and older"],
                  explanation: "The 26th Amendment (1971) set the minimum voting age at 18."),
            .init(text: "¿Qué edad deben tener los ciudadanos para votar por el Presidente?",
                  options: ["16 años o más", "21 años o más", "18 años o más", "25 años o más"],
                  explanation: "La 26.ª Enmienda (1971) estableció la edad mínima para votar en 18 años.")
        ]),
        UnifiedQuestion(id: "q_08_055", correctAnswer: 1, variants: [
            .init(text: "What are two ways that Americans can participate in their democracy?",
                  options: ["Pay taxes and read the news", "Vote and join a civic group", "Work for the government and serve in the military", "Study history and learn English"],
                  explanation: "Americans can participate by voting, joining parties, running for office, and contacting elected officials."),
            .init(text: "¿Cuáles son dos formas en que los estadounidenses pueden participar en su democracia?",
                  options: ["Pagar impuestos y leer las noticias", "Votar y unirse a un grupo cívico", "Trabajar para el gobierno y servir en las fuerzas armadas", "Estudiar historia y aprender inglés"],
                  explanation: "Los estadounidenses pueden participar votando, uniéndose a partidos, postulándose a cargos y contactando a sus representantes electos.")
        ]),
        UnifiedQuestion(id: "q_08_056", correctAnswer: 2, variants: [
            .init(text: "When is the last day you can send in federal income tax forms?",
                  options: ["January 31", "March 15", "April 15", "June 30"],
                  explanation: "Federal income tax returns are due on April 15 each year."),
            .init(text: "¿Cuál es el último día para presentar las declaraciones de impuestos federales sobre la renta?",
                  options: ["31 de enero", "15 de marzo", "15 de abril", "30 de junio"],
                  explanation: "Las declaraciones de impuestos federales sobre la renta vencen el 15 de abril de cada año.")
        ]),
        UnifiedQuestion(id: "q_08_057", correctAnswer: 2, variants: [
            .init(text: "When must all men register for the Selective Service?",
                  options: ["At age 16", "At age 21", "At age 18 (between 18 and 26)", "Only during wartime when required"],
                  explanation: "All male U.S. residents must register with the Selective Service within 30 days of turning 18."),
            .init(text: "¿Cuándo deben inscribirse todos los hombres en el Servicio Selectivo?",
                  options: ["A los 16 años", "A los 21 años", "A los 18 años (entre los 18 y los 26)", "Solo en tiempos de guerra cuando se requiera"],
                  explanation: "Todos los residentes varones de EE. UU. deben registrarse en el Servicio Selectivo en los 30 días posteriores a cumplir 18 años.")
        ]),
        UnifiedQuestion(id: "q_08_058", correctAnswer: 2, variants: [
            .init(text: "What is one reason colonists came to America?",
                  options: ["To find gold and return to Europe", "To trade exclusively with Native Americans", "For religious freedom and political liberty", "To establish a European monarchy in the New World"],
                  explanation: "Colonists came for religious freedom, political liberty, and economic opportunity."),
            .init(text: "¿Cuál es una razón por la que los colonos vinieron a América?",
                  options: ["Para encontrar oro y regresar a Europa", "Para comerciar exclusivamente con los nativos americanos", "Por libertad religiosa y libertad política", "Para establecer una monarquía europea en el Nuevo Mundo"],
                  explanation: "Los colonos llegaron en busca de libertad religiosa, libertad política y oportunidades económicas.")
        ]),
        UnifiedQuestion(id: "q_08_059", correctAnswer: 2, variants: [
            .init(text: "Who lived in America before the Europeans arrived?",
                  options: ["Spanish explorers", "Settlers from Africa", "American Indians (Native Americans)", "Settlers from Asia"],
                  explanation: "American Indians (Native Americans) lived in North America for thousands of years before European colonization."),
            .init(text: "¿Quién vivía en América antes de la llegada de los europeos?",
                  options: ["Exploradores españoles", "Colonos procedentes de África", "Indios americanos (nativos americanos)", "Colonos procedentes de Asia"],
                  explanation: "Los indios americanos (nativos americanos) vivieron en América del Norte durante miles de años antes de la colonización europea.")
        ]),
        UnifiedQuestion(id: "q_08_060", correctAnswer: 3, variants: [
            .init(text: "What group of people was taken to America and sold as slaves?",
                  options: ["People from Asia", "People from Europe", "People from South America", "People from Africa"],
                  explanation: "Millions of Africans were forcibly brought to America from the 16th through 19th centuries and sold into slavery."),
            .init(text: "¿Qué grupo de personas fue traído a América y vendido como esclavos?",
                  options: ["Personas de Asia", "Personas de Europa", "Personas de América del Sur", "Personas de África"],
                  explanation: "Millones de africanos fueron traídos a la fuerza a América entre los siglos XVI y XIX y vendidos como esclavos.")
        ])
    ]

    // MARK: - Practice Set 7: La Revolución y los Padres Fundadores (Q61–Q70)
    static let practice7: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_061", correctAnswer: 2, variants: [
            .init(text: "Why did the colonists fight the British?",
                  options: ["To gain more land in the Western territories", "They wanted to become part of Canada", "Because of high taxes and no self-government (taxation without representation)", "To protect themselves from Native American raids"],
                  explanation: "Key causes of the Revolution: taxation without representation and no vote in British Parliament."),
            .init(text: "¿Por qué los colonos lucharon contra los británicos?",
                  options: ["Para obtener más tierras en los territorios del Oeste", "Querían formar parte de Canadá", "Por los altos impuestos y la falta de autogobierno (impuestos sin representación)", "Para protegerse de los ataques de los nativos americanos"],
                  explanation: "Las causas principales de la Revolución fueron los impuestos sin representación y la falta de voto en el Parlamento británico.")
        ]),
        UnifiedQuestion(id: "q_08_062", correctAnswer: 2, variants: [
            .init(text: "Who wrote the Declaration of Independence?",
                  options: ["George Washington", "Benjamin Franklin", "Thomas Jefferson", "John Adams"],
                  explanation: "Thomas Jefferson was the principal author of the Declaration of Independence, adopted July 4, 1776."),
            .init(text: "¿Quién redactó la Declaración de Independencia?",
                  options: ["George Washington", "Benjamin Franklin", "Thomas Jefferson", "John Adams"],
                  explanation: "Thomas Jefferson fue el autor principal de la Declaración de Independencia, adoptada el 4 de julio de 1776.")
        ]),
        UnifiedQuestion(id: "q_08_063", correctAnswer: 0, variants: [
            .init(text: "When was the Declaration of Independence adopted?",
                  options: ["July 4, 1776", "September 17, 1787", "April 19, 1775", "March 4, 1789"],
                  explanation: "July 4, 1776 is when the Continental Congress formally adopted the Declaration of Independence."),
            .init(text: "¿Cuándo fue adoptada la Declaración de Independencia?",
                  options: ["4 de julio de 1776", "17 de septiembre de 1787", "19 de abril de 1775", "4 de marzo de 1789"],
                  explanation: "El 4 de julio de 1776 fue cuando el Congreso Continental adoptó formalmente la Declaración de Independencia.")
        ]),
        UnifiedQuestion(id: "q_08_064", correctAnswer: 2, variants: [
            .init(text: "There were 13 original states. Name three.",
                  options: ["Florida, Texas, and California", "Maine, Michigan, and Ohio", "Virginia, Pennsylvania, and New York", "Arizona, Nevada, and Utah"],
                  explanation: "The 13 original states were all former British colonies that declared independence in 1776."),
            .init(text: "Había 13 estados originales. Nombre tres.",
                  options: ["Florida, Texas y California", "Maine, Míchigan y Ohio", "Virginia, Pensilvania y Nueva York", "Arizona, Nevada y Utah"],
                  explanation: "Los 13 estados originales eran antiguas colonias británicas que declararon su independencia en 1776.")
        ]),
        UnifiedQuestion(id: "q_08_065", correctAnswer: 2, variants: [
            .init(text: "What happened at the Constitutional Convention?",
                  options: ["The Declaration of Independence was signed", "The Civil War ended", "The Constitution was written", "Slavery was abolished throughout the country"],
                  explanation: "The Constitutional Convention met in Philadelphia in 1787 where the Constitution was drafted."),
            .init(text: "¿Qué ocurrió en la Convención Constitucional?",
                  options: ["Se firmó la Declaración de Independencia", "Terminó la Guerra Civil", "Se redactó la Constitución", "Se abolió la esclavitud en todo el país"],
                  explanation: "La Convención Constitucional se reunió en Filadelfia en 1787, donde se redactó la Constitución.")
        ]),
        UnifiedQuestion(id: "q_08_066", correctAnswer: 2, variants: [
            .init(text: "When was the Constitution written?",
                  options: ["1776", "1781", "1787", "1791"],
                  explanation: "The Constitution was written in 1787 and ratified in 1788."),
            .init(text: "¿Cuándo se redactó la Constitución?",
                  options: ["1776", "1781", "1787", "1791"],
                  explanation: "La Constitución se redactó en 1787 y fue ratificada en 1788.")
        ]),
        UnifiedQuestion(id: "q_08_067", correctAnswer: 2, variants: [
            .init(text: "The Federalist Papers supported the passage of the U.S. Constitution. Name one of the writers.",
                  options: ["Thomas Jefferson", "John Adams", "Hamilton, Madison, or Jay (Publius)", "Benjamin Franklin"],
                  explanation: "The Federalist Papers were written by Alexander Hamilton, James Madison, and John Jay under the pen name 'Publius.' USCIS accepts any of their names."),
            .init(text: "Los Documentos Federalistas apoyaron la ratificación de la Constitución de EE. UU. Nombre a uno de sus autores.",
                  options: ["Thomas Jefferson", "John Adams", "Hamilton, Madison o Jay (Publius)", "Benjamin Franklin"],
                  explanation: "Los Documentos Federalistas fueron escritos por Alexander Hamilton, James Madison y John Jay bajo el seudónimo «Publius». La USCIS acepta cualquiera de sus nombres.")
        ]),
        UnifiedQuestion(id: "q_08_068", correctAnswer: 2, variants: [
            .init(text: "What is one thing Benjamin Franklin is famous for?",
                  options: ["Writing the Declaration of Independence", "Being the first President of the United States", "Being the first U.S. Postmaster General", "Leading the Union Army during the Civil War"],
                  explanation: "Benjamin Franklin was a diplomat, inventor, writer, and the first Postmaster General."),
            .init(text: "¿Cuál es una cosa por la que es famoso Benjamin Franklin?",
                  options: ["Por redactar la Declaración de Independencia", "Por ser el primer Presidente de los Estados Unidos", "Por ser el primer Director General de Correos de EE. UU.", "Por liderar el Ejército de la Unión durante la Guerra Civil"],
                  explanation: "Benjamin Franklin fue diplomático, inventor, escritor y el primer Director General de Correos.")
        ]),
        UnifiedQuestion(id: "q_08_069", correctAnswer: 3, variants: [
            .init(text: "Who is the 'Father of Our Country'?",
                  options: ["Benjamin Franklin", "Thomas Jefferson", "John Adams", "George Washington"],
                  explanation: "George Washington is called the 'Father of Our Country' for commanding the Continental Army and serving as the first President."),
            .init(text: "¿Quién es el «Padre de la Patria»?",
                  options: ["Benjamin Franklin", "Thomas Jefferson", "John Adams", "George Washington"],
                  explanation: "George Washington es llamado el «Padre de la Patria» por haber comandado el Ejército Continental y ser el primer Presidente.")
        ]),
        UnifiedQuestion(id: "q_08_070", correctAnswer: 3, variants: [
            .init(text: "Who was the first President?",
                  options: ["John Adams", "Thomas Jefferson", "Benjamin Franklin", "George Washington"],
                  explanation: "George Washington became the first President of the United States in 1789."),
            .init(text: "¿Quién fue el primer Presidente?",
                  options: ["John Adams", "Thomas Jefferson", "Benjamin Franklin", "George Washington"],
                  explanation: "George Washington se convirtió en el primer Presidente de los Estados Unidos en 1789.")
        ])
    ]

    // MARK: - Practice Set 8: Historia del siglo XIX (Q71–Q80)
    static let practice8: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_071", correctAnswer: 3, variants: [
            .init(text: "What territory did the United States buy from France in 1803?",
                  options: ["Texas Territory", "Florida Territory", "Alaska Territory", "The Louisiana Territory"],
                  explanation: "The Louisiana Purchase (1803) nearly doubled the size of the U.S., purchased from France for approximately $15 million."),
            .init(text: "¿Qué territorio compró Estados Unidos a Francia en 1803?",
                  options: ["El Territorio de Texas", "El Territorio de Florida", "El Territorio de Alaska", "El Territorio de Luisiana"],
                  explanation: "La Compra de Luisiana (1803) casi duplicó el tamaño de EE. UU.; fue adquirida a Francia por aproximadamente 15 millones de dólares.")
        ]),
        UnifiedQuestion(id: "q_08_072", correctAnswer: 2, variants: [
            .init(text: "Name one war fought by the United States in the 1800s.",
                  options: ["World War I", "Korean War", "The Civil War", "Vietnam War"],
                  explanation: "U.S. wars in the 1800s included the War of 1812, Mexican-American War, Civil War, and Spanish-American War."),
            .init(text: "Nombre una guerra en la que participaron los Estados Unidos en el siglo XIX.",
                  options: ["La Primera Guerra Mundial", "La Guerra de Corea", "La Guerra Civil", "La Guerra de Vietnam"],
                  explanation: "Las guerras de EE. UU. en el siglo XIX incluyen la Guerra de 1812, la Guerra Mexicano-Estadounidense, la Guerra Civil y la Guerra Hispano-Estadounidense.")
        ]),
        UnifiedQuestion(id: "q_08_073", correctAnswer: 2, variants: [
            .init(text: "Name the U.S. war between the North and the South.",
                  options: ["The Revolutionary War", "The War of 1812", "The Civil War", "The Spanish-American War"],
                  explanation: "The Civil War (1861–1865) was fought between the Northern Union and Southern Confederacy primarily over slavery."),
            .init(text: "Nombre la guerra de EE. UU. entre el Norte y el Sur.",
                  options: ["La Guerra de Independencia", "La Guerra de 1812", "La Guerra Civil", "La Guerra Hispano-Estadounidense"],
                  explanation: "La Guerra Civil (1861–1865) fue librada entre la Unión del Norte y la Confederación del Sur, principalmente por la cuestión de la esclavitud.")
        ]),
        UnifiedQuestion(id: "q_08_074", correctAnswer: 2, variants: [
            .init(text: "Name one problem that led to the Civil War.",
                  options: ["A dispute solely about tariffs", "A foreign invasion of U.S. territory", "Slavery", "A conflict over the Constitution's legality"],
                  explanation: "The Civil War's causes included slavery, economic differences, and debates over states' rights."),
            .init(text: "Nombre un problema que condujo a la Guerra Civil.",
                  options: ["Una disputa exclusivamente sobre aranceles", "Una invasión extranjera del territorio de EE. UU.", "La esclavitud", "Un conflicto sobre la legalidad de la Constitución"],
                  explanation: "Las causas de la Guerra Civil incluyeron la esclavitud, las diferencias económicas y los debates sobre los derechos de los estados.")
        ]),
        UnifiedQuestion(id: "q_08_075", correctAnswer: 2, variants: [
            .init(text: "What was one important thing that Abraham Lincoln did?",
                  options: ["Wrote the U.S. Constitution", "Won the Spanish-American War", "Freed the slaves (Emancipation Proclamation)", "Purchased Alaska from Russia"],
                  explanation: "Lincoln issued the Emancipation Proclamation (1863), freeing enslaved people in Confederate states."),
            .init(text: "¿Cuál fue una cosa importante que hizo Abraham Lincoln?",
                  options: ["Redactó la Constitución de EE. UU.", "Ganó la Guerra Hispano-Estadounidense", "Liberó a los esclavos (Proclamación de Emancipación)", "Compró Alaska a Rusia"],
                  explanation: "Lincoln emitió la Proclamación de Emancipación (1863), liberando a las personas esclavizadas en los estados confederados.")
        ]),
        UnifiedQuestion(id: "q_08_076", correctAnswer: 2, variants: [
            .init(text: "What did the Emancipation Proclamation do?",
                  options: ["Officially ended the Civil War", "Gave women the right to vote", "Freed the slaves in Confederate states", "Created the Republican Party"],
                  explanation: "The Emancipation Proclamation declared all enslaved people in Confederate states to be free."),
            .init(text: "¿Qué hizo la Proclamación de Emancipación?",
                  options: ["Puso fin oficialmente a la Guerra Civil", "Concedió a las mujeres el derecho al voto", "Liberó a los esclavos en los estados confederados", "Creó el Partido Republicano"],
                  explanation: "La Proclamación de Emancipación declaró libres a todas las personas esclavizadas en los estados confederados.")
        ]),
        UnifiedQuestion(id: "q_08_077", correctAnswer: 3, variants: [
            .init(text: "What did Susan B. Anthony do?",
                  options: ["Led the Underground Railroad to free enslaved people", "Wrote the Emancipation Proclamation", "Was the first woman elected to the U.S. Congress", "Fought for women's rights and civil rights"],
                  explanation: "Susan B. Anthony campaigned for women's right to vote. The 19th Amendment (1920) is sometimes called the 'Susan B. Anthony Amendment.'"),
            .init(text: "¿Qué hizo Susan B. Anthony?",
                  options: ["Lideró el Ferrocarril Subterráneo para liberar a los esclavizados", "Redactó la Proclamación de Emancipación", "Fue la primera mujer elegida al Congreso de EE. UU.", "Luchó por los derechos de la mujer y los derechos civiles"],
                  explanation: "Susan B. Anthony luchó por el derecho al voto de las mujeres. La 19.ª Enmienda (1920) a veces es llamada la «Enmienda Susan B. Anthony».")
        ]),
        UnifiedQuestion(id: "q_08_078", correctAnswer: 3, variants: [
            .init(text: "Name one war fought by the United States in the 1900s.",
                  options: ["The Civil War", "The Revolutionary War", "The War of 1812", "World War I"],
                  explanation: "U.S. wars in the 1900s: WWI, WWII, Korean War, Vietnam War, and Persian Gulf War."),
            .init(text: "Nombre una guerra en la que participaron los Estados Unidos en el siglo XX.",
                  options: ["La Guerra Civil", "La Guerra de Independencia", "La Guerra de 1812", "La Primera Guerra Mundial"],
                  explanation: "Las guerras de EE. UU. en el siglo XX incluyen la Primera Guerra Mundial, la Segunda Guerra Mundial, la Guerra de Corea, la Guerra de Vietnam y la Guerra del Golfo Pérsico.")
        ]),
        UnifiedQuestion(id: "q_08_079", correctAnswer: 2, variants: [
            .init(text: "Who was President during World War I?",
                  options: ["Theodore Roosevelt", "Abraham Lincoln", "Woodrow Wilson", "Franklin Roosevelt"],
                  explanation: "Woodrow Wilson was the 28th President. He led the United States through World War I (1917–1918) and proposed the League of Nations to maintain world peace after the war."),
            .init(text: "¿Quién fue presidente durante la Primera Guerra Mundial?",
                  options: ["Theodore Roosevelt", "Abraham Lincoln", "Woodrow Wilson", "Franklin Roosevelt"],
                  explanation: "Woodrow Wilson fue el 28.º Presidente. Lideró a los Estados Unidos durante la Primera Guerra Mundial (1917–1918) y propuso la Liga de Naciones para mantener la paz mundial.")
        ]),
        UnifiedQuestion(id: "q_08_080", correctAnswer: 3, variants: [
            .init(text: "Who was President during the Great Depression and World War II?",
                  options: ["Herbert Hoover", "Calvin Coolidge", "Harry Truman", "Franklin Roosevelt"],
                  explanation: "Franklin D. Roosevelt (FDR), the 32nd President, led the nation through both the Great Depression and World War II. He served four terms — the most of any President."),
            .init(text: "¿Quién fue presidente durante la Gran Depresión y la Segunda Guerra Mundial?",
                  options: ["Herbert Hoover", "Calvin Coolidge", "Harry Truman", "Franklin Roosevelt"],
                  explanation: "Franklin D. Roosevelt (FDR), el 32.º Presidente, lideró al país durante la Gran Depresión y la Segunda Guerra Mundial. Fue elegido cuatro veces, más que cualquier otro presidente.")
        ])
    ]

    // MARK: - Practice Set 9: Historia del siglo XX (Q81–Q90)
    static let practice9: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_081", correctAnswer: 2, variants: [
            .init(text: "Who did the United States fight in World War II?",
                  options: ["Germany, Russia, and China", "Japan, France, and Italy", "Japan, Germany, and Italy", "Britain, France, and Germany"],
                  explanation: "The U.S. fought the Axis Powers: Japan, Germany, and Italy. The U.S. entered after Japan attacked Pearl Harbor on December 7, 1941."),
            .init(text: "¿Contra quién luchó Estados Unidos en la Segunda Guerra Mundial?",
                  options: ["Alemania, Rusia y China", "Japón, Francia e Italia", "Japón, Alemania e Italia", "Gran Bretaña, Francia y Alemania"],
                  explanation: "EE. UU. combatió a las Potencias del Eje: Japón, Alemania e Italia. EE. UU. entró en la guerra tras el ataque japonés a Pearl Harbor el 7 de diciembre de 1941.")
        ]),
        UnifiedQuestion(id: "q_08_082", correctAnswer: 1, variants: [
            .init(text: "Before he was President, Eisenhower was a general. What war was he in?",
                  options: ["World War I", "World War II", "Korean War", "Vietnam War"],
                  explanation: "Eisenhower served as Supreme Commander of Allied Forces in Europe during WWII, then became the 34th President."),
            .init(text: "Antes de ser Presidente, Eisenhower fue general. ¿En qué guerra participó?",
                  options: ["La Primera Guerra Mundial", "La Segunda Guerra Mundial", "La Guerra de Corea", "La Guerra de Vietnam"],
                  explanation: "Eisenhower fue Comandante Supremo de las Fuerzas Aliadas en Europa durante la Segunda Guerra Mundial y luego se convirtió en el 34.º Presidente.")
        ]),
        UnifiedQuestion(id: "q_08_083", correctAnswer: 3, variants: [
            .init(text: "During the Cold War, what was the main concern of the United States?",
                  options: ["Economic recession and unemployment", "Climate change and pollution", "Illegal immigration", "Communism / the spread of communism and nuclear war"],
                  explanation: "The Cold War (1947–1991) was a global conflict between the democratic U.S. and communist Soviet Union."),
            .init(text: "Durante la Guerra Fría, ¿cuál era la principal preocupación de los Estados Unidos?",
                  options: ["La recesión económica y el desempleo", "El cambio climático y la contaminación", "La inmigración ilegal", "El comunismo / la expansión del comunismo y la guerra nuclear"],
                  explanation: "La Guerra Fría (1947–1991) fue un conflicto global entre EE. UU., defensor de la democracia, y la Unión Soviética, de régimen comunista.")
        ]),
        UnifiedQuestion(id: "q_08_084", correctAnswer: 2, variants: [
            .init(text: "What movement tried to end racial discrimination?",
                  options: ["The Temperance Movement", "The Labor Movement", "The Civil Rights Movement", "The Women's Suffrage Movement"],
                  explanation: "The Civil Rights Movement of the 1950s–1960s fought to end racial segregation, resulting in the Civil Rights Act of 1964."),
            .init(text: "¿Qué movimiento intentó poner fin a la discriminación racial?",
                  options: ["El Movimiento por la Templanza", "El Movimiento Obrero", "El Movimiento por los Derechos Civiles", "El Movimiento por el Sufragio Femenino"],
                  explanation: "El Movimiento por los Derechos Civiles de las décadas de 1950 y 1960 luchó para acabar con la segregación racial, lo que dio lugar a la Ley de Derechos Civiles de 1964.")
        ]),
        UnifiedQuestion(id: "q_08_085", correctAnswer: 2, variants: [
            .init(text: "What did Martin Luther King, Jr. do?",
                  options: ["Led the Underground Railroad to free enslaved people", "Served as the first Black President of the NAACP", "Fought for civil rights and equality for all Americans", "Wrote the Civil Rights Act of 1964"],
                  explanation: "Dr. Martin Luther King, Jr. was the most prominent Civil Rights leader. He received the Nobel Peace Prize in 1964."),
            .init(text: "¿Qué hizo Martin Luther King Jr.?",
                  options: ["Lideró el Ferrocarril Subterráneo para liberar a los esclavizados", "Fue el primer presidente negro de la NAACP", "Luchó por los derechos civiles y la igualdad para todos los estadounidenses", "Redactó la Ley de Derechos Civiles de 1964"],
                  explanation: "El Dr. Martin Luther King Jr. fue el líder más destacado del movimiento por los derechos civiles. Recibió el Premio Nobel de la Paz en 1964.")
        ]),
        UnifiedQuestion(id: "q_08_086", correctAnswer: 2, variants: [
            .init(text: "What major event happened on September 11, 2001, in the United States?",
                  options: ["A major hurricane struck the East Coast", "A financial crisis closed the stock market", "Terrorists attacked the United States", "The United States declared war on Iraq"],
                  explanation: "On September 11, 2001, al-Qaeda terrorists hijacked four planes and attacked the World Trade Center (New York) and the Pentagon (Virginia). Nearly 3,000 people were killed."),
            .init(text: "¿Qué evento importante ocurrió el 11 de septiembre de 2001 en los Estados Unidos?",
                  options: ["Un gran huracán azotó la Costa Este", "Una crisis financiera cerró la bolsa de valores", "Terroristas atacaron a los Estados Unidos", "Los Estados Unidos declararon la guerra a Irak"],
                  explanation: "El 11 de septiembre de 2001, terroristas de Al-Qaeda secuestraron cuatro aviones y atacaron el World Trade Center (Nueva York) y el Pentágono (Virginia). Casi 3,000 personas murieron en los ataques.")
        ]),
        UnifiedQuestion(id: "q_08_087", correctAnswer: 3, variants: [
            .init(text: "Name one American Indian tribe in the United States.",
                  options: ["Aztec", "Maya", "Inca", "Cherokee or Navajo"],
                  explanation: "USCIS accepts many tribes: Cherokee, Navajo, Sioux, Chippewa, Choctaw, Pueblo, Apache, Iroquois, Creek, Blackfeet, Seminole, Cheyenne, Shawnee, Lakota, Crow, Hopi, Inuit, and others."),
            .init(text: "Nombre una tribu indígena americana en los Estados Unidos.",
                  options: ["Azteca", "Maya", "Inca", "Cherokee o Navajo"],
                  explanation: "La USCIS acepta muchas tribus: Cherokee, Navajo, Sioux, Chippewa, Choctaw, Pueblo, Apache, Iroquois, Creek, Blackfeet, Seminole, Cheyenne, Shawnee, Lakota, Crow, Hopi, Inuit y otras. (Los aztecas, mayas e incas son latinoamericanos, no de EE. UU.)")
        ]),
        UnifiedQuestion(id: "q_08_088", correctAnswer: 2, variants: [
            .init(text: "Name one of the two longest rivers in the United States.",
                  options: ["The Colorado River or the Rio Grande", "The Ohio River or the Columbia River", "The Missouri River or the Mississippi River", "The Hudson River or the Tennessee River"],
                  explanation: "The Missouri River and Mississippi River are the two longest rivers in the United States."),
            .init(text: "Nombre uno de los dos ríos más largos de los Estados Unidos.",
                  options: ["El río Colorado o el río Bravo", "El río Ohio o el río Columbia", "El río Misuri o el río Misisipi", "El río Hudson o el río Tennessee"],
                  explanation: "El río Misuri y el río Misisipi son los dos ríos más largos de los Estados Unidos.")
        ]),
        UnifiedQuestion(id: "q_08_089", correctAnswer: 3, variants: [
            .init(text: "What ocean is on the West Coast of the United States?",
                  options: ["Atlantic Ocean", "Indian Ocean", "Arctic Ocean", "Pacific Ocean"],
                  explanation: "The Pacific Ocean borders the West Coast, including California, Oregon, Washington, and Alaska."),
            .init(text: "¿Qué océano está en la Costa Oeste de los Estados Unidos?",
                  options: ["Océano Atlántico", "Océano Índico", "Océano Ártico", "Océano Pacífico"],
                  explanation: "El Océano Pacífico bordea la Costa Oeste, incluyendo California, Oregón, Washington y Alaska.")
        ]),
        UnifiedQuestion(id: "q_08_090", correctAnswer: 2, variants: [
            .init(text: "What ocean is on the East Coast of the United States?",
                  options: ["Pacific Ocean", "Indian Ocean", "Atlantic Ocean", "Arctic Ocean"],
                  explanation: "The Atlantic Ocean borders the East Coast of the United States, from Maine to Florida."),
            .init(text: "¿Qué océano está en la Costa Este de los Estados Unidos?",
                  options: ["Océano Pacífico", "Océano Índico", "Océano Atlántico", "Océano Ártico"],
                  explanation: "El Océano Atlántico bordea la Costa Este de los Estados Unidos, desde Maine hasta Florida.")
        ])
    ]

    // MARK: - Practice Set 10: Geografía, símbolos y días festivos (Q91–Q100)
    static let practice10: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_091", correctAnswer: 1, variants: [
            .init(text: "Name one U.S. territory.",
                  options: ["Cuba", "Puerto Rico", "Dominican Republic", "Philippines"],
                  explanation: "U.S. territories include Puerto Rico, U.S. Virgin Islands, American Samoa, Guam, and the Northern Mariana Islands."),
            .init(text: "Nombre un territorio de EE. UU.",
                  options: ["Cuba", "Puerto Rico", "República Dominicana", "Filipinas"],
                  explanation: "Los territorios de EE. UU. incluyen Puerto Rico, las Islas Vírgenes de EE. UU., Samoa Americana, Guam y las Islas Marianas del Norte.")
        ]),
        UnifiedQuestion(id: "q_08_092", correctAnswer: 3, variants: [
            .init(text: "Name one state that borders Canada.",
                  options: ["California", "Florida", "Texas", "Minnesota"],
                  explanation: "States bordering Canada include Maine, New York, Michigan, Minnesota, North Dakota, Montana, Idaho, Washington, and Alaska."),
            .init(text: "Nombre un estado que tenga frontera con Canadá.",
                  options: ["California", "Florida", "Texas", "Minnesota"],
                  explanation: "Los estados que limitan con Canadá incluyen Maine, Nueva York, Míchigan, Minnesota, Dakota del Norte, Montana, Idaho, Washington y Alaska.")
        ]),
        UnifiedQuestion(id: "q_08_093", correctAnswer: 3, variants: [
            .init(text: "Name one state that borders Mexico.",
                  options: ["Florida", "Louisiana", "Nevada", "Texas"],
                  explanation: "Four states share a border with Mexico: California, Arizona, New Mexico, and Texas."),
            .init(text: "Nombre un estado que tenga frontera con México.",
                  options: ["Florida", "Luisiana", "Nevada", "Texas"],
                  explanation: "Cuatro estados comparten frontera con México: California, Arizona, Nuevo México y Texas.")
        ]),
        UnifiedQuestion(id: "q_08_094", correctAnswer: 3, variants: [
            .init(text: "What is the capital of the United States?",
                  options: ["New York City", "Los Angeles", "Chicago", "Washington, D.C."],
                  explanation: "Washington, D.C. has been the nation's capital since 1800. It is not part of any state."),
            .init(text: "¿Cuál es la capital de los Estados Unidos?",
                  options: ["Nueva York", "Los Ángeles", "Chicago", "Washington, D.C."],
                  explanation: "Washington, D.C. ha sido la capital de la nación desde 1800. No forma parte de ningún estado.")
        ]),
        UnifiedQuestion(id: "q_08_095", correctAnswer: 2, variants: [
            .init(text: "Where is the Statue of Liberty?",
                  options: ["Philadelphia, Pennsylvania", "Boston, Massachusetts", "New York (Harbor) / Liberty Island", "Washington, D.C."],
                  explanation: "The Statue of Liberty stands on Liberty Island in New York Harbor. A gift from France, dedicated in 1886."),
            .init(text: "¿Dónde está la Estatua de la Libertad?",
                  options: ["Filadelfia, Pensilvania", "Boston, Massachusetts", "Nueva York (Puerto) / Isla de la Libertad", "Washington, D.C."],
                  explanation: "La Estatua de la Libertad se encuentra en la Isla de la Libertad, en el puerto de Nueva York. Fue un regalo de Francia, inaugurado en 1886.")
        ]),
        UnifiedQuestion(id: "q_08_096", correctAnswer: 2, variants: [
            .init(text: "Why does the flag have 13 stripes?",
                  options: ["For the 13 presidents who served before Lincoln", "For the 13 amendments that form the Bill of Rights", "Because there were 13 original colonies", "For the 13 original Supreme Court justices"],
                  explanation: "The 13 stripes represent the original 13 colonies that became the nation's first 13 states."),
            .init(text: "¿Por qué la bandera tiene 13 franjas?",
                  options: ["Por los 13 presidentes que gobernaron antes de Lincoln", "Por las 13 enmiendas que forman la Carta de Derechos", "Porque había 13 colonias originales", "Por los 13 magistrados originales de la Corte Suprema"],
                  explanation: "Las 13 franjas representan las 13 colonias originales que se convirtieron en los primeros 13 estados de la nación.")
        ]),
        UnifiedQuestion(id: "q_08_097", correctAnswer: 3, variants: [
            .init(text: "Why does the flag have 50 stars?",
                  options: ["For the 50 largest U.S. cities", "For the 50 years since independence", "For the 50 most important federal laws", "Because there is one star for each state"],
                  explanation: "Each of the 50 stars represents one U.S. state. The current flag was adopted July 4, 1960."),
            .init(text: "¿Por qué la bandera tiene 50 estrellas?",
                  options: ["Por las 50 ciudades más grandes de EE. UU.", "Por los 50 años de independencia", "Por las 50 leyes federales más importantes", "Porque hay una estrella por cada estado"],
                  explanation: "Cada una de las 50 estrellas representa un estado de EE. UU. La bandera actual fue adoptada el 4 de julio de 1960.")
        ]),
        UnifiedQuestion(id: "q_08_098", correctAnswer: 3, variants: [
            .init(text: "What is the name of the national anthem?",
                  options: ["America the Beautiful", "God Bless America", "My Country, 'Tis of Thee", "The Star-Spangled Banner"],
                  explanation: "'The Star-Spangled Banner,' written by Francis Scott Key during the War of 1812, became the national anthem in 1931."),
            .init(text: "¿Cómo se llama el himno nacional?",
                  options: ["América la Bella", "Dios Bendiga a América", "Mi País, a Ti", "The Star-Spangled Banner (La bandera adornada de estrellas)"],
                  explanation: "«The Star-Spangled Banner», escrito por Francis Scott Key durante la Guerra de 1812, se convirtió en el himno nacional en 1931.")
        ]),
        UnifiedQuestion(id: "q_08_099", correctAnswer: 1, variants: [
            .init(text: "When do we celebrate Independence Day?",
                  options: ["July 1", "July 4", "September 4", "October 31"],
                  explanation: "Independence Day (July 4th) celebrates the adoption of the Declaration of Independence on July 4, 1776."),
            .init(text: "¿Cuándo celebramos el Día de la Independencia?",
                  options: ["1 de julio", "4 de julio", "4 de septiembre", "31 de octubre"],
                  explanation: "El Día de la Independencia (4 de julio) celebra la adopción de la Declaración de Independencia el 4 de julio de 1776.")
        ]),
        UnifiedQuestion(id: "q_08_100", correctAnswer: 1, variants: [
            .init(text: "Name two national U.S. holidays.",
                  options: ["Valentine's Day and Easter", "Independence Day and Thanksgiving", "Hanukkah and Kwanzaa", "New Year's Eve and April Fool's Day"],
                  explanation: "Federal holidays include New Year's Day, MLK Day, Presidents' Day, Memorial Day, Independence Day, Labor Day, Veterans Day, Thanksgiving, and Christmas."),
            .init(text: "Nombre dos días festivos nacionales de EE. UU.",
                  options: ["El Día de San Valentín y la Pascua", "El Día de la Independencia y el Día de Acción de Gracias", "Janucá y Kwanzaa", "La Nochevieja y el Día de los Inocentes"],
                  explanation: "Los días festivos federales incluyen Año Nuevo, el Día de Martin Luther King Jr., el Día de los Presidentes, el Día de los Caídos, el Día de la Independencia, el Día del Trabajo, el Día de los Veteranos, el Día de Acción de Gracias y la Navidad.")
        ])
    ]
}
