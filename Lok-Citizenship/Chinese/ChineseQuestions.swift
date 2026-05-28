import Foundation

/// All Chinese (English ↔ Simplified ↔ Traditional) quiz question sets — the
/// 128 official 2025 USCIS naturalization civics questions, regrouped
/// thematically across 8 practice levels of exactly 16 questions each. IDs
/// (`q_25_NNN`) match the official USCIS question numbering 1-128 and mirror
/// EnglishQuestions.swift so a learner's mastery is interchangeable across
/// English, Simplified Chinese, and Traditional Chinese.
///
/// Each question has 3 variants: [English, Simplified, Traditional]. The
/// English variant (index 0) is byte-identical to the same-ID question in
/// EnglishQuestions, so trilingual learners can toggle mid-quiz without
/// breaking spaced repetition.
///
/// Chinese terminology follows the official USCIS 100-question Chinese PDF
/// (the canonical USCIS style reference, since the 2025 128-question test
/// has not yet been published in Chinese): 憲法/宪法, 國會/国会, 參議院/参议院,
/// 眾議院/众议院, 最高法院, 三軍統帥/三军统帅, 權利法案/权利法案,
/// 獨立宣言/独立宣言, 解放宣言/解放宣言, 制衡, etc.
enum ChineseQuestions {

