import Foundation

/// All English quiz question sets, grouped by difficulty level.
/// Each set has 15 questions with 1 variant (English only).
enum EnglishQuestions {
    static let practice1: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_1_01", correctAnswer: 2, variants: [
            .init(text: "What is the supreme law of the land?", options: ["The Bill of Rights", "The Declaration", "The Constitution", "The Articles"], explanation: "The Constitution is the supreme law because it establishes the framework of government and overrides all other laws.")
        ]),
        UnifiedQuestion(id: "q_1_02", correctAnswer: 1, variants: [
            .init(text: "Who makes federal laws?", options: ["The President", "Congress", "The Supreme Court", "The Military"], explanation: "Congress (the Senate and House of Representatives) is the legislative branch responsible for making federal laws.")
        ]),
        UnifiedQuestion(id: "q_1_03", correctAnswer: 0, variants: [
            .init(text: "What are the two parts of the U.S. Congress?", options: ["The Senate and The House", "The House and The President", "The Cabinet", "The Military"], explanation: "Congress is made up of the Senate (100 members) and the House of Representatives (435 members).")
        ]),
        UnifiedQuestion(id: "q_1_04", correctAnswer: 1, variants: [
            .init(text: "What is the capital of the United States?", options: ["New York", "Washington D.C.", "Los Angeles", "Chicago"], explanation: "Washington D.C. has been the capital since 1790. It was named after George Washington.")
        ]),
        UnifiedQuestion(id: "q_1_05", correctAnswer: 3, variants: [
            .init(text: "What are the two major political parties?", options: ["Democrats and Libertarians", "Federalists and Republicans", "Libertarians and Tories", "Democrats and Republicans"], explanation: "The Democratic Party and the Republican Party have been the two major parties since the mid-1800s.")
        ]),
        UnifiedQuestion(id: "q_1_06", correctAnswer: 1, variants: [
            .init(text: "What color are the stars on the American flag?", options: ["Blue", "White", "Red", "Yellow"], explanation: "The 50 white stars on the blue field represent the 50 states of the Union.")
        ]),
        UnifiedQuestion(id: "q_1_07", correctAnswer: 2, variants: [
            .init(text: "How many states are there in the United States?", options: ["51", "49", "50", "52"], explanation: "There are 50 states. Hawaii was the last to join in 1959.")
        ]),
        UnifiedQuestion(id: "q_1_08", correctAnswer: 0, variants: [
            .init(text: "What is the name of the President of the United States?", options: ["Donald J Trump", "George Bush", "Barack Obama", "Joe Biden"], explanation: "The current President is Donald J. Trump, serving his second term beginning January 2025.")
        ]),
        UnifiedQuestion(id: "q_1_09", correctAnswer: 3, variants: [
            .init(text: "What is the name of the Vice President of the United States?", options: ["Kamala Harris", "Mike Pence", "Nancy Pelosi", "JD Vance"], explanation: "JD Vance became Vice President in January 2025.")
        ]),
        UnifiedQuestion(id: "q_1_10", correctAnswer: 2, variants: [
            .init(text: "What is one right in the First Amendment?", options: ["Freedom to travel", "Right to vote", "Freedom of speech", "Right to education"], explanation: "The First Amendment protects freedom of speech, religion, press, assembly, and the right to petition the government.")
        ]),
        UnifiedQuestion(id: "q_1_11", correctAnswer: 1, variants: [
            .init(text: "What do we celebrate on July 4th?", options: ["Memorial Day", "Independence Day", "Labor Day", "Thanksgiving"], explanation: "July 4th celebrates the adoption of the Declaration of Independence in 1776.")
        ]),
        UnifiedQuestion(id: "q_1_12", correctAnswer: 0, variants: [
            .init(text: "Who is the Commander in Chief of the military?", options: ["The President", "The Vice President", "The Senate", "The Supreme Court"], explanation: "The Constitution makes the President the Commander in Chief of all U.S. armed forces.")
        ]),
        UnifiedQuestion(id: "q_1_13", correctAnswer: 3, variants: [
            .init(text: "What is the name of the national anthem?", options: ["This Land is Your Land", "God Bless America", "America the Beautiful", "The Star-Spangled Banner"], explanation: "\"The Star-Spangled Banner\" was written by Francis Scott Key in 1814 and became the national anthem in 1931.")
        ]),
        UnifiedQuestion(id: "q_1_14", correctAnswer: 3, variants: [
            .init(text: "What do the 13 stripes on the flag represent?", options: ["The 13 amendments", "The number of wars", "The 13 states", "The original 13 colonies"], explanation: "The 13 stripes represent the original 13 colonies that declared independence and became the first states.")
        ]),
        UnifiedQuestion(id: "q_1_15", correctAnswer: 0, variants: [
            .init(text: "What is the highest court in the United States?", options: ["The Supreme Court", "The Federal Court", "The Court of Appeals", "The Civil Court"], explanation: "The Supreme Court is the highest court and has the final say on interpreting the Constitution.")
        ])
    ]

    static let practice2: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_2_01", correctAnswer: 3, variants: [
            .init(text: "Who wrote the Declaration of Independence?", options: ["George Washington", "Abraham Lincoln", "Benjamin Franklin", "Thomas Jefferson"], explanation: "Thomas Jefferson drafted the Declaration of Independence in 1776 at age 33.")
        ]),
        UnifiedQuestion(id: "q_2_02", correctAnswer: 1, variants: [
            .init(text: "How many U.S. Senators are there?", options: ["50", "100", "435", "200"], explanation: "There are 100 Senators — two from each of the 50 states — ensuring equal representation.")
        ]),
        UnifiedQuestion(id: "q_2_03", correctAnswer: 2, variants: [
            .init(text: "How long is a term for a U.S. Senator?", options: ["4 years", "2 years", "6 years", "8 years"], explanation: "Senators serve 6-year terms, with about one-third up for election every two years.")
        ]),
        UnifiedQuestion(id: "q_2_04", correctAnswer: 0, variants: [
            .init(text: "What is one responsibility of a U.S. citizen?", options: ["Vote in elections", "Own a business", "Pay for health insurance", "Travel abroad"], explanation: "Voting is both a right and a civic responsibility that allows citizens to choose their leaders.")
        ]),
        UnifiedQuestion(id: "q_2_05", correctAnswer: 0, variants: [
            .init(text: "Who is the Father of Our Country?", options: ["George Washington", "Thomas Jefferson", "Abraham Lincoln", "John Adams"], explanation: "George Washington is called the Father of Our Country because he led the Revolutionary War and was the first President.")
        ]),
        UnifiedQuestion(id: "q_2_06", correctAnswer: 3, variants: [
            .init(text: "What is one promise you make when you become a U.S. citizen?", options: ["Speak only English", "Always vote in elections", "Get a college degree", "Obey the laws of the United States"], explanation: "The Oath of Allegiance includes a promise to obey U.S. laws and support the Constitution.")
        ]),
        UnifiedQuestion(id: "q_2_07", correctAnswer: 1, variants: [
            .init(text: "What ocean is on the West Coast of the United States?", options: ["Atlantic Ocean", "Pacific Ocean", "Indian Ocean", "Arctic Ocean"], explanation: "The Pacific Ocean borders the western states including California, Oregon, and Washington.")
        ]),
        UnifiedQuestion(id: "q_2_08", correctAnswer: 2, variants: [
            .init(text: "What is the economic system in the United States?", options: ["Socialism", "Communism", "Capitalism", "Monarchy"], explanation: "The U.S. has a capitalist (free market) economy where private businesses operate with limited government control.")
        ]),
        UnifiedQuestion(id: "q_2_09", correctAnswer: 0, variants: [
            .init(text: "How many voting members are in the House of Representatives?", options: ["435", "100", "50", "200"], explanation: "The House has 435 voting members, with seats distributed among states based on population.")
        ]),
        UnifiedQuestion(id: "q_2_10", correctAnswer: 0, variants: [
            .init(text: "What is the rule of law?", options: ["Everyone must follow the law", "The President is above the law", "Judges are above the law", "Only lawmakers follow the law"], explanation: "The rule of law means that no one, including government leaders, is above the law.")
        ]),
        UnifiedQuestion(id: "q_2_11", correctAnswer: 2, variants: [
            .init(text: "What is freedom of religion?", options: ["You can only practice major religions", "You must follow the government religion", "You can practice any religion, or not practice a religion", "You can never change your religion"], explanation: "The First Amendment guarantees that the government cannot establish a religion or prohibit religious practice.")
        ]),
        UnifiedQuestion(id: "q_2_12", correctAnswer: 3, variants: [
            .init(text: "What does the Constitution do?", options: ["Gives advice to the President", "Defines laws for voting", "Declares war", "Sets up the government"], explanation: "The Constitution establishes the structure of government, defines its powers, and protects the rights of the people.")
        ]),
        UnifiedQuestion(id: "q_2_13", correctAnswer: 3, variants: [
            .init(text: "What stops one branch of government from becoming too powerful?", options: ["The Supreme Court", "The military", "The people", "Checks and balances"], explanation: "Checks and balances give each branch the power to limit the others, preventing any single branch from dominating.")
        ]),
        UnifiedQuestion(id: "q_2_14", correctAnswer: 0, variants: [
            .init(text: "Name one branch or part of the government.", options: ["Congress", "Lawmakers", "Governors", "The Police"], explanation: "The three branches are: Congress (legislative), the President (executive), and the courts (judicial).")
        ]),
        UnifiedQuestion(id: "q_2_15", correctAnswer: 1, variants: [
            .init(text: "What is an amendment?", options: ["A law", "A change to the Constitution", "A government branch", "A tax"], explanation: "An amendment is a formal change or addition to the Constitution. There have been 27 amendments so far.")
        ])
    ]

    static let practice3: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_3_01", correctAnswer: 3, variants: [
            .init(text: "What do we call the first ten amendments to the Constitution?", options: ["The Federalist Papers", "The Declaration of Independence", "The Articles of Confederation", "The Bill of Rights"], explanation: "The Bill of Rights was ratified in 1791 and protects fundamental freedoms like speech, religion, and due process.")
        ]),
        UnifiedQuestion(id: "q_3_02", correctAnswer: 0, variants: [
            .init(text: "What is the capital of your state?", options: ["Depends on your state", "New York", "Los Angeles", "Chicago"], explanation: "Each state has its own capital city where the state government is located. Know your state's capital for the interview.")
        ]),
        UnifiedQuestion(id: "q_3_03", correctAnswer: 2, variants: [
            .init(text: "Who was the first President of the United States?", options: ["John Adams", "Thomas Jefferson", "George Washington", "Benjamin Franklin"], explanation: "George Washington served as President from 1789 to 1797 and set many precedents for the office.")
        ]),
        UnifiedQuestion(id: "q_3_04", correctAnswer: 1, variants: [
            .init(text: "What did the Emancipation Proclamation do?", options: ["Ended the Civil War", "Freed the slaves", "Established a national bank", "Declared independence from Britain"], explanation: "President Lincoln's Emancipation Proclamation of 1863 declared slaves in Confederate states to be free.")
        ]),
        UnifiedQuestion(id: "q_3_05", correctAnswer: 3, variants: [
            .init(text: "Who is the Speaker of the House of Representatives now?", options: ["Nancy Pelosi", "Kevin McCarthy", "Mitch McConnell", "Mike Johnson"], explanation: "The Speaker of the House is elected by House members and is second in the presidential line of succession.")
        ]),
        UnifiedQuestion(id: "q_3_06", correctAnswer: 2, variants: [
            .init(text: "How many justices are on the Supreme Court?", options: ["7", "11", "9", "13"], explanation: "The Supreme Court has had 9 justices since 1869: one Chief Justice and eight Associate Justices.")
        ]),
        UnifiedQuestion(id: "q_3_07", correctAnswer: 0, variants: [
            .init(text: "What did Susan B. Anthony do?", options: ["Fought for women's rights", "Wrote the Constitution", "Discovered America", "Became the first female President"], explanation: "Susan B. Anthony was a leader in the women's suffrage movement, helping women win the right to vote.")
        ]),
        UnifiedQuestion(id: "q_3_08", correctAnswer: 0, variants: [
            .init(text: "What movement tried to end racial discrimination?", options: ["The Civil Rights Movement", "The Women's Movement", "The American Revolution", "The Abolitionist Movement"], explanation: "The Civil Rights Movement of the 1950s-60s fought to end segregation and ensure equal rights for all races.")
        ]),
        UnifiedQuestion(id: "q_3_09", correctAnswer: 1, variants: [
            .init(text: "What was one important thing that Abraham Lincoln did?", options: ["Established the U.S. Navy", "Freed the slaves", "Fought in the Revolutionary War", "Wrote the Bill of Rights"], explanation: "Abraham Lincoln preserved the Union during the Civil War and issued the Emancipation Proclamation freeing slaves.")
        ]),
        UnifiedQuestion(id: "q_3_10", correctAnswer: 3, variants: [
            .init(text: "Why does the U.S. flag have 50 stars?", options: ["For the 50 Presidents", "For the 50 years of independence", "For the 50 amendments", "For the 50 states"], explanation: "Each star represents one of the 50 states. The flag gets a new star when a new state joins the Union.")
        ]),
        UnifiedQuestion(id: "q_3_11", correctAnswer: 2, variants: [
            .init(text: "When do we vote for President?", options: ["January", "March", "November", "December"], explanation: "Presidential elections are held on the first Tuesday after the first Monday in November every four years.")
        ]),
        UnifiedQuestion(id: "q_3_12", correctAnswer: 1, variants: [
            .init(text: "What is one reason colonists came to America?", options: ["To escape taxes", "To practice their religion freely", "To join the military", "To find gold"], explanation: "Many colonists came seeking religious freedom, escaping persecution in their home countries.")
        ]),
        UnifiedQuestion(id: "q_3_13", correctAnswer: 1, variants: [
            .init(text: "Who wrote the Federalist Papers?", options: ["Thomas Jefferson", "James Madison, Alexander Hamilton, John Jay", "George Washington", "Ben Franklin"], explanation: "The Federalist Papers were 85 essays written to persuade New York to ratify the Constitution.")
        ]),
        UnifiedQuestion(id: "q_3_14", correctAnswer: 1, variants: [
            .init(text: "Who was the President during World War I?", options: ["Harry Truman", "Woodrow Wilson", "Franklin D. Roosevelt", "Dwight D. Eisenhower"], explanation: "Woodrow Wilson led the U.S. during WWI (1917-1918) and later proposed the League of Nations.")
        ]),
        UnifiedQuestion(id: "q_3_15", correctAnswer: 1, variants: [
            .init(text: "What is one U.S. territory?", options: ["Alaska", "Puerto Rico", "Hawaii", "Canada"], explanation: "U.S. territories include Puerto Rico, Guam, U.S. Virgin Islands, American Samoa, and Northern Mariana Islands.")
        ])
    ]

    static let practice4: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_4_01", correctAnswer: 1, variants: [
            .init(text: "What was the main purpose of the Federalist Papers?", options: ["To declare independence from Britain", "To promote the ratification of the U.S. Constitution", "To outline the Bill of Rights", "To establish a national bank"], explanation: "The Federalist Papers argued for ratifying the Constitution by explaining how the new government would work.")
        ]),
        UnifiedQuestion(id: "q_4_02", correctAnswer: 0, variants: [
            .init(text: "Which amendment abolished slavery?", options: ["13th Amendment", "14th Amendment", "15th Amendment", "19th Amendment"], explanation: "The 13th Amendment (1865) abolished slavery throughout the United States after the Civil War.")
        ]),
        UnifiedQuestion(id: "q_4_03", correctAnswer: 0, variants: [
            .init(text: "What landmark case established judicial review?", options: ["Marbury v. Madison", "Brown v. Board of Education", "Roe v. Wade", "McCulloch v. Maryland"], explanation: "Marbury v. Madison (1803) established that the Supreme Court can declare laws unconstitutional.")
        ]),
        UnifiedQuestion(id: "q_4_04", correctAnswer: 3, variants: [
            .init(text: "How many years can a President serve in total?", options: ["4 years", "12 years", "2 years", "8 years"], explanation: "The 22nd Amendment limits Presidents to two 4-year terms, for a maximum of 8 years in office.")
        ]),
        UnifiedQuestion(id: "q_4_05", correctAnswer: 2, variants: [
            .init(text: "What war was fought between the North and South in the U.S.?", options: ["Revolutionary War", "World War I", "The Civil War", "The War of 1812"], explanation: "The Civil War (1861-1865) was fought over slavery and states' rights, resulting in the Union's preservation.")
        ]),
        UnifiedQuestion(id: "q_4_06", correctAnswer: 2, variants: [
            .init(text: "What was the main reason the U.S. entered World War II?", options: ["To support Britain and France", "To stop the spread of communism", "The attack on Pearl Harbor", "To defend against Germany"], explanation: "Japan's surprise attack on Pearl Harbor on December 7, 1941 led the U.S. to enter World War II.")
        ]),
        UnifiedQuestion(id: "q_4_07", correctAnswer: 0, variants: [
            .init(text: "What did the Monroe Doctrine declare?", options: ["Europe should not interfere in the Americas", "Slavery is abolished", "The U.S. must remain neutral in global conflicts", "The Louisiana Purchase is legal"], explanation: "The Monroe Doctrine (1823) warned European nations against further colonization in the Western Hemisphere.")
        ]),
        UnifiedQuestion(id: "q_4_08", correctAnswer: 1, variants: [
            .init(text: "Which U.S. President served more than two terms?", options: ["George Washington", "Franklin D. Roosevelt", "Theodore Roosevelt", "Dwight D. Eisenhower"], explanation: "FDR served four terms (1933-1945), the only President to do so. The 22nd Amendment later limited terms to two.")
        ]),
        UnifiedQuestion(id: "q_4_09", correctAnswer: 3, variants: [
            .init(text: "What is the term length for a Supreme Court Justice?", options: ["4 years", "8 years", "12 years", "Life"], explanation: "Supreme Court Justices serve life terms to insulate them from political pressure and protect judicial independence.")
        ]),
        UnifiedQuestion(id: "q_4_10", correctAnswer: 0, variants: [
            .init(text: "Who is the Chief Justice of the Supreme Court?", options: ["John Roberts", "Clarence Thomas", "Sonia Sotomayor", "Amy Coney Barrett"], explanation: "John Roberts has served as Chief Justice since 2005, presiding over the Supreme Court.")
        ]),
        UnifiedQuestion(id: "q_4_11", correctAnswer: 2, variants: [
            .init(text: "Which branch of government has the power to declare war?", options: ["The President", "The Supreme Court", "Congress", "The Vice President"], explanation: "Only Congress can formally declare war, though the President can deploy troops as Commander in Chief.")
        ]),
        UnifiedQuestion(id: "q_4_12", correctAnswer: 0, variants: [
            .init(text: "What was the purpose of the Marshall Plan?", options: ["To rebuild Europe after World War II", "To prevent communism in the U.S.", "To provide U.S. military aid", "To negotiate peace with Japan"], explanation: "The Marshall Plan (1948) provided $13 billion in aid to rebuild Western European economies after WWII.")
        ]),
        UnifiedQuestion(id: "q_4_13", correctAnswer: 1, variants: [
            .init(text: "Which constitutional amendment granted women the right to vote?", options: ["15th Amendment", "19th Amendment", "21st Amendment", "26th Amendment"], explanation: "The 19th Amendment (1920) guaranteed women the right to vote after decades of the suffrage movement.")
        ]),
        UnifiedQuestion(id: "q_4_14", correctAnswer: 2, variants: [
            .init(text: "Which U.S. state was an independent republic before joining the Union?", options: ["Hawaii", "California", "Texas", "Alaska"], explanation: "Texas was an independent republic from 1836 to 1845 before being annexed and becoming a U.S. state.")
        ]),
        UnifiedQuestion(id: "q_4_15", correctAnswer: 2, variants: [
            .init(text: "Who was President during the Great Depression and World War II?", options: ["Woodrow Wilson", "Herbert Hoover", "Franklin D. Roosevelt", "Harry Truman"], explanation: "FDR led the country through the Great Depression with the New Deal and through most of WWII.")
        ])
    ]

    static let practice5: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_5_01", correctAnswer: 1, variants: [
            .init(text: "The House of Representatives has how many voting members?", options: ["100", "435", "50", "200"], explanation: "The House has 435 voting members, apportioned among states based on their population from the census.")
        ]),
        UnifiedQuestion(id: "q_5_02", correctAnswer: 0, variants: [
            .init(text: "If both the President and the Vice President can no longer serve, who becomes President?", options: ["The Speaker of the House", "The Chief Justice", "The Secretary of State", "The Senate Majority Leader"], explanation: "The Speaker of the House is third in the presidential line of succession, after the Vice President.")
        ]),
        UnifiedQuestion(id: "q_5_03", correctAnswer: 1, variants: [
            .init(text: "Under the Constitution, some powers belong to the federal government. What is one power of the federal government?", options: ["To issue driver's licenses", "To create an army", "To set up schools", "To regulate marriages"], explanation: "Federal powers include creating an army, declaring war, printing money, and making treaties.")
        ]),
        UnifiedQuestion(id: "q_5_04", correctAnswer: 3, variants: [
            .init(text: "Under our Constitution, some powers belong to the states. What is one power of the states?", options: ["To make treaties", "To create an army", "To print money", "Establish and run public schools"], explanation: "State powers include providing education, issuing driver's licenses, and establishing local governments.")
        ]),
        UnifiedQuestion(id: "q_5_05", correctAnswer: 0, variants: [
            .init(text: "Who is the Commander in Chief of the military?", options: ["The President", "The Vice President", "The Secretary of Defense", "The Speaker of the House"], explanation: "The President serves as Commander in Chief, giving civilian control over the U.S. military.")
        ]),
        UnifiedQuestion(id: "q_5_06", correctAnswer: 2, variants: [
            .init(text: "What are two rights in the Declaration of Independence?", options: ["Right to bear arms & right to vote", "Right to work & right to protest", "Life and Liberty", "Freedom of speech & freedom of religion"], explanation: "The Declaration states that all people have unalienable rights to life, liberty, and the pursuit of happiness.")
        ]),
        UnifiedQuestion(id: "q_5_07", correctAnswer: 1, variants: [
            .init(text: "What is the 'rule of law'?", options: ["The government can ignore laws", "No one is above the law", "Only federal judges follow the law", "The Constitution is not legally binding"], explanation: "The rule of law means everyone, including government officials, must follow the law equally.")
        ]),
        UnifiedQuestion(id: "q_5_08", correctAnswer: 3, variants: [
            .init(text: "What does the judicial branch do?", options: ["Makes laws", "Controls the military", "Elects the President", "Interprets the law"], explanation: "The judicial branch, led by the Supreme Court, interprets laws and determines if they follow the Constitution.")
        ]),
        UnifiedQuestion(id: "q_5_09", correctAnswer: 2, variants: [
            .init(text: "There are four amendments to the Constitution about who can vote. Describe one of them.", options: ["Only landowners can vote", "Only white men can vote", "Citizens 18 and older can vote", "Voting is mandatory"], explanation: "The 26th Amendment (1971) lowered the voting age to 18. Other voting amendments: 15th, 19th, and 24th.")
        ]),
        UnifiedQuestion(id: "q_5_10", correctAnswer: 1, variants: [
            .init(text: "Why do some states have more Representatives than other states?", options: ["Because they are bigger", "Because they have more people", "Because they were part of the original 13 colonies", "Because they have more senators"], explanation: "House seats are apportioned by population. California has the most (52) while states like Wyoming have just 1.")
        ]),
        UnifiedQuestion(id: "q_5_11", correctAnswer: 2, variants: [
            .init(text: "What was the main concern of the United States during the Cold War?", options: ["Nuclear disarmament", "Terrorism", "Communism", "World War III"], explanation: "The Cold War (1947-1991) was a geopolitical rivalry with the Soviet Union driven by the fear of communism spreading.")
        ]),
        UnifiedQuestion(id: "q_5_12", correctAnswer: 0, variants: [
            .init(text: "What major event happened on September 11, 2001, in the United States?", options: ["Terrorists attacked the United States", "The U.S. declared war on Iraq", "The Great Recession began", "Hurricane Katrina struck"], explanation: "On 9/11, terrorists hijacked planes and attacked the World Trade Center and Pentagon, killing nearly 3,000 people.")
        ]),
        UnifiedQuestion(id: "q_5_13", correctAnswer: 3, variants: [
            .init(text: "What are two rights of everyone living in the United States?", options: ["Right to vote & right to work", "Right to drive & right to a free education", "Right to own land & right to healthcare", "Freedom of speech & freedom of religion"], explanation: "Everyone in the U.S., citizen or not, has rights including freedom of speech, religion, and equal protection under law.")
        ]),
        UnifiedQuestion(id: "q_5_14", correctAnswer: 1, variants: [
            .init(text: "What did the Civil Rights Movement do?", options: ["Fought for women's rights", "Fought for the end of segregation and racial discrimination", "Fought for U.S. independence", "Fought for workers' rights"], explanation: "The Civil Rights Movement ended legal segregation and led to the Civil Rights Act of 1964 and Voting Rights Act of 1965.")
        ]),
        UnifiedQuestion(id: "q_5_15", correctAnswer: 2, variants: [
            .init(text: "What is one promise you make when you become a U.S. citizen?", options: ["To always vote", "To support your birth country", "To obey U.S. laws", "To join the U.S. military"], explanation: "The Oath of Allegiance requires new citizens to support the Constitution and obey U.S. laws.")
        ])
    ]
}
