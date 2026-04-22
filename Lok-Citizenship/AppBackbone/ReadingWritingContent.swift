import Foundation

/// A vocabulary word from the official USCIS reading or writing test word list.
struct ReadingWritingWord: Identifiable {
    let id: String
    let word: String
    let category: String
    let exampleSentence: String
}

/// Official USCIS reading and writing vocabulary for the naturalization test.
enum ReadingWritingContent {

    // MARK: - Reading Vocabulary (~100 words organized by category)

    static let readingVocabulary: [ReadingWritingWord] = [
        // People
        ReadingWritingWord(id: "r_01", word: "Abraham Lincoln", category: "People", exampleSentence: "Abraham Lincoln was the President during the Civil War."),
        ReadingWritingWord(id: "r_02", word: "George Washington", category: "People", exampleSentence: "George Washington was the first President."),

        // Civics
        ReadingWritingWord(id: "r_03", word: "American flag", category: "Civics", exampleSentence: "The American flag has stars and stripes."),
        ReadingWritingWord(id: "r_04", word: "Bill of Rights", category: "Civics", exampleSentence: "The Bill of Rights protects our freedoms."),
        ReadingWritingWord(id: "r_05", word: "capital", category: "Civics", exampleSentence: "Washington, D.C., is the capital of the United States."),
        ReadingWritingWord(id: "r_06", word: "citizen", category: "Civics", exampleSentence: "A citizen of the United States can vote."),
        ReadingWritingWord(id: "r_07", word: "Congress", category: "Civics", exampleSentence: "Congress makes federal laws."),
        ReadingWritingWord(id: "r_08", word: "country", category: "Civics", exampleSentence: "The United States is a large country."),
        ReadingWritingWord(id: "r_09", word: "Father of Our Country", category: "Civics", exampleSentence: "George Washington is the Father of Our Country."),
        ReadingWritingWord(id: "r_10", word: "government", category: "Civics", exampleSentence: "The government is for the people."),
        ReadingWritingWord(id: "r_11", word: "President", category: "Civics", exampleSentence: "The President lives in the White House."),
        ReadingWritingWord(id: "r_12", word: "right", category: "Civics", exampleSentence: "Citizens have the right to vote."),
        ReadingWritingWord(id: "r_13", word: "Senators", category: "Civics", exampleSentence: "There are one hundred Senators in Congress."),
        ReadingWritingWord(id: "r_14", word: "state", category: "Civics", exampleSentence: "Each state has two Senators."),
        ReadingWritingWord(id: "r_15", word: "White House", category: "Civics", exampleSentence: "The President lives in the White House."),
        ReadingWritingWord(id: "r_16", word: "Constitution", category: "Civics", exampleSentence: "The Constitution is the supreme law of the land."),
        ReadingWritingWord(id: "r_17", word: "election", category: "Civics", exampleSentence: "We vote in an election every November."),
        ReadingWritingWord(id: "r_18", word: "freedom", category: "Civics", exampleSentence: "We have freedom of speech in America."),
        ReadingWritingWord(id: "r_19", word: "law", category: "Civics", exampleSentence: "Everyone must obey the law."),
        ReadingWritingWord(id: "r_20", word: "vote", category: "Civics", exampleSentence: "Citizens can vote for the President."),

        // Places
        ReadingWritingWord(id: "r_21", word: "America", category: "Places", exampleSentence: "America is a free country."),
        ReadingWritingWord(id: "r_22", word: "United States", category: "Places", exampleSentence: "The United States has fifty states."),
        ReadingWritingWord(id: "r_23", word: "Washington, D.C.", category: "Places", exampleSentence: "Washington, D.C., is the capital."),

        // Holidays
        ReadingWritingWord(id: "r_24", word: "Presidents' Day", category: "Holidays", exampleSentence: "Presidents' Day is in February."),
        ReadingWritingWord(id: "r_25", word: "Memorial Day", category: "Holidays", exampleSentence: "Memorial Day honors soldiers who died."),
        ReadingWritingWord(id: "r_26", word: "Flag Day", category: "Holidays", exampleSentence: "Flag Day is in June."),
        ReadingWritingWord(id: "r_27", word: "Independence Day", category: "Holidays", exampleSentence: "Independence Day is on July 4th."),
        ReadingWritingWord(id: "r_28", word: "Labor Day", category: "Holidays", exampleSentence: "Labor Day is in September."),
        ReadingWritingWord(id: "r_29", word: "Columbus Day", category: "Holidays", exampleSentence: "Columbus Day is in October."),
        ReadingWritingWord(id: "r_30", word: "Thanksgiving", category: "Holidays", exampleSentence: "Thanksgiving is in November."),

        // Question Words
        ReadingWritingWord(id: "r_31", word: "How", category: "Question Words", exampleSentence: "How many states are in the United States?"),
        ReadingWritingWord(id: "r_32", word: "What", category: "Question Words", exampleSentence: "What is the capital of the United States?"),
        ReadingWritingWord(id: "r_33", word: "When", category: "Question Words", exampleSentence: "When is Independence Day?"),
        ReadingWritingWord(id: "r_34", word: "Where", category: "Question Words", exampleSentence: "Where does the President live?"),
        ReadingWritingWord(id: "r_35", word: "Who", category: "Question Words", exampleSentence: "Who was the first President?"),
        ReadingWritingWord(id: "r_36", word: "Why", category: "Question Words", exampleSentence: "Why do we have the Bill of Rights?"),

        // Verbs
        ReadingWritingWord(id: "r_37", word: "can", category: "Verbs", exampleSentence: "Citizens can vote in elections."),
        ReadingWritingWord(id: "r_38", word: "come", category: "Verbs", exampleSentence: "People come to America for freedom."),
        ReadingWritingWord(id: "r_39", word: "do", category: "Verbs", exampleSentence: "What do we pay to the government?"),
        ReadingWritingWord(id: "r_40", word: "elect", category: "Verbs", exampleSentence: "Citizens elect the President."),
        ReadingWritingWord(id: "r_41", word: "have", category: "Verbs", exampleSentence: "We have freedom of speech."),
        ReadingWritingWord(id: "r_42", word: "is", category: "Verbs", exampleSentence: "The flag is red, white, and blue."),
        ReadingWritingWord(id: "r_43", word: "lives", category: "Verbs", exampleSentence: "The President lives in the White House."),
        ReadingWritingWord(id: "r_44", word: "meet", category: "Verbs", exampleSentence: "Congress meets in Washington, D.C."),
        ReadingWritingWord(id: "r_45", word: "pay", category: "Verbs", exampleSentence: "Citizens pay taxes."),
        ReadingWritingWord(id: "r_46", word: "vote", category: "Verbs", exampleSentence: "Citizens vote for the President."),
        ReadingWritingWord(id: "r_47", word: "want", category: "Verbs", exampleSentence: "I want to be a citizen."),

        // Other Content Words
        ReadingWritingWord(id: "r_48", word: "colors", category: "Other", exampleSentence: "The colors of the flag are red, white, and blue."),
        ReadingWritingWord(id: "r_49", word: "dollar bill", category: "Other", exampleSentence: "George Washington is on the dollar bill."),
        ReadingWritingWord(id: "r_50", word: "first", category: "Other", exampleSentence: "George Washington was the first President."),
        ReadingWritingWord(id: "r_51", word: "largest", category: "Other", exampleSentence: "Alaska is the largest state."),
        ReadingWritingWord(id: "r_52", word: "most", category: "Other", exampleSentence: "California has the most people."),
        ReadingWritingWord(id: "r_53", word: "north", category: "Other", exampleSentence: "Canada is north of the United States."),
        ReadingWritingWord(id: "r_54", word: "one", category: "Other", exampleSentence: "We have one President at a time."),
        ReadingWritingWord(id: "r_55", word: "people", category: "Other", exampleSentence: "The government is for the people."),
        ReadingWritingWord(id: "r_56", word: "second", category: "Other", exampleSentence: "John Adams was the second President."),
        ReadingWritingWord(id: "r_57", word: "south", category: "Other", exampleSentence: "Mexico is south of the United States."),
        ReadingWritingWord(id: "r_58", word: "taxes", category: "Other", exampleSentence: "Citizens pay taxes to the government."),
    ]