    // MARK: - Practice 1: Government Basics & Symbols (16 questions)
    static let practice1: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_001", correctAnswer: 0, variants: [
            .init(text: "What is the form of government of the United States?",
                  options: ["Republic", "Monarchy", "Dictatorship", "Direct democracy"],
                  explanation: "The U.S. is a constitution-based federal republic — a representative democracy where citizens elect officials to govern."),
            .init(text: "美国的政府形式是什么？",
                  options: ["共和国", "君主制", "独裁", "直接民主制"],
                  explanation: "美国是基于宪法的联邦共和国——一种由公民选举官员进行治理的代议制民主政体。"),
            .init(text: "美國的政府形式是什麼？",
                  options: ["共和國", "君主制", "獨裁", "直接民主制"],
                  explanation: "美國是基於憲法的聯邦共和國——一種由公民選舉官員進行治理的代議制民主政體。")
        ]),
        UnifiedQuestion(id: "q_25_012", correctAnswer: 2, variants: [
            .init(text: "What is the economic system of the United States?",
                  options: ["Socialism", "Communism", "Capitalism", "Feudalism"],
                  explanation: "The U.S. operates a capitalist (free market) economy, where businesses and prices are largely determined by supply and demand."),
            .init(text: "美国的经济制度是什么？",
                  options: ["社会主义", "共产主义", "资本主义", "封建主义"],
                  explanation: "美国采用资本主义（自由市场）经济，企业和价格主要由供需关系决定。"),
            .init(text: "美國的經濟制度是什麼？",
                  options: ["社會主義", "共產主義", "資本主義", "封建主義"],
                  explanation: "美國採用資本主義（自由市場）經濟，企業和價格主要由供需關係決定。")
        ]),
        UnifiedQuestion(id: "q_25_016", correctAnswer: 1, variants: [
            .init(text: "Name the three branches of government.",
                  options: ["Federal, state, local", "Legislative, executive, and judicial", "President, Senate, House", "Republican, Democrat, Independent"],
                  explanation: "The three branches are the Legislative (Congress), Executive (President), and Judicial (the courts), each with separate powers."),
            .init(text: "请列出政府的三个分支。",
                  options: ["联邦、州、地方", "立法、行政和司法", "总统、参议院、众议院", "共和党、民主党、独立人士"],
                  explanation: "三个分支分别是立法部门（国会）、行政部门（总统）和司法部门（法院），各自拥有独立的权力。"),
            .init(text: "請列出政府的三個分支。",
                  options: ["聯邦、州、地方", "立法、行政和司法", "總統、參議院、眾議院", "共和黨、民主黨、獨立人士"],
                  explanation: "三個分支分別是立法部門（國會）、行政部門（總統）和司法部門（法院），各自擁有獨立的權力。")
        ]),
        UnifiedQuestion(id: "q_25_017", correctAnswer: 2, variants: [
            .init(text: "The President of the United States is in charge of which branch of government?",
                  options: ["Legislative branch", "Judicial branch", "Executive branch", "Military branch"],
                  explanation: "The President leads the Executive branch, which enforces the laws passed by Congress."),
            .init(text: "美国总统负责政府的哪个分支？",
                  options: ["立法部门", "司法部门", "行政部门", "军事部门"],
                  explanation: "总统领导行政部门，行政部门负责执行国会通过的法律。"),
            .init(text: "美國總統負責政府的哪個分支？",
                  options: ["立法部門", "司法部門", "行政部門", "軍事部門"],
                  explanation: "總統領導行政部門，行政部門負責執行國會通過的法律。")
        ]),
        UnifiedQuestion(id: "q_25_038", correctAnswer: 2, variants: [
            .init(text: "What is the name of the President of the United States now?",
                  options: ["Joe Biden", "Barack Obama", "Donald Trump", "George W. Bush"],
                  explanation: "Donald Trump is the current President, serving his second term beginning January 2025."),
            .init(text: "现任美国总统的名字是什么？",
                  options: ["乔·拜登", "巴拉克·奥巴马", "唐纳德·特朗普", "乔治·W·布什"],
                  explanation: "唐纳德·特朗普是现任总统，自 2025 年 1 月起开始他的第二个任期。"),
            .init(text: "現任美國總統的名字是什麼？",
                  options: ["喬·拜登", "巴拉克·歐巴馬", "唐納德·特朗普", "喬治·W·布什"],
                  explanation: "唐納德·特朗普是現任總統，自 2025 年 1 月起開始他的第二個任期。")
        ]),
        UnifiedQuestion(id: "q_25_039", correctAnswer: 1, variants: [
            .init(text: "What is the name of the Vice President of the United States now?",
                  options: ["Kamala Harris", "JD Vance", "Mike Pence", "Joe Biden"],
                  explanation: "JD Vance became Vice President in January 2025, serving alongside President Trump."),
            .init(text: "现任美国副总统的名字是什么？",
                  options: ["卡马拉·哈里斯", "JD·万斯", "迈克·彭斯", "乔·拜登"],
                  explanation: "JD·万斯于 2025 年 1 月就任副总统，与特朗普总统共同执政。"),
            .init(text: "現任美國副總統的名字是什麼？",
                  options: ["卡馬拉·哈里斯", "JD·萬斯", "邁克·彭斯", "喬·拜登"],
                  explanation: "JD·萬斯於 2025 年 1 月就任副總統，與特朗普總統共同執政。")
        ]),
        UnifiedQuestion(id: "q_25_040", correctAnswer: 1, variants: [
            .init(text: "If the President can no longer serve, who becomes President?",
                  options: ["The Speaker of the House", "The Vice President", "The Secretary of State", "The Chief Justice"],
                  explanation: "The Vice President becomes President if the President can no longer serve, per the 25th Amendment."),
            .init(text: "如果总统无法继续任职，谁将成为总统？",
                  options: ["众议院议长", "副总统", "国务卿", "首席大法官"],
                  explanation: "根据第 25 修正案，若总统无法继续任职，副总统将成为总统。"),
            .init(text: "如果總統無法繼續任職，誰將成為總統？",
                  options: ["眾議院議長", "副總統", "國務卿", "首席大法官"],
                  explanation: "根據第 25 修正案，若總統無法繼續任職，副總統將成為總統。")
        ]),
        UnifiedQuestion(id: "q_25_042", correctAnswer: 0, variants: [
            .init(text: "Who is Commander in Chief of the U.S. military?",
                  options: ["The President", "The Secretary of Defense", "A military general", "The Vice President"],
                  explanation: "The President serves as Commander in Chief, which keeps the military under civilian control."),
            .init(text: "谁是美国军队的三军统帅？",
                  options: ["总统", "国防部长", "军队将领", "副总统"],
                  explanation: "总统担任三军统帅，使军队处于文官控制之下。"),
            .init(text: "誰是美國軍隊的三軍統帥？",
                  options: ["總統", "國防部長", "軍隊將領", "副總統"],
                  explanation: "總統擔任三軍統帥，使軍隊處於文官控制之下。")
        ]),
        UnifiedQuestion(id: "q_25_052", correctAnswer: 2, variants: [
            .init(text: "What is the highest court in the United States?",
                  options: ["Federal Court", "Court of Appeals", "Supreme Court", "Circuit Court"],
                  explanation: "The Supreme Court is the highest court in the U.S. Its decisions are final and apply to all lower courts."),
            .init(text: "美国的最高法院是什么？",
                  options: ["联邦法院", "上诉法院", "最高法院", "巡回法院"],
                  explanation: "最高法院是美国最高的法院，其裁决具有终审效力并适用于所有下级法院。"),
            .init(text: "美國的最高法院是什麼？",
                  options: ["聯邦法院", "上訴法院", "最高法院", "巡迴法院"],
                  explanation: "最高法院是美國最高的法院，其裁決具有終審效力並適用於所有下級法院。")
        ]),
        UnifiedQuestion(id: "q_25_053", correctAnswer: 1, variants: [
            .init(text: "How many seats are on the Supreme Court?",
                  options: ["7", "9", "11", "13"],
                  explanation: "The Supreme Court has 9 seats: one Chief Justice and eight Associate Justices, set by the Judiciary Act of 1869."),
            .init(text: "最高法院有多少个席位？",
                  options: ["7", "9", "11", "13"],
                  explanation: "最高法院共有 9 个席位：一位首席大法官和八位陪席大法官，由 1869 年《司法法》确定。"),
            .init(text: "最高法院有多少個席位？",
                  options: ["7", "9", "11", "13"],
                  explanation: "最高法院共有 9 個席位：一位首席大法官和八位陪席大法官，由 1869 年《司法法》確定。")
        ]),
        UnifiedQuestion(id: "q_25_066", correctAnswer: 2, variants: [
            .init(text: "What do we show loyalty to when we say the Pledge of Allegiance?",
                  options: ["The President", "The state government", "The United States and the flag", "The military"],
                  explanation: "The Pledge of Allegiance shows loyalty to the United States and to the U.S. flag — symbols of the nation as a whole."),
            .init(text: "我们在宣誓效忠时是向什么表达忠诚？",
                  options: ["总统", "州政府", "美利坚合众国和国旗", "军队"],
                  explanation: "宣誓效忠是向美利坚合众国及美国国旗——整个国家的象征——表达忠诚。"),
            .init(text: "我們在宣誓效忠時是向什麼表達忠誠？",
                  options: ["總統", "州政府", "美利堅合眾國和國旗", "軍隊"],
                  explanation: "宣誓效忠是向美利堅合眾國及美國國旗——整個國家的象徵——表達忠誠。")
        ]),
        UnifiedQuestion(id: "q_25_119", correctAnswer: 1, variants: [
            .init(text: "What is the capital of the United States?",
                  options: ["New York City", "Washington, D.C.", "Philadelphia", "Boston"],
                  explanation: "Washington, D.C. has been the U.S. capital since 1800. The District of Columbia is named after Christopher Columbus."),
            .init(text: "美国的首都是哪里？",
                  options: ["纽约市", "华盛顿哥伦比亚特区", "费城", "波士顿"],
                  explanation: "华盛顿哥伦比亚特区自 1800 年起成为美国首都。哥伦比亚特区以克里斯托弗·哥伦布命名。"),
            .init(text: "美國的首都是哪裡？",
                  options: ["紐約市", "華盛頓哥倫比亞特區", "費城", "波士頓"],
                  explanation: "華盛頓哥倫比亞特區自 1800 年起成為美國首都。哥倫比亞特區以克里斯多福·哥倫布命名。")
        ]),
        UnifiedQuestion(id: "q_25_121", correctAnswer: 2, variants: [
            .init(text: "Why does the flag have 13 stripes?",
                  options: ["For the 13 amendments", "For the 13 states bordering the ocean", "Because there were 13 original colonies", "For the 13 founding fathers"],
                  explanation: "The 13 stripes represent the 13 original colonies that declared independence and became the first U.S. states."),
            .init(text: "国旗上为什么有 13 条条纹？",
                  options: ["代表 13 条修正案", "代表 13 个沿海州", "因为最初有 13 个殖民地", "代表 13 位开国先贤"],
                  explanation: "13 条条纹代表宣布独立并成为美国最初各州的 13 个殖民地。"),
            .init(text: "國旗上為什麼有 13 條條紋？",
                  options: ["代表 13 條修正案", "代表 13 個沿海州", "因為最初有 13 個殖民地", "代表 13 位開國先賢"],
                  explanation: "13 條條紋代表宣佈獨立並成為美國最初各州的 13 個殖民地。")
        ]),
        UnifiedQuestion(id: "q_25_122", correctAnswer: 1, variants: [
            .init(text: "Why does the flag have 50 stars?",
                  options: ["For the 50 founding fathers", "There is one star for each state", "For 50 years of independence", "For each amendment"],
                  explanation: "Each star represents one of the 50 U.S. states. A new star is added when a state joins the Union."),
            .init(text: "国旗上为什么有 50 颗星？",
                  options: ["代表 50 位开国先贤", "每个州对应一颗星", "代表独立 50 年", "代表每条修正案"],
                  explanation: "每颗星代表 50 个州中的一个州。每当有一个州加入联邦，就会增加一颗星。"),
            .init(text: "國旗上為什麼有 50 顆星？",
                  options: ["代表 50 位開國先賢", "每個州對應一顆星", "代表獨立 50 年", "代表每條修正案"],
                  explanation: "每顆星代表 50 個州中的一個州。每當有一個州加入聯邦，就會增加一顆星。")
        ]),
        UnifiedQuestion(id: "q_25_123", correctAnswer: 2, variants: [
            .init(text: "What is the name of the national anthem?",
                  options: ["America the Beautiful", "God Bless America", "The Star-Spangled Banner", "My Country, 'Tis of Thee"],
                  explanation: "\"The Star-Spangled Banner\" was written by Francis Scott Key in 1814 and became the official national anthem in 1931."),
            .init(text: "美国国歌的名称是什么？",
                  options: ["《美丽的美国》", "《上帝保佑美国》", "《星条旗之歌》", "《我的祖国》"],
                  explanation: "《星条旗之歌》由弗朗西斯·斯科特·基于 1814 年创作，并于 1931 年成为美国官方国歌。"),
            .init(text: "美國國歌的名稱是什麼？",
                  options: ["《美麗的美國》", "《上帝保佑美國》", "《星條旗之歌》", "《我的祖國》"],
                  explanation: "《星條旗之歌》由法蘭西斯·史考特·基於 1814 年創作，並於 1931 年成為美國官方國歌。")
        ]),
        UnifiedQuestion(id: "q_25_124", correctAnswer: 1, variants: [
            .init(text: "The Nation's first motto was \"E Pluribus Unum.\" What does that mean?",
                  options: ["In God We Trust", "Out of many, one", "Liberty and justice for all", "We the People"],
                  explanation: "\"E Pluribus Unum\" (Latin) means \"Out of many, one.\" It refers to the union of many states forming one nation."),
            .init(text: "美国最早的格言是「E Pluribus Unum」。这是什么意思？",
                  options: ["我们信仰上帝", "合众为一", "人人享有自由与正义", "我们人民"],
                  explanation: "「E Pluribus Unum」（拉丁文）意为「合众为一」，指许多州联合形成一个国家。"),
            .init(text: "美國最早的格言是「E Pluribus Unum」。這是什麼意思？",
                  options: ["我們信仰上帝", "合眾為一", "人人享有自由與正義", "我們人民"],
                  explanation: "「E Pluribus Unum」（拉丁文）意為「合眾為一」，指許多州聯合形成一個國家。")
        ])
    ]

    // MARK: - Practice 2: Constitution & Amendments (16 questions)
    static let practice2: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_002", correctAnswer: 2, variants: [
            .init(text: "What is the supreme law of the land?",
                  options: ["The Bill of Rights", "The Declaration of Independence", "The U.S. Constitution", "The Articles of Confederation"],
                  explanation: "The U.S. Constitution is the supreme law of the land. All other laws must comply with it."),
            .init(text: "美国的最高法律是什么？",
                  options: ["《权利法案》", "《独立宣言》", "《美国宪法》", "《邦联条例》"],
                  explanation: "《美国宪法》是美国的最高法律，所有其他法律都必须遵守宪法。"),
            .init(text: "美國的最高法律是什麼？",
                  options: ["《權利法案》", "《獨立宣言》", "《美國憲法》", "《邦聯條例》"],
                  explanation: "《美國憲法》是美國的最高法律，所有其他法律都必須遵守憲法。")
        ]),
        UnifiedQuestion(id: "q_25_003", correctAnswer: 1, variants: [
            .init(text: "Name one thing the U.S. Constitution does.",
                  options: ["Declares war on Britain", "Forms the government and protects rights", "Lists all U.S. citizens", "Establishes the national religion"],
                  explanation: "The Constitution forms the government, defines its powers and parts, and protects the rights of the people."),
            .init(text: "请说出《美国宪法》的一项作用。",
                  options: ["向英国宣战", "建立政府并保护权利", "列出所有美国公民", "确立国教"],
                  explanation: "宪法建立政府，定义政府的权力与组成部分，并保护人民的权利。"),
            .init(text: "請說出《美國憲法》的一項作用。",
                  options: ["向英國宣戰", "建立政府並保護權利", "列出所有美國公民", "確立國教"],
                  explanation: "憲法建立政府，定義政府的權力與組成部分，並保護人民的權利。")
        ]),
        UnifiedQuestion(id: "q_25_004", correctAnswer: 1, variants: [
            .init(text: "The U.S. Constitution starts with the words \"We the People.\" What does \"We the People\" mean?",
                  options: ["Only landowners", "Self-government and consent of the governed", "Only U.S. citizens", "The President alone"],
                  explanation: "\"We the People\" expresses self-government, popular sovereignty, and consent of the governed — government's power comes from the people."),
            .init(text: "《美国宪法》以「我们人民」开头。「我们人民」是什么意思？",
                  options: ["仅限地主", "自治与被治者的同意", "仅限美国公民", "仅指总统"],
                  explanation: "「我们人民」体现了自治、人民主权及被治者的同意——政府的权力来自人民。"),
            .init(text: "《美國憲法》以「我們人民」開頭。「我們人民」是什麼意思？",
                  options: ["僅限地主", "自治與被治者的同意", "僅限美國公民", "僅指總統"],
                  explanation: "「我們人民」體現了自治、人民主權及被治者的同意——政府的權力來自人民。")
        ]),
        UnifiedQuestion(id: "q_25_005", correctAnswer: 1, variants: [
            .init(text: "How are changes made to the U.S. Constitution?",
                  options: ["By presidential order", "Through the amendment process", "By Supreme Court ruling", "By state vote alone"],
                  explanation: "Changes are made through amendments. An amendment requires a two-thirds vote in Congress and ratification by three-fourths of the states."),
            .init(text: "《美国宪法》如何进行修改？",
                  options: ["通过总统命令", "通过修正案程序", "通过最高法院裁决", "仅通过州投票"],
                  explanation: "修改通过修正案进行。修正案需要国会三分之二的赞成票及四分之三州的批准。"),
            .init(text: "《美國憲法》如何進行修改？",
                  options: ["通過總統命令", "通過修正案程序", "通過最高法院裁決", "僅通過州投票"],
                  explanation: "修改通過修正案進行。修正案需要國會三分之二的贊成票及四分之三州的批准。")
        ]),
        UnifiedQuestion(id: "q_25_006", correctAnswer: 1, variants: [
            .init(text: "What does the Bill of Rights protect?",
                  options: ["Government property", "The basic rights of Americans", "Foreign trade only", "State borders"],
                  explanation: "The Bill of Rights — the first 10 amendments — protects the basic rights of Americans, including speech, religion, and due process."),
            .init(text: "《权利法案》保护什么？",
                  options: ["政府财产", "美国人的基本权利", "仅外贸", "州界"],
                  explanation: "《权利法案》——即前 10 条修正案——保护美国人的基本权利，包括言论、宗教及正当程序。"),
            .init(text: "《權利法案》保護什麼？",
                  options: ["政府財產", "美國人的基本權利", "僅外貿", "州界"],
                  explanation: "《權利法案》——即前 10 條修正案——保護美國人的基本權利，包括言論、宗教及正當程序。")
        ]),
        UnifiedQuestion(id: "q_25_007", correctAnswer: 2, variants: [
            .init(text: "How many amendments does the U.S. Constitution have?",
                  options: ["10", "17", "27", "50"],
                  explanation: "The Constitution has 27 amendments. The first 10 are the Bill of Rights; the most recent (27th) was ratified in 1992."),
            .init(text: "《美国宪法》共有多少条修正案？",
                  options: ["10", "17", "27", "50"],
                  explanation: "宪法共有 27 条修正案。前 10 条是《权利法案》；最近一条（第 27 条）于 1992 年批准。"),
            .init(text: "《美國憲法》共有多少條修正案？",
                  options: ["10", "17", "27", "50"],
                  explanation: "憲法共有 27 條修正案。前 10 條是《權利法案》；最近一條（第 27 條）於 1992 年批准。")
        ]),
        UnifiedQuestion(id: "q_25_008", correctAnswer: 1, variants: [
            .init(text: "Why is the Declaration of Independence important?",
                  options: ["It established the U.S. dollar", "It says all people are created equal and identifies inherent rights", "It ended World War II", "It created the Supreme Court"],
                  explanation: "The Declaration of Independence states America is free from British control, says all people are created equal, and identifies inherent rights and individual freedoms."),
            .init(text: "为什么《独立宣言》很重要？",
                  options: ["它确立了美元", "它宣告人人生而平等并指明天赋权利", "它结束了第二次世界大战", "它创立了最高法院"],
                  explanation: "《独立宣言》宣布美国脱离英国统治，宣告人人生而平等，并指明天赋权利与个人自由。"),
            .init(text: "為什麼《獨立宣言》很重要？",
                  options: ["它確立了美元", "它宣告人人生而平等並指明天賦權利", "它結束了第二次世界大戰", "它創立了最高法院"],
                  explanation: "《獨立宣言》宣佈美國脫離英國統治，宣告人人生而平等，並指明天賦權利與個人自由。")
        ]),
        UnifiedQuestion(id: "q_25_009", correctAnswer: 1, variants: [
            .init(text: "What founding document said the American colonies were free from Britain?",
                  options: ["The U.S. Constitution", "The Declaration of Independence", "The Bill of Rights", "The Federalist Papers"],
                  explanation: "The Declaration of Independence (1776) declared the 13 American colonies free from British rule."),
            .init(text: "哪份建国文献宣告美洲殖民地脱离英国？",
                  options: ["《美国宪法》", "《独立宣言》", "《权利法案》", "《联邦论》"],
                  explanation: "《独立宣言》（1776 年）宣告 13 个美洲殖民地脱离英国统治。"),
            .init(text: "哪份建國文獻宣告美洲殖民地脫離英國？",
                  options: ["《美國憲法》", "《獨立宣言》", "《權利法案》", "《聯邦論》"],
                  explanation: "《獨立宣言》（1776 年）宣告 13 個美洲殖民地脫離英國統治。")
        ]),
        UnifiedQuestion(id: "q_25_010", correctAnswer: 1, variants: [
            .init(text: "Name two important ideas from the Declaration of Independence and the U.S. Constitution.",
                  options: ["Monarchy and aristocracy", "Equality and liberty", "Slavery and segregation", "Foreign rule and conquest"],
                  explanation: "Important ideas include equality, liberty, social contract, natural rights, limited government, and self-government."),
            .init(text: "请说出《独立宣言》和《美国宪法》中的两个重要理念。",
                  options: ["君主制与贵族制", "平等与自由", "奴隶制与种族隔离", "外国统治与征服"],
                  explanation: "重要理念包括平等、自由、社会契约、天赋权利、有限政府和自治。"),
            .init(text: "請說出《獨立宣言》和《美國憲法》中的兩個重要理念。",
                  options: ["君主制與貴族制", "平等與自由", "奴隸制與種族隔離", "外國統治與征服"],
                  explanation: "重要理念包括平等、自由、社會契約、天賦權利、有限政府和自治。")
        ]),
        UnifiedQuestion(id: "q_25_011", correctAnswer: 2, variants: [
            .init(text: "The words \"Life, Liberty, and the pursuit of Happiness\" are in what founding document?",
                  options: ["U.S. Constitution", "Bill of Rights", "Declaration of Independence", "Articles of Confederation"],
                  explanation: "These famous words appear in the Declaration of Independence, written by Thomas Jefferson in 1776."),
            .init(text: "「生命、自由及追求幸福」这些字句出自哪份建国文献？",
                  options: ["《美国宪法》", "《权利法案》", "《独立宣言》", "《邦联条例》"],
                  explanation: "这些著名字句出自《独立宣言》，由托马斯·杰斐逊于 1776 年撰写。"),
            .init(text: "「生命、自由及追求幸福」這些字句出自哪份建國文獻？",
                  options: ["《美國憲法》", "《權利法案》", "《獨立宣言》", "《邦聯條例》"],
                  explanation: "這些著名字句出自《獨立宣言》，由湯瑪士·傑佛遜於 1776 年撰寫。")
        ]),
        UnifiedQuestion(id: "q_25_013", correctAnswer: 2, variants: [
            .init(text: "What is the rule of law?",
                  options: ["The President can do anything", "The richest people make the rules", "Everyone must follow the law, including leaders", "Only judges follow the law"],
                  explanation: "The rule of law means everyone must obey the law — including leaders, the government, and ordinary citizens. No one is above the law."),
            .init(text: "什么是法治？",
                  options: ["总统可以做任何事", "最富有的人制定规则", "人人都必须遵守法律，包括领导人", "只有法官需要遵守法律"],
                  explanation: "法治意味着所有人都必须遵守法律——包括领导人、政府和普通公民。没有人凌驾于法律之上。"),
            .init(text: "什麼是法治？",
                  options: ["總統可以做任何事", "最富有的人制定規則", "人人都必須遵守法律，包括領導人", "只有法官需要遵守法律"],
                  explanation: "法治意味著所有人都必須遵守法律——包括領導人、政府和普通公民。沒有人凌駕於法律之上。")
        ]),
        UnifiedQuestion(id: "q_25_014", correctAnswer: 1, variants: [
            .init(text: "Many documents influenced the U.S. Constitution. Name one.",
                  options: ["The Treaty of Paris", "The Federalist Papers", "The Monroe Doctrine", "The Marshall Plan"],
                  explanation: "Documents that influenced the Constitution include the Declaration of Independence, Articles of Confederation, Federalist Papers, Virginia Declaration of Rights, Mayflower Compact, and Iroquois Great Law of Peace."),
            .init(text: "许多文献影响了《美国宪法》。请说出其中一份。",
                  options: ["《巴黎条约》", "《联邦论》", "《门罗主义》", "《马歇尔计划》"],
                  explanation: "影响宪法的文献包括《独立宣言》、《邦联条例》、《联邦论》、《弗吉尼亚权利宣言》、《五月花号公约》以及《易洛魁大和平法》。"),
            .init(text: "許多文獻影響了《美國憲法》。請說出其中一份。",
                  options: ["《巴黎條約》", "《聯邦論》", "《門羅主義》", "《馬歇爾計劃》"],
                  explanation: "影響憲法的文獻包括《獨立宣言》、《邦聯條例》、《聯邦論》、《維吉尼亞權利宣言》、《五月花號公約》以及《易洛魁大和平法》。")
        ]),
        UnifiedQuestion(id: "q_25_015", correctAnswer: 1, variants: [
            .init(text: "There are three branches of government. Why?",
                  options: ["To create more jobs", "So one part does not become too powerful", "Because the colonies wanted three", "Because three is a lucky number"],
                  explanation: "Three branches with checks and balances ensure no single branch becomes too powerful — the principle of separation of powers."),
            .init(text: "政府为什么有三个分支？",
                  options: ["为了创造更多就业", "为了防止某一分支过于强大", "因为殖民地想要三个", "因为三是个吉利数字"],
                  explanation: "三个分支通过制衡机制确保任何一个分支都不会变得过于强大——这就是权力分立原则。"),
            .init(text: "政府為什麼有三個分支？",
                  options: ["為了創造更多就業", "為了防止某一分支過於強大", "因為殖民地想要三個", "因為三是個吉利數字"],
                  explanation: "三個分支通過制衡機制確保任何一個分支都不會變得過於強大——這就是權力分立原則。")
        ]),
        UnifiedQuestion(id: "q_25_060", correctAnswer: 1, variants: [
            .init(text: "What is the purpose of the 10th Amendment?",
                  options: ["To give all power to the federal government", "Powers not given to the federal government belong to the states or the people", "To establish religious freedom", "To allow free speech"],
                  explanation: "The 10th Amendment reserves any powers not delegated to the federal government — and not prohibited to states — for the states or the people."),
            .init(text: "第 10 修正案的目的是什么？",
                  options: ["将所有权力赋予联邦政府", "未授予联邦政府的权力归属于州或人民", "确立宗教自由", "允许言论自由"],
                  explanation: "第 10 修正案规定：凡未授予联邦政府且未禁止州行使的权力，均保留给各州或人民。"),
            .init(text: "第 10 修正案的目的是什麼？",
                  options: ["將所有權力賦予聯邦政府", "未授予聯邦政府的權力歸屬於州或人民", "確立宗教自由", "允許言論自由"],
                  explanation: "第 10 修正案規定：凡未授予聯邦政府且未禁止州行使的權力，均保留給各州或人民。")
        ]),
        UnifiedQuestion(id: "q_25_097", correctAnswer: 1, variants: [
            .init(text: "What amendment says all persons born or naturalized in the United States, and subject to the jurisdiction thereof, are U.S. citizens?",
                  options: ["13th Amendment", "14th Amendment", "15th Amendment", "19th Amendment"],
                  explanation: "The 14th Amendment (1868) grants citizenship to all persons born or naturalized in the United States — known as birthright citizenship."),
            .init(text: "哪条修正案规定凡在美国出生或归化并受其管辖的人均为美国公民？",
                  options: ["第 13 修正案", "第 14 修正案", "第 15 修正案", "第 19 修正案"],
                  explanation: "第 14 修正案（1868 年）授予所有在美国出生或归化者公民身份——即「出生公民权」。"),
            .init(text: "哪條修正案規定凡在美國出生或歸化並受其管轄的人均為美國公民？",
                  options: ["第 13 修正案", "第 14 修正案", "第 15 修正案", "第 19 修正案"],
                  explanation: "第 14 修正案（1868 年）授予所有在美國出生或歸化者公民身份——即「出生公民權」。")
        ]),
        UnifiedQuestion(id: "q_25_102", correctAnswer: 2, variants: [
            .init(text: "When did all women get the right to vote?",
                  options: ["1865", "1870", "1920 (with the 19th Amendment)", "1965"],
                  explanation: "The 19th Amendment, ratified in 1920, gave women the right to vote nationwide after a long suffrage movement."),
            .init(text: "所有妇女何时获得投票权？",
                  options: ["1865 年", "1870 年", "1920 年（随着第 19 修正案）", "1965 年"],
                  explanation: "第 19 修正案于 1920 年获得批准，经过长期的妇女参政权运动后赋予全国妇女投票权。"),
            .init(text: "所有婦女何時獲得投票權？",
                  options: ["1865 年", "1870 年", "1920 年（隨著第 19 修正案）", "1965 年"],
                  explanation: "第 19 修正案於 1920 年獲得批准，經過長期的婦女參政權運動後賦予全國婦女投票權。")
        ])
    ]

    // MARK: - Practice 3: Congress: Structure & Powers (16 questions)
    static let practice3: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_018", correctAnswer: 2, variants: [
            .init(text: "What part of the federal government writes laws?",
                  options: ["The Supreme Court", "The President", "U.S. Congress (legislative branch)", "The Cabinet"],
                  explanation: "Congress — the Senate and House of Representatives — is the legislative branch responsible for writing federal laws."),
            .init(text: "联邦政府的哪一部分负责制定法律？",
                  options: ["最高法院", "总统", "美国国会（立法部门）", "内阁"],
                  explanation: "国会——由参议院和众议院组成——是负责制定联邦法律的立法部门。"),
            .init(text: "聯邦政府的哪一部分負責制定法律？",
                  options: ["最高法院", "總統", "美國國會（立法部門）", "內閣"],
                  explanation: "國會——由參議院和眾議院組成——是負責制定聯邦法律的立法部門。")
        ]),
        UnifiedQuestion(id: "q_25_019", correctAnswer: 0, variants: [
            .init(text: "What are the two parts of the U.S. Congress?",
                  options: ["Senate and House of Representatives", "Cabinet and Senate", "President and Vice President", "House and Cabinet"],
                  explanation: "Congress is bicameral, made up of the Senate (100 members) and the House of Representatives (435 voting members)."),
            .init(text: "美国国会由哪两部分组成？",
                  options: ["参议院和众议院", "内阁和参议院", "总统和副总统", "众议院和内阁"],
                  explanation: "国会实行两院制，由参议院（100 位议员）和众议院（435 位有投票权的议员）组成。"),
            .init(text: "美國國會由哪兩部分組成？",
                  options: ["參議院和眾議院", "內閣和參議院", "總統和副總統", "眾議院和內閣"],
                  explanation: "國會實行兩院制，由參議院（100 位議員）和眾議院（435 位有投票權的議員）組成。")
        ]),
        UnifiedQuestion(id: "q_25_020", correctAnswer: 2, variants: [
            .init(text: "Name one power of the U.S. Congress.",
                  options: ["Veto bills", "Decides Supreme Court cases", "Writes laws", "Commands the military"],
                  explanation: "Powers of Congress include writing laws, declaring war, and making the federal budget."),
            .init(text: "请说出美国国会的一项权力。",
                  options: ["否决法案", "裁决最高法院案件", "制定法律", "指挥军队"],
                  explanation: "国会的权力包括制定法律、宣战及编制联邦预算。"),
            .init(text: "請說出美國國會的一項權力。",
                  options: ["否決法案", "裁決最高法院案件", "制定法律", "指揮軍隊"],
                  explanation: "國會的權力包括制定法律、宣戰及編制聯邦預算。")
        ]),
        UnifiedQuestion(id: "q_25_021", correctAnswer: 1, variants: [
            .init(text: "How many U.S. senators are there?",
                  options: ["50", "100", "435", "200"],
                  explanation: "There are 100 U.S. Senators — two from each of the 50 states, ensuring equal representation regardless of state size."),
            .init(text: "美国共有多少位参议员？",
                  options: ["50", "100", "435", "200"],
                  explanation: "美国共有 100 位参议员——每个州 2 位，确保各州无论大小都有平等代表权。"),
            .init(text: "美國共有多少位參議員？",
                  options: ["50", "100", "435", "200"],
                  explanation: "美國共有 100 位參議員——每個州 2 位，確保各州無論大小都有平等代表權。")
        ]),
        UnifiedQuestion(id: "q_25_022", correctAnswer: 2, variants: [
            .init(text: "How long is a term for a U.S. senator?",
                  options: ["2 years", "4 years", "6 years", "Life"],
                  explanation: "Senators serve 6-year terms. About one-third of the Senate is up for election every two years."),
            .init(text: "美国参议员的任期是多长？",
                  options: ["2 年", "4 年", "6 年", "终身"],
                  explanation: "参议员任期 6 年。约三分之一的参议员每两年进行一次改选。"),
            .init(text: "美國參議員的任期是多長？",
                  options: ["2 年", "4 年", "6 年", "終身"],
                  explanation: "參議員任期 6 年。約三分之一的參議員每兩年進行一次改選。")
        ]),
        UnifiedQuestion(id: "q_25_023", correctAnswer: 0, variants: [
            .init(text: "Who is one of your state's U.S. senators now?",
                  options: ["Depends on your state", "Joe Biden", "Donald Trump", "Ron DeSantis"],
                  explanation: "Each state has 2 U.S. Senators. Look up your state's current Senators at senate.gov before your interview. (D.C. and U.S. territories have no voting Senators.)"),
            .init(text: "您所在州现任的一位美国参议员是谁？",
                  options: ["依您所在州而定", "乔·拜登", "唐纳德·特朗普", "罗恩·德桑蒂斯"],
                  explanation: "每个州都有 2 位美国参议员。请在面试前到 senate.gov 查询您所在州的现任参议员。（哥伦比亚特区及美国领地没有有投票权的参议员。）"),
            .init(text: "您所在州現任的一位美國參議員是誰？",
                  options: ["依您所在州而定", "喬·拜登", "唐納德·特朗普", "羅恩·德桑蒂斯"],
                  explanation: "每個州都有 2 位美國參議員。請在面試前到 senate.gov 查詢您所在州的現任參議員。（哥倫比亞特區及美國領地沒有有投票權的參議員。）")
        ]),
        UnifiedQuestion(id: "q_25_024", correctAnswer: 2, variants: [
            .init(text: "How many voting members are in the House of Representatives?",
                  options: ["100", "200", "435", "538"],
                  explanation: "The House has 435 voting members. Seats are apportioned by population, recalculated after each census."),
            .init(text: "众议院有多少位有投票权的议员？",
                  options: ["100", "200", "435", "538"],
                  explanation: "众议院有 435 位有投票权的议员。席位按人口分配，每次人口普查后重新计算。"),
            .init(text: "眾議院有多少位有投票權的議員？",
                  options: ["100", "200", "435", "538"],
                  explanation: "眾議院有 435 位有投票權的議員。席位按人口分配，每次人口普查後重新計算。")
        ]),
        UnifiedQuestion(id: "q_25_025", correctAnswer: 0, variants: [
            .init(text: "How long is a term for a member of the House of Representatives?",
                  options: ["2 years", "4 years", "6 years", "8 years"],
                  explanation: "House members serve 2-year terms. The entire House faces re-election every two years to keep them close to the people."),
            .init(text: "众议院议员的任期是多长？",
                  options: ["2 年", "4 年", "6 年", "8 年"],
                  explanation: "众议员任期 2 年。整个众议院每两年改选一次，以保持议员与民众的紧密联系。"),
            .init(text: "眾議院議員的任期是多長？",
                  options: ["2 年", "4 年", "6 年", "8 年"],
                  explanation: "眾議員任期 2 年。整個眾議院每兩年改選一次，以保持議員與民眾的緊密聯繫。")
        ]),
        UnifiedQuestion(id: "q_25_026", correctAnswer: 1, variants: [
            .init(text: "Why do U.S. representatives serve shorter terms than U.S. senators?",
                  options: ["To save government money", "To more closely follow public opinion", "Because they have less power", "Because they are appointed, not elected"],
                  explanation: "Representatives serve shorter (2-year) terms so they remain closely accountable to the public's current opinions."),
            .init(text: "为什么众议员的任期比参议员短？",
                  options: ["为政府节省开支", "为了更紧密地跟随民意", "因为他们权力较小", "因为他们是任命而非选举产生"],
                  explanation: "众议员任期较短（2 年），以保持对民众当前意见的紧密回应。"),
            .init(text: "為什麼眾議員的任期比參議員短？",
                  options: ["為政府節省開支", "為了更緊密地跟隨民意", "因為他們權力較小", "因為他們是任命而非選舉產生"],
                  explanation: "眾議員任期較短（2 年），以保持對民眾當前意見的緊密回應。")
        ]),
        UnifiedQuestion(id: "q_25_027", correctAnswer: 1, variants: [
            .init(text: "How many senators does each state have?",
                  options: ["1", "2", "3", "Depends on population"],
                  explanation: "Each state has 2 Senators, regardless of population. This was the Great Compromise to ensure equal state representation."),
            .init(text: "每个州有几位参议员？",
                  options: ["1", "2", "3", "依人口而定"],
                  explanation: "每个州都有 2 位参议员，与人口无关。这就是为确保各州享有平等代表权的「大妥协」。"),
            .init(text: "每個州有幾位參議員？",
                  options: ["1", "2", "3", "依人口而定"],
                  explanation: "每個州都有 2 位參議員，與人口無關。這就是為確保各州享有平等代表權的「大妥協」。")
        ]),
        UnifiedQuestion(id: "q_25_028", correctAnswer: 0, variants: [
            .init(text: "Why does each state have two senators?",
                  options: ["For equal representation of small and large states (the Great Compromise)", "Because the Senate is the more important chamber", "To save election costs", "Because the Constitution forgot to specify"],
                  explanation: "Each state has 2 Senators for equal representation. This was the Great Compromise (Connecticut Compromise), balancing small-state and large-state interests."),
            .init(text: "为什么每个州有两位参议员？",
                  options: ["让大小州享有平等代表权（大妥协）", "因为参议院是更重要的一院", "为了节省选举开支", "因为宪法忘了规定"],
                  explanation: "每个州 2 位参议员是为了实现各州平等代表权。这就是平衡小州与大州利益的「大妥协」（康涅狄格妥协）。"),
            .init(text: "為什麼每個州有兩位參議員？",
                  options: ["讓大小州享有平等代表權（大妥協）", "因為參議院是更重要的一院", "為了節省選舉開支", "因為憲法忘了規定"],
                  explanation: "每個州 2 位參議員是為了實現各州平等代表權。這就是平衡小州與大州利益的「大妥協」（康乃狄克妥協）。")
        ]),
        UnifiedQuestion(id: "q_25_029", correctAnswer: 0, variants: [
            .init(text: "Name your U.S. representative.",
                  options: ["Depends on your congressional district", "Mike Johnson", "Nancy Pelosi", "Kevin McCarthy"],
                  explanation: "Each congressional district has one Representative. Find yours at house.gov by entering your ZIP code."),
            .init(text: "请说出您的美国众议员。",
                  options: ["依您所在国会选区而定", "迈克·约翰逊", "南希·佩洛西", "凯文·麦卡锡"],
                  explanation: "每个国会选区有一位众议员。请到 house.gov 输入您的邮政编码即可查询。"),
            .init(text: "請說出您的美國眾議員。",
                  options: ["依您所在國會選區而定", "邁克·約翰遜", "南希·佩洛西", "凱文·麥卡錫"],
                  explanation: "每個國會選區有一位眾議員。請到 house.gov 輸入您的郵政編碼即可查詢。")
        ]),
        UnifiedQuestion(id: "q_25_030", correctAnswer: 2, variants: [
            .init(text: "What is the name of the Speaker of the House of Representatives now?",
                  options: ["Nancy Pelosi", "Kevin McCarthy", "Mike Johnson", "Mitch McConnell"],
                  explanation: "Mike Johnson has been Speaker of the House since 2023. The Speaker leads the House and is second in line for presidential succession."),
            .init(text: "现任美国众议院议长的名字是什么？",
                  options: ["南希·佩洛西", "凯文·麦卡锡", "迈克·约翰逊", "米奇·麦康奈尔"],
                  explanation: "迈克·约翰逊自 2023 年起担任众议院议长。议长领导众议院，并是总统继任顺序中的第二位。"),
            .init(text: "現任美國眾議院議長的名字是什麼？",
                  options: ["南希·佩洛西", "凱文·麥卡錫", "邁克·約翰遜", "米奇·麥康奈爾"],
                  explanation: "邁克·約翰遜自 2023 年起擔任眾議院議長。議長領導眾議院，並是總統繼任順序中的第二位。")
        ]),
        UnifiedQuestion(id: "q_25_031", correctAnswer: 1, variants: [
            .init(text: "Who does a U.S. senator represent?",
                  options: ["Only the President's party", "Citizens of their state", "Federal employees only", "The Supreme Court"],
                  explanation: "A U.S. Senator represents all the citizens (people) of their state."),
            .init(text: "美国参议员代表谁？",
                  options: ["仅代表总统所在政党", "其所在州的公民", "仅代表联邦雇员", "最高法院"],
                  explanation: "美国参议员代表其所在州的全体公民（人民）。"),
            .init(text: "美國參議員代表誰？",
                  options: ["僅代表總統所在政黨", "其所在州的公民", "僅代表聯邦僱員", "最高法院"],
                  explanation: "美國參議員代表其所在州的全體公民（人民）。")
        ]),
        UnifiedQuestion(id: "q_25_032", correctAnswer: 2, variants: [
            .init(text: "Who elects U.S. senators?",
                  options: ["State legislatures", "The President", "Citizens from their state", "Other Senators"],
                  explanation: "Citizens from each state elect their Senators. Before the 17th Amendment (1913), Senators were chosen by state legislatures."),
            .init(text: "谁选举美国参议员？",
                  options: ["州议会", "总统", "其所在州的公民", "其他参议员"],
                  explanation: "各州公民选举本州的参议员。在第 17 修正案（1913 年）之前，参议员由州议会选出。"),
            .init(text: "誰選舉美國參議員？",
                  options: ["州議會", "總統", "其所在州的公民", "其他參議員"],
                  explanation: "各州公民選舉本州的參議員。在第 17 修正案（1913 年）之前，參議員由州議會選出。")
        ]),
        UnifiedQuestion(id: "q_25_033", correctAnswer: 0, variants: [
            .init(text: "Who does a member of the House of Representatives represent?",
                  options: ["Citizens of their congressional district", "All U.S. citizens", "Their political party", "The President"],
                  explanation: "A House member represents the citizens (people) of their congressional district. House districts are based on population."),
            .init(text: "众议员代表谁？",
                  options: ["其国会选区的公民", "全体美国公民", "其所属政党", "总统"],
                  explanation: "众议员代表其国会选区的公民（人民）。国会选区按人口划分。"),
            .init(text: "眾議員代表誰？",
                  options: ["其國會選區的公民", "全體美國公民", "其所屬政黨", "總統"],
                  explanation: "眾議員代表其國會選區的公民（人民）。國會選區按人口劃分。")
        ])
    ]

    // MARK: - Practice 4: Congress & Executive (16 questions)
    static let practice4: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_034", correctAnswer: 1, variants: [
            .init(text: "Who elects members of the House of Representatives?",
                  options: ["The state governor", "Citizens from their congressional district", "The President", "The Senate"],
                  explanation: "Citizens from each congressional district elect their Representative every two years."),
            .init(text: "谁选举众议院议员？",
                  options: ["州长", "其国会选区的公民", "总统", "参议院"],
                  explanation: "每个国会选区的公民每两年选举本选区的众议员一次。"),
            .init(text: "誰選舉眾議院議員？",
                  options: ["州長", "其國會選區的公民", "總統", "參議院"],
                  explanation: "每個國會選區的公民每兩年選舉本選區的眾議員一次。")
        ]),
        UnifiedQuestion(id: "q_25_035", correctAnswer: 1, variants: [
            .init(text: "Some states have more representatives than other states. Why?",
                  options: ["Because they were states first", "Because of the state's population", "Because they pay more taxes", "Because they have more land"],
                  explanation: "House seats are apportioned by population. California has 52 representatives; small states like Wyoming have just 1."),
            .init(text: "为什么有些州的众议员比其他州多？",
                  options: ["因为它们先成为州", "因为该州的人口", "因为它们缴纳更多税款", "因为它们土地面积较大"],
                  explanation: "众议院席位按人口分配。加利福尼亚州有 52 位众议员；像怀俄明这样的小州只有 1 位。"),
            .init(text: "為什麼有些州的眾議員比其他州多？",
                  options: ["因為它們先成為州", "因為該州的人口", "因為它們繳納更多稅款", "因為它們土地面積較大"],
                  explanation: "眾議院席位按人口分配。加利福尼亞州有 52 位眾議員；像懷俄明這樣的小州只有 1 位。")
        ]),
        UnifiedQuestion(id: "q_25_036", correctAnswer: 1, variants: [
            .init(text: "The President of the United States is elected for how many years?",
                  options: ["2 years", "4 years", "6 years", "Life"],
                  explanation: "The President serves a 4-year term, established by Article II of the Constitution."),
            .init(text: "美国总统当选任期为多少年？",
                  options: ["2 年", "4 年", "6 年", "终身"],
                  explanation: "总统任期为 4 年，由宪法第二条规定。"),
            .init(text: "美國總統當選任期為多少年？",
                  options: ["2 年", "4 年", "6 年", "終身"],
                  explanation: "總統任期為 4 年，由憲法第二條規定。")
        ]),
        UnifiedQuestion(id: "q_25_037", correctAnswer: 1, variants: [
            .init(text: "The President of the United States can serve only two terms. Why?",
                  options: ["To save campaign costs", "Because of the 22nd Amendment (to prevent too much power)", "Because of tradition only", "Because the President gets too old"],
                  explanation: "The 22nd Amendment (1951) limits Presidents to two elected terms, preventing any one person from accumulating too much power. It was passed after FDR served four terms."),
            .init(text: "美国总统只能任职两届。为什么？",
                  options: ["为节省竞选开支", "因为第 22 修正案（为了防止权力过大）", "仅因为传统", "因为总统年纪过大"],
                  explanation: "第 22 修正案（1951 年）将总统任期限制在两届，防止任何一人累积过大权力。该修正案是在富兰克林·罗斯福担任四届总统之后通过的。"),
            .init(text: "美國總統只能任職兩屆。為什麼？",
                  options: ["為節省競選開支", "因為第 22 修正案（為了防止權力過大）", "僅因為傳統", "因為總統年紀過大"],
                  explanation: "第 22 修正案（1951 年）將總統任期限制在兩屆，防止任何一人累積過大權力。該修正案是在富蘭克林·羅斯福擔任四屆總統之後通過的。")
        ]),
        UnifiedQuestion(id: "q_25_041", correctAnswer: 1, variants: [
            .init(text: "Name one power of the President.",
                  options: ["Writes federal laws", "Vetoes bills", "Decides Supreme Court cases", "Declares war"],
                  explanation: "Presidential powers include vetoing bills, signing bills into law, enforcing laws, serving as Commander in Chief, and appointing federal judges."),
            .init(text: "请说出总统的一项权力。",
                  options: ["制定联邦法律", "否决法案", "裁决最高法院案件", "宣战"],
                  explanation: "总统的权力包括否决法案、签署法案使其成为法律、执行法律、担任三军统帅及任命联邦法官。"),
            .init(text: "請說出總統的一項權力。",
                  options: ["制定聯邦法律", "否決法案", "裁決最高法院案件", "宣戰"],
                  explanation: "總統的權力包括否決法案、簽署法案使其成為法律、執行法律、擔任三軍統帥及任命聯邦法官。")
        ]),
        UnifiedQuestion(id: "q_25_043", correctAnswer: 2, variants: [
            .init(text: "Who signs bills to become laws?",
                  options: ["The Speaker of the House", "The Vice President", "The President", "The Chief Justice"],
                  explanation: "After Congress passes a bill, the President signs it into law. The President can also veto a bill, returning it to Congress."),
            .init(text: "谁签署法案使其成为法律？",
                  options: ["众议院议长", "副总统", "总统", "首席大法官"],
                  explanation: "国会通过法案后，由总统签署使其成为法律。总统也可以否决法案，将其退回国会。"),
            .init(text: "誰簽署法案使其成為法律？",
                  options: ["眾議院議長", "副總統", "總統", "首席大法官"],
                  explanation: "國會通過法案後，由總統簽署使其成為法律。總統也可以否決法案，將其退回國會。")
        ]),
        UnifiedQuestion(id: "q_25_044", correctAnswer: 2, variants: [
            .init(text: "Who vetoes bills?",
                  options: ["The Senate", "The Supreme Court", "The President", "The Cabinet"],
                  explanation: "The President vetoes bills passed by Congress. Congress can override a veto with a two-thirds vote in both chambers."),
            .init(text: "谁有权否决法案？",
                  options: ["参议院", "最高法院", "总统", "内阁"],
                  explanation: "总统否决国会通过的法案。国会两院以三分之二多数票可推翻总统的否决。"),
            .init(text: "誰有權否決法案？",
                  options: ["參議院", "最高法院", "總統", "內閣"],
                  explanation: "總統否決國會通過的法案。國會兩院以三分之二多數票可推翻總統的否決。")
        ]),
        UnifiedQuestion(id: "q_25_045", correctAnswer: 2, variants: [
            .init(text: "Who appoints federal judges?",
                  options: ["The Speaker of the House", "The Chief Justice", "The President", "Congress"],
                  explanation: "The President appoints federal judges, including Supreme Court Justices. The Senate must confirm these appointments."),
            .init(text: "谁任命联邦法官？",
                  options: ["众议院议长", "首席大法官", "总统", "国会"],
                  explanation: "总统任命包括最高法院大法官在内的联邦法官。参议院必须确认这些任命。"),
            .init(text: "誰任命聯邦法官？",
                  options: ["眾議院議長", "首席大法官", "總統", "國會"],
                  explanation: "總統任命包括最高法院大法官在內的聯邦法官。參議院必須確認這些任命。")
        ]),
        UnifiedQuestion(id: "q_25_046", correctAnswer: 1, variants: [
            .init(text: "The executive branch has many parts. Name one.",
                  options: ["The Supreme Court", "The President's Cabinet", "The Senate", "Congress"],
                  explanation: "Parts of the Executive branch include the President, the Cabinet, and federal departments and agencies (like the FBI, EPA, IRS)."),
            .init(text: "行政部门有很多组成部分。请说出一个。",
                  options: ["最高法院", "总统的内阁", "参议院", "国会"],
                  explanation: "行政部门的组成部分包括总统、内阁，以及联邦各部和各机构（如 FBI、EPA、IRS）。"),
            .init(text: "行政部門有很多組成部分。請說出一個。",
                  options: ["最高法院", "總統的內閣", "參議院", "國會"],
                  explanation: "行政部門的組成部分包括總統、內閣，以及聯邦各部和各機構（如 FBI、EPA、IRS）。")
        ]),
        UnifiedQuestion(id: "q_25_047", correctAnswer: 1, variants: [
            .init(text: "What does the President's Cabinet do?",
                  options: ["Writes laws", "Advises the President", "Decides court cases", "Elects the next President"],
                  explanation: "The Cabinet is a group of advisors to the President, made up of the heads of the federal departments (like Secretary of State, Secretary of Defense)."),
            .init(text: "总统的内阁做什么？",
                  options: ["制定法律", "向总统提出建议", "裁决法庭案件", "选出下一任总统"],
                  explanation: "内阁是向总统提供建议的顾问团，由联邦各部首长组成（如国务卿、国防部长）。"),
            .init(text: "總統的內閣做什麼？",
                  options: ["制定法律", "向總統提出建議", "裁決法庭案件", "選出下一任總統"],
                  explanation: "內閣是向總統提供建議的顧問團，由聯邦各部首長組成（如國務卿、國防部長）。")
        ]),
        UnifiedQuestion(id: "q_25_048", correctAnswer: 0, variants: [
            .init(text: "What are two Cabinet-level positions?",
                  options: ["Secretary of State and Attorney General", "Speaker of the House and Senate Majority Leader", "Chief Justice and Vice President", "Governor and Mayor"],
                  explanation: "Cabinet-level positions include Secretary of State, Attorney General, Secretary of Defense, Secretary of the Treasury, Secretary of Homeland Security, and many others."),
            .init(text: "请说出两个内阁级别的职位。",
                  options: ["国务卿和司法部长", "众议院议长和参议院多数党领袖", "首席大法官和副总统", "州长和市长"],
                  explanation: "内阁级别的职位包括国务卿、司法部长、国防部长、财政部长、国土安全部长以及其他许多职位。"),
            .init(text: "請說出兩個內閣級別的職位。",
                  options: ["國務卿和司法部長", "眾議院議長和參議院多數黨領袖", "首席大法官和副總統", "州長和市長"],
                  explanation: "內閣級別的職位包括國務卿、司法部長、國防部長、財政部長、國土安全部長以及其他許多職位。")
        ]),
        UnifiedQuestion(id: "q_25_049", correctAnswer: 0, variants: [
            .init(text: "Why is the Electoral College important?",
                  options: ["It decides who is elected President", "It chooses Supreme Court Justices", "It teaches government in college", "It runs federal elections"],
                  explanation: "The Electoral College decides who is elected President. It is a compromise between popular election and congressional selection of the President."),
            .init(text: "为什么选举人团很重要？",
                  options: ["它决定谁当选总统", "它选择最高法院大法官", "它在大学里教授政府课程", "它管理联邦选举"],
                  explanation: "选举人团决定谁当选总统。它是介于普选与国会选举总统之间的妥协机制。"),
            .init(text: "為什麼選舉人團很重要？",
                  options: ["它決定誰當選總統", "它選擇最高法院大法官", "它在大學裡教授政府課程", "它管理聯邦選舉"],
                  explanation: "選舉人團決定誰當選總統。它是介於普選與國會選舉總統之間的妥協機制。")
        ]),
        UnifiedQuestion(id: "q_25_050", correctAnswer: 2, variants: [
            .init(text: "What is one part of the judicial branch?",
                  options: ["The Senate", "The Cabinet", "The Supreme Court", "The Pentagon"],
                  explanation: "The judicial branch includes the Supreme Court and the federal courts (district courts and courts of appeals)."),
            .init(text: "司法部门的一个组成部分是什么？",
                  options: ["参议院", "内阁", "最高法院", "五角大楼"],
                  explanation: "司法部门包括最高法院和联邦各级法院（地区法院和上诉法院）。"),
            .init(text: "司法部門的一個組成部分是什麼？",
                  options: ["參議院", "內閣", "最高法院", "五角大廈"],
                  explanation: "司法部門包括最高法院和聯邦各級法院（地區法院和上訴法院）。")
        ]),
        UnifiedQuestion(id: "q_25_051", correctAnswer: 1, variants: [
            .init(text: "What does the judicial branch do?",
                  options: ["Writes laws", "Reviews and explains laws", "Commands the military", "Collects taxes"],
                  explanation: "The judicial branch reviews laws, explains them, resolves disputes, and decides if a law goes against the Constitution."),
            .init(text: "司法部门的职责是什么？",
                  options: ["制定法律", "审查及解释法律", "指挥军队", "征收税款"],
                  explanation: "司法部门审查法律、解释法律、解决争议，并裁定某项法律是否违反宪法。"),
            .init(text: "司法部門的職責是什麼？",
                  options: ["制定法律", "審查及解釋法律", "指揮軍隊", "徵收稅款"],
                  explanation: "司法部門審查法律、解釋法律、解決爭議，並裁定某項法律是否違反憲法。")
        ]),
        UnifiedQuestion(id: "q_25_054", correctAnswer: 1, variants: [
            .init(text: "How many Supreme Court justices are usually needed to decide a case?",
                  options: ["3", "6 (a quorum)", "9 (all)", "5"],
                  explanation: "Per 28 U.S.C. §1, six (6) Justices constitute a quorum — the minimum number required to hear and decide a Supreme Court case. This is the official USCIS answer."),
            .init(text: "通常需要多少位最高法院大法官才能裁决一个案件？",
                  options: ["3", "6（法定人数）", "9（全部）", "5"],
                  explanation: "根据《美国法典》第28编第1条，6 位大法官构成法定人数——即最高法院审理并裁决一个案件所需的最低人数。这是 USCIS 的官方答案。"),
            .init(text: "通常需要多少位最高法院大法官才能裁決一個案件？",
                  options: ["3", "6（法定人數）", "9（全部）", "5"],
                  explanation: "根據《美國法典》第28編第1條，6 位大法官構成法定人數——即最高法院審理並裁決一個案件所需的最低人數。這是 USCIS 的官方答案。")
        ]),
        UnifiedQuestion(id: "q_25_055", correctAnswer: 3, variants: [
            .init(text: "How long do Supreme Court justices serve?",
                  options: ["4 years", "8 years", "12 years", "For life (lifetime appointment)"],
                  explanation: "Supreme Court Justices serve for life or until retirement. Lifetime appointments shield them from political pressure."),
            .init(text: "最高法院大法官任期多久？",
                  options: ["4 年", "8 年", "12 年", "终身（终身任命）"],
                  explanation: "最高法院大法官终身任职或直至退休。终身任命保护他们不受政治压力影响。"),
            .init(text: "最高法院大法官任期多久？",
                  options: ["4 年", "8 年", "12 年", "終身（終身任命）"],
                  explanation: "最高法院大法官終身任職或直至退休。終身任命保護他們不受政治壓力影響。")
        ])
    ]

    // MARK: - Practice 5: Judicial, Federalism & Rights (16 questions)
    static let practice5: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_056", correctAnswer: 1, variants: [
            .init(text: "Supreme Court justices serve for life. Why?",
                  options: ["To save retirement costs", "To be independent of politics", "Because they cannot be replaced", "Because they're appointed by the people"],
                  explanation: "Lifetime appointments protect Justices from political pressure, allowing them to interpret the Constitution independently."),
            .init(text: "最高法院大法官为何终身任职？",
                  options: ["为节省退休开支", "为了不受政治影响", "因为无法被取代", "因为由人民任命"],
                  explanation: "终身任命保护大法官不受政治压力，使他们能够独立解释宪法。"),
            .init(text: "最高法院大法官為何終身任職？",
                  options: ["為節省退休開支", "為了不受政治影響", "因為無法被取代", "因為由人民任命"],
                  explanation: "終身任命保護大法官不受政治壓力，使他們能夠獨立解釋憲法。")
        ]),
        UnifiedQuestion(id: "q_25_057", correctAnswer: 0, variants: [
            .init(text: "Who is the Chief Justice of the United States now?",
                  options: ["John Roberts", "Clarence Thomas", "Amy Coney Barrett", "Sonia Sotomayor"],
                  explanation: "John Roberts has been Chief Justice since 2005. He presides over the Supreme Court and over presidential impeachment trials."),
            .init(text: "现任美国首席大法官是谁？",
                  options: ["约翰·罗伯茨", "克拉伦斯·托马斯", "艾米·科尼·巴雷特", "索尼娅·索托马约尔"],
                  explanation: "约翰·罗伯茨自 2005 年起担任首席大法官。他主持最高法院的事务及总统弹劾审判。"),
            .init(text: "現任美國首席大法官是誰？",
                  options: ["約翰·羅伯茨", "克拉倫斯·托馬斯", "艾米·科尼·巴雷特", "索尼婭·索托馬約爾"],
                  explanation: "約翰·羅伯茨自 2005 年起擔任首席大法官。他主持最高法院的事務及總統彈劾審判。")
        ]),
        UnifiedQuestion(id: "q_25_058", correctAnswer: 2, variants: [
            .init(text: "Name one power that is only for the federal government.",
                  options: ["Issue driver's licenses", "Run public schools", "Declare war (or print money)", "Provide police services"],
                  explanation: "Federal-only powers include declaring war, printing paper money, minting coins, creating an army, making treaties, and setting foreign policy."),
            .init(text: "请说出一项仅属于联邦政府的权力。",
                  options: ["颁发驾驶执照", "管理公立学校", "宣战（或印制货币）", "提供警务服务"],
                  explanation: "仅属于联邦政府的权力包括宣战、印制纸币、铸造硬币、组建军队、签订条约和制定外交政策。"),
            .init(text: "請說出一項僅屬於聯邦政府的權力。",
                  options: ["頒發駕駛執照", "管理公立學校", "宣戰（或印製貨幣）", "提供警務服務"],
                  explanation: "僅屬於聯邦政府的權力包括宣戰、印製紙幣、鑄造硬幣、組建軍隊、簽訂條約和制定外交政策。")
        ]),
        UnifiedQuestion(id: "q_25_059", correctAnswer: 2, variants: [
            .init(text: "Name one power that is only for the states.",
                  options: ["Print money", "Declare war", "Provide schooling and police protection", "Sign treaties"],
                  explanation: "State-only powers include providing education and schools, police and fire protection, issuing driver's licenses, and approving zoning."),
            .init(text: "请说出一项仅属于州政府的权力。",
                  options: ["印制货币", "宣战", "提供教育和警察保护", "签订条约"],
                  explanation: "仅属于州政府的权力包括提供教育和学校、警察与消防保护、颁发驾驶执照及批准土地分区。"),
            .init(text: "請說出一項僅屬於州政府的權力。",
                  options: ["印製貨幣", "宣戰", "提供教育和警察保護", "簽訂條約"],
                  explanation: "僅屬於州政府的權力包括提供教育和學校、警察與消防保護、頒發駕駛執照及批准土地分區。")
        ]),
        UnifiedQuestion(id: "q_25_061", correctAnswer: 0, variants: [
            .init(text: "Who is the governor of your state now?",
                  options: ["Depends on your state", "Donald Trump", "Joe Biden", "Gavin Newsom"],
                  explanation: "Each state has its own Governor. Look up your current Governor on your state government's website. (Territories have appointed governors; D.C. has a mayor instead.)"),
            .init(text: "您所在州现任州长是谁？",
                  options: ["依您所在州而定", "唐纳德·特朗普", "乔·拜登", "加文·纽森"],
                  explanation: "每个州都有自己的州长。请在所在州政府的网站上查询现任州长。（领地的州长由任命产生；哥伦比亚特区设市长而非州长。）"),
            .init(text: "您所在州現任州長是誰？",
                  options: ["依您所在州而定", "唐納德·特朗普", "喬·拜登", "加文·紐森"],
                  explanation: "每個州都有自己的州長。請在所在州政府的網站上查詢現任州長。（領地的州長由任命產生；哥倫比亞特區設市長而非州長。）")
        ]),
        UnifiedQuestion(id: "q_25_062", correctAnswer: 0, variants: [
            .init(text: "What is the capital of your state?",
                  options: ["Depends on your state", "Washington, D.C.", "New York City", "Los Angeles"],
                  explanation: "Each state has its own capital city. Know your state's capital before your interview. (D.C. is the U.S. capital, not a state. Territories also have capitals.)"),
            .init(text: "您所在州的首府是哪里？",
                  options: ["依您所在州而定", "华盛顿哥伦比亚特区", "纽约市", "洛杉矶"],
                  explanation: "每个州都有自己的首府。请在面试前了解所在州的首府。（哥伦比亚特区是美国首都，不是州。领地也有各自的首府。）"),
            .init(text: "您所在州的首府是哪裡？",
                  options: ["依您所在州而定", "華盛頓哥倫比亞特區", "紐約市", "洛杉磯"],
                  explanation: "每個州都有自己的首府。請在面試前瞭解所在州的首府。（哥倫比亞特區是美國首都，不是州。領地也有各自的首府。）")
        ]),
        UnifiedQuestion(id: "q_25_063", correctAnswer: 1, variants: [
            .init(text: "There are four amendments to the U.S. Constitution about who can vote. Describe one of them.",
                  options: ["Only homeowners can vote", "Citizens 18 and older can vote", "Only male citizens can vote", "Voting requires a literacy test"],
                  explanation: "The 26th Amendment (1971) lowered the voting age to 18. Other voting amendments are the 15th (men of any race), 19th (women), and 24th (no poll tax)."),
            .init(text: "《美国宪法》中有四条关于谁能投票的修正案。请描述其中之一。",
                  options: ["只有房主才能投票", "年满 18 岁的公民可以投票", "只有男性公民才能投票", "投票须通过识字测试"],
                  explanation: "第 26 修正案（1971 年）将投票年龄降至 18 岁。其他投票相关修正案为第 15 修正案（任何种族的男性）、第 19 修正案（女性）和第 24 修正案（取消投票税）。"),
            .init(text: "《美國憲法》中有四條關於誰能投票的修正案。請描述其中之一。",
                  options: ["只有房主才能投票", "年滿 18 歲的公民可以投票", "只有男性公民才能投票", "投票須通過識字測試"],
                  explanation: "第 26 修正案（1971 年）將投票年齡降至 18 歲。其他投票相關修正案為第 15 修正案（任何種族的男性）、第 19 修正案（女性）和第 24 修正案（取消投票稅）。")
        ]),
        UnifiedQuestion(id: "q_25_064", correctAnswer: 1, variants: [
            .init(text: "Who can vote in federal elections, run for federal office, and serve on a jury in the United States?",
                  options: ["All adults", "U.S. citizens only", "Anyone with a passport", "Only military veterans"],
                  explanation: "Only U.S. citizens have the rights to vote in federal elections, run for federal office, and serve on a jury."),
            .init(text: "在美国，谁可以在联邦选举中投票、竞选联邦公职及担任陪审员？",
                  options: ["所有成年人", "仅美国公民", "任何持有护照者", "仅退伍军人"],
                  explanation: "只有美国公民拥有在联邦选举中投票、竞选联邦公职及担任陪审员的权利。"),
            .init(text: "在美國，誰可以在聯邦選舉中投票、競選聯邦公職及擔任陪審員？",
                  options: ["所有成年人", "僅美國公民", "任何持有護照者", "僅退伍軍人"],
                  explanation: "只有美國公民擁有在聯邦選舉中投票、競選聯邦公職及擔任陪審員的權利。")
        ]),
        UnifiedQuestion(id: "q_25_065", correctAnswer: 1, variants: [
            .init(text: "What are three rights of everyone living in the United States?",
                  options: ["Free housing, free food, free healthcare", "Freedom of speech, freedom of religion, and freedom of assembly", "Right to vote, run for office, and own land", "Right to drive, own a gun, and choose any job"],
                  explanation: "Rights of everyone living in the U.S. (citizen or not) include freedom of speech, religion, assembly, the press, and to petition the government."),
            .init(text: "在美国居住的每个人享有的三项权利是什么？",
                  options: ["免费住房、免费食物、免费医疗", "言论自由、宗教自由及集会自由", "投票权、竞选公职及拥有土地", "驾驶权、持枪权及自由择业"],
                  explanation: "所有在美国居住的人（无论是否公民）享有的权利包括言论、宗教、集会、新闻及向政府请愿的自由。"),
            .init(text: "在美國居住的每個人享有的三項權利是什麼？",
                  options: ["免費住房、免費食物、免費醫療", "言論自由、宗教自由及集會自由", "投票權、競選公職及擁有土地", "駕駛權、持槍權及自由擇業"],
                  explanation: "所有在美國居住的人（無論是否公民）享有的權利包括言論、宗教、集會、新聞及向政府請願的自由。")
        ]),
        UnifiedQuestion(id: "q_25_067", correctAnswer: 1, variants: [
            .init(text: "Name two promises that new citizens make in the Oath of Allegiance.",
                  options: ["Pay extra taxes and vote in every election", "Give up loyalty to other countries and obey U.S. laws", "Speak only English and serve in the military", "Become Christian and own property"],
                  explanation: "The Oath includes giving up loyalty to other countries, defending the Constitution, obeying U.S. laws, and serving the nation when needed."),
            .init(text: "新公民在效忠宣誓中所作的两项承诺是什么？",
                  options: ["缴纳额外税款并每次选举都投票", "放弃对其他国家的效忠并遵守美国法律", "只讲英语并加入军队", "成为基督徒并拥有财产"],
                  explanation: "效忠宣誓包括放弃对其他国家的效忠、护卫宪法、遵守美国法律以及在必要时为国效劳。"),
            .init(text: "新公民在效忠宣誓中所作的兩項承諾是什麼？",
                  options: ["繳納額外稅款並每次選舉都投票", "放棄對其他國家的效忠並遵守美國法律", "只講英語並加入軍隊", "成為基督徒並擁有財產"],
                  explanation: "效忠宣誓包括放棄對其他國家的效忠、護衛憲法、遵守美國法律以及在必要時為國效勞。")
        ]),
        UnifiedQuestion(id: "q_25_068", correctAnswer: 1, variants: [
            .init(text: "How can people become United States citizens?",
                  options: ["Only by being born in the U.S.", "By naturalization or being born in the U.S. (under certain conditions)", "Only by marrying a U.S. citizen", "Only by joining the military"],
                  explanation: "People become U.S. citizens by being born in the U.S. (under conditions of the 14th Amendment), through naturalization, or by deriving citizenship through their parents."),
            .init(text: "人们如何成为美国公民？",
                  options: ["仅通过在美国出生", "通过归化或在美国出生（在特定条件下）", "仅通过与美国公民结婚", "仅通过加入军队"],
                  explanation: "人们可以通过在美国出生（依据第 14 修正案）、归化或通过父母获得衍生公民身份成为美国公民。"),
            .init(text: "人們如何成為美國公民？",
                  options: ["僅通過在美國出生", "通過歸化或在美國出生（在特定條件下）", "僅通過與美國公民結婚", "僅通過加入軍隊"],
                  explanation: "人們可以通過在美國出生（依據第 14 修正案）、歸化或通過父母獲得衍生公民身份成為美國公民。")
        ]),
        UnifiedQuestion(id: "q_25_069", correctAnswer: 1, variants: [
            .init(text: "What are two examples of civic participation in the United States?",
                  options: ["Eating at restaurants and watching TV", "Voting and joining a community group", "Working a job and paying rent", "Driving a car and owning a home"],
                  explanation: "Civic participation includes voting, running for office, joining a political party or community group, contacting elected officials, and supporting/opposing issues."),
            .init(text: "在美国，公民参与的两个例子是什么？",
                  options: ["在餐厅吃饭和看电视", "投票及加入社区团体", "工作和支付租金", "开车和拥有住房"],
                  explanation: "公民参与包括投票、竞选公职、加入政党或社区团体、联系民选官员，以及支持或反对某项议题。"),
            .init(text: "在美國，公民參與的兩個例子是什麼？",
                  options: ["在餐廳吃飯和看電視", "投票及加入社區團體", "工作和支付租金", "開車和擁有住房"],
                  explanation: "公民參與包括投票、競選公職、加入政黨或社區團體、聯繫民選官員，以及支持或反對某項議題。")
        ]),
        UnifiedQuestion(id: "q_25_070", correctAnswer: 1, variants: [
            .init(text: "What is one way Americans can serve their country?",
                  options: ["Get a high-paying job", "Serve in the military, work for the government, or pay taxes", "Travel abroad as a tourist", "Buy U.S.-made products"],
                  explanation: "Americans can serve by voting, paying taxes, obeying the law, serving in the military, running for office, or working for local, state, or federal government."),
            .init(text: "美国人为国效劳的一种方式是什么？",
                  options: ["从事高薪工作", "加入军队、为政府工作或缴税", "以游客身份出国旅行", "购买美国制造的产品"],
                  explanation: "美国人可通过投票、缴税、守法、加入军队、竞选公职或在地方、州或联邦政府任职等方式为国效劳。"),
            .init(text: "美國人為國效勞的一種方式是什麼？",
                  options: ["從事高薪工作", "加入軍隊、為政府工作或繳稅", "以遊客身份出國旅行", "購買美國製造的產品"],
                  explanation: "美國人可通過投票、繳稅、守法、加入軍隊、競選公職或在地方、州或聯邦政府任職等方式為國效勞。")
        ]),
        UnifiedQuestion(id: "q_25_071", correctAnswer: 1, variants: [
            .init(text: "Why is it important to pay federal taxes?",
                  options: ["Because tax money goes to other countries", "It is required by law and funds the federal government", "Only wealthy citizens pay taxes", "Taxes are voluntary in the U.S."],
                  explanation: "Paying federal taxes is required by law and funds the federal government. The 16th Amendment (1913) authorized the federal income tax."),
            .init(text: "为什么缴纳联邦税很重要？",
                  options: ["因为税款流向其他国家", "这是法律规定的，且为联邦政府提供经费", "只有富有公民才需缴税", "美国的税收是自愿的"],
                  explanation: "缴纳联邦税是法律规定的，并为联邦政府提供经费。第 16 修正案（1913 年）授权征收联邦所得税。"),
            .init(text: "為什麼繳納聯邦稅很重要？",
                  options: ["因為稅款流向其他國家", "這是法律規定的，且為聯邦政府提供經費", "只有富有公民才需繳稅", "美國的稅收是自願的"],
                  explanation: "繳納聯邦稅是法律規定的，並為聯邦政府提供經費。第 16 修正案（1913 年）授權徵收聯邦所得稅。")
        ]),
        UnifiedQuestion(id: "q_25_072", correctAnswer: 1, variants: [
            .init(text: "It is important for all men age 18 through 25 to register for the Selective Service. Name one reason why.",
                  options: ["To get a free college education", "It is required by law (to make a draft fair if needed)", "To receive Social Security benefits", "To get a passport"],
                  explanation: "Selective Service registration is required by law for men ages 18-25. It allows the government to conduct a fair draft if one becomes necessary."),
            .init(text: "所有 18 至 25 岁的男性必须进行兵役登记。请说出一项原因。",
                  options: ["以获得免费大学教育", "这是法律规定的（在必要时使征兵公平进行）", "以领取社会安全福利", "以获得护照"],
                  explanation: "18-25 岁男性的兵役登记是法律规定的，让政府在必要时能够公平地实施征兵。"),
            .init(text: "所有 18 至 25 歲的男性必須進行兵役登記。請說出一項原因。",
                  options: ["以獲得免費大學教育", "這是法律規定的（在必要時使徵兵公平進行）", "以領取社會安全福利", "以獲得護照"],
                  explanation: "18-25 歲男性的兵役登記是法律規定的，讓政府在必要時能夠公平地實施徵兵。")
        ]),
        UnifiedQuestion(id: "q_25_125", correctAnswer: 1, variants: [
            .init(text: "What is Independence Day?",
                  options: ["A holiday for Christopher Columbus", "A holiday celebrating U.S. independence from Britain", "A holiday honoring veterans", "A holiday for the Constitution"],
                  explanation: "Independence Day (July 4) celebrates the adoption of the Declaration of Independence in 1776 — the country's birthday."),
            .init(text: "什么是独立纪念日？",
                  options: ["纪念克里斯托弗·哥伦布的节日", "庆祝美国脱离英国独立的节日", "纪念退伍军人的节日", "纪念宪法的节日"],
                  explanation: "独立纪念日（7 月 4 日）庆祝 1776 年通过《独立宣言》——美国的生日。"),
            .init(text: "什麼是獨立紀念日？",
                  options: ["紀念克里斯多福·哥倫布的節日", "慶祝美國脫離英國獨立的節日", "紀念退伍軍人的節日", "紀念憲法的節日"],
                  explanation: "獨立紀念日（7 月 4 日）慶祝 1776 年通過《獨立宣言》——美國的生日。")
        ])
    ]

    // MARK: - Practice 6: Founding Era & Revolution (16 questions)
    static let practice6: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_073", correctAnswer: 1, variants: [
            .init(text: "The colonists came to America for many reasons. Name one.",
                  options: ["To start a new civilization", "Religious freedom", "To find gold only", "To meet Native Americans"],
                  explanation: "Many colonists came seeking religious freedom, escaping persecution. Others came for political liberty or economic opportunity."),
            .init(text: "殖民者因许多原因来到美洲。请说出其中一个。",
                  options: ["开创新文明", "宗教自由", "仅为了寻找黄金", "为了见到美洲原住民"],
                  explanation: "许多殖民者为寻求宗教自由、逃避迫害而来。其他人则因政治自由或经济机会而来。"),
            .init(text: "殖民者因許多原因來到美洲。請說出其中一個。",
                  options: ["開創新文明", "宗教自由", "僅為了尋找黃金", "為了見到美洲原住民"],
                  explanation: "許多殖民者為尋求宗教自由、逃避迫害而來。其他人則因政治自由或經濟機會而來。")
        ]),
        UnifiedQuestion(id: "q_25_074", correctAnswer: 2, variants: [
            .init(text: "Who lived in America before the Europeans arrived?",
                  options: ["African settlers", "Asian immigrants", "American Indians (Native Americans)", "European explorers"],
                  explanation: "American Indians (Native Americans) lived across the Americas for thousands of years before European arrival."),
            .init(text: "在欧洲人到来之前，谁居住在美洲？",
                  options: ["非洲殖民者", "亚洲移民", "美国印地安人（美洲原住民）", "欧洲探险家"],
                  explanation: "美国印地安人（美洲原住民）在欧洲人到来前已在美洲各地生活了数千年。"),
            .init(text: "在歐洲人到來之前，誰居住在美洲？",
                  options: ["非洲殖民者", "亞洲移民", "美國印地安人（美洲原住民）", "歐洲探險家"],
                  explanation: "美國印地安人（美洲原住民）在歐洲人到來前已在美洲各地生活了數千年。")
        ]),
        UnifiedQuestion(id: "q_25_075", correctAnswer: 2, variants: [
            .init(text: "What group of people was taken and sold as slaves?",
                  options: ["Native Americans", "Europeans", "Africans (people from Africa)", "Asians"],
                  explanation: "Africans were taken from their homelands and sold as slaves in the Americas, primarily from the 1500s to the 1800s."),
            .init(text: "哪个族群被带走并贩卖为奴隶？",
                  options: ["美洲原住民", "欧洲人", "非洲人（来自非洲的人）", "亚洲人"],
                  explanation: "非洲人被从家乡掳走并在美洲被贩卖为奴隶，主要发生在 1500 年代至 1800 年代。"),
            .init(text: "哪個族群被帶走並販賣為奴隸？",
                  options: ["美洲原住民", "歐洲人", "非洲人（來自非洲的人）", "亞洲人"],
                  explanation: "非洲人被從家鄉擄走並在美洲被販賣為奴隸，主要發生在 1500 年代至 1800 年代。")
        ]),
        UnifiedQuestion(id: "q_25_076", correctAnswer: 1, variants: [
            .init(text: "What war did the Americans fight to win independence from Britain?",
                  options: ["The Civil War", "The American Revolution (Revolutionary War)", "The War of 1812", "World War I"],
                  explanation: "The American Revolution (1775-1783) won the colonies' independence from Britain, formalized by the Treaty of Paris in 1783."),
            .init(text: "美国人为脱离英国独立而进行的是哪场战争？",
                  options: ["内战", "美国革命（独立战争）", "1812 年战争", "第一次世界大战"],
                  explanation: "美国革命（1775-1783 年）为殖民地赢得独立，并于 1783 年通过《巴黎条约》正式确立。"),
            .init(text: "美國人為脫離英國獨立而進行的是哪場戰爭？",
                  options: ["內戰", "美國革命（獨立戰爭）", "1812 年戰爭", "第一次世界大戰"],
                  explanation: "美國革命（1775-1783 年）為殖民地贏得獨立，並於 1783 年通過《巴黎條約》正式確立。")
        ]),
        UnifiedQuestion(id: "q_25_077", correctAnswer: 1, variants: [
            .init(text: "Name one reason why the Americans declared independence from Britain.",
                  options: ["Britain treated colonists too well", "High taxes (taxation without representation)", "The colonies wanted to merge with France", "British food was unhealthy"],
                  explanation: "Reasons included high taxes (taxation without representation), British soldiers in colonial homes, lack of self-government, the Boston Massacre, and the Boston Tea Party."),
            .init(text: "请说出美国人宣告脱离英国独立的一个原因。",
                  options: ["英国对殖民者过于优待", "高额税收（无代表权的征税）", "殖民地想与法国合并", "英国食物不健康"],
                  explanation: "原因包括高额税收（无代表权的征税）、英国士兵驻扎在殖民地民宅、缺乏自治、波士顿大屠杀及波士顿茶党事件。"),
            .init(text: "請說出美國人宣告脫離英國獨立的一個原因。",
                  options: ["英國對殖民者過於優待", "高額稅收（無代表權的徵稅）", "殖民地想與法國合併", "英國食物不健康"],
                  explanation: "原因包括高額稅收（無代表權的徵稅）、英國士兵駐紮在殖民地民宅、缺乏自治、波士頓大屠殺及波士頓茶黨事件。")
        ]),
        UnifiedQuestion(id: "q_25_078", correctAnswer: 1, variants: [
            .init(text: "Who wrote the Declaration of Independence?",
                  options: ["George Washington", "Thomas Jefferson", "Benjamin Franklin", "John Adams"],
                  explanation: "Thomas Jefferson was the principal author of the Declaration of Independence, drafted in 1776 at age 33."),
            .init(text: "《独立宣言》是谁起草的？",
                  options: ["乔治·华盛顿", "托马斯·杰斐逊", "本杰明·富兰克林", "约翰·亚当斯"],
                  explanation: "托马斯·杰斐逊是《独立宣言》的主要作者，于 1776 年 33 岁时起草。"),
            .init(text: "《獨立宣言》是誰起草的？",
                  options: ["喬治·華盛頓", "湯瑪士·傑佛遜", "班哲明·富蘭克林", "約翰·亞當斯"],
                  explanation: "湯瑪士·傑佛遜是《獨立宣言》的主要作者，於 1776 年 33 歲時起草。")
        ]),
        UnifiedQuestion(id: "q_25_079", correctAnswer: 1, variants: [
            .init(text: "When was the Declaration of Independence adopted?",
                  options: ["July 4, 1775", "July 4, 1776", "July 4, 1789", "July 4, 1812"],
                  explanation: "The Declaration of Independence was adopted on July 4, 1776 — celebrated annually as Independence Day."),
            .init(text: "《独立宣言》是何时通过的？",
                  options: ["1775 年 7 月 4 日", "1776 年 7 月 4 日", "1789 年 7 月 4 日", "1812 年 7 月 4 日"],
                  explanation: "《独立宣言》于 1776 年 7 月 4 日通过——每年作为独立纪念日庆祝。"),
            .init(text: "《獨立宣言》是何時通過的？",
                  options: ["1775 年 7 月 4 日", "1776 年 7 月 4 日", "1789 年 7 月 4 日", "1812 年 7 月 4 日"],
                  explanation: "《獨立宣言》於 1776 年 7 月 4 日通過——每年作為獨立紀念日慶祝。")
        ]),
        UnifiedQuestion(id: "q_25_080", correctAnswer: 1, variants: [
            .init(text: "The American Revolution had many important events. Name one.",
                  options: ["The Battle of Gettysburg", "The Declaration of Independence (1776)", "Pearl Harbor attack", "Fall of the Berlin Wall"],
                  explanation: "Important Revolution events include the Battle of Bunker Hill, the Declaration of Independence, Washington crossing the Delaware, Valley Forge, and the Battle of Yorktown."),
            .init(text: "美国革命有许多重要事件。请说出其中之一。",
                  options: ["葛底斯堡战役", "《独立宣言》（1776 年）", "珍珠港事件", "柏林墙倒塌"],
                  explanation: "美国革命的重要事件包括邦克山之战、《独立宣言》、华盛顿横渡特拉华河、福吉谷以及约克镇之战。"),
            .init(text: "美國革命有許多重要事件。請說出其中之一。",
                  options: ["蓋茨堡之戰", "《獨立宣言》（1776 年）", "珍珠港事件", "柏林牆倒塌"],
                  explanation: "美國革命的重要事件包括邦克山之戰、《獨立宣言》、華盛頓橫渡特拉華河、福吉谷以及約克鎮之戰。")
        ]),
        UnifiedQuestion(id: "q_25_081", correctAnswer: 1, variants: [
            .init(text: "There were 13 original states. Name five.",
                  options: ["California, Texas, Florida, Hawaii, Alaska", "Virginia, Massachusetts, New York, Pennsylvania, Georgia", "Ohio, Michigan, Illinois, Indiana, Wisconsin", "Maine, Vermont, West Virginia, Oregon, Iowa"],
                  explanation: "The 13 original states were New Hampshire, Massachusetts, Rhode Island, Connecticut, New York, New Jersey, Pennsylvania, Delaware, Maryland, Virginia, North Carolina, South Carolina, and Georgia."),
            .init(text: "美国原有 13 个州。请说出五个。",
                  options: ["加利福尼亚、德克萨斯、佛罗里达、夏威夷、阿拉斯加", "弗吉尼亚、马萨诸塞、纽约、宾夕法尼亚、佐治亚", "俄亥俄、密歇根、伊利诺伊、印第安纳、威斯康星", "缅因、佛蒙特、西弗吉尼亚、俄勒冈、爱荷华"],
                  explanation: "13 个原始州为新罕布什尔、马萨诸塞、罗德岛、康涅狄格、纽约、新泽西、宾夕法尼亚、特拉华、马里兰、弗吉尼亚、北卡罗来纳、南卡罗来纳和佐治亚。"),
            .init(text: "美國原有 13 個州。請說出五個。",
                  options: ["加利福尼亞、德克薩斯、佛羅里達、夏威夷、阿拉斯加", "維吉尼亞、麻薩諸塞、紐約、賓夕法尼亞、喬治亞", "俄亥俄、密西根、伊利諾、印第安納、威斯康辛", "緬因、佛蒙特、西維吉尼亞、奧勒岡、愛荷華"],
                  explanation: "13 個原始州為新罕布夏、麻薩諸塞、羅德島、康乃狄克、紐約、紐澤西、賓夕法尼亞、德拉瓦、馬里蘭、維吉尼亞、北卡羅萊納、南卡羅萊納和喬治亞。")
        ]),
        UnifiedQuestion(id: "q_25_082", correctAnswer: 1, variants: [
            .init(text: "What founding document was written in 1787?",
                  options: ["The Declaration of Independence", "The U.S. Constitution", "The Bill of Rights", "The Articles of Confederation"],
                  explanation: "The U.S. Constitution was written at the Constitutional Convention in Philadelphia in 1787 and ratified in 1788."),
            .init(text: "1787 年起草的建国文献是哪一份？",
                  options: ["《独立宣言》", "《美国宪法》", "《权利法案》", "《邦联条例》"],
                  explanation: "《美国宪法》于 1787 年在费城制宪会议上起草，并于 1788 年获得批准。"),
            .init(text: "1787 年起草的建國文獻是哪一份？",
                  options: ["《獨立宣言》", "《美國憲法》", "《權利法案》", "《邦聯條例》"],
                  explanation: "《美國憲法》於 1787 年在費城制憲會議上起草，並於 1788 年獲得批准。")
        ]),
        UnifiedQuestion(id: "q_25_083", correctAnswer: 1, variants: [
            .init(text: "The Federalist Papers supported the passage of the U.S. Constitution. Name one of the writers.",
                  options: ["Thomas Jefferson", "James Madison (or Hamilton, or Jay)", "George Washington", "Benjamin Franklin"],
                  explanation: "The Federalist Papers were written by James Madison, Alexander Hamilton, and John Jay (under the pen name \"Publius\") to argue for ratifying the Constitution."),
            .init(text: "《联邦论》支持《美国宪法》的通过。请说出其作者之一。",
                  options: ["托马斯·杰斐逊", "詹姆斯·麦迪逊（或汉密尔顿、杰伊）", "乔治·华盛顿", "本杰明·富兰克林"],
                  explanation: "《联邦论》由詹姆斯·麦迪逊、亚历山大·汉密尔顿和约翰·杰伊（笔名「普布利乌斯」）撰写，旨在论证批准宪法。"),
            .init(text: "《聯邦論》支持《美國憲法》的通過。請說出其作者之一。",
                  options: ["湯瑪士·傑佛遜", "詹姆士·麥迪森（或漢密爾頓、傑伊）", "喬治·華盛頓", "班哲明·富蘭克林"],
                  explanation: "《聯邦論》由詹姆士·麥迪森、亞歷山大·漢密爾頓和約翰·傑伊（筆名「普布利烏斯」）撰寫，旨在論證批准憲法。")
        ]),
        UnifiedQuestion(id: "q_25_084", correctAnswer: 1, variants: [
            .init(text: "Why were the Federalist Papers important?",
                  options: ["They led to the American Revolution", "They helped people understand and supported passing the Constitution", "They started the Civil War", "They wrote new amendments"],
                  explanation: "The 85 Federalist essays explained how the new Constitution would work and persuaded states (especially New York) to ratify it."),
            .init(text: "为什么《联邦论》很重要？",
                  options: ["引发了美国革命", "帮助人民理解宪法并支持其通过", "引发了内战", "撰写了新的修正案"],
                  explanation: "85 篇《联邦论》文章解释了新宪法如何运作，并说服各州（尤其是纽约州）批准宪法。"),
            .init(text: "為什麼《聯邦論》很重要？",
                  options: ["引發了美國革命", "幫助人民理解憲法並支持其通過", "引發了內戰", "撰寫了新的修正案"],
                  explanation: "85 篇《聯邦論》文章解釋了新憲法如何運作，並說服各州（尤其是紐約州）批准憲法。")
        ]),
        UnifiedQuestion(id: "q_25_085", correctAnswer: 1, variants: [
            .init(text: "Benjamin Franklin is famous for many things. Name one.",
                  options: ["First President", "First Postmaster General and inventor", "Wrote the Declaration of Independence alone", "First Chief Justice"],
                  explanation: "Franklin was the first Postmaster General, an inventor, a U.S. diplomat, founder of the first free public libraries, and helped write the Declaration of Independence."),
            .init(text: "本杰明·富兰克林因许多事迹而著名。请说出其中之一。",
                  options: ["首任总统", "首任邮政总局局长和发明家", "独自撰写了《独立宣言》", "首任首席大法官"],
                  explanation: "富兰克林是首任邮政总局局长、发明家、美国外交官、首批免费公共图书馆的创办人，并参与撰写了《独立宣言》。"),
            .init(text: "班哲明·富蘭克林因許多事蹟而著名。請說出其中之一。",
                  options: ["首任總統", "首任郵政總局局長和發明家", "獨自撰寫了《獨立宣言》", "首任首席大法官"],
                  explanation: "富蘭克林是首任郵政總局局長、發明家、美國外交官、首批免費公共圖書館的創辦人，並參與撰寫了《獨立宣言》。")
        ]),
        UnifiedQuestion(id: "q_25_086", correctAnswer: 1, variants: [
            .init(text: "George Washington is famous for many things. Name one.",
                  options: ["Wrote the Declaration of Independence", "First President of the United States", "Discovered America", "Wrote the Star-Spangled Banner"],
                  explanation: "Washington is called the \"Father of Our Country.\" He led the Continental Army and was the first U.S. President (1789-1797)."),
            .init(text: "乔治·华盛顿因许多事迹而著名。请说出其中之一。",
                  options: ["撰写了《独立宣言》", "美国首任总统", "发现了美洲", "创作了《星条旗之歌》"],
                  explanation: "华盛顿被尊为「美国国父」。他领导大陆军，并担任美国首任总统（1789-1797 年）。"),
            .init(text: "喬治·華盛頓因許多事蹟而著名。請說出其中之一。",
                  options: ["撰寫了《獨立宣言》", "美國首任總統", "發現了美洲", "創作了《星條旗之歌》"],
                  explanation: "華盛頓被尊為「美國國父」。他領導大陸軍，並擔任美國首任總統（1789-1797 年）。")
        ]),
        UnifiedQuestion(id: "q_25_087", correctAnswer: 1, variants: [
            .init(text: "Thomas Jefferson is famous for many things. Name one.",
                  options: ["Discovered electricity", "Wrote the Declaration of Independence and was 3rd President", "Led the Confederacy in the Civil War", "Invented the cotton gin"],
                  explanation: "Jefferson wrote the Declaration of Independence, was the 3rd President, doubled the U.S. with the Louisiana Purchase, and founded the University of Virginia."),
            .init(text: "托马斯·杰斐逊因许多事迹而著名。请说出其中之一。",
                  options: ["发现了电", "撰写了《独立宣言》并担任第三任总统", "在内战中领导邦联", "发明了轧棉机"],
                  explanation: "杰斐逊撰写了《独立宣言》，担任第三任总统，通过路易斯安那购地使美国领土翻倍，并创办了弗吉尼亚大学。"),
            .init(text: "湯瑪士·傑佛遜因許多事蹟而著名。請說出其中之一。",
                  options: ["發現了電", "撰寫了《獨立宣言》並擔任第三任總統", "在內戰中領導邦聯", "發明了軋棉機"],
                  explanation: "傑佛遜撰寫了《獨立宣言》，擔任第三任總統，通過路易斯安那購地使美國領土翻倍，並創辦了維吉尼亞大學。")
        ]),
        UnifiedQuestion(id: "q_25_088", correctAnswer: 0, variants: [
            .init(text: "James Madison is famous for many things. Name one.",
                  options: ["Father of the Constitution and 4th President", "Led the Underground Railroad", "Discovered America", "Founded Boston"],
                  explanation: "Madison is called the \"Father of the Constitution.\" He was the 4th President, served during the War of 1812, and was a writer of the Federalist Papers."),
            .init(text: "詹姆斯·麦迪森因许多事迹而著名。请说出其中之一。",
                  options: ["宪法之父及第四任总统", "领导了地下铁路", "发现了美洲", "创建了波士顿"],
                  explanation: "麦迪森被尊为「宪法之父」。他是第四任总统，在 1812 年战争期间任职，并是《联邦论》的作者之一。"),
            .init(text: "詹姆士·麥迪森因許多事蹟而著名。請說出其中之一。",
                  options: ["憲法之父及第四任總統", "領導了地下鐵路", "發現了美洲", "創建了波士頓"],
                  explanation: "麥迪森被尊為「憲法之父」。他是第四任總統，在 1812 年戰爭期間任職，並是《聯邦論》的作者之一。")
        ])
    ]

    // MARK: - Practice 7: 1800s & National Identity (16 questions)
    static let practice7: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_089", correctAnswer: 1, variants: [
            .init(text: "Alexander Hamilton is famous for many things. Name one.",
                  options: ["First President of the U.S.", "First Secretary of the Treasury and Federalist Papers writer", "Discovered penicillin", "Wrote the Star-Spangled Banner"],
                  explanation: "Hamilton was the first Secretary of the Treasury, a writer of the Federalist Papers, helped establish the First Bank of the United States, and was an aide to General Washington."),
            .init(text: "亚历山大·汉密尔顿因许多事迹而著名。请说出其中之一。",
                  options: ["美国首任总统", "首任财政部长及《联邦论》作者", "发现了青霉素", "创作了《星条旗之歌》"],
                  explanation: "汉密尔顿是首任财政部长、《联邦论》作者之一，协助建立美国第一银行，并曾是华盛顿将军的副官。"),
            .init(text: "亞歷山大·漢密爾頓因許多事蹟而著名。請說出其中之一。",
                  options: ["美國首任總統", "首任財政部長及《聯邦論》作者", "發現了青黴素", "創作了《星條旗之歌》"],
                  explanation: "漢密爾頓是首任財政部長、《聯邦論》作者之一，協助建立美國第一銀行，並曾是華盛頓將軍的副官。")
        ]),
        UnifiedQuestion(id: "q_25_090", correctAnswer: 1, variants: [
            .init(text: "What territory did the United States buy from France in 1803?",
                  options: ["Florida", "Louisiana Territory", "Alaska", "Texas"],
                  explanation: "President Jefferson bought the Louisiana Territory from France in 1803 for $15 million, doubling the size of the United States."),
            .init(text: "美国于 1803 年从法国购买的领地是哪里？",
                  options: ["佛罗里达", "路易斯安那领地", "阿拉斯加", "德克萨斯"],
                  explanation: "杰斐逊总统于 1803 年以 1500 万美元从法国购得路易斯安那领地，使美国领土翻倍。"),
            .init(text: "美國於 1803 年從法國購買的領地是哪裡？",
                  options: ["佛羅里達", "路易斯安那領地", "阿拉斯加", "德克薩斯"],
                  explanation: "傑佛遜總統於 1803 年以 1500 萬美元從法國購得路易斯安那領地，使美國領土翻倍。")
        ]),
        UnifiedQuestion(id: "q_25_091", correctAnswer: 1, variants: [
            .init(text: "Name one war fought by the United States in the 1800s.",
                  options: ["World War I", "Civil War (or War of 1812, Mexican-American War, Spanish-American War)", "Vietnam War", "Korean War"],
                  explanation: "Wars fought by the U.S. in the 1800s include the War of 1812, the Mexican-American War, the Civil War, and the Spanish-American War."),
            .init(text: "请说出美国在 1800 年代参与的一场战争。",
                  options: ["第一次世界大战", "内战（或 1812 年战争、美墨战争、美西战争）", "越南战争", "朝鲜战争"],
                  explanation: "美国在 1800 年代参与的战争包括 1812 年战争、美墨战争、内战及美西战争。"),
            .init(text: "請說出美國在 1800 年代參與的一場戰爭。",
                  options: ["第一次世界大戰", "內戰（或 1812 年戰爭、美墨戰爭、美西戰爭）", "越南戰爭", "朝鮮戰爭"],
                  explanation: "美國在 1800 年代參與的戰爭包括 1812 年戰爭、美墨戰爭、內戰及美西戰爭。")
        ]),
        UnifiedQuestion(id: "q_25_092", correctAnswer: 2, variants: [
            .init(text: "Name the U.S. war between the North and the South.",
                  options: ["The Revolutionary War", "The War of 1812", "The Civil War", "The Mexican-American War"],
                  explanation: "The Civil War (1861-1865) was fought between the Northern Union states and the Southern Confederate states, primarily over slavery."),
            .init(text: "请说出美国南方与北方之间的战争名称。",
                  options: ["独立战争", "1812 年战争", "内战", "美墨战争"],
                  explanation: "内战（1861-1865 年）是北方联邦诸州与南方邦联诸州之间的战争，主要因奴隶制问题而起。"),
            .init(text: "請說出美國南方與北方之間的戰爭名稱。",
                  options: ["獨立戰爭", "1812 年戰爭", "內戰", "美墨戰爭"],
                  explanation: "內戰（1861-1865 年）是北方聯邦諸州與南方邦聯諸州之間的戰爭，主要因奴隸制問題而起。")
        ]),
        UnifiedQuestion(id: "q_25_093", correctAnswer: 1, variants: [
            .init(text: "The Civil War had many important events. Name one.",
                  options: ["The bombing of Pearl Harbor", "The Battle of Gettysburg (or Emancipation Proclamation, Surrender at Appomattox)", "Construction of the Panama Canal", "The first moon landing"],
                  explanation: "Important Civil War events include the Battle of Fort Sumter, Emancipation Proclamation, Battle of Gettysburg, Sherman's March, and the Surrender at Appomattox."),
            .init(text: "内战有许多重要事件。请说出其中之一。",
                  options: ["珍珠港事件", "盖茨堡之战（或《解放宣言》、阿波马托克斯投降）", "巴拿马运河的建造", "首次登月"],
                  explanation: "内战的重要事件包括萨姆特堡之战、《解放宣言》、盖茨堡之战、谢尔曼进军以及阿波马托克斯投降。"),
            .init(text: "內戰有許多重要事件。請說出其中之一。",
                  options: ["珍珠港事件", "蓋茨堡之戰（或《解放宣言》、阿波馬托克斯投降）", "巴拿馬運河的建造", "首次登月"],
                  explanation: "內戰的重要事件包括薩姆特堡之戰、《解放宣言》、蓋茨堡之戰、謝爾曼進軍以及阿波馬托克斯投降。")
        ]),
        UnifiedQuestion(id: "q_25_094", correctAnswer: 1, variants: [
            .init(text: "Abraham Lincoln is famous for many things. Name one.",
                  options: ["Wrote the Constitution", "Freed the slaves and preserved the Union", "Discovered electricity", "Founded the Republican Party"],
                  explanation: "Lincoln freed the slaves with the Emancipation Proclamation, preserved the Union during the Civil War, and was the 16th President."),
            .init(text: "亚伯拉罕·林肯因许多事迹而著名。请说出其中之一。",
                  options: ["撰写了宪法", "解放奴隶并保全联邦", "发现了电", "创立了共和党"],
                  explanation: "林肯以《解放宣言》解放了奴隶，在内战期间保全了联邦，是美国第 16 任总统。"),
            .init(text: "亞伯拉罕·林肯因許多事蹟而著名。請說出其中之一。",
                  options: ["撰寫了憲法", "解放奴隸並保全聯邦", "發現了電", "創立了共和黨"],
                  explanation: "林肯以《解放宣言》解放了奴隸，在內戰期間保全了聯邦，是美國第 16 任總統。")
        ]),
        UnifiedQuestion(id: "q_25_095", correctAnswer: 1, variants: [
            .init(text: "What did the Emancipation Proclamation do?",
                  options: ["Started the Civil War", "Freed the slaves in the Confederate states", "Granted women the right to vote", "Ended World War II"],
                  explanation: "President Lincoln's Emancipation Proclamation (1863) declared slaves in the Confederate states to be free."),
            .init(text: "《解放宣言》做了什么？",
                  options: ["发动了内战", "解放了邦联诸州的奴隶", "赋予妇女投票权", "结束了第二次世界大战"],
                  explanation: "林肯总统的《解放宣言》（1863 年）宣告邦联诸州的奴隶获得自由。"),
            .init(text: "《解放宣言》做了什麼？",
                  options: ["發動了內戰", "解放了邦聯諸州的奴隸", "賦予婦女投票權", "結束了第二次世界大戰"],
                  explanation: "林肯總統的《解放宣言》（1863 年）宣告邦聯諸州的奴隸獲得自由。")
        ]),
        UnifiedQuestion(id: "q_25_096", correctAnswer: 2, variants: [
            .init(text: "What U.S. war ended slavery?",
                  options: ["The Revolutionary War", "The War of 1812", "The Civil War", "World War I"],
                  explanation: "The Civil War ended slavery. The 13th Amendment, ratified in 1865 after the war, formally abolished slavery throughout the United States."),
            .init(text: "美国的哪场战争结束了奴隶制？",
                  options: ["独立战争", "1812 年战争", "内战", "第一次世界大战"],
                  explanation: "内战结束了奴隶制。战后于 1865 年批准的第 13 修正案正式废除了美国境内的奴隶制。"),
            .init(text: "美國的哪場戰爭結束了奴隸制？",
                  options: ["獨立戰爭", "1812 年戰爭", "內戰", "第一次世界大戰"],
                  explanation: "內戰結束了奴隸制。戰後於 1865 年批准的第 13 修正案正式廢除了美國境內的奴隸制。")
        ]),
        UnifiedQuestion(id: "q_25_098", correctAnswer: 1, variants: [
            .init(text: "When did all men get the right to vote?",
                  options: ["At the start of the country (1776)", "After the Civil War (15th Amendment, 1870)", "After World War I (1920)", "Only in 1965"],
                  explanation: "The 15th Amendment (1870), ratified after the Civil War, prohibited denying the vote based on race — extending voting rights to men of all races."),
            .init(text: "所有男性何时获得投票权？",
                  options: ["建国之初（1776 年）", "内战之后（第 15 修正案，1870 年）", "第一次世界大战之后（1920 年）", "仅 1965 年"],
                  explanation: "内战后批准的第 15 修正案（1870 年）禁止以种族为由剥夺投票权，将投票权扩展至所有种族的男性。"),
            .init(text: "所有男性何時獲得投票權？",
                  options: ["建國之初（1776 年）", "內戰之後（第 15 修正案，1870 年）", "第一次世界大戰之後（1920 年）", "僅 1965 年"],
                  explanation: "內戰後批准的第 15 修正案（1870 年）禁止以種族為由剝奪投票權，將投票權擴展至所有種族的男性。")
        ]),
        UnifiedQuestion(id: "q_25_099", correctAnswer: 1, variants: [
            .init(text: "Name one leader of the women's rights movement in the 1800s.",
                  options: ["Eleanor Roosevelt", "Susan B. Anthony", "Hillary Clinton", "Sandra Day O'Connor"],
                  explanation: "Leaders of the 1800s women's rights movement included Susan B. Anthony, Elizabeth Cady Stanton, Sojourner Truth, Harriet Tubman, and Lucretia Mott."),
            .init(text: "请说出 1800 年代妇女权利运动的一位领袖。",
                  options: ["埃莉诺·罗斯福", "苏珊·B·安东尼", "希拉里·克林顿", "桑德拉·戴·奥康纳"],
                  explanation: "1800 年代妇女权利运动的领袖包括苏珊·B·安东尼、伊丽莎白·凯迪·斯坦顿、索杰纳·特鲁斯、哈丽特·塔布曼及卢克丽霞·莫特。"),
            .init(text: "請說出 1800 年代婦女權利運動的一位領袖。",
                  options: ["埃莉諾·羅斯福", "蘇珊·B·安東尼", "希拉蕊·柯林頓", "桑德拉·戴·歐康納"],
                  explanation: "1800 年代婦女權利運動的領袖包括蘇珊·B·安東尼、伊麗莎白·凱迪·斯坦頓、索傑納·特魯斯、哈麗特·塔布曼及盧克麗霞·莫特。")
        ]),
        UnifiedQuestion(id: "q_25_117", correctAnswer: 1, variants: [
            .init(text: "Name one American Indian tribe in the United States.",
                  options: ["The Egyptians", "Cherokee (or Navajo, Sioux, Apache, Hopi)", "The Vikings", "The Mongols"],
                  explanation: "Recognized American Indian tribes include the Cherokee, Navajo, Sioux, Apache, Hopi, Blackfeet, Choctaw, Pueblo, and many others."),
            .init(text: "请说出一个美国的印地安人部族。",
                  options: ["埃及人", "切罗基（或纳瓦霍、苏、阿帕奇、霍皮）", "维京人", "蒙古人"],
                  explanation: "联邦承认的印地安人部族包括切罗基、纳瓦霍、苏、阿帕奇、霍皮、黑脚、乔克陶、普埃布洛及其他许多部族。"),
            .init(text: "請說出一個美國的印地安人部族。",
                  options: ["埃及人", "切洛基（或納瓦荷、蘇、阿帕契、賀皮）", "維京人", "蒙古人"],
                  explanation: "聯邦承認的印地安人部族包括切洛基、納瓦荷、蘇、阿帕契、賀皮、佈雷克非特、喬克陶、布耶布洛及其他許多部族。")
        ]),
        UnifiedQuestion(id: "q_25_118", correctAnswer: 1, variants: [
            .init(text: "Name one example of an American innovation.",
                  options: ["The wheel", "The airplane (or light bulb, automobile, skyscraper)", "Paper", "Pottery"],
                  explanation: "American innovations include the light bulb (Edison), the airplane (Wright Brothers), the automobile assembly line (Ford), skyscrapers, and the integrated circuit."),
            .init(text: "请举出一例美国的创新发明。",
                  options: ["车轮", "飞机（或灯泡、汽车、摩天大楼）", "纸张", "陶器"],
                  explanation: "美国的创新包括灯泡（爱迪生）、飞机（莱特兄弟）、汽车装配线（福特）、摩天大楼及集成电路。"),
            .init(text: "請舉出一例美國的創新發明。",
                  options: ["車輪", "飛機（或燈泡、汽車、摩天大樓）", "紙張", "陶器"],
                  explanation: "美國的創新包括燈泡（愛迪生）、飛機（萊特兄弟）、汽車裝配線（福特）、摩天大樓及積體電路。")
        ]),
        UnifiedQuestion(id: "q_25_120", correctAnswer: 1, variants: [
            .init(text: "Where is the Statue of Liberty?",
                  options: ["Boston Harbor", "New York Harbor (Liberty Island)", "Chesapeake Bay", "Los Angeles"],
                  explanation: "The Statue of Liberty stands on Liberty Island in New York Harbor. It was a gift from France in 1886 and a symbol of freedom for immigrants arriving by sea."),
            .init(text: "自由女神像在哪里？",
                  options: ["波士顿港", "纽约港（自由岛）", "切萨皮克湾", "洛杉矶"],
                  explanation: "自由女神像矗立在纽约港的自由岛上。这是法国于 1886 年赠送的礼物，也是海上移民抵达美国时自由的象征。"),
            .init(text: "自由女神像在哪裡？",
                  options: ["波士頓港", "紐約港（自由島）", "切薩皮克灣", "洛杉磯"],
                  explanation: "自由女神像矗立在紐約港的自由島上。這是法國於 1886 年贈送的禮物，也是海上移民抵達美國時自由的象徵。")
        ]),
        UnifiedQuestion(id: "q_25_126", correctAnswer: 1, variants: [
            .init(text: "Name three national U.S. holidays.",
                  options: ["Halloween, Valentine's Day, Earth Day", "Independence Day, Thanksgiving, and Christmas", "Mother's Day, Father's Day, Easter", "Black Friday, Cyber Monday, Tax Day"],
                  explanation: "U.S. national holidays include New Year's Day, MLK Jr. Day, Presidents Day, Memorial Day, Juneteenth, Independence Day, Labor Day, Columbus Day, Veterans Day, Thanksgiving, and Christmas."),
            .init(text: "请说出三个美国的国定假日。",
                  options: ["万圣节、情人节、地球日", "独立纪念日、感恩节及圣诞节", "母亲节、父亲节、复活节", "黑色星期五、网络星期一、报税日"],
                  explanation: "美国国定假日包括新年、马丁·路德·金日、总统日、国殇日、六月节、独立纪念日、劳动节、哥伦布日、退伍军人节、感恩节及圣诞节。"),
            .init(text: "請說出三個美國的國定假日。",
                  options: ["萬聖節、情人節、地球日", "獨立紀念日、感恩節及聖誕節", "母親節、父親節、復活節", "黑色星期五、網路星期一、報稅日"],
                  explanation: "美國國定假日包括新年、馬丁·路德·金日、總統日、國殤日、六月節、獨立紀念日、勞動節、哥倫布日、退伍軍人節、感恩節及聖誕節。")
        ]),
        UnifiedQuestion(id: "q_25_127", correctAnswer: 2, variants: [
            .init(text: "What is Memorial Day?",
                  options: ["A holiday to honor veterans still living", "A holiday to celebrate independence", "A holiday to honor soldiers who died in military service", "A holiday for state founders"],
                  explanation: "Memorial Day (last Monday in May) honors U.S. military service members who died in service to their country."),
            .init(text: "国殇日是什么？",
                  options: ["纪念在世退伍军人的节日", "庆祝独立的节日", "纪念在军中服役期间牺牲的军人的节日", "纪念建州先贤的节日"],
                  explanation: "国殇日（5 月最后一个星期一）纪念为国捐躯的美国军人。"),
            .init(text: "國殤日是什麼？",
                  options: ["紀念在世退伍軍人的節日", "慶祝獨立的節日", "紀念在軍中服役期間犧牲的軍人的節日", "紀念建州先賢的節日"],
                  explanation: "國殤日（5 月最後一個星期一）紀念為國捐軀的美國軍人。")
        ]),
        UnifiedQuestion(id: "q_25_128", correctAnswer: 1, variants: [
            .init(text: "What is Veterans Day?",
                  options: ["A holiday for active military only", "A holiday to honor people who have served in the U.S. military", "A holiday for fallen soldiers only", "A holiday for new immigrants"],
                  explanation: "Veterans Day (November 11) honors all people who have served in the U.S. military, both living and deceased."),
            .init(text: "退伍军人节是什么？",
                  options: ["仅限现役军人的节日", "纪念曾在美国军队服役者的节日", "仅纪念阵亡将士的节日", "新移民的节日"],
                  explanation: "退伍军人节（11 月 11 日）纪念所有曾在美国军队服役的人，无论健在或已故。"),
            .init(text: "退伍軍人節是什麼？",
                  options: ["僅限現役軍人的節日", "紀念曾在美國軍隊服役者的節日", "僅紀念陣亡將士的節日", "新移民的節日"],
                  explanation: "退伍軍人節（11 月 11 日）紀念所有曾在美國軍隊服役的人，無論健在或已故。")
        ])
    ]

    // MARK: - Practice 8: 1900s & Modern History (16 questions)
    static let practice8: [UnifiedQuestion] = [
        UnifiedQuestion(id: "q_25_100", correctAnswer: 1, variants: [
            .init(text: "Name one war fought by the United States in the 1900s.",
                  options: ["The Civil War", "World War II (or WWI, Korean War, Vietnam War, Persian Gulf War)", "American Revolution", "War of 1812"],
                  explanation: "U.S. wars in the 1900s include World War I, World War II, the Korean War, the Vietnam War, and the Persian Gulf War."),
            .init(text: "请说出美国在 1900 年代参与的一场战争。",
                  options: ["内战", "第二次世界大战（或一战、朝鲜战争、越南战争、波斯湾战争）", "美国革命", "1812 年战争"],
                  explanation: "美国在 1900 年代参与的战争包括第一次世界大战、第二次世界大战、朝鲜战争、越南战争及波斯湾战争。"),
            .init(text: "請說出美國在 1900 年代參與的一場戰爭。",
                  options: ["內戰", "第二次世界大戰（或一戰、朝鮮戰爭、越南戰爭、波斯灣戰爭）", "美國革命", "1812 年戰爭"],
                  explanation: "美國在 1900 年代參與的戰爭包括第一次世界大戰、第二次世界大戰、朝鮮戰爭、越南戰爭及波斯灣戰爭。")
        ]),
        UnifiedQuestion(id: "q_25_101", correctAnswer: 1, variants: [
            .init(text: "Why did the United States enter World War I?",
                  options: ["To help Germany", "Because Germany attacked U.S. civilian ships (and to support the Allies)", "To gain new territory", "To stop the spread of communism"],
                  explanation: "The U.S. entered WWI in 1917 because Germany attacked U.S. civilian ships and to support the Allied Powers (England, France, Italy, and Russia)."),
            .init(text: "美国为什么加入第一次世界大战？",
                  options: ["为支援德国", "因为德国袭击美国民用船只（并为支援协约国）", "为获取新领土", "为阻止共产主义扩张"],
                  explanation: "美国于 1917 年加入第一次世界大战，因为德国袭击了美国民用船只，并为支持协约国（英国、法国、意大利和俄国）。"),
            .init(text: "美國為什麼加入第一次世界大戰？",
                  options: ["為支援德國", "因為德國襲擊美國民用船隻（並為支援協約國）", "為獲取新領土", "為阻止共產主義擴張"],
                  explanation: "美國於 1917 年加入第一次世界大戰，因為德國襲擊了美國民用船隻，並為支持協約國（英國、法國、意大利和俄國）。")
        ]),
        UnifiedQuestion(id: "q_25_103", correctAnswer: 1, variants: [
            .init(text: "What was the Great Depression?",
                  options: ["A war fought in the 1930s", "The longest economic recession in modern history", "A famous government program", "A presidential election"],
                  explanation: "The Great Depression was the longest and deepest economic recession in modern history, with mass unemployment and bank failures throughout the 1930s."),
            .init(text: "什么是大萧条？",
                  options: ["1930 年代发生的战争", "现代历史上持续最久的经济衰退", "一项著名的政府计划", "一次总统选举"],
                  explanation: "大萧条是现代历史上持续最久、最严重的经济衰退，1930 年代期间出现大规模失业及银行倒闭。"),
            .init(text: "什麼是大蕭條？",
                  options: ["1930 年代發生的戰爭", "現代歷史上持續最久的經濟衰退", "一項著名的政府計劃", "一次總統選舉"],
                  explanation: "大蕭條是現代歷史上持續最久、最嚴重的經濟衰退，1930 年代期間出現大規模失業及銀行倒閉。")
        ]),
        UnifiedQuestion(id: "q_25_104", correctAnswer: 1, variants: [
            .init(text: "When did the Great Depression start?",
                  options: ["With World War I (1917)", "With the Great Crash of 1929 (stock market crash)", "After World War II (1945)", "1933"],
                  explanation: "The Great Depression began with the stock market crash of October 1929 (the Great Crash), and lasted until the early 1940s."),
            .init(text: "大萧条何时开始？",
                  options: ["第一次世界大战开始时（1917 年）", "1929 年大崩盘（股市崩盘）", "第二次世界大战之后（1945 年）", "1933 年"],
                  explanation: "大萧条始于 1929 年 10 月的股市崩盘（大崩盘），持续至 1940 年代初。"),
            .init(text: "大蕭條何時開始？",
                  options: ["第一次世界大戰開始時（1917 年）", "1929 年大崩盤（股市崩盤）", "第二次世界大戰之後（1945 年）", "1933 年"],
                  explanation: "大蕭條始於 1929 年 10 月的股市崩盤（大崩盤），持續至 1940 年代初。")
        ]),
        UnifiedQuestion(id: "q_25_105", correctAnswer: 1, variants: [
            .init(text: "Who was president during the Great Depression and World War II?",
                  options: ["Theodore Roosevelt", "Franklin D. Roosevelt (FDR)", "Harry Truman", "Herbert Hoover"],
                  explanation: "Franklin D. Roosevelt (FDR) served as President from 1933 until his death in 1945. He led the New Deal response to the Depression and led the U.S. through most of WWII."),
            .init(text: "大萧条和第二次世界大战期间的美国总统是谁？",
                  options: ["西奥多·罗斯福", "富兰克林·D·罗斯福（FDR）", "哈里·杜鲁门", "赫伯特·胡佛"],
                  explanation: "富兰克林·D·罗斯福（FDR）自 1933 年起担任总统直至 1945 年逝世。他领导了应对大萧条的新政，并带领美国度过二战的大部分时期。"),
            .init(text: "大蕭條和第二次世界大戰期間的美國總統是誰？",
                  options: ["西奧多·羅斯福", "富蘭克林·D·羅斯福（FDR）", "哈里·杜魯門", "赫伯特·胡佛"],
                  explanation: "富蘭克林·D·羅斯福（FDR）自 1933 年起擔任總統直至 1945 年逝世。他領導了應對大蕭條的新政，並帶領美國度過二戰的大部分時期。")
        ]),
        UnifiedQuestion(id: "q_25_106", correctAnswer: 1, variants: [
            .init(text: "Why did the United States enter World War II?",
                  options: ["To help Germany", "Because Japan bombed Pearl Harbor", "To gain new colonies", "To establish trade routes"],
                  explanation: "The U.S. entered WWII after Japan attacked Pearl Harbor on December 7, 1941. The U.S. then joined the Allied Powers against the Axis Powers."),
            .init(text: "美国为什么加入第二次世界大战？",
                  options: ["为支援德国", "因为日本轰炸了珍珠港", "为获取新殖民地", "为建立贸易航线"],
                  explanation: "美国于 1941 年 12 月 7 日日本袭击珍珠港后加入二战。此后美国加入同盟国对抗轴心国。"),
            .init(text: "美國為什麼加入第二次世界大戰？",
                  options: ["為支援德國", "因為日本轟炸了珍珠港", "為獲取新殖民地", "為建立貿易航線"],
                  explanation: "美國於 1941 年 12 月 7 日日本襲擊珍珠港後加入二戰。此後美國加入同盟國對抗軸心國。")
        ]),
        UnifiedQuestion(id: "q_25_107", correctAnswer: 1, variants: [
            .init(text: "Dwight Eisenhower is famous for many things. Name one.",
                  options: ["Founded Microsoft", "General during World War II and 34th President", "Wrote the Constitution", "Discovered penicillin"],
                  explanation: "Eisenhower was a top general in WWII (commanded D-Day), the 34th President (1953-61), president when the Korean War ended, and signed the law creating the Interstate Highway System."),
            .init(text: "德怀特·艾森豪威尔因许多事迹而著名。请说出其中之一。",
                  options: ["创立了微软", "第二次世界大战期间的将军，第 34 任总统", "撰写了宪法", "发现了青霉素"],
                  explanation: "艾森豪威尔是二战期间的顶尖将领（指挥诺曼底登陆）、第 34 任总统（1953-61 年）、朝鲜战争结束时的总统，并签署了创建州际公路系统的法律。"),
            .init(text: "德懷特·艾森豪因許多事蹟而著名。請說出其中之一。",
                  options: ["創立了微軟", "第二次世界大戰期間的將軍，第 34 任總統", "撰寫了憲法", "發現了青黴素"],
                  explanation: "艾森豪是二戰期間的頂尖將領（指揮諾曼第登陸）、第 34 任總統（1953-61 年）、朝鮮戰爭結束時的總統，並簽署了創建州際公路系統的法律。")
        ]),
        UnifiedQuestion(id: "q_25_108", correctAnswer: 2, variants: [
            .init(text: "Who was the United States' main rival during the Cold War?",
                  options: ["Germany", "China", "The Soviet Union (USSR)", "Japan"],
                  explanation: "The Soviet Union (USSR) was the main U.S. rival during the Cold War (1947-1991), a period of geopolitical tension without direct military conflict."),
            .init(text: "冷战期间美国的主要对手是谁？",
                  options: ["德国", "中国", "苏联（USSR）", "日本"],
                  explanation: "冷战期间（1947-1991 年），苏联（USSR）是美国的主要对手，那是一段没有直接军事冲突的地缘政治紧张时期。"),
            .init(text: "冷戰期間美國的主要對手是誰？",
                  options: ["德國", "中國", "蘇聯（USSR）", "日本"],
                  explanation: "冷戰期間（1947-1991 年），蘇聯（USSR）是美國的主要對手，那是一段沒有直接軍事衝突的地緣政治緊張時期。")
        ]),
        UnifiedQuestion(id: "q_25_109", correctAnswer: 1, variants: [
            .init(text: "During the Cold War, what was one main concern of the United States?",
                  options: ["Trade deficits", "Communism (and nuclear war)", "Immigration", "Energy independence"],
                  explanation: "Main U.S. concerns during the Cold War were the spread of communism and the threat of nuclear war between the superpowers."),
            .init(text: "冷战期间美国主要的顾虑之一是什么？",
                  options: ["贸易赤字", "共产主义（和核战争）", "移民", "能源独立"],
                  explanation: "冷战期间美国的主要顾虑是共产主义扩张及超级大国之间的核战争威胁。"),
            .init(text: "冷戰期間美國主要的顧慮之一是什麼？",
                  options: ["貿易赤字", "共產主義（和核戰爭）", "移民", "能源獨立"],
                  explanation: "冷戰期間美國的主要顧慮是共產主義擴張及超級大國之間的核戰爭威脅。")
        ]),
        UnifiedQuestion(id: "q_25_110", correctAnswer: 1, variants: [
            .init(text: "Why did the United States enter the Korean War?",
                  options: ["To gain Korean territory", "To stop the spread of communism", "To support the Korean monarchy", "To rescue American hostages"],
                  explanation: "The U.S. entered the Korean War (1950-53) to stop the spread of communism after North Korea (communist) invaded South Korea."),
            .init(text: "美国为什么加入朝鲜战争？",
                  options: ["为获取朝鲜领土", "为阻止共产主义扩张", "为支援朝鲜君主制", "为营救美国人质"],
                  explanation: "美国于朝鲜战争（1950-53 年）加入，因为共产主义朝鲜入侵南韩，旨在阻止共产主义扩张。"),
            .init(text: "美國為什麼加入朝鮮戰爭？",
                  options: ["為獲取朝鮮領土", "為阻止共產主義擴張", "為支援朝鮮君主制", "為營救美國人質"],
                  explanation: "美國於朝鮮戰爭（1950-53 年）加入，因為共產主義朝鮮入侵南韓，旨在阻止共產主義擴張。")
        ]),
        UnifiedQuestion(id: "q_25_111", correctAnswer: 1, variants: [
            .init(text: "Why did the United States enter the Vietnam War?",
                  options: ["To gain Vietnamese territory", "To stop the spread of communism", "To establish a U.S. naval base", "To enforce a trade agreement"],
                  explanation: "The U.S. entered the Vietnam War (1955-75) to stop the spread of communism in Southeast Asia."),
            .init(text: "美国为什么加入越南战争？",
                  options: ["为获取越南领土", "为阻止共产主义扩张", "为建立美国海军基地", "为执行贸易协议"],
                  explanation: "美国加入越南战争（1955-75 年）是为了阻止共产主义在东南亚的扩张。"),
            .init(text: "美國為什麼加入越南戰爭？",
                  options: ["為獲取越南領土", "為阻止共產主義擴張", "為建立美國海軍基地", "為執行貿易協議"],
                  explanation: "美國加入越南戰爭（1955-75 年）是為了阻止共產主義在東南亞的擴張。")
        ]),
        UnifiedQuestion(id: "q_25_112", correctAnswer: 1, variants: [
            .init(text: "What did the civil rights movement do?",
                  options: ["Won the right to vote for women", "Fought to end racial discrimination", "Brought independence from Britain", "Established Social Security"],
                  explanation: "The civil rights movement (1950s-1960s) fought to end racial discrimination and segregation. It led to the Civil Rights Act of 1964 and Voting Rights Act of 1965."),
            .init(text: "民权运动做了什么？",
                  options: ["为妇女赢得投票权", "为终结种族歧视而奋斗", "为脱离英国独立", "建立了社会保障"],
                  explanation: "民权运动（1950 至 1960 年代）为终结种族歧视及种族隔离而奋斗，促成了 1964 年《民权法案》及 1965 年《投票权法案》。"),
            .init(text: "民權運動做了什麼？",
                  options: ["為婦女贏得投票權", "為終結種族歧視而奮鬥", "為脫離英國獨立", "建立了社會保障"],
                  explanation: "民權運動（1950 至 1960 年代）為終結種族歧視及種族隔離而奮鬥，促成了 1964 年《民權法案》及 1965 年《投票權法案》。")
        ]),
        UnifiedQuestion(id: "q_25_113", correctAnswer: 1, variants: [
            .init(text: "Martin Luther King, Jr. is famous for many things. Name one.",
                  options: ["Invented the airplane", "Fought for civil rights and equality for all Americans", "First African American President", "Wrote the Declaration of Independence"],
                  explanation: "Dr. King fought for civil rights using nonviolent methods, worked for equality, and delivered the famous \"I Have a Dream\" speech. He was awarded the Nobel Peace Prize in 1964."),
            .init(text: "小马丁·路德·金因许多事迹而著名。请说出其中之一。",
                  options: ["发明了飞机", "为民权及全体美国人的平等而奋斗", "首位非裔美籍总统", "撰写了《独立宣言》"],
                  explanation: "金博士以非暴力方式为民权奋斗，致力争取平等，并发表了著名的《我有一个梦想》演说。他于 1964 年荣获诺贝尔和平奖。"),
            .init(text: "小馬丁·路德·金因許多事蹟而著名。請說出其中之一。",
                  options: ["發明了飛機", "為民權及全體美國人的平等而奮鬥", "首位非裔美籍總統", "撰寫了《獨立宣言》"],
                  explanation: "金博士以非暴力方式為民權奮鬥，致力爭取平等，並發表了著名的《我有一個夢想》演說。他於 1964 年榮獲諾貝爾和平獎。")
        ]),
        UnifiedQuestion(id: "q_25_114", correctAnswer: 1, variants: [
            .init(text: "Why did the United States enter the Persian Gulf War?",
                  options: ["To support Iraq", "To force the Iraqi military from Kuwait", "To establish a U.S. embassy", "To rescue American tourists"],
                  explanation: "The U.S. led an international coalition in the Persian Gulf War (1990-91) to force the Iraqi military out of Kuwait, which Iraq had invaded."),
            .init(text: "美国为什么加入波斯湾战争？",
                  options: ["为支援伊拉克", "为迫使伊拉克军队撤离科威特", "为设立美国大使馆", "为营救美国游客"],
                  explanation: "美国在波斯湾战争（1990-91 年）中领导国际联盟，迫使入侵科威特的伊拉克军队撤离。"),
            .init(text: "美國為什麼加入波斯灣戰爭？",
                  options: ["為支援伊拉克", "為迫使伊拉克軍隊撤離科威特", "為設立美國大使館", "為營救美國遊客"],
                  explanation: "美國在波斯灣戰爭（1990-91 年）中領導國際聯盟，迫使入侵科威特的伊拉克軍隊撤離。")
        ]),
        UnifiedQuestion(id: "q_25_115", correctAnswer: 1, variants: [
            .init(text: "What major event happened on September 11, 2001 in the United States?",
                  options: ["A presidential election", "Terrorists attacked the United States", "A natural disaster", "A peace agreement was signed"],
                  explanation: "On 9/11, terrorists hijacked four planes, crashing two into the World Trade Center, one into the Pentagon, and one in a Pennsylvania field. Nearly 3,000 people died."),
            .init(text: "2001 年 9 月 11 日在美国发生了什么重大事件？",
                  options: ["一次总统选举", "恐怖分子袭击了美国", "一次自然灾害", "签署了一项和平协议"],
                  explanation: "9·11 事件中，恐怖分子劫持四架飞机，两架撞入世贸中心、一架撞入五角大楼、另一架在宾夕法尼亚州的田野坠毁。近 3000 人罹难。"),
            .init(text: "2001 年 9 月 11 日在美國發生了什麼重大事件？",
                  options: ["一次總統選舉", "恐怖分子襲擊了美國", "一次自然災害", "簽署了一項和平協議"],
                  explanation: "9·11 事件中，恐怖分子劫持四架飛機，兩架撞入世貿中心、一架撞入五角大廈、另一架在賓夕法尼亞州的田野墜毀。近 3000 人罹難。")
        ]),
        UnifiedQuestion(id: "q_25_116", correctAnswer: 2, variants: [
            .init(text: "Name one U.S. military conflict after the September 11, 2001 attacks.",
                  options: ["The Korean War", "The Vietnam War", "The War in Afghanistan (or War in Iraq, War on Terror)", "The Civil War"],
                  explanation: "U.S. conflicts after 9/11 include the Global War on Terror, the War in Afghanistan (2001-2021), and the War in Iraq (2003-2011)."),
            .init(text: "请说出 2001 年 9·11 袭击事件之后美国参与的一场军事冲突。",
                  options: ["朝鲜战争", "越南战争", "阿富汗战争（或伊拉克战争、反恐战争）", "内战"],
                  explanation: "9·11 之后美国参与的冲突包括全球反恐战争、阿富汗战争（2001-2021 年）及伊拉克战争（2003-2011 年）。"),
            .init(text: "請說出 2001 年 9·11 襲擊事件之後美國參與的一場軍事衝突。",
                  options: ["朝鮮戰爭", "越南戰爭", "阿富汗戰爭（或伊拉克戰爭、反恐戰爭）", "內戰"],
                  explanation: "9·11 之後美國參與的衝突包括全球反恐戰爭、阿富汗戰爭（2001-2021 年）及伊拉克戰爭（2003-2011 年）。")
        ])
    ]
}
