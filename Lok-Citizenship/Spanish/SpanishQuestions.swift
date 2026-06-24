
/// All Spanish (English ↔ Español) quiz question sets — the 128 official 2025
/// USCIS naturalization civics questions, regrouped thematically across 8
/// practice levels of exactly 16 questions each. IDs (`q_25_NNN`) match the
/// official USCIS question numbering 1-128 and mirror EnglishQuestions.swift
/// so a learner's mastery is interchangeable between the two languages.
///
/// Each question has 2 variants: [English, Spanish]. The English variant
/// (index 0) is byte-identical to the same-ID question in EnglishQuestions,
/// so bilingual learners can toggle mid-quiz without breaking spaced
/// repetition.
enum SpanishQuestions {

    // MARK: - Practice 1: Government Basics & Symbols (16 questions)
    static let practice1: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_001", correctAnswer: 0, variants: [
            .init(text: "What is the form of government of the United States?",
                  options: ["Republic", "Monarchy", "Dictatorship", "Direct democracy"],
                  explanation: "The U.S. is a constitution-based federal republic — a representative democracy where citizens elect officials to govern."),
            .init(text: "¿Cuál es la forma de gobierno de los Estados Unidos?",
                  options: ["República", "Monarquía", "Dictadura", "Democracia directa"],
                  explanation: "EE. UU. es una república federal basada en una constitución — una democracia representativa donde los ciudadanos eligen a sus gobernantes.")
        ]),
        UnifiedQuestion(id: "q_25_012", correctAnswer: 2, variants: [
            .init(text: "What is the economic system of the United States?",
                  options: ["Socialism", "Communism", "Capitalism", "Feudalism"],
                  explanation: "The U.S. operates a capitalist (free market) economy, where businesses and prices are largely determined by supply and demand."),
            .init(text: "¿Cuál es el sistema económico de los Estados Unidos?",
                  options: ["Socialismo", "Comunismo", "Capitalismo", "Feudalismo"],
                  explanation: "EE. UU. tiene una economía capitalista (de mercado libre), donde las empresas y los precios se determinan en gran medida por la oferta y la demanda.")
        ]),
        UnifiedQuestion(id: "q_25_016", correctAnswer: 1, variants: [
            .init(text: "Name the three branches of government.",
                  options: ["Federal, state, local", "Legislative, executive, and judicial", "President, Senate, House", "Republican, Democrat, Independent"],
                  explanation: "The three branches are the Legislative (Congress), Executive (President), and Judicial (the courts), each with separate powers."),
            .init(text: "Nombre las tres ramas del gobierno.",
                  options: ["Federal, estatal, local", "Legislativa, ejecutiva y judicial", "Presidente, Senado, Cámara", "Republicano, Demócrata, Independiente"],
                  explanation: "Las tres ramas son la Legislativa (Congreso), la Ejecutiva (Presidente) y la Judicial (los tribunales), cada una con poderes separados.")
        ]),
        UnifiedQuestion(id: "q_25_017", correctAnswer: 2, variants: [
            .init(text: "The President of the United States is in charge of which branch of government?",
                  options: ["Legislative branch", "Judicial branch", "Executive branch", "Military branch"],
                  explanation: "The President leads the Executive branch, which enforces the laws passed by Congress."),
            .init(text: "¿De qué rama del gobierno está a cargo el Presidente de los Estados Unidos?",
                  options: ["Rama legislativa", "Rama judicial", "Rama ejecutiva", "Rama militar"],
                  explanation: "El Presidente dirige la rama ejecutiva, que hace cumplir las leyes aprobadas por el Congreso.")
        ]),
        UnifiedQuestion(id: "q_25_038", correctAnswer: 2, variants: [
            .init(text: "What is the name of the President of the United States now?",
                  options: ["Joe Biden", "Barack Obama", "Donald Trump", "George W. Bush"],
                  explanation: "Donald Trump is the current President, serving his second term beginning January 2025."),
            .init(text: "¿Cómo se llama el actual Presidente de los Estados Unidos?",
                  options: ["Joe Biden", "Barack Obama", "Donald Trump", "George W. Bush"],
                  explanation: "Donald Trump es el actual Presidente, ejerciendo su segundo mandato a partir de enero de 2025.")
        ]),
        UnifiedQuestion(id: "q_25_039", correctAnswer: 1, variants: [
            .init(text: "What is the name of the Vice President of the United States now?",
                  options: ["Kamala Harris", "JD Vance", "Mike Pence", "Joe Biden"],
                  explanation: "JD Vance became Vice President in January 2025, serving alongside President Trump."),
            .init(text: "¿Cómo se llama el actual Vicepresidente de los Estados Unidos?",
                  options: ["Kamala Harris", "JD Vance", "Mike Pence", "Joe Biden"],
                  explanation: "JD Vance asumió la Vicepresidencia en enero de 2025, junto al Presidente Trump.")
        ]),
        UnifiedQuestion(id: "q_25_040", correctAnswer: 1, variants: [
            .init(text: "If the President can no longer serve, who becomes President?",
                  options: ["The Speaker of the House", "The Vice President", "The Secretary of State", "The Chief Justice"],
                  explanation: "The Vice President becomes President if the President can no longer serve, per the 25th Amendment."),
            .init(text: "Si el Presidente ya no puede servir, ¿quién se convierte en Presidente?",
                  options: ["El Presidente de la Cámara", "El Vicepresidente", "El Secretario de Estado", "El Presidente del Tribunal Supremo"],
                  explanation: "El Vicepresidente asume la Presidencia si el Presidente ya no puede servir, según la 25.ª Enmienda.")
        ]),
        UnifiedQuestion(id: "q_25_042", correctAnswer: 0, variants: [
            .init(text: "Who is Commander in Chief of the U.S. military?",
                  options: ["The President", "The Secretary of Defense", "A military general", "The Vice President"],
                  explanation: "The President serves as Commander in Chief, which keeps the military under civilian control."),
            .init(text: "¿Quién es el Comandante en Jefe de las fuerzas armadas de EE. UU.?",
                  options: ["El Presidente", "El Secretario de Defensa", "Un general militar", "El Vicepresidente"],
                  explanation: "El Presidente actúa como Comandante en Jefe, lo que mantiene a las fuerzas armadas bajo control civil.")
        ]),
        UnifiedQuestion(id: "q_25_052", correctAnswer: 2, variants: [
            .init(text: "What is the highest court in the United States?",
                  options: ["Federal Court", "Court of Appeals", "Supreme Court", "Circuit Court"],
                  explanation: "The Supreme Court is the highest court in the U.S. Its decisions are final and apply to all lower courts."),
            .init(text: "¿Cuál es el tribunal más alto de los Estados Unidos?",
                  options: ["Tribunal Federal", "Tribunal de Apelaciones", "Corte Suprema", "Tribunal de Circuito"],
                  explanation: "La Corte Suprema es el tribunal más alto de EE. UU. Sus decisiones son definitivas y se aplican a todos los tribunales inferiores.")
        ]),
        UnifiedQuestion(id: "q_25_053", correctAnswer: 1, variants: [
            .init(text: "How many seats are on the Supreme Court?",
                  options: ["7", "9", "11", "13"],
                  explanation: "The Supreme Court has 9 seats: one Chief Justice and eight Associate Justices, set by the Judiciary Act of 1869."),
            .init(text: "¿Cuántos asientos hay en la Corte Suprema?",
                  options: ["7", "9", "11", "13"],
                  explanation: "La Corte Suprema tiene 9 asientos: un Presidente del Tribunal y ocho jueces asociados, fijados por la Ley Judicial de 1869.")
        ]),
        UnifiedQuestion(id: "q_25_066", correctAnswer: 2, variants: [
            .init(text: "What do we show loyalty to when we say the Pledge of Allegiance?",
                  options: ["The President", "The state government", "The United States and the flag", "The military"],
                  explanation: "The Pledge of Allegiance shows loyalty to the United States and to the U.S. flag — symbols of the nation as a whole."),
            .init(text: "¿A qué le mostramos lealtad cuando recitamos el Juramento de Lealtad?",
                  options: ["Al Presidente", "Al gobierno estatal", "A los Estados Unidos y a la bandera", "A las fuerzas armadas"],
                  explanation: "El Juramento de Lealtad muestra fidelidad a los Estados Unidos y a la bandera estadounidense — símbolos de la nación entera.")
        ]),
        UnifiedQuestion(id: "q_25_119", correctAnswer: 1, variants: [
            .init(text: "What is the capital of the United States?",
                  options: ["New York City", "Washington, D.C.", "Philadelphia", "Boston"],
                  explanation: "Washington, D.C. has been the U.S. capital since 1800. The District of Columbia is named after Christopher Columbus."),
            .init(text: "¿Cuál es la capital de los Estados Unidos?",
                  options: ["Ciudad de Nueva York", "Washington, D. C.", "Filadelfia", "Boston"],
                  explanation: "Washington, D. C. es la capital de EE. UU. desde 1800. El Distrito de Columbia lleva el nombre de Cristóbal Colón.")
        ]),
        UnifiedQuestion(id: "q_25_121", correctAnswer: 2, variants: [
            .init(text: "Why does the flag have 13 stripes?",
                  options: ["For the 13 amendments", "For the 13 states bordering the ocean", "Because there were 13 original colonies", "For the 13 founding fathers"],
                  explanation: "The 13 stripes represent the 13 original colonies that declared independence and became the first U.S. states."),
            .init(text: "¿Por qué la bandera tiene 13 franjas?",
                  options: ["Por las 13 enmiendas", "Por los 13 estados costeros", "Porque había 13 colonias originales", "Por los 13 padres fundadores"],
                  explanation: "Las 13 franjas representan las 13 colonias originales que declararon la independencia y se convirtieron en los primeros estados de EE. UU.")
        ]),
        UnifiedQuestion(id: "q_25_122", correctAnswer: 1, variants: [
            .init(text: "Why does the flag have 50 stars?",
                  options: ["For the 50 founding fathers", "There is one star for each state", "For 50 years of independence", "For each amendment"],
                  explanation: "Each star represents one of the 50 U.S. states. A new star is added when a state joins the Union."),
            .init(text: "¿Por qué la bandera tiene 50 estrellas?",
                  options: ["Por los 50 padres fundadores", "Hay una estrella por cada estado", "Por los 50 años de independencia", "Por cada enmienda"],
                  explanation: "Cada estrella representa uno de los 50 estados de EE. UU. Se añade una nueva estrella cuando un estado se une a la Unión.")
        ]),
        UnifiedQuestion(id: "q_25_123", correctAnswer: 2, variants: [
            .init(text: "What is the name of the national anthem?",
                  options: ["America the Beautiful", "God Bless America", "The Star-Spangled Banner", "My Country, 'Tis of Thee"],
                  explanation: "\"The Star-Spangled Banner\" was written by Francis Scott Key in 1814 and became the official national anthem in 1931."),
            .init(text: "¿Cómo se llama el himno nacional?",
                  options: ["América la Bella", "Dios bendiga a América", "El estandarte adornado de estrellas (The Star-Spangled Banner)", "My Country, 'Tis of Thee"],
                  explanation: "\"The Star-Spangled Banner\" fue escrito por Francis Scott Key en 1814 y se convirtió en el himno nacional oficial en 1931.")
        ]),
        UnifiedQuestion(id: "q_25_124", correctAnswer: 1, variants: [
            .init(text: "The Nation's first motto was \"E Pluribus Unum.\" What does that mean?",
                  options: ["In God We Trust", "Out of many, one", "Liberty and justice for all", "We the People"],
                  explanation: "\"E Pluribus Unum\" (Latin) means \"Out of many, one.\" It refers to the union of many states forming one nation."),
            .init(text: "El primer lema de la nación fue «E Pluribus Unum». ¿Qué significa?",
                  options: ["En Dios confiamos", "De muchos, uno", "Libertad y justicia para todos", "Nosotros, el pueblo"],
                  explanation: "«E Pluribus Unum» (latín) significa «De muchos, uno». Hace referencia a la unión de muchos estados que forman una sola nación.")
        ])
    ]

    // MARK: - Practice 2: Constitution & Amendments (16 questions)
    static let practice2: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_002", correctAnswer: 2, variants: [
            .init(text: "What is the supreme law of the land?",
                  options: ["The Bill of Rights", "The Declaration of Independence", "The U.S. Constitution", "The Articles of Confederation"],
                  explanation: "The U.S. Constitution is the supreme law of the land. All other laws must comply with it."),
            .init(text: "¿Cuál es la ley suprema del país?",
                  options: ["La Carta de Derechos", "La Declaración de Independencia", "La Constitución de EE. UU.", "Los Artículos de la Confederación"],
                  explanation: "La Constitución de EE. UU. es la ley suprema del país. Todas las demás leyes deben cumplirla.")
        ]),
        UnifiedQuestion(id: "q_25_003", correctAnswer: 1, variants: [
            .init(text: "Name one thing the U.S. Constitution does.",
                  options: ["Declares war on Britain", "Forms the government and protects rights", "Lists all U.S. citizens", "Establishes the national religion"],
                  explanation: "The Constitution forms the government, defines its powers and parts, and protects the rights of the people."),
            .init(text: "Nombre una cosa que hace la Constitución de EE. UU.",
                  options: ["Declara la guerra a Gran Bretaña", "Forma el gobierno y protege los derechos", "Enumera a todos los ciudadanos de EE. UU.", "Establece la religión nacional"],
                  explanation: "La Constitución forma el gobierno, define sus poderes y partes, y protege los derechos del pueblo.")
        ]),
        UnifiedQuestion(id: "q_25_004", correctAnswer: 1, variants: [
            .init(text: "The U.S. Constitution starts with the words \"We the People.\" What does \"We the People\" mean?",
                  options: ["Only landowners", "Self-government and consent of the governed", "Only U.S. citizens", "The President alone"],
                  explanation: "\"We the People\" expresses self-government, popular sovereignty, and consent of the governed — government's power comes from the people."),
            .init(text: "La Constitución de EE. UU. comienza con las palabras «Nosotros, el pueblo». ¿Qué significan?",
                  options: ["Solo los propietarios", "Autogobierno y consentimiento de los gobernados", "Solo los ciudadanos de EE. UU.", "Únicamente el Presidente"],
                  explanation: "«Nosotros, el pueblo» expresa autogobierno, soberanía popular y consentimiento de los gobernados — el poder del gobierno proviene del pueblo.")
        ]),
        UnifiedQuestion(id: "q_25_005", correctAnswer: 1, variants: [
            .init(text: "How are changes made to the U.S. Constitution?",
                  options: ["By presidential order", "Through the amendment process", "By Supreme Court ruling", "By state vote alone"],
                  explanation: "Changes are made through amendments. An amendment requires a two-thirds vote in Congress and ratification by three-fourths of the states."),
            .init(text: "¿Cómo se hacen cambios a la Constitución de EE. UU.?",
                  options: ["Por orden presidencial", "Mediante el proceso de enmienda", "Por fallo de la Corte Suprema", "Solo por voto estatal"],
                  explanation: "Los cambios se realizan mediante enmiendas. Una enmienda requiere dos tercios del voto del Congreso y la ratificación de tres cuartas partes de los estados.")
        ]),
        UnifiedQuestion(id: "q_25_006", correctAnswer: 1, variants: [
            .init(text: "What does the Bill of Rights protect?",
                  options: ["Government property", "The basic rights of Americans", "Foreign trade only", "State borders"],
                  explanation: "The Bill of Rights — the first 10 amendments — protects the basic rights of Americans, including speech, religion, and due process."),
            .init(text: "¿Qué protege la Carta de Derechos?",
                  options: ["La propiedad del gobierno", "Los derechos básicos de los estadounidenses", "Solo el comercio exterior", "Las fronteras estatales"],
                  explanation: "La Carta de Derechos — las primeras 10 enmiendas — protege los derechos básicos de los estadounidenses, incluyendo expresión, religión y debido proceso.")
        ]),
        UnifiedQuestion(id: "q_25_007", correctAnswer: 2, variants: [
            .init(text: "How many amendments does the U.S. Constitution have?",
                  options: ["10", "17", "27", "50"],
                  explanation: "The Constitution has 27 amendments. The first 10 are the Bill of Rights; the most recent (27th) was ratified in 1992."),
            .init(text: "¿Cuántas enmiendas tiene la Constitución de EE. UU.?",
                  options: ["10", "17", "27", "50"],
                  explanation: "La Constitución tiene 27 enmiendas. Las primeras 10 son la Carta de Derechos; la más reciente (la 27.ª) fue ratificada en 1992.")
        ]),
        UnifiedQuestion(id: "q_25_008", correctAnswer: 1, variants: [
            .init(text: "Why is the Declaration of Independence important?",
                  options: ["It established the U.S. dollar", "It says all people are created equal and identifies inherent rights", "It ended World War II", "It created the Supreme Court"],
                  explanation: "The Declaration of Independence states America is free from British control, says all people are created equal, and identifies inherent rights and individual freedoms."),
            .init(text: "¿Por qué es importante la Declaración de Independencia?",
                  options: ["Estableció el dólar estadounidense", "Dice que todas las personas son creadas iguales e identifica derechos inherentes", "Puso fin a la Segunda Guerra Mundial", "Creó la Corte Suprema"],
                  explanation: "La Declaración de Independencia establece que EE. UU. está libre del control británico, dice que todas las personas son creadas iguales e identifica derechos inherentes y libertades individuales.")
        ]),
        UnifiedQuestion(id: "q_25_009", correctAnswer: 1, variants: [
            .init(text: "What founding document said the American colonies were free from Britain?",
                  options: ["The U.S. Constitution", "The Declaration of Independence", "The Bill of Rights", "The Federalist Papers"],
                  explanation: "The Declaration of Independence (1776) declared the 13 American colonies free from British rule."),
            .init(text: "¿Qué documento fundador declaró que las colonias americanas eran libres de Gran Bretaña?",
                  options: ["La Constitución de EE. UU.", "La Declaración de Independencia", "La Carta de Derechos", "Los Documentos Federalistas"],
                  explanation: "La Declaración de Independencia (1776) declaró libres a las 13 colonias americanas del dominio británico.")
        ]),
        UnifiedQuestion(id: "q_25_010", correctAnswer: 1, variants: [
            .init(text: "Name two important ideas from the Declaration of Independence and the U.S. Constitution.",
                  options: ["Monarchy and aristocracy", "Equality and liberty", "Slavery and segregation", "Foreign rule and conquest"],
                  explanation: "Important ideas include equality, liberty, social contract, natural rights, limited government, and self-government."),
            .init(text: "Nombre dos ideas importantes de la Declaración de Independencia y la Constitución de EE. UU.",
                  options: ["Monarquía y aristocracia", "Igualdad y libertad", "Esclavitud y segregación", "Dominio extranjero y conquista"],
                  explanation: "Ideas importantes incluyen la igualdad, la libertad, el contrato social, los derechos naturales, el gobierno limitado y el autogobierno.")
        ]),
        UnifiedQuestion(id: "q_25_011", correctAnswer: 2, variants: [
            .init(text: "The words \"Life, Liberty, and the pursuit of Happiness\" are in what founding document?",
                  options: ["U.S. Constitution", "Bill of Rights", "Declaration of Independence", "Articles of Confederation"],
                  explanation: "These famous words appear in the Declaration of Independence, written by Thomas Jefferson in 1776."),
            .init(text: "¿En qué documento fundador están las palabras «Vida, Libertad y la búsqueda de la Felicidad»?",
                  options: ["La Constitución de EE. UU.", "La Carta de Derechos", "La Declaración de Independencia", "Los Artículos de la Confederación"],
                  explanation: "Estas famosas palabras aparecen en la Declaración de Independencia, escrita por Thomas Jefferson en 1776.")
        ]),
        UnifiedQuestion(id: "q_25_013", correctAnswer: 2, variants: [
            .init(text: "What is the rule of law?",
                  options: ["The President can do anything", "The richest people make the rules", "Everyone must follow the law, including leaders", "Only judges follow the law"],
                  explanation: "The rule of law means everyone must obey the law — including leaders, the government, and ordinary citizens. No one is above the law."),
            .init(text: "¿Qué es el estado de derecho?",
                  options: ["El Presidente puede hacer cualquier cosa", "Los más ricos hacen las reglas", "Todos deben obedecer la ley, incluidos los líderes", "Solo los jueces obedecen la ley"],
                  explanation: "El estado de derecho significa que todos deben obedecer la ley — incluidos líderes, el gobierno y los ciudadanos comunes. Nadie está por encima de la ley.")
        ]),
        UnifiedQuestion(id: "q_25_014", correctAnswer: 1, variants: [
            .init(text: "Many documents influenced the U.S. Constitution. Name one.",
                  options: ["The Treaty of Paris", "The Federalist Papers", "The Monroe Doctrine", "The Marshall Plan"],
                  explanation: "Documents that influenced the Constitution include the Declaration of Independence, Articles of Confederation, Federalist Papers, Virginia Declaration of Rights, Mayflower Compact, and Iroquois Great Law of Peace."),
            .init(text: "Muchos documentos influyeron en la Constitución de EE. UU. Nombre uno.",
                  options: ["El Tratado de París", "Los Documentos Federalistas", "La Doctrina Monroe", "El Plan Marshall"],
                  explanation: "Entre los documentos que influyeron en la Constitución se incluyen la Declaración de Independencia, los Artículos de la Confederación, los Documentos Federalistas, la Declaración de Derechos de Virginia, el Pacto del Mayflower y la Gran Ley de la Paz de los Iroqueses.")
        ]),
        UnifiedQuestion(id: "q_25_015", correctAnswer: 1, variants: [
            .init(text: "There are three branches of government. Why?",
                  options: ["To create more jobs", "So one part does not become too powerful", "Because the colonies wanted three", "Because three is a lucky number"],
                  explanation: "Three branches with checks and balances ensure no single branch becomes too powerful — the principle of separation of powers."),
            .init(text: "Hay tres ramas del gobierno. ¿Por qué?",
                  options: ["Para crear más empleos", "Para que ninguna parte se vuelva demasiado poderosa", "Porque las colonias querían tres", "Porque tres es un número de la suerte"],
                  explanation: "Tres ramas con controles y equilibrios garantizan que ninguna sola rama se vuelva demasiado poderosa — el principio de separación de poderes.")
        ]),
        UnifiedQuestion(id: "q_25_060", correctAnswer: 1, variants: [
            .init(text: "What is the purpose of the 10th Amendment?",
                  options: ["To give all power to the federal government", "Powers not given to the federal government belong to the states or the people", "To establish religious freedom", "To allow free speech"],
                  explanation: "The 10th Amendment reserves any powers not delegated to the federal government — and not prohibited to states — for the states or the people."),
            .init(text: "¿Cuál es el propósito de la 10.ª Enmienda?",
                  options: ["Otorgar todo el poder al gobierno federal", "Los poderes no otorgados al gobierno federal pertenecen a los estados o al pueblo", "Establecer la libertad religiosa", "Permitir la libertad de expresión"],
                  explanation: "La 10.ª Enmienda reserva cualquier poder no delegado al gobierno federal — y no prohibido a los estados — para los estados o el pueblo.")
        ]),
        UnifiedQuestion(id: "q_25_097", correctAnswer: 1, variants: [
            .init(text: "What amendment says all persons born or naturalized in the United States, and subject to the jurisdiction thereof, are U.S. citizens?",
                  options: ["13th Amendment", "14th Amendment", "15th Amendment", "19th Amendment"],
                  explanation: "The 14th Amendment (1868) grants citizenship to all persons born or naturalized in the United States — known as birthright citizenship."),
            .init(text: "¿Qué enmienda dice que todas las personas nacidas o naturalizadas en los Estados Unidos, y sujetas a su jurisdicción, son ciudadanos de EE. UU.?",
                  options: ["13.ª Enmienda", "14.ª Enmienda", "15.ª Enmienda", "19.ª Enmienda"],
                  explanation: "La 14.ª Enmienda (1868) otorga la ciudadanía a todas las personas nacidas o naturalizadas en los Estados Unidos — conocida como ciudadanía por nacimiento.")
        ]),
        UnifiedQuestion(id: "q_25_102", correctAnswer: 2, variants: [
            .init(text: "When did all women get the right to vote?",
                  options: ["1865", "1870", "1920 (with the 19th Amendment)", "1965"],
                  explanation: "The 19th Amendment, ratified in 1920, gave women the right to vote nationwide after a long suffrage movement."),
            .init(text: "¿Cuándo obtuvieron todas las mujeres el derecho al voto?",
                  options: ["1865", "1870", "1920 (con la 19.ª Enmienda)", "1965"],
                  explanation: "La 19.ª Enmienda, ratificada en 1920, otorgó a las mujeres el derecho al voto a nivel nacional tras un largo movimiento sufragista.")
        ])
    ]

    // MARK: - Practice 3: Congress: Structure & Powers (16 questions)
    static let practice3: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_018", correctAnswer: 2, variants: [
            .init(text: "What part of the federal government writes laws?",
                  options: ["The Supreme Court", "The President", "U.S. Congress (legislative branch)", "The Cabinet"],
                  explanation: "Congress — the Senate and House of Representatives — is the legislative branch responsible for writing federal laws."),
            .init(text: "¿Qué parte del gobierno federal redacta las leyes?",
                  options: ["La Corte Suprema", "El Presidente", "El Congreso de EE. UU. (rama legislativa)", "El Gabinete"],
                  explanation: "El Congreso — el Senado y la Cámara de Representantes — es la rama legislativa encargada de redactar las leyes federales.")
        ]),
        UnifiedQuestion(id: "q_25_019", correctAnswer: 0, variants: [
            .init(text: "What are the two parts of the U.S. Congress?",
                  options: ["Senate and House of Representatives", "Cabinet and Senate", "President and Vice President", "House and Cabinet"],
                  explanation: "Congress is bicameral, made up of the Senate (100 members) and the House of Representatives (435 voting members)."),
            .init(text: "¿Cuáles son las dos partes del Congreso de EE. UU.?",
                  options: ["Senado y Cámara de Representantes", "Gabinete y Senado", "Presidente y Vicepresidente", "Cámara y Gabinete"],
                  explanation: "El Congreso es bicameral, compuesto por el Senado (100 miembros) y la Cámara de Representantes (435 miembros con derecho a voto).")
        ]),
        UnifiedQuestion(id: "q_25_020", correctAnswer: 2, variants: [
            .init(text: "Name one power of the U.S. Congress.",
                  options: ["Veto bills", "Decides Supreme Court cases", "Writes laws", "Commands the military"],
                  explanation: "Powers of Congress include writing laws, declaring war, and making the federal budget."),
            .init(text: "Nombre un poder del Congreso de EE. UU.",
                  options: ["Vetar proyectos de ley", "Decidir casos de la Corte Suprema", "Redactar leyes", "Comandar las fuerzas armadas"],
                  explanation: "Los poderes del Congreso incluyen redactar leyes, declarar la guerra y elaborar el presupuesto federal.")
        ]),
        UnifiedQuestion(id: "q_25_021", correctAnswer: 1, variants: [
            .init(text: "How many U.S. senators are there?",
                  options: ["50", "100", "435", "200"],
                  explanation: "There are 100 U.S. Senators — two from each of the 50 states, ensuring equal representation regardless of state size."),
            .init(text: "¿Cuántos senadores hay en EE. UU.?",
                  options: ["50", "100", "435", "200"],
                  explanation: "Hay 100 senadores de EE. UU. — dos por cada uno de los 50 estados, lo que garantiza una representación igualitaria sin importar el tamaño del estado.")
        ]),
        UnifiedQuestion(id: "q_25_022", correctAnswer: 2, variants: [
            .init(text: "How long is a term for a U.S. senator?",
                  options: ["2 years", "4 years", "6 years", "Life"],
                  explanation: "Senators serve 6-year terms. About one-third of the Senate is up for election every two years."),
            .init(text: "¿Cuánto dura el mandato de un senador de EE. UU.?",
                  options: ["2 años", "4 años", "6 años", "De por vida"],
                  explanation: "Los senadores sirven mandatos de 6 años. Aproximadamente un tercio del Senado se renueva cada dos años.")
        ]),
        UnifiedQuestion(id: "q_25_023", correctAnswer: 0, variants: [
            .init(text: "Who is one of your state's U.S. senators now?",
                  options: ["Depends on your state", "Joe Biden", "Donald Trump", "Ron DeSantis"],
                  explanation: "Each state has 2 U.S. Senators. Look up your state's current Senators at senate.gov before your interview. (D.C. and U.S. territories have no voting Senators.)"),
            .init(text: "¿Quién es actualmente uno de los senadores de su estado?",
                  options: ["Depende de su estado", "Joe Biden", "Donald Trump", "Ron DeSantis"],
                  explanation: "Cada estado tiene 2 senadores en EE. UU. Consulte quiénes son sus senadores actuales en senate.gov antes de su entrevista. (D. C. y los territorios no tienen senadores con derecho a voto.)")
        ]),
        UnifiedQuestion(id: "q_25_024", correctAnswer: 2, variants: [
            .init(text: "How many voting members are in the House of Representatives?",
                  options: ["100", "200", "435", "538"],
                  explanation: "The House has 435 voting members. Seats are apportioned by population, recalculated after each census."),
            .init(text: "¿Cuántos miembros con derecho a voto hay en la Cámara de Representantes?",
                  options: ["100", "200", "435", "538"],
                  explanation: "La Cámara tiene 435 miembros con derecho a voto. Los asientos se asignan por población, recalculados después de cada censo.")
        ]),
        UnifiedQuestion(id: "q_25_025", correctAnswer: 0, variants: [
            .init(text: "How long is a term for a member of the House of Representatives?",
                  options: ["2 years", "4 years", "6 years", "8 years"],
                  explanation: "House members serve 2-year terms. The entire House faces re-election every two years to keep them close to the people."),
            .init(text: "¿Cuánto dura el mandato de un miembro de la Cámara de Representantes?",
                  options: ["2 años", "4 años", "6 años", "8 años"],
                  explanation: "Los miembros de la Cámara cumplen mandatos de 2 años. Toda la Cámara se renueva cada dos años para mantenerse cerca del pueblo.")
        ]),
        UnifiedQuestion(id: "q_25_026", correctAnswer: 1, variants: [
            .init(text: "Why do U.S. representatives serve shorter terms than U.S. senators?",
                  options: ["To save government money", "To more closely follow public opinion", "Because they have less power", "Because they are appointed, not elected"],
                  explanation: "Representatives serve shorter (2-year) terms so they remain closely accountable to the public's current opinions."),
            .init(text: "¿Por qué los representantes de EE. UU. tienen mandatos más cortos que los senadores?",
                  options: ["Para ahorrar dinero al gobierno", "Para seguir más de cerca la opinión pública", "Porque tienen menos poder", "Porque son nombrados, no elegidos"],
                  explanation: "Los representantes cumplen mandatos más cortos (2 años) para responder más directamente a la opinión pública actual.")
        ]),
        UnifiedQuestion(id: "q_25_027", correctAnswer: 1, variants: [
            .init(text: "How many senators does each state have?",
                  options: ["1", "2", "3", "Depends on population"],
                  explanation: "Each state has 2 Senators, regardless of population. This was the Great Compromise to ensure equal state representation."),
            .init(text: "¿Cuántos senadores tiene cada estado?",
                  options: ["1", "2", "3", "Depende de la población"],
                  explanation: "Cada estado tiene 2 senadores, sin importar la población. Esto fue el Gran Compromiso para garantizar la representación estatal igualitaria.")
        ]),
        UnifiedQuestion(id: "q_25_028", correctAnswer: 0, variants: [
            .init(text: "Why does each state have two senators?",
                  options: ["For equal representation of small and large states (the Great Compromise)", "Because the Senate is the more important chamber", "To save election costs", "Because the Constitution forgot to specify"],
                  explanation: "Each state has 2 Senators for equal representation. This was the Great Compromise (Connecticut Compromise), balancing small-state and large-state interests."),
            .init(text: "¿Por qué cada estado tiene dos senadores?",
                  options: ["Para una representación igualitaria de estados pequeños y grandes (el Gran Compromiso)", "Porque el Senado es la cámara más importante", "Para ahorrar costos electorales", "Porque la Constitución olvidó especificar"],
                  explanation: "Cada estado tiene 2 senadores para una representación igualitaria. Esto fue el Gran Compromiso (Compromiso de Connecticut), que equilibró los intereses de estados pequeños y grandes.")
        ]),
        UnifiedQuestion(id: "q_25_029", correctAnswer: 0, variants: [
            .init(text: "Name your U.S. representative.",
                  options: ["Depends on your congressional district", "Mike Johnson", "Nancy Pelosi", "Kevin McCarthy"],
                  explanation: "Each congressional district has one Representative. Find yours at house.gov by entering your ZIP code."),
            .init(text: "Nombre a su representante de EE. UU.",
                  options: ["Depende de su distrito congresional", "Mike Johnson", "Nancy Pelosi", "Kevin McCarthy"],
                  explanation: "Cada distrito congresional tiene un representante. Encuentre el suyo en house.gov ingresando su código postal.")
        ]),
        UnifiedQuestion(id: "q_25_030", correctAnswer: 2, variants: [
            .init(text: "What is the name of the Speaker of the House of Representatives now?",
                  options: ["Nancy Pelosi", "Kevin McCarthy", "Mike Johnson", "Mitch McConnell"],
                  explanation: "Mike Johnson has been Speaker of the House since 2023. The Speaker leads the House and is second in line for presidential succession."),
            .init(text: "¿Cómo se llama el actual Presidente de la Cámara de Representantes?",
                  options: ["Nancy Pelosi", "Kevin McCarthy", "Mike Johnson", "Mitch McConnell"],
                  explanation: "Mike Johnson es Presidente de la Cámara desde 2023. El Presidente de la Cámara la dirige y es el segundo en la línea de sucesión presidencial.")
        ]),
        UnifiedQuestion(id: "q_25_031", correctAnswer: 1, variants: [
            .init(text: "Who does a U.S. senator represent?",
                  options: ["Only the President's party", "Citizens of their state", "Federal employees only", "The Supreme Court"],
                  explanation: "A U.S. Senator represents all the citizens (people) of their state."),
            .init(text: "¿A quién representa un senador de EE. UU.?",
                  options: ["Solo al partido del Presidente", "A los ciudadanos de su estado", "Solo a los empleados federales", "A la Corte Suprema"],
                  explanation: "Un senador de EE. UU. representa a todos los ciudadanos (personas) de su estado.")
        ]),
        UnifiedQuestion(id: "q_25_032", correctAnswer: 2, variants: [
            .init(text: "Who elects U.S. senators?",
                  options: ["State legislatures", "The President", "Citizens from their state", "Other Senators"],
                  explanation: "Citizens from each state elect their Senators. Before the 17th Amendment (1913), Senators were chosen by state legislatures."),
            .init(text: "¿Quién elige a los senadores de EE. UU.?",
                  options: ["Las legislaturas estatales", "El Presidente", "Los ciudadanos de su estado", "Otros senadores"],
                  explanation: "Los ciudadanos de cada estado eligen a sus senadores. Antes de la 17.ª Enmienda (1913), los senadores eran elegidos por las legislaturas estatales.")
        ]),
        UnifiedQuestion(id: "q_25_033", correctAnswer: 0, variants: [
            .init(text: "Who does a member of the House of Representatives represent?",
                  options: ["Citizens of their congressional district", "All U.S. citizens", "Their political party", "The President"],
                  explanation: "A House member represents the citizens (people) of their congressional district. House districts are based on population."),
            .init(text: "¿A quién representa un miembro de la Cámara de Representantes?",
                  options: ["A los ciudadanos de su distrito congresional", "A todos los ciudadanos de EE. UU.", "A su partido político", "Al Presidente"],
                  explanation: "Un miembro de la Cámara representa a los ciudadanos (personas) de su distrito congresional. Los distritos de la Cámara se basan en la población.")
        ])
    ]

    // MARK: - Practice 4: Congress & Executive (16 questions)
    static let practice4: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_034", correctAnswer: 1, variants: [
            .init(text: "Who elects members of the House of Representatives?",
                  options: ["The state governor", "Citizens from their congressional district", "The President", "The Senate"],
                  explanation: "Citizens from each congressional district elect their Representative every two years."),
            .init(text: "¿Quién elige a los miembros de la Cámara de Representantes?",
                  options: ["El gobernador del estado", "Los ciudadanos de su distrito congresional", "El Presidente", "El Senado"],
                  explanation: "Los ciudadanos de cada distrito congresional eligen a su representante cada dos años.")
        ]),
        UnifiedQuestion(id: "q_25_035", correctAnswer: 1, variants: [
            .init(text: "Some states have more representatives than other states. Why?",
                  options: ["Because they were states first", "Because of the state's population", "Because they pay more taxes", "Because they have more land"],
                  explanation: "House seats are apportioned by population. California has 52 representatives; small states like Wyoming have just 1."),
            .init(text: "Algunos estados tienen más representantes que otros. ¿Por qué?",
                  options: ["Porque fueron estados primero", "Por la población del estado", "Porque pagan más impuestos", "Porque tienen más territorio"],
                  explanation: "Los asientos de la Cámara se asignan por población. California tiene 52 representantes; estados pequeños como Wyoming tienen solo 1.")
        ]),
        UnifiedQuestion(id: "q_25_036", correctAnswer: 1, variants: [
            .init(text: "The President of the United States is elected for how many years?",
                  options: ["2 years", "4 years", "6 years", "Life"],
                  explanation: "The President serves a 4-year term, established by Article II of the Constitution."),
            .init(text: "¿Por cuántos años se elige al Presidente de los Estados Unidos?",
                  options: ["2 años", "4 años", "6 años", "De por vida"],
                  explanation: "El Presidente cumple un mandato de 4 años, establecido por el Artículo II de la Constitución.")
        ]),
        UnifiedQuestion(id: "q_25_037", correctAnswer: 1, variants: [
            .init(text: "The President of the United States can serve only two terms. Why?",
                  options: ["To save campaign costs", "Because of the 22nd Amendment (to prevent too much power)", "Because of tradition only", "Because the President gets too old"],
                  explanation: "The 22nd Amendment (1951) limits Presidents to two elected terms, preventing any one person from accumulating too much power. It was passed after FDR served four terms."),
            .init(text: "El Presidente de EE. UU. solo puede servir dos mandatos. ¿Por qué?",
                  options: ["Para ahorrar costos de campaña", "Por la 22.ª Enmienda (para evitar demasiado poder)", "Solo por tradición", "Porque el Presidente envejece"],
                  explanation: "La 22.ª Enmienda (1951) limita a los presidentes a dos mandatos electos, impidiendo que una sola persona acumule demasiado poder. Se aprobó después de que FDR sirviera cuatro mandatos.")
        ]),
        UnifiedQuestion(id: "q_25_041", correctAnswer: 1, variants: [
            .init(text: "Name one power of the President.",
                  options: ["Writes federal laws", "Vetoes bills", "Decides Supreme Court cases", "Declares war"],
                  explanation: "Presidential powers include vetoing bills, signing bills into law, enforcing laws, serving as Commander in Chief, and appointing federal judges."),
            .init(text: "Nombre un poder del Presidente.",
                  options: ["Redacta leyes federales", "Veta proyectos de ley", "Decide casos de la Corte Suprema", "Declara la guerra"],
                  explanation: "Los poderes presidenciales incluyen vetar proyectos de ley, firmar proyectos de ley para convertirlos en leyes, hacer cumplir las leyes, servir como Comandante en Jefe y nombrar jueces federales.")
        ]),
        UnifiedQuestion(id: "q_25_043", correctAnswer: 2, variants: [
            .init(text: "Who signs bills to become laws?",
                  options: ["The Speaker of the House", "The Vice President", "The President", "The Chief Justice"],
                  explanation: "After Congress passes a bill, the President signs it into law. The President can also veto a bill, returning it to Congress."),
            .init(text: "¿Quién firma los proyectos de ley para convertirlos en leyes?",
                  options: ["El Presidente de la Cámara", "El Vicepresidente", "El Presidente", "El Presidente del Tribunal Supremo"],
                  explanation: "Después de que el Congreso aprueba un proyecto de ley, el Presidente lo firma para convertirlo en ley. El Presidente también puede vetarlo, devolviéndolo al Congreso.")
        ]),
        UnifiedQuestion(id: "q_25_044", correctAnswer: 2, variants: [
            .init(text: "Who vetoes bills?",
                  options: ["The Senate", "The Supreme Court", "The President", "The Cabinet"],
                  explanation: "The President vetoes bills passed by Congress. Congress can override a veto with a two-thirds vote in both chambers."),
            .init(text: "¿Quién veta los proyectos de ley?",
                  options: ["El Senado", "La Corte Suprema", "El Presidente", "El Gabinete"],
                  explanation: "El Presidente veta los proyectos de ley aprobados por el Congreso. El Congreso puede anular un veto con dos tercios del voto en ambas cámaras.")
        ]),
        UnifiedQuestion(id: "q_25_045", correctAnswer: 2, variants: [
            .init(text: "Who appoints federal judges?",
                  options: ["The Speaker of the House", "The Chief Justice", "The President", "Congress"],
                  explanation: "The President appoints federal judges, including Supreme Court Justices. The Senate must confirm these appointments."),
            .init(text: "¿Quién nombra a los jueces federales?",
                  options: ["El Presidente de la Cámara", "El Presidente del Tribunal Supremo", "El Presidente", "El Congreso"],
                  explanation: "El Presidente nombra a los jueces federales, incluidos los magistrados de la Corte Suprema. El Senado debe confirmar estos nombramientos.")
        ]),
        UnifiedQuestion(id: "q_25_046", correctAnswer: 1, variants: [
            .init(text: "The executive branch has many parts. Name one.",
                  options: ["The Supreme Court", "The President's Cabinet", "The Senate", "Congress"],
                  explanation: "Parts of the Executive branch include the President, the Cabinet, and federal departments and agencies (like the FBI, EPA, IRS)."),
            .init(text: "La rama ejecutiva tiene muchas partes. Nombre una.",
                  options: ["La Corte Suprema", "El Gabinete del Presidente", "El Senado", "El Congreso"],
                  explanation: "Las partes de la rama ejecutiva incluyen el Presidente, el Gabinete y los departamentos y agencias federales (como el FBI, la EPA y el IRS).")
        ]),
        UnifiedQuestion(id: "q_25_047", correctAnswer: 1, variants: [
            .init(text: "What does the President's Cabinet do?",
                  options: ["Writes laws", "Advises the President", "Decides court cases", "Elects the next President"],
                  explanation: "The Cabinet is a group of advisors to the President, made up of the heads of the federal departments (like Secretary of State, Secretary of Defense)."),
            .init(text: "¿Qué hace el Gabinete del Presidente?",
                  options: ["Redacta leyes", "Asesora al Presidente", "Decide casos judiciales", "Elige al próximo Presidente"],
                  explanation: "El Gabinete es un grupo de asesores del Presidente, compuesto por los jefes de los departamentos federales (como el Secretario de Estado, el Secretario de Defensa).")
        ]),
        UnifiedQuestion(id: "q_25_048", correctAnswer: 0, variants: [
            .init(text: "What are two Cabinet-level positions?",
                  options: ["Secretary of State and Attorney General", "Speaker of the House and Senate Majority Leader", "Chief Justice and Vice President", "Governor and Mayor"],
                  explanation: "Cabinet-level positions include Secretary of State, Attorney General, Secretary of Defense, Secretary of the Treasury, Secretary of Homeland Security, and many others."),
            .init(text: "¿Cuáles son dos cargos a nivel de Gabinete?",
                  options: ["Secretario de Estado y Fiscal General", "Presidente de la Cámara y Líder de la Mayoría del Senado", "Presidente del Tribunal Supremo y Vicepresidente", "Gobernador y Alcalde"],
                  explanation: "Los cargos a nivel de Gabinete incluyen Secretario de Estado, Fiscal General, Secretario de Defensa, Secretario del Tesoro, Secretario de Seguridad Nacional y muchos otros.")
        ]),
        UnifiedQuestion(id: "q_25_049", correctAnswer: 0, variants: [
            .init(text: "Why is the Electoral College important?",
                  options: ["It decides who is elected President", "It chooses Supreme Court Justices", "It teaches government in college", "It runs federal elections"],
                  explanation: "The Electoral College decides who is elected President. It is a compromise between popular election and congressional selection of the President."),
            .init(text: "¿Por qué es importante el Colegio Electoral?",
                  options: ["Decide quién es elegido Presidente", "Elige a los magistrados de la Corte Suprema", "Enseña gobierno en la universidad", "Dirige las elecciones federales"],
                  explanation: "El Colegio Electoral decide quién es elegido Presidente. Es un compromiso entre la elección popular y la selección congresional del Presidente.")
        ]),
        UnifiedQuestion(id: "q_25_050", correctAnswer: 2, variants: [
            .init(text: "What is one part of the judicial branch?",
                  options: ["The Senate", "The Cabinet", "The Supreme Court", "The Pentagon"],
                  explanation: "The judicial branch includes the Supreme Court and the federal courts (district courts and courts of appeals)."),
            .init(text: "¿Cuál es una parte de la rama judicial?",
                  options: ["El Senado", "El Gabinete", "La Corte Suprema", "El Pentágono"],
                  explanation: "La rama judicial incluye la Corte Suprema y los tribunales federales (tribunales de distrito y tribunales de apelaciones).")
        ]),
        UnifiedQuestion(id: "q_25_051", correctAnswer: 1, variants: [
            .init(text: "What does the judicial branch do?",
                  options: ["Writes laws", "Reviews and explains laws", "Commands the military", "Collects taxes"],
                  explanation: "The judicial branch reviews laws, explains them, resolves disputes, and decides if a law goes against the Constitution."),
            .init(text: "¿Qué hace la rama judicial?",
                  options: ["Redacta leyes", "Revisa y explica las leyes", "Comanda las fuerzas armadas", "Recauda impuestos"],
                  explanation: "La rama judicial revisa las leyes, las explica, resuelve disputas y decide si una ley va en contra de la Constitución.")
        ]),
        UnifiedQuestion(id: "q_25_054", correctAnswer: 1, variants: [
            .init(text: "How many Supreme Court justices are usually needed to decide a case?",
                  options: ["3", "6 (a quorum)", "9 (all)", "5"],
                  explanation: "Per 28 U.S.C. §1, six (6) Justices constitute a quorum — the minimum number required to hear and decide a Supreme Court case. This is the official USCIS answer."),
            .init(text: "¿Cuántos magistrados de la Corte Suprema se necesitan normalmente para decidir un caso?",
                  options: ["3", "6 (quórum)", "9 (todos)", "5"],
                  explanation: "Según 28 U.S.C. §1, seis (6) magistrados constituyen el quórum — el número mínimo requerido para que la Corte Suprema escuche y decida un caso. Esta es la respuesta oficial de USCIS.")
        ]),
        UnifiedQuestion(id: "q_25_055", correctAnswer: 3, variants: [
            .init(text: "How long do Supreme Court justices serve?",
                  options: ["4 years", "8 years", "12 years", "For life (lifetime appointment)"],
                  explanation: "Supreme Court Justices serve for life or until retirement. Lifetime appointments shield them from political pressure."),
            .init(text: "¿Cuánto tiempo sirven los jueces de la Corte Suprema?",
                  options: ["4 años", "8 años", "12 años", "De por vida (nombramiento vitalicio)"],
                  explanation: "Los jueces de la Corte Suprema sirven de por vida o hasta su jubilación. Los nombramientos vitalicios los protegen de las presiones políticas.")
        ])
    ]

    // MARK: - Practice 5: Judicial, Federalism & Rights (16 questions)
    static let practice5: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_056", correctAnswer: 1, variants: [
            .init(text: "Supreme Court justices serve for life. Why?",
                  options: ["To save retirement costs", "To be independent of politics", "Because they cannot be replaced", "Because they're appointed by the people"],
                  explanation: "Lifetime appointments protect Justices from political pressure, allowing them to interpret the Constitution independently."),
            .init(text: "Los magistrados de la Corte Suprema sirven de por vida. ¿Por qué?",
                  options: ["Para ahorrar costos de jubilación", "Para ser independientes de la política", "Porque no pueden ser reemplazados", "Porque son nombrados por el pueblo"],
                  explanation: "Los nombramientos vitalicios protegen a los magistrados de las presiones políticas, permitiéndoles interpretar la Constitución de forma independiente.")
        ]),
        UnifiedQuestion(id: "q_25_057", correctAnswer: 0, variants: [
            .init(text: "Who is the Chief Justice of the United States now?",
                  options: ["John Roberts", "Clarence Thomas", "Amy Coney Barrett", "Sonia Sotomayor"],
                  explanation: "John Roberts has been Chief Justice since 2005. He presides over the Supreme Court and over presidential impeachment trials."),
            .init(text: "¿Quién es actualmente el Presidente del Tribunal Supremo de EE. UU.?",
                  options: ["John Roberts", "Clarence Thomas", "Amy Coney Barrett", "Sonia Sotomayor"],
                  explanation: "John Roberts es Presidente del Tribunal Supremo desde 2005. Preside la Corte Suprema y los juicios de destitución presidencial.")
        ]),
        UnifiedQuestion(id: "q_25_058", correctAnswer: 2, variants: [
            .init(text: "Name one power that is only for the federal government.",
                  options: ["Issue driver's licenses", "Run public schools", "Declare war (or print money)", "Provide police services"],
                  explanation: "Federal-only powers include declaring war, printing paper money, minting coins, creating an army, making treaties, and setting foreign policy."),
            .init(text: "Nombre un poder que solo corresponde al gobierno federal.",
                  options: ["Expedir licencias de conducir", "Administrar escuelas públicas", "Declarar la guerra (o imprimir dinero)", "Proporcionar servicios policiales"],
                  explanation: "Los poderes exclusivamente federales incluyen declarar la guerra, imprimir papel moneda, acuñar monedas, crear un ejército, firmar tratados y fijar la política exterior.")
        ]),
        UnifiedQuestion(id: "q_25_059", correctAnswer: 2, variants: [
            .init(text: "Name one power that is only for the states.",
                  options: ["Print money", "Declare war", "Provide schooling and police protection", "Sign treaties"],
                  explanation: "State-only powers include providing education and schools, police and fire protection, issuing driver's licenses, and approving zoning."),
            .init(text: "Nombre un poder que solo corresponde a los estados.",
                  options: ["Imprimir dinero", "Declarar la guerra", "Proporcionar educación y protección policial", "Firmar tratados"],
                  explanation: "Los poderes exclusivos de los estados incluyen proporcionar educación y escuelas, protección policial y contra incendios, expedir licencias de conducir y aprobar la zonificación.")
        ]),
        UnifiedQuestion(id: "q_25_061", correctAnswer: 0, variants: [
            .init(text: "Who is the governor of your state now?",
                  options: ["Depends on your state", "Donald Trump", "Joe Biden", "Gavin Newsom"],
                  explanation: "Each state has its own Governor. Look up your current Governor on your state government's website. (Territories have appointed governors; D.C. has a mayor instead.)"),
            .init(text: "¿Quién es actualmente el gobernador de su estado?",
                  options: ["Depende de su estado", "Donald Trump", "Joe Biden", "Gavin Newsom"],
                  explanation: "Cada estado tiene su propio gobernador. Consulte quién es el gobernador actual en el sitio web del gobierno de su estado. (Los territorios tienen gobernadores designados; D. C. tiene un alcalde en su lugar.)")
        ]),
        UnifiedQuestion(id: "q_25_062", correctAnswer: 0, variants: [
            .init(text: "What is the capital of your state?",
                  options: ["Depends on your state", "Washington, D.C.", "New York City", "Los Angeles"],
                  explanation: "Each state has its own capital city. Know your state's capital before your interview. (D.C. is the U.S. capital, not a state. Territories also have capitals.)"),
            .init(text: "¿Cuál es la capital de su estado?",
                  options: ["Depende de su estado", "Washington, D. C.", "Ciudad de Nueva York", "Los Ángeles"],
                  explanation: "Cada estado tiene su propia capital. Conozca la capital de su estado antes de su entrevista. (D. C. es la capital de EE. UU., no un estado. Los territorios también tienen capitales.)")
        ]),
        UnifiedQuestion(id: "q_25_063", correctAnswer: 1, variants: [
            .init(text: "There are four amendments to the U.S. Constitution about who can vote. Describe one of them.",
                  options: ["Only homeowners can vote", "Citizens 18 and older can vote", "Only male citizens can vote", "Voting requires a literacy test"],
                  explanation: "The 26th Amendment (1971) lowered the voting age to 18. Other voting amendments are the 15th (men of any race), 19th (women), and 24th (no poll tax)."),
            .init(text: "Hay cuatro enmiendas a la Constitución de EE. UU. sobre quién puede votar. Describa una.",
                  options: ["Solo los propietarios pueden votar", "Los ciudadanos de 18 años o más pueden votar", "Solo los ciudadanos varones pueden votar", "Votar requiere una prueba de alfabetización"],
                  explanation: "La 26.ª Enmienda (1971) redujo la edad de voto a 18 años. Otras enmiendas sobre el voto son la 15.ª (hombres de cualquier raza), la 19.ª (mujeres) y la 24.ª (sin impuesto al voto).")
        ]),
        UnifiedQuestion(id: "q_25_064", correctAnswer: 1, variants: [
            .init(text: "Who can vote in federal elections, run for federal office, and serve on a jury in the United States?",
                  options: ["All adults", "U.S. citizens only", "Anyone with a passport", "Only military veterans"],
                  explanation: "Only U.S. citizens have the rights to vote in federal elections, run for federal office, and serve on a jury."),
            .init(text: "¿Quién puede votar en elecciones federales, postularse a un cargo federal y servir en un jurado en EE. UU.?",
                  options: ["Todos los adultos", "Solo los ciudadanos de EE. UU.", "Cualquiera con pasaporte", "Solo los veteranos militares"],
                  explanation: "Solo los ciudadanos de EE. UU. tienen el derecho de votar en elecciones federales, postularse a un cargo federal y servir en un jurado.")
        ]),
        UnifiedQuestion(id: "q_25_065", correctAnswer: 1, variants: [
            .init(text: "What are three rights of everyone living in the United States?",
                  options: ["Free housing, free food, free healthcare", "Freedom of speech, freedom of religion, and freedom of assembly", "Right to vote, run for office, and own land", "Right to drive, own a gun, and choose any job"],
                  explanation: "Rights of everyone living in the U.S. (citizen or not) include freedom of speech, religion, assembly, the press, and to petition the government."),
            .init(text: "¿Cuáles son tres derechos de todas las personas que viven en EE. UU.?",
                  options: ["Vivienda gratuita, comida gratuita, atención médica gratuita", "Libertad de expresión, libertad de religión y libertad de reunión", "Derecho a votar, postularse y poseer tierras", "Derecho a conducir, poseer un arma y elegir cualquier empleo"],
                  explanation: "Los derechos de todas las personas que viven en EE. UU. (ciudadanos o no) incluyen libertad de expresión, de religión, de reunión, de prensa y de petición al gobierno.")
        ]),
        UnifiedQuestion(id: "q_25_067", correctAnswer: 1, variants: [
            .init(text: "Name two promises that new citizens make in the Oath of Allegiance.",
                  options: ["Pay extra taxes and vote in every election", "Give up loyalty to other countries and obey U.S. laws", "Speak only English and serve in the military", "Become Christian and own property"],
                  explanation: "The Oath includes giving up loyalty to other countries, defending the Constitution, obeying U.S. laws, and serving the nation when needed."),
            .init(text: "Nombre dos promesas que hacen los nuevos ciudadanos en el Juramento de Lealtad.",
                  options: ["Pagar impuestos adicionales y votar en cada elección", "Renunciar a la lealtad a otros países y obedecer las leyes de EE. UU.", "Hablar solo inglés y servir en las fuerzas armadas", "Volverse cristiano y poseer propiedades"],
                  explanation: "El Juramento incluye renunciar a la lealtad a otros países, defender la Constitución, obedecer las leyes de EE. UU. y servir a la nación cuando sea necesario.")
        ]),
        UnifiedQuestion(id: "q_25_068", correctAnswer: 1, variants: [
            .init(text: "How can people become United States citizens?",
                  options: ["Only by being born in the U.S.", "By naturalization or being born in the U.S. (under certain conditions)", "Only by marrying a U.S. citizen", "Only by joining the military"],
                  explanation: "People become U.S. citizens by being born in the U.S. (under conditions of the 14th Amendment), through naturalization, or by deriving citizenship through their parents."),
            .init(text: "¿Cómo pueden las personas convertirse en ciudadanos de EE. UU.?",
                  options: ["Solo naciendo en EE. UU.", "Por naturalización o naciendo en EE. UU. (bajo ciertas condiciones)", "Solo casándose con un ciudadano", "Solo uniéndose a las fuerzas armadas"],
                  explanation: "Las personas se convierten en ciudadanos de EE. UU. al nacer en EE. UU. (bajo las condiciones de la 14.ª Enmienda), mediante la naturalización o derivando la ciudadanía de sus padres.")
        ]),
        UnifiedQuestion(id: "q_25_069", correctAnswer: 1, variants: [
            .init(text: "What are two examples of civic participation in the United States?",
                  options: ["Eating at restaurants and watching TV", "Voting and joining a community group", "Working a job and paying rent", "Driving a car and owning a home"],
                  explanation: "Civic participation includes voting, running for office, joining a political party or community group, contacting elected officials, and supporting/opposing issues."),
            .init(text: "¿Cuáles son dos ejemplos de participación cívica en EE. UU.?",
                  options: ["Comer en restaurantes y ver televisión", "Votar y unirse a un grupo comunitario", "Trabajar y pagar el alquiler", "Conducir un auto y ser propietario de una casa"],
                  explanation: "La participación cívica incluye votar, postularse a cargos, unirse a un partido político o grupo comunitario, contactar a funcionarios electos y apoyar u oponerse a temas.")
        ]),
        UnifiedQuestion(id: "q_25_070", correctAnswer: 1, variants: [
            .init(text: "What is one way Americans can serve their country?",
                  options: ["Get a high-paying job", "Serve in the military, work for the government, or pay taxes", "Travel abroad as a tourist", "Buy U.S.-made products"],
                  explanation: "Americans can serve by voting, paying taxes, obeying the law, serving in the military, running for office, or working for local, state, or federal government."),
            .init(text: "¿Cuál es una forma en que los estadounidenses pueden servir a su país?",
                  options: ["Conseguir un empleo bien remunerado", "Servir en las fuerzas armadas, trabajar para el gobierno o pagar impuestos", "Viajar al extranjero como turista", "Comprar productos fabricados en EE. UU."],
                  explanation: "Los estadounidenses pueden servir votando, pagando impuestos, obedeciendo la ley, sirviendo en las fuerzas armadas, postulándose a cargos o trabajando para el gobierno local, estatal o federal.")
        ]),
        UnifiedQuestion(id: "q_25_071", correctAnswer: 1, variants: [
            .init(text: "Why is it important to pay federal taxes?",
                  options: ["Because tax money goes to other countries", "It is required by law and funds the federal government", "Only wealthy citizens pay taxes", "Taxes are voluntary in the U.S."],
                  explanation: "Paying federal taxes is required by law and funds the federal government. The 16th Amendment (1913) authorized the federal income tax."),
            .init(text: "¿Por qué es importante pagar los impuestos federales?",
                  options: ["Porque el dinero de los impuestos va a otros países", "Es exigido por ley y financia al gobierno federal", "Solo los ciudadanos ricos pagan impuestos", "Los impuestos son voluntarios en EE. UU."],
                  explanation: "Pagar los impuestos federales es exigido por ley y financia al gobierno federal. La 16.ª Enmienda (1913) autorizó el impuesto federal sobre la renta.")
        ]),
        UnifiedQuestion(id: "q_25_072", correctAnswer: 1, variants: [
            .init(text: "It is important for all men age 18 through 25 to register for the Selective Service. Name one reason why.",
                  options: ["To get a free college education", "It is required by law (to make a draft fair if needed)", "To receive Social Security benefits", "To get a passport"],
                  explanation: "Selective Service registration is required by law for men ages 18-25. It allows the government to conduct a fair draft if one becomes necessary."),
            .init(text: "Es importante que todos los hombres de 18 a 25 años se inscriban en el Servicio Selectivo. Nombre una razón.",
                  options: ["Para obtener educación universitaria gratuita", "Es exigido por ley (para hacer un reclutamiento justo si fuera necesario)", "Para recibir beneficios del Seguro Social", "Para obtener un pasaporte"],
                  explanation: "La inscripción en el Servicio Selectivo es exigida por ley para los hombres de 18 a 25 años. Permite al gobierno realizar un reclutamiento justo si fuera necesario.")
        ]),
        UnifiedQuestion(id: "q_25_125", correctAnswer: 1, variants: [
            .init(text: "What is Independence Day?",
                  options: ["A holiday for Christopher Columbus", "A holiday celebrating U.S. independence from Britain", "A holiday honoring veterans", "A holiday for the Constitution"],
                  explanation: "Independence Day (July 4) celebrates the adoption of the Declaration of Independence in 1776 — the country's birthday."),
            .init(text: "¿Qué es el Día de la Independencia?",
                  options: ["Un feriado en honor a Cristóbal Colón", "Un feriado que celebra la independencia de EE. UU. de Gran Bretaña", "Un feriado en honor a los veteranos", "Un feriado para la Constitución"],
                  explanation: "El Día de la Independencia (4 de julio) celebra la adopción de la Declaración de Independencia en 1776 — el cumpleaños del país.")
        ])
    ]

    // MARK: - Practice 6: Founding Era & Revolution (16 questions)
    static let practice6: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_073", correctAnswer: 1, variants: [
            .init(text: "The colonists came to America for many reasons. Name one.",
                  options: ["To start a new civilization", "Religious freedom", "To find gold only", "To meet Native Americans"],
                  explanation: "Many colonists came seeking religious freedom, escaping persecution. Others came for political liberty or economic opportunity."),
            .init(text: "Los colonos vinieron a América por muchas razones. Nombre una.",
                  options: ["Para iniciar una nueva civilización", "Libertad religiosa", "Solo para encontrar oro", "Para conocer a los nativos americanos"],
                  explanation: "Muchos colonos llegaron buscando libertad religiosa, huyendo de la persecución. Otros vinieron por libertad política u oportunidad económica.")
        ]),
        UnifiedQuestion(id: "q_25_074", correctAnswer: 2, variants: [
            .init(text: "Who lived in America before the Europeans arrived?",
                  options: ["African settlers", "Asian immigrants", "American Indians (Native Americans)", "European explorers"],
                  explanation: "American Indians (Native Americans) lived across the Americas for thousands of years before European arrival."),
            .init(text: "¿Quién vivía en América antes de la llegada de los europeos?",
                  options: ["Colonos africanos", "Inmigrantes asiáticos", "Indios americanos (nativos americanos)", "Exploradores europeos"],
                  explanation: "Los indios americanos (nativos americanos) vivieron en todo el continente americano durante miles de años antes de la llegada europea.")
        ]),
        UnifiedQuestion(id: "q_25_075", correctAnswer: 2, variants: [
            .init(text: "What group of people was taken and sold as slaves?",
                  options: ["Native Americans", "Europeans", "Africans (people from Africa)", "Asians"],
                  explanation: "Africans were taken from their homelands and sold as slaves in the Americas, primarily from the 1500s to the 1800s."),
            .init(text: "¿Qué grupo de personas fue capturado y vendido como esclavos?",
                  options: ["Nativos americanos", "Europeos", "Africanos (personas de África)", "Asiáticos"],
                  explanation: "Los africanos fueron arrebatados de sus tierras y vendidos como esclavos en América, principalmente desde el siglo XVI hasta el XIX.")
        ]),
        UnifiedQuestion(id: "q_25_076", correctAnswer: 1, variants: [
            .init(text: "What war did the Americans fight to win independence from Britain?",
                  options: ["The Civil War", "The American Revolution (Revolutionary War)", "The War of 1812", "World War I"],
                  explanation: "The American Revolution (1775-1783) won the colonies' independence from Britain, formalized by the Treaty of Paris in 1783."),
            .init(text: "¿Qué guerra libraron los estadounidenses para obtener la independencia de Gran Bretaña?",
                  options: ["La Guerra Civil", "La Revolución Americana (Guerra de Independencia)", "La Guerra de 1812", "La Primera Guerra Mundial"],
                  explanation: "La Revolución Americana (1775-1783) consiguió la independencia de las colonias de Gran Bretaña, formalizada por el Tratado de París en 1783.")
        ]),
        UnifiedQuestion(id: "q_25_077", correctAnswer: 1, variants: [
            .init(text: "Name one reason why the Americans declared independence from Britain.",
                  options: ["Britain treated colonists too well", "High taxes (taxation without representation)", "The colonies wanted to merge with France", "British food was unhealthy"],
                  explanation: "Reasons included high taxes (taxation without representation), British soldiers in colonial homes, lack of self-government, the Boston Massacre, and the Boston Tea Party."),
            .init(text: "Nombre una razón por la que los estadounidenses declararon la independencia de Gran Bretaña.",
                  options: ["Gran Bretaña trataba demasiado bien a los colonos", "Impuestos altos (impuestos sin representación)", "Las colonias querían fusionarse con Francia", "La comida británica era poco saludable"],
                  explanation: "Las razones incluyeron impuestos altos (impuestos sin representación), soldados británicos en hogares coloniales, falta de autogobierno, la Masacre de Boston y el Motín del Té de Boston.")
        ]),
        UnifiedQuestion(id: "q_25_078", correctAnswer: 1, variants: [
            .init(text: "Who wrote the Declaration of Independence?",
                  options: ["George Washington", "Thomas Jefferson", "Benjamin Franklin", "John Adams"],
                  explanation: "Thomas Jefferson was the principal author of the Declaration of Independence, drafted in 1776 at age 33."),
            .init(text: "¿Quién redactó la Declaración de Independencia?",
                  options: ["George Washington", "Thomas Jefferson", "Benjamin Franklin", "John Adams"],
                  explanation: "Thomas Jefferson fue el autor principal de la Declaración de Independencia, redactada en 1776 a los 33 años.")
        ]),
        UnifiedQuestion(id: "q_25_079", correctAnswer: 1, variants: [
            .init(text: "When was the Declaration of Independence adopted?",
                  options: ["July 4, 1775", "July 4, 1776", "July 4, 1789", "July 4, 1812"],
                  explanation: "The Declaration of Independence was adopted on July 4, 1776 — celebrated annually as Independence Day."),
            .init(text: "¿Cuándo se adoptó la Declaración de Independencia?",
                  options: ["4 de julio de 1775", "4 de julio de 1776", "4 de julio de 1789", "4 de julio de 1812"],
                  explanation: "La Declaración de Independencia se adoptó el 4 de julio de 1776 — celebrado anualmente como el Día de la Independencia.")
        ]),
        UnifiedQuestion(id: "q_25_080", correctAnswer: 1, variants: [
            .init(text: "The American Revolution had many important events. Name one.",
                  options: ["The Battle of Gettysburg", "The Declaration of Independence (1776)", "Pearl Harbor attack", "Fall of the Berlin Wall"],
                  explanation: "Important Revolution events include the Battle of Bunker Hill, the Declaration of Independence, Washington crossing the Delaware, Valley Forge, and the Battle of Yorktown."),
            .init(text: "La Revolución Estadounidense tuvo muchos eventos importantes. Nombre uno.",
                  options: ["La Batalla de Gettysburg", "La Declaración de Independencia (1776)", "El ataque a Pearl Harbor", "La caída del Muro de Berlín"],
                  explanation: "Entre los eventos importantes de la Revolución se incluyen la Batalla de Bunker Hill, la Declaración de Independencia, el cruce del Delaware por Washington, Valley Forge y la Batalla de Yorktown.")
        ]),
        UnifiedQuestion(id: "q_25_081", correctAnswer: 1, variants: [
            .init(text: "There were 13 original states. Name five.",
                  options: ["California, Texas, Florida, Hawaii, Alaska", "Virginia, Massachusetts, New York, Pennsylvania, Georgia", "Ohio, Michigan, Illinois, Indiana, Wisconsin", "Maine, Vermont, West Virginia, Oregon, Iowa"],
                  explanation: "The 13 original states were New Hampshire, Massachusetts, Rhode Island, Connecticut, New York, New Jersey, Pennsylvania, Delaware, Maryland, Virginia, North Carolina, South Carolina, and Georgia."),
            .init(text: "Había 13 estados originales. Nombre cinco.",
                  options: ["California, Texas, Florida, Hawái, Alaska", "Virginia, Massachusetts, Nueva York, Pensilvania, Georgia", "Ohio, Michigan, Illinois, Indiana, Wisconsin", "Maine, Vermont, Virginia Occidental, Oregón, Iowa"],
                  explanation: "Los 13 estados originales fueron New Hampshire, Massachusetts, Rhode Island, Connecticut, Nueva York, Nueva Jersey, Pensilvania, Delaware, Maryland, Virginia, Carolina del Norte, Carolina del Sur y Georgia.")
        ]),
        UnifiedQuestion(id: "q_25_082", correctAnswer: 1, variants: [
            .init(text: "What founding document was written in 1787?",
                  options: ["The Declaration of Independence", "The U.S. Constitution", "The Bill of Rights", "The Articles of Confederation"],
                  explanation: "The U.S. Constitution was written at the Constitutional Convention in Philadelphia in 1787 and ratified in 1788."),
            .init(text: "¿Qué documento fundador se redactó en 1787?",
                  options: ["La Declaración de Independencia", "La Constitución de EE. UU.", "La Carta de Derechos", "Los Artículos de la Confederación"],
                  explanation: "La Constitución de EE. UU. fue redactada en la Convención Constitucional de Filadelfia en 1787 y ratificada en 1788.")
        ]),
        UnifiedQuestion(id: "q_25_083", correctAnswer: 1, variants: [
            .init(text: "The Federalist Papers supported the passage of the U.S. Constitution. Name one of the writers.",
                  options: ["Thomas Jefferson", "James Madison (or Hamilton, or Jay)", "George Washington", "Benjamin Franklin"],
                  explanation: "The Federalist Papers were written by James Madison, Alexander Hamilton, and John Jay (under the pen name \"Publius\") to argue for ratifying the Constitution."),
            .init(text: "Los Documentos Federalistas apoyaron la aprobación de la Constitución de EE. UU. Nombre a uno de los autores.",
                  options: ["Thomas Jefferson", "James Madison (o Hamilton, o Jay)", "George Washington", "Benjamin Franklin"],
                  explanation: "Los Documentos Federalistas fueron escritos por James Madison, Alexander Hamilton y John Jay (bajo el seudónimo «Publius») para argumentar a favor de la ratificación de la Constitución.")
        ]),
        UnifiedQuestion(id: "q_25_084", correctAnswer: 1, variants: [
            .init(text: "Why were the Federalist Papers important?",
                  options: ["They led to the American Revolution", "They helped people understand and supported passing the Constitution", "They started the Civil War", "They wrote new amendments"],
                  explanation: "The 85 Federalist essays explained how the new Constitution would work and persuaded states (especially New York) to ratify it."),
            .init(text: "¿Por qué fueron importantes los Documentos Federalistas?",
                  options: ["Llevaron a la Revolución Americana", "Ayudaron a la gente a entender y apoyaron la aprobación de la Constitución", "Iniciaron la Guerra Civil", "Escribieron nuevas enmiendas"],
                  explanation: "Los 85 ensayos federalistas explicaron cómo funcionaría la nueva Constitución y persuadieron a los estados (especialmente Nueva York) a ratificarla.")
        ]),
        UnifiedQuestion(id: "q_25_085", correctAnswer: 1, variants: [
            .init(text: "Benjamin Franklin is famous for many things. Name one.",
                  options: ["First President", "First Postmaster General and inventor", "Wrote the Declaration of Independence alone", "First Chief Justice"],
                  explanation: "Franklin was the first Postmaster General, an inventor, a U.S. diplomat, founder of the first free public libraries, and helped write the Declaration of Independence."),
            .init(text: "Benjamin Franklin es famoso por muchas cosas. Nombre una.",
                  options: ["Primer Presidente", "Primer Director General de Correos e inventor", "Escribió la Declaración de Independencia solo", "Primer Presidente del Tribunal Supremo"],
                  explanation: "Franklin fue el primer Director General de Correos, inventor, diplomático de EE. UU., fundador de las primeras bibliotecas públicas gratuitas y ayudó a escribir la Declaración de Independencia.")
        ]),
        UnifiedQuestion(id: "q_25_086", correctAnswer: 1, variants: [
            .init(text: "George Washington is famous for many things. Name one.",
                  options: ["Wrote the Declaration of Independence", "First President of the United States", "Discovered America", "Wrote the Star-Spangled Banner"],
                  explanation: "Washington is called the \"Father of Our Country.\" He led the Continental Army and was the first U.S. President (1789-1797)."),
            .init(text: "George Washington es famoso por muchas cosas. Nombre una.",
                  options: ["Escribió la Declaración de Independencia", "Primer Presidente de los Estados Unidos", "Descubrió América", "Escribió el Star-Spangled Banner"],
                  explanation: "Washington es llamado el «Padre de la Patria». Dirigió el Ejército Continental y fue el primer Presidente de EE. UU. (1789-1797).")
        ]),
        UnifiedQuestion(id: "q_25_087", correctAnswer: 1, variants: [
            .init(text: "Thomas Jefferson is famous for many things. Name one.",
                  options: ["Discovered electricity", "Wrote the Declaration of Independence and was 3rd President", "Led the Confederacy in the Civil War", "Invented the cotton gin"],
                  explanation: "Jefferson wrote the Declaration of Independence, was the 3rd President, doubled the U.S. with the Louisiana Purchase, and founded the University of Virginia."),
            .init(text: "Thomas Jefferson es famoso por muchas cosas. Nombre una.",
                  options: ["Descubrió la electricidad", "Escribió la Declaración de Independencia y fue el 3.º Presidente", "Lideró la Confederación en la Guerra Civil", "Inventó la desmotadora de algodón"],
                  explanation: "Jefferson escribió la Declaración de Independencia, fue el 3.º Presidente, duplicó EE. UU. con la Compra de Luisiana y fundó la Universidad de Virginia.")
        ]),
        UnifiedQuestion(id: "q_25_088", correctAnswer: 0, variants: [
            .init(text: "James Madison is famous for many things. Name one.",
                  options: ["Father of the Constitution and 4th President", "Led the Underground Railroad", "Discovered America", "Founded Boston"],
                  explanation: "Madison is called the \"Father of the Constitution.\" He was the 4th President, served during the War of 1812, and was a writer of the Federalist Papers."),
            .init(text: "James Madison es famoso por muchas cosas. Nombre una.",
                  options: ["Padre de la Constitución y 4.º Presidente", "Lideró el Ferrocarril Subterráneo", "Descubrió América", "Fundó Boston"],
                  explanation: "Madison es llamado el «Padre de la Constitución». Fue el 4.º Presidente, sirvió durante la Guerra de 1812 y fue uno de los autores de los Documentos Federalistas.")
        ])
    ]

    // MARK: - Practice 7: 1800s & National Identity (16 questions)
    static let practice7: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_089", correctAnswer: 1, variants: [
            .init(text: "Alexander Hamilton is famous for many things. Name one.",
                  options: ["First President of the U.S.", "First Secretary of the Treasury and Federalist Papers writer", "Discovered penicillin", "Wrote the Star-Spangled Banner"],
                  explanation: "Hamilton was the first Secretary of the Treasury, a writer of the Federalist Papers, helped establish the First Bank of the United States, and was an aide to General Washington."),
            .init(text: "Alexander Hamilton es famoso por muchas cosas. Nombre una.",
                  options: ["Primer Presidente de EE. UU.", "Primer Secretario del Tesoro y autor de los Documentos Federalistas", "Descubrió la penicilina", "Escribió el Star-Spangled Banner"],
                  explanation: "Hamilton fue el primer Secretario del Tesoro, autor de los Documentos Federalistas, ayudó a establecer el Primer Banco de los Estados Unidos y fue ayudante del general Washington.")
        ]),
        UnifiedQuestion(id: "q_25_090", correctAnswer: 1, variants: [
            .init(text: "What territory did the United States buy from France in 1803?",
                  options: ["Florida", "Louisiana Territory", "Alaska", "Texas"],
                  explanation: "President Jefferson bought the Louisiana Territory from France in 1803 for $15 million, doubling the size of the United States."),
            .init(text: "¿Qué territorio compró Estados Unidos a Francia en 1803?",
                  options: ["Florida", "El Territorio de Luisiana", "Alaska", "Texas"],
                  explanation: "El Presidente Jefferson compró el Territorio de Luisiana a Francia en 1803 por 15 millones de dólares, duplicando el tamaño de Estados Unidos.")
        ]),
        UnifiedQuestion(id: "q_25_091", correctAnswer: 1, variants: [
            .init(text: "Name one war fought by the United States in the 1800s.",
                  options: ["World War I", "Civil War (or War of 1812, Mexican-American War, Spanish-American War)", "Vietnam War", "Korean War"],
                  explanation: "Wars fought by the U.S. in the 1800s include the War of 1812, the Mexican-American War, the Civil War, and the Spanish-American War."),
            .init(text: "Nombre una guerra librada por EE. UU. en el siglo XIX.",
                  options: ["La Primera Guerra Mundial", "La Guerra Civil (o Guerra de 1812, Guerra México-Estadounidense, Guerra Hispano-Estadounidense)", "La Guerra de Vietnam", "La Guerra de Corea"],
                  explanation: "Entre las guerras libradas por EE. UU. en el siglo XIX se incluyen la Guerra de 1812, la Guerra México-Estadounidense, la Guerra Civil y la Guerra Hispano-Estadounidense.")
        ]),
        UnifiedQuestion(id: "q_25_092", correctAnswer: 2, variants: [
            .init(text: "Name the U.S. war between the North and the South.",
                  options: ["The Revolutionary War", "The War of 1812", "The Civil War", "The Mexican-American War"],
                  explanation: "The Civil War (1861-1865) was fought between the Northern Union states and the Southern Confederate states, primarily over slavery."),
            .init(text: "Nombre la guerra de EE. UU. entre el Norte y el Sur.",
                  options: ["La Guerra de la Independencia", "La Guerra de 1812", "La Guerra Civil", "La Guerra México-Estadounidense"],
                  explanation: "La Guerra Civil (1861-1865) se libró entre los estados de la Unión del Norte y los estados Confederados del Sur, principalmente por la esclavitud.")
        ]),
        UnifiedQuestion(id: "q_25_093", correctAnswer: 1, variants: [
            .init(text: "The Civil War had many important events. Name one.",
                  options: ["The bombing of Pearl Harbor", "The Battle of Gettysburg (or Emancipation Proclamation, Surrender at Appomattox)", "Construction of the Panama Canal", "The first moon landing"],
                  explanation: "Important Civil War events include the Battle of Fort Sumter, Emancipation Proclamation, Battle of Gettysburg, Sherman's March, and the Surrender at Appomattox."),
            .init(text: "La Guerra Civil tuvo muchos eventos importantes. Nombre uno.",
                  options: ["El bombardeo de Pearl Harbor", "La Batalla de Gettysburg (o la Proclamación de Emancipación, la Rendición de Appomattox)", "La construcción del Canal de Panamá", "La primera llegada a la Luna"],
                  explanation: "Entre los eventos importantes de la Guerra Civil se incluyen la Batalla de Fort Sumter, la Proclamación de Emancipación, la Batalla de Gettysburg, la Marcha de Sherman y la Rendición de Appomattox.")
        ]),
        UnifiedQuestion(id: "q_25_094", correctAnswer: 1, variants: [
            .init(text: "Abraham Lincoln is famous for many things. Name one.",
                  options: ["Wrote the Constitution", "Freed the slaves and preserved the Union", "Discovered electricity", "Founded the Republican Party"],
                  explanation: "Lincoln freed the slaves with the Emancipation Proclamation, preserved the Union during the Civil War, and was the 16th President."),
            .init(text: "Abraham Lincoln es famoso por muchas cosas. Nombre una.",
                  options: ["Escribió la Constitución", "Liberó a los esclavos y preservó la Unión", "Descubrió la electricidad", "Fundó el Partido Republicano"],
                  explanation: "Lincoln liberó a los esclavos con la Proclamación de Emancipación, preservó la Unión durante la Guerra Civil y fue el 16.º Presidente.")
        ]),
        UnifiedQuestion(id: "q_25_095", correctAnswer: 1, variants: [
            .init(text: "What did the Emancipation Proclamation do?",
                  options: ["Started the Civil War", "Freed the slaves in the Confederate states", "Granted women the right to vote", "Ended World War II"],
                  explanation: "President Lincoln's Emancipation Proclamation (1863) declared slaves in the Confederate states to be free."),
            .init(text: "¿Qué hizo la Proclamación de Emancipación?",
                  options: ["Inició la Guerra Civil", "Liberó a los esclavos en los estados confederados", "Otorgó a las mujeres el derecho al voto", "Puso fin a la Segunda Guerra Mundial"],
                  explanation: "La Proclamación de Emancipación del Presidente Lincoln (1863) declaró libres a los esclavos de los estados confederados.")
        ]),
        UnifiedQuestion(id: "q_25_096", correctAnswer: 2, variants: [
            .init(text: "What U.S. war ended slavery?",
                  options: ["The Revolutionary War", "The War of 1812", "The Civil War", "World War I"],
                  explanation: "The Civil War ended slavery. The 13th Amendment, ratified in 1865 after the war, formally abolished slavery throughout the United States."),
            .init(text: "¿Qué guerra de EE. UU. puso fin a la esclavitud?",
                  options: ["La Guerra de la Independencia", "La Guerra de 1812", "La Guerra Civil", "La Primera Guerra Mundial"],
                  explanation: "La Guerra Civil puso fin a la esclavitud. La 13.ª Enmienda, ratificada en 1865 después de la guerra, abolió formalmente la esclavitud en todo Estados Unidos.")
        ]),
        UnifiedQuestion(id: "q_25_098", correctAnswer: 1, variants: [
            .init(text: "When did all men get the right to vote?",
                  options: ["At the start of the country (1776)", "After the Civil War (15th Amendment, 1870)", "After World War I (1920)", "Only in 1965"],
                  explanation: "The 15th Amendment (1870), ratified after the Civil War, prohibited denying the vote based on race — extending voting rights to men of all races."),
            .init(text: "¿Cuándo obtuvieron todos los hombres el derecho al voto?",
                  options: ["Al inicio del país (1776)", "Después de la Guerra Civil (15.ª Enmienda, 1870)", "Después de la Primera Guerra Mundial (1920)", "Solo en 1965"],
                  explanation: "La 15.ª Enmienda (1870), ratificada después de la Guerra Civil, prohibió negar el voto por motivos de raza — extendiendo el derecho al voto a los hombres de todas las razas.")
        ]),
        UnifiedQuestion(id: "q_25_099", correctAnswer: 1, variants: [
            .init(text: "Name one leader of the women's rights movement in the 1800s.",
                  options: ["Eleanor Roosevelt", "Susan B. Anthony", "Hillary Clinton", "Sandra Day O'Connor"],
                  explanation: "Leaders of the 1800s women's rights movement included Susan B. Anthony, Elizabeth Cady Stanton, Sojourner Truth, Harriet Tubman, and Lucretia Mott."),
            .init(text: "Nombre a una líder del movimiento por los derechos de la mujer en el siglo XIX.",
                  options: ["Eleanor Roosevelt", "Susan B. Anthony", "Hillary Clinton", "Sandra Day O'Connor"],
                  explanation: "Entre las líderes del movimiento por los derechos de la mujer del siglo XIX se incluyen Susan B. Anthony, Elizabeth Cady Stanton, Sojourner Truth, Harriet Tubman y Lucretia Mott.")
        ]),
        UnifiedQuestion(id: "q_25_117", correctAnswer: 1, variants: [
            .init(text: "Name one American Indian tribe in the United States.",
                  options: ["The Egyptians", "Cherokee (or Navajo, Sioux, Apache, Hopi)", "The Vikings", "The Mongols"],
                  explanation: "Recognized American Indian tribes include the Cherokee, Navajo, Sioux, Apache, Hopi, Blackfeet, Choctaw, Pueblo, and many others."),
            .init(text: "Nombre una tribu indígena americana de Estados Unidos.",
                  options: ["Los egipcios", "Cherokee (o Navajo, Sioux, Apache, Hopi)", "Los vikingos", "Los mongoles"],
                  explanation: "Entre las tribus indígenas americanas reconocidas se incluyen los Cherokee, Navajo, Sioux, Apache, Hopi, Blackfeet, Choctaw, Pueblo y muchos otros.")
        ]),
        UnifiedQuestion(id: "q_25_118", correctAnswer: 1, variants: [
            .init(text: "Name one example of an American innovation.",
                  options: ["The wheel", "The airplane (or light bulb, automobile, skyscraper)", "Paper", "Pottery"],
                  explanation: "American innovations include the light bulb (Edison), the airplane (Wright Brothers), the automobile assembly line (Ford), skyscrapers, and the integrated circuit."),
            .init(text: "Nombre un ejemplo de una innovación estadounidense.",
                  options: ["La rueda", "El avión (o la bombilla, el automóvil, el rascacielos)", "El papel", "La alfarería"],
                  explanation: "Entre las innovaciones estadounidenses se incluyen la bombilla (Edison), el avión (los hermanos Wright), la cadena de montaje del automóvil (Ford), los rascacielos y el circuito integrado.")
        ]),
        UnifiedQuestion(id: "q_25_120", correctAnswer: 1, variants: [
            .init(text: "Where is the Statue of Liberty?",
                  options: ["Boston Harbor", "New York Harbor (Liberty Island)", "Chesapeake Bay", "Los Angeles"],
                  explanation: "The Statue of Liberty stands on Liberty Island in New York Harbor. It was a gift from France in 1886 and a symbol of freedom for immigrants arriving by sea."),
            .init(text: "¿Dónde está la Estatua de la Libertad?",
                  options: ["El puerto de Boston", "El puerto de Nueva York (Isla de la Libertad)", "La bahía de Chesapeake", "Los Ángeles"],
                  explanation: "La Estatua de la Libertad se encuentra en la Isla de la Libertad, en el puerto de Nueva York. Fue un regalo de Francia en 1886 y un símbolo de libertad para los inmigrantes que llegaban por mar.")
        ]),
        UnifiedQuestion(id: "q_25_126", correctAnswer: 1, variants: [
            .init(text: "Name three national U.S. holidays.",
                  options: ["Halloween, Valentine's Day, Earth Day", "Independence Day, Thanksgiving, and Christmas", "Mother's Day, Father's Day, Easter", "Black Friday, Cyber Monday, Tax Day"],
                  explanation: "U.S. national holidays include New Year's Day, MLK Jr. Day, Presidents Day, Memorial Day, Juneteenth, Independence Day, Labor Day, Columbus Day, Veterans Day, Thanksgiving, and Christmas."),
            .init(text: "Nombre tres feriados nacionales de EE. UU.",
                  options: ["Halloween, Día de San Valentín, Día de la Tierra", "Día de la Independencia, Acción de Gracias y Navidad", "Día de la Madre, Día del Padre, Pascua", "Viernes Negro, Lunes Cibernético, Día de Impuestos"],
                  explanation: "Los feriados nacionales de EE. UU. incluyen el Día de Año Nuevo, el Día de MLK Jr., el Día de los Presidentes, el Día de los Caídos, Juneteenth, el Día de la Independencia, el Día del Trabajo, el Día de Colón, el Día de los Veteranos, Acción de Gracias y Navidad.")
        ]),
        UnifiedQuestion(id: "q_25_127", correctAnswer: 2, variants: [
            .init(text: "What is Memorial Day?",
                  options: ["A holiday to honor veterans still living", "A holiday to celebrate independence", "A holiday to honor soldiers who died in military service", "A holiday for state founders"],
                  explanation: "Memorial Day (last Monday in May) honors U.S. military service members who died in service to their country."),
            .init(text: "¿Qué es el Día de los Caídos?",
                  options: ["Un feriado para honrar a los veteranos vivos", "Un feriado para celebrar la independencia", "Un feriado para honrar a los soldados que murieron en el servicio militar", "Un feriado para los fundadores de los estados"],
                  explanation: "El Día de los Caídos (último lunes de mayo) honra a los miembros de las fuerzas armadas de EE. UU. que murieron al servicio de su país.")
        ]),
        UnifiedQuestion(id: "q_25_128", correctAnswer: 1, variants: [
            .init(text: "What is Veterans Day?",
                  options: ["A holiday for active military only", "A holiday to honor people who have served in the U.S. military", "A holiday for fallen soldiers only", "A holiday for new immigrants"],
                  explanation: "Veterans Day (November 11) honors all people who have served in the U.S. military, both living and deceased."),
            .init(text: "¿Qué es el Día de los Veteranos?",
                  options: ["Un feriado solo para militares en servicio activo", "Un feriado para honrar a las personas que han servido en las fuerzas armadas de EE. UU.", "Un feriado solo para los soldados caídos", "Un feriado para los nuevos inmigrantes"],
                  explanation: "El Día de los Veteranos (11 de noviembre) honra a todas las personas que han servido en las fuerzas armadas de EE. UU., tanto vivas como fallecidas.")
        ])
    ]

    // MARK: - Practice 8: 1900s & Modern History (16 questions)
    static let practice8: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_100", correctAnswer: 1, variants: [
            .init(text: "Name one war fought by the United States in the 1900s.",
                  options: ["The Civil War", "World War II (or WWI, Korean War, Vietnam War, Persian Gulf War)", "American Revolution", "War of 1812"],
                  explanation: "U.S. wars in the 1900s include World War I, World War II, the Korean War, the Vietnam War, and the Persian Gulf War."),
            .init(text: "Nombre una guerra librada por EE. UU. en el siglo XX.",
                  options: ["La Guerra Civil", "La Segunda Guerra Mundial (o la Primera Guerra Mundial, la Guerra de Corea, la Guerra de Vietnam, la Guerra del Golfo Pérsico)", "La Revolución Americana", "La Guerra de 1812"],
                  explanation: "Las guerras de EE. UU. en el siglo XX incluyen la Primera Guerra Mundial, la Segunda Guerra Mundial, la Guerra de Corea, la Guerra de Vietnam y la Guerra del Golfo Pérsico.")
        ]),
        UnifiedQuestion(id: "q_25_101", correctAnswer: 1, variants: [
            .init(text: "Why did the United States enter World War I?",
                  options: ["To help Germany", "Because Germany attacked U.S. civilian ships (and to support the Allies)", "To gain new territory", "To stop the spread of communism"],
                  explanation: "The U.S. entered WWI in 1917 because Germany attacked U.S. civilian ships and to support the Allied Powers (England, France, Italy, and Russia)."),
            .init(text: "¿Por qué entró Estados Unidos en la Primera Guerra Mundial?",
                  options: ["Para ayudar a Alemania", "Porque Alemania atacó barcos civiles de EE. UU. (y para apoyar a los Aliados)", "Para ganar nuevos territorios", "Para detener la expansión del comunismo"],
                  explanation: "EE. UU. entró en la Primera Guerra Mundial en 1917 porque Alemania atacó barcos civiles estadounidenses y para apoyar a las Potencias Aliadas (Inglaterra, Francia, Italia y Rusia).")
        ]),
        UnifiedQuestion(id: "q_25_103", correctAnswer: 1, variants: [
            .init(text: "What was the Great Depression?",
                  options: ["A war fought in the 1930s", "The longest economic recession in modern history", "A famous government program", "A presidential election"],
                  explanation: "The Great Depression was the longest and deepest economic recession in modern history, with mass unemployment and bank failures throughout the 1930s."),
            .init(text: "¿Qué fue la Gran Depresión?",
                  options: ["Una guerra librada en los años 30", "La recesión económica más larga de la historia moderna", "Un famoso programa gubernamental", "Una elección presidencial"],
                  explanation: "La Gran Depresión fue la recesión económica más larga y profunda de la historia moderna, con desempleo masivo y quiebras bancarias durante los años 30.")
        ]),
        UnifiedQuestion(id: "q_25_104", correctAnswer: 1, variants: [
            .init(text: "When did the Great Depression start?",
                  options: ["With World War I (1917)", "With the Great Crash of 1929 (stock market crash)", "After World War II (1945)", "1933"],
                  explanation: "The Great Depression began with the stock market crash of October 1929 (the Great Crash), and lasted until the early 1940s."),
            .init(text: "¿Cuándo empezó la Gran Depresión?",
                  options: ["Con la Primera Guerra Mundial (1917)", "Con el Crac de 1929 (crisis bursátil)", "Después de la Segunda Guerra Mundial (1945)", "1933"],
                  explanation: "La Gran Depresión comenzó con el crac bursátil de octubre de 1929 (el Gran Crac) y duró hasta principios de los años 40.")
        ]),
        UnifiedQuestion(id: "q_25_105", correctAnswer: 1, variants: [
            .init(text: "Who was president during the Great Depression and World War II?",
                  options: ["Theodore Roosevelt", "Franklin D. Roosevelt (FDR)", "Harry Truman", "Herbert Hoover"],
                  explanation: "Franklin D. Roosevelt (FDR) served as President from 1933 until his death in 1945. He led the New Deal response to the Depression and led the U.S. through most of WWII."),
            .init(text: "¿Quién fue Presidente durante la Gran Depresión y la Segunda Guerra Mundial?",
                  options: ["Theodore Roosevelt", "Franklin D. Roosevelt (FDR)", "Harry Truman", "Herbert Hoover"],
                  explanation: "Franklin D. Roosevelt (FDR) fue Presidente desde 1933 hasta su muerte en 1945. Dirigió la respuesta del New Deal a la Depresión y guió a EE. UU. durante la mayor parte de la Segunda Guerra Mundial.")
        ]),
        UnifiedQuestion(id: "q_25_106", correctAnswer: 1, variants: [
            .init(text: "Why did the United States enter World War II?",
                  options: ["To help Germany", "Because Japan bombed Pearl Harbor", "To gain new colonies", "To establish trade routes"],
                  explanation: "The U.S. entered WWII after Japan attacked Pearl Harbor on December 7, 1941. The U.S. then joined the Allied Powers against the Axis Powers."),
            .init(text: "¿Por qué entró Estados Unidos en la Segunda Guerra Mundial?",
                  options: ["Para ayudar a Alemania", "Porque Japón bombardeó Pearl Harbor", "Para conseguir nuevas colonias", "Para establecer rutas comerciales"],
                  explanation: "EE. UU. entró en la Segunda Guerra Mundial después de que Japón atacara Pearl Harbor el 7 de diciembre de 1941. EE. UU. se unió entonces a las Potencias Aliadas contra las Potencias del Eje.")
        ]),
        UnifiedQuestion(id: "q_25_107", correctAnswer: 1, variants: [
            .init(text: "Dwight Eisenhower is famous for many things. Name one.",
                  options: ["Founded Microsoft", "General during World War II and 34th President", "Wrote the Constitution", "Discovered penicillin"],
                  explanation: "Eisenhower was a top general in WWII (commanded D-Day), the 34th President (1953-61), president when the Korean War ended, and signed the law creating the Interstate Highway System."),
            .init(text: "Dwight Eisenhower es famoso por muchas cosas. Nombre una.",
                  options: ["Fundó Microsoft", "General durante la Segunda Guerra Mundial y 34.º Presidente", "Escribió la Constitución", "Descubrió la penicilina"],
                  explanation: "Eisenhower fue uno de los principales generales en la Segunda Guerra Mundial (comandó el Día D), el 34.º Presidente (1953-61), Presidente cuando terminó la Guerra de Corea, y firmó la ley que creó el Sistema de Autopistas Interestatales.")
        ]),
        UnifiedQuestion(id: "q_25_108", correctAnswer: 2, variants: [
            .init(text: "Who was the United States' main rival during the Cold War?",
                  options: ["Germany", "China", "The Soviet Union (USSR)", "Japan"],
                  explanation: "The Soviet Union (USSR) was the main U.S. rival during the Cold War (1947-1991), a period of geopolitical tension without direct military conflict."),
            .init(text: "¿Quién fue el principal rival de Estados Unidos durante la Guerra Fría?",
                  options: ["Alemania", "China", "La Unión Soviética (URSS)", "Japón"],
                  explanation: "La Unión Soviética (URSS) fue el principal rival de EE. UU. durante la Guerra Fría (1947-1991), un período de tensión geopolítica sin conflicto militar directo.")
        ]),
        UnifiedQuestion(id: "q_25_109", correctAnswer: 1, variants: [
            .init(text: "During the Cold War, what was one main concern of the United States?",
                  options: ["Trade deficits", "Communism (and nuclear war)", "Immigration", "Energy independence"],
                  explanation: "Main U.S. concerns during the Cold War were the spread of communism and the threat of nuclear war between the superpowers."),
            .init(text: "Durante la Guerra Fría, ¿cuál fue una de las principales preocupaciones de EE. UU.?",
                  options: ["Los déficits comerciales", "El comunismo (y la guerra nuclear)", "La inmigración", "La independencia energética"],
                  explanation: "Las principales preocupaciones de EE. UU. durante la Guerra Fría fueron la expansión del comunismo y la amenaza de una guerra nuclear entre las superpotencias.")
        ]),
        UnifiedQuestion(id: "q_25_110", correctAnswer: 1, variants: [
            .init(text: "Why did the United States enter the Korean War?",
                  options: ["To gain Korean territory", "To stop the spread of communism", "To support the Korean monarchy", "To rescue American hostages"],
                  explanation: "The U.S. entered the Korean War (1950-53) to stop the spread of communism after North Korea (communist) invaded South Korea."),
            .init(text: "¿Por qué entró Estados Unidos en la Guerra de Corea?",
                  options: ["Para conseguir territorio coreano", "Para detener la expansión del comunismo", "Para apoyar a la monarquía coreana", "Para rescatar a rehenes estadounidenses"],
                  explanation: "EE. UU. entró en la Guerra de Corea (1950-53) para detener la expansión del comunismo después de que Corea del Norte (comunista) invadiera Corea del Sur.")
        ]),
        UnifiedQuestion(id: "q_25_111", correctAnswer: 1, variants: [
            .init(text: "Why did the United States enter the Vietnam War?",
                  options: ["To gain Vietnamese territory", "To stop the spread of communism", "To establish a U.S. naval base", "To enforce a trade agreement"],
                  explanation: "The U.S. entered the Vietnam War (1955-75) to stop the spread of communism in Southeast Asia."),
            .init(text: "¿Por qué entró Estados Unidos en la Guerra de Vietnam?",
                  options: ["Para conseguir territorio vietnamita", "Para detener la expansión del comunismo", "Para establecer una base naval de EE. UU.", "Para hacer cumplir un acuerdo comercial"],
                  explanation: "EE. UU. entró en la Guerra de Vietnam (1955-75) para detener la expansión del comunismo en el Sudeste Asiático.")
        ]),
        UnifiedQuestion(id: "q_25_112", correctAnswer: 1, variants: [
            .init(text: "What did the civil rights movement do?",
                  options: ["Won the right to vote for women", "Fought to end racial discrimination", "Brought independence from Britain", "Established Social Security"],
                  explanation: "The civil rights movement (1950s-1960s) fought to end racial discrimination and segregation. It led to the Civil Rights Act of 1964 and Voting Rights Act of 1965."),
            .init(text: "¿Qué hizo el movimiento por los derechos civiles?",
                  options: ["Ganó el derecho al voto para las mujeres", "Luchó por acabar con la discriminación racial", "Trajo la independencia de Gran Bretaña", "Estableció el Seguro Social"],
                  explanation: "El movimiento por los derechos civiles (años 50 y 60) luchó por acabar con la discriminación racial y la segregación. Condujo a la Ley de Derechos Civiles de 1964 y a la Ley de Derecho al Voto de 1965.")
        ]),
        UnifiedQuestion(id: "q_25_113", correctAnswer: 1, variants: [
            .init(text: "Martin Luther King, Jr. is famous for many things. Name one.",
                  options: ["Invented the airplane", "Fought for civil rights and equality for all Americans", "First African American President", "Wrote the Declaration of Independence"],
                  explanation: "Dr. King fought for civil rights using nonviolent methods, worked for equality, and delivered the famous \"I Have a Dream\" speech. He was awarded the Nobel Peace Prize in 1964."),
            .init(text: "Martin Luther King, Jr. es famoso por muchas cosas. Nombre una.",
                  options: ["Inventó el avión", "Luchó por los derechos civiles y la igualdad de todos los estadounidenses", "Primer Presidente afroamericano", "Escribió la Declaración de Independencia"],
                  explanation: "El Dr. King luchó por los derechos civiles usando métodos no violentos, trabajó por la igualdad y pronunció el famoso discurso «I Have a Dream». Recibió el Premio Nobel de la Paz en 1964.")
        ]),
        UnifiedQuestion(id: "q_25_114", correctAnswer: 1, variants: [
            .init(text: "Why did the United States enter the Persian Gulf War?",
                  options: ["To support Iraq", "To force the Iraqi military from Kuwait", "To establish a U.S. embassy", "To rescue American tourists"],
                  explanation: "The U.S. led an international coalition in the Persian Gulf War (1990-91) to force the Iraqi military out of Kuwait, which Iraq had invaded."),
            .init(text: "¿Por qué entró Estados Unidos en la Guerra del Golfo Pérsico?",
                  options: ["Para apoyar a Irak", "Para obligar a las fuerzas iraquíes a salir de Kuwait", "Para establecer una embajada de EE. UU.", "Para rescatar a turistas estadounidenses"],
                  explanation: "EE. UU. lideró una coalición internacional en la Guerra del Golfo Pérsico (1990-91) para obligar a las fuerzas militares iraquíes a salir de Kuwait, que Irak había invadido.")
        ]),
        UnifiedQuestion(id: "q_25_115", correctAnswer: 1, variants: [
            .init(text: "What major event happened on September 11, 2001 in the United States?",
                  options: ["A presidential election", "Terrorists attacked the United States", "A natural disaster", "A peace agreement was signed"],
                  explanation: "On 9/11, terrorists hijacked four planes, crashing two into the World Trade Center, one into the Pentagon, and one in a Pennsylvania field. Nearly 3,000 people died."),
            .init(text: "¿Qué hecho importante ocurrió el 11 de septiembre de 2001 en Estados Unidos?",
                  options: ["Una elección presidencial", "Terroristas atacaron a Estados Unidos", "Un desastre natural", "Se firmó un acuerdo de paz"],
                  explanation: "El 11-S, los terroristas secuestraron cuatro aviones, estrellando dos contra el World Trade Center, uno contra el Pentágono y uno en un campo de Pensilvania. Murieron cerca de 3.000 personas.")
        ]),
        UnifiedQuestion(id: "q_25_116", correctAnswer: 2, variants: [
            .init(text: "Name one U.S. military conflict after the September 11, 2001 attacks.",
                  options: ["The Korean War", "The Vietnam War", "The War in Afghanistan (or War in Iraq, War on Terror)", "The Civil War"],
                  explanation: "U.S. conflicts after 9/11 include the Global War on Terror, the War in Afghanistan (2001-2021), and the War in Iraq (2003-2011)."),
            .init(text: "Nombre un conflicto militar de EE. UU. posterior a los ataques del 11 de septiembre de 2001.",
                  options: ["La Guerra de Corea", "La Guerra de Vietnam", "La Guerra de Afganistán (o la Guerra de Irak, la Guerra contra el Terrorismo)", "La Guerra Civil"],
                  explanation: "Entre los conflictos de EE. UU. tras el 11-S se incluyen la Guerra Global contra el Terrorismo, la Guerra de Afganistán (2001-2021) y la Guerra de Irak (2003-2011).")
        ])
    ]
}
