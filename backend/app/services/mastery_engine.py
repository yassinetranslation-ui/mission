from datetime import datetime, timezone
from sqlalchemy.orm import Session
from sqlalchemy.future import select
from app.models.progress import LearningProgress
import uuid
from typing import List, Tuple

def get_mastery_tier(score: float) -> str:
    if score >= 85.0:
        return "mastered"
    elif score >= 70.0:
        return "good"
    elif score >= 40.0:
        return "developing"
    else:
        return "needsPractice"

def calculate_mastery_score(attempts: int, correct: int, last_correct: bool, response_time_ms: int = None) -> float:
    if attempts <= 0:
        return 0.0

    raw_accuracy = (correct / attempts) * 100.0

    # Confidence scaling (1 attempt = 60% confidence, 5+ attempts = 100% confidence)
    confidence = min(attempts / 5.0, 1.0)

    # Recency bonus/penalty: last answer carries weight
    recency_factor = 1.05 if last_correct else 0.95

    # Guessing penalty: very fast incorrect answer (< 1200ms)
    speed_penalty = 1.0
    if not last_correct and response_time_ms and response_time_ms < 1200:
        speed_penalty = 0.9

    calculated = raw_accuracy * confidence * recency_factor * speed_penalty
    return round(min(max(calculated, 0.0), 100.0), 1)

def update_concept_progress(
    db: Session,
    child_id: str,
    concept_key: str,
    concept_name: str,
    is_correct: bool,
    response_time_ms: int = None
) -> LearningProgress:
    """Update or create the learning progress record for a specific concept"""
    result = db.execute(
        select(LearningProgress).where(
            LearningProgress.child_id == child_id,
            LearningProgress.concept_id == concept_key
        )
    )
    progress = result.scalars().first()

    now = datetime.now(timezone.utc)

    if not progress:
        attempts = 1
        correct = 1 if is_correct else 0
        accuracy = (correct / attempts) * 100.0
        score = calculate_mastery_score(attempts, correct, is_correct, response_time_ms)
        tier = get_mastery_tier(score)

        progress = LearningProgress(
            id=str(uuid.uuid4()),
            child_id=child_id,
            concept_id=concept_key,
            concept_name=concept_name or concept_key,
            attempts=attempts,
            correct_answers=correct,
            accuracy=accuracy,
            mastery_score=score,
            mastery_tier=tier,
            last_attempt_at=now,
            created_at=now,
            updated_at=now
        )
        db.add(progress)
    else:
        progress.attempts += 1
        if is_correct:
            progress.correct_answers += 1
        progress.accuracy = round((progress.correct_answers / progress.attempts) * 100.0, 1)
        progress.mastery_score = calculate_mastery_score(
            progress.attempts,
            progress.correct_answers,
            is_correct,
            response_time_ms
        )
        progress.mastery_tier = get_mastery_tier(progress.mastery_score)
        progress.last_attempt_at = now
        progress.updated_at = now

    db.commit()
    db.refresh(progress)
    return progress

def identify_weak_concepts(db: Session, child_id: str) -> List[LearningProgress]:
    """Retrieve all concepts where child mastery is in need of practice or developing"""
    result = db.execute(
        select(LearningProgress).where(
            LearningProgress.child_id == child_id,
            LearningProgress.mastery_score < 70.0
        )
    )
    return result.scalars().all()

def identify_strong_concepts(db: Session, child_id: str) -> List[LearningProgress]:
    """Retrieve concepts where child has demonstrated good or mastered knowledge"""
    result = db.execute(
        select(LearningProgress).where(
            LearningProgress.child_id == child_id,
            LearningProgress.mastery_score >= 70.0
        )
    )
    return result.scalars().all()
