from pydantic import BaseModel
from typing import Optional, List, Dict, Any
from datetime import datetime
from app.schemas.game import GameResponse

class StartSessionRequest(BaseModel):
    game_id: str
    child_id: str

class StartSessionResponse(BaseModel):
    session_id: str
    game: Optional[GameResponse] = None

    model_config = {"from_attributes": True}

class SubmitAnswerRequest(BaseModel):
    question_id: str
    concept_id: Optional[str] = None
    concept_name: Optional[str] = None
    answer_given: Any
    response_time_ms: Optional[int] = None

class AnswerResponse(BaseModel):
    is_correct: bool
    explanation: Optional[str] = None
    xp_earned: int
    concept_id: Optional[str] = None
    correct_answer: Optional[Any] = None

    model_config = {"from_attributes": True}

class CompleteSessionResponse(BaseModel):
    session_id: str
    score: int
    xp_earned: int
    completion_percentage: float
    total_questions: int
    correct_answers: int
    duration_seconds: int
    achievements_earned: List[Dict[str, Any]] = []

    model_config = {"from_attributes": True}
