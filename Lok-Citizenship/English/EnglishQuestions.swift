import Foundation

/// All English quiz question sets — the 128 official 2025 USCIS naturalization
/// civics questions, regrouped thematically across 8 practice levels of
/// exactly 16 questions each. IDs (`q_25_NNN`) match the official USCIS
/// question numbering 1-128.
///
/// Themed grouping (Government Basics, Constitution & Amendments, Congress,
/// Executive, Judicial/Rights, Founding Era, 1800s, 1900s/Modern) lets users
/// target weak topic areas instead of grinding through random sets.
///
/// Each English question has 1 variant (English only).
enum EnglishQuestions {

    // MARK: - Practice 1: Government Basics & Symbols (16 questions)
    static let practice1: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_001", correctAnswer: 0, variants: [
            .init(text: "What is the form of government of the United States?",
                  options: ["Republic", "Monarchy", "Dictatorship", "Direct democracy"],
                  explanation: "The U.S. is a constitution-based federal republic — a representative democracy where citizens elect officials to govern.")
        ]),
        UnifiedQuestion(id: "q_25_012", correctAnswer: 2, variants: [
            .init(text: "What is the economic system of the United States?",
                  options: ["Socialism", "Communism", "Capitalism", "Feudalism"],
                  explanation: "The U.S. operates a capitalist (free market) economy, where businesses and prices are largely determined by supply and demand.")
        ]),
        UnifiedQuestion(id: "q_25_016", correctAnswer: 1, variants: [
            .init(text: "Name the three branches of government.",
                  options: ["Federal, state, local", "Legislative, executive, and judicial", "President, Senate, House", "Republican, Democrat, Independent"],
                  explanation: "The three branches are the Legislative (Congress), Executive (President), and Judicial (the courts), each with separate powers.")
        ]),
        UnifiedQuestion(id: "q_25_017", correctAnswer: 2, variants: [
            .init(text: "The President of the United States is in charge of which branch of government?",
                  options: ["Legislative branch", "Judicial branch", "Executive branch", "Military branch"],
                  explanation: "The President leads the Executive branch, which enforces the laws passed by Congress.")
        ]),
        UnifiedQuestion(id: "q_25_038", correctAnswer: 2, variants: [
            .init(text: "What is the name of the President of the United States now?",
                  options: ["Joe Biden", "Barack Obama", "Donald Trump", "George W. Bush"],
                  explanation: "Donald Trump is the current President, serving his second term beginning January 2025.")
        ]),
        UnifiedQuestion(id: "q_25_039", correctAnswer: 1, variants: [
            .init(text: "What is the name of the Vice President of the United States now?",
                  options: ["Kamala Harris", "JD Vance", "Mike Pence", "Joe Biden"],
                  explanation: "JD Vance became Vice President in January 2025, serving alongside President Trump.")
        ]),
        UnifiedQuestion(id: "q_25_040", correctAnswer: 1, variants: [
            .init(text: "If the President can no longer serve, who becomes President?",
                  options: ["The Speaker of the House", "The Vice President", "The Secretary of State", "The Chief Justice"],
                  explanation: "The Vice President becomes President if the President can no longer serve, per the 25th Amendment.")
        ]),
        UnifiedQuestion(id: "q_25_042", correctAnswer: 0, variants: [
            .init(text: "Who is Commander in Chief of the U.S. military?",
                  options: ["The President", "The Secretary of Defense", "A military general", "The Vice President"],
                  explanation: "The President serves as Commander in Chief, which keeps the military under civilian control.")
        ]),
        UnifiedQuestion(id: "q_25_052", correctAnswer: 2, variants: [
            .init(text: "What is the highest court in the United States?",
                  options: ["Federal Court", "Court of Appeals", "Supreme Court", "Circuit Court"],
                  explanation: "The Supreme Court is the highest court in the U.S. Its decisions are final and apply to all lower courts.")
        ]),
        UnifiedQuestion(id: "q_25_053", correctAnswer: 1, variants: [
            .init(text: "How many seats are on the Supreme Court?",
                  options: ["7", "9", "11", "13"],
                  explanation: "The Supreme Court has 9 seats: one Chief Justice and eight Associate Justices, set by the Judiciary Act of 1869.")
        ]),
        UnifiedQuestion(id: "q_25_066", correctAnswer: 2, variants: [
            .init(text: "What do we show loyalty to when we say the Pledge of Allegiance?",
                  options: ["The President", "The state government", "The United States and the flag", "The military"],
                  explanation: "The Pledge of Allegiance shows loyalty to the United States and to the U.S. flag — symbols of the nation as a whole.")
        ]),
        UnifiedQuestion(id: "q_25_119", correctAnswer: 1, variants: [
            .init(text: "What is the capital of the United States?",
                  options: ["New York City", "Washington, D.C.", "Philadelphia", "Boston"],
                  explanation: "Washington, D.C. has been the U.S. capital since 1800. The District of Columbia is named after Christopher Columbus.")
        ]),
        UnifiedQuestion(id: "q_25_121", correctAnswer: 2, variants: [
            .init(text: "Why does the flag have 13 stripes?",
                  options: ["For the 13 amendments", "For the 13 states bordering the ocean", "Because there were 13 original colonies", "For the 13 founding fathers"],
                  explanation: "The 13 stripes represent the 13 original colonies that declared independence and became the first U.S. states.")
        ]),
        UnifiedQuestion(id: "q_25_122", correctAnswer: 1, variants: [
            .init(text: "Why does the flag have 50 stars?",
                  options: ["For the 50 founding fathers", "There is one star for each state", "For 50 years of independence", "For each amendment"],
                  explanation: "Each star represents one of the 50 U.S. states. A new star is added when a state joins the Union.")
        ]),
        UnifiedQuestion(id: "q_25_123", correctAnswer: 2, variants: [
            .init(text: "What is the name of the national anthem?",
                  options: ["America the Beautiful", "God Bless America", "The Star-Spangled Banner", "My Country, 'Tis of Thee"],
                  explanation: "\"The Star-Spangled Banner\" was written by Francis Scott Key in 1814 and became the official national anthem in 1931.")
        ]),
        UnifiedQuestion(id: "q_25_124", correctAnswer: 1, variants: [
            .init(text: "The Nation's first motto was \"E Pluribus Unum.\" What does that mean?",
                  options: ["In God We Trust", "Out of many, one", "Liberty and justice for all", "We the People"],
                  explanation: "\"E Pluribus Unum\" (Latin) means \"Out of many, one.\" It refers to the union of many states forming one nation.")
        ])
    ]

    // MARK: - Practice 2: Constitution & Amendments (16 questions)
    static let practice2: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_002", correctAnswer: 2, variants: [
            .init(text: "What is the supreme law of the land?",
                  options: ["The Bill of Rights", "The Declaration of Independence", "The U.S. Constitution", "The Articles of Confederation"],
                  explanation: "The U.S. Constitution is the supreme law of the land. All other laws must comply with it.")
        ]),
        UnifiedQuestion(id: "q_25_003", correctAnswer: 1, variants: [
            .init(text: "Name one thing the U.S. Constitution does.",
                  options: ["Declares war on Britain", "Forms the government and protects rights", "Lists all U.S. citizens", "Establishes the national religion"],
                  explanation: "The Constitution forms the government, defines its powers and parts, and protects the rights of the people.")
        ]),
        UnifiedQuestion(id: "q_25_004", correctAnswer: 1, variants: [
            .init(text: "The U.S. Constitution starts with the words \"We the People.\" What does \"We the People\" mean?",
                  options: ["Only landowners", "Self-government and consent of the governed", "Only U.S. citizens", "The President alone"],
                  explanation: "\"We the People\" expresses self-government, popular sovereignty, and consent of the governed — government's power comes from the people.")
        ]),
        UnifiedQuestion(id: "q_25_005", correctAnswer: 1, variants: [
            .init(text: "How are changes made to the U.S. Constitution?",
                  options: ["By presidential order", "Through the amendment process", "By Supreme Court ruling", "By state vote alone"],
                  explanation: "Changes are made through amendments. An amendment requires a two-thirds vote in Congress and ratification by three-fourths of the states.")
        ]),
        UnifiedQuestion(id: "q_25_006", correctAnswer: 1, variants: [
            .init(text: "What does the Bill of Rights protect?",
                  options: ["Government property", "The basic rights of Americans", "Foreign trade only", "State borders"],
                  explanation: "The Bill of Rights — the first 10 amendments — protects the basic rights of Americans, including speech, religion, and due process.")
        ]),
        UnifiedQuestion(id: "q_25_007", correctAnswer: 2, variants: [
            .init(text: "How many amendments does the U.S. Constitution have?",
                  options: ["10", "17", "27", "50"],
                  explanation: "The Constitution has 27 amendments. The first 10 are the Bill of Rights; the most recent (27th) was ratified in 1992.")
        ]),
        UnifiedQuestion(id: "q_25_008", correctAnswer: 1, variants: [
            .init(text: "Why is the Declaration of Independence important?",
                  options: ["It established the U.S. dollar", "It says all people are created equal and identifies inherent rights", "It ended World War II", "It created the Supreme Court"],
                  explanation: "The Declaration of Independence states America is free from British control, says all people are created equal, and identifies inherent rights and individual freedoms.")
        ]),
        UnifiedQuestion(id: "q_25_009", correctAnswer: 1, variants: [
            .init(text: "What founding document said the American colonies were free from Britain?",
                  options: ["The U.S. Constitution", "The Declaration of Independence", "The Bill of Rights", "The Federalist Papers"],
                  explanation: "The Declaration of Independence (1776) declared the 13 American colonies free from British rule.")
        ]),
        UnifiedQuestion(id: "q_25_010", correctAnswer: 1, variants: [
            .init(text: "Name two important ideas from the Declaration of Independence and the U.S. Constitution.",
                  options: ["Monarchy and aristocracy", "Equality and liberty", "Slavery and segregation", "Foreign rule and conquest"],
                  explanation: "Important ideas include equality, liberty, social contract, natural rights, limited government, and self-government.")
        ]),
        UnifiedQuestion(id: "q_25_011", correctAnswer: 2, variants: [
            .init(text: "The words \"Life, Liberty, and the pursuit of Happiness\" are in what founding document?",
                  options: ["U.S. Constitution", "Bill of Rights", "Declaration of Independence", "Articles of Confederation"],
                  explanation: "These famous words appear in the Declaration of Independence, written by Thomas Jefferson in 1776.")
        ]),
        UnifiedQuestion(id: "q_25_013", correctAnswer: 2, variants: [
            .init(text: "What is the rule of law?",
                  options: ["The President can do anything", "The richest people make the rules", "Everyone must follow the law, including leaders", "Only judges follow the law"],
                  explanation: "The rule of law means everyone must obey the law — including leaders, the government, and ordinary citizens. No one is above the law.")
        ]),
        UnifiedQuestion(id: "q_25_014", correctAnswer: 1, variants: [
            .init(text: "Many documents influenced the U.S. Constitution. Name one.",
                  options: ["The Treaty of Paris", "The Federalist Papers", "The Monroe Doctrine", "The Marshall Plan"],
                  explanation: "Documents that influenced the Constitution include the Declaration of Independence, Articles of Confederation, Federalist Papers, Virginia Declaration of Rights, Mayflower Compact, and Iroquois Great Law of Peace.")
        ]),
        UnifiedQuestion(id: "q_25_015", correctAnswer: 1, variants: [
            .init(text: "There are three branches of government. Why?",
                  options: ["To create more jobs", "So one part does not become too powerful", "Because the colonies wanted three", "Because three is a lucky number"],
                  explanation: "Three branches with checks and balances ensure no single branch becomes too powerful — the principle of separation of powers.")
        ]),
        UnifiedQuestion(id: "q_25_060", correctAnswer: 1, variants: [
            .init(text: "What is the purpose of the 10th Amendment?",
                  options: ["To give all power to the federal government", "Powers not given to the federal government belong to the states or the people", "To establish religious freedom", "To allow free speech"],
                  explanation: "The 10th Amendment reserves any powers not delegated to the federal government — and not prohibited to states — for the states or the people.")
        ]),
        UnifiedQuestion(id: "q_25_097", correctAnswer: 1, variants: [
            .init(text: "What amendment says all persons born or naturalized in the United States, and subject to the jurisdiction thereof, are U.S. citizens?",
                  options: ["13th Amendment", "14th Amendment", "15th Amendment", "19th Amendment"],
                  explanation: "The 14th Amendment (1868) grants citizenship to all persons born or naturalized in the United States — known as birthright citizenship.")
        ]),
        UnifiedQuestion(id: "q_25_102", correctAnswer: 2, variants: [
            .init(text: "When did all women get the right to vote?",
                  options: ["1865", "1870", "1920 (with the 19th Amendment)", "1965"],
                  explanation: "The 19th Amendment, ratified in 1920, gave women the right to vote nationwide after a long suffrage movement.")
        ])
    ]

    // MARK: - Practice 3: Congress: Structure & Powers (16 questions)
    static let practice3: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_018", correctAnswer: 2, variants: [
            .init(text: "What part of the federal government writes laws?",
                  options: ["The Supreme Court", "The President", "U.S. Congress (legislative branch)", "The Cabinet"],
                  explanation: "Congress — the Senate and House of Representatives — is the legislative branch responsible for writing federal laws.")
        ]),
        UnifiedQuestion(id: "q_25_019", correctAnswer: 0, variants: [
            .init(text: "What are the two parts of the U.S. Congress?",
                  options: ["Senate and House of Representatives", "Cabinet and Senate", "President and Vice President", "House and Cabinet"],
                  explanation: "Congress is bicameral, made up of the Senate (100 members) and the House of Representatives (435 voting members).")
        ]),
        UnifiedQuestion(id: "q_25_020", correctAnswer: 2, variants: [
            .init(text: "Name one power of the U.S. Congress.",
                  options: ["Veto bills", "Decides Supreme Court cases", "Writes laws", "Commands the military"],
                  explanation: "Powers of Congress include writing laws, declaring war, and making the federal budget.")
        ]),
        UnifiedQuestion(id: "q_25_021", correctAnswer: 1, variants: [
            .init(text: "How many U.S. senators are there?",
                  options: ["50", "100", "435", "200"],
                  explanation: "There are 100 U.S. Senators — two from each of the 50 states, ensuring equal representation regardless of state size.")
        ]),
        UnifiedQuestion(id: "q_25_022", correctAnswer: 2, variants: [
            .init(text: "How long is a term for a U.S. senator?",
                  options: ["2 years", "4 years", "6 years", "Life"],
                  explanation: "Senators serve 6-year terms. About one-third of the Senate is up for election every two years.")
        ]),
        UnifiedQuestion(id: "q_25_023", correctAnswer: 0, variants: [
            .init(text: "Who is one of your state's U.S. senators now?",
                  options: ["Depends on your state", "Joe Biden", "Donald Trump", "Ron DeSantis"],
                  explanation: "Each state has 2 U.S. Senators. Look up your state's current Senators at senate.gov before your interview. (D.C. and U.S. territories have no voting Senators.)")
        ]),
        UnifiedQuestion(id: "q_25_024", correctAnswer: 2, variants: [
            .init(text: "How many voting members are in the House of Representatives?",
                  options: ["100", "200", "435", "538"],
                  explanation: "The House has 435 voting members. Seats are apportioned by population, recalculated after each census.")
        ]),
        UnifiedQuestion(id: "q_25_025", correctAnswer: 0, variants: [
            .init(text: "How long is a term for a member of the House of Representatives?",
                  options: ["2 years", "4 years", "6 years", "8 years"],
                  explanation: "House members serve 2-year terms. The entire House faces re-election every two years to keep them close to the people.")
        ]),
        UnifiedQuestion(id: "q_25_026", correctAnswer: 1, variants: [
            .init(text: "Why do U.S. representatives serve shorter terms than U.S. senators?",
                  options: ["To save government money", "To more closely follow public opinion", "Because they have less power", "Because they are appointed, not elected"],
                  explanation: "Representatives serve shorter (2-year) terms so they remain closely accountable to the public's current opinions.")
        ]),
        UnifiedQuestion(id: "q_25_027", correctAnswer: 1, variants: [
            .init(text: "How many senators does each state have?",
                  options: ["1", "2", "3", "Depends on population"],
                  explanation: "Each state has 2 Senators, regardless of population. This was the Great Compromise to ensure equal state representation.")
        ]),
        UnifiedQuestion(id: "q_25_028", correctAnswer: 0, variants: [
            .init(text: "Why does each state have two senators?",
                  options: ["For equal representation of small and large states (the Great Compromise)", "Because the Senate is the more important chamber", "To save election costs", "Because the Constitution forgot to specify"],
                  explanation: "Each state has 2 Senators for equal representation. This was the Great Compromise (Connecticut Compromise), balancing small-state and large-state interests.")
        ]),
        UnifiedQuestion(id: "q_25_029", correctAnswer: 0, variants: [
            .init(text: "Name your U.S. representative.",
                  options: ["Depends on your congressional district", "Mike Johnson", "Nancy Pelosi", "Kevin McCarthy"],
                  explanation: "Each congressional district has one Representative. Find yours at house.gov by entering your ZIP code.")
        ]),
        UnifiedQuestion(id: "q_25_030", correctAnswer: 2, variants: [
            .init(text: "What is the name of the Speaker of the House of Representatives now?",
                  options: ["Nancy Pelosi", "Kevin McCarthy", "Mike Johnson", "Mitch McConnell"],
                  explanation: "Mike Johnson has been Speaker of the House since 2023. The Speaker leads the House and is second in line for presidential succession.")
        ]),
        UnifiedQuestion(id: "q_25_031", correctAnswer: 1, variants: [
            .init(text: "Who does a U.S. senator represent?",
                  options: ["Only the President's party", "Citizens of their state", "Federal employees only", "The Supreme Court"],
                  explanation: "A U.S. Senator represents all the citizens (people) of their state.")
        ]),
        UnifiedQuestion(id: "q_25_032", correctAnswer: 2, variants: [
            .init(text: "Who elects U.S. senators?",
                  options: ["State legislatures", "The President", "Citizens from their state", "Other Senators"],
                  explanation: "Citizens from each state elect their Senators. Before the 17th Amendment (1913), Senators were chosen by state legislatures.")
        ]),
        UnifiedQuestion(id: "q_25_033", correctAnswer: 0, variants: [
            .init(text: "Who does a member of the House of Representatives represent?",
                  options: ["Citizens of their congressional district", "All U.S. citizens", "Their political party", "The President"],
                  explanation: "A House member represents the citizens (people) of their congressional district. House districts are based on population.")
        ])
    ]

    // MARK: - Practice 4: Congress & Executive (16 questions)
    static let practice4: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_034", correctAnswer: 1, variants: [
            .init(text: "Who elects members of the House of Representatives?",
                  options: ["The state governor", "Citizens from their congressional district", "The President", "The Senate"],
                  explanation: "Citizens from each congressional district elect their Representative every two years.")
        ]),
        UnifiedQuestion(id: "q_25_035", correctAnswer: 1, variants: [
            .init(text: "Some states have more representatives than other states. Why?",
                  options: ["Because they were states first", "Because of the state's population", "Because they pay more taxes", "Because they have more land"],
                  explanation: "House seats are apportioned by population. California has 52 representatives; small states like Wyoming have just 1.")
        ]),
        UnifiedQuestion(id: "q_25_036", correctAnswer: 1, variants: [
            .init(text: "The President of the United States is elected for how many years?",
                  options: ["2 years", "4 years", "6 years", "Life"],
                  explanation: "The President serves a 4-year term, established by Article II of the Constitution.")
        ]),
        UnifiedQuestion(id: "q_25_037", correctAnswer: 1, variants: [
            .init(text: "The President of the United States can serve only two terms. Why?",
                  options: ["To save campaign costs", "Because of the 22nd Amendment (to prevent too much power)", "Because of tradition only", "Because the President gets too old"],
                  explanation: "The 22nd Amendment (1951) limits Presidents to two elected terms, preventing any one person from accumulating too much power. It was passed after FDR served four terms.")
        ]),
        UnifiedQuestion(id: "q_25_041", correctAnswer: 1, variants: [
            .init(text: "Name one power of the President.",
                  options: ["Writes federal laws", "Vetoes bills", "Decides Supreme Court cases", "Declares war"],
                  explanation: "Presidential powers include vetoing bills, signing bills into law, enforcing laws, serving as Commander in Chief, and appointing federal judges.")
        ]),
        UnifiedQuestion(id: "q_25_043", correctAnswer: 2, variants: [
            .init(text: "Who signs bills to become laws?",
                  options: ["The Speaker of the House", "The Vice President", "The President", "The Chief Justice"],
                  explanation: "After Congress passes a bill, the President signs it into law. The President can also veto a bill, returning it to Congress.")
        ]),
        UnifiedQuestion(id: "q_25_044", correctAnswer: 2, variants: [
            .init(text: "Who vetoes bills?",
                  options: ["The Senate", "The Supreme Court", "The President", "The Cabinet"],
                  explanation: "The President vetoes bills passed by Congress. Congress can override a veto with a two-thirds vote in both chambers.")
        ]),
        UnifiedQuestion(id: "q_25_045", correctAnswer: 2, variants: [
            .init(text: "Who appoints federal judges?",
                  options: ["The Speaker of the House", "The Chief Justice", "The President", "Congress"],
                  explanation: "The President appoints federal judges, including Supreme Court Justices. The Senate must confirm these appointments.")
        ]),
        UnifiedQuestion(id: "q_25_046", correctAnswer: 1, variants: [
            .init(text: "The executive branch has many parts. Name one.",
                  options: ["The Supreme Court", "The President's Cabinet", "The Senate", "Congress"],
                  explanation: "Parts of the Executive branch include the President, the Cabinet, and federal departments and agencies (like the FBI, EPA, IRS).")
        ]),
        UnifiedQuestion(id: "q_25_047", correctAnswer: 1, variants: [
            .init(text: "What does the President's Cabinet do?",
                  options: ["Writes laws", "Advises the President", "Decides court cases", "Elects the next President"],
                  explanation: "The Cabinet is a group of advisors to the President, made up of the heads of the federal departments (like Secretary of State, Secretary of Defense).")
        ]),
        UnifiedQuestion(id: "q_25_048", correctAnswer: 0, variants: [
            .init(text: "What are two Cabinet-level positions?",
                  options: ["Secretary of State and Attorney General", "Speaker of the House and Senate Majority Leader", "Chief Justice and Vice President", "Governor and Mayor"],
                  explanation: "Cabinet-level positions include Secretary of State, Attorney General, Secretary of Defense, Secretary of the Treasury, Secretary of Homeland Security, and many others.")
        ]),
        UnifiedQuestion(id: "q_25_049", correctAnswer: 0, variants: [
            .init(text: "Why is the Electoral College important?",
                  options: ["It decides who is elected President", "It chooses Supreme Court Justices", "It teaches government in college", "It runs federal elections"],
                  explanation: "The Electoral College decides who is elected President. It is a compromise between popular election and congressional selection of the President.")
        ]),
        UnifiedQuestion(id: "q_25_050", correctAnswer: 2, variants: [
            .init(text: "What is one part of the judicial branch?",
                  options: ["The Senate", "The Cabinet", "The Supreme Court", "The Pentagon"],
                  explanation: "The judicial branch includes the Supreme Court and the federal courts (district courts and courts of appeals).")
        ]),
        UnifiedQuestion(id: "q_25_051", correctAnswer: 1, variants: [
            .init(text: "What does the judicial branch do?",
                  options: ["Writes laws", "Reviews and explains laws", "Commands the military", "Collects taxes"],
                  explanation: "The judicial branch reviews laws, explains them, resolves disputes, and decides if a law goes against the Constitution.")
        ]),
        UnifiedQuestion(id: "q_25_054", correctAnswer: 1, variants: [
            .init(text: "How many Supreme Court justices are usually needed to decide a case?",
                  options: ["3", "6 (a quorum)", "9 (all)", "5"],
                  explanation: "Per 28 U.S.C. §1, six (6) Justices constitute a quorum — the minimum number required to hear and decide a Supreme Court case. This is the official USCIS answer.")
        ]),
        UnifiedQuestion(id: "q_25_055", correctAnswer: 3, variants: [
            .init(text: "How long do Supreme Court justices serve?",
                  options: ["4 years", "8 years", "12 years", "For life (lifetime appointment)"],
                  explanation: "Supreme Court Justices serve for life or until retirement. Lifetime appointments shield them from political pressure.")
        ])
    ]

    // MARK: - Practice 5: Judicial, Federalism & Rights (16 questions)
    static let practice5: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_056", correctAnswer: 1, variants: [
            .init(text: "Supreme Court justices serve for life. Why?",
                  options: ["To save retirement costs", "To be independent of politics", "Because they cannot be replaced", "Because they're appointed by the people"],
                  explanation: "Lifetime appointments protect Justices from political pressure, allowing them to interpret the Constitution independently.")
        ]),
        UnifiedQuestion(id: "q_25_057", correctAnswer: 0, variants: [
            .init(text: "Who is the Chief Justice of the United States now?",
                  options: ["John Roberts", "Clarence Thomas", "Amy Coney Barrett", "Sonia Sotomayor"],
                  explanation: "John Roberts has been Chief Justice since 2005. He presides over the Supreme Court and over presidential impeachment trials.")
        ]),
        UnifiedQuestion(id: "q_25_058", correctAnswer: 2, variants: [
            .init(text: "Name one power that is only for the federal government.",
                  options: ["Issue driver's licenses", "Run public schools", "Declare war (or print money)", "Provide police services"],
                  explanation: "Federal-only powers include declaring war, printing paper money, minting coins, creating an army, making treaties, and setting foreign policy.")
        ]),
        UnifiedQuestion(id: "q_25_059", correctAnswer: 2, variants: [
            .init(text: "Name one power that is only for the states.",
                  options: ["Print money", "Declare war", "Provide schooling and police protection", "Sign treaties"],
                  explanation: "State-only powers include providing education and schools, police and fire protection, issuing driver's licenses, and approving zoning.")
        ]),
        UnifiedQuestion(id: "q_25_061", correctAnswer: 0, variants: [
            .init(text: "Who is the governor of your state now?",
                  options: ["Depends on your state", "Donald Trump", "Joe Biden", "Gavin Newsom"],
                  explanation: "Each state has its own Governor. Look up your current Governor on your state government's website. (Territories have appointed governors; D.C. has a mayor instead.)")
        ]),
        UnifiedQuestion(id: "q_25_062", correctAnswer: 0, variants: [
            .init(text: "What is the capital of your state?",
                  options: ["Depends on your state", "Washington, D.C.", "New York City", "Los Angeles"],
                  explanation: "Each state has its own capital city. Know your state's capital before your interview. (D.C. is the U.S. capital, not a state. Territories also have capitals.)")
        ]),
        UnifiedQuestion(id: "q_25_063", correctAnswer: 1, variants: [
            .init(text: "There are four amendments to the U.S. Constitution about who can vote. Describe one of them.",
                  options: ["Only homeowners can vote", "Citizens 18 and older can vote", "Only male citizens can vote", "Voting requires a literacy test"],
                  explanation: "The 26th Amendment (1971) lowered the voting age to 18. Other voting amendments are the 15th (men of any race), 19th (women), and 24th (no poll tax).")
        ]),
        UnifiedQuestion(id: "q_25_064", correctAnswer: 1, variants: [
            .init(text: "Who can vote in federal elections, run for federal office, and serve on a jury in the United States?",
                  options: ["All adults", "U.S. citizens only", "Anyone with a passport", "Only military veterans"],
                  explanation: "Only U.S. citizens have the rights to vote in federal elections, run for federal office, and serve on a jury.")
        ]),
        UnifiedQuestion(id: "q_25_065", correctAnswer: 1, variants: [
            .init(text: "What are three rights of everyone living in the United States?",
                  options: ["Free housing, free food, free healthcare", "Freedom of speech, freedom of religion, and freedom of assembly", "Right to vote, run for office, and own land", "Right to drive, own a gun, and choose any job"],
                  explanation: "Rights of everyone living in the U.S. (citizen or not) include freedom of speech, religion, assembly, the press, and to petition the government.")
        ]),
        UnifiedQuestion(id: "q_25_067", correctAnswer: 1, variants: [
            .init(text: "Name two promises that new citizens make in the Oath of Allegiance.",
                  options: ["Pay extra taxes and vote in every election", "Give up loyalty to other countries and obey U.S. laws", "Speak only English and serve in the military", "Become Christian and own property"],
                  explanation: "The Oath includes giving up loyalty to other countries, defending the Constitution, obeying U.S. laws, and serving the nation when needed.")
        ]),
        UnifiedQuestion(id: "q_25_068", correctAnswer: 1, variants: [
            .init(text: "How can people become United States citizens?",
                  options: ["Only by being born in the U.S.", "By naturalization or being born in the U.S. (under certain conditions)", "Only by marrying a U.S. citizen", "Only by joining the military"],
                  explanation: "People become U.S. citizens by being born in the U.S. (under conditions of the 14th Amendment), through naturalization, or by deriving citizenship through their parents.")
        ]),
        UnifiedQuestion(id: "q_25_069", correctAnswer: 1, variants: [
            .init(text: "What are two examples of civic participation in the United States?",
                  options: ["Eating at restaurants and watching TV", "Voting and joining a community group", "Working a job and paying rent", "Driving a car and owning a home"],
                  explanation: "Civic participation includes voting, running for office, joining a political party or community group, contacting elected officials, and supporting/opposing issues.")
        ]),
        UnifiedQuestion(id: "q_25_070", correctAnswer: 1, variants: [
            .init(text: "What is one way Americans can serve their country?",
                  options: ["Get a high-paying job", "Serve in the military, work for the government, or pay taxes", "Travel abroad as a tourist", "Buy U.S.-made products"],
                  explanation: "Americans can serve by voting, paying taxes, obeying the law, serving in the military, running for office, or working for local, state, or federal government.")
        ]),
        UnifiedQuestion(id: "q_25_071", correctAnswer: 1, variants: [
            .init(text: "Why is it important to pay federal taxes?",
                  options: ["Because tax money goes to other countries", "It is required by law and funds the federal government", "Only wealthy citizens pay taxes", "Taxes are voluntary in the U.S."],
                  explanation: "Paying federal taxes is required by law and funds the federal government. The 16th Amendment (1913) authorized the federal income tax.")
        ]),
        UnifiedQuestion(id: "q_25_072", correctAnswer: 1, variants: [
            .init(text: "It is important for all men age 18 through 25 to register for the Selective Service. Name one reason why.",
                  options: ["To get a free college education", "It is required by law (to make a draft fair if needed)", "To receive Social Security benefits", "To get a passport"],
                  explanation: "Selective Service registration is required by law for men ages 18-25. It allows the government to conduct a fair draft if one becomes necessary.")
        ]),
        UnifiedQuestion(id: "q_25_125", correctAnswer: 1, variants: [
            .init(text: "What is Independence Day?",
                  options: ["A holiday for Christopher Columbus", "A holiday celebrating U.S. independence from Britain", "A holiday honoring veterans", "A holiday for the Constitution"],
                  explanation: "Independence Day (July 4) celebrates the adoption of the Declaration of Independence in 1776 — the country's birthday.")
        ])
    ]

    // MARK: - Practice 6: Founding Era & Revolution (16 questions)
    static let practice6: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_073", correctAnswer: 1, variants: [
            .init(text: "The colonists came to America for many reasons. Name one.",
                  options: ["To start a new civilization", "Religious freedom", "To find gold only", "To meet Native Americans"],
                  explanation: "Many colonists came seeking religious freedom, escaping persecution. Others came for political liberty or economic opportunity.")
        ]),
        UnifiedQuestion(id: "q_25_074", correctAnswer: 2, variants: [
            .init(text: "Who lived in America before the Europeans arrived?",
                  options: ["African settlers", "Asian immigrants", "American Indians (Native Americans)", "European explorers"],
                  explanation: "American Indians (Native Americans) lived across the Americas for thousands of years before European arrival.")
        ]),
        UnifiedQuestion(id: "q_25_075", correctAnswer: 2, variants: [
            .init(text: "What group of people was taken and sold as slaves?",
                  options: ["Native Americans", "Europeans", "Africans (people from Africa)", "Asians"],
                  explanation: "Africans were taken from their homelands and sold as slaves in the Americas, primarily from the 1500s to the 1800s.")
        ]),
        UnifiedQuestion(id: "q_25_076", correctAnswer: 1, variants: [
            .init(text: "What war did the Americans fight to win independence from Britain?",
                  options: ["The Civil War", "The American Revolution (Revolutionary War)", "The War of 1812", "World War I"],
                  explanation: "The American Revolution (1775-1783) won the colonies' independence from Britain, formalized by the Treaty of Paris in 1783.")
        ]),
        UnifiedQuestion(id: "q_25_077", correctAnswer: 1, variants: [
            .init(text: "Name one reason why the Americans declared independence from Britain.",
                  options: ["Britain treated colonists too well", "High taxes (taxation without representation)", "The colonies wanted to merge with France", "British food was unhealthy"],
                  explanation: "Reasons included high taxes (taxation without representation), British soldiers in colonial homes, lack of self-government, the Boston Massacre, and the Boston Tea Party.")
        ]),
        UnifiedQuestion(id: "q_25_078", correctAnswer: 1, variants: [
            .init(text: "Who wrote the Declaration of Independence?",
                  options: ["George Washington", "Thomas Jefferson", "Benjamin Franklin", "John Adams"],
                  explanation: "Thomas Jefferson was the principal author of the Declaration of Independence, drafted in 1776 at age 33.")
        ]),
        UnifiedQuestion(id: "q_25_079", correctAnswer: 1, variants: [
            .init(text: "When was the Declaration of Independence adopted?",
                  options: ["July 4, 1775", "July 4, 1776", "July 4, 1789", "July 4, 1812"],
                  explanation: "The Declaration of Independence was adopted on July 4, 1776 — celebrated annually as Independence Day.")
        ]),
        UnifiedQuestion(id: "q_25_080", correctAnswer: 1, variants: [
            .init(text: "The American Revolution had many important events. Name one.",
                  options: ["The Battle of Gettysburg", "The Declaration of Independence (1776)", "Pearl Harbor attack", "Fall of the Berlin Wall"],
                  explanation: "Important Revolution events include the Battle of Bunker Hill, the Declaration of Independence, Washington crossing the Delaware, Valley Forge, and the Battle of Yorktown.")
        ]),
        UnifiedQuestion(id: "q_25_081", correctAnswer: 1, variants: [
            .init(text: "There were 13 original states. Name five.",
                  options: ["California, Texas, Florida, Hawaii, Alaska", "Virginia, Massachusetts, New York, Pennsylvania, Georgia", "Ohio, Michigan, Illinois, Indiana, Wisconsin", "Maine, Vermont, West Virginia, Oregon, Iowa"],
                  explanation: "The 13 original states were New Hampshire, Massachusetts, Rhode Island, Connecticut, New York, New Jersey, Pennsylvania, Delaware, Maryland, Virginia, North Carolina, South Carolina, and Georgia.")
        ]),
        UnifiedQuestion(id: "q_25_082", correctAnswer: 1, variants: [
            .init(text: "What founding document was written in 1787?",
                  options: ["The Declaration of Independence", "The U.S. Constitution", "The Bill of Rights", "The Articles of Confederation"],
                  explanation: "The U.S. Constitution was written at the Constitutional Convention in Philadelphia in 1787 and ratified in 1788.")
        ]),
        UnifiedQuestion(id: "q_25_083", correctAnswer: 1, variants: [
            .init(text: "The Federalist Papers supported the passage of the U.S. Constitution. Name one of the writers.",
                  options: ["Thomas Jefferson", "James Madison (or Hamilton, or Jay)", "George Washington", "Benjamin Franklin"],
                  explanation: "The Federalist Papers were written by James Madison, Alexander Hamilton, and John Jay (under the pen name \"Publius\") to argue for ratifying the Constitution.")
        ]),
        UnifiedQuestion(id: "q_25_084", correctAnswer: 1, variants: [
            .init(text: "Why were the Federalist Papers important?",
                  options: ["They led to the American Revolution", "They helped people understand and supported passing the Constitution", "They started the Civil War", "They wrote new amendments"],
                  explanation: "The 85 Federalist essays explained how the new Constitution would work and persuaded states (especially New York) to ratify it.")
        ]),
        UnifiedQuestion(id: "q_25_085", correctAnswer: 1, variants: [
            .init(text: "Benjamin Franklin is famous for many things. Name one.",
                  options: ["First President", "First Postmaster General and inventor", "Wrote the Declaration of Independence alone", "First Chief Justice"],
                  explanation: "Franklin was the first Postmaster General, an inventor, a U.S. diplomat, founder of the first free public libraries, and helped write the Declaration of Independence.")
        ]),
        UnifiedQuestion(id: "q_25_086", correctAnswer: 1, variants: [
            .init(text: "George Washington is famous for many things. Name one.",
                  options: ["Wrote the Declaration of Independence", "First President of the United States", "Discovered America", "Wrote the Star-Spangled Banner"],
                  explanation: "Washington is called the \"Father of Our Country.\" He led the Continental Army and was the first U.S. President (1789-1797).")
        ]),
        UnifiedQuestion(id: "q_25_087", correctAnswer: 1, variants: [
            .init(text: "Thomas Jefferson is famous for many things. Name one.",
                  options: ["Discovered electricity", "Wrote the Declaration of Independence and was 3rd President", "Led the Confederacy in the Civil War", "Invented the cotton gin"],
                  explanation: "Jefferson wrote the Declaration of Independence, was the 3rd President, doubled the U.S. with the Louisiana Purchase, and founded the University of Virginia.")
        ]),
        UnifiedQuestion(id: "q_25_088", correctAnswer: 0, variants: [
            .init(text: "James Madison is famous for many things. Name one.",
                  options: ["Father of the Constitution and 4th President", "Led the Underground Railroad", "Discovered America", "Founded Boston"],
                  explanation: "Madison is called the \"Father of the Constitution.\" He was the 4th President, served during the War of 1812, and was a writer of the Federalist Papers.")
        ])
    ]

    // MARK: - Practice 7: 1800s & National Identity (16 questions)
    static let practice7: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_089", correctAnswer: 1, variants: [
            .init(text: "Alexander Hamilton is famous for many things. Name one.",
                  options: ["First President of the U.S.", "First Secretary of the Treasury and Federalist Papers writer", "Discovered penicillin", "Wrote the Star-Spangled Banner"],
                  explanation: "Hamilton was the first Secretary of the Treasury, a writer of the Federalist Papers, helped establish the First Bank of the United States, and was an aide to General Washington.")
        ]),
        UnifiedQuestion(id: "q_25_090", correctAnswer: 1, variants: [
            .init(text: "What territory did the United States buy from France in 1803?",
                  options: ["Florida", "Louisiana Territory", "Alaska", "Texas"],
                  explanation: "President Jefferson bought the Louisiana Territory from France in 1803 for $15 million, doubling the size of the United States.")
        ]),
        UnifiedQuestion(id: "q_25_091", correctAnswer: 1, variants: [
            .init(text: "Name one war fought by the United States in the 1800s.",
                  options: ["World War I", "Civil War (or War of 1812, Mexican-American War, Spanish-American War)", "Vietnam War", "Korean War"],
                  explanation: "Wars fought by the U.S. in the 1800s include the War of 1812, the Mexican-American War, the Civil War, and the Spanish-American War.")
        ]),
        UnifiedQuestion(id: "q_25_092", correctAnswer: 2, variants: [
            .init(text: "Name the U.S. war between the North and the South.",
                  options: ["The Revolutionary War", "The War of 1812", "The Civil War", "The Mexican-American War"],
                  explanation: "The Civil War (1861-1865) was fought between the Northern Union states and the Southern Confederate states, primarily over slavery.")
        ]),
        UnifiedQuestion(id: "q_25_093", correctAnswer: 1, variants: [
            .init(text: "The Civil War had many important events. Name one.",
                  options: ["The bombing of Pearl Harbor", "The Battle of Gettysburg (or Emancipation Proclamation, Surrender at Appomattox)", "Construction of the Panama Canal", "The first moon landing"],
                  explanation: "Important Civil War events include the Battle of Fort Sumter, Emancipation Proclamation, Battle of Gettysburg, Sherman's March, and the Surrender at Appomattox.")
        ]),
        UnifiedQuestion(id: "q_25_094", correctAnswer: 1, variants: [
            .init(text: "Abraham Lincoln is famous for many things. Name one.",
                  options: ["Wrote the Constitution", "Freed the slaves and preserved the Union", "Discovered electricity", "Founded the Republican Party"],
                  explanation: "Lincoln freed the slaves with the Emancipation Proclamation, preserved the Union during the Civil War, and was the 16th President.")
        ]),
        UnifiedQuestion(id: "q_25_095", correctAnswer: 1, variants: [
            .init(text: "What did the Emancipation Proclamation do?",
                  options: ["Started the Civil War", "Freed the slaves in the Confederate states", "Granted women the right to vote", "Ended World War II"],
                  explanation: "President Lincoln's Emancipation Proclamation (1863) declared slaves in the Confederate states to be free.")
        ]),
        UnifiedQuestion(id: "q_25_096", correctAnswer: 2, variants: [
            .init(text: "What U.S. war ended slavery?",
                  options: ["The Revolutionary War", "The War of 1812", "The Civil War", "World War I"],
                  explanation: "The Civil War ended slavery. The 13th Amendment, ratified in 1865 after the war, formally abolished slavery throughout the United States.")
        ]),
        UnifiedQuestion(id: "q_25_098", correctAnswer: 1, variants: [
            .init(text: "When did all men get the right to vote?",
                  options: ["At the start of the country (1776)", "After the Civil War (15th Amendment, 1870)", "After World War I (1920)", "Only in 1965"],
                  explanation: "The 15th Amendment (1870), ratified after the Civil War, prohibited denying the vote based on race — extending voting rights to men of all races.")
        ]),
        UnifiedQuestion(id: "q_25_099", correctAnswer: 1, variants: [
            .init(text: "Name one leader of the women's rights movement in the 1800s.",
                  options: ["Eleanor Roosevelt", "Susan B. Anthony", "Hillary Clinton", "Sandra Day O'Connor"],
                  explanation: "Leaders of the 1800s women's rights movement included Susan B. Anthony, Elizabeth Cady Stanton, Sojourner Truth, Harriet Tubman, and Lucretia Mott.")
        ]),
        UnifiedQuestion(id: "q_25_117", correctAnswer: 1, variants: [
            .init(text: "Name one American Indian tribe in the United States.",
                  options: ["The Egyptians", "Cherokee (or Navajo, Sioux, Apache, Hopi)", "The Vikings", "The Mongols"],
                  explanation: "Recognized American Indian tribes include the Cherokee, Navajo, Sioux, Apache, Hopi, Blackfeet, Choctaw, Pueblo, and many others.")
        ]),
        UnifiedQuestion(id: "q_25_118", correctAnswer: 1, variants: [
            .init(text: "Name one example of an American innovation.",
                  options: ["The wheel", "The airplane (or light bulb, automobile, skyscraper)", "Paper", "Pottery"],
                  explanation: "American innovations include the light bulb (Edison), the airplane (Wright Brothers), the automobile assembly line (Ford), skyscrapers, and the integrated circuit.")
        ]),
        UnifiedQuestion(id: "q_25_120", correctAnswer: 1, variants: [
            .init(text: "Where is the Statue of Liberty?",
                  options: ["Boston Harbor", "New York Harbor (Liberty Island)", "Chesapeake Bay", "Los Angeles"],
                  explanation: "The Statue of Liberty stands on Liberty Island in New York Harbor. It was a gift from France in 1886 and a symbol of freedom for immigrants arriving by sea.")
        ]),
        UnifiedQuestion(id: "q_25_126", correctAnswer: 1, variants: [
            .init(text: "Name three national U.S. holidays.",
                  options: ["Halloween, Valentine's Day, Earth Day", "Independence Day, Thanksgiving, and Christmas", "Mother's Day, Father's Day, Easter", "Black Friday, Cyber Monday, Tax Day"],
                  explanation: "U.S. national holidays include New Year's Day, MLK Jr. Day, Presidents Day, Memorial Day, Juneteenth, Independence Day, Labor Day, Columbus Day, Veterans Day, Thanksgiving, and Christmas.")
        ]),
        UnifiedQuestion(id: "q_25_127", correctAnswer: 2, variants: [
            .init(text: "What is Memorial Day?",
                  options: ["A holiday to honor veterans still living", "A holiday to celebrate independence", "A holiday to honor soldiers who died in military service", "A holiday for state founders"],
                  explanation: "Memorial Day (last Monday in May) honors U.S. military service members who died in service to their country.")
        ]),
        UnifiedQuestion(id: "q_25_128", correctAnswer: 1, variants: [
            .init(text: "What is Veterans Day?",
                  options: ["A holiday for active military only", "A holiday to honor people who have served in the U.S. military", "A holiday for fallen soldiers only", "A holiday for new immigrants"],
                  explanation: "Veterans Day (November 11) honors all people who have served in the U.S. military, both living and deceased.")
        ])
    ]

    // MARK: - Practice 8: 1900s & Modern History (16 questions)
    static let practice8: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_100", correctAnswer: 1, variants: [
            .init(text: "Name one war fought by the United States in the 1900s.",
                  options: ["The Civil War", "World War II (or WWI, Korean War, Vietnam War, Persian Gulf War)", "American Revolution", "War of 1812"],
                  explanation: "U.S. wars in the 1900s include World War I, World War II, the Korean War, the Vietnam War, and the Persian Gulf War.")
        ]),
        UnifiedQuestion(id: "q_25_101", correctAnswer: 1, variants: [
            .init(text: "Why did the United States enter World War I?",
                  options: ["To help Germany", "Because Germany attacked U.S. civilian ships (and to support the Allies)", "To gain new territory", "To stop the spread of communism"],
                  explanation: "The U.S. entered WWI in 1917 because Germany attacked U.S. civilian ships and to support the Allied Powers (England, France, Italy, and Russia).")
        ]),
        UnifiedQuestion(id: "q_25_103", correctAnswer: 1, variants: [
            .init(text: "What was the Great Depression?",
                  options: ["A war fought in the 1930s", "The longest economic recession in modern history", "A famous government program", "A presidential election"],
                  explanation: "The Great Depression was the longest and deepest economic recession in modern history, with mass unemployment and bank failures throughout the 1930s.")
        ]),
        UnifiedQuestion(id: "q_25_104", correctAnswer: 1, variants: [
            .init(text: "When did the Great Depression start?",
                  options: ["With World War I (1917)", "With the Great Crash of 1929 (stock market crash)", "After World War II (1945)", "1933"],
                  explanation: "The Great Depression began with the stock market crash of October 1929 (the Great Crash), and lasted until the early 1940s.")
        ]),
        UnifiedQuestion(id: "q_25_105", correctAnswer: 1, variants: [
            .init(text: "Who was president during the Great Depression and World War II?",
                  options: ["Theodore Roosevelt", "Franklin D. Roosevelt (FDR)", "Harry Truman", "Herbert Hoover"],
                  explanation: "Franklin D. Roosevelt (FDR) served as President from 1933 until his death in 1945. He led the New Deal response to the Depression and led the U.S. through most of WWII.")
        ]),
        UnifiedQuestion(id: "q_25_106", correctAnswer: 1, variants: [
            .init(text: "Why did the United States enter World War II?",
                  options: ["To help Germany", "Because Japan bombed Pearl Harbor", "To gain new colonies", "To establish trade routes"],
                  explanation: "The U.S. entered WWII after Japan attacked Pearl Harbor on December 7, 1941. The U.S. then joined the Allied Powers against the Axis Powers.")
        ]),
        UnifiedQuestion(id: "q_25_107", correctAnswer: 1, variants: [
            .init(text: "Dwight Eisenhower is famous for many things. Name one.",
                  options: ["Founded Microsoft", "General during World War II and 34th President", "Wrote the Constitution", "Discovered penicillin"],
                  explanation: "Eisenhower was a top general in WWII (commanded D-Day), the 34th President (1953-61), president when the Korean War ended, and signed the law creating the Interstate Highway System.")
        ]),
        UnifiedQuestion(id: "q_25_108", correctAnswer: 2, variants: [
            .init(text: "Who was the United States' main rival during the Cold War?",
                  options: ["Germany", "China", "The Soviet Union (USSR)", "Japan"],
                  explanation: "The Soviet Union (USSR) was the main U.S. rival during the Cold War (1947-1991), a period of geopolitical tension without direct military conflict.")
        ]),
        UnifiedQuestion(id: "q_25_109", correctAnswer: 1, variants: [
            .init(text: "During the Cold War, what was one main concern of the United States?",
                  options: ["Trade deficits", "Communism (and nuclear war)", "Immigration", "Energy independence"],
                  explanation: "Main U.S. concerns during the Cold War were the spread of communism and the threat of nuclear war between the superpowers.")
        ]),
        UnifiedQuestion(id: "q_25_110", correctAnswer: 1, variants: [
            .init(text: "Why did the United States enter the Korean War?",
                  options: ["To gain Korean territory", "To stop the spread of communism", "To support the Korean monarchy", "To rescue American hostages"],
                  explanation: "The U.S. entered the Korean War (1950-53) to stop the spread of communism after North Korea (communist) invaded South Korea.")
        ]),
        UnifiedQuestion(id: "q_25_111", correctAnswer: 1, variants: [
            .init(text: "Why did the United States enter the Vietnam War?",
                  options: ["To gain Vietnamese territory", "To stop the spread of communism", "To establish a U.S. naval base", "To enforce a trade agreement"],
                  explanation: "The U.S. entered the Vietnam War (1955-75) to stop the spread of communism in Southeast Asia.")
        ]),
        UnifiedQuestion(id: "q_25_112", correctAnswer: 1, variants: [
            .init(text: "What did the civil rights movement do?",
                  options: ["Won the right to vote for women", "Fought to end racial discrimination", "Brought independence from Britain", "Established Social Security"],
                  explanation: "The civil rights movement (1950s-1960s) fought to end racial discrimination and segregation. It led to the Civil Rights Act of 1964 and Voting Rights Act of 1965.")
        ]),
        UnifiedQuestion(id: "q_25_113", correctAnswer: 1, variants: [
            .init(text: "Martin Luther King, Jr. is famous for many things. Name one.",
                  options: ["Invented the airplane", "Fought for civil rights and equality for all Americans", "First African American President", "Wrote the Declaration of Independence"],
                  explanation: "Dr. King fought for civil rights using nonviolent methods, worked for equality, and delivered the famous \"I Have a Dream\" speech. He was awarded the Nobel Peace Prize in 1964.")
        ]),
        UnifiedQuestion(id: "q_25_114", correctAnswer: 1, variants: [
            .init(text: "Why did the United States enter the Persian Gulf War?",
                  options: ["To support Iraq", "To force the Iraqi military from Kuwait", "To establish a U.S. embassy", "To rescue American tourists"],
                  explanation: "The U.S. led an international coalition in the Persian Gulf War (1990-91) to force the Iraqi military out of Kuwait, which Iraq had invaded.")
        ]),
        UnifiedQuestion(id: "q_25_115", correctAnswer: 1, variants: [
            .init(text: "What major event happened on September 11, 2001 in the United States?",
                  options: ["A presidential election", "Terrorists attacked the United States", "A natural disaster", "A peace agreement was signed"],
                  explanation: "On 9/11, terrorists hijacked four planes, crashing two into the World Trade Center, one into the Pentagon, and one in a Pennsylvania field. Nearly 3,000 people died.")
        ]),
        UnifiedQuestion(id: "q_25_116", correctAnswer: 2, variants: [
            .init(text: "Name one U.S. military conflict after the September 11, 2001 attacks.",
                  options: ["The Korean War", "The Vietnam War", "The War in Afghanistan (or War in Iraq, War on Terror)", "The Civil War"],
                  explanation: "U.S. conflicts after 9/11 include the Global War on Terror, the War in Afghanistan (2001-2021), and the War in Iraq (2003-2011).")
        ])
    ]
}
