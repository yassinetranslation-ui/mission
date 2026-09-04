from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy.future import select
from typing import List
import os
import uuid

from app.database import get_db
from app.schemas.game import ContentAnalysisResponse, GameResponse, GameListResponse, GameListResponseItem
from app.schemas.upload import GenerateGameRequest
from app.models.user import User
from app.models.lesson import Lesson, LessonStatus
from app.models.content_analysis import ContentAnalysis
from app.models.concept import Concept
from app.models.game import Game
from app.models.child import Child
from app.api.middleware.auth_middleware import get_current_user
from app.services.claude_service import get_claude_service
from app.utils.file_processor import extract_text_from_pdf

router = APIRouter()

@router.post("/analyze/{lesson_id}", response_model=ContentAnalysisResponse)
def analyze_content(
    lesson_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
    claude_svc = Depends(get_claude_service)
):
    """Analyze an uploaded lesson and create a structured Knowledge Map"""
    result = db.execute(select(Lesson).where(Lesson.id == lesson_id, Lesson.parent_id == current_user.id))
    lesson = result.scalars().first()
    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")

    # Get target child age if assigned
    child_age = 9
    if lesson.child_id:
        child_res = db.execute(select(Child).where(Child.id == lesson.child_id))
        child = child_res.scalars().first()
        if child:
            child_age = child.age

    # Extract content
    extracted_text = ""
    if os.path.exists(lesson.file_path):
        if lesson.file_type == "pdf":
            extracted_text = extract_text_from_pdf(lesson.file_path)
        else:
            extracted_text = f"Educational lesson image: {lesson.title}"
    else:
        extracted_text = f"Lesson topic: {lesson.title}"

    # Call AI / Claude
    analysis_data = claude_svc.analyze_content(
        text_or_image_data=extracted_text,
        file_type=lesson.file_type,
        child_age=child_age,
        lesson_title=lesson.title
    )

    # Check if analysis already exists
    existing_analysis_res = db.execute(select(ContentAnalysis).where(ContentAnalysis.lesson_id == lesson.id))
    analysis = existing_analysis_res.scalars().first()

    if not analysis:
        analysis = ContentAnalysis(
            id=str(uuid.uuid4()),
            lesson_id=lesson.id,
            subject=analysis_data.get("subject"),
            topic=analysis_data.get("topic"),
            language=analysis_data.get("language", "ar"),
            estimated_grade=str(analysis_data.get("estimated_grade", "Grade 4")),
            difficulty=analysis_data.get("difficulty", "medium"),
            summary=analysis_data.get("summary"),
            concepts=analysis_data.get("concepts", {}),
            learning_objectives=analysis_data.get("learning_objectives", []),
            important_facts=analysis_data.get("important_facts", []),
            terminology=analysis_data.get("terminology", {}),
            potential_questions=analysis_data.get("potential_questions", []),
            prompt_version="1.0.0"
        )
        db.add(analysis)
    else:
        analysis.subject = analysis_data.get("subject")
        analysis.topic = analysis_data.get("topic")
        analysis.language = analysis_data.get("language", "ar")
        analysis.estimated_grade = str(analysis_data.get("estimated_grade", "Grade 4"))
        analysis.difficulty = analysis_data.get("difficulty", "medium")
        analysis.summary = analysis_data.get("summary")
        analysis.concepts = analysis_data.get("concepts", {})
        analysis.learning_objectives = analysis_data.get("learning_objectives", [])
        analysis.important_facts = analysis_data.get("important_facts", [])
        analysis.terminology = analysis_data.get("terminology", {})
        analysis.potential_questions = analysis_data.get("potential_questions", [])

    # Store individual concept records for tracking
    concepts_dict = analysis_data.get("concepts", {})
    if isinstance(concepts_dict, dict):
        for key, name in concepts_dict.items():
            concept_record = Concept(
                id=str(uuid.uuid4()),
                analysis_id=analysis.id,
                concept_key=str(key),
                name=str(name),
                description=str(name)
            )
            db.add(concept_record)

    lesson.status = LessonStatus.ready
    db.commit()
    db.refresh(analysis)

    return analysis

@router.post("/generate/{lesson_id}", response_model=GameResponse)
def generate_game(
    lesson_id: str,
    request: GenerateGameRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
    claude_svc = Depends(get_claude_service)
):
    """Generate a playable GameSpecification from an analyzed lesson"""
    result = db.execute(select(Lesson).where(Lesson.id == lesson_id, Lesson.parent_id == current_user.id))
    lesson = result.scalars().first()
    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")

    # Fetch content analysis
    analysis_res = db.execute(select(ContentAnalysis).where(ContentAnalysis.lesson_id == lesson_id))
    analysis = analysis_res.scalars().first()
    if not analysis:
        # Trigger analysis if not performed yet
        analysis = analyze_content(lesson_id, db, current_user, claude_svc)

    analysis_dict = {
        "subject": analysis.subject,
        "topic": analysis.topic,
        "language": analysis.language,
        "summary": analysis.summary,
        "concepts": analysis.concepts,
        "learning_objectives": analysis.learning_objectives,
        "important_facts": analysis.important_facts,
    }

    # Generate game spec
    game_spec = claude_svc.generate_game(analysis_dict, options={
        "duration_minutes": request.duration_minutes,
        "difficulty": request.difficulty,
    })

    game_id = str(uuid.uuid4())
    # Assign unique game_id into spec
    game_spec["game_id"] = game_id

    new_game = Game(
        id=game_id,
        lesson_id=lesson.id,
        analysis_id=analysis.id,
        title=game_spec.get("title", lesson.title),
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

    return new_game

@router.get("/analysis/{lesson_id}", response_model=ContentAnalysisResponse)
def get_analysis(
    lesson_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Retrieve an existing content analysis for a lesson"""
    result = db.execute(select(ContentAnalysis).join(Lesson).where(ContentAnalysis.lesson_id == lesson_id, Lesson.parent_id == current_user.id))
    analysis = result.scalars().first()
    if not analysis:
        raise HTTPException(status_code=404, detail="Analysis not found for this lesson")
    return analysis

@router.get("/{game_id}", response_model=GameResponse)
def get_game(game_id: str, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    """Get a specific game specification"""
    result = db.execute(select(Game).where(Game.id == game_id))
    game = result.scalars().first()
    if not game:
        raise HTTPException(status_code=404, detail="Game not found")
    return game

@router.get("/child/{child_id}", response_model=GameListResponse)
def list_games_for_child(child_id: str, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    """List all available games for a specific child"""
    result = db.execute(select(Game).join(Lesson).where(Lesson.child_id == child_id))
    games = result.scalars().all()
    # If no child-specific games, return all parent games
    if not games:
        result = db.execute(select(Game))
        games = result.scalars().all()
    return {"games": games}
