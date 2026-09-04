import datetime

sample_games = [
    {
        "game_id": "game_water_cycle_01",
        "title": "أنقذ كوكب واتيريا (Save Planet Wateria)",
        "description": "انطلق في مهمة بطولية لإنقاذ كوكب واتيريا واستعادة دورة المياه المتوازنة عبر حل الألغاز وهزيمة زعيم الجفاف!",
        "game_type": "adventure",
        "language": "ar",
        "age_range": {"min": 8, "max": 12},
        "estimated_duration_minutes": 12,
        "difficulty": 3,
        "xp_reward": 500,
        "concept_ids": ["evaporation", "condensation", "precipitation", "collection"],
        "narrative": {
            "mission_title": "استعادة شريان الحياة في واتيريا",
            "mission_description": "كوكب واتيريا يتعرض للجفاف بسبب انقطاع دورة المياه. عليك جمع طاقة الشمس، وتكثيف السحب، وإسقاط الأمطار لهزيمة 'زعيم الجفاف'!",
            "character_name": "الكابتن غيث",
            "backstory": "حارس المياه الأسطوري المجهز بدروع الطاقة المطرية."
        },
        "levels": [
            {
                "id": "level_1",
                "title": "المرحلة الأولى: أسرار التبخر",
                "description": "استخدم طاقة الشمس لتحويل المياه إلى بخار صاعد.",
                "type": "multipleChoice",
                "order": 1,
                "xp_reward": 80,
                "is_boss": False,
                "concept_ids": ["evaporation"],
                "source_fact_ids": ["fact_1"],
                "content": {
                    "type": "multipleChoice",
                    "question": "ما هو المحرك الأساسي الذي يزود الماء بالطاقة ليتحول إلى بخار ويصعد للأعلى؟",
                    "choices": ["حرارة أشعة الشمس", "ضوء القمر", "الرياح الباردة", "حركة الأسماك"],
                    "correct_answer": 0,
                    "explanation": "أشعة الشمس تسخن مياه البحار والمحيطات فتتحول إلى بخار ماء غير مرئي يصعد لطبقات الجو العليا.",
                    "hint": "فكر في المصدر الطبيعي الأكبر للحرارة والدفء في كوكبنا."
                }
            },
            {
                "id": "level_2",
                "title": "المرحلة الثانية: بناء السحب والتكثف",
                "description": "طابق كل مصطلح علمي بتأثيره الصحيح في السماء.",
                "type": "matching",
                "order": 2,
                "xp_reward": 100,
                "is_boss": False,
                "concept_ids": ["condensation", "evaporation"],
                "source_fact_ids": ["fact_1", "fact_2"],
                "content": {
                    "type": "matching",
                    "instruction": "صل كل مصطلح من دورة الماء بالتعريف العلمي المناسب له:",
                    "pairs": [
                        {"left": "التبخر", "right": "تحول السائل إلى بخار بفعل الحرارة"},
                        {"left": "التكثف", "right": "تحول البخار إلى قطرات ماء عند ملامسة البرودة"},
                        {"left": "السحب", "right": "تجمع ملايين قطرات الماء الدقيقة في السماء"}
                    ],
                    "explanation": "عندما يصعد البخار ويبرد في طبقات الجو يتكثف مشكلاً السحب والغيوم."
                }
            },
            {
                "id": "level_3",
                "title": "المرحلة الثالثة: مسار رحلة القطرة",
                "description": "رتب مراحل دورة الماء بالترتيب الزمني الصحيح.",
                "type": "ordering",
                "order": 3,
                "xp_reward": 120,
                "is_boss": False,
                "concept_ids": ["evaporation", "condensation", "precipitation", "collection"],
                "source_fact_ids": ["fact_1", "fact_2", "fact_3", "fact_4"],
                "content": {
                    "type": "ordering",
                    "instruction": "رتب الخطوات التالية حسب تسلسل دورة المياه في الطبيعة من البداية:",
                    "items": [
                        "تسخين مياه البحر بأشعة الشمس وتبخرها",
                        "صعود بخار الماء وتكثفه لتكوين الغيوم",
                        "سقوط الأمطار والثلوج نحو الأرض (الهطول)",
                        "جريان المياه إلى الأنهار وعودتها للبحار"
                    ],
                    "correct_order": [0, 1, 2, 3],
                    "explanation": "تبدأ الدورة بالتبخر، يليه التكثف، ثم الهطول، وأخيراً التجمع والجريان السطحي."
                }
            },
            {
                "id": "level_4_boss",
                "title": "المعركة الحاسمة: هزيمة وحش الجفاف",
                "description": "واجه وحش الجفاف بسلسلة تحديات سريعة لإنقاذ كوكب واتيريا!",
                "type": "bossBattle",
                "order": 4,
                "xp_reward": 200,
                "is_boss": True,
                "concept_ids": ["evaporation", "condensation", "precipitation", "collection"],
                "source_fact_ids": ["fact_1", "fact_2", "fact_3", "fact_4"],
                "content": {
                    "type": "bossBattle",
                    "title": "وحش الجفاف العملاق",
                    "description": "يحاول وحش الجفاف منع المطر من النزول! أجب بسرعة لإطلاق عاصفة المطر وإعادة الحياة لواتيريا.",
                    "time_limit": 60,
                    "challenges": [
                        {
                            "type": "multipleChoice",
                            "content": {
                                "type": "multipleChoice",
                                "question": "ماذا يسمى تساقط المياه من الغلاف الجوي إلى سطح الأرض بأشكاله المختلفة؟",
                                "choices": ["الهطول", "الانصهار", "التجمد", "التسامي"],
                                "correct_answer": 0,
                                "explanation": "الهطول يشمل المطر والثلج والبَرَد عندما تثقل القطرات داخل السحب.",
                                "hint": "يشمل المطر والثلج والبرد."
                            }
                        },
                        {
                            "type": "multipleChoice",
                            "content": {
                                "type": "multipleChoice",
                                "question": "أين تذهب المياه بعد هطولها وجريانها على سطح الأرض؟",
                                "choices": ["تعود للبحار والمحيطات والمياه الجوفية", "تختفي تماماً من الكون", "تتحول لصخور صلبة", "تبقى معلقة في الهواء"],
                                "correct_answer": 0,
                                "explanation": "تجري المياه المتساقطة إلى الأنهار والبحار أو ترشح إلى باطن الأرض كمياه جوفية.",
                                "hint": "إنها دورة مستمرة تعود لنقطة البداية."
                            }
                        }
                    ]
                }
            }
        ],
        "created_at": "2026-08-30T00:00:00Z"
    },
    {
        "game_id": "game_fractions_01",
        "title": "Fraction Quest: Realm of Parts",
        "description": "Explore the ancient math dungeon, unlock mystical gates by mastering numerators, denominators, and equivalent fractions!",
        "game_type": "adventure",
        "language": "en",
        "age_range": {"min": 9, "max": 13},
        "estimated_duration_minutes": 10,
        "difficulty": 3,
        "xp_reward": 450,
        "concept_ids": ["numerator", "denominator", "equivalent_fractions"],
        "narrative": {
            "mission_title": "The Vault of Equivalent Gems",
            "mission_description": "The math sorcerer has locked the vault. Solve fraction challenges to break the spell!",
            "character_name": "Alex the Number Knight",
            "backstory": "A heroic student armed with the legendary Ruler Sword."
        },
        "levels": [
            {
                "id": "level_1",
                "title": "Level 1: The Gate of Denominators",
                "description": "Understand the total parts of a whole.",
                "type": "multipleChoice",
                "order": 1,
                "xp_reward": 80,
                "is_boss": False,
                "concept_ids": ["denominator"],
                "source_fact_ids": ["fact_1"],
                "content": {
                    "type": "multipleChoice",
                    "question": "In the fraction 3/4, what does the number 4 (denominator) represent?",
                    "choices": [
                        "The total number of equal parts the whole is divided into",
                        "The number of parts we currently have",
                        "The number of whole pizzas",
                        "The sum of both numbers"
                    ],
                    "correct_answer": 0,
                    "explanation": "The denominator (bottom number) tells us the total equal parts that make up one whole.",
                    "hint": "Look at the bottom number."
                }
            },
            {
                "id": "level_2",
                "title": "Level 2: Match Equivalent Powers",
                "description": "Connect fractions that have the same value.",
                "type": "matching",
                "order": 2,
                "xp_reward": 100,
                "is_boss": False,
                "concept_ids": ["equivalent_fractions"],
                "source_fact_ids": ["fact_3"],
                "content": {
                    "type": "matching",
                    "instruction": "Match each fraction on the left to its equivalent on the right:",
                    "pairs": [
                        {"left": "1/2", "right": "2/4"},
                        {"left": "2/3", "right": "4/6"},
                        {"left": "3/4", "right": "6/8"}
                    ],
                    "explanation": "Multiplying or dividing both numerator and denominator by the same number gives an equivalent fraction."
                }
            },
            {
                "id": "level_3",
                "title": "Level 3: Order the Portals",
                "description": "Arrange fractions from smallest to largest.",
                "type": "ordering",
                "order": 3,
                "xp_reward": 120,
                "is_boss": False,
                "concept_ids": ["equivalent_fractions", "numerator"],
                "source_fact_ids": ["fact_2"],
                "content": {
                    "type": "ordering",
                    "instruction": "Order these fractions from smallest to largest value:",
                    "items": [
                        "1/8 (One eighth)",
                        "1/4 (One fourth)",
                        "1/2 (One half)",
                        "3/4 (Three fourths)"
                    ],
                    "correct_order": [0, 1, 2, 3],
                    "explanation": "When comparing fractions with the same numerator, larger denominator means smaller piece."
                }
            },
            {
                "id": "level_4_boss",
                "title": "Boss Battle: The Fraction Golem",
                "description": "Defeat the Fraction Golem before the timer runs out!",
                "type": "bossBattle",
                "order": 4,
                "xp_reward": 150,
                "is_boss": True,
                "concept_ids": ["numerator", "denominator", "equivalent_fractions"],
                "source_fact_ids": ["fact_1", "fact_2", "fact_3"],
                "content": {
                    "type": "bossBattle",
                    "title": "The Stone Fraction Golem",
                    "description": "Answer the rapid-fire questions to break the golem's armor!",
                    "time_limit": 45,
                    "challenges": [
                        {
                            "type": "multipleChoice",
                            "content": {
                                "type": "multipleChoice",
                                "question": "Which fraction is greater than 1/2?",
                                "choices": ["3/4", "1/4", "2/6", "1/8"],
                                "correct_answer": 0,
                                "explanation": "3/4 is 75%, which is greater than 1/2 (50%).",
                                "hint": "Which is more than half?"
                            }
                        }
                    ]
                }
            }
        ],
        "created_at": "2026-08-30T00:00:00Z"
    }
]
