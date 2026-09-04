from pydantic import BaseModel
from typing import Optional, List, Dict, Any
from datetime import datetime

class ContentAnalysisResponse(BaseModel):
    id: str
    lesson_id: str
    subject: Optional[str] = None
    topic: Optional[str] = None
    language: Optional[str] = None
    estimated_grade: Optional[str] = None
    difficulty: Optional[str] = None
    summary: Optional[str] = None
    concepts: Optional[Dict[str, Any]] = None
    learning_objectives: Optional[List[Any]] = None
    important_facts: Optional[List[Any]] = None
    terminology: Optional[Dict[str, Any]] = None
    potential_questions: Optional[List[Any]] = None
    created_at: datetime

    model_config = {"from_attributes": True}

class GameResponse(BaseModel):
    id: str
    lesson_id: str
    analysis_id: str
    title: str
    description: Optional[str] = None
    game_type: Optional[str] = None
    language: Optional[str] = None
    age_min: Optional[int] = None
    age_max: Optional[int] = None
    estimated_duration: Optional[int] = None
    difficulty: Optional[str] = None
    xp_reward: int
    specification: Optional[Dict[str, Any]] = None
    status: str
    created_at: datetime
    updated_at: datetime

    model_config = {"from_attributes": True}

class GameListResponseItem(BaseModel):
    id: str
    lesson_id: str
    title: str
    description: Optional[str] = None
    game_type: Optional[str] = None
    status: str
    xp_reward: int
    created_at: datetime

    model_config = {"from_attributes": True}

class GameListResponse(BaseModel):
    games: List[GameListResponseItem]

class GenerationStatusResponse(BaseModel):
    status: str
    current_step: str
    steps_completed: int
    total_steps: int
