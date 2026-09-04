from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

class CreateChildRequest(BaseModel):
    name: str
    age: int
    avatar: Optional[str] = None
    preferred_language: str = "ar"
    grade_level: Optional[str] = None
    preferred_subjects: Optional[List[str]] = None

class UpdateChildRequest(BaseModel):
    name: Optional[str] = None
    age: Optional[int] = None
    avatar: Optional[str] = None
    preferred_language: Optional[str] = None
    grade_level: Optional[str] = None
    preferred_subjects: Optional[List[str]] = None

class ChildResponse(BaseModel):
    id: str
    parent_id: str
    name: str
    age: int
    avatar: Optional[str] = None
    preferred_language: str
    grade_level: Optional[str] = None
    preferred_subjects: Optional[List[str]] = None
    xp_total: int
    current_level: int
    current_streak: int
    last_activity_date: Optional[datetime] = None
    created_at: datetime
    updated_at: datetime
    
    model_config = {"from_attributes": True}

class ChildListResponse(BaseModel):
    children: List[ChildResponse]
