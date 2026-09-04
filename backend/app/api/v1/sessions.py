from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy.future import select
from datetime import datetime, timezone
import uuid

from app.database import get_db
from app.schemas.session import (
    StartSessionRequest,
    StartSessionResponse,
    SubmitAnswerRequest,
    AnswerResponse,
    CompleteSessionResponse,
    SessionDetailResponse
)
from app.schemas.game import GameResponse
from app.models.user import User
from app.models.child import Child
from app.models.game import Game
from app.models.session import GameSession, SessionAnswer
from app.api.middleware.auth_middleware import get_current_user
from app.services.mastery_engine import update_concept_progress

router = APIRouter()

@router.post("/start", response_model=StartSessionResponse)
def start_session(
    request: StartSessionRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Start a new interactive game session for a child"""
    # Verify child belongs to parent
    child_res = db.execute(select(Child).where(Child.id == request.child_id, Child.parent_id == current_user.id))
    child = child_res.scalars().first()
    if not child:
        raise HTTPException(status_code=404, detail="Child profile not found")

    # Verify game exists
    game_res = db.execute(select(Game).where(Game.id == request.game_id))
    game = game_res.scalars().first()
    if not game:
        raise HTTPException(status_code=404, detail="Game not found")

    session_id = str(uuid.uuid4())
    now = datetime.now(timezone.utc)
    new_session = GameSession(
        id=session_id,
        game_id=game.id,
        child_id=child.id,
        score=0,
        xp_earned=0,
        completion_percentage=0.0,
        total_questions=0,
        correct_answers=0,
        duration_seconds=0,
        status="in_progress",
        started_at=now
    )

    db.add(new_session)
    db.commit()
    db.refresh(new_session)

    return StartSessionResponse(
        session_id=new_session.id,
        game=GameResponse.model_validate(game)
    )

@router.post("/{session_id}/answer", response_model=AnswerResponse)
def submit_answer(
    session_id: str,
    request: SubmitAnswerRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Record an answer during gameplay and update real-time concept mastery"""
    result = db.execute(select(GameSession).where(GameSession.id == session_id))
    session = result.scalars().first()
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    # Determine correctness
    is_correct = True
    if isinstance(request.answer_given, dict):
        is_correct = request.answer_given.get("is_correct", True)
    elif isinstance(request.answer_given, bool):
        is_correct = request.answer_given

    now = datetime.now(timezone.utc)
    # Save answer record
    answer_rec = SessionAnswer(
        id=str(uuid.uuid4()),
        session_id=session.id,
        question_id=request.question_id,
        concept_id=None,
        answer_given={"value": request.answer_given},
        is_correct=is_correct,
        response_time_ms=request.response_time_ms,
        created_at=now
    )
    db.add(answer_rec)

    session.total_questions += 1
    if is_correct:
        session.correct_answers += 1
        session.score += 100
        session.xp_earned += 50

    # Update Mastery Engine if concept is provided
    concept_key = request.concept_id or request.question_id
    concept_name = request.concept_name or concept_key
    update_concept_progress(
        db=db,
        child_id=session.child_id,
        concept_key=concept_key,
        concept_name=concept_name,
        is_correct=is_correct,
        response_time_ms=request.response_time_ms
    )

    db.commit()

    return AnswerResponse(
        is_correct=is_correct,
        explanation="Well done!" if is_correct else "Review this concept to master it.",
        xp_earned=50 if is_correct else 0,
        concept_id=concept_key,
        correct_answer=None
    )

@router.post("/{session_id}/complete", response_model=CompleteSessionResponse)
def complete_session(
    session_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Complete a session, finalize duration, awards, and update child profile stats"""
    result = db.execute(select(GameSession).where(GameSession.id == session_id))
    session = result.scalars().first()
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")

    now = datetime.now(timezone.utc)
    session.completed_at = now
    session.status = "completed"

    if session.started_at:
        # Handle naive or timezone-aware difference
        started = session.started_at
        if started.tzinfo is None:
            started = started.replace(tzinfo=timezone.utc)
        duration = int((now - started).total_seconds())
        session.duration_seconds = max(duration, 10)

    if session.total_questions > 0:
        session.completion_percentage = round((session.correct_answers / session.total_questions) * 100.0, 1)
    else:
        session.completion_percentage = 100.0

    # Update Child profile statistics
    child_res = db.execute(select(Child).where(Child.id == session.child_id))
    child = child_res.scalars().first()
    if child:
        child.xp_total += session.xp_earned
        child.current_streak = max(child.current_streak, 1)
        child.last_activity_date = now.date()
        # Level up every 500 XP
        child.current_level = max(1, (child.xp_total // 500) + 1)

    db.commit()
    db.refresh(session)

    return CompleteSessionResponse(
        session_id=session.id,
        score=session.score,
        xp_earned=session.xp_earned,
        completion_percentage=session.completion_percentage,
        total_questions=session.total_questions,
        correct_answers=session.correct_answers,
        duration_seconds=session.duration_seconds,
        achievements_earned=[
            {"id": "first_mission", "title": "Mission Accomplished! 🌟", "xp": 50}
        ]
    )

@router.get("/{session_id}", response_model=SessionDetailResponse)
def get_session(session_id: str, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    """Get details for a specific game session"""
    result = db.execute(select(GameSession).where(GameSession.id == session_id))
    session = result.scalars().first()
    if not session:
        raise HTTPException(status_code=404, detail="Session not found")
    return session
