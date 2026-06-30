/// All Chinese (English ↔ 中文) quiz question sets — the 100 official 2008 USCIS
/// naturalization civics questions, organized into 10 interview-style practice sets
/// of exactly 10 questions each. IDs (`q_08_NNN`) match EnglishQuestions100.
///
/// Each question has 3 variants: [English, Simplified Chinese, Traditional Chinese].
/// correctAnswer index is identical across all variants — only the text is translated.
///
/// Chinese terminology follows USCIS official Chinese PDF conventions:
/// 憲法/宪法、國會/国会、參議院/参议院、眾議院/众议院、最高法院、
/// 總司令/三军统帅、權利法案/权利法案、獨立宣言/独立宣言、解放宣言、制衡等。
/// Traditional Chinese uses Taiwan standard: 臺灣, 選舉, 總統, 國會, etc.
enum ChineseQuestions100 {

    // MARK: - Practice Set 1: 民主原則 (Q1–Q10)
    static let practice1: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_001", correctAnswer: 2, variants: [
            .init(text: "What is the supreme law of the land?",
                  options: ["The Declaration of Independence", "The Bill of Rights", "The Constitution", "The Federalist Papers"],
                  explanation: "The Constitution is the supreme law of the United States. All other laws must be consistent with it."),
            .init(text: "美国的最高法律是什么？",
                  options: ["《独立宣言》", "《权利法案》", "《宪法》", "《联邦党人文集》"],
                  explanation: "《宪法》是美国的最高法律。所有其他法律都必须与其保持一致。"),
            .init(text: "美國的最高法律是什麼？",
                  options: ["《獨立宣言》", "《權利法案》", "《憲法》", "《聯邦黨人文集》"],
                  explanation: "《憲法》是美國的最高法律。所有其他法律都必須與其保持一致。")
        ]),
        UnifiedQuestion(id: "q_08_002", correctAnswer: 1, variants: [
            .init(text: "What does the Constitution do?",
                  options: ["Establishes the U.S. military", "Sets up the government and protects basic rights of Americans", "Lists every federal law", "Declares independence from Britain"],
                  explanation: "The Constitution defines the structure of the U.S. government and protects the basic rights of all Americans."),
            .init(text: "宪法有什么作用？",
                  options: ["建立美国军队", "建立政府并保障美国人的基本权利", "列出所有联邦法律", "宣布脱离英国独立"],
                  explanation: "《宪法》规定了美国政府的结构，并保障所有美国人的基本权利。"),
            .init(text: "憲法有什麼作用？",
                  options: ["建立美國軍隊", "建立政府並保障美國人的基本權利", "列出所有聯邦法律", "宣布脫離英國獨立"],
                  explanation: "《憲法》規定了美國政府的結構，並保障所有美國人的基本權利。")
        ]),
        UnifiedQuestion(id: "q_08_003", correctAnswer: 1, variants: [
            .init(text: "The idea of self-government is in the first three words of the Constitution. What are these words?",
                  options: ["Life and Liberty", "We the People", "Equal Justice Under Law", "In God We Trust"],
                  explanation: "'We the People' opens the Preamble, establishing that all government authority comes from the citizens."),
            .init(text: "自治的理念体现在宪法的前三个词中。这三个词是什么？",
                  options: ["生命与自由", "我们人民", "法律之下人人平等", "我们信仰上帝"],
                  explanation: "\"我们人民\"开启了序言，确立了所有政府权力来自公民的原则。"),
            .init(text: "自治的理念體現在憲法的前三個詞中。這三個詞是什麼？",
                  options: ["生命與自由", "我們人民", "法律之下人人平等", "我們信仰上帝"],
                  explanation: "\"我們人民\"開啟了序言，確立了所有政府權力來自公民的原則。")
        ]),
        UnifiedQuestion(id: "q_08_004", correctAnswer: 2, variants: [
            .init(text: "What is an amendment?",
                  options: ["A federal court ruling", "A presidential executive order", "A change or addition to the Constitution", "A temporary law passed by Congress"],
                  explanation: "An amendment is a formal change or addition to the Constitution."),
            .init(text: "什么是修正案？",
                  options: ["联邦法院裁决", "总统行政命令", "对宪法的修改或补充", "国会通过的临时法律"],
                  explanation: "修正案是对《宪法》的正式修改或补充。"),
            .init(text: "什麼是修正案？",
                  options: ["聯邦法院裁決", "總統行政命令", "對憲法的修改或補充", "國會通過的臨時法律"],
                  explanation: "修正案是對《憲法》的正式修改或補充。")
        ]),
        UnifiedQuestion(id: "q_08_005", correctAnswer: 3, variants: [
            .init(text: "What do we call the first ten amendments to the Constitution?",
                  options: ["The Federalist Papers", "The Articles of Confederation", "The Declaration of Rights", "The Bill of Rights"],
                  explanation: "The first ten amendments are the Bill of Rights, ratified in 1791."),
            .init(text: "我们如何称呼宪法的前十条修正案？",
                  options: ["《联邦党人文集》", "《邦联条例》", "《权利宣言》", "《权利法案》"],
                  explanation: "前十条修正案称为《权利法案》，于1791年批准生效。"),
            .init(text: "我們如何稱呼憲法的前十條修正案？",
                  options: ["《聯邦黨人文集》", "《邦聯條例》", "《權利宣言》", "《權利法案》"],
                  explanation: "前十條修正案稱為《權利法案》，於1791年批准生效。")
        ]),
        UnifiedQuestion(id: "q_08_006", correctAnswer: 1, variants: [
            .init(text: "What is one right or freedom from the First Amendment?",
                  options: ["Right to bear arms", "Freedom of speech", "Right to vote", "Right to a trial by jury"],
                  explanation: "The First Amendment protects five freedoms: religion, speech, press, assembly, and petition."),
            .init(text: "第一修正案中有哪一项权利或自由？",
                  options: ["持有武器的权利", "言论自由", "投票权", "陪审团审判权"],
                  explanation: "第一修正案保护五项自由：宗教、言论、新闻、集会和请愿。"),
            .init(text: "第一修正案中有哪一項權利或自由？",
                  options: ["持有武器的權利", "言論自由", "投票權", "陪審團審判權"],
                  explanation: "第一修正案保護五項自由：宗教、言論、新聞、集會和請願。")
        ]),
        UnifiedQuestion(id: "q_08_007", correctAnswer: 2, variants: [
            .init(text: "How many amendments does the Constitution have?",
                  options: ["10", "21", "27", "33"],
                  explanation: "The Constitution has been amended 27 times."),
            .init(text: "宪法有多少条修正案？",
                  options: ["10条", "21条", "27条", "33条"],
                  explanation: "《宪法》已被修正27次。"),
            .init(text: "憲法有多少條修正案？",
                  options: ["10條", "21條", "27條", "33條"],
                  explanation: "《憲法》已被修正27次。")
        ]),
        UnifiedQuestion(id: "q_08_008", correctAnswer: 1, variants: [
            .init(text: "What did the Declaration of Independence do?",
                  options: ["Created the U.S. Constitution", "Announced and declared our independence from Great Britain", "Established the Bill of Rights", "Set up the three branches of government"],
                  explanation: "The Declaration of Independence, adopted July 4, 1776, formally announced separation from British rule."),
            .init(text: "《独立宣言》起到了什么作用？",
                  options: ["创建了美国宪法", "宣告我们脱离英国独立", "建立了《权利法案》", "设立了政府三个分支"],
                  explanation: "1776年7月4日通过的《独立宣言》正式宣布脱离英国统治。"),
            .init(text: "《獨立宣言》起到了什麼作用？",
                  options: ["創建了美國憲法", "宣告我們脫離英國獨立", "建立了《權利法案》", "設立了政府三個分支"],
                  explanation: "1776年7月4日通過的《獨立宣言》正式宣布脫離英國統治。")
        ]),
        UnifiedQuestion(id: "q_08_009", correctAnswer: 1, variants: [
            .init(text: "What are two rights in the Declaration of Independence?",
                  options: ["Free speech and religion", "Life and liberty (or pursuit of happiness)", "Right to vote and bear arms", "Trial by jury and free press"],
                  explanation: "USCIS accepts any two of: life / liberty / pursuit of happiness. The Declaration states these as 'unalienable rights' — the most famous words in American founding history."),
            .init(text: "《独立宣言》中有哪两项权利？",
                  options: ["言论自由和宗教自由", "生命和自由（或追求幸福）", "投票权和持有武器权", "陪审团审判权和新闻自由"],
                  explanation: "USCIS 接受以下任意两项：生命 / 自由 / 追求幸福。《独立宣言》将这些称为「不可剥夺的权利」。"),
            .init(text: "《獨立宣言》中有哪兩項權利？",
                  options: ["言論自由和宗教自由", "生命和自由（或追求幸福）", "投票權和持有武器權", "陪審團審判權和新聞自由"],
                  explanation: "USCIS 接受以下任意兩項：生命 / 自由 / 追求幸福。《獨立宣言》將這些稱為「不可剝奪的權利」。")
        ]),
        UnifiedQuestion(id: "q_08_010", correctAnswer: 2, variants: [
            .init(text: "What is freedom of religion?",
                  options: ["The government selects an official religion for all citizens", "You may only practice one of several approved religions", "You can practice any religion, or not practice a religion", "Religious leaders help run the government"],
                  explanation: "Freedom of religion means you can practice any faith — or no faith — without any government interference."),
            .init(text: "什么是宗教自由？",
                  options: ["政府为所有公民指定一种官方宗教", "你只能信仰几种经批准的宗教之一", "你可以信仰任何宗教，或不信仰任何宗教", "宗教领袖协助管理政府"],
                  explanation: "宗教自由意味着你可以信仰任何宗教，或不信仰任何宗教，政府不得干涉。"),
            .init(text: "什麼是宗教自由？",
                  options: ["政府為所有公民指定一種官方宗教", "你只能信仰幾種經批准的宗教之一", "你可以信仰任何宗教，或不信仰任何宗教", "宗教領袖協助管理政府"],
                  explanation: "宗教自由意味著你可以信仰任何宗教，或不信仰任何宗教，政府不得干涉。")
        ])
    ]

    // MARK: - Practice Set 2: 政府制度 (Q11–Q20)
    static let practice2: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_011", correctAnswer: 1, variants: [
            .init(text: "What is the economic system in the United States?",
                  options: ["Socialist economy", "Capitalist economy / market economy", "Communist economy", "Mixed feudal economy"],
                  explanation: "The United States has a capitalist, free market economy."),
            .init(text: "美国的经济制度是什么？",
                  options: ["社会主义经济", "资本主义经济 / 市场经济", "共产主义经济", "混合封建经济"],
                  explanation: "美国实行资本主义自由市场经济。"),
            .init(text: "美國的經濟制度是什麼？",
                  options: ["社會主義經濟", "資本主義經濟 / 市場經濟", "共產主義經濟", "混合封建經濟"],
                  explanation: "美國實行資本主義自由市場經濟。")
        ]),
        UnifiedQuestion(id: "q_08_012", correctAnswer: 2, variants: [
            .init(text: "What is the 'rule of law'?",
                  options: ["Kings and rulers make all the laws", "Only criminals must follow the law", "Everyone must follow the law, including government leaders", "Laws apply only to citizens, not visitors"],
                  explanation: "Under the rule of law, everyone must obey the same laws."),
            .init(text: "什么是「法治」？",
                  options: ["国王和统治者制定所有法律", "只有罪犯才必须遵守法律", "每个人都必须遵守法律，包括政府领导人", "法律只适用于公民，不适用于访客"],
                  explanation: "在法治之下，每个人都必须遵守同样的法律。"),
            .init(text: "什麼是「法治」？",
                  options: ["國王和統治者制定所有法律", "只有罪犯才必須遵守法律", "每個人都必須遵守法律，包括政府領導人", "法律只適用於公民，不適用於訪客"],
                  explanation: "在法治之下，每個人都必須遵守同樣的法律。")
        ]),
        UnifiedQuestion(id: "q_08_013", correctAnswer: 1, variants: [
            .init(text: "Name one branch or part of the government.",
                  options: ["The Army", "Congress (legislative branch)", "The FBI", "The Department of the Treasury"],
                  explanation: "The three branches are: Legislative (Congress), Executive (President), and Judicial (courts)."),
            .init(text: "说出政府的一个分支或组成部分。",
                  options: ["陆军", "国会（立法部门）", "联邦调查局", "财政部"],
                  explanation: "三个分支分别是：立法部门（国会）、行政部门（总统）和司法部门（法院）。"),
            .init(text: "說出政府的一個分支或組成部分。",
                  options: ["陸軍", "國會（立法部門）", "聯邦調查局", "財政部"],
                  explanation: "三個分支分別是：立法部門（國會）、行政部門（總統）和司法部門（法院）。")
        ]),
        UnifiedQuestion(id: "q_08_014", correctAnswer: 1, variants: [
            .init(text: "What stops one branch of government from becoming too powerful?",
                  options: ["Popular vote", "Checks and balances / separation of powers", "The military", "State governments"],
                  explanation: "Checks and balances allow each branch to limit the others."),
            .init(text: "什么防止政府的某一分支权力过大？",
                  options: ["全民投票", "制衡 / 权力分立", "军队", "州政府"],
                  explanation: "制衡机制使每个分支都能限制其他分支的权力。"),
            .init(text: "什麼防止政府的某一分支權力過大？",
                  options: ["全民投票", "制衡 / 權力分立", "軍隊", "州政府"],
                  explanation: "制衡機制使每個分支都能限制其他分支的權力。")
        ]),
        UnifiedQuestion(id: "q_08_015", correctAnswer: 2, variants: [
            .init(text: "Who is in charge of the executive branch?",
                  options: ["The Speaker of the House", "The Chief Justice of the Supreme Court", "The President", "The Secretary of State"],
                  explanation: "The President leads the executive branch."),
            .init(text: "谁负责行政部门？",
                  options: ["众议院议长", "最高法院首席大法官", "总统", "国务卿"],
                  explanation: "总统领导行政部门。"),
            .init(text: "誰負責行政部門？",
                  options: ["眾議院議長", "最高法院首席大法官", "總統", "國務卿"],
                  explanation: "總統領導行政部門。")
        ]),
        UnifiedQuestion(id: "q_08_016", correctAnswer: 2, variants: [
            .init(text: "Who makes federal laws?",
                  options: ["The President", "The Supreme Court", "Congress (Senate and House of Representatives)", "State governors"],
                  explanation: "Congress is the federal lawmaking body."),
            .init(text: "谁制定联邦法律？",
                  options: ["总统", "最高法院", "国会（参议院和众议院）", "州长"],
                  explanation: "国会是联邦立法机构。"),
            .init(text: "誰制定聯邦法律？",
                  options: ["總統", "最高法院", "國會（參議院和眾議院）", "州長"],
                  explanation: "國會是聯邦立法機構。")
        ]),
        UnifiedQuestion(id: "q_08_017", correctAnswer: 1, variants: [
            .init(text: "What are the two parts of the U.S. Congress?",
                  options: ["The President and Vice President", "The Senate and House of Representatives", "The Supreme Court and Congress", "The Democratic and Republican parties"],
                  explanation: "Congress is bicameral: the Senate and the House of Representatives."),
            .init(text: "美国国会由哪两部分组成？",
                  options: ["总统和副总统", "参议院和众议院", "最高法院和国会", "民主党和共和党"],
                  explanation: "国会实行两院制：参议院和众议院。"),
            .init(text: "美國國會由哪兩部分組成？",
                  options: ["總統和副總統", "參議院和眾議院", "最高法院和國會", "民主黨和共和黨"],
                  explanation: "國會實行兩院制：參議院和眾議院。")
        ]),
        UnifiedQuestion(id: "q_08_018", correctAnswer: 1, variants: [
            .init(text: "How many U.S. Senators are there?",
                  options: ["50", "100", "435", "535"],
                  explanation: "There are 100 U.S. Senators — two from each of the 50 states."),
            .init(text: "美国有多少位参议员？",
                  options: ["50位", "100位", "435位", "535位"],
                  explanation: "美国共有100位参议员——每个州2位，共50个州。"),
            .init(text: "美國有多少位參議員？",
                  options: ["50位", "100位", "435位", "535位"],
                  explanation: "美國共有100位參議員——每個州2位，共50個州。")
        ]),
        UnifiedQuestion(id: "q_08_019", correctAnswer: 2, variants: [
            .init(text: "We elect a U.S. Senator for how many years?",
                  options: ["2 years", "4 years", "6 years", "8 years"],
                  explanation: "U.S. Senators serve 6-year terms."),
            .init(text: "美国参议员的任期是多少年？",
                  options: ["2年", "4年", "6年", "8年"],
                  explanation: "美国参议员任期为6年。"),
            .init(text: "美國參議員的任期是多少年？",
                  options: ["2年", "4年", "6年", "8年"],
                  explanation: "美國參議員任期為6年。")
        ]),
        UnifiedQuestion(id: "q_08_020", correctAnswer: 0, variants: [
            .init(text: "Who is one of your state's U.S. Senators now?",
                  options: ["Answers will vary — research your state", "Donald Trump", "Joe Biden", "Kamala Harris"],
                  explanation: "Look up your two current senators before your interview."),
            .init(text: "你所在州现任美国参议员是谁？",
                  options: ["答案因州而异——请查询您所在的州", "唐纳德·特朗普", "乔·拜登", "卡玛拉·哈里斯"],
                  explanation: "请在面试前查询您所在州的两位现任参议员。"),
            .init(text: "你所在州現任美國參議員是誰？",
                  options: ["答案因州而異——請查詢您所在的州", "唐納德·川普", "喬·拜登", "卡瑪拉·哈里斯"],
                  explanation: "請在面試前查詢您所在州的兩位現任參議員。")
        ])
    ]

    // MARK: - Practice Set 3: 代議制度 (Q21–Q30)
    static let practice3: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_021", correctAnswer: 2, variants: [
            .init(text: "The House of Representatives has how many voting members?",
                  options: ["100", "270", "435", "538"],
                  explanation: "The House has 435 voting members."),
            .init(text: "众议院有多少名有投票权的成员？",
                  options: ["100名", "270名", "435名", "538名"],
                  explanation: "众议院共有435名有投票权的成员。"),
            .init(text: "眾議院有多少名有投票權的成員？",
                  options: ["100名", "270名", "435名", "538名"],
                  explanation: "眾議院共有435名有投票權的成員。")
        ]),
        UnifiedQuestion(id: "q_08_022", correctAnswer: 0, variants: [
            .init(text: "We elect a U.S. Representative for how many years?",
                  options: ["2 years", "4 years", "6 years", "8 years"],
                  explanation: "U.S. Representatives serve 2-year terms."),
            .init(text: "美国众议员的任期是多少年？",
                  options: ["2年", "4年", "6年", "8年"],
                  explanation: "美国众议员任期为2年。"),
            .init(text: "美國眾議員的任期是多少年？",
                  options: ["2年", "4年", "6年", "8年"],
                  explanation: "美國眾議員任期為2年。")
        ]),
        UnifiedQuestion(id: "q_08_023", correctAnswer: 0, variants: [
            .init(text: "Name your U.S. Representative.",
                  options: ["Answers will vary — research your district", "Nancy Pelosi", "Kevin McCarthy", "Hakeem Jeffries"],
                  explanation: "Look up your representative at house.gov before your interview."),
            .init(text: "说出您的美国众议员姓名。",
                  options: ["答案因选区而异——请查询您的选区", "南希·佩洛西", "凯文·麦卡锡", "哈基姆·杰弗里斯"],
                  explanation: "请在面试前登录house.gov查询您的众议员。"),
            .init(text: "說出您的美國眾議員姓名。",
                  options: ["答案因選區而異——請查詢您的選區", "南希·裴洛西", "凱文·麥卡錫", "哈基姆·傑弗里斯"],
                  explanation: "請在面試前登錄house.gov查詢您的眾議員。")
        ]),
        UnifiedQuestion(id: "q_08_024", correctAnswer: 1, variants: [
            .init(text: "Who does a U.S. Senator represent?",
                  options: ["Only the voters who elected them", "All the people of their state", "Their political party's supporters", "The federal government"],
                  explanation: "Each U.S. Senator represents ALL residents of their state."),
            .init(text: "美国参议员代表谁？",
                  options: ["只代表选举他们的选民", "代表其所在州的全体人民", "代表其政党的支持者", "代表联邦政府"],
                  explanation: "每位美国参议员代表其所在州的全体居民。"),
            .init(text: "美國參議員代表誰？",
                  options: ["只代表選舉他們的選民", "代表其所在州的全體人民", "代表其政黨的支持者", "代表聯邦政府"],
                  explanation: "每位美國參議員代表其所在州的全體居民。")
        ]),
        UnifiedQuestion(id: "q_08_025", correctAnswer: 2, variants: [
            .init(text: "Why do some states have more Representatives than other states?",
                  options: ["Because of the state's geographic size", "Because of the state's wealth and tax revenue", "Because of the state's population", "Because of how long the state has been in the Union"],
                  explanation: "House seats are apportioned by population."),
            .init(text: "为什么一些州比其他州拥有更多的众议员？",
                  options: ["因为该州的地理面积", "因为该州的财富和税收", "因为该州的人口", "因为该州加入联邦的时间长短"],
                  explanation: "众议院席位按人口比例分配。"),
            .init(text: "為什麼一些州比其他州擁有更多的眾議員？",
                  options: ["因為該州的地理面積", "因為該州的財富和稅收", "因為該州的人口", "因為該州加入聯邦的時間長短"],
                  explanation: "眾議院席位按人口比例分配。")
        ]),
        UnifiedQuestion(id: "q_08_026", correctAnswer: 2, variants: [
            .init(text: "We elect a President for how many years?",
                  options: ["2 years", "3 years", "4 years", "6 years"],
                  explanation: "The President serves a 4-year term, limited to two terms."),
            .init(text: "总统的任期是多少年？",
                  options: ["2年", "3年", "4年", "6年"],
                  explanation: "总统任期为4年，最多担任两届。"),
            .init(text: "總統的任期是多少年？",
                  options: ["2年", "3年", "4年", "6年"],
                  explanation: "總統任期為4年，最多擔任兩屆。")
        ]),
        UnifiedQuestion(id: "q_08_027", correctAnswer: 2, variants: [
            .init(text: "In what month do we vote for President?",
                  options: ["September", "October", "November", "December"],
                  explanation: "Presidential elections are held in November every four years."),
            .init(text: "我们在哪个月份投票选举总统？",
                  options: ["九月", "十月", "十一月", "十二月"],
                  explanation: "总统选举每四年举行一次，在十一月进行。"),
            .init(text: "我們在哪個月份投票選舉總統？",
                  options: ["九月", "十月", "十一月", "十二月"],
                  explanation: "總統選舉每四年舉行一次，在十一月進行。")
        ]),
        UnifiedQuestion(id: "q_08_028", correctAnswer: 2, variants: [
            .init(text: "What is the name of the President of the United States now?",
                  options: ["Joe Biden", "Barack Obama", "Donald Trump", "Kamala Harris"],
                  explanation: "Donald Trump is the 47th President, serving his second term since January 2025."),
            .init(text: "现任美国总统的名字是什么？",
                  options: ["乔·拜登", "巴拉克·奥巴马", "唐纳德·特朗普", "卡玛拉·哈里斯"],
                  explanation: "唐纳德·特朗普是第47任总统，自2025年1月起开始第二届任期。"),
            .init(text: "現任美國總統的名字是什麼？",
                  options: ["喬·拜登", "巴拉克·歐巴馬", "唐納德·川普", "卡瑪拉·哈里斯"],
                  explanation: "唐納德·川普是第47任總統，自2025年1月起開始第二屆任期。")
        ]),
        UnifiedQuestion(id: "q_08_029", correctAnswer: 2, variants: [
            .init(text: "What is the name of the Vice President of the United States now?",
                  options: ["Kamala Harris", "Mike Pence", "JD Vance", "Tim Walz"],
                  explanation: "JD Vance is the 50th Vice President, serving since January 2025."),
            .init(text: "现任美国副总统的名字是什么？",
                  options: ["卡玛拉·哈里斯", "迈克·彭斯", "JD·万斯", "蒂姆·瓦尔兹"],
                  explanation: "JD·万斯是第50任副总统，自2025年1月起就职。"),
            .init(text: "現任美國副總統的名字是什麼？",
                  options: ["卡瑪拉·哈里斯", "麥克·彭斯", "JD·萬斯", "提姆·沃爾茲"],
                  explanation: "JD·萬斯是第50任副總統，自2025年1月起就職。")
        ]),
        UnifiedQuestion(id: "q_08_030", correctAnswer: 3, variants: [
            .init(text: "If the President can no longer serve, who becomes President?",
                  options: ["The Speaker of the House", "The Chief Justice", "The Secretary of State", "The Vice President"],
                  explanation: "The Vice President becomes President if the President is unable to serve."),
            .init(text: "如果总统无法继续履职，谁将成为总统？",
                  options: ["众议院议长", "首席大法官", "国务卿", "副总统"],
                  explanation: "如果总统无法履职，副总统将成为总统。"),
            .init(text: "如果總統無法繼續履職，誰將成為總統？",
                  options: ["眾議院議長", "首席大法官", "國務卿", "副總統"],
                  explanation: "如果總統無法履職，副總統將成為總統。")
        ])
    ]

    // MARK: - Practice Set 4: 行政司法 (Q31–Q40)
    static let practice4: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_031", correctAnswer: 1, variants: [
            .init(text: "If both the President and the Vice President can no longer serve, who becomes President?",
                  options: ["The Secretary of State", "The Speaker of the House", "The President pro tempore of the Senate", "The Chief Justice of the Supreme Court"],
                  explanation: "The Speaker of the House is second in line of succession."),
            .init(text: "如果总统和副总统都无法继续履职，谁将成为总统？",
                  options: ["国务卿", "众议院议长", "参议院临时议长", "最高法院首席大法官"],
                  explanation: "众议院议长在继任顺序中排第二位。"),
            .init(text: "如果總統和副總統都無法繼續履職，誰將成為總統？",
                  options: ["國務卿", "眾議院議長", "參議院臨時議長", "最高法院首席大法官"],
                  explanation: "眾議院議長在繼任順序中排第二位。")
        ]),
        UnifiedQuestion(id: "q_08_032", correctAnswer: 2, variants: [
            .init(text: "Who is the Commander in Chief of the military?",
                  options: ["The Secretary of Defense", "A four-star general", "The President", "The Chairman of the Joint Chiefs of Staff"],
                  explanation: "The President serves as Commander in Chief of all U.S. armed forces."),
            .init(text: "谁是军队的总司令？",
                  options: ["国防部长", "四星上将", "总统", "参谋长联席会议主席"],
                  explanation: "总统担任美国全部武装力量的总司令。"),
            .init(text: "誰是軍隊的總司令？",
                  options: ["國防部長", "四星上將", "總統", "參謀長聯席會議主席"],
                  explanation: "總統擔任美國全部武裝力量的總司令。")
        ]),
        UnifiedQuestion(id: "q_08_033", correctAnswer: 2, variants: [
            .init(text: "Who signs bills to become laws?",
                  options: ["The Speaker of the House", "The Vice President", "The President", "The Chief Justice"],
                  explanation: "After Congress passes a bill, the President signs it into law or vetoes it."),
            .init(text: "谁签署法案使其成为法律？",
                  options: ["众议院议长", "副总统", "总统", "首席大法官"],
                  explanation: "国会通过法案后，总统签署使其成为法律，或行使否决权。"),
            .init(text: "誰簽署法案使其成為法律？",
                  options: ["眾議院議長", "副總統", "總統", "首席大法官"],
                  explanation: "國會通過法案後，總統簽署使其成為法律，或行使否決權。")
        ]),
        UnifiedQuestion(id: "q_08_034", correctAnswer: 3, variants: [
            .init(text: "Who vetoes bills?",
                  options: ["The Senate Majority Leader", "The Supreme Court", "The Speaker of the House", "The President"],
                  explanation: "The President can veto legislation passed by Congress."),
            .init(text: "谁有权否决法案？",
                  options: ["参议院多数党领袖", "最高法院", "众议院议长", "总统"],
                  explanation: "总统可以否决国会通过的立法。"),
            .init(text: "誰有權否決法案？",
                  options: ["參議院多數黨領袖", "最高法院", "眾議院議長", "總統"],
                  explanation: "總統可以否決國會通過的立法。")
        ]),
        UnifiedQuestion(id: "q_08_035", correctAnswer: 1, variants: [
            .init(text: "What does the President's Cabinet do?",
                  options: ["Makes federal laws", "Advises the President", "Elects the Vice President", "Oversees the Supreme Court"],
                  explanation: "The Cabinet members advise the President on major policy decisions."),
            .init(text: "总统内阁的职能是什么？",
                  options: ["制定联邦法律", "为总统提供建议", "选举副总统", "监督最高法院"],
                  explanation: "内阁成员就重大政策决定向总统提供建议。"),
            .init(text: "總統內閣的職能是什麼？",
                  options: ["制定聯邦法律", "為總統提供建議", "選舉副總統", "監督最高法院"],
                  explanation: "內閣成員就重大政策決定向總統提供建議。")
        ]),
        UnifiedQuestion(id: "q_08_036", correctAnswer: 2, variants: [
            .init(text: "What are two Cabinet-level positions?",
                  options: ["Senator and Representative", "Governor and Mayor", "Secretary of State and Secretary of Defense", "Chief Justice and Speaker of the House"],
                  explanation: "Cabinet positions include the Vice President and department heads: Secretary of State, Defense, Treasury, and the Attorney General. (Chief Justice and Speaker lead judicial/legislative branches — not Cabinet.)"),
            .init(text: "举出两个内阁级别的职位。",
                  options: ["参议员和众议员", "州长和市长", "国务卿和国防部长", "首席大法官和众议院议长"],
                  explanation: "内阁职位包括副总统及国务卿、国防部长、财政部长和司法部长等部门首长。（首席大法官和众议院议长领导司法/立法机构，并非内阁成员。）"),
            .init(text: "舉出兩個內閣級別的職位。",
                  options: ["參議員和眾議員", "州長和市長", "國務卿和國防部長", "首席大法官和眾議院議長"],
                  explanation: "內閣職位包括副總統及國務卿、國防部長、財政部長和司法部長等部門首長。（首席大法官和眾議院議長領導司法／立法機構，並非內閣成員。）")
        ]),
        UnifiedQuestion(id: "q_08_037", correctAnswer: 3, variants: [
            .init(text: "What does the judicial branch do?",
                  options: ["Makes federal laws", "Enforces laws and manages the military", "Collects taxes and prints money", "Reviews laws and decides if they are constitutional"],
                  explanation: "The judicial branch interprets laws and determines whether they are constitutional."),
            .init(text: "司法部门的职能是什么？",
                  options: ["制定联邦法律", "执行法律并管理军队", "征税和印刷货币", "审查法律并裁定其是否符合宪法"],
                  explanation: "司法部门负责解释法律，并裁定法律是否符合宪法。"),
            .init(text: "司法部門的職能是什麼？",
                  options: ["制定聯邦法律", "執行法律並管理軍隊", "徵稅和印刷貨幣", "審查法律並裁定其是否符合憲法"],
                  explanation: "司法部門負責解釋法律，並裁定法律是否符合憲法。")
        ]),
        UnifiedQuestion(id: "q_08_038", correctAnswer: 3, variants: [
            .init(text: "What is the highest court in the United States?",
                  options: ["The Federal Appeals Court", "The State Supreme Court", "The Federal District Court", "The Supreme Court"],
                  explanation: "The U.S. Supreme Court is the highest court in the land."),
            .init(text: "美国最高级别的法院是什么？",
                  options: ["联邦上诉法院", "州最高法院", "联邦地区法院", "最高法院"],
                  explanation: "美国最高法院是全国最高级别的法院。"),
            .init(text: "美國最高級別的法院是什麼？",
                  options: ["聯邦上訴法院", "州最高法院", "聯邦地區法院", "最高法院"],
                  explanation: "美國最高法院是全國最高級別的法院。")
        ]),
        UnifiedQuestion(id: "q_08_039", correctAnswer: 1, variants: [
            .init(text: "How many justices are on the Supreme Court?",
                  options: ["7", "9", "11", "13"],
                  explanation: "The Supreme Court has 9 justices: one Chief Justice and eight Associate Justices."),
            .init(text: "最高法院有多少位大法官？",
                  options: ["7位", "9位", "11位", "13位"],
                  explanation: "最高法院共有9位大法官：一位首席大法官和八位大法官。"),
            .init(text: "最高法院有多少位大法官？",
                  options: ["7位", "9位", "11位", "13位"],
                  explanation: "最高法院共有9位大法官：一位首席大法官和八位大法官。")
        ]),
        UnifiedQuestion(id: "q_08_040", correctAnswer: 2, variants: [
            .init(text: "Who is the Chief Justice of the United States now?",
                  options: ["Sonia Sotomayor", "Clarence Thomas", "John Roberts", "Elena Kagan"],
                  explanation: "John G. Roberts Jr. has served as Chief Justice since 2005."),
            .init(text: "现任美国首席大法官是谁？",
                  options: ["索尼娅·索托马约尔", "克拉伦斯·托马斯", "约翰·罗伯茨", "埃琳娜·卡根"],
                  explanation: "小约翰·G·罗伯茨自2005年起担任首席大法官。"),
            .init(text: "現任美國首席大法官是誰？",
                  options: ["索尼雅·索托馬約爾", "克拉倫斯·托馬斯", "約翰·羅伯茨", "艾蓮娜·卡根"],
                  explanation: "小約翰·G·羅伯茨自2005年起擔任首席大法官。")
        ])
    ]

    // MARK: - Practice Set 5: 公民權利 (Q41–Q50)
    static let practice5: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_041", correctAnswer: 2, variants: [
            .init(text: "Under our Constitution, some powers belong to the federal government. What is one power of the federal government?",
                  options: ["Issue driver's licenses", "Set local zoning laws", "To print money", "Provide fire protection"],
                  explanation: "Exclusive federal powers include printing money, declaring war, and making treaties."),
            .init(text: "根据我们的宪法，某些权力属于联邦政府。联邦政府的一项权力是什么？",
                  options: ["颁发驾照", "制定地方分区法规", "印刷货币", "提供消防保护"],
                  explanation: "联邦政府的专属权力包括印刷货币、宣战和缔结条约。"),
            .init(text: "根據我們的憲法，某些權力屬於聯邦政府。聯邦政府的一項權力是什麼？",
                  options: ["頒發駕照", "制定地方分區法規", "印刷貨幣", "提供消防保護"],
                  explanation: "聯邦政府的專屬權力包括印刷貨幣、宣戰和締結條約。")
        ]),
        UnifiedQuestion(id: "q_08_042", correctAnswer: 3, variants: [
            .init(text: "Under our Constitution, some powers belong to the states. What is one power of the states?",
                  options: ["Declare war", "Print money", "Make treaties with foreign nations", "Provide schooling and education"],
                  explanation: "State powers include providing education, police protection, and driver's licenses."),
            .init(text: "根据我们的宪法，某些权力属于各州。各州的一项权力是什么？",
                  options: ["宣战", "印刷货币", "与外国缔结条约", "提供学校教育"],
                  explanation: "州权力包括提供教育、警察保护和颁发驾照。"),
            .init(text: "根據我們的憲法，某些權力屬於各州。各州的一項權力是什麼？",
                  options: ["宣戰", "印刷貨幣", "與外國締結條約", "提供學校教育"],
                  explanation: "州權力包括提供教育、警察保護和頒發駕照。")
        ]),
        UnifiedQuestion(id: "q_08_043", correctAnswer: 0, variants: [
            .init(text: "Who is the Governor of your state now?",
                  options: ["Answers will vary — research your state", "Donald Trump", "Joe Biden", "Kamala Harris"],
                  explanation: "Look up your current Governor before your interview."),
            .init(text: "你所在州现任州长是谁？",
                  options: ["答案因州而异——请查询您所在的州", "唐纳德·特朗普", "乔·拜登", "卡玛拉·哈里斯"],
                  explanation: "请在面试前查询您所在州的现任州长。"),
            .init(text: "你所在州現任州長是誰？",
                  options: ["答案因州而異——請查詢您所在的州", "唐納德·川普", "喬·拜登", "卡瑪拉·哈里斯"],
                  explanation: "請在面試前查詢您所在州的現任州長。")
        ]),
        UnifiedQuestion(id: "q_08_044", correctAnswer: 0, variants: [
            .init(text: "What is the capital of your state?",
                  options: ["Answers will vary — research your state", "New York City", "Los Angeles", "Chicago"],
                  explanation: "Each state has its own capital city."),
            .init(text: "你所在州的首府是什么？",
                  options: ["答案因州而异——请查询您所在的州", "纽约市", "洛杉矶", "芝加哥"],
                  explanation: "每个州都有自己的首府城市。"),
            .init(text: "你所在州的首府是什麼？",
                  options: ["答案因州而異——請查詢您所在的州", "紐約市", "洛杉磯", "芝加哥"],
                  explanation: "每個州都有自己的首府城市。")
        ]),
        UnifiedQuestion(id: "q_08_045", correctAnswer: 2, variants: [
            .init(text: "What are the two major political parties in the United States?",
                  options: ["Liberal and Conservative", "Federalist and Democratic-Republican", "Democratic and Republican", "Independent and Green"],
                  explanation: "The Democratic Party and Republican Party are the two dominant parties in U.S. politics."),
            .init(text: "美国的两大政党是什么？",
                  options: ["自由派和保守派", "联邦党和民主共和党", "民主党和共和党", "独立党和绿党"],
                  explanation: "民主党和共和党是美国政治中的两大主要政党。"),
            .init(text: "美國的兩大政黨是什麼？",
                  options: ["自由派和保守派", "聯邦黨和民主共和黨", "民主黨和共和黨", "獨立黨和綠黨"],
                  explanation: "民主黨和共和黨是美國政治中的兩大主要政黨。")
        ]),
        UnifiedQuestion(id: "q_08_046", correctAnswer: 1, variants: [
            .init(text: "What is the political party of the President now?",
                  options: ["Democratic Party", "Republican Party", "Independent", "Libertarian Party"],
                  explanation: "Donald Trump is a member of the Republican Party."),
            .init(text: "现任总统属于哪个政党？",
                  options: ["民主党", "共和党", "无党派", "自由意志党"],
                  explanation: "唐纳德·特朗普是共和党成员。"),
            .init(text: "現任總統屬於哪個政黨？",
                  options: ["民主黨", "共和黨", "無黨派", "自由意志黨"],
                  explanation: "唐納德·川普是共和黨成員。")
        ]),
        UnifiedQuestion(id: "q_08_047", correctAnswer: 2, variants: [
            .init(text: "What is the name of the Speaker of the House of Representatives now?",
                  options: ["Kevin McCarthy", "Nancy Pelosi", "Mike Johnson", "Hakeem Jeffries"],
                  explanation: "Mike Johnson has served as Speaker of the House since October 2023."),
            .init(text: "现任众议院议长的名字是什么？",
                  options: ["凯文·麦卡锡", "南希·佩洛西", "迈克·约翰逊", "哈基姆·杰弗里斯"],
                  explanation: "迈克·约翰逊自2023年10月起担任众议院议长。"),
            .init(text: "現任眾議院議長的名字是什麼？",
                  options: ["凱文·麥卡錫", "南希·裴洛西", "麥克·強森", "哈基姆·傑弗里斯"],
                  explanation: "麥克·強森自2023年10月起擔任眾議院議長。")
        ]),
        UnifiedQuestion(id: "q_08_048", correctAnswer: 1, variants: [
            .init(text: "There are four amendments to the Constitution about who can vote. Describe one of them.",
                  options: ["All people age 16 and older can vote", "Citizens eighteen (18) and older can vote", "Only property owners can vote", "Only taxpayers can vote"],
                  explanation: "Four voting amendments: 15th (race), 19th (women), 24th (no poll tax), and 26th (age 18+)."),
            .init(text: "宪法中有四条关于投票权的修正案。描述其中一条。",
                  options: ["所有16岁及以上的人都可以投票", "18岁及以上的公民可以投票", "只有有产者才能投票", "只有纳税人才能投票"],
                  explanation: "四条投票修正案：第15条（种族）、第19条（女性）、第24条（取消人头税）和第26条（18岁以上）。"),
            .init(text: "憲法中有四條關於投票權的修正案。描述其中一條。",
                  options: ["所有16歲及以上的人都可以投票", "18歲及以上的公民可以投票", "只有有產者才能投票", "只有納稅人才能投票"],
                  explanation: "四條投票修正案：第15條（種族）、第19條（女性）、第24條（取消人頭稅）和第26條（18歲以上）。")
        ]),
        UnifiedQuestion(id: "q_08_049", correctAnswer: 2, variants: [
            .init(text: "What is one responsibility that is only for United States citizens?",
                  options: ["Pay taxes", "Follow federal and state laws", "Serve on a jury", "Obey local ordinances"],
                  explanation: "Serving on a jury is reserved exclusively for U.S. citizens."),
            .init(text: "仅限美国公民的一项责任是什么？",
                  options: ["缴纳税款", "遵守联邦和州法律", "担任陪审团成员", "遵守地方条例"],
                  explanation: "担任陪审团成员是专属美国公民的责任。"),
            .init(text: "僅限美國公民的一項責任是什麼？",
                  options: ["繳納稅款", "遵守聯邦和州法律", "擔任陪審團成員", "遵守地方條例"],
                  explanation: "擔任陪審團成員是專屬美國公民的責任。")
        ]),
        UnifiedQuestion(id: "q_08_050", correctAnswer: 2, variants: [
            .init(text: "Name one right only for United States citizens.",
                  options: ["Freedom of speech", "Right to a fair trial", "Vote in a federal election", "Freedom of religion"],
                  explanation: "Only U.S. citizens may vote in federal elections and run for federal office."),
            .init(text: "说出一项仅属于美国公民的权利。",
                  options: ["言论自由", "公正审判权", "在联邦选举中投票", "宗教自由"],
                  explanation: "只有美国公民才能在联邦选举中投票并竞选联邦职位。"),
            .init(text: "說出一項僅屬於美國公民的權利。",
                  options: ["言論自由", "公正審判權", "在聯邦選舉中投票", "宗教自由"],
                  explanation: "只有美國公民才能在聯邦選舉中投票並競選聯邦職位。")
        ])
    ]

    // MARK: - Practice Set 6: 公民義務 (Q51–Q60)
    static let practice6: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_051", correctAnswer: 1, variants: [
            .init(text: "What are two rights of everyone living in the United States?",
                  options: ["Right to vote and run for federal office", "Freedom of speech and freedom of religion", "Free government housing and employment", "The right to bear arms and vote in local elections"],
                  explanation: "Everyone in the U.S. has rights including freedom of expression and religion."),
            .init(text: "居住在美国的每个人都有哪两项权利？",
                  options: ["投票权和竞选联邦职位的权利", "言论自由和宗教自由", "免费政府住房和就业", "持有武器权和在地方选举中投票"],
                  explanation: "美国境内的每个人都享有包括言论自由和宗教自由在内的权利。"),
            .init(text: "居住在美國的每個人都有哪兩項權利？",
                  options: ["投票權和競選聯邦職位的權利", "言論自由和宗教自由", "免費政府住房和就業", "持有武器權和在地方選舉中投票"],
                  explanation: "美國境內的每個人都享有包括言論自由和宗教自由在內的權利。")
        ]),
        UnifiedQuestion(id: "q_08_052", correctAnswer: 2, variants: [
            .init(text: "What do we show loyalty to when we say the Pledge of Allegiance?",
                  options: ["The President of the United States", "The U.S. Constitution and the courts", "The United States and the flag", "The military and veterans"],
                  explanation: "The Pledge of Allegiance is a declaration of loyalty to the United States and its flag."),
            .init(text: "我们朗诵《效忠誓词》时，是对谁表示忠诚？",
                  options: ["美国总统", "美国宪法和法院", "美国和国旗", "军队和退伍军人"],
                  explanation: "效忠誓词是对美国及其国旗的忠诚宣言。"),
            .init(text: "我們朗誦《效忠誓詞》時，是對誰表示忠誠？",
                  options: ["美國總統", "美國憲法和法院", "美國和國旗", "軍隊和退伍軍人"],
                  explanation: "效忠誓詞是對美國及其國旗的忠誠宣言。")
        ]),
        UnifiedQuestion(id: "q_08_053", correctAnswer: 1, variants: [
            .init(text: "What is one promise you make when you become a United States citizen?",
                  options: ["Never leave the United States", "Give up loyalty to other countries", "Always vote in every election", "Pay an extra citizenship tax"],
                  explanation: "The Oath of Allegiance includes giving up loyalty to foreign nations and defending the Constitution."),
            .init(text: "成为美国公民时，你要做出哪一项承诺？",
                  options: ["永不离开美国", "放弃对其他国家的效忠", "始终参加每次选举投票", "缴纳额外的公民税"],
                  explanation: "效忠宣誓包括放弃对外国的效忠以及捍卫宪法。"),
            .init(text: "成為美國公民時，你要做出哪一項承諾？",
                  options: ["永不離開美國", "放棄對其他國家的效忠", "始終參加每次選舉投票", "繳納額外的公民稅"],
                  explanation: "效忠宣誓包括放棄對外國的效忠以及捍衛憲法。")
        ]),
        UnifiedQuestion(id: "q_08_054", correctAnswer: 2, variants: [
            .init(text: "How old do citizens have to be to vote for President?",
                  options: ["16 and older", "21 and older", "18 and older", "25 and older"],
                  explanation: "The 26th Amendment (1971) set the minimum voting age at 18."),
            .init(text: "公民必须年满多少岁才能参加总统选举投票？",
                  options: ["16岁及以上", "21岁及以上", "18岁及以上", "25岁及以上"],
                  explanation: "第26条修正案（1971年）将最低投票年龄定为18岁。"),
            .init(text: "公民必須年滿多少歲才能參加總統選舉投票？",
                  options: ["16歲及以上", "21歲及以上", "18歲及以上", "25歲及以上"],
                  explanation: "第26條修正案（1971年）將最低投票年齡定為18歲。")
        ]),
        UnifiedQuestion(id: "q_08_055", correctAnswer: 1, variants: [
            .init(text: "What are two ways that Americans can participate in their democracy?",
                  options: ["Pay taxes and read the news", "Vote and join a civic group", "Work for the government and serve in the military", "Study history and learn English"],
                  explanation: "Americans can participate by voting, joining civic groups, and contacting elected officials."),
            .init(text: "美国人参与民主的两种方式是什么？",
                  options: ["缴税和阅读新闻", "投票和加入公民团体", "为政府工作和服兵役", "学习历史和学习英语"],
                  explanation: "美国人可以通过投票、加入公民团体和联系民选官员来参与民主。"),
            .init(text: "美國人參與民主的兩種方式是什麼？",
                  options: ["繳稅和閱讀新聞", "投票和加入公民團體", "為政府工作和服兵役", "學習歷史和學習英語"],
                  explanation: "美國人可以通過投票、加入公民團體和聯繫民選官員來參與民主。")
        ]),
        UnifiedQuestion(id: "q_08_056", correctAnswer: 2, variants: [
            .init(text: "When is the last day you can send in federal income tax forms?",
                  options: ["January 31", "March 15", "April 15", "June 30"],
                  explanation: "Federal income tax returns are due on April 15 each year."),
            .init(text: "联邦所得税申报表的最后提交日期是哪天？",
                  options: ["1月31日", "3月15日", "4月15日", "6月30日"],
                  explanation: "联邦所得税申报表每年4月15日到期。"),
            .init(text: "聯邦所得稅申報表的最後提交日期是哪天？",
                  options: ["1月31日", "3月15日", "4月15日", "6月30日"],
                  explanation: "聯邦所得稅申報表每年4月15日到期。")
        ]),
        UnifiedQuestion(id: "q_08_057", correctAnswer: 2, variants: [
            .init(text: "When must all men register for the Selective Service?",
                  options: ["At age 16", "At age 21", "At age 18 (between 18 and 26)", "Only during wartime when required"],
                  explanation: "All male U.S. residents must register with the Selective Service within 30 days of turning 18."),
            .init(text: "所有男性必须在何时向选征兵役局登记？",
                  options: ["16岁时", "21岁时", "18岁时（18至26岁之间）", "仅在战时需要时"],
                  explanation: "所有美国男性居民必须在年满18岁后30天内向选征兵役局登记。"),
            .init(text: "所有男性必須在何時向選征兵役局登記？",
                  options: ["16歲時", "21歲時", "18歲時（18至26歲之間）", "僅在戰時需要時"],
                  explanation: "所有美國男性居民必須在年滿18歲後30天內向選征兵役局登記。")
        ]),
        UnifiedQuestion(id: "q_08_058", correctAnswer: 2, variants: [
            .init(text: "What is one reason colonists came to America?",
                  options: ["To find gold and return to Europe", "To trade exclusively with Native Americans", "For religious freedom and political liberty", "To establish a European monarchy in the New World"],
                  explanation: "Colonists came for religious freedom, political liberty, and economic opportunity."),
            .init(text: "殖民者来到美国的一个原因是什么？",
                  options: ["寻找黄金并返回欧洲", "专门与美洲原住民贸易", "为了宗教自由和政治自由", "在新世界建立欧洲君主制"],
                  explanation: "殖民者来此是为了宗教自由、政治自由和经济机会。"),
            .init(text: "殖民者來到美國的一個原因是什麼？",
                  options: ["尋找黃金並返回歐洲", "專門與美洲原住民貿易", "為了宗教自由和政治自由", "在新世界建立歐洲君主制"],
                  explanation: "殖民者來此是為了宗教自由、政治自由和經濟機會。")
        ]),
        UnifiedQuestion(id: "q_08_059", correctAnswer: 2, variants: [
            .init(text: "Who lived in America before the Europeans arrived?",
                  options: ["Spanish explorers", "Settlers from Africa", "American Indians (Native Americans)", "Settlers from Asia"],
                  explanation: "American Indians lived in North America for thousands of years before European colonization."),
            .init(text: "欧洲人到来之前，谁住在美洲？",
                  options: ["西班牙探险家", "来自非洲的移民", "美洲印第安人（美洲原住民）", "来自亚洲的移民"],
                  explanation: "美洲印第安人在欧洲殖民之前已在北美生活了数千年。"),
            .init(text: "歐洲人到來之前，誰住在美洲？",
                  options: ["西班牙探險家", "來自非洲的移民", "美洲印第安人（美洲原住民）", "來自亞洲的移民"],
                  explanation: "美洲印第安人在歐洲殖民之前已在北美生活了數千年。")
        ]),
        UnifiedQuestion(id: "q_08_060", correctAnswer: 3, variants: [
            .init(text: "What group of people was taken to America and sold as slaves?",
                  options: ["People from Asia", "People from Europe", "People from South America", "People from Africa"],
                  explanation: "Millions of Africans were forcibly brought to America and sold into slavery."),
            .init(text: "哪个群体的人被带到美国并被卖为奴隶？",
                  options: ["来自亚洲的人", "来自欧洲的人", "来自南美洲的人", "来自非洲的人"],
                  explanation: "数百万非洲人被强行带到美国并被卖为奴隶。"),
            .init(text: "哪個群體的人被帶到美國並被賣為奴隸？",
                  options: ["來自亞洲的人", "來自歐洲的人", "來自南美洲的人", "來自非洲的人"],
                  explanation: "數百萬非洲人被強行帶到美國並被賣為奴隸。")
        ])
    ]

    // MARK: - Practice Set 7: 獨立革命 (Q61–Q70)
    static let practice7: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_061", correctAnswer: 2, variants: [
            .init(text: "Why did the colonists fight the British?",
                  options: ["To gain more land in the Western territories", "They wanted to become part of Canada", "Because of high taxes and no self-government (taxation without representation)", "To protect themselves from Native American raids"],
                  explanation: "Key causes: taxation without representation and no vote in British Parliament."),
            .init(text: "殖民者为什么与英国人作战？",
                  options: ["为了获得更多西部领土", "他们想成为加拿大的一部分", "因为高税收且没有自治权（无代表不纳税）", "为了保护自己免受美洲原住民袭击"],
                  explanation: "主要原因：无代表的征税以及在英国议会中没有投票权。"),
            .init(text: "殖民者為什麼與英國人作戰？",
                  options: ["為了獲得更多西部領土", "他們想成為加拿大的一部分", "因為高稅收且沒有自治權（無代表不納稅）", "為了保護自己免受美洲原住民襲擊"],
                  explanation: "主要原因：無代表的徵稅以及在英國議會中沒有投票權。")
        ]),
        UnifiedQuestion(id: "q_08_062", correctAnswer: 2, variants: [
            .init(text: "Who wrote the Declaration of Independence?",
                  options: ["George Washington", "Benjamin Franklin", "Thomas Jefferson", "John Adams"],
                  explanation: "Thomas Jefferson was the principal author of the Declaration of Independence."),
            .init(text: "谁起草了《独立宣言》？",
                  options: ["乔治·华盛顿", "本杰明·富兰克林", "托马斯·杰斐逊", "约翰·亚当斯"],
                  explanation: "托马斯·杰斐逊是《独立宣言》的主要起草人。"),
            .init(text: "誰起草了《獨立宣言》？",
                  options: ["喬治·華盛頓", "班傑明·富蘭克林", "托馬斯·傑佛遜", "約翰·亞當斯"],
                  explanation: "托馬斯·傑佛遜是《獨立宣言》的主要起草人。")
        ]),
        UnifiedQuestion(id: "q_08_063", correctAnswer: 0, variants: [
            .init(text: "When was the Declaration of Independence adopted?",
                  options: ["July 4, 1776", "September 17, 1787", "April 19, 1775", "March 4, 1789"],
                  explanation: "July 4, 1776 is when the Continental Congress formally adopted the Declaration of Independence."),
            .init(text: "《独立宣言》是何时被正式采纳的？",
                  options: ["1776年7月4日", "1787年9月17日", "1775年4月19日", "1789年3月4日"],
                  explanation: "1776年7月4日，大陆会议正式通过了《独立宣言》。"),
            .init(text: "《獨立宣言》是何時被正式採納的？",
                  options: ["1776年7月4日", "1787年9月17日", "1775年4月19日", "1789年3月4日"],
                  explanation: "1776年7月4日，大陸會議正式通過了《獨立宣言》。")
        ]),
        UnifiedQuestion(id: "q_08_064", correctAnswer: 2, variants: [
            .init(text: "There were 13 original states. Name three.",
                  options: ["Florida, Texas, and California", "Maine, Michigan, and Ohio", "Virginia, Pennsylvania, and New York", "Arizona, Nevada, and Utah"],
                  explanation: "The 13 original states were all former British colonies."),
            .init(text: "最初有13个州。请说出其中三个。",
                  options: ["佛罗里达州、德克萨斯州和加利福尼亚州", "缅因州、密歇根州和俄亥俄州", "弗吉尼亚州、宾夕法尼亚州和纽约州", "亚利桑那州、内华达州和犹他州"],
                  explanation: "最初的13个州都曾是英国的殖民地。"),
            .init(text: "最初有13個州。請說出其中三個。",
                  options: ["佛羅里達州、德克薩斯州和加利福尼亞州", "緬因州、密西根州和俄亥俄州", "維吉尼亞州、賓夕法尼亞州和紐約州", "亞利桑那州、內華達州和猶他州"],
                  explanation: "最初的13個州都曾是英國的殖民地。")
        ]),
        UnifiedQuestion(id: "q_08_065", correctAnswer: 2, variants: [
            .init(text: "What happened at the Constitutional Convention?",
                  options: ["The Declaration of Independence was signed", "The Civil War ended", "The Constitution was written", "Slavery was abolished throughout the country"],
                  explanation: "The Constitutional Convention in Philadelphia in 1787 drafted the U.S. Constitution."),
            .init(text: "制宪会议上发生了什么？",
                  options: ["《独立宣言》被签署", "内战结束", "《宪法》被制定", "全国废除了奴隶制"],
                  explanation: "1787年在费城召开的制宪会议起草了美国宪法。"),
            .init(text: "制憲會議上發生了什麼？",
                  options: ["《獨立宣言》被簽署", "內戰結束", "《憲法》被制定", "全國廢除了奴隸制"],
                  explanation: "1787年在費城召開的制憲會議起草了美國憲法。")
        ]),
        UnifiedQuestion(id: "q_08_066", correctAnswer: 2, variants: [
            .init(text: "When was the Constitution written?",
                  options: ["1776", "1781", "1787", "1791"],
                  explanation: "The Constitution was written in 1787 and ratified in 1788."),
            .init(text: "宪法是什么时候制定的？",
                  options: ["1776年", "1781年", "1787年", "1791年"],
                  explanation: "《宪法》于1787年制定，1788年批准生效。"),
            .init(text: "憲法是什麼時候制定的？",
                  options: ["1776年", "1781年", "1787年", "1791年"],
                  explanation: "《憲法》於1787年制定，1788年批准生效。")
        ]),
        UnifiedQuestion(id: "q_08_067", correctAnswer: 2, variants: [
            .init(text: "The Federalist Papers supported the passage of the U.S. Constitution. Name one of the writers.",
                  options: ["Thomas Jefferson", "John Adams", "Hamilton, Madison, or Jay (Publius)", "Benjamin Franklin"],
                  explanation: "The Federalist Papers were written by Alexander Hamilton, James Madison, and John Jay under the pen name 'Publius.' USCIS accepts any of their names."),
            .init(text: "《联邦党人文集》支持批准美国宪法。请说出其中一位作者的名字。",
                  options: ["托马斯·杰斐逊", "约翰·亚当斯", "汉密尔顿、麦迪逊或杰伊（普布利乌斯）", "本杰明·富兰克林"],
                  explanation: "《联邦党人文集》由 Alexander Hamilton、James Madison 和 John Jay 以笔名「Publius」共同撰写。USCIS 接受任何一位的名字。"),
            .init(text: "《聯邦黨人文集》支持批准美國憲法。請說出其中一位作者的名字。",
                  options: ["托馬斯·傑佛遜", "約翰·亞當斯", "漢米爾頓、麥迪森或傑伊（普布利烏斯）", "班傑明·富蘭克林"],
                  explanation: "《聯邦黨人文集》由 Alexander Hamilton、James Madison 和 John Jay 以筆名「Publius」共同撰寫。USCIS 接受任何一位的名字。")
        ]),
        UnifiedQuestion(id: "q_08_068", correctAnswer: 2, variants: [
            .init(text: "What is one thing Benjamin Franklin is famous for?",
                  options: ["Writing the Declaration of Independence", "Being the first President of the United States", "Being the first U.S. Postmaster General", "Leading the Union Army during the Civil War"],
                  explanation: "Benjamin Franklin was a diplomat, inventor, and the first Postmaster General."),
            .init(text: "本杰明·富兰克林以什么闻名？",
                  options: ["起草《独立宣言》", "成为美国第一任总统", "成为第一任美国邮政局长", "在内战期间领导联邦军队"],
                  explanation: "本杰明·富兰克林是外交家、发明家，也是第一任邮政局长。"),
            .init(text: "班傑明·富蘭克林以什麼聞名？",
                  options: ["起草《獨立宣言》", "成為美國第一任總統", "成為第一任美國郵政局長", "在內戰期間領導聯邦軍隊"],
                  explanation: "班傑明·富蘭克林是外交家、發明家，也是第一任郵政局長。")
        ]),
        UnifiedQuestion(id: "q_08_069", correctAnswer: 3, variants: [
            .init(text: "Who is the 'Father of Our Country'?",
                  options: ["Benjamin Franklin", "Thomas Jefferson", "John Adams", "George Washington"],
                  explanation: "George Washington is called the 'Father of Our Country.'"),
            .init(text: "谁被称为「国父」？",
                  options: ["本杰明·富兰克林", "托马斯·杰斐逊", "约翰·亚当斯", "乔治·华盛顿"],
                  explanation: "乔治·华盛顿被称为「国父」。"),
            .init(text: "誰被稱為「國父」？",
                  options: ["班傑明·富蘭克林", "托馬斯·傑佛遜", "約翰·亞當斯", "喬治·華盛頓"],
                  explanation: "喬治·華盛頓被稱為「國父」。")
        ]),
        UnifiedQuestion(id: "q_08_070", correctAnswer: 3, variants: [
            .init(text: "Who was the first President?",
                  options: ["John Adams", "Thomas Jefferson", "Benjamin Franklin", "George Washington"],
                  explanation: "George Washington became the first President in 1789."),
            .init(text: "谁是第一任总统？",
                  options: ["约翰·亚当斯", "托马斯·杰斐逊", "本杰明·富兰克林", "乔治·华盛顿"],
                  explanation: "乔治·华盛顿于1789年成为第一任总统。"),
            .init(text: "誰是第一任總統？",
                  options: ["約翰·亞當斯", "托馬斯·傑佛遜", "班傑明·富蘭克林", "喬治·華盛頓"],
                  explanation: "喬治·華盛頓於1789年成為第一任總統。")
        ])
    ]

    // MARK: - Practice Set 8: 內戰與改革 (Q71–Q80)
    static let practice8: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_071", correctAnswer: 3, variants: [
            .init(text: "What territory did the United States buy from France in 1803?",
                  options: ["Texas Territory", "Florida Territory", "Alaska Territory", "The Louisiana Territory"],
                  explanation: "The Louisiana Purchase (1803) nearly doubled the size of the U.S."),
            .init(text: "1803年美国从法国购买了哪块领土？",
                  options: ["德克萨斯领地", "佛罗里达领地", "阿拉斯加领地", "路易斯安那领地"],
                  explanation: "路易斯安那购地（1803年）使美国领土几乎翻了一番。"),
            .init(text: "1803年美國從法國購買了哪塊領土？",
                  options: ["德克薩斯領地", "佛羅里達領地", "阿拉斯加領地", "路易斯安那領地"],
                  explanation: "路易斯安那購地（1803年）使美國領土幾乎翻了一番。")
        ]),
        UnifiedQuestion(id: "q_08_072", correctAnswer: 2, variants: [
            .init(text: "Name one war fought by the United States in the 1800s.",
                  options: ["World War I", "Korean War", "The Civil War", "Vietnam War"],
                  explanation: "U.S. wars in the 1800s included the War of 1812, Mexican-American War, Civil War, and Spanish-American War."),
            .init(text: "说出美国在19世纪参与的一场战争。",
                  options: ["第一次世界大战", "朝鲜战争", "内战", "越南战争"],
                  explanation: "美国在19世纪的战争包括1812年战争、美墨战争、内战和美西战争。"),
            .init(text: "說出美國在19世紀參與的一場戰爭。",
                  options: ["第一次世界大戰", "韓戰", "內戰", "越戰"],
                  explanation: "美國在19世紀的戰爭包括1812年戰爭、美墨戰爭、內戰和美西戰爭。")
        ]),
        UnifiedQuestion(id: "q_08_073", correctAnswer: 2, variants: [
            .init(text: "Name the U.S. war between the North and the South.",
                  options: ["The Revolutionary War", "The War of 1812", "The Civil War", "The Spanish-American War"],
                  explanation: "The Civil War (1861–1865) was fought between the Northern Union and Southern Confederacy."),
            .init(text: "说出美国南北方之间的战争名称。",
                  options: ["独立战争", "1812年战争", "内战", "美西战争"],
                  explanation: "内战（1861-1865年）是在北方联邦和南方邦联之间进行的。"),
            .init(text: "說出美國南北方之間的戰爭名稱。",
                  options: ["獨立戰爭", "1812年戰爭", "內戰", "美西戰爭"],
                  explanation: "內戰（1861-1865年）是在北方聯邦和南方邦聯之間進行的。")
        ]),
        UnifiedQuestion(id: "q_08_074", correctAnswer: 2, variants: [
            .init(text: "Name one problem that led to the Civil War.",
                  options: ["A dispute solely about tariffs", "A foreign invasion of U.S. territory", "Slavery", "A conflict over the Constitution's legality"],
                  explanation: "The Civil War's causes included slavery and debates over states' rights."),
            .init(text: "说出导致内战的一个问题。",
                  options: ["纯粹关于关税的争议", "外国入侵美国领土", "奴隶制", "关于宪法合法性的冲突"],
                  explanation: "内战的原因包括奴隶制和关于州权的争论。"),
            .init(text: "說出導致內戰的一個問題。",
                  options: ["純粹關於關稅的爭議", "外國入侵美國領土", "奴隸制", "關於憲法合法性的衝突"],
                  explanation: "內戰的原因包括奴隸制和關於州權的爭論。")
        ]),
        UnifiedQuestion(id: "q_08_075", correctAnswer: 2, variants: [
            .init(text: "What was one important thing that Abraham Lincoln did?",
                  options: ["Wrote the U.S. Constitution", "Won the Spanish-American War", "Freed the slaves (Emancipation Proclamation)", "Purchased Alaska from Russia"],
                  explanation: "Lincoln issued the Emancipation Proclamation (1863), freeing enslaved people in Confederate states."),
            .init(text: "亚伯拉罕·林肯做了一件什么重要的事情？",
                  options: ["起草了美国宪法", "赢得了美西战争", "解放了奴隶（《解放宣言》）", "从俄罗斯购买了阿拉斯加"],
                  explanation: "林肯颁布了《解放宣言》（1863年），宣布解放南方邦联各州的奴隶。"),
            .init(text: "亞伯拉罕·林肯做了一件什麼重要的事情？",
                  options: ["起草了美國憲法", "贏得了美西戰爭", "解放了奴隸（《解放宣言》）", "從俄羅斯購買了阿拉斯加"],
                  explanation: "林肯頒布了《解放宣言》（1863年），宣布解放南方邦聯各州的奴隸。")
        ]),
        UnifiedQuestion(id: "q_08_076", correctAnswer: 2, variants: [
            .init(text: "What did the Emancipation Proclamation do?",
                  options: ["Officially ended the Civil War", "Gave women the right to vote", "Freed the slaves in Confederate states", "Created the Republican Party"],
                  explanation: "The Emancipation Proclamation declared all enslaved people in Confederate states to be free."),
            .init(text: "《解放宣言》起到了什么作用？",
                  options: ["正式结束了内战", "赋予了女性投票权", "解放了南方邦联各州的奴隶", "创建了共和党"],
                  explanation: "《解放宣言》宣布南方邦联各州的所有奴隶获得自由。"),
            .init(text: "《解放宣言》起到了什麼作用？",
                  options: ["正式結束了內戰", "賦予了女性投票權", "解放了南方邦聯各州的奴隸", "創建了共和黨"],
                  explanation: "《解放宣言》宣布南方邦聯各州的所有奴隸獲得自由。")
        ]),
        UnifiedQuestion(id: "q_08_077", correctAnswer: 3, variants: [
            .init(text: "What did Susan B. Anthony do?",
                  options: ["Led the Underground Railroad to free enslaved people", "Wrote the Emancipation Proclamation", "Was the first woman elected to the U.S. Congress", "Fought for women's rights and civil rights"],
                  explanation: "Susan B. Anthony campaigned for women's right to vote. The 19th Amendment is sometimes called the 'Susan B. Anthony Amendment.'"),
            .init(text: "苏珊·B·安东尼做了什么？",
                  options: ["领导地下铁路解放奴隶", "起草了《解放宣言》", "成为第一位当选美国国会议员的女性", "为女权和公民权利而斗争"],
                  explanation: "苏珊·B·安东尼为女性投票权奔走呼号。第19条修正案有时被称为「苏珊·B·安东尼修正案」。"),
            .init(text: "蘇珊·B·安東尼做了什麼？",
                  options: ["領導地下鐵路解放奴隸", "起草了《解放宣言》", "成為第一位當選美國國會議員的女性", "為女權和公民權利而奮鬥"],
                  explanation: "蘇珊·B·安東尼為女性投票權奔走呼號。第19條修正案有時被稱為「蘇珊·B·安東尼修正案」。")
        ]),
        UnifiedQuestion(id: "q_08_078", correctAnswer: 3, variants: [
            .init(text: "Name one war fought by the United States in the 1900s.",
                  options: ["The Civil War", "The Revolutionary War", "The War of 1812", "World War I"],
                  explanation: "U.S. wars in the 1900s: WWI, WWII, Korean War, Vietnam War, and Persian Gulf War."),
            .init(text: "说出美国在20世纪参与的一场战争。",
                  options: ["内战", "独立战争", "1812年战争", "第一次世界大战"],
                  explanation: "美国在20世纪的战争包括：一战、二战、朝鲜战争、越战和波斯湾战争。"),
            .init(text: "說出美國在20世紀參與的一場戰爭。",
                  options: ["內戰", "獨立戰爭", "1812年戰爭", "第一次世界大戰"],
                  explanation: "美國在20世紀的戰爭包括：一戰、二戰、韓戰、越戰和波斯灣戰爭。")
        ]),
        UnifiedQuestion(id: "q_08_079", correctAnswer: 2, variants: [
            .init(text: "Who was President during World War I?",
                  options: ["Theodore Roosevelt", "Abraham Lincoln", "Woodrow Wilson", "Franklin Roosevelt"],
                  explanation: "Woodrow Wilson was the 28th President. He led the United States through World War I (1917–1918) and proposed the League of Nations to maintain world peace after the war."),
            .init(text: "第一次世界大战期间谁是美国总统？",
                  options: ["西奥多·罗斯福", "亚伯拉罕·林肯", "伍德罗·威尔逊", "富兰克林·罗斯福"],
                  explanation: "伍德罗·威尔逊是第 28 任总统。他领导美国经历了第一次世界大战（1917–1918），并提议成立国际联盟以维护战后世界和平。"),
            .init(text: "第一次世界大戰期間誰是美國總統？",
                  options: ["西奧多·羅斯福", "亞伯拉罕·林肯", "伍德羅·威爾遜", "富蘭克林·羅斯福"],
                  explanation: "伍德羅·威爾遜是第 28 任總統。他領導美國經歷了第一次世界大戰（1917–1918），並提議成立國際聯盟以維護戰後世界和平。")
        ]),
        UnifiedQuestion(id: "q_08_080", correctAnswer: 3, variants: [
            .init(text: "Who was President during the Great Depression and World War II?",
                  options: ["Herbert Hoover", "Calvin Coolidge", "Harry Truman", "Franklin Roosevelt"],
                  explanation: "Franklin D. Roosevelt (FDR), the 32nd President, led the nation through both the Great Depression and World War II. He served four terms — the most of any President."),
            .init(text: "大萧条和第二次世界大战期间谁是美国总统？",
                  options: ["赫伯特·胡佛", "卡尔文·柯立芝", "哈里·杜鲁门", "富兰克林·罗斯福"],
                  explanation: "富兰克林·罗斯福（FDR），第 32 任总统，带领美国经历了大萧条和第二次世界大战。他连任四届，是历史上任期最长的总统。"),
            .init(text: "大蕭條和第二次世界大戰期間誰是美國總統？",
                  options: ["赫伯特·胡佛", "卡爾文·柯立芝", "哈利·杜魯門", "富蘭克林·羅斯福"],
                  explanation: "富蘭克林·羅斯福（FDR），第 32 任總統，帶領美國經歷了大蕭條和第二次世界大戰。他連任四屆，是歷史上任期最長的總統。")
        ])
    ]

    // MARK: - Practice Set 9: 現代歷史與地理 (Q81–Q90)
    static let practice9: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_081", correctAnswer: 2, variants: [
            .init(text: "Who did the United States fight in World War II?",
                  options: ["Germany, Russia, and China", "Japan, France, and Italy", "Japan, Germany, and Italy", "Britain, France, and Germany"],
                  explanation: "The U.S. fought the Axis Powers: Japan, Germany, and Italy."),
            .init(text: "美国在第二次世界大战中与谁作战？",
                  options: ["德国、俄罗斯和中国", "日本、法国和意大利", "日本、德国和意大利", "英国、法国和德国"],
                  explanation: "美国与轴心国作战：日本、德国和意大利。"),
            .init(text: "美國在第二次世界大戰中與誰作戰？",
                  options: ["德國、俄羅斯和中國", "日本、法國和義大利", "日本、德國和義大利", "英國、法國和德國"],
                  explanation: "美國與軸心國作戰：日本、德國和義大利。")
        ]),
        UnifiedQuestion(id: "q_08_082", correctAnswer: 1, variants: [
            .init(text: "Before he was President, Eisenhower was a general. What war was he in?",
                  options: ["World War I", "World War II", "Korean War", "Vietnam War"],
                  explanation: "Eisenhower served as Supreme Commander of Allied Forces in Europe during WWII."),
            .init(text: "在成为总统之前，艾森豪威尔是一名将军。他参加了哪场战争？",
                  options: ["第一次世界大战", "第二次世界大战", "朝鲜战争", "越南战争"],
                  explanation: "艾森豪威尔在二战期间担任欧洲盟军最高统帅。"),
            .init(text: "在成為總統之前，艾森豪是一名將軍。他參加了哪場戰爭？",
                  options: ["第一次世界大戰", "第二次世界大戰", "韓戰", "越戰"],
                  explanation: "艾森豪在二戰期間擔任歐洲盟軍最高統帥。")
        ]),
        UnifiedQuestion(id: "q_08_083", correctAnswer: 3, variants: [
            .init(text: "During the Cold War, what was the main concern of the United States?",
                  options: ["Economic recession and unemployment", "Climate change and pollution", "Illegal immigration", "Communism / the spread of communism and nuclear war"],
                  explanation: "The Cold War (1947–1991) was a global conflict between the democratic U.S. and communist Soviet Union."),
            .init(text: "冷战期间，美国最主要的担忧是什么？",
                  options: ["经济衰退和失业", "气候变化和污染", "非法移民", "共产主义 / 共产主义的扩散和核战争"],
                  explanation: "冷战（1947–1991年）是民主国家美国与共产主义苏联之间的全球性对抗。"),
            .init(text: "冷戰期間，美國最主要的擔憂是什麼？",
                  options: ["經濟衰退和失業", "氣候變化和污染", "非法移民", "共產主義 / 共產主義的擴散和核戰爭"],
                  explanation: "冷戰（1947–1991年）是民主國家美國與共產主義蘇聯之間的全球性對抗。")
        ]),
        UnifiedQuestion(id: "q_08_084", correctAnswer: 2, variants: [
            .init(text: "What movement tried to end racial discrimination?",
                  options: ["The Temperance Movement", "The Labor Movement", "The Civil Rights Movement", "The Women's Suffrage Movement"],
                  explanation: "The Civil Rights Movement of the 1950s–1960s fought to end racial segregation."),
            .init(text: "哪个运动试图终结种族歧视？",
                  options: ["禁酒运动", "劳工运动", "民权运动", "女性选举权运动"],
                  explanation: "1950至1960年代的民权运动致力于终结种族隔离。"),
            .init(text: "哪個運動試圖終結種族歧視？",
                  options: ["禁酒運動", "勞工運動", "民權運動", "女性選舉權運動"],
                  explanation: "1950至1960年代的民權運動致力於終結種族隔離。")
        ]),
        UnifiedQuestion(id: "q_08_085", correctAnswer: 2, variants: [
            .init(text: "What did Martin Luther King, Jr. do?",
                  options: ["Led the Underground Railroad to free enslaved people", "Served as the first Black President of the NAACP", "Fought for civil rights and equality for all Americans", "Wrote the Civil Rights Act of 1964"],
                  explanation: "Dr. Martin Luther King, Jr. was the most prominent Civil Rights leader. He received the Nobel Peace Prize in 1964."),
            .init(text: "小马丁·路德·金做了什么？",
                  options: ["领导地下铁路解放奴隶", "担任全国有色人种协进会第一任黑人主席", "为所有美国人的公民权利和平等而斗争", "起草了1964年《民权法案》"],
                  explanation: "小马丁·路德·金博士是最杰出的民权领袖。他于1964年获得诺贝尔和平奖。"),
            .init(text: "小馬丁·路德·金恩做了什麼？",
                  options: ["領導地下鐵路解放奴隸", "擔任全國有色人種協進會第一任黑人主席", "為所有美國人的公民權利和平等而奮鬥", "起草了1964年《民權法案》"],
                  explanation: "小馬丁·路德·金恩博士是最傑出的民權領袖。他於1964年獲得諾貝爾和平獎。")
        ]),
        UnifiedQuestion(id: "q_08_086", correctAnswer: 2, variants: [
            .init(text: "What major event happened on September 11, 2001, in the United States?",
                  options: ["A major hurricane struck the East Coast", "A financial crisis closed the stock market", "Terrorists attacked the United States", "The United States declared war on Iraq"],
                  explanation: "On September 11, 2001, al-Qaeda terrorists hijacked four planes and attacked the World Trade Center (New York) and the Pentagon (Virginia). Nearly 3,000 people were killed."),
            .init(text: "2001 年 9 月 11 日，美国发生了什么重大事件？",
                  options: ["一场大型飓风袭击了东海岸", "一场金融危机导致股市关闭", "恐怖分子袭击了美国", "美国向伊拉克宣战"],
                  explanation: "2001 年 9 月 11 日，基地组织恐怖分子劫持了四架飞机，袭击了纽约的世界贸易中心和弗吉尼亚州的五角大楼，近 3,000 人在袭击中遇难。"),
            .init(text: "2001 年 9 月 11 日，美國發生了什麼重大事件？",
                  options: ["一場大型颶風襲擊了東海岸", "一場金融危機導致股市關閉", "恐怖分子襲擊了美國", "美國向伊拉克宣戰"],
                  explanation: "2001 年 9 月 11 日，蓋達組織恐怖分子劫持了四架飛機，襲擊了紐約的世界貿易中心和維吉尼亞州的五角大廈，近 3,000 人在襲擊中遇難。")
        ]),
        UnifiedQuestion(id: "q_08_087", correctAnswer: 3, variants: [
            .init(text: "Name one American Indian tribe in the United States.",
                  options: ["Aztec", "Maya", "Inca", "Cherokee or Navajo"],
                  explanation: "USCIS accepts many tribes: Cherokee, Navajo, Sioux, Chippewa, Choctaw, Pueblo, Apache, Iroquois, Creek, Blackfeet, Seminole, Cheyenne, Shawnee, Lakota, Crow, Hopi, Inuit, and others."),
            .init(text: "请说出美国的一个印第安部落。",
                  options: ["阿兹特克", "玛雅", "印加", "切罗基或纳瓦霍"],
                  explanation: "USCIS 接受的部落包括：切罗基、纳瓦霍、苏族、奇佩瓦、乔克托、普韦布洛、阿帕奇、易洛魁、克里克、黑脚、塞米诺尔、夏延、肖尼、拉科塔、克劳、霍皮、因纽特等。（阿兹特克、玛雅、印加均属拉丁美洲，并非美国印第安人。）"),
            .init(text: "請說出美國的一個印第安部落。",
                  options: ["阿茲特克", "馬雅", "印加", "切羅基或納瓦荷"],
                  explanation: "USCIS 接受的部落包括：切羅基、納瓦荷、蘇族、奇佩瓦、喬克托、普韋布洛、阿帕奇、易洛魁、克里克、黑腳、塞米諾爾、夏延、肖尼、拉科塔、克勞、霍皮、因紐特等。（阿茲特克、馬雅、印加均屬拉丁美洲，並非美國印第安人。）")
        ]),
        UnifiedQuestion(id: "q_08_088", correctAnswer: 2, variants: [
            .init(text: "Name one of the two longest rivers in the United States.",
                  options: ["The Colorado River or the Rio Grande", "The Ohio River or the Columbia River", "The Missouri River or the Mississippi River", "The Hudson River or the Tennessee River"],
                  explanation: "The Missouri River and Mississippi River are the two longest rivers in the United States."),
            .init(text: "说出美国两条最长河流中的一条。",
                  options: ["科罗拉多河或格兰德河", "俄亥俄河或哥伦比亚河", "密苏里河或密西西比河", "哈德逊河或田纳西河"],
                  explanation: "密苏里河和密西西比河是美国最长的两条河流。"),
            .init(text: "說出美國兩條最長河流中的一條。",
                  options: ["科羅拉多河或格蘭德河", "俄亥俄河或哥倫比亞河", "密蘇里河或密西西比河", "哈德遜河或田納西河"],
                  explanation: "密蘇里河和密西西比河是美國最長的兩條河流。")
        ]),
        UnifiedQuestion(id: "q_08_089", correctAnswer: 3, variants: [
            .init(text: "What ocean is on the West Coast of the United States?",
                  options: ["Atlantic Ocean", "Indian Ocean", "Arctic Ocean", "Pacific Ocean"],
                  explanation: "The Pacific Ocean borders the West Coast of the United States."),
            .init(text: "美国西海岸濒临哪个大洋？",
                  options: ["大西洋", "印度洋", "北冰洋", "太平洋"],
                  explanation: "太平洋毗邻美国西海岸。"),
            .init(text: "美國西海岸瀕臨哪個大洋？",
                  options: ["大西洋", "印度洋", "北冰洋", "太平洋"],
                  explanation: "太平洋毗鄰美國西海岸。")
        ]),
        UnifiedQuestion(id: "q_08_090", correctAnswer: 2, variants: [
            .init(text: "What ocean is on the East Coast of the United States?",
                  options: ["Pacific Ocean", "Indian Ocean", "Atlantic Ocean", "Arctic Ocean"],
                  explanation: "The Atlantic Ocean borders the East Coast of the United States."),
            .init(text: "美国东海岸濒临哪个大洋？",
                  options: ["太平洋", "印度洋", "大西洋", "北冰洋"],
                  explanation: "大西洋毗邻美国东海岸。"),
            .init(text: "美國東海岸瀕臨哪個大洋？",
                  options: ["太平洋", "印度洋", "大西洋", "北冰洋"],
                  explanation: "大西洋毗鄰美國東海岸。")
        ])
    ]

    // MARK: - Practice Set 10: 地理與節假日 (Q91–Q100)
    static let practice10: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_08_091", correctAnswer: 1, variants: [
            .init(text: "Name one U.S. territory.",
                  options: ["Cuba", "Puerto Rico", "Dominican Republic", "Philippines"],
                  explanation: "U.S. territories include Puerto Rico, U.S. Virgin Islands, American Samoa, Guam, and the Northern Mariana Islands."),
            .init(text: "说出一个美国领土。",
                  options: ["古巴", "波多黎各", "多米尼加共和国", "菲律宾"],
                  explanation: "美国领土包括波多黎各、美属维尔京群岛、美属萨摩亚、关岛和北马里亚纳群岛。"),
            .init(text: "說出一個美國領土。",
                  options: ["古巴", "波多黎各", "多明尼加共和國", "菲律賓"],
                  explanation: "美國領土包括波多黎各、美屬維爾京群島、美屬薩摩亞、關島和北馬里亞納群島。")
        ]),
        UnifiedQuestion(id: "q_08_092", correctAnswer: 3, variants: [
            .init(text: "Name one state that borders Canada.",
                  options: ["California", "Florida", "Texas", "Minnesota"],
                  explanation: "States bordering Canada include Maine, New York, Michigan, Minnesota, North Dakota, Montana, Idaho, Washington, and Alaska."),
            .init(text: "说出一个与加拿大接壤的州。",
                  options: ["加利福尼亚州", "佛罗里达州", "德克萨斯州", "明尼苏达州"],
                  explanation: "与加拿大接壤的州包括缅因州、纽约州、密歇根州、明尼苏达州、北达科他州、蒙大拿州、爱达荷州、华盛顿州和阿拉斯加州。"),
            .init(text: "說出一個與加拿大接壤的州。",
                  options: ["加利福尼亞州", "佛羅里達州", "德克薩斯州", "明尼蘇達州"],
                  explanation: "與加拿大接壤的州包括緬因州、紐約州、密西根州、明尼蘇達州、北達科他州、蒙大拿州、愛達荷州、華盛頓州和阿拉斯加州。")
        ]),
        UnifiedQuestion(id: "q_08_093", correctAnswer: 3, variants: [
            .init(text: "Name one state that borders Mexico.",
                  options: ["Florida", "Louisiana", "Nevada", "Texas"],
                  explanation: "Four states share a border with Mexico: California, Arizona, New Mexico, and Texas."),
            .init(text: "说出一个与墨西哥接壤的州。",
                  options: ["佛罗里达州", "路易斯安那州", "内华达州", "德克萨斯州"],
                  explanation: "与墨西哥接壤的四个州：加利福尼亚州、亚利桑那州、新墨西哥州和德克萨斯州。"),
            .init(text: "說出一個與墨西哥接壤的州。",
                  options: ["佛羅里達州", "路易斯安那州", "內華達州", "德克薩斯州"],
                  explanation: "與墨西哥接壤的四個州：加利福尼亞州、亞利桑那州、新墨西哥州和德克薩斯州。")
        ]),
        UnifiedQuestion(id: "q_08_094", correctAnswer: 3, variants: [
            .init(text: "What is the capital of the United States?",
                  options: ["New York City", "Los Angeles", "Chicago", "Washington, D.C."],
                  explanation: "Washington, D.C. has been the nation's capital since 1800."),
            .init(text: "美国的首都是哪里？",
                  options: ["纽约市", "洛杉矶", "芝加哥", "华盛顿特区"],
                  explanation: "华盛顿特区自1800年起成为美国首都。"),
            .init(text: "美國的首都是哪裡？",
                  options: ["紐約市", "洛杉磯", "芝加哥", "華盛頓特區"],
                  explanation: "華盛頓特區自1800年起成為美國首都。")
        ]),
        UnifiedQuestion(id: "q_08_095", correctAnswer: 2, variants: [
            .init(text: "Where is the Statue of Liberty?",
                  options: ["Philadelphia, Pennsylvania", "Boston, Massachusetts", "New York (Harbor) / Liberty Island", "Washington, D.C."],
                  explanation: "The Statue of Liberty stands on Liberty Island in New York Harbor, a gift from France dedicated in 1886."),
            .init(text: "自由女神像在哪里？",
                  options: ["宾夕法尼亚州费城", "马萨诸塞州波士顿", "纽约（港口）/ 自由岛", "华盛顿特区"],
                  explanation: "自由女神像矗立在纽约港自由岛上，是法国于1886年赠送的礼物。"),
            .init(text: "自由女神像在哪裡？",
                  options: ["賓夕法尼亞州費城", "麻薩諸塞州波士頓", "紐約（港口）/ 自由島", "華盛頓特區"],
                  explanation: "自由女神像矗立在紐約港自由島上，是法國於1886年贈送的禮物。")
        ]),
        UnifiedQuestion(id: "q_08_096", correctAnswer: 2, variants: [
            .init(text: "Why does the flag have 13 stripes?",
                  options: ["For the 13 presidents who served before Lincoln", "For the 13 amendments that form the Bill of Rights", "Because there were 13 original colonies", "For the 13 original Supreme Court justices"],
                  explanation: "The 13 stripes represent the original 13 colonies."),
            .init(text: "国旗为什么有13条条纹？",
                  options: ["代表林肯之前的13位总统", "代表构成《权利法案》的13条修正案", "因为最初有13个殖民地", "代表最初的13位最高法院大法官"],
                  explanation: "13条条纹代表最初的13个殖民地。"),
            .init(text: "國旗為什麼有13條條紋？",
                  options: ["代表林肯之前的13位總統", "代表構成《權利法案》的13條修正案", "因為最初有13個殖民地", "代表最初的13位最高法院大法官"],
                  explanation: "13條條紋代表最初的13個殖民地。")
        ]),
        UnifiedQuestion(id: "q_08_097", correctAnswer: 3, variants: [
            .init(text: "Why does the flag have 50 stars?",
                  options: ["For the 50 largest U.S. cities", "For the 50 years since independence", "For the 50 most important federal laws", "Because there is one star for each state"],
                  explanation: "Each of the 50 stars represents one U.S. state."),
            .init(text: "国旗为什么有50颗星？",
                  options: ["代表美国50个最大城市", "代表独立后的50年", "代表50项最重要的联邦法律", "因为每颗星代表一个州"],
                  explanation: "50颗星中每一颗代表美国的一个州。"),
            .init(text: "國旗為什麼有50顆星？",
                  options: ["代表美國50個最大城市", "代表獨立後的50年", "代表50項最重要的聯邦法律", "因為每顆星代表一個州"],
                  explanation: "50顆星中每一顆代表美國的一個州。")
        ]),
        UnifiedQuestion(id: "q_08_098", correctAnswer: 3, variants: [
            .init(text: "What is the name of the national anthem?",
                  options: ["America the Beautiful", "God Bless America", "My Country, 'Tis of Thee", "The Star-Spangled Banner"],
                  explanation: "'The Star-Spangled Banner' became the national anthem in 1931."),
            .init(text: "国歌的名称是什么？",
                  options: ["《美丽的美国》", "《上帝保佑美国》", "《我的国家，属于你》", "《星条旗》"],
                  explanation: "《星条旗》于1931年成为美国国歌。"),
            .init(text: "國歌的名稱是什麼？",
                  options: ["《美麗的美國》", "《上帝保佑美國》", "《我的國家，屬於你》", "《星條旗》"],
                  explanation: "《星條旗》於1931年成為美國國歌。")
        ]),
        UnifiedQuestion(id: "q_08_099", correctAnswer: 1, variants: [
            .init(text: "When do we celebrate Independence Day?",
                  options: ["July 1", "July 4", "September 4", "October 31"],
                  explanation: "Independence Day (July 4th) celebrates the adoption of the Declaration of Independence on July 4, 1776."),
            .init(text: "我们什么时候庆祝独立日？",
                  options: ["7月1日", "7月4日", "9月4日", "10月31日"],
                  explanation: "独立日（7月4日）庆祝1776年7月4日《独立宣言》的通过。"),
            .init(text: "我們什麼時候慶祝獨立日？",
                  options: ["7月1日", "7月4日", "9月4日", "10月31日"],
                  explanation: "獨立日（7月4日）慶祝1776年7月4日《獨立宣言》的通過。")
        ]),
        UnifiedQuestion(id: "q_08_100", correctAnswer: 1, variants: [
            .init(text: "Name two national U.S. holidays.",
                  options: ["Valentine's Day and Easter", "Independence Day and Thanksgiving", "Hanukkah and Kwanzaa", "New Year's Eve and April Fool's Day"],
                  explanation: "Federal holidays include Independence Day, Thanksgiving, New Year's Day, Memorial Day, Veterans Day, and Christmas."),
            .init(text: "说出两个美国全国性节假日。",
                  options: ["情人节和复活节", "独立日和感恩节", "光明节和宽扎节", "跨年夜和愚人节"],
                  explanation: "联邦节假日包括独立日、感恩节、元旦、阵亡将士纪念日、退伍军人节和圣诞节。"),
            .init(text: "說出兩個美國全國性節假日。",
                  options: ["情人節和復活節", "獨立日和感恩節", "光明節和寬扎節", "跨年夜和愚人節"],
                  explanation: "聯邦節假日包括獨立日、感恩節、元旦、陣亡將士紀念日、退伍軍人節和聖誕節。")
        ])
    ]
}
