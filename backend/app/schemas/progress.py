from pydantic import BaseModel
from typing import Optional, List, Dict, Any
from datetime import datetime

class ProgressResponse(BaseModel):
    concept_id: str
    concept_name: str
    attempts: int
    correct_answers: int
    accuracy: float
    mastery_score: float
    mastery_tier: str
    last_attempt_at: Optional[datetime] = None

    model_config = {"from_attributes": True}

class WeakConceptsResponse(BaseModel):
    concepts: List[ProgressResponse]

    model_config = {"from_attributes": True}

class SubjectProgressResponse(BaseModel):
    subject: str
    mastery: float
    concept_count: int

    model_config = {"from_attributes": True}

class ChildProgressResponse(BaseModel):
    child_id: str
    child_name: str
    overall_mastery: float
    total_xp: int
    games_played: int
    concepts_learned: int
    progress_by_subject: List[SubjectProgressResponse] = []
    weak_concepts: List[ProgressResponse] = []
    strong_concepts: List[ProgressResponse] = []

    model_config = {"from_attributes": True}

class LearningReportResponse(BaseModel):
    child_id: str
    child_name: str
    lesson_title: Optional[str] = "Science Lesson"
    subject: Optional[str] = "Science"
    overall_mastery: float
    concept_breakdown: List[ProgressResponse] = []
    ai_insight: str
    recommended_actions: List[str] = []
    generated_at: datetime

    model_config = {"from_attributes": True}

class PracticeRequest(BaseModel):
    child_id: str
    concept_ids: List[str]
    duration_minutes: Optional[int] = 10
