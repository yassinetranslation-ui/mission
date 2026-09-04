import os
import shutil
from fastapi import UploadFile, HTTPException
from sqlalchemy.orm import Session
from app.config import get_settings
from app.models.lesson import Lesson, LessonStatus
import uuid

def save_upload(db: Session, file: UploadFile, user_id: str, child_id: str = None, title: str = None) -> dict:
    settings = get_settings()

    file_ext = os.path.splitext(file.filename or "")[1].lower()
    allowed_exts = [".pdf", ".jpg", ".jpeg", ".png", ".webp", ".doc", ".docx"]
    if file_ext not in allowed_exts:
        raise HTTPException(
            status_code=400,
            detail="Unsupported file type. Please upload a PDF or Image (JPG, PNG, WEBP)."
        )

    os.makedirs(settings.upload_dir, exist_ok=True)

    file_id = str(uuid.uuid4())
    file_path = os.path.join(settings.upload_dir, f"{file_id}{file_ext}")

    try:
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)

        file_type = "pdf" if file_ext == ".pdf" else "image"
        lesson_title = title.strip() if title and title.strip() else (file.filename or "Uploaded Lesson")

        lesson = Lesson(
            id=file_id,
            parent_id=user_id,
            child_id=child_id,
            title=lesson_title,
            file_path=file_path,
            file_type=file_type,
            status=LessonStatus.uploaded
        )

        db.add(lesson)
        db.commit()
        db.refresh(lesson)

        return {
            "lesson_id": lesson.id,
            "status": lesson.status.value,
            "file_type": lesson.file_type,
            "title": lesson.title
        }
    except Exception as e:
        if os.path.exists(file_path):
            os.remove(file_path)
        raise HTTPException(status_code=500, detail=f"Failed to process and store file: {str(e)}")
