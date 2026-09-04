import os
import sys
import uuid

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")

from app.database import SessionLocal, create_tables
from app.models.user import User
from app.models.child import Child
from app.models.lesson import Lesson
from app.models.game import Game
from app.models.session import GameSession
from app.models.progress import LearningProgress
from app.schemas.auth import RegisterRequest
from app.services import auth_service
from app.services.mastery_engine import (
    update_concept_progress,
    identify_weak_concepts,
    identify_strong_concepts,
    get_mastery_tier
)

def test_phase5_pipeline():
    print("[START] Starting Phase 5 Session Tracking & Progress Analytics Test...")
    create_tables()
    db = SessionLocal()

    # 1. Parent & Child
    user_email = f"parent_{uuid.uuid4().hex[:6]}@example.com"
    req = RegisterRequest(email=user_email, password="Password123!", name="Dr. Parent")
    auth_res = auth_service.register(db, req)
    user_id = auth_res.user.id

    child = Child(
        id=str(uuid.uuid4()),
        parent_id=user_id,
        name="Sami",
        age=9,
        preferred_language="ar",
        grade_level="4th Grade",
        preferred_subjects=["Science"],
        xp_total=100,
        current_level=1,
        current_streak=1
    )
    db.add(child)
    db.commit()
    db.refresh(child)
    print(f"[SUCCESS] 1. Initialized Child: {child.name} (XP: {child.xp_total})")

    # 2. Game
    game_id = str(uuid.uuid4())
    game = Game(
        id=game_id,
        title="دورة المياه في الطبيعة",
        game_type="adventure",
        language="ar",
        age_min=8,
        age_max=12,
        estimated_duration=10,
        difficulty="medium",
        xp_reward=200,
        specification={"levels": []},
        prompt_version="1.0.0",
        status="ready"
    )
    db.add(game)
    db.commit()

    # 3. GameSession Lifecycle
    session_id = str(uuid.uuid4())
    session = GameSession(
        id=session_id,
        game_id=game.id,
        child_id=child.id,
        score=0,
        xp_earned=0,
        completion_percentage=0.0,
        total_questions=0,
        correct_answers=0,
        duration_seconds=0,
        status="in_progress"
    )
    db.add(session)
    db.commit()
    print(f"[SUCCESS] 2. Game Session Started: Session ID = {session.id}")

    # 4. Answers & Real-Time Mastery Engine Updates
    # Answer 1: Correct on 'evaporation'
    p1 = update_concept_progress(
        db=db,
        child_id=child.id,
        concept_key="evaporation",
        concept_name="التبخر",
        is_correct=True,
        response_time_ms=3500
    )
    # Answer 2: Correct on 'evaporation' (consecutive)
    p1 = update_concept_progress(
        db=db,
        child_id=child.id,
        concept_key="evaporation",
        concept_name="التبخر",
        is_correct=True,
        response_time_ms=2800
    )
    # Answer 3: Incorrect on 'condensation'
    p2 = update_concept_progress(
        db=db,
        child_id=child.id,
        concept_key="condensation",
        concept_name="التكثف",
        is_correct=False,
        response_time_ms=1500
    )

    print(f"[SUCCESS] 3. Concept Mastery Calculated:")
    print(f"   - Concept '{p1.concept_name}': Score={p1.mastery_score}%, Tier='{p1.mastery_tier}' (Attempts: {p1.attempts})")
    print(f"   - Concept '{p2.concept_name}': Score={p2.mastery_score}%, Tier='{p2.mastery_tier}' (Attempts: {p2.attempts})")

    # 5. Complete Session & Award XP
    session.total_questions = 3
    session.correct_answers = 2
    session.score = 200
    session.xp_earned = 150
    session.duration_seconds = 120
    session.completion_percentage = 66.7
    session.status = "completed"

    child.xp_total += session.xp_earned
    child.current_streak += 1
    db.commit()
    db.refresh(child)

    print(f"[SUCCESS] 4. Session Completed:")
    print(f"   - Child New Total XP: {child.xp_total} (Gained +{session.xp_earned} XP)")
    print(f"   - Child New Streak: {child.current_streak} days")

    # 6. Verify Weak & Strong Concept Clusters
    weak = identify_weak_concepts(db, child.id)
    strong = identify_strong_concepts(db, child.id)

    print(f"[SUCCESS] 5. Mastery Clusters:")
    print(f"   - Weak Concepts (<70%): {[w.concept_name for w in weak]}")
    print(f"   - Strong Concepts (>=70%): {[s.concept_name for s in strong]}")

    weak_ids = [w.concept_id for w in weak]
    assert "condensation" in weak_ids, f"Expected condensation in weak concepts, got {weak_ids}"
    assert "evaporation" in weak_ids, f"Expected evaporation in weak concepts, got {weak_ids}"

    print(f"[DONE] Phase 5 Backend Integration Test Passed 100%!")

if __name__ == "__main__":
    test_phase5_pipeline()
