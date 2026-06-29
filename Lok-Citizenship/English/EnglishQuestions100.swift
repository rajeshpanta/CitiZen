
/// All English quiz question sets — the 100 official 2008 USCIS naturalization
/// civics questions, organized into 10 interview-style practice sets of exactly
/// 10 questions each. IDs use the `q_08_NNN` prefix to keep QuestionTracker
/// records fully separate from the 128-question `q_25_NNN` set.
///
/// Each set mirrors the real USCIS interview format: 10 questions, 6 correct
/// required to pass. Questions are thematically grouped so users can target
/// specific topic areas, and the set order matches the real interview's
/// question numbering (Q1–Q100).
///
/// State-specific questions (senator, representative, governor, state capital)
/// use "Answers will vary — research your state" as the accepted answer,
/// which is how USCIS handles them in practice.
enum EnglishQuestions100 {

    // MARK: - Practice Set 1: Principles of Democracy (Q1–Q10)
    static let practice1: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_001", correctAnswer: 2, variants: [
            .init(text: "What is the supreme law of the land?",
                  options: ["The Declaration of Independence", "The Bill of Rights", "The Constitution", "The Federalist Papers"],
                  explanation: "The Constitution is the supreme law of the United States. All other laws must be consistent with it.")
        ]),
        UnifiedQuestion(id: "q_08_002", correctAnswer: 1, variants: [
            .init(text: "What does the Constitution do?",
                  options: ["Establishes the U.S. military", "Sets up the government and protects basic rights of Americans", "Lists every federal law", "Declares independence from Britain"],
                  explanation: "The Constitution defines the structure of the U.S. government and protects the basic rights of all Americans.")
        ]),
        UnifiedQuestion(id: "q_08_003", correctAnswer: 1, variants: [
            .init(text: "The idea of self-government is in the first three words of the Constitution. What are these words?",
                  options: ["Life and Liberty", "We the People", "Equal Justice Under Law", "In God We Trust"],
                  explanation: "'We the People' opens the Preamble, establishing that all government authority comes from the citizens.")
        ]),
        UnifiedQuestion(id: "q_08_004", correctAnswer: 2, variants: [
            .init(text: "What is an amendment?",
                  options: ["A federal court ruling", "A presidential executive order", "A change or addition to the Constitution", "A temporary law passed by Congress"],
                  explanation: "An amendment is a formal change or addition to the Constitution. The amendment process requires approval by two-thirds of Congress and three-fourths of states.")
        ]),
        UnifiedQuestion(id: "q_08_005", correctAnswer: 3, variants: [
            .init(text: "What do we call the first ten amendments to the Constitution?",
                  options: ["The Federalist Papers", "The Articles of Confederation", "The Declaration of Rights", "The Bill of Rights"],
                  explanation: "The first ten amendments are the Bill of Rights, ratified in 1791. They guarantee fundamental individual freedoms such as speech, religion, and fair trial.")
        ]),
        UnifiedQuestion(id: "q_08_006", correctAnswer: 1, variants: [
            .init(text: "What is one right or freedom from the First Amendment?",
                  options: ["Right to bear arms", "Freedom of speech", "Right to vote", "Right to a trial by jury"],
                  explanation: "The First Amendment protects five freedoms: religion, speech, press, assembly, and the right to petition the government.")
        ]),
        UnifiedQuestion(id: "q_08_007", correctAnswer: 2, variants: [
            .init(text: "How many amendments does the Constitution have?",
                  options: ["10", "21", "27", "33"],
                  explanation: "The Constitution has been amended 27 times. The first 10 (the Bill of Rights) were ratified in 1791; the most recent (27th) was ratified in 1992.")
        ]),
        UnifiedQuestion(id: "q_08_008", correctAnswer: 1, variants: [
            .init(text: "What did the Declaration of Independence do?",
                  options: ["Created the U.S. Constitution", "Announced and declared our independence from Great Britain", "Established the Bill of Rights", "Set up the three branches of government"],
                  explanation: "The Declaration of Independence, adopted July 4, 1776, formally announced separation from British rule and stated the principles of liberty and equality.")
        ]),
        UnifiedQuestion(id: "q_08_009", correctAnswer: 1, variants: [
            .init(text: "What are two rights in the Declaration of Independence?",
                  options: ["Free speech and religion", "Life and liberty (or pursuit of happiness)", "Right to vote and bear arms", "Trial by jury and free press"],
                  explanation: "USCIS accepts any two of: life / liberty / pursuit of happiness. The Declaration states these as 'unalienable rights' — the most famous words in American founding history.")
        ]),
        UnifiedQuestion(id: "q_08_010", correctAnswer: 2, variants: [
            .init(text: "What is freedom of religion?",
                  options: ["The government selects an official religion for all citizens", "You may only practice one of several approved religions", "You can practice any religion, or not practice a religion", "Religious leaders help run the government"],
                  explanation: "Freedom of religion means you can practice any faith — or no faith — without any government interference. This was a core reason many colonists came to America.")
        ])
    ]

    // MARK: - Practice Set 2: Foundations of Government (Q11–Q20)
    static let practice2: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_011", correctAnswer: 1, variants: [
            .init(text: "What is the economic system in the United States?",
                  options: ["Socialist economy", "Capitalist economy / market economy", "Communist economy", "Mixed feudal economy"],
                  explanation: "The United States has a capitalist, free market economy where businesses and prices are largely driven by supply, demand, and private ownership.")
        ]),
        UnifiedQuestion(id: "q_08_012", correctAnswer: 2, variants: [
            .init(text: "What is the 'rule of law'?",
                  options: ["Kings and rulers make all the laws", "Only criminals must follow the law", "Everyone must follow the law, including government leaders", "Laws apply only to citizens, not visitors"],
                  explanation: "Under the rule of law, everyone — including the President and Congress — must obey the same laws. No one is above the law.")
        ]),
        UnifiedQuestion(id: "q_08_013", correctAnswer: 1, variants: [
            .init(text: "Name one branch or part of the government.",
                  options: ["The Army", "Congress (legislative branch)", "The FBI", "The Department of the Treasury"],
                  explanation: "The three branches are: Legislative (Congress — makes laws), Executive (President — enforces laws), and Judicial (courts — interprets laws).")
        ]),
        UnifiedQuestion(id: "q_08_014", correctAnswer: 1, variants: [
            .init(text: "What stops one branch of government from becoming too powerful?",
                  options: ["Popular vote", "Checks and balances / separation of powers", "The military", "State governments"],
                  explanation: "Checks and balances allow each branch to limit the others. For example, Congress makes laws, the President can veto them, and the courts can strike them down if unconstitutional.")
        ]),
        UnifiedQuestion(id: "q_08_015", correctAnswer: 2, variants: [
            .init(text: "Who is in charge of the executive branch?",
                  options: ["The Speaker of the House", "The Chief Justice of the Supreme Court", "The President", "The Secretary of State"],
                  explanation: "The President leads the executive branch, which carries out and enforces laws passed by Congress.")
        ]),
        UnifiedQuestion(id: "q_08_016", correctAnswer: 2, variants: [
            .init(text: "Who makes federal laws?",
                  options: ["The President", "The Supreme Court", "Congress (Senate and House of Representatives)", "State governors"],
                  explanation: "Congress — the legislative branch made up of the Senate and House of Representatives — is the federal lawmaking body.")
        ]),
        UnifiedQuestion(id: "q_08_017", correctAnswer: 1, variants: [
            .init(text: "What are the two parts of the U.S. Congress?",
                  options: ["The President and Vice President", "The Senate and House of Representatives", "The Supreme Court and Congress", "The Democratic and Republican parties"],
                  explanation: "Congress is bicameral: the Senate (100 members, 2 per state) and the House of Representatives (435 members, apportioned by population).")
        ]),
        UnifiedQuestion(id: "q_08_018", correctAnswer: 1, variants: [
            .init(text: "How many U.S. Senators are there?",
                  options: ["50", "100", "435", "535"],
                  explanation: "There are 100 U.S. Senators — exactly two from each of the 50 states, regardless of the state's population.")
        ]),
        UnifiedQuestion(id: "q_08_019", correctAnswer: 2, variants: [
            .init(text: "We elect a U.S. Senator for how many years?",
                  options: ["2 years", "4 years", "6 years", "8 years"],
                  explanation: "U.S. Senators serve 6-year terms. Elections are staggered so roughly one-third of Senate seats are contested every two years.")
        ]),
        UnifiedQuestion(id: "q_08_020", correctAnswer: 0, variants: [
            .init(text: "Who is one of your state's U.S. Senators now?",
                  options: ["Answers will vary — research your state", "Elizabeth Warren", "Marco Rubio", "Mitch McConnell"],
                  explanation: "U.S. Senators represent their state. The correct answer depends on which state you live in. Look up your two current senators at senate.gov before your interview.")
        ])
    ]

    // MARK: - Practice Set 3: Congress & Elections (Q21–Q30)
    static let practice3: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_021", correctAnswer: 2, variants: [
            .init(text: "The House of Representatives has how many voting members?",
                  options: ["100", "270", "435", "538"],
                  explanation: "The House has 435 voting members. The number from each state is based on population as counted by the census every 10 years.")
        ]),
        UnifiedQuestion(id: "q_08_022", correctAnswer: 0, variants: [
            .init(text: "We elect a U.S. Representative for how many years?",
                  options: ["2 years", "4 years", "6 years", "8 years"],
                  explanation: "U.S. Representatives serve 2-year terms. Because they must run every two years, all 435 House seats are on the ballot in every election cycle.")
        ]),
        UnifiedQuestion(id: "q_08_023", correctAnswer: 0, variants: [
            .init(text: "Name your U.S. Representative.",
                  options: ["Answers will vary — research your district", "Nancy Pelosi", "Kevin McCarthy", "Hakeem Jeffries"],
                  explanation: "Your U.S. Representative represents your specific congressional district. Look up your representative at house.gov before your interview.")
        ]),
        UnifiedQuestion(id: "q_08_024", correctAnswer: 1, variants: [
            .init(text: "Who does a U.S. Senator represent?",
                  options: ["Only the voters who elected them", "All the people of their state", "Their political party's supporters", "The federal government"],
                  explanation: "Each U.S. Senator represents ALL residents of their state — not just those who voted for them or belong to their party.")
        ]),
        UnifiedQuestion(id: "q_08_025", correctAnswer: 2, variants: [
            .init(text: "Why do some states have more Representatives than other states?",
                  options: ["Because of the state's geographic size", "Because of the state's wealth and tax revenue", "Because of the state's population", "Because of how long the state has been in the Union"],
                  explanation: "House seats are apportioned by population. California, the most populous state, has the most Representatives; states like Wyoming have just one.")
        ]),
        UnifiedQuestion(id: "q_08_026", correctAnswer: 2, variants: [
            .init(text: "We elect a President for how many years?",
                  options: ["2 years", "3 years", "4 years", "6 years"],
                  explanation: "The President serves a 4-year term. The 22nd Amendment (1951) limits the President to two terms (maximum 8 years) in office.")
        ]),
        UnifiedQuestion(id: "q_08_027", correctAnswer: 2, variants: [
            .init(text: "In what month do we vote for President?",
                  options: ["September", "October", "November", "December"],
                  explanation: "Presidential elections are held on the first Tuesday after the first Monday in November every four years. In 2024, the election was November 5.")
        ]),
        UnifiedQuestion(id: "q_08_028", correctAnswer: 2, variants: [
            .init(text: "What is the name of the President of the United States now?",
                  options: ["Joe Biden", "Barack Obama", "Donald Trump", "Kamala Harris"],
                  explanation: "Donald Trump is the 47th President of the United States, having taken office in January 2025 for his second term.")
        ]),
        UnifiedQuestion(id: "q_08_029", correctAnswer: 2, variants: [
            .init(text: "What is the name of the Vice President of the United States now?",
                  options: ["Kamala Harris", "Mike Pence", "JD Vance", "Tim Walz"],
                  explanation: "JD Vance is the 50th Vice President of the United States, serving alongside President Trump since January 2025.")
        ]),
        UnifiedQuestion(id: "q_08_030", correctAnswer: 3, variants: [
            .init(text: "If the President can no longer serve, who becomes President?",
                  options: ["The Speaker of the House", "The Chief Justice", "The Secretary of State", "The Vice President"],
                  explanation: "The Vice President becomes President if the President is unable to serve, per the 25th Amendment (1967).")
        ])
    ]

    // MARK: - Practice Set 4: Executive Branch & Judicial Branch (Q31–Q40)
    static let practice4: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_031", correctAnswer: 1, variants: [
            .init(text: "If both the President and the Vice President can no longer serve, who becomes President?",
                  options: ["The Secretary of State", "The Speaker of the House", "The President pro tempore of the Senate", "The Chief Justice of the Supreme Court"],
                  explanation: "By the Presidential Succession Act, the Speaker of the House is third in the line of succession, after the Vice President.")
        ]),
        UnifiedQuestion(id: "q_08_032", correctAnswer: 2, variants: [
            .init(text: "Who is the Commander in Chief of the military?",
                  options: ["The Secretary of Defense", "A four-star general", "The President", "The Chairman of the Joint Chiefs of Staff"],
                  explanation: "The President serves as Commander in Chief of all U.S. armed forces, ensuring civilian control of the military — a key democratic principle.")
        ]),
        UnifiedQuestion(id: "q_08_033", correctAnswer: 2, variants: [
            .init(text: "Who signs bills to become laws?",
                  options: ["The Speaker of the House", "The Vice President", "The President", "The Chief Justice"],
                  explanation: "After Congress passes a bill, it goes to the President. If signed, it becomes law. If the President vetoes it, Congress can attempt to override with a two-thirds majority.")
        ]),
        UnifiedQuestion(id: "q_08_034", correctAnswer: 3, variants: [
            .init(text: "Who vetoes bills?",
                  options: ["The Senate Majority Leader", "The Supreme Court", "The Speaker of the House", "The President"],
                  explanation: "The President can veto (reject) legislation passed by Congress. Congress may override a veto with a two-thirds vote in both the Senate and House.")
        ]),
        UnifiedQuestion(id: "q_08_035", correctAnswer: 1, variants: [
            .init(text: "What does the President's Cabinet do?",
                  options: ["Makes federal laws", "Advises the President", "Elects the Vice President", "Oversees the Supreme Court"],
                  explanation: "The Cabinet is made up of the heads of 15 executive departments (like State, Defense, Treasury) who advise the President on major policy decisions.")
        ]),
        UnifiedQuestion(id: "q_08_036", correctAnswer: 2, variants: [
            .init(text: "What are two Cabinet-level positions?",
                  options: ["Senator and Representative", "Governor and Mayor", "Secretary of State and Secretary of Defense", "Chief Justice and Speaker of the House"],
                  explanation: "Cabinet positions include the Vice President and 15 department heads such as Secretary of State, Defense, Treasury, and the Attorney General. (Chief Justice and Speaker of the House lead judicial/legislative branches — not Cabinet.)")
        ]),
        UnifiedQuestion(id: "q_08_037", correctAnswer: 3, variants: [
            .init(text: "What does the judicial branch do?",
                  options: ["Makes federal laws", "Enforces laws and manages the military", "Collects taxes and prints money", "Reviews laws and decides if they are constitutional"],
                  explanation: "The judicial branch interprets laws, resolves legal disputes, and — crucially — determines whether laws are consistent with the Constitution.")
        ]),
        UnifiedQuestion(id: "q_08_038", correctAnswer: 3, variants: [
            .init(text: "What is the highest court in the United States?",
                  options: ["The Federal Appeals Court", "The State Supreme Court", "The Federal District Court", "The Supreme Court"],
                  explanation: "The U.S. Supreme Court is the highest court in the land. Its decisions are final and binding on all lower courts throughout the country.")
        ]),
        UnifiedQuestion(id: "q_08_039", correctAnswer: 1, variants: [
            .init(text: "How many justices are on the Supreme Court?",
                  options: ["7", "9", "11", "13"],
                  explanation: "The Supreme Court has 9 justices: one Chief Justice and eight Associate Justices. This number has been set by law since 1869.")
        ]),
        UnifiedQuestion(id: "q_08_040", correctAnswer: 2, variants: [
            .init(text: "Who is the Chief Justice of the United States now?",
                  options: ["Sonia Sotomayor", "Clarence Thomas", "John Roberts", "Elena Kagan"],
                  explanation: "John G. Roberts Jr. has served as Chief Justice of the United States since 2005, appointed by President George W. Bush.")
        ])
    ]

    // MARK: - Practice Set 5: Federal & State Powers, Political Parties (Q41–Q50)
    static let practice5: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_041", correctAnswer: 2, variants: [
            .init(text: "Under our Constitution, some powers belong to the federal government. What is one power of the federal government?",
                  options: ["Issue driver's licenses", "Set local zoning laws", "To print money", "Provide fire protection"],
                  explanation: "Exclusive federal powers include printing money, declaring war, creating an army, and making treaties with other countries.")
        ]),
        UnifiedQuestion(id: "q_08_042", correctAnswer: 3, variants: [
            .init(text: "Under our Constitution, some powers belong to the states. What is one power of the states?",
                  options: ["Declare war", "Print money", "Make treaties with foreign nations", "Provide schooling and education"],
                  explanation: "State powers include providing education, police protection, fire departments, driver's licenses, and zoning/land use decisions.")
        ]),
        UnifiedQuestion(id: "q_08_043", correctAnswer: 0, variants: [
            .init(text: "Who is the Governor of your state now?",
                  options: ["Answers will vary — research your state", "Ron DeSantis", "Gavin Newsom", "Greg Abbott"],
                  explanation: "The Governor is the chief executive of a state. Look up your current Governor before your interview — USCIS will ask about YOUR state.")
        ]),
        UnifiedQuestion(id: "q_08_044", correctAnswer: 0, variants: [
            .init(text: "What is the capital of your state?",
                  options: ["Answers will vary — research your state", "New York City", "Los Angeles", "Chicago"],
                  explanation: "Each state has its own capital city. Note: state capitals are often NOT the largest cities (e.g., Albany is NY's capital, not New York City).")
        ]),
        UnifiedQuestion(id: "q_08_045", correctAnswer: 2, variants: [
            .init(text: "What are the two major political parties in the United States?",
                  options: ["Liberal and Conservative", "Federalist and Democratic-Republican", "Democratic and Republican", "Independent and Green"],
                  explanation: "The Democratic Party and Republican Party are the two dominant parties in U.S. politics, though other parties (Libertarian, Green, etc.) also exist.")
        ]),
        UnifiedQuestion(id: "q_08_046", correctAnswer: 1, variants: [
            .init(text: "What is the political party of the President now?",
                  options: ["Democratic Party", "Republican Party", "Independent", "Libertarian Party"],
                  explanation: "Donald Trump, the current President, is a member of the Republican Party.")
        ]),
        UnifiedQuestion(id: "q_08_047", correctAnswer: 2, variants: [
            .init(text: "What is the name of the Speaker of the House of Representatives now?",
                  options: ["Kevin McCarthy", "Nancy Pelosi", "Mike Johnson", "Hakeem Jeffries"],
                  explanation: "Mike Johnson of Louisiana has served as Speaker of the House since October 2023. The Speaker is third in the line of presidential succession.")
        ]),
        UnifiedQuestion(id: "q_08_048", correctAnswer: 1, variants: [
            .init(text: "There are four amendments to the Constitution about who can vote. Describe one of them.",
                  options: ["All people age 16 and older can vote", "Citizens eighteen (18) and older can vote", "Only property owners can vote", "Only taxpayers can vote"],
                  explanation: "Four voting amendments: 15th (1870, race), 19th (1920, women), 24th (1964, no poll tax), and 26th (1971, age 18+).")
        ]),
        UnifiedQuestion(id: "q_08_049", correctAnswer: 2, variants: [
            .init(text: "What is one responsibility that is only for United States citizens?",
                  options: ["Pay taxes", "Follow federal and state laws", "Serve on a jury", "Obey local ordinances"],
                  explanation: "Serving on a jury and voting in federal elections are civic responsibilities reserved exclusively for U.S. citizens. All residents must pay taxes and follow the law.")
        ]),
        UnifiedQuestion(id: "q_08_050", correctAnswer: 2, variants: [
            .init(text: "Name one right only for United States citizens.",
                  options: ["Freedom of speech", "Right to a fair trial", "Vote in a federal election", "Freedom of religion"],
                  explanation: "Only U.S. citizens may vote in federal elections and run for federal office. Rights like free speech, fair trial, and religious freedom extend to everyone in the U.S.")
        ])
    ]

    // MARK: - Practice Set 6: Rights & Civic Responsibilities (Q51–Q60)
    static let practice6: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_051", correctAnswer: 1, variants: [
            .init(text: "What are two rights of everyone living in the United States?",
                  options: ["Right to vote and run for federal office", "Freedom of speech and freedom of religion", "Free government housing and employment", "The right to bear arms and vote in local elections"],
                  explanation: "Everyone in the U.S. — citizens and non-citizens — has rights including freedom of expression, speech, assembly, petition, religion, and the right to bear arms.")
        ]),
        UnifiedQuestion(id: "q_08_052", correctAnswer: 2, variants: [
            .init(text: "What do we show loyalty to when we say the Pledge of Allegiance?",
                  options: ["The President of the United States", "The U.S. Constitution and the courts", "The United States and the flag", "The military and veterans"],
                  explanation: "The Pledge of Allegiance is a declaration of loyalty to the United States and to its flag — the national symbol — pledging allegiance to 'one nation, under God, indivisible.'")
        ]),
        UnifiedQuestion(id: "q_08_053", correctAnswer: 1, variants: [
            .init(text: "What is one promise you make when you become a United States citizen?",
                  options: ["Never leave the United States", "Give up loyalty to other countries", "Always vote in every election", "Pay an extra citizenship tax"],
                  explanation: "The Oath of Allegiance includes: giving up loyalty to foreign nations, defending the Constitution, obeying U.S. laws, and serving the country if needed.")
        ]),
        UnifiedQuestion(id: "q_08_054", correctAnswer: 2, variants: [
            .init(text: "How old do citizens have to be to vote for President?",
                  options: ["16 and older", "21 and older", "18 and older", "25 and older"],
                  explanation: "The 26th Amendment (1971) set the minimum voting age at 18 for all U.S. elections, including presidential elections.")
        ]),
        UnifiedQuestion(id: "q_08_055", correctAnswer: 1, variants: [
            .init(text: "What are two ways that Americans can participate in their democracy?",
                  options: ["Pay taxes and read the news", "Vote and join a civic group", "Work for the government and serve in the military", "Study history and learn English"],
                  explanation: "Americans can participate by voting, joining political parties, running for office, joining civic groups, contacting elected officials, writing to newspapers, and more.")
        ]),
        UnifiedQuestion(id: "q_08_056", correctAnswer: 2, variants: [
            .init(text: "When is the last day you can send in federal income tax forms?",
                  options: ["January 31", "March 15", "April 15", "June 30"],
                  explanation: "Federal income tax returns (Form 1040) are due on April 15 each year. You can file for an automatic extension, but any taxes owed are still due by April 15.")
        ]),
        UnifiedQuestion(id: "q_08_057", correctAnswer: 2, variants: [
            .init(text: "When must all men register for the Selective Service?",
                  options: ["At age 16", "At age 21", "At age 18 (between 18 and 26)", "Only during wartime when required"],
                  explanation: "All male U.S. residents (citizens and most non-citizens) must register with the Selective Service System within 30 days of turning 18, and by age 26.")
        ]),
        UnifiedQuestion(id: "q_08_058", correctAnswer: 2, variants: [
            .init(text: "What is one reason colonists came to America?",
                  options: ["To find gold and return to Europe", "To trade exclusively with Native Americans", "For religious freedom and political liberty", "To establish a European monarchy in the New World"],
                  explanation: "Colonists came for religious freedom, political liberty, economic opportunity, and to escape persecution in Europe. Many sought a fresh start.")
        ]),
        UnifiedQuestion(id: "q_08_059", correctAnswer: 2, variants: [
            .init(text: "Who lived in America before the Europeans arrived?",
                  options: ["Spanish explorers", "Settlers from Africa", "American Indians (Native Americans)", "Settlers from Asia"],
                  explanation: "American Indians (Native Americans) lived in North America for thousands of years before European colonization began in the late 1400s and 1500s.")
        ]),
        UnifiedQuestion(id: "q_08_060", correctAnswer: 3, variants: [
            .init(text: "What group of people was taken to America and sold as slaves?",
                  options: ["People from Asia", "People from Europe", "People from South America", "People from Africa"],
                  explanation: "Millions of Africans were forcibly brought to America from the 16th through 19th centuries and sold into slavery — one of the greatest injustices in history.")
        ])
    ]

    // MARK: - Practice Set 7: Colonial History & Independence (Q61–Q70)
    static let practice7: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_061", correctAnswer: 2, variants: [
            .init(text: "Why did the colonists fight the British?",
                  options: ["To gain more land in the Western territories", "They wanted to become part of Canada", "Because of high taxes and no self-government (taxation without representation)", "To protect themselves from Native American raids"],
                  explanation: "Key causes of the Revolution: taxation without representation, British troops quartered in colonists' homes, and colonists having no vote in British Parliament.")
        ]),
        UnifiedQuestion(id: "q_08_062", correctAnswer: 2, variants: [
            .init(text: "Who wrote the Declaration of Independence?",
                  options: ["George Washington", "Benjamin Franklin", "Thomas Jefferson", "John Adams"],
                  explanation: "Thomas Jefferson was the principal author of the Declaration of Independence, adopted July 4, 1776. A committee including Franklin and Adams helped revise it.")
        ]),
        UnifiedQuestion(id: "q_08_063", correctAnswer: 0, variants: [
            .init(text: "When was the Declaration of Independence adopted?",
                  options: ["July 4, 1776", "September 17, 1787", "April 19, 1775", "March 4, 1789"],
                  explanation: "July 4, 1776 — now celebrated as Independence Day — is when the Continental Congress formally adopted the Declaration of Independence.")
        ]),
        UnifiedQuestion(id: "q_08_064", correctAnswer: 2, variants: [
            .init(text: "There were 13 original states. Name three.",
                  options: ["Florida, Texas, and California", "Maine, Michigan, and Ohio", "Virginia, Pennsylvania, and New York", "Arizona, Nevada, and Utah"],
                  explanation: "The 13 original states: NH, MA, RI, CT, NY, NJ, PA, DE, MD, VA, NC, SC, and GA — all former British colonies that declared independence in 1776.")
        ]),
        UnifiedQuestion(id: "q_08_065", correctAnswer: 2, variants: [
            .init(text: "What happened at the Constitutional Convention?",
                  options: ["The Declaration of Independence was signed", "The Civil War ended", "The Constitution was written", "Slavery was abolished throughout the country"],
                  explanation: "The Constitutional Convention met in Philadelphia in 1787 where the Founding Fathers drafted the U.S. Constitution to replace the weak Articles of Confederation.")
        ]),
        UnifiedQuestion(id: "q_08_066", correctAnswer: 2, variants: [
            .init(text: "When was the Constitution written?",
                  options: ["1776", "1781", "1787", "1791"],
                  explanation: "The Constitution was written at the Constitutional Convention in Philadelphia in 1787 and ratified by the required nine states in 1788.")
        ]),
        UnifiedQuestion(id: "q_08_067", correctAnswer: 2, variants: [
            .init(text: "The Federalist Papers supported the passage of the U.S. Constitution. Name one of the writers.",
                  options: ["Thomas Jefferson", "John Adams", "Hamilton, Madison, or Jay (Publius)", "Benjamin Franklin"],
                  explanation: "The Federalist Papers were written by Alexander Hamilton, James Madison, and John Jay under the shared pen name 'Publius.' USCIS accepts any of their names, or 'Publius.'")
        ]),
        UnifiedQuestion(id: "q_08_068", correctAnswer: 2, variants: [
            .init(text: "What is one thing Benjamin Franklin is famous for?",
                  options: ["Writing the Declaration of Independence", "Being the first President of the United States", "Being the first U.S. Postmaster General", "Leading the Union Army during the Civil War"],
                  explanation: "Benjamin Franklin was a diplomat, inventor (lightning rod, bifocals), writer (Poor Richard's Almanac), and the first Postmaster General. He was also the oldest delegate at the Constitutional Convention.")
        ]),
        UnifiedQuestion(id: "q_08_069", correctAnswer: 3, variants: [
            .init(text: "Who is the 'Father of Our Country'?",
                  options: ["Benjamin Franklin", "Thomas Jefferson", "John Adams", "George Washington"],
                  explanation: "George Washington is called the 'Father of Our Country' for commanding the Continental Army to victory in the Revolution and serving as the nation's first President.")
        ]),
        UnifiedQuestion(id: "q_08_070", correctAnswer: 3, variants: [
            .init(text: "Who was the first President?",
                  options: ["John Adams", "Thomas Jefferson", "Benjamin Franklin", "George Washington"],
                  explanation: "George Washington became the first President of the United States in 1789 and served two terms until 1797, setting important precedents for the office.")
        ])
    ]

    // MARK: - Practice Set 8: The 1800s & Civil War (Q71–Q80)
    static let practice8: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_071", correctAnswer: 3, variants: [
            .init(text: "What territory did the United States buy from France in 1803?",
                  options: ["Texas Territory", "Florida Territory", "Alaska Territory", "The Louisiana Territory"],
                  explanation: "The Louisiana Purchase (1803) nearly doubled the size of the U.S. — about 828,000 square miles purchased from Napoleon's France for approximately $15 million.")
        ]),
        UnifiedQuestion(id: "q_08_072", correctAnswer: 2, variants: [
            .init(text: "Name one war fought by the United States in the 1800s.",
                  options: ["World War I", "Korean War", "The Civil War", "Vietnam War"],
                  explanation: "U.S. wars in the 1800s: War of 1812, Mexican-American War (1846–48), Civil War (1861–65), and Spanish-American War (1898).")
        ]),
        UnifiedQuestion(id: "q_08_073", correctAnswer: 2, variants: [
            .init(text: "Name the U.S. war between the North and the South.",
                  options: ["The Revolutionary War", "The War of 1812", "The Civil War", "The Spanish-American War"],
                  explanation: "The Civil War (1861–1865) was fought between the Northern states (Union) and Southern states (Confederacy) primarily over slavery, states' rights, and economic differences.")
        ]),
        UnifiedQuestion(id: "q_08_074", correctAnswer: 2, variants: [
            .init(text: "Name one problem that led to the Civil War.",
                  options: ["A dispute solely about tariffs", "A foreign invasion of U.S. territory", "Slavery", "A conflict over the Constitution's legality"],
                  explanation: "The Civil War's causes included slavery, economic differences between the industrialized North and agricultural South, and fierce debates over states' rights.")
        ]),
        UnifiedQuestion(id: "q_08_075", correctAnswer: 2, variants: [
            .init(text: "What was one important thing that Abraham Lincoln did?",
                  options: ["Wrote the U.S. Constitution", "Won the Spanish-American War", "Freed the slaves (Emancipation Proclamation)", "Purchased Alaska from Russia"],
                  explanation: "Lincoln issued the Emancipation Proclamation (1863), freeing enslaved people in Confederate states. He also preserved the Union and led the U.S. through the Civil War.")
        ]),
        UnifiedQuestion(id: "q_08_076", correctAnswer: 2, variants: [
            .init(text: "What did the Emancipation Proclamation do?",
                  options: ["Officially ended the Civil War", "Gave women the right to vote", "Freed the slaves in Confederate states", "Created the Republican Party"],
                  explanation: "The Emancipation Proclamation (January 1, 1863) declared all enslaved people in Confederate states to be free, transforming the war into a fight to end slavery.")
        ]),
        UnifiedQuestion(id: "q_08_077", correctAnswer: 3, variants: [
            .init(text: "What did Susan B. Anthony do?",
                  options: ["Led the Underground Railroad to free enslaved people", "Wrote the Emancipation Proclamation", "Was the first woman elected to the U.S. Congress", "Fought for women's rights and civil rights"],
                  explanation: "Susan B. Anthony was a leading suffragist who campaigned tirelessly for women's right to vote. The 19th Amendment (1920) is sometimes called the 'Susan B. Anthony Amendment.'")
        ]),
        UnifiedQuestion(id: "q_08_078", correctAnswer: 3, variants: [
            .init(text: "Name one war fought by the United States in the 1900s.",
                  options: ["The Civil War", "The Revolutionary War", "The War of 1812", "World War I"],
                  explanation: "U.S. wars in the 1900s: WWI (1917–18), WWII (1941–45), Korean War (1950–53), Vietnam War (1964–75), and Persian Gulf War (1991).")
        ]),
        UnifiedQuestion(id: "q_08_079", correctAnswer: 2, variants: [
            .init(text: "Who was President during World War I?",
                  options: ["Theodore Roosevelt", "Abraham Lincoln", "Woodrow Wilson", "Franklin Roosevelt"],
                  explanation: "Woodrow Wilson was the 28th President. He led the United States through World War I (1917–1918) and proposed the League of Nations to maintain world peace after the war.")
        ]),
        UnifiedQuestion(id: "q_08_080", correctAnswer: 3, variants: [
            .init(text: "Who was President during the Great Depression and World War II?",
                  options: ["Herbert Hoover", "Calvin Coolidge", "Harry Truman", "Franklin Roosevelt"],
                  explanation: "Franklin D. Roosevelt (FDR), the 32nd President, led the nation through both the Great Depression (New Deal programs) and World War II. He served four terms — the most of any President.")
        ])
    ]

    // MARK: - Practice Set 9: 20th Century History & U.S. Geography (Q81–Q90)
    static let practice9: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_081", correctAnswer: 2, variants: [
            .init(text: "Who did the United States fight in World War II?",
                  options: ["Germany, Russia, and China", "Japan, France, and Italy", "Japan, Germany, and Italy", "Britain, France, and Germany"],
                  explanation: "The U.S. fought the Axis Powers: Japan, Germany, and Italy. The U.S. entered WWII after Japan's attack on Pearl Harbor, Hawaii, on December 7, 1941.")
        ]),
        UnifiedQuestion(id: "q_08_082", correctAnswer: 1, variants: [
            .init(text: "Before he was President, Eisenhower was a general. What war was he in?",
                  options: ["World War I", "World War II", "Korean War", "Vietnam War"],
                  explanation: "Dwight D. Eisenhower served as Supreme Commander of Allied Forces in Europe during WWII. He later became the 34th President, serving from 1953 to 1961.")
        ]),
        UnifiedQuestion(id: "q_08_083", correctAnswer: 3, variants: [
            .init(text: "During the Cold War, what was the main concern of the United States?",
                  options: ["Economic recession and unemployment", "Climate change and pollution", "Illegal immigration", "Communism / the spread of communism and nuclear war"],
                  explanation: "The Cold War (1947–1991) was a global ideological conflict between the democratic U.S. and communist Soviet Union, centered on nuclear weapons, arms races, and spreading influence.")
        ]),
        UnifiedQuestion(id: "q_08_084", correctAnswer: 2, variants: [
            .init(text: "What movement tried to end racial discrimination?",
                  options: ["The Temperance Movement", "The Labor Movement", "The Civil Rights Movement", "The Women's Suffrage Movement"],
                  explanation: "The Civil Rights Movement of the 1950s–1960s fought to end racial segregation and discrimination, resulting in landmark laws like the Civil Rights Act of 1964 and Voting Rights Act of 1965.")
        ]),
        UnifiedQuestion(id: "q_08_085", correctAnswer: 2, variants: [
            .init(text: "What did Martin Luther King, Jr. do?",
                  options: ["Led the Underground Railroad to free enslaved people", "Served as the first Black President of the NAACP", "Fought for civil rights and equality for all Americans", "Wrote the Civil Rights Act of 1964"],
                  explanation: "Dr. Martin Luther King, Jr. was the most prominent leader of the Civil Rights Movement, advocating nonviolent protest. He received the Nobel Peace Prize in 1964.")
        ]),
        UnifiedQuestion(id: "q_08_086", correctAnswer: 2, variants: [
            .init(text: "What major event happened on September 11, 2001, in the United States?",
                  options: ["A major hurricane struck the East Coast", "A financial crisis closed the stock market", "Terrorists attacked the United States", "The United States declared war on Iraq"],
                  explanation: "On September 11, 2001, al-Qaeda terrorists hijacked four planes and attacked the World Trade Center (New York) and the Pentagon (Virginia). Nearly 3,000 people were killed.")
        ]),
        UnifiedQuestion(id: "q_08_087", correctAnswer: 3, variants: [
            .init(text: "Name one American Indian tribe in the United States.",
                  options: ["Aztec", "Maya", "Inca", "Cherokee or Navajo"],
                  explanation: "USCIS accepts many tribes: Cherokee, Navajo, Sioux, Chippewa, Choctaw, Pueblo, Apache, Iroquois, Creek, Blackfeet, Seminole, Cheyenne, Shawnee, Lakota, Crow, Hopi, Inuit, and others. (Aztec/Maya/Inca are Latin American, not U.S.)")
        ]),
        UnifiedQuestion(id: "q_08_088", correctAnswer: 2, variants: [
            .init(text: "Name one of the two longest rivers in the United States.",
                  options: ["The Colorado River or the Rio Grande", "The Ohio River or the Columbia River", "The Missouri River or the Mississippi River", "The Hudson River or the Tennessee River"],
                  explanation: "The Missouri River (~2,341 miles) and Mississippi River (~2,340 miles) are the two longest rivers in the United States. The Mississippi drains the central U.S. into the Gulf of Mexico.")
        ]),
        UnifiedQuestion(id: "q_08_089", correctAnswer: 3, variants: [
            .init(text: "What ocean is on the West Coast of the United States?",
                  options: ["Atlantic Ocean", "Indian Ocean", "Arctic Ocean", "Pacific Ocean"],
                  explanation: "The Pacific Ocean borders the West Coast of the United States, including California, Oregon, Washington, and Alaska. It is the world's largest ocean.")
        ]),
        UnifiedQuestion(id: "q_08_090", correctAnswer: 2, variants: [
            .init(text: "What ocean is on the East Coast of the United States?",
                  options: ["Pacific Ocean", "Indian Ocean", "Atlantic Ocean", "Arctic Ocean"],
                  explanation: "The Atlantic Ocean borders the East Coast of the United States, from Maine down to Florida. The early colonists crossed the Atlantic to reach America from Europe.")
        ])
    ]

    // MARK: - Practice Set 10: Geography, Symbols & Holidays (Q91–Q100)
    static let practice10: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_091", correctAnswer: 1, variants: [
            .init(text: "Name one U.S. territory.",
                  options: ["Cuba", "Puerto Rico", "Dominican Republic", "Philippines"],
                  explanation: "U.S. territories include Puerto Rico, U.S. Virgin Islands, American Samoa, Guam, and the Northern Mariana Islands. Residents are U.S. nationals; Puerto Ricans are U.S. citizens.")
        ]),
        UnifiedQuestion(id: "q_08_092", correctAnswer: 3, variants: [
            .init(text: "Name one state that borders Canada.",
                  options: ["California", "Florida", "Texas", "Minnesota"],
                  explanation: "States bordering Canada: Maine, New Hampshire, Vermont, New York, Pennsylvania, Ohio, Michigan, Minnesota, North Dakota, Montana, Idaho, Washington, and Alaska.")
        ]),
        UnifiedQuestion(id: "q_08_093", correctAnswer: 3, variants: [
            .init(text: "Name one state that borders Mexico.",
                  options: ["Florida", "Louisiana", "Nevada", "Texas"],
                  explanation: "Four states share a border with Mexico: California, Arizona, New Mexico, and Texas. The U.S.-Mexico border stretches nearly 2,000 miles.")
        ]),
        UnifiedQuestion(id: "q_08_094", correctAnswer: 3, variants: [
            .init(text: "What is the capital of the United States?",
                  options: ["New York City", "Los Angeles", "Chicago", "Washington, D.C."],
                  explanation: "Washington, D.C. (District of Columbia) has been the nation's capital since 1800. It is not part of any state and was named after President George Washington.")
        ]),
        UnifiedQuestion(id: "q_08_095", correctAnswer: 2, variants: [
            .init(text: "Where is the Statue of Liberty?",
                  options: ["Philadelphia, Pennsylvania", "Boston, Massachusetts", "New York (Harbor) / Liberty Island", "Washington, D.C."],
                  explanation: "The Statue of Liberty stands on Liberty Island in New York Harbor. A gift from France, it was dedicated in 1886 and symbolizes freedom and democracy.")
        ]),
        UnifiedQuestion(id: "q_08_096", correctAnswer: 2, variants: [
            .init(text: "Why does the flag have 13 stripes?",
                  options: ["For the 13 presidents who served before Lincoln", "For the 13 amendments that form the Bill of Rights", "Because there were 13 original colonies", "For the 13 original Supreme Court justices"],
                  explanation: "The 13 alternating red and white stripes represent the original 13 colonies that declared independence from Britain and became the nation's first 13 states.")
        ]),
        UnifiedQuestion(id: "q_08_097", correctAnswer: 3, variants: [
            .init(text: "Why does the flag have 50 stars?",
                  options: ["For the 50 largest U.S. cities", "For the 50 years since independence", "For the 50 most important federal laws", "Because there is one star for each state"],
                  explanation: "Each of the 50 stars represents one U.S. state. The current 50-star flag was adopted on July 4, 1960, after Hawaii became the 50th state in 1959.")
        ]),
        UnifiedQuestion(id: "q_08_098", correctAnswer: 3, variants: [
            .init(text: "What is the name of the national anthem?",
                  options: ["America the Beautiful", "God Bless America", "My Country, 'Tis of Thee", "The Star-Spangled Banner"],
                  explanation: "'The Star-Spangled Banner,' written by Francis Scott Key during the War of 1812, was officially designated the national anthem by Congress in 1931.")
        ]),
        UnifiedQuestion(id: "q_08_099", correctAnswer: 1, variants: [
            .init(text: "When do we celebrate Independence Day?",
                  options: ["July 1", "July 4", "September 4", "October 31"],
                  explanation: "Independence Day (July 4th) celebrates the adoption of the Declaration of Independence on July 4, 1776 — the birth of the United States as a nation.")
        ]),
        UnifiedQuestion(id: "q_08_100", correctAnswer: 1, variants: [
            .init(text: "Name two national U.S. holidays.",
                  options: ["Valentine's Day and Easter", "Independence Day and Thanksgiving", "Hanukkah and Kwanzaa", "New Year's Eve and April Fool's Day"],
                  explanation: "Federal holidays include New Year's Day, MLK Day, Presidents' Day, Memorial Day, Independence Day, Labor Day, Columbus Day, Veterans Day, Thanksgiving, and Christmas.")
        ])
    ]
}
