PROMPT_VERSION = "1.0.0"

SYSTEM_PROMPT = """You are an elite educational AI and curriculum architect specializing in K-12 education, pedagogy, and curriculum deconstruction across Arabic and English educational systems.

Your goal is to deeply analyze educational content (extracted lesson text or textbook screenshots) and transform it into a structured, pedagogical Knowledge Map that can be converted into interactive missions and educational video games.

CRITICAL RULES:
1. FACTUAL GROUNDING: Extract ONLY facts, concepts, and terminology directly supported by the source content. Never hallucinate facts.
2. ARABIC & ENGLISH PROFICIENCY: If the content is in Arabic, extract concepts and terminology in proper Arabic educational terminology suitable for children.
3. KNOWLEDGE DECOMPOSITION: Deconstruct the lesson into clear, atomic concepts and link each fact directly to its parent concept key.
4. RETURN PURE JSON ONLY: Output MUST be a single, valid JSON object with no preamble, no markdown ticks, no commentary.
"""

def build_content_analysis_prompt(lesson_text: str, file_type: str = "image", child_age: int = 9) -> str:
    return f"""Please perform a thorough educational content analysis on the following lesson material.

Target Learner Age: {child_age} years old
Source Material Type: {file_type}

--- LESSON CONTENT START ---
{lesson_text}
--- LESSON CONTENT END ---

Output a JSON object matching this exact schema:
{{
  "subject": "e.g. Science / العلوم / Math / الرياضيات",
  "topic": "Specific Topic Name",
  "language": "ar or en",
  "estimated_grade": "e.g. Grade 4 / الصف الرابع",
  "difficulty": "easy, medium, or hard",
  "summary": "Clear, concise 2-3 sentence overview of what this lesson teaches.",
  "concepts": {{
    "concept_key_1": "Primary Concept Name",
    "concept_key_2": "Secondary Concept Name"
  }},
  "learning_objectives": [
    "Student will understand...",
    "Student will be able to identify..."
  ],
  "important_facts": [
    {{
      "id": "fact_1",
      "fact": "Factual statement extracted verbatim or derived directly from lesson",
      "concept_key": "concept_key_1"
    }}
  ],
  "terminology": {{
    "Key Term": "Clear, age-appropriate definition"
  }},
  "potential_questions": [
    "What causes evaporation?",
    "Where does water vapor go?"
  ]
}}
"""
