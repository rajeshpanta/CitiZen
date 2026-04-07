import Foundation

/// All Chinese (English <-> Simplified <-> Traditional) quiz question sets.
/// Each question has 3 variants: [English, Simplified, Traditional].
enum ChineseQuestions {

    // MARK: - Practice 1

    static let practice1: [UnifiedQuestion] = [
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What is the supreme law of the land?", options: ["The Bill of Rights", "The Declaration", "The Constitution", "The Articles"]),
            .init(text: "美国的最高法律是什么？", options: ["《权利法案》", "《独立宣言》", "《宪法》", "《邦联条例》"]),
            .init(text: "美國的最高法律是什麼？", options: ["《權利法案》", "《獨立宣言》", "《憲法》", "《邦聯條例》"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "Who makes federal laws?", options: ["The President", "Congress", "The Supreme Court", "The Military"]),
            .init(text: "谁制定联邦法律？", options: ["总统", "国会", "最高法院", "军队"]),
            .init(text: "誰制定聯邦法律？", options: ["總統", "國會", "最高法院", "軍隊"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What are the two parts of the U.S. Congress?", options: ["The Senate & The House", "The House & The President", "The Senate & The Cabinet", "The Military & The President"]),
            .init(text: "美国国会由哪两部分组成？", options: ["参议院和众议院", "众议院和总统", "参议院和内阁", "军队和总统"]),
            .init(text: "美國國會由哪兩部分組成？", options: ["參議院和眾議院", "眾議院和總統", "參議院和內閣", "軍隊和總統"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What is the capital of the United States?", options: ["New York", "Washington D.C.", "Los Angeles", "Chicago"]),
            .init(text: "美国的首都是什么？", options: ["纽约", "华盛顿特区", "洛杉矶", "芝加哥"]),
            .init(text: "美國的首都是什麼？", options: ["紐約", "華盛頓特區", "洛杉磯", "芝加哥"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What are the two major political parties?", options: ["Democrats & Libertarian", "Federalists & Republicans", "Libertarian & Tories", "Democrats & Republicans"]),
            .init(text: "美国的两个主要政党是什么？", options: ["民主党与自由意志党", "联邦党人与共和党人", "自由意志党与保守党", "民主党与共和党"]),
            .init(text: "美國的兩個主要政黨是什麼？", options: ["民主黨與自由意志黨", "聯邦黨人與共和黨人", "自由意志黨與保守黨", "民主黨與共和黨"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What color are the stars on the American flag?", options: ["Blue", "White", "Red", "Yellow"]),
            .init(text: "美国国旗上的星星是什么颜色？", options: ["蓝色", "白色", "红色", "黄色"]),
            .init(text: "美國國旗上的星星是什麼顏色？", options: ["藍色", "白色", "紅色", "黃色"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "How many states are there in the United States?", options: ["51", "49", "52", "50"]),
            .init(text: "美国共有多少个州？", options: ["51", "49", "52", "50"]),
            .init(text: "美國共有多少個州？", options: ["51", "49", "52", "50"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What is the name of the President of the United States?", options: ["Joe Biden", "George Bush", "Barack Obama", "Donald J. Trump"]),
            .init(text: "美国总统的名字是什么？", options: ["乔·拜登", "乔治·布什", "巴拉克·奥巴马", "唐纳德·J·特朗普"]),
            .init(text: "美國總統的名字是什麼？", options: ["喬·拜登", "喬治·布什", "巴拉克·歐巴馬", "唐納德·J·特朗普"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What is the name of the Vice President of the United States?", options: ["Kamala Harris", "Mike Pence", "Nancy Pelosi", "JD Vance"]),
            .init(text: "美国副总统的名字是什么？", options: ["卡马拉·哈里斯", "迈克·彭斯", "南希·佩洛西", "JD·万斯"]),
            .init(text: "美國副總統的名字是什麼？", options: ["卡馬拉·哈里斯", "邁克·彭斯", "南希·佩洛西", "JD·萬斯"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What is one right in the First Amendment?", options: ["Freedom to travel", "Right to vote", "Freedom of speech", "Right to education"]),
            .init(text: "第一修正案中的一项权利是什么？", options: ["旅行自由", "投票权", "言论自由", "受教育权"]),
            .init(text: "第一修正案中的一項權利是什麼？", options: ["旅行自由", "投票權", "言論自由", "受教育權"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What do we celebrate on July 4th?", options: ["Memorial Day", "Independence Day", "Labor Day", "Thanksgiving"]),
            .init(text: "我们在 7 月 4 日庆祝什么？", options: ["阵亡将士纪念日", "独立日", "劳动节", "感恩节"]),
            .init(text: "我們在 7 月 4 日慶祝什麼？", options: ["陣亡將士紀念日", "獨立日", "勞動節", "感恩節"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "Who is the Commander in Chief of the military?", options: ["The President", "The Vice President", "The Senate", "The Supreme Court"]),
            .init(text: "谁是军队总司令？", options: ["总统", "副总统", "参议院", "最高法院"]),
            .init(text: "誰是軍隊總司令？", options: ["總統", "副總統", "參議院", "最高法院"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What is the name of the national anthem?", options: ["This Land is Your Land", "God Bless America", "America the Beautiful", "The Star-Spangled Banner"]),
            .init(text: "美国国歌的名字是什么？", options: ["《这片土地是你的土地》", "《上帝保佑美国》", "《美丽的美国》", "《星条旗永不落》"]),
            .init(text: "美國國歌的名字是什麼？", options: ["《這片土地是你的土地》", "《上帝保佑美國》", "《美麗的美國》", "《星條旗永不落》"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What do the 13 stripes on the U.S. flag represent?", options: ["The 13 amendments", "The number of wars", "The 13 states", "The original 13 colonies"]),
            .init(text: "美国国旗上的 13 条纹代表什么？", options: ["13 条修正案", "战争数量", "13 个州", "最初的 13 个殖民地"]),
            .init(text: "美國國旗上的 13 條紋代表什麼？", options: ["13 條修正案", "戰爭數量", "13 個州", "最初的 13 個殖民地"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What is the highest court in the United States?", options: ["The Supreme Court", "The Federal Court", "The Court of Appeals", "The Civil Court"]),
            .init(text: "美国最高的法院是什么？", options: ["最高法院", "联邦法院", "上诉法院", "民事法院"]),
            .init(text: "美國最高的法院是什麼？", options: ["最高法院", "聯邦法院", "上訴法院", "民事法院"])
        ])
    ]

    // MARK: - Practice 2

    static let practice2: [UnifiedQuestion] = [
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "Who wrote the Declaration of Independence?", options: ["George Washington", "Abraham Lincoln", "Benjamin Franklin", "Thomas Jefferson"]),
            .init(text: "谁起草了《独立宣言》？", options: ["乔治·华盛顿", "亚伯拉罕·林肯", "本杰明·富兰克林", "托马斯·杰斐逊"]),
            .init(text: "誰起草了《獨立宣言》？", options: ["喬治·華盛頓", "亞伯拉罕·林肯", "本傑明·富蘭克林", "托馬斯·傑斐遜"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "How many U.S. Senators are there?", options: ["50", "100", "435", "200"]),
            .init(text: "美国有多少参议员？", options: ["50", "100", "435", "200"]),
            .init(text: "美國有多少參議員？", options: ["50", "100", "435", "200"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "How long is a term for a U.S. Senator?", options: ["4 years", "2 years", "6 years", "8 years"]),
            .init(text: "美国参议员的任期是多久？", options: ["4年", "2年", "6年", "8年"]),
            .init(text: "美國參議員的任期是多久？", options: ["4年", "2年", "6年", "8年"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What is one responsibility of a U.S. citizen?", options: ["Vote in elections", "Own a business", "Pay for health insurance", "Travel abroad"]),
            .init(text: "美国公民的一项责任是什么？", options: ["在选举中投票", "拥有企业", "支付健康保险", "出国旅行"]),
            .init(text: "美國公民的一項責任是什麼？", options: ["在選舉中投票", "擁有企業", "支付健康保險", "出國旅行"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "Who is the Father of Our Country?", options: ["George Washington", "Thomas Jefferson", "Abraham Lincoln", "John Adams"]),
            .init(text: "谁是我们国家之父？", options: ["乔治·华盛顿", "托马斯·杰斐逊", "亚伯拉罕·林肯", "约翰·亚当斯"]),
            .init(text: "誰是我們國家之父？", options: ["喬治·華盛頓", "托馬斯·傑斐遜", "亞伯拉罕·林肯", "約翰·亞當斯"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What is one promise you make when you become a U.S. citizen?", options: ["Speak only English", "Always vote in elections", "Get a college degree", "Obey the laws of the United States"]),
            .init(text: "成为美国公民时，你做出的一个承诺是什么？", options: ["只讲英语", "始终参加选举并投票", "获得大学学位", "遵守美国法律"]),
            .init(text: "成為美國公民時，你做出的一個承諾是什麼？", options: ["只講英語", "始終參加選舉並投票", "獲得大學學位", "遵守美國法律"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What ocean is on the West Coast of the United States?", options: ["Atlantic Ocean", "Pacific Ocean", "Indian Ocean", "Arctic Ocean"]),
            .init(text: "美国西海岸濒临哪个海洋？", options: ["大西洋", "太平洋", "印度洋", "北冰洋"]),
            .init(text: "美國西海岸濱臨哪個海洋？", options: ["大西洋", "太平洋", "印度洋", "北冰洋"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What is the economic system in the United States?", options: ["Socialism", "Communism", "Capitalism", "Monarchy"]),
            .init(text: "美国的经济制度是什么？", options: ["社会主义", "共产主义", "资本主义", "君主制"]),
            .init(text: "美國的經濟制度是什麼？", options: ["社會主義", "共產主義", "資本主義", "君主制"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "How many voting members are in the House of Representatives?", options: ["200", "100", "50", "435"]),
            .init(text: "众议院有多少投票成员？", options: ["200", "100", "50", "435"]),
            .init(text: "眾議院有多少投票成員？", options: ["200", "100", "50", "435"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What is the rule of law?", options: ["Everyone must follow the law", "The President is above the law", "Judges are above the law", "Only lawmakers follow the law"]),
            .init(text: "法治是什么？", options: ["人人都必须遵守法律", "总统凌驾于法律之上", "法官凌驾于法律之上", "只有立法者遵守法律"]),
            .init(text: "法治是什麼？", options: ["人人都必須遵守法律", "總統凌駕於法律之上", "法官凌駕於法律之上", "只有立法者遵守法律"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What is freedom of religion?", options: ["You can only practice major religions", "You must follow the government religion", "You can practice any religion, or not practice a religion", "You can never change your religion"]),
            .init(text: "宗教自由是什么？", options: ["你只能信仰主要宗教", "你必须信奉政府指定的宗教", "你可以信仰任何宗教，或者不信仰任何宗教", "你永远不能改变你的宗教信仰"]),
            .init(text: "宗教自由是什麼？", options: ["你只能信仰主要宗教", "你必須信奉政府指定的宗教", "你可以信仰任何宗教，或者不信仰任何宗教", "你永遠不能改變你的宗教信仰"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What does the Constitution do?", options: ["Declares war", "Defines laws for voting", "Sets up the government", "Gives advice to the President"]),
            .init(text: "宪法有什么作用？", options: ["宣布战争", "为投票制定法律", "建立政府", "向总统提供建议"]),
            .init(text: "憲法有什麼作用？", options: ["宣布戰爭", "為投票制定法律", "建立政府", "向總統提供建議"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What stops one branch of government from becoming too powerful?", options: ["The Supreme Court", "The military", "The people", "Checks and balances"]),
            .init(text: "是什么阻止了政府某一分支变得过于强大？", options: ["最高法院", "军队", "人民", "制衡机制"]),
            .init(text: "是什麼阻止了政府某一分支變得過於強大？", options: ["最高法院", "軍隊", "人民", "制衡機制"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "Name one branch or part of the government.", options: ["Lawmakers", "Legislative branch (Congress)", "Governors", "The Police"]),
            .init(text: "说出政府的一个分支或部分。", options: ["立法者", "立法部门（国会）", "州长", "警察"]),
            .init(text: "說出政府的一個分支或部分。", options: ["立法者", "立法部門（國會）", "州長", "警察"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What is an amendment?", options: ["A change to the Constitution", "A law", "A government branch", "A tax"]),
            .init(text: "什么是修正案？", options: ["对宪法的修改", "一项法律", "一个政府分支", "一种税收"]),
            .init(text: "什麼是修正案？", options: ["對憲法的修改", "一項法律", "一個政府分支", "一種稅收"])
        ])
    ]

    // MARK: - Practice 3

    static let practice3: [UnifiedQuestion] = [
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What do we call the first ten amendments to the Constitution?", options: ["The Declaration of Independence", "The Bill of Rights", "The Articles of Confederation", "The Federalist Papers"]),
            .init(text: "我们把宪法前十条修正案称为什么？", options: ["《独立宣言》", "《权利法案》", "《邦联条例》", "《联邦党人文集》"]),
            .init(text: "我們把憲法前十條修正案稱為什麼？", options: ["《獨立宣言》", "《權利法案》", "《邦聯條例》", "《聯邦黨人文集》"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What is the capital of your state?", options: ["Depends on your state", "New York", "Los Angeles", "Chicago"]),
            .init(text: "你所在州的首府是什么？", options: ["取决于你所在的州", "纽约", "洛杉矶", "芝加哥"]),
            .init(text: "你所在州的首府是什麼？", options: ["取決於你所在的州", "紐約", "洛杉磯", "芝加哥"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "Who was the first President of the United States?", options: ["John Adams", "Thomas Jefferson", "George Washington", "Benjamin Franklin"]),
            .init(text: "谁是美国的第一任总统？", options: ["约翰·亚当斯", "托马斯·杰斐逊", "乔治·华盛顿", "本杰明·富兰克林"]),
            .init(text: "誰是美國的第一任總統？", options: ["約翰·亞當斯", "托馬斯·傑斐遜", "喬治·華盛頓", "本傑明·富蘭克林"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What did the Emancipation Proclamation do?", options: ["Ended the Civil War", "Freed the slaves", "Established a national bank", "Declared independence from Britain"]),
            .init(text: "《解放奴隶宣言》做了什么？", options: ["结束了内战", "解放了奴隶", "建立了国家银行", "宣布脱离英国独立"]),
            .init(text: "《解放奴隸宣言》做了什麼？", options: ["結束了內戰", "解放了奴隸", "建立了國家銀行", "宣布脫離英國獨立"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "Who is the Speaker of the House of Representatives now?", options: ["Nancy Pelosi", "Kevin McCarthy", "Mitch McConnell", "Mike Johnson"]),
            .init(text: "现任众议院议长是谁？", options: ["南希·佩洛西", "凯文·麦卡锡", "米奇·麦康奈尔", "迈克·约翰逊"]),
            .init(text: "現任眾議院議長是誰？", options: ["南希·佩洛西", "凱文·麥卡錫", "米奇·麥康納爾", "邁克·約翰遜"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "How many justices are on the Supreme Court?", options: ["7", "9", "11", "13"]),
            .init(text: "最高法院有多少位大法官？", options: ["7", "9", "11", "13"]),
            .init(text: "最高法院有多少位大法官？", options: ["7", "9", "11", "13"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What did Susan B. Anthony do?", options: ["Fought for women's rights", "Wrote the Constitution", "Discovered America", "Became the first female President"]),
            .init(text: "苏珊·B·安东尼做了什么？", options: ["为妇女权利而斗争", "撰写宪法", "发现了美洲", "成为第一位女性总统"]),
            .init(text: "蘇珊·B·安東尼做了什麼？", options: ["為婦女權利而鬥爭", "撰寫憲法", "發現了美洲", "成為第一位女性總統"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What movement tried to end racial discrimination?", options: ["The Civil Rights Movement", "The Women's Movement", "The American Revolution", "The Abolitionist Movement"]),
            .init(text: "哪个运动试图结束种族歧视？", options: ["民权运动", "妇女运动", "美国独立战争", "废奴运动"]),
            .init(text: "哪個運動試圖結束種族歧視？", options: ["民權運動", "婦女運動", "美國獨立戰爭", "廢奴運動"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What was one important thing that Abraham Lincoln did?", options: ["Established the U.S. Navy", "Freed the slaves", "Fought in the Revolutionary War", "Wrote the Bill of Rights"]),
            .init(text: "亚伯拉罕·林肯做的一件重要事情是什么？", options: ["建立了美国海军", "解放了奴隶", "参加了独立战争", "撰写了权利法案"]),
            .init(text: "亞伯拉罕·林肯做的一件重要事情是什麼？", options: ["建立了美國海軍", "解放了奴隸", "參加了獨立戰爭", "撰寫了權利法案"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "Why does the U.S. flag have 50 stars?", options: ["For the 50 Presidents", "For the 50 states", "For the 50 amendments", "For the 50 years of independence"]),
            .init(text: "美国国旗为什么有50颗星？", options: ["代表50位总统", "代表50个州", "代表50条修正案", "代表50年的独立"]),
            .init(text: "美國國旗為什麼有50顆星？", options: ["代表50位總統", "代表50個州", "代表50條修正案", "代表50年的獨立"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "When do we vote for President?", options: ["January", "March", "November", "December"]),
            .init(text: "我们什么时候投票选总统？", options: ["一月", "三月", "十一月", "十二月"]),
            .init(text: "我們什麼時候投票選總統？", options: ["一月", "三月", "十一月", "十二月"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What is one reason colonists came to America?", options: ["To escape taxes", "Religious freedom", "To join the military", "To find gold"]),
            .init(text: "殖民者来到美洲的一个原因是什么？", options: ["逃避税收", "宗教自由", "参军", "寻找黄金"]),
            .init(text: "殖民者來到美洲的一個原因是什麼？", options: ["逃避稅收", "宗教自由", "參軍", "尋找黃金"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "Who wrote the Federalist Papers?", options: ["Thomas Jefferson", "James Madison, Alexander Hamilton, John Jay", "George Washington", "Ben Franklin"]),
            .init(text: "谁撰写了《联邦党人文集》？", options: ["托马斯·杰斐逊", "詹姆斯·麦迪逊、亚历山大·汉密尔顿和约翰·杰伊", "乔治·华盛顿", "本杰明·富兰克林"]),
            .init(text: "誰撰寫了《聯邦黨人文集》？", options: ["托馬斯·傑斐遜", "詹姆斯·麥迪遜、亞歷山大·漢密爾頓和約翰·傑伊", "喬治·華盛頓", "本傑明·富蘭克林"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "Who was the President during World War I?", options: ["Franklin D. Roosevelt", "Woodrow Wilson", "Harry Truman", "Dwight D. Eisenhower"]),
            .init(text: "第一次世界大战期间谁是总统？", options: ["富兰克林·D·罗斯福", "伍德罗·威尔逊", "哈里·杜鲁门", "德怀特·D·艾森豪威尔"]),
            .init(text: "第一次世界大戰期間誰是總統？", options: ["富蘭克林·D·羅斯福", "伍德羅·威爾遜", "哈里·杜魯門", "德懷特·D·艾森豪威爾"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What is one U.S. territory?", options: ["Hawaii", "Puerto Rico", "Alaska", "Canada"]),
            .init(text: "美国的一个领地是什么？", options: ["夏威夷", "波多黎各", "阿拉斯加", "加拿大"]),
            .init(text: "美國的一個領地是什麼？", options: ["夏威夷", "波多黎各", "阿拉斯加", "加拿大"])
        ])
    ]

    // MARK: - Practice 4

    static let practice4: [UnifiedQuestion] = [
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What was the main purpose of the Federalist Papers?", options: ["To declare independence from Britain", "To promote the ratification of the U.S. Constitution", "To outline the Bill of Rights", "To establish a national bank"]),
            .init(text: "《联邦党人文集》的主要目的是什么？", options: ["宣布脱离英国独立", "促进美国宪法的批准", "概述《权利法案》", "建立国家银行"]),
            .init(text: "《聯邦黨人文集》的主要目的是什麼？", options: ["宣佈脫離英國獨立", "促進美國憲法的批准", "概述《權利法案》", "建立國家銀行"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "Which amendment abolished slavery?", options: ["13th Amendment", "14th Amendment", "15th Amendment", "19th Amendment"]),
            .init(text: "哪一条修正案废除了奴隶制？", options: ["第十三修正案", "第十四修正案", "第十五修正案", "第十九修正案"]),
            .init(text: "哪一條修正案廢除了奴隸制？", options: ["第十三修正案", "第十四修正案", "第十五修正案", "第十九修正案"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What landmark case established judicial review?", options: ["Marbury v. Madison", "Brown v. Board of Education", "Roe v. Wade", "McCulloch v. Maryland"]),
            .init(text: "哪一起具有里程碑意义的案件确立了司法审查权？", options: ["马伯里诉麦迪逊案", "布朗诉教育委员会案", "罗诉韦德案", "麦卡洛诉马里兰案"]),
            .init(text: "哪一起具有里程碑意義的案件確立了司法審查權？", options: ["馬伯里訴麥迪遜案", "布朗訴教育委員會案", "羅訴韋德案", "麥卡洛訴馬里蘭案"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What is the maximum number of years a President can serve?", options: ["4 years", "8 years", "10 years", "12 years"]),
            .init(text: "总统最多可以任职多少年？", options: ["4年", "8年", "10年", "12年"]),
            .init(text: "總統最多可以任職多少年？", options: ["4年", "8年", "10年", "12年"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What war was fought between the North and South in the U.S.?", options: ["Revolutionary War", "World War 1", "The Civil War", "The War of 1812"]),
            .init(text: "美国北方和南方之间爆发的是哪场战争？", options: ["美国独立战争", "第一次世界大战", "内战", "1812年战争"]),
            .init(text: "美國北方和南方之間爆發的是哪場戰爭？", options: ["美國獨立戰爭", "第一次世界大戰", "內戰", "1812年戰爭"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What was the main reason the U.S. entered World War II?", options: ["To support Britain and France", "To stop the spread of communism", "The attack on Pearl Harbor", "To defend against Germany"]),
            .init(text: "美国参战第二次世界大战的主要原因是什么？", options: ["支持英國和法國", "阻止共产主义蔓延", "珍珠港袭击", "抵御德国"]),
            .init(text: "美國參戰第二次世界大戰的主要原因是什麼？", options: ["支持英國和法國", "阻止共產主義蔓延", "珍珠港襲擊", "抵禦德國"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What did the Monroe Doctrine declare?", options: ["Europe should not interfere in the Americas", "Slavery is abolished", "The U.S. must remain neutral in global conflicts", "The Louisiana Purchase is legal"]),
            .init(text: "门罗主义宣称了什么？", options: ["欧洲不应干涉美洲事务", "奴隶制被废除", "美国必须在全球冲突中保持中立", "路易斯安那购地合法"]),
            .init(text: "門羅主義宣稱了什麼？", options: ["歐洲不應干涉美洲事務", "奴隸制被廢除", "美國必須在全球衝突中保持中立", "路易斯安那購地合法"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "Which U.S. President served more than two terms?", options: ["George Washington", "Theodore Roosevelt", "Franklin D. Roosevelt", "Dwight D. Eisenhower"]),
            .init(text: "哪位美国总统任期超过两届？", options: ["乔治·华盛顿", "西奥多·罗斯福", "富兰克林·D·罗斯福", "德怀特·D·艾森豪威尔"]),
            .init(text: "哪位美國總統任期超過兩屆？", options: ["喬治·華盛頓", "西奧多·羅斯福", "富蘭克林·D·羅斯福", "德懷特·D·艾森豪威爾"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What is the term length for a Supreme Court Justice?", options: ["4 years", "8 years", "12 years", "Life"]),
            .init(text: "最高法院大法官的任期是多久？", options: ["4年", "8年", "12年", "终身"]),
            .init(text: "最高法院大法官的任期是多久？", options: ["4年", "8年", "12年", "終身"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "Who was the Chief Justice of the Supreme Court in 2023?", options: ["John G. Roberts", "Clarence Thomas", "Sonia Sotomayor", "Amy Coney Barrett"]),
            .init(text: "2023年的最高法院首席大法官是谁？", options: ["约翰·G·罗伯茨", "克拉伦斯·托马斯", "索尼娅·索托马约尔", "艾米·科尼·巴雷特"]),
            .init(text: "2023年的最高法院首席大法官是誰？", options: ["約翰·G·羅伯茨", "克拉倫斯·托馬斯", "索尼婭·索托馬約爾", "艾米·科尼·巴雷特"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "Which branch of government has the power to declare war?", options: ["The President", "The Supreme Court", "Congress", "The Vice President"]),
            .init(text: "哪一部门有权宣战？", options: ["总统", "最高法院", "国会", "副总统"]),
            .init(text: "哪一部門有權宣戰？", options: ["總統", "最高法院", "國會", "副總統"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "What was the purpose of the Marshall Plan?", options: ["To rebuild Europe after World War 2", "To prevent communism in the U.S.", "To provide U.S. military aid", "To negotiate peace with Japan"]),
            .init(text: "马歇尔计划的目的是什么？", options: ["二战后重建欧洲", "防止共产主义在美国蔓延", "提供美国军事援助", "与日本谈判和平"]),
            .init(text: "馬歇爾計劃的目的是什麼？", options: ["二戰後重建歐洲", "防止共產主義在美國蔓延", "提供美國軍事援助", "與日本談判和平"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "Which constitutional amendment granted women the right to vote?", options: ["15th Amendment", "19th Amendment", "21st Amendment", "26th Amendment"]),
            .init(text: "哪一条宪法修正案赋予妇女投票权？", options: ["第十五修正案", "第十九修正案", "第二十一修正案", "第二十六修正案"]),
            .init(text: "哪一條憲法修正案賦予婦女投票權？", options: ["第十五修正案", "第十九修正案", "第二十一修正案", "第二十六修正案"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "Which U.S. state was an independent republic before joining the Union?", options: ["Hawaii", "California", "Texas", "Alaska"]),
            .init(text: "哪个美国州在加入联邦前是独立共和国？", options: ["夏威夷", "加利福尼亚", "德克萨斯", "阿拉斯加"]),
            .init(text: "哪個美國州在加入聯邦前是獨立共和國？", options: ["夏威夷", "加利福尼亞", "德克薩斯", "阿拉斯加"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "Who was President during the Great Depression and World War II?", options: ["Woodrow Wilson", "Herbert Hoover", "Franklin D. Roosevelt", "Harry Truman"]),
            .init(text: "大萧条和第二次世界大战期间谁是总统？", options: ["伍德罗·威尔逊", "赫伯特·胡佛", "富兰克林·D·罗斯福", "哈里·杜鲁门"]),
            .init(text: "大蕭條和第二次世界大戰期間誰是總統？", options: ["伍德羅·威爾遜", "赫伯特·胡佛", "富蘭克林·D·羅斯福", "哈里·杜魯門"])
        ])
    ]

    // MARK: - Practice 5

    static let practice5: [UnifiedQuestion] = [
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "The House of Representatives has how many voting members?", options: ["100", "435", "50", "200"]),
            .init(text: "众议院有多少名有投票权的成员？", options: ["100", "435", "50", "200"]),
            .init(text: "眾議院有多少名有投票權的成員？", options: ["100", "435", "50", "200"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "If both the President and the Vice President can no longer serve, who becomes President?", options: ["The Speaker of the House", "The Chief Justice", "The Secretary of State", "The Senate Majority Leader"]),
            .init(text: "如果总统和副总统都无法履职，谁将成为总统？", options: ["众议院议长", "首席大法官", "国务卿", "参议院多数党领袖"]),
            .init(text: "如果總統和副總統都無法履職，誰將成為總統？", options: ["眾議院議長", "首席大法官", "國務卿", "參議院多數黨領袖"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "Under the Constitution, some powers belong to the federal government. What is one power of the federal government?", options: ["To issue driver's licenses", "To create an army", "To set up schools", "To regulate marriages"]),
            .init(text: "根据宪法，某些权力属于联邦政府。联邦政府的一个权力是什么？", options: ["颁发驾驶执照", "组建军队", "建立学校", "管理婚姻"]),
            .init(text: "根據憲法，某些權力屬於聯邦政府。聯邦政府的一項權力是什麼？", options: ["頒發駕駛執照", "組建軍隊", "建立學校", "管理婚姻"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "Under our Constitution, some powers belong to the states. What is one power of the states?", options: ["To make treaties", "To create an army", "To print money", "Establish and run public schools"]),
            .init(text: "根据我们的宪法，某些权力属于各州。各州的一个权力是什么？", options: ["缔结条约", "组建军队", "印制货币", "建立和管理公立学校"]),
            .init(text: "根據我們的憲法，某些權力屬於各州。各州的一項權力是什麼？", options: ["締結條約", "組建軍隊", "印製貨幣", "建立和管理公立學校"])
        ]),
        UnifiedQuestion(correctAnswer: 0, variants: [
            .init(text: "Who is the Commander in Chief of the military?", options: ["The President", "The Vice President", "The Secretary of Defense", "The Speaker of the House"]),
            .init(text: "谁是军队的最高统帅？", options: ["总统", "副总统", "国防部长", "众议院议长"]),
            .init(text: "誰是軍隊的最高統帥？", options: ["總統", "副總統", "國防部長", "眾議院議長"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What are two rights in the Declaration of Independence?", options: ["Right to bear arms and right to vote", "Right to work and right to protest", "Life and Liberty", "Freedom of speech and freedom of religion"]),
            .init(text: "《独立宣言》中提到的两项权利是什么？", options: ["持有武器权和投票权", "工作权和抗议权", "生命与自由", "言论自由和宗教自由"]),
            .init(text: "《獨立宣言》中提到的兩項權利是什麼？", options: ["持有武器權和投票權", "工作權和抗議權", "生命與自由", "言論自由和宗教自由"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What is the 'rule of law'?", options: ["The government can ignore laws", "No one is above the law", "Only federal judges follow the law", "The Constitution is not legally binding"]),
            .init(text: "什么是\u{201C}法治\u{201D}？", options: ["政府可以无视法律", "没有人可以凌驾于法律之上", "只有联邦法官遵守法律", "宪法不具法律约束力"]),
            .init(text: "什麼是\u{300C}法治\u{300D}？", options: ["政府可以無視法律", "沒有人可以凌駕於法律之上", "只有聯邦法官遵守法律", "憲法不具法律約束力"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What does the judicial branch do?", options: ["Makes laws", "Interprets the law", "Elects the President", "Controls the military"]),
            .init(text: "司法部门做什么？", options: ["制定法律", "解释法律", "选举总统", "控制军队"]),
            .init(text: "司法部門做什麼？", options: ["制定法律", "解釋法律", "選舉總統", "控制軍隊"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "There are four amendments to the Constitution about who can vote. Describe one of them.", options: ["Only landowners can vote", "Only white men can vote", "Citizens 18 and older can vote", "Voting is mandatory"]),
            .init(text: "宪法中有四项修正案涉及谁可以投票。请描述其中一项。", options: ["只有土地所有者可以投票", "只有白人男性可以投票", "18岁及以上公民可以投票", "投票是强制性的"]),
            .init(text: "憲法中有四項修正案涉及誰可以投票。請描述其中一項。", options: ["只有土地所有者可以投票", "只有白人男性可以投票", "18歲及以上公民可以投票", "投票是強制性的"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "Why do some states have more Representatives than other states?", options: ["Because they are bigger", "Because they have more people", "Because they were part of the original 13 colonies", "Because they have more senators"]),
            .init(text: "为什么有些州比其他州拥有更多众议员？", options: ["因为面积更大", "因为人口更多", "因为它们是最初13个殖民地的一部分", "因为它们拥有更多参议员"]),
            .init(text: "為什麼有些州比其他州擁有更多眾議員？", options: ["因為面積更大", "因為人口更多", "因為它們是最初13個殖民地的一部分", "因為它們擁有更多參議員"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What was the main concern of the United States during the Cold War?", options: ["Nuclear disarmament", "Terrorism", "The spread of communism", "World War 3"]),
            .init(text: "冷战期间美国的主要关切是什么？", options: ["核裁军", "恐怖主义", "共产主义的扩散", "第三次世界大战"]),
            .init(text: "冷戰期間美國的主要關切是什麼？", options: ["核裁軍", "恐怖主義", "共產主義的擴散", "第三次世界大戰"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What major event happened on September 11, 2001, in the United States?", options: ["The U.S. declared war on Iraq", "Terrorists attacked the United States", "The Great Recession began", "Hurricane Katrina struck"]),
            .init(text: "2001年9月11日，美国发生了什么重大事件？", options: ["美國對伊拉克宣戰", "恐怖分子袭击美国", "大萧条开始", "卡特里娜飓风袭击"]),
            .init(text: "2001年9月11日，美國發生了什麼重大事件？", options: ["美國對伊拉克宣戰", "恐怖分子襲擊美國", "大蕭條開始", "卡特里娜颶風襲擊"])
        ]),
        UnifiedQuestion(correctAnswer: 1, variants: [
            .init(text: "What are two rights of everyone living in the United States?", options: ["Right to vote & right to work", "Freedom of speech & freedom of religion", "Right to own land & right to healthcare", "Right to drive & right to a free education"]),
            .init(text: "居住在美国的每个人有哪些两项权利？", options: ["投票权和工作权", "言论自由和宗教自由", "土地所有权和医疗保健权", "驾车权和免费教育权"]),
            .init(text: "居住在美國的每個人有哪些兩項權利？", options: ["投票權和工作權", "言論自由和宗教自由", "土地所有權和醫療保健權", "駕車權和免費教育權"])
        ]),
        UnifiedQuestion(correctAnswer: 3, variants: [
            .init(text: "What did the Civil Rights Movement do?", options: ["Fought for women's rights", "Fought for workers' rights", "Fought for U.S. independence", "Fought for the end of segregation and racial discrimination"]),
            .init(text: "民权运动做了什么？", options: ["为女性权利而斗争", "为工人权利而斗争", "为美国独立而斗争", "为结束种族隔离和歧视而斗争"]),
            .init(text: "民權運動做了什麼？", options: ["為女性權利而鬥爭", "為工人權利而鬥爭", "為美國獨立而鬥爭", "為結束種族隔離和歧視而鬥爭"])
        ]),
        UnifiedQuestion(correctAnswer: 2, variants: [
            .init(text: "What is one promise you make when you become a U.S. citizen?", options: ["To always vote", "To support your birth country", "To obey U.S. laws", "To join the U.S. military"]),
            .init(text: "成为美国公民时你会做出的一个承诺是什么？", options: ["始终投票", "支持你的出生国", "遵守美国法律", "加入美军"]),
            .init(text: "成為美國公民時你會做出的一個承諾是什麼？", options: ["始終投票", "支持你的出生國", "遵守美國法律", "加入美軍"])
        ])
    ]
}
