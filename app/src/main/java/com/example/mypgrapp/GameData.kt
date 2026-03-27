package com.example.mypgrapp

data class Character(
    val name: String,
    val image: String,
    val description: Map<String, String>
)

data class Organization(
    val name: String,
    val image: String,
    val description: Map<String, String>
)

object GameData {
    val characters = listOf(
        Character("Lucia", "lucia1", mapOf("en" to "A member of the Gray Raven team, and the protagonist of the story. She is a skilled warrior who is determined to protect humanity from the Punishing Virus.", "zh" to "灰鸦小队的成员，故事的主角。她是一名熟练的战士，决心保护人类免受惩罚病毒的侵害。")),
        Character("Alpha", "alpha1", mapOf("en" to "A mysterious figure who seems to have a connection to Lucia. Her motives are unclear, but she is a powerful fighter.", "zh" to "一个似乎与露西亚有联系的神秘人物。她的动机尚不清楚，但她是一个强大的战士。")),
        Character("Liv", "liv", mapOf("en" to "A support member of the Gray Raven team. She is a kind and gentle person who is always there to help her teammates.", "zh" to "灰鸦小队的支援成员。她是一个善良温柔的人，总是在那里帮助她的队友。")),
        Character("Lee", "lee", mapOf("en" to "A member of the Gray Raven team. He is a skilled marksman and a reliable teammate.", "zh" to "灰鸦小队的成员。他是一名熟练的射手和可靠的队友。")),
        Character("Watanabe", "watanabe", mapOf("en" to "A former member of the Purifying Force. He is a powerful warrior who is now fighting alongside the Gray Raven team.", "zh" to "前净化部队成员。他是一个强大的战士，现在正与灰鸦小队并肩作战。")),
        Character("Bianca", "bianca", mapOf("en" to "A member of the Purifying Force. She is a skilled swordswoman who is dedicated to her duty.", "zh" to "净化部队的成员。她是一位技艺精湛的女剑客，忠于职守。"]))
    )

    val organizations = listOf(
        Organization("Gray Raven", "gray_raven", mapOf("en" to "A special task force created to fight the Punishing Virus. They are the last hope for humanity.", "zh" to "为对抗惩罚病毒而创建的特种部队。他们是人类最后的希望。")),
        Organization("World Government", "world_government", mapOf("en" to "The governing body of the remaining human survivors. They are responsible for coordinating the efforts to fight the Punishing Virus.", "zh" to "剩余人类幸存者的管理机构。他们负责协调对抗惩罚病毒的努力。")),
        Organization("CSU", "science", mapOf("en" to "The Consolidated Science Union, a group of scientists and engineers who are working to find a cure for the Punishing Virus.", "zh" to "统一科学联盟，一群致力于寻找惩罚病毒治疗方法的科学家和工程师。")),
        Organization("Purifying Force", "purifying_force", mapOf("en" to "A military organization that is responsible for maintaining order and security in the world. They are often at odds with the Gray Raven team.", "zh" to "负责维护世界秩序和安全的军事组织。他们经常与灰鸦小队意见相左。")),
        Organization("Ascendant", "ascendant", mapOf("en" to "A mysterious organization that seems to be behind the Punishing Virus. Their goals are unknown, but they are a major threat to humanity.", "zh" to "一个似乎是惩罚病毒幕后黑手的神秘组织。他们的目标不明，但他们是人类的主要威胁。"]))
    )
}
