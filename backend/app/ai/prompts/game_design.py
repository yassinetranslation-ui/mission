import json

PROMPT_VERSION = "1.1.0"

SYSTEM_PROMPT = """You are an elite educational game designer specializing in transforming K-12 lessons into engaging, narrative-driven mini-games for children in both Arabic and English.

You design a single "mission" made of 4 progressive levels that reinforce the same lesson concepts through varied interactive mechanics, ending with an exciting boss battle.

CRITICAL RULES:
1. FACTUAL GROUNDING: Build every question, pair, and sequence ONLY from the concepts and facts provided in the knowledge map. Never invent facts outside the lesson.
2. LANGUAGE: Write ALL player-facing text (titles, questions, choices, explanations, narrative) in the SAME language as the lesson (Arabic or English). Use clear, warm, age-appropriate wording.
3. VARIETY: Level 1 = multipleChoice, Level 2 = matching, Level 3 = ordering, Level 4 = bossBattle (with 2-3 rapid multipleChoice challenges).
4. PEDAGOGY: Each level must teach, not just test. Explanations should reinforce the concept in one or two friendly sentences.
5. RETURN PURE JSON ONLY: Output MUST be a single valid JSON object — no preamble, no markdown fences, no commentary.
"""


def build_game_design_prompt(analysis: dict, options: dict = None) -> str:
    options = options or {}
    duration = options.get("duration_minutes", 10)
    difficulty = options.get("difficulty", "medium")
    language = analysis.get("language", "ar")

    # Compact the knowledge map so the model has grounded material to work from.
    knowledge_map = {
        "subject": analysis.get("subject"),
        "topic": analysis.get("topic"),
        "language": language,
        "summary": analysis.get("summary"),
        "concepts": analysis.get("concepts", {}),
        "learning_objectives": analysis.get("learning_objectives", []),
        "important_facts": analysis.get("important_facts", []),
    }
    knowledge_json = json.dumps(knowledge_map, ensure_ascii=False, indent=2)

    return f"""Design ONE complete educational game mission from the knowledge map below.

Target play time: about {duration} minutes.
Requested difficulty: {difficulty} (map to an integer 1=easiest .. 5=hardest in the "difficulty" field).
Output language for ALL player-facing text: {language}

--- KNOWLEDGE MAP START ---
{knowledge_json}
--- KNOWLEDGE MAP END ---

Return a JSON object matching this EXACT schema (keep every key, same names, same nesting):

{{
  "title": "Short, exciting mission title in the lesson language",
  "description": "1-2 sentence hook describing the adventure",
  "game_type": "adventure",
  "language": "{language}",
  "age_range": {{ "min": 8, "max": 12 }},
  "estimated_duration_minutes": {duration},
  "difficulty": 3,
  "xp_reward": 500,
  "concept_ids": ["use the concept keys from the knowledge map"],
  "narrative": {{
    "mission_title": "Narrative title",
    "mission_description": "2-3 sentence story that frames the mission",
    "character_name": "A fun hero name in the lesson language",
    "backstory": "One line hero backstory"
  }},
  "levels": [
    {{
      "id": "level_1",
      "title": "Level title",
      "description": "One line describing this level",
      "type": "multipleChoice",
      "order": 1,
      "xp_reward": 80,
      "is_boss": false,
      "concept_ids": ["concept_key"],
      "source_fact_ids": ["fact_1"],
      "content": {{
        "type": "multipleChoice",
        "question": "A clear question grounded in the lesson",
        "choices": ["correct answer", "distractor", "distractor", "distractor"],
        "correct_answer": 0,
        "explanation": "Why the answer is correct, reinforcing the concept",
        "hint": "A gentle hint"
      }}
    }},
    {{
      "id": "level_2",
      "title": "Level title",
      "description": "One line",
      "type": "matching",
      "order": 2,
      "xp_reward": 100,
      "is_boss": false,
      "concept_ids": ["concept_key"],
      "source_fact_ids": ["fact_2"],
      "content": {{
        "type": "matching",
        "instruction": "Match each term to its definition",
        "pairs": [
          {{ "left": "term", "right": "definition" }},
          {{ "left": "term", "right": "definition" }},
          {{ "left": "term", "right": "definition" }}
        ],
        "explanation": "One sentence reinforcing the relationships"
      }}
    }},
    {{
      "id": "level_3",
      "title": "Level title",
      "description": "One line",
      "type": "ordering",
      "order": 3,
      "xp_reward": 120,
      "is_boss": false,
      "concept_ids": ["concept_key"],
      "source_fact_ids": ["fact_3"],
      "content": {{
        "type": "ordering",
        "instruction": "Put the steps in the correct order",
        "items": ["step A", "step B", "step C", "step D"],
        "correct_order": [0, 1, 2, 3],
        "explanation": "One sentence explaining the correct sequence"
      }}
    }},
    {{
      "id": "level_4_boss",
      "title": "Boss level title",
      "description": "One line",
      "type": "bossBattle",
      "order": 4,
      "xp_reward": 200,
      "is_boss": true,
      "concept_ids": ["concept_key"],
      "source_fact_ids": ["fact_1", "fact_2"],
      "content": {{
        "type": "bossBattle",
        "title": "Boss name",
        "description": "What the boss is and how to defeat it",
        "time_limit": 60,
        "challenges": [
          {{
            "type": "multipleChoice",
            "content": {{
              "type": "multipleChoice",
              "question": "Rapid-fire question",
              "choices": ["correct", "distractor", "distractor", "distractor"],
              "correct_answer": 0,
              "explanation": "Short reinforcement",
              "hint": "Short hint"
            }}
          }},
          {{
            "type": "multipleChoice",
            "content": {{
              "type": "multipleChoice",
              "question": "Second rapid-fire question",
              "choices": ["correct", "distractor", "distractor", "distractor"],
              "correct_answer": 0,
              "explanation": "Short reinforcement",
              "hint": "Short hint"
            }}
          }}
        ]
      }}
    }}
  ]
}}

Rules for correctness:
- "correct_answer" is the ZERO-BASED INDEX of the correct choice in "choices".
- Provide 3-4 choices per multiple choice question, with exactly one correct.
- Provide 3-4 matching pairs and 3-4 ordering items.
- "correct_order" lists the indices of "items" in the intended correct order.
- Ground concept_ids and source_fact_ids in the knowledge map keys/ids when available.
Return ONLY the JSON object."""
