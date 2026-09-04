from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File, Form
from sqlalchemy.orm import Session
from sqlalchemy.future import select
from typing import List, Optional
from app.database import get_db
from app.schemas.upload import UploadResponse, LessonResponse
from app.models.user import User
from app.models.lesson import Lesson
from app.api.middleware.auth_middleware import get_current_user
from app.services import upload_service

router = APIRouter()

@router.post("/", response_model=UploadResponse, status_code=status.HTTP_201_CREATED)
def upload_file(
    file: UploadFile = File(...),
    child_id: Optional[str] = Form(None),
    title: Optional[str] = Form(None),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Upload educational content (PDF/Image) to generate games"""
    return upload_service.save_upload(db, file, current_user.id, child_id, title)

@router.get("/lessons", response_model=List[LessonResponse])
def list_lessons(db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    """List all lessons uploaded by the current parent"""
    result = db.execute(select(Lesson).where(Lesson.parent_id == current_user.id))
    return result.scalars().all()

@router.get("/lessons/{lesson_id}", response_model=LessonResponse)
def get_lesson(lesson_id: str, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    """Get details for a specific uploaded lesson"""
    result = db.execute(select(Lesson).where(Lesson.id == lesson_id, Lesson.parent_id == current_user.id))
    lesson = result.scalars().first()
    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")
    return lesson