    // MARK: - Writing Vocabulary (~75 words organized by category)

    static let writingVocabulary: [ReadingWritingWord] = [
        // People
        ReadingWritingWord(id: "w_01", word: "Adams", category: "People", exampleSentence: "Adams was the second President."),
        ReadingWritingWord(id: "w_02", word: "Lincoln", category: "People", exampleSentence: "Lincoln freed the slaves."),
        ReadingWritingWord(id: "w_03", word: "Washington", category: "People", exampleSentence: "Washington was the first President."),

        // Civics
        ReadingWritingWord(id: "w_04", word: "American Indians", category: "Civics", exampleSentence: "American Indians lived here first."),
        ReadingWritingWord(id: "w_05", word: "capital", category: "Civics", exampleSentence: "The capital is Washington, D.C."),
        ReadingWritingWord(id: "w_06", word: "citizens", category: "Civics", exampleSentence: "Citizens have the right to vote."),
        ReadingWritingWord(id: "w_07", word: "Civil War", category: "Civics", exampleSentence: "The Civil War was in the 1800s."),
        ReadingWritingWord(id: "w_08", word: "Congress", category: "Civics", exampleSentence: "Congress makes laws for the country."),
        ReadingWritingWord(id: "w_09", word: "Father of Our Country", category: "Civics", exampleSentence: "Washington is the Father of Our Country."),
        ReadingWritingWord(id: "w_10", word: "flag", category: "Civics", exampleSentence: "The flag has red and white stripes."),
        ReadingWritingWord(id: "w_11", word: "free", category: "Civics", exampleSentence: "The United States is a free country."),
        ReadingWritingWord(id: "w_12", word: "freedom of speech", category: "Civics", exampleSentence: "We have freedom of speech."),
        ReadingWritingWord(id: "w_13", word: "President", category: "Civics", exampleSentence: "The President lives in the White House."),
        ReadingWritingWord(id: "w_14", word: "right", category: "Civics", exampleSentence: "Every citizen has the right to vote."),
        ReadingWritingWord(id: "w_15", word: "Senators", category: "Civics", exampleSentence: "Senators work in Congress."),
        ReadingWritingWord(id: "w_16", word: "state", category: "Civics", exampleSentence: "Every state has two Senators."),
        ReadingWritingWord(id: "w_17", word: "White House", category: "Civics", exampleSentence: "The White House is in Washington, D.C."),

        // Places
        ReadingWritingWord(id: "w_18", word: "Alaska", category: "Places", exampleSentence: "Alaska is the largest state."),
        ReadingWritingWord(id: "w_19", word: "California", category: "Places", exampleSentence: "California has the most people."),
        ReadingWritingWord(id: "w_20", word: "Canada", category: "Places", exampleSentence: "Canada is north of the United States."),
        ReadingWritingWord(id: "w_21", word: "Delaware", category: "Places", exampleSentence: "Delaware was the first state."),
        ReadingWritingWord(id: "w_22", word: "Mexico", category: "Places", exampleSentence: "Mexico is south of the United States."),
        ReadingWritingWord(id: "w_23", word: "New York City", category: "Places", exampleSentence: "New York City is the largest city."),
        ReadingWritingWord(id: "w_24", word: "United States", category: "Places", exampleSentence: "The United States has fifty states."),
        ReadingWritingWord(id: "w_25", word: "Washington, D.C.", category: "Places", exampleSentence: "Washington, D.C., is the capital."),

        // Months
        ReadingWritingWord(id: "w_26", word: "February", category: "Months", exampleSentence: "Presidents' Day is in February."),
        ReadingWritingWord(id: "w_27", word: "May", category: "Months", exampleSentence: "Memorial Day is in May."),
        ReadingWritingWord(id: "w_28", word: "June", category: "Months", exampleSentence: "Flag Day is in June."),
        ReadingWritingWord(id: "w_29", word: "July", category: "Months", exampleSentence: "Independence Day is in July."),
        ReadingWritingWord(id: "w_30", word: "September", category: "Months", exampleSentence: "Labor Day is in September."),
        ReadingWritingWord(id: "w_31", word: "October", category: "Months", exampleSentence: "Columbus Day is in October."),
        ReadingWritingWord(id: "w_32", word: "November", category: "Months", exampleSentence: "We vote in November."),

        // Holidays
        ReadingWritingWord(id: "w_33", word: "Presidents' Day", category: "Holidays", exampleSentence: "Presidents' Day is a holiday."),
        ReadingWritingWord(id: "w_34", word: "Memorial Day", category: "Holidays", exampleSentence: "Memorial Day honors fallen soldiers."),
        ReadingWritingWord(id: "w_35", word: "Flag Day", category: "Holidays", exampleSentence: "Flag Day is on June 14."),
        ReadingWritingWord(id: "w_36", word: "Independence Day", category: "Holidays", exampleSentence: "Independence Day is on the Fourth of July."),
        ReadingWritingWord(id: "w_37", word: "Labor Day", category: "Holidays", exampleSentence: "Labor Day is in September."),
        ReadingWritingWord(id: "w_38", word: "Columbus Day", category: "Holidays", exampleSentence: "Columbus Day is in October."),
        ReadingWritingWord(id: "w_39", word: "Thanksgiving", category: "Holidays", exampleSentence: "Thanksgiving is in November."),

        // Verbs
        ReadingWritingWord(id: "w_40", word: "can", category: "Verbs", exampleSentence: "Citizens can vote."),
        ReadingWritingWord(id: "w_41", word: "come", category: "Verbs", exampleSentence: "Many people come to America."),
        ReadingWritingWord(id: "w_42", word: "elect", category: "Verbs", exampleSentence: "Citizens elect the President."),
        ReadingWritingWord(id: "w_43", word: "have", category: "Verbs", exampleSentence: "We have freedom of speech."),
        ReadingWritingWord(id: "w_44", word: "is", category: "Verbs", exampleSentence: "The White House is in Washington, D.C."),
        ReadingWritingWord(id: "w_45", word: "lives", category: "Verbs", exampleSentence: "The President lives in the White House."),
        ReadingWritingWord(id: "w_46", word: "meets", category: "Verbs", exampleSentence: "Congress meets in the Capitol."),
        ReadingWritingWord(id: "w_47", word: "pay", category: "Verbs", exampleSentence: "Citizens pay taxes."),
        ReadingWritingWord(id: "w_48", word: "vote", category: "Verbs", exampleSentence: "Citizens vote in elections."),
        ReadingWritingWord(id: "w_49", word: "want", category: "Verbs", exampleSentence: "I want to be an American citizen."),

        // Other
        ReadingWritingWord(id: "w_50", word: "blue", category: "Other", exampleSentence: "The flag is red, white, and blue."),
        ReadingWritingWord(id: "w_51", word: "dollar bill", category: "Other", exampleSentence: "Washington is on the dollar bill."),
        ReadingWritingWord(id: "w_52", word: "fifty", category: "Other", exampleSentence: "There are fifty states."),
        ReadingWritingWord(id: "w_53", word: "first", category: "Other", exampleSentence: "Washington was the first President."),
        ReadingWritingWord(id: "w_54", word: "largest", category: "Other", exampleSentence: "Alaska is the largest state."),
        ReadingWritingWord(id: "w_55", word: "most", category: "Other", exampleSentence: "California has the most people."),
        ReadingWritingWord(id: "w_56", word: "north", category: "Other", exampleSentence: "Canada is north of the United States."),
        ReadingWritingWord(id: "w_57", word: "one hundred", category: "Other", exampleSentence: "There are one hundred Senators."),
        ReadingWritingWord(id: "w_58", word: "people", category: "Other", exampleSentence: "The government is for the people."),
        ReadingWritingWord(id: "w_59", word: "red", category: "Other", exampleSentence: "The stripes are red and white."),
        ReadingWritingWord(id: "w_60", word: "second", category: "Other", exampleSentence: "Adams was the second President."),
        ReadingWritingWord(id: "w_61", word: "south", category: "Other", exampleSentence: "Mexico is south of the United States."),
        ReadingWritingWord(id: "w_62", word: "taxes", category: "Other", exampleSentence: "We pay taxes to the government."),
        ReadingWritingWord(id: "w_63", word: "white", category: "Other", exampleSentence: "The stars on the flag are white."),
    ]

    /// Grouped reading words by category for display.
    static var readingByCategory: [(category: String, words: [ReadingWritingWord])] {
        Dictionary(grouping: readingVocabulary, by: \.category)
            .sorted { $0.key < $1.key }
            .map { (category: $0.key, words: $0.value) }
    }

    /// Grouped writing words by category for display.
    static var writingByCategory: [(category: String, words: [ReadingWritingWord])] {
        Dictionary(grouping: writingVocabulary, by: \.category)
            .sorted { $0.key < $1.key }
            .map { (category: $0.key, words: $0.value) }
    }
}
