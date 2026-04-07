import Foundation

/// All Spanish (English ↔ Español) quiz question sets.
/// Each question has 2 variants: [English, Spanish].
enum SpanishQuestions {

    // MARK: - Practice 1

    static let practice1: [UnifiedQuestion] = [
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What is the supreme law of the land?", options: ["The Bill of Rights", "The Declaration", "The Constitution", "The Articles"]),
            .init(text: "¿Cuál es la ley suprema del país?", options: ["La Carta de Derechos", "La Declaración", "La Constitución", "Los Artículos"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "Who makes federal laws?", options: ["The President", "Congress", "The Supreme Court", "The Military"]),
            .init(text: "¿Quién hace las leyes federales?", options: ["El Presidente", "El Congreso", "La Corte Suprema", "El Ejército"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What are the two parts of the U.S. Congress?", options: ["The Senate & The House", "The House & The President", "The Senate & The Cabinet", "The Military & The President"]),
            .init(text: "¿Cuáles son las dos partes del Congreso de los Estados Unidos?", options: ["El Senado y la Cámara de Representantes", "La Cámara de Representantes y el Presidente", "El Senado y el Gabinete", "El Ejército y el Presidente"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What is the capital of the United States?", options: ["New York", "Washington D.C.", "Los Angeles", "Chicago"]),
            .init(text: "¿Cuál es la capital de los Estados Unidos?", options: ["Nueva York", "Washington D. C.", "Los Ángeles", "Chicago"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What are the two major political parties?", options: ["Democrats & Libertarian", "Federalists & Republicans", "Libertarian & Tories", "Democrats & Republicans"]),
            .init(text: "¿Cuáles son los dos partidos políticos principales?", options: ["Demócratas y Libertarios", "Federalistas y Republicanos", "Libertarios y Conservadores", "Demócratas y Republicanos"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What color are the stars on the American flag?", options: ["Blue", "White", "Red", "Yellow"]),
            .init(text: "¿De qué color son las estrellas de la bandera estadounidense?", options: ["Azul", "Blanco", "Rojo", "Amarillo"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "How many states are there in the United States?", options: ["51", "49", "52", "50"]),
            .init(text: "¿Cuántos estados hay en los Estados Unidos?", options: ["51", "49", "52", "50"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What is the name of the President of the United States?", options: ["Joe Biden", "George Bush", "Barack Obama", "Donald J. Trump"]),
            .init(text: "¿Cómo se llama el Presidente de los Estados Unidos?", options: ["Joe Biden", "George Bush", "Barack Obama", "Donald J. Trump"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What is the name of the Vice President of the United States?", options: ["Kamala Harris", "Mike Pence", "Nancy Pelosi", "JD Vance"]),
            .init(text: "¿Cómo se llama la persona que ocupa la Vicepresidencia de los Estados Unidos?", options: ["Kamala Harris", "Mike Pence", "Nancy Pelosi", "JD Vance"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What is one right in the First Amendment?", options: ["Freedom to travel", "Right to vote", "Freedom of speech", "Right to education"]),
            .init(text: "¿Cuál es un derecho protegido por la Primera Enmienda?", options: ["Libertad de viajar", "Derecho al voto", "Libertad de expresión", "Derecho a la educación"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What do we celebrate on July 4th?", options: ["Memorial Day", "Independence Day", "Labor Day", "Thanksgiving"]),
            .init(text: "¿Qué celebramos el 4 de julio?", options: ["Día de los Caídos", "Día de la Independencia", "Día del Trabajo", "Acción de Gracias"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "Who is the Commander in Chief of the military?", options: ["The President", "The Vice President", "The Senate", "The Supreme Court"]),
            .init(text: "¿Quién es el Comandante en Jefe de las fuerzas armadas?", options: ["El Presidente", "El Vicepresidente", "El Senado", "La Corte Suprema"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What is the name of the national anthem?", options: ["This Land is Your Land", "God Bless America", "America the Beautiful", "The Star-Spangled Banner"]),
            .init(text: "¿Cómo se llama el himno nacional?", options: ["Esta tierra es tu tierra", "Dios bendiga a América", "América la Bella", "El estandarte adornado de estrellas"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What do the 13 stripes on the U.S. flag represent?", options: ["The 13 amendments", "The number of wars", "The 13 states", "The original 13 colonies"]),
            .init(text: "¿Qué representan las 13 franjas de la bandera de EE. UU.?", options: ["Las 13 enmiendas", "El número de guerras", "Los 13 estados", "Las 13 colonias originales"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What is the highest court in the United States?", options: ["The Supreme Court", "The Federal Court", "The Court of Appeals", "The Civil Court"]),
            .init(text: "¿Cuál es el tribunal más alto de los Estados Unidos?", options: ["La Corte Suprema", "El Tribunal Federal", "El Tribunal de Apelaciones", "El Tribunal Civil"])
        ])
    ]

    // MARK: - Practice 2

    static let practice2: [UnifiedQuestion] = [
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "Who wrote the Declaration of Independence?", options: ["George Washington", "Abraham Lincoln", "Benjamin Franklin", "Thomas Jefferson"]),
            .init(text: "¿Quién redactó la Declaración de Independencia?", options: ["George Washington", "Abraham Lincoln", "Benjamin Franklin", "Thomas Jefferson"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "How many U.S. Senators are there?", options: ["50", "100", "435", "200"]),
            .init(text: "¿Cuántos senadores hay en los Estados Unidos?", options: ["50", "100", "435", "200"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "How long is a term for a U.S. Senator?", options: ["4 years", "2 years", "6 years", "8 years"]),
            .init(text: "¿Cuánto dura el mandato de un senador de los Estados Unidos?", options: ["4 años", "2 años", "6 años", "8 años"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What is one responsibility of a U.S. citizen?", options: ["Vote in elections", "Own a business", "Pay for health insurance", "Travel abroad"]),
            .init(text: "¿Cuál es una responsabilidad de un ciudadano de los Estados Unidos?", options: ["Votar en las elecciones", "Tener un negocio", "Pagar un seguro médico", "Viajar al extranjero"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "Who is the Father of Our Country?", options: ["George Washington", "Thomas Jefferson", "Abraham Lincoln", "John Adams"]),
            .init(text: "¿Quién es el Padre de la Patria?", options: ["George Washington", "Thomas Jefferson", "Abraham Lincoln", "John Adams"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What is one promise you make when you become a U.S. citizen?", options: ["Speak only English", "Always vote in elections", "Get a college degree", "Obey the laws of the United States"]),
            .init(text: "¿Cuál es una promesa que hace cuando se convierte en ciudadano de los Estados Unidos?", options: ["Hablar solo inglés", "Votar siempre en las elecciones", "Obtener un título universitario", "Obedecer las leyes de los Estados Unidos"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What ocean is on the West Coast of the United States?", options: ["Atlantic Ocean", "Pacific Ocean", "Indian Ocean", "Arctic Ocean"]),
            .init(text: "¿Qué océano está en la costa oeste de los Estados Unidos?", options: ["Océano Atlántico", "Océano Pacífico", "Océano Índico", "Océano Ártico"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What is the economic system in the United States?", options: ["Socialism", "Communism", "Capitalism", "Monarchy"]),
            .init(text: "¿Cuál es el sistema económico de los Estados Unidos?", options: ["Socialismo", "Comunismo", "Capitalismo", "Monarquía"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "How many voting members are in the House of Representatives?", options: ["200", "100", "50", "435"]),
            .init(text: "¿Cuántos miembros con derecho a voto hay en la Cámara de Representantes?", options: ["200", "100", "50", "435"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What is the rule of law?", options: ["Everyone must follow the law", "The President is above the law", "Judges are above the law", "Only lawmakers follow the law"]),
            .init(text: "¿Qué es el estado de derecho?", options: ["Todos deben obedecer la ley", "El Presidente está por encima de la ley", "Los jueces están por encima de la ley", "Solo los legisladores obedecen la ley"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What is freedom of religion?", options: ["You can only practice major religions", "You must follow the government religion", "You can practice any religion, or not practice a religion", "You can never change your religion"]),
            .init(text: "¿Qué es la libertad de religión?", options: ["Solo puede practicar religiones principales", "Debe seguir la religión del gobierno", "Puede practicar cualquier religión o no practicar ninguna", "Nunca puede cambiar de religión"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What does the Constitution do?", options: ["Declares war", "Defines laws for voting", "Sets up the government", "Gives advice to the President"]),
            .init(text: "¿Qué hace la Constitución?", options: ["Declara la guerra", "Define leyes para votar", "Establece el gobierno", "Da consejos al Presidente"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What stops one branch of government from becoming too powerful?", options: ["The Supreme Court", "The military", "The people", "Checks and balances"]),
            .init(text: "¿Qué evita que una rama del gobierno se vuelva demasiado poderosa?", options: ["La Corte Suprema", "El ejército", "El pueblo", "Controles y equilibrios"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "Name one branch or part of the government.", options: ["Lawmakers", "Legislative branch (Congress)", "Governors", "The Police"]),
            .init(text: "Nombre una rama o parte del gobierno.", options: ["Legisladores", "Rama legislativa (Congreso)", "Gobernadores", "La Policía"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What is an amendment?", options: ["A change to the Constitution", "A law", "A government branch", "A tax"]),
            .init(text: "¿Qué es una enmienda?", options: ["Un cambio a la Constitución", "Una ley", "Una rama del gobierno", "Un impuesto"])
        ])
    ]

    // MARK: - Practice 3

    static let practice3: [UnifiedQuestion] = [
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What do we call the first ten amendments to the Constitution?", options: ["The Declaration of Independence", "The Bill of Rights", "The Articles of Confederation", "The Federalist Papers"]),
            .init(text: "¿Cómo llamamos a las primeras diez enmiendas de la Constitución?", options: ["La Declaración de Independencia", "La Carta de Derechos", "Los Artículos de la Confederación", "Los Documentos Federalistas"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What is the capital of your state?", options: ["Depends on your state", "New York", "Los Angeles", "Chicago"]),
            .init(text: "¿Cuál es la capital de su estado?", options: ["Depende de su estado", "Nueva York", "Los Ángeles", "Chicago"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "Who was the first President of the United States?", options: ["John Adams", "Thomas Jefferson", "George Washington", "Benjamin Franklin"]),
            .init(text: "¿Quién fue el primer Presidente de los Estados Unidos?", options: ["John Adams", "Thomas Jefferson", "George Washington", "Benjamin Franklin"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What did the Emancipation Proclamation do?", options: ["Ended the Civil War", "Freed the slaves", "Established a national bank", "Declared independence from Britain"]),
            .init(text: "¿Qué hizo la Proclamación de Emancipación?", options: ["Terminó la Guerra Civil", "Liberó a los esclavos", "Estableció un banco nacional", "Declaró la independencia de Gran Bretaña"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "Who is the Speaker of the House of Representatives now?", options: ["Nancy Pelosi", "Kevin McCarthy", "Mitch McConnell", "Mike Johnson"]),
            .init(text: "¿Quién es actualmente el Presidente de la Cámara de Representantes?", options: ["Nancy Pelosi", "Kevin McCarthy", "Mitch McConnell", "Mike Johnson"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "How many justices are on the Supreme Court?", options: ["7", "9", "11", "13"]),
            .init(text: "¿Cuántos jueces hay en la Corte Suprema?", options: ["7", "9", "11", "13"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What did Susan B. Anthony do?", options: ["Fought for women's rights", "Wrote the Constitution", "Discovered America", "Became the first female President"]),
            .init(text: "¿Qué hizo Susan B. Anthony?", options: ["Luchó por los derechos de las mujeres", "Escribió la Constitución", "Descubrió América", "Se convirtió en la primera Presidenta"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What movement tried to end racial discrimination?", options: ["The Civil Rights Movement", "The Women's Movement", "The American Revolution", "The Abolitionist Movement"]),
            .init(text: "¿Qué movimiento intentó acabar con la discriminación racial?", options: ["El Movimiento por los Derechos Civiles", "El Movimiento de Mujeres", "La Revolución Americana", "El Movimiento Abolicionista"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What was one important thing that Abraham Lincoln did?", options: ["Established the U.S. Navy", "Freed the slaves", "Fought in the Revolutionary War", "Wrote the Bill of Rights"]),
            .init(text: "¿Cuál fue una cosa importante que hizo Abraham Lincoln?", options: ["Estableció la Armada de EE. UU.", "Liberó a los esclavos", "Luchó en la Guerra de la Independencia", "Escribió la Carta de Derechos"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "Why does the U.S. flag have 50 stars?", options: ["For the 50 Presidents", "For the 50 states", "For the 50 amendments", "For the 50 years of independence"]),
            .init(text: "¿Por qué la bandera de EE. UU. tiene 50 estrellas?", options: ["Por los 50 Presidentes", "Por los 50 estados", "Por las 50 enmiendas", "Por los 50 años de independencia"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "When do we vote for President?", options: ["January", "March", "November", "December"]),
            .init(text: "¿Cuándo votamos para Presidente?", options: ["Enero", "Marzo", "Noviembre", "Diciembre"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What is one reason colonists came to America?", options: ["To escape taxes", "Religious freedom", "To join the military", "To find gold"]),
            .init(text: "¿Cuál es una razón por la que los colonos vinieron a América?", options: ["Para escapar de los impuestos", "Libertad religiosa", "Para unirse al ejército", "Para encontrar oro"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "Who wrote the Federalist Papers?", options: ["Thomas Jefferson", "James Madison, Alexander Hamilton, John Jay", "George Washington", "Ben Franklin"]),
            .init(text: "¿Quién escribió los Documentos Federalistas?", options: ["Thomas Jefferson", "James Madison, Alexander Hamilton, John Jay", "George Washington", "Ben Franklin"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "Who was the President during World War I?", options: ["Franklin D. Roosevelt", "Woodrow Wilson", "Harry Truman", "Dwight D. Eisenhower"]),
            .init(text: "¿Quién era el Presidente durante la Primera Guerra Mundial?", options: ["Franklin D. Roosevelt", "Woodrow Wilson", "Harry Truman", "Dwight D. Eisenhower"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What is one U.S. territory?", options: ["Hawaii", "Puerto Rico", "Alaska", "Canada"]),
            .init(text: "¿Cuál es un territorio de los Estados Unidos?", options: ["Hawái", "Puerto Rico", "Alaska", "Canadá"])
        ])
    ]

    // MARK: - Practice 4

    static let practice4: [UnifiedQuestion] = [
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What was the main purpose of the Federalist Papers?", options: ["To declare independence from Britain", "To promote the ratification of the U.S. Constitution", "To outline the Bill of Rights", "To establish a national bank"]),
            .init(text: "¿Cuál fue el propósito principal de los Documentos Federalistas?", options: ["Declarar la independencia de Gran Bretaña", "Promover la ratificación de la Constitución de EE. UU.", "Exponer la Carta de Derechos", "Establecer un banco nacional"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "Which amendment abolished slavery?", options: ["13th Amendment", "14th Amendment", "15th Amendment", "19th Amendment"]),
            .init(text: "¿Qué enmienda abolió la esclavitud?", options: ["13.ª Enmienda", "14.ª Enmienda", "15.ª Enmienda", "19.ª Enmienda"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What landmark case established judicial review?", options: ["Marbury v. Madison", "Brown v. Board of Education", "Roe v. Wade", "McCulloch v. Maryland"]),
            .init(text: "¿Qué caso histórico estableció la revisión judicial?", options: ["Marbury v. Madison", "Brown v. Board of Education", "Roe v. Wade", "McCulloch v. Maryland"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What is the maximum number of years a President can serve?", options: ["4 years", "8 years", "10 years", "12 years"]),
            .init(text: "¿Cuál es el número máximo de años que puede servir un Presidente?", options: ["4 años", "8 años", "10 años", "12 años"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What war was fought between the North and South in the U.S.?", options: ["Revolutionary War", "World War 1", "The Civil War", "The War of 1812"]),
            .init(text: "¿Qué guerra se libró entre el Norte y el Sur en EE. UU.?", options: ["Guerra de la Independencia", "Primera Guerra Mundial", "La Guerra Civil", "La Guerra de 1812"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What was the main reason the U.S. entered World War II?", options: ["To support Britain and France", "To stop the spread of communism", "The attack on Pearl Harbor", "To defend against Germany"]),
            .init(text: "¿Cuál fue la principal razón por la que EE. UU. entró en la Segunda Guerra Mundial?", options: ["Apoyar a Gran Bretaña y Francia", "Detener la expansión del comunismo", "El ataque a Pearl Harbor", "Defenderse de Alemania"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What did the Monroe Doctrine declare?", options: ["Europe should not interfere in the Americas", "Slavery is abolished", "The U.S. must remain neutral in global conflicts", "The Louisiana Purchase is legal"]),
            .init(text: "¿Qué declaró la Doctrina Monroe?", options: ["Europa no debe interferir en las Américas", "La esclavitud está abolida", "EE. UU. debe permanecer neutral en los conflictos globales", "La Compra de Luisiana es legal"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "Which U.S. President served more than two terms?", options: ["George Washington", "Theodore Roosevelt", "Franklin D. Roosevelt", "Dwight D. Eisenhower"]),
            .init(text: "¿Qué Presidente de EE. UU. sirvió más de dos mandatos?", options: ["George Washington", "Theodore Roosevelt", "Franklin D. Roosevelt", "Dwight D. Eisenhower"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What is the term length for a Supreme Court Justice?", options: ["4 years", "8 years", "12 years", "Life"]),
            .init(text: "¿Cuál es la duración del mandato de un juez de la Corte Suprema?", options: ["4 años", "8 años", "12 años", "De por vida"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "Who was the Chief Justice of the Supreme Court in 2023?", options: ["John G. Roberts", "Clarence Thomas", "Sonia Sotomayor", "Amy Coney Barrett"]),
            .init(text: "¿Quién era el Presidente de la Corte Suprema en 2023?", options: ["John G. Roberts", "Clarence Thomas", "Sonia Sotomayor", "Amy Coney Barrett"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "Which branch of government has the power to declare war?", options: ["The President", "The Supreme Court", "Congress", "The Vice President"]),
            .init(text: "¿Qué rama del gobierno tiene el poder de declarar la guerra?", options: ["El Presidente", "La Corte Suprema", "El Congreso", "El Vicepresidente"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What was the purpose of the Marshall Plan?", options: ["To rebuild Europe after World War 2", "To prevent communism in the U.S.", "To provide U.S. military aid", "To negotiate peace with Japan"]),
            .init(text: "¿Cuál fue el propósito del Plan Marshall?", options: ["Reconstruir Europa después de la Segunda Guerra Mundial", "Prevenir el comunismo en EE. UU.", "Proporcionar ayuda militar estadounidense", "Negociar la paz con Japón"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "Which constitutional amendment granted women the right to vote?", options: ["15th Amendment", "19th Amendment", "21st Amendment", "26th Amendment"]),
            .init(text: "¿Qué enmienda constitucional otorgó a las mujeres el derecho al voto?", options: ["15.ª Enmienda", "19.ª Enmienda", "21.ª Enmienda", "26.ª Enmienda"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "Which U.S. state was an independent republic before joining the Union?", options: ["Hawaii", "California", "Texas", "Alaska"]),
            .init(text: "¿Qué estado de EE. UU. fue una república independiente antes de unirse a la Unión?", options: ["Hawái", "California", "Texas", "Alaska"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "Who was President during the Great Depression and World War II?", options: ["Woodrow Wilson", "Herbert Hoover", "Franklin D. Roosevelt", "Harry Truman"]),
            .init(text: "¿Quién era Presidente durante la Gran Depresión y la Segunda Guerra Mundial?", options: ["Woodrow Wilson", "Herbert Hoover", "Franklin D. Roosevelt", "Harry Truman"])
        ])
    ]

    // MARK: - Practice 5

    static let practice5: [UnifiedQuestion] = [
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "The House of Representatives has how many voting members?", options: ["100", "435", "50", "200"]),
            .init(text: "¿Cuántos miembros con derecho a voto hay en la Cámara de Representantes?", options: ["100", "435", "50", "200"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "If both the President and the Vice President can no longer serve, who becomes President?", options: ["The Speaker of the House", "The Chief Justice", "The Secretary of State", "The Senate Majority Leader"]),
            .init(text: "Si el Presidente y el Vicepresidente ya no pueden servir, ¿quién se convierte en Presidente?", options: ["El Presidente de la Cámara", "El Presidente del Tribunal Supremo", "El Secretario de Estado", "El líder de la mayoría del Senado"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "Under the Constitution, some powers belong to the federal government. What is one power of the federal government?", options: ["To issue driver's licenses", "To create an army", "To set up schools", "To regulate marriages"]),
            .init(text: "Según la Constitución, algunos poderes pertenecen al gobierno federal. ¿Cuál es un poder del gobierno federal?", options: ["Expedir licencias de conducir", "Crear un ejército", "Establecer escuelas", "Regular matrimonios"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "Under our Constitution, some powers belong to the states. What is one power of the states?", options: ["To make treaties", "To create an army", "To print money", "Establish and run public schools"]),
            .init(text: "Según nuestra Constitución, algunos poderes pertenecen a los estados. ¿Cuál es un poder de los estados?", options: ["Hacer tratados", "Crear un ejército", "Imprimir dinero", "Establecer y administrar escuelas públicas"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "Who is the Commander in Chief of the military?", options: ["The President", "The Vice President", "The Secretary of Defense", "The Speaker of the House"]),
            .init(text: "¿Quién es el Comandante en Jefe de las fuerzas armadas?", options: ["El Presidente", "El Vicepresidente", "El Secretario de Defensa", "El Presidente de la Cámara"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What are two rights in the Declaration of Independence?", options: ["Right to bear arms and right to vote", "Right to work and right to protest", "Life and Liberty", "Freedom of speech and freedom of religion"]),
            .init(text: "¿Cuáles son dos derechos en la Declaración de Independencia?", options: ["Derecho a portar armas y derecho a votar", "Derecho al trabajo y derecho a protestar", "Vida y Libertad", "Libertad de expresión y libertad de religión"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What is the 'rule of law'?", options: ["The government can ignore laws", "No one is above the law", "Only federal judges follow the law", "The Constitution is not legally binding"]),
            .init(text: "¿Qué es el 'estado de derecho'?", options: ["El gobierno puede ignorar las leyes", "Nadie está por encima de la ley", "Solo los jueces federales cumplen la ley", "La Constitución no es jurídicamente vinculante"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What does the judicial branch do?", options: ["Makes laws", "Interprets the law", "Elects the President", "Controls the military"]),
            .init(text: "¿Qué hace la rama judicial?", options: ["Hace leyes", "Interpreta la ley", "Elige al Presidente", "Controla las fuerzas armadas"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "There are four amendments to the Constitution about who can vote. Describe one of them.", options: ["Only landowners can vote", "Only white men can vote", "Citizens 18 and older can vote", "Voting is mandatory"]),
            .init(text: "Hay cuatro enmiendas a la Constitución sobre quién puede votar. Describa una de ellas.", options: ["Solo los propietarios pueden votar", "Solo los hombres blancos pueden votar", "Los ciudadanos de 18 años o más pueden votar", "El voto es obligatorio"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "Why do some states have more Representatives than other states?", options: ["Because they are bigger", "Because they have more people", "Because they were part of the original 13 colonies", "Because they have more senators"]),
            .init(text: "¿Por qué algunos estados tienen más Representantes que otros?", options: ["Porque son más grandes", "Porque tienen más población", "Porque formaban parte de las 13 colonias originales", "Porque tienen más senadores"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What was the main concern of the United States during the Cold War?", options: ["Nuclear disarmament", "Terrorism", "The spread of communism", "World War 3"]),
            .init(text: "¿Cuál fue la principal preocupación de EE. UU. durante la Guerra Fría?", options: ["El desarme nuclear", "El terrorismo", "La expansión del comunismo", "Una Tercera Guerra Mundial"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What major event happened on September 11, 2001, in the United States?", options: ["The U.S. declared war on Iraq", "Terrorists attacked the United States", "The Great Recession began", "Hurricane Katrina struck"]),
            .init(text: "¿Qué hecho importante ocurrió el 11 de septiembre de 2001 en los Estados Unidos?", options: ["EE. UU. declaró la guerra a Irak", "Terroristas atacaron los Estados Unidos", "Comenzó la Gran Recesión", "El huracán Katrina golpeó"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What are two rights of everyone living in the United States?", options: ["Right to vote & right to work", "Freedom of speech & freedom of religion", "Right to own land & right to healthcare", "Right to drive & right to a free education"]),
            .init(text: "¿Cuáles son dos derechos de todas las personas que viven en los Estados Unidos?", options: ["Derecho a votar y derecho a trabajar", "Libertad de expresión y libertad de religión", "Derecho a poseer tierras y derecho a la atención médica", "Derecho a conducir y derecho a una educación gratuita"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What did the Civil Rights Movement do?", options: ["Fought for women's rights", "Fought for workers' rights", "Fought for U.S. independence", "Fought for the end of segregation and racial discrimination"]),
            .init(text: "¿Qué hizo el Movimiento por los Derechos Civiles?", options: ["Luchó por los derechos de las mujeres", "Luchó por los derechos de los trabajadores", "Luchó por la independencia de EE. UU.", "Luchó por el fin de la segregación y la discriminación racial"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What is one promise you make when you become a U.S. citizen?", options: ["To always vote", "To support your birth country", "To obey U.S. laws", "To join the U.S. military"]),
            .init(text: "¿Cuál es una promesa que hace cuando se convierte en ciudadano de EE. UU.?", options: ["Votar siempre", "Apoyar a su país de nacimiento", "Obedecer las leyes de EE. UU.", "Unirse a las fuerzas armadas de EE. UU."])
        ])
    ]
}
