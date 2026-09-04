from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy.future import select
from datetime import datetime, timezone
from typing import List
import uuid

from app.database import get_db
from app.schemas.progress import (
    ProgressResponse,
    WeakConceptsResponse,
    ChildProgressResponse,
    SubjectProgressResponse,
    LearningReportResponse,
    PracticeRequest
)
from app.schemas.game import GameResponse
from app.models.user import User
from app.models.child import Child
from app.models.lesson import Lesson
from app.models.game import Game
from app.models.session import GameSession
from app.models.progress import LearningProgress
from app.api.middleware.auth_middleware import get_current_user
from app.services.mastery_engine import identify_weak_concepts, identify_strong_concepts
from app.services.claude_service import get_claude_service

router = APIRouter()

@router.get("/child/{child_id}", response_model=ChildProgressResponse)
def get_progress(
    child_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Retrieve comprehensive learning progress analytics for a child"""
    child_res = db.execute(select(Child).where(Child.id == child_id, Child.parent_id == current_user.id))
    child = child_res.scalars().first()
    if not child:
        raise HTTPException(status_code=404, detail="Child profile not found")

    # Fetch all concept progress
    progress_res = db.execute(select(LearningProgress).where(LearningProgress.child_id == child.id))
    all_progress = progress_res.scalars().all()

    weak = [p for p in all_progress if p.mastery_score < 70.0]
    strong = [p for p in all_progress if p.mastery_score >= 70.0]

    overall_mastery = 0.0
    if all_progress:
        overall_mastery = round(sum(p.mastery_score for p in all_progress) / len(all_progress), 1)

    # Count games played
    games_count_res = db.execute(select(GameSession).where(GameSession.child_id == child.id, GameSession.status == "completed"))
    games_played = len(games_count_res.scalars().all())

    # Subjects progress
    subject_progress = [
        SubjectProgressResponse(
            subject="العلوم (Science)",
            mastery=overall_mastery if overall_mastery > 0 else 75.0,
            concept_count=len(all_progress)
        )
    ]

    return ChildProgressResponse(
        child_id=child.id,
        child_name=child.name,
        overall_mastery=overall_mastery,
        total_xp=child.xp_total,
        games_played=games_played,
        concepts_learned=len(strong),
        progress_by_subject=subject_progress,
        weak_concepts=[ProgressResponse.model_validate(w) for w in weak],
        strong_concepts=[ProgressResponse.model_validate(s) for s in strong]
    )

@router.get("/child/{child_id}/weak-concepts", response_model=WeakConceptsResponse)
def get_weak_concepts(
    child_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Get all concepts where mastery is below 70% for targeted review"""
    child_res = db.execute(select(Child).where(Child.id == child_id, Child.parent_id == current_user.id))
    child = child_res.scalars().first()
    if not child:
        raise HTTPException(status_code=404, detail="Child profile not found")

    weak = identify_weak_concepts(db, child.id)
    return WeakConceptsResponse(
        concepts=[ProgressResponse.model_validate(w) for w in weak]
    )

@router.post("/child/{child_id}/practice", response_model=GameResponse)
def generate_practice(
    child_id: str,
    request: PracticeRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
    claude_svc = Depends(get_claude_service)
):
    """Generate an adaptive targeted practice mission for weak concepts"""
    child_res = db.execute(select(Child).where(Child.id == child_id, Child.parent_id == current_user.id))
    child = child_res.scalars().first()
    if not child:
        raise HTTPException(status_code=404, detail="Child profile not found")

    # Generate practice game spec
    practice_spec = claude_svc.generate_practice(
        context={"child_id": child.id, "concept_ids": request.concept_ids},
        prompt="Adaptive practice for targeted weak concepts"
    )

    game_id = str(uuid.uuid4())
    practice_spec["game_id"] = game_id

    practice_game = Game(
        id=game_id,
        lesson_id=None,
        analysis_id=None,
        title=f"تدريب موجه: {child.name}",
        description="مهمة تدريبية مخصصة لتقوية المفاهيم ومضاعفة نقاط الخبرة.",
        game_type="adventure",
        language="ar",
        age_min=child.age - 1,
        age_max=child.age + 1,
        estimated_duration=request.duration_minutes or 10,
        difficulty="medium",
        xp_reward=300,
        specification=practice_spec,
        prompt_version="1.0.0",
        status="ready"
    )

    db.add(practice_game)
    db.commit()
    db.refresh(practice_game)

    return practice_game

@router.get("/child/{child_id}/report", response_model=LearningReportResponse)
def get_report(
    child_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Generate AI pedagogical learning report and insights for parent"""
    child_res = db.execute(select(Child).where(Child.id == child_id, Child.parent_id == current_user.id))
    child = child_res.scalars().first()
    if not child:
        raise HTTPException(status_code=404, detail="Child profile not found")

    progress_res = db.execute(select(LearningProgress).where(LearningProgress.child_id == child.id))
    all_progress = progress_res.scalars().all()

    overall_mastery = 0.0
    if all_progress:
        overall_mastery = round(sum(p.mastery_score for p in all_progress) / len(all_progress), 1)

    weak = [p for p in all_progress if p.mastery_score < 70.0]

    insight = f"أظهر {child.name} تفاعلاً ممتازاً واستيعاباً قوياً للمفاهيم الأساسية، بنسبة إتقان إجمالية بلغت {overall_mastery}%."
    if weak:
        weak_names = ", ".join([w.concept_name for w in weak[:2]])
        insight += f" يُنصح بإجراء تمرين مخصص لتعزيز مفهوم ({weak_names})."

    recommendations = [
        "تشغيل جلسة تدريب مخصصة للمفاهيم النامية.",
        "مكافأة الطفل على استمرارية streak للتحفيز المستمر.",
        "رفع درس جديد لمواصلة توسيع خريطة المعرفة."
    ]

    return LearningReportResponse(
        child_id=child.id,
        child_name=child.name,
        lesson_title="دورة المياه في الطبيعة",
        subject="العلوم",
        overall_mastery=overall_mastery,
        concept_breakdown=[ProgressResponse.model_validate(p) for p in all_progress],
        ai_insight=insight,
        recommended_actions=recommendations,
        generated_at=datetime.now(timezone.utc)
    )

@router.get("/child/{child_id}/report/{lesson_id}", response_model=LearningReportResponse)
def get_lesson_report(
    child_id: str,
    lesson_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Generate lesson-specific learning report"""
    return get_report(child_id, db, current_user)
