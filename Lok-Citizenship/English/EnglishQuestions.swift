import Foundation

/// All English quiz question sets, grouped by difficulty level.
/// Each set has 15 questions with 1 variant (English only).
enum EnglishQuestions {
    static let practice1: [UnifiedQuestion] = [
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What is the supreme law of the land?", options: ["The Bill of Rights", "The Declaration", "The Constitution", "The Articles"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "Who makes federal laws?", options: ["The President", "Congress", "The Supreme Court", "The Military"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What are the two parts of the U.S. Congress?", options: ["The Senate and The House", "The House and The President", "The Cabinet", "The Military"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What is the capital of the United States?", options: ["New York", "Washington D.C.", "Los Angeles", "Chicago"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What are the two major political parties?", options: ["Democrats and Libertarians", "Federalists and Republicans", "Libertarians and Tories", "Democrats and Republicans"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What color are the stars on the American flag?", options: ["Blue", "White", "Red", "Yellow"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "How many states are there in the United States?", options: ["51", "49", "50", "52"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What is the name of the President of the United States?", options: ["Donald J Trump", "George Bush", "Barack Obama", "Joe Biden"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What is the name of the Vice President of the United States?", options: ["Kamala Harris", "Mike Pence", "Nancy Pelosi", "JD Vance"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What is one right in the First Amendment?", options: ["Freedom to travel", "Right to vote", "Freedom of speech", "Right to education"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What do we celebrate on July 4th?", options: ["Memorial Day", "Independence Day", "Labor Day", "Thanksgiving"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "Who is the Commander in Chief of the military?", options: ["The President", "The Vice President", "The Senate", "The Supreme Court"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What is the name of the national anthem?", options: ["This Land is Your Land", "God Bless America", "America the Beautiful", "The Star-Spangled Banner"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What do the 13 stripes on the flag represent?", options: ["The 13 amendments", "The number of wars", "The 13 states", "The original 13 colonies"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What is the highest court in the United States?", options: ["The Supreme Court", "The Federal Court", "The Court of Appeals", "The Civil Court"])
        ])
    ]

    static let practice2: [UnifiedQuestion] = [
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "Who wrote the Declaration of Independence?", options: ["George Washington", "Abraham Lincoln", "Benjamin Franklin", "Thomas Jefferson"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "How many U.S. Senators are there?", options: ["50", "100", "435", "200"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "How long is a term for a U.S. Senator?", options: ["4 years", "2 years", "6 years", "8 years"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What is one responsibility of a U.S. citizen?", options: ["Vote in elections", "Own a business", "Pay for health insurance", "Travel abroad"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "Who is the Father of Our Country?", options: ["George Washington", "Thomas Jefferson", "Abraham Lincoln", "John Adams"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What is one promise you make when you become a U.S. citizen?", options: ["Speak only English", "Always vote in elections", "Get a college degree", "Obey the laws of the United States"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What ocean is on the West Coast of the United States?", options: ["Atlantic Ocean", "Pacific Ocean", "Indian Ocean", "Arctic Ocean"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What is the economic system in the United States?", options: ["Socialism", "Communism", "Capitalism", "Monarchy"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "How many voting members are in the House of Representatives?", options: ["435", "100", "50", "200"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What is the rule of law?", options: ["Everyone must follow the law", "The President is above the law", "Judges are above the law", "Only lawmakers follow the law"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What is freedom of religion?", options: ["You can only practice major religions", "You must follow the government religion", "You can practice any religion, or not practice a religion", "You can never change your religion"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What does the Constitution do?", options: ["Gives advice to the President", "Defines laws for voting", "Declares war", "Sets up the government"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What stops one branch of government from becoming too powerful?", options: ["The Supreme Court", "The military", "The people", "Checks and balances"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "Name one branch or part of the government.", options: ["Congress", "Lawmakers", "Governors", "The Police"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What is an amendment?", options: ["A law", "A change to the Constitution", "A government branch", "A tax"])
        ])
    ]

    static let practice3: [UnifiedQuestion] = [
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What do we call the first ten amendments to the Constitution?", options: ["The Federalist Papers", "The Declaration of Independence", "The Articles of Confederation", "The Bill of Rights"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What is the capital of your state?", options: ["Depends on your state", "New York", "Los Angeles", "Chicago"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "Who was the first President of the United States?", options: ["John Adams", "Thomas Jefferson", "George Washington", "Benjamin Franklin"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What did the Emancipation Proclamation do?", options: ["Ended the Civil War", "Freed the slaves", "Established a national bank", "Declared independence from Britain"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "Who is the Speaker of the House of Representatives now?", options: ["Nancy Pelosi", "Kevin McCarthy", "Mitch McConnell", "Mike Johnson"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "How many justices are on the Supreme Court?", options: ["7", "11", "9", "13"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What did Susan B. Anthony do?", options: ["Fought for women's rights", "Wrote the Constitution", "Discovered America", "Became the first female President"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What movement tried to end racial discrimination?", options: ["The Civil Rights Movement", "The Women's Movement", "The American Revolution", "The Abolitionist Movement"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What was one important thing that Abraham Lincoln did?", options: ["Established the U.S. Navy", "Freed the slaves", "Fought in the Revolutionary War", "Wrote the Bill of Rights"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "Why does the U.S. flag have 50 stars?", options: ["For the 50 Presidents", "For the 50 years of independence", "For the 50 amendments", "For the 50 states"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "When do we vote for President?", options: ["January", "March", "November", "December"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What is one reason colonists came to America?", options: ["To escape taxes", "To practice their religion freely", "To join the military", "To find gold"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "Who wrote the Federalist Papers?", options: ["Thomas Jefferson", "James Madison, Alexander Hamilton, John Jay", "George Washington", "Ben Franklin"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "Who was the President during World War I?", options: ["Harry Truman", "Woodrow Wilson", "Franklin D. Roosevelt", "Dwight D. Eisenhower"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What is one U.S. territory?", options: ["Alaska", "Puerto Rico", "Hawaii", "Canada"])
        ])
    ]

    static let practice4: [UnifiedQuestion] = [
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What was the main purpose of the Federalist Papers?", options: ["To declare independence from Britain", "To promote the ratification of the U.S. Constitution", "To outline the Bill of Rights", "To establish a national bank"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "Which amendment abolished slavery?", options: ["13th Amendment", "14th Amendment", "15th Amendment", "19th Amendment"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What landmark case established judicial review?", options: ["Marbury v. Madison", "Brown v. Board of Education", "Roe v. Wade", "McCulloch v. Maryland"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What is the maximum number of years a President can serve?", options: ["4 years", "12 years", "2 years", "8 years"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What war was fought between the North and South in the U.S.?", options: ["Revolutionary War", "World War I", "The Civil War", "The War of 1812"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What was the main reason the U.S. entered World War II?", options: ["To support Britain and France", "To stop the spread of communism", "The attack on Pearl Harbor", "To defend against Germany"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What did the Monroe Doctrine declare?", options: ["Europe should not interfere in the Americas", "Slavery is abolished", "The U.S. must remain neutral in global conflicts", "The Louisiana Purchase is legal"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "Which U.S. President served more than two terms?", options: ["George Washington", "Franklin D. Roosevelt", "Theodore Roosevelt", "Dwight D. Eisenhower"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What is the term length for a Supreme Court Justice?", options: ["4 years", "8 years", "12 years", "Life"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "Who is the Chief Justice of the Supreme Court?", options: ["John Roberts", "Clarence Thomas", "Sonia Sotomayor", "Amy Coney Barrett"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "Which branch of government has the power to declare war?", options: ["The President", "The Supreme Court", "Congress", "The Vice President"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What was the purpose of the Marshall Plan?", options: ["To rebuild Europe after World War II", "To prevent communism in the U.S.", "To provide U.S. military aid", "To negotiate peace with Japan"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "Which constitutional amendment granted women the right to vote?", options: ["15th Amendment", "19th Amendment", "21st Amendment", "26th Amendment"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "Which U.S. state was an independent republic before joining the Union?", options: ["Hawaii", "California", "Texas", "Alaska"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "Who was President during the Great Depression and World War II?", options: ["Woodrow Wilson", "Herbert Hoover", "Franklin D. Roosevelt", "Harry Truman"])
        ])
    ]

    static let practice5: [UnifiedQuestion] = [
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "The House of Representatives has how many voting members?", options: ["100", "435", "50", "200"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "If both the President and the Vice President can no longer serve, who becomes President?", options: ["The Speaker of the House", "The Chief Justice", "The Secretary of State", "The Senate Majority Leader"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "Under the Constitution, some powers belong to the federal government. What is one power of the federal government?", options: ["To issue driver's licenses", "To create an army", "To set up schools", "To regulate marriages"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "Under our Constitution, some powers belong to the states. What is one power of the states?", options: ["To make treaties", "To create an army", "To print money", "Establish and run public schools"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "Who is the Commander in Chief of the military?", options: ["The President", "The Vice President", "The Secretary of Defense", "The Speaker of the House"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What are two rights in the Declaration of Independence?", options: ["Right to bear arms & right to vote", "Right to work & right to protest", "Life and Liberty", "Freedom of speech & freedom of religion"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What is the 'rule of law'?", options: ["The government can ignore laws", "No one is above the law", "Only federal judges follow the law", "The Constitution is not legally binding"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What does the judicial branch do?", options: ["Makes laws", "Controls the military", "Elects the President", "Interprets the law"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "There are four amendments to the Constitution about who can vote. Describe one of them.", options: ["Only landowners can vote", "Only white men can vote", "Citizens 18 and older can vote", "Voting is mandatory"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "Why do some states have more Representatives than other states?", options: ["Because they are bigger", "Because they have more people", "Because they were part of the original 13 colonies", "Because they have more senators"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What was the main concern of the United States during the Cold War?", options: ["Nuclear disarmament", "Terrorism", "Communism", "World War III"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What major event happened on September 11, 2001, in the United States?", options: ["Terrorists attacked the United States", "The U.S. declared war on Iraq", "The Great Recession began", "Hurricane Katrina struck"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What are two rights of everyone living in the United States?", options: ["Right to vote & right to work", "Right to drive & right to a free education", "Right to own land & right to healthcare", "Freedom of speech & freedom of religion"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What did the Civil Rights Movement do?", options: ["Fought for women's rights", "Fought for the end of segregation and racial discrimination", "Fought for U.S. independence", "Fought for workers' rights"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What is one promise you make when you become a U.S. citizen?", options: ["To always vote", "To support your birth country", "To obey U.S. laws", "To join the U.S. military"])
        ])
    ]
}
