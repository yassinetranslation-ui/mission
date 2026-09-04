from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class UploadResponse(BaseModel):
    lesson_id: str
    status: str
    file_type: str
    title: str

    model_config = {"from_attributes": True}

class LessonResponse(BaseModel):
    id: str
    parent_id: str
    child_id: Optional[str] = None
    title: str
    file_path: str
    file_type: str
    status: str
    created_at: datetime
    updated_at: datetime

    model_config = {"from_attributes": True, "use_enum_values": True}

class GenerateGameRequest(BaseModel):
    lesson_id: str
    child_id: str
    duration_minutes: Optional[int] = 15
    difficulty: Optional[str] = "medium"
