import os
import sys
import uuid

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")

from app.database import SessionLocal, create_tables
from app.models.user import User
from app.models.child import Child
from app.models.lesson import Lesson
from app.models.content_analysis import ContentAnalysis
from app.models.game import Game
from app.services.claude_service import get_claude_service
from app.schemas.auth import RegisterRequest
from app.services import auth_service

def test_phase4_pipeline():
    print("[START] Starting Phase 4 Game Generation & Engine Integration Test...")
    create_tables()
    db = SessionLocal()

    # 1. Ensure user and child exist
    user_email = f"parent_{uuid.uuid4().hex[:6]}@example.com"
    req = RegisterRequest(email=user_email, password="Password123!", name="Dr. Parent")
    auth_res = auth_service.register(db, req)
    user_id = auth_res.user.id

    child = Child(
        id=str(uuid.uuid4()),
        parent_id=user_id,
        name="Tariq",
        age=10,
        preferred_language="ar",
        grade_level="5th Grade",
        preferred_subjects=["Science"]
    )
    db.add(child)
    db.commit()
    db.refresh(child)

    # 2. Uploaded lesson & content analysis
    lesson = Lesson(
        id=str(uuid.uuid4()),
        parent_id=user_id,
        child_id=child.id,
        title="دورة المياه في الطبيعة",
        file_path="./uploads/test_science_lesson.txt",
        file_type="image",
        status="ready"
    )
    db.add(lesson)

    analysis = ContentAnalysis(
        id=str(uuid.uuid4()),
        lesson_id=lesson.id,
        subject="Science (العلوم)",
        topic="Water Cycle (دورة الماء)",
        language="ar",
        estimated_grade="Grade 4",
        difficulty="medium",
        summary="دورة المياه في الطبيعة تشمل التبخر والتكثف والهطول والتجمع.",
        concepts={"evaporation": "التبخر", "condensation": "التكثف", "precipitation": "الهطول"},
        learning_objectives=["فهم دور الشمس", "التعرف على التكثف"],
        important_facts=[{"id": "fact_1", "fact": "الشمس تسخن الماء", "concept_key": "evaporation"}],
        terminology={"التبخر": "تحول السائل لغاز"},
        potential_questions=["ماذا يحدث للماء بالحرارة؟"],
        prompt_version="1.0.0"
    )
    db.add(analysis)
    db.commit()

    # 3. Generate Game Specification via ClaudeService
    claude_svc = get_claude_service()
    game_spec = claude_svc.generate_game(
        analysis_data={
            "subject": analysis.subject,
            "topic": analysis.topic,
            "language": analysis.language,
            "summary": analysis.summary,
            "concepts": analysis.concepts,
        },
        options={"difficulty": "medium", "duration_minutes": 12}
    )

    game_id = str(uuid.uuid4())
    game_spec["game_id"] = game_id

    # 4. Validate Game Specification structure
    assert "title" in game_spec, "Missing title in game spec"
    assert "levels" in game_spec, "Missing levels in game spec"
    assert len(game_spec["levels"]) >= 3, f"Expected >= 3 levels, got {len(game_spec['levels'])}"

    print(f"[SUCCESS] Game Generated: '{game_spec['title']}' with {len(game_spec['levels'])} levels:")
    level_types_found = set()
    for lvl in game_spec["levels"]:
        level_type = lvl.get("type")
        level_types_found.add(level_type)
        print(f"   - Level {lvl.get('order')}: [{level_type}] '{lvl.get('title')}' (XP: +{lvl.get('xp_reward')})")

    assert "multipleChoice" in level_types_found, "Missing multipleChoice level"
    assert "matching" in level_types_found, "Missing matching level"
    assert "ordering" in level_types_found, "Missing ordering level"
    assert "bossBattle" in level_types_found, "Missing bossBattle level"

    # 5. Persist Game in Database
    new_game = Game(
        id=game_id,
        lesson_id=lesson.id,
        analysis_id=analysis.id,
        title=game_spec["title"],
        description=game_spec.get("description", ""),
        game_type=game_spec.get("game_type", "adventure"),
        language=game_spec.get("language", "ar"),
        age_min=game_spec.get("age_range", {}).get("min", 8),
        age_max=game_spec.get("age_range", {}).get("max", 12),
        estimated_duration=game_spec.get("estimated_duration_minutes", 10),
        difficulty=str(game_spec.get("difficulty", "medium")),
        xp_reward=game_spec.get("xp_reward", 500),
        specification=game_spec,
        prompt_version="1.0.0",
        status="ready"
    )
    db.add(new_game)
    db.commit()
    db.refresh(new_game)

    print(f"[SUCCESS] Game Record Saved in Database: Game ID = {new_game.id}")
    print(f"[DONE] Phase 4 Backend Integration Test Passed 100%!")

if __name__ == "__main__":
    test_phase4_pipeline()
