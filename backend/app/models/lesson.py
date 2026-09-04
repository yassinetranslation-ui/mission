import uuid
from datetime import datetime, timezone
from sqlalchemy import String, ForeignKey, DateTime, Enum as SQLEnum
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.database import Base
import enum

class LessonStatus(str, enum.Enum):
    uploaded = "uploaded"
    analyzing = "analyzing"
    ready = "ready"
    failed = "failed"

class Lesson(Base):
    __tablename__ = "lessons"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    parent_id: Mapped[str] = mapped_column(String(36), ForeignKey("users.id", ondelete="CASCADE"))
    child_id: Mapped[str] = mapped_column(String(36), ForeignKey("children.id", ondelete="CASCADE"), nullable=True)
    title: Mapped[str] = mapped_column(String(255), nullable=False)
    file_path: Mapped[str] = mapped_column(String(500), nullable=False)
    file_type: Mapped[str] = mapped_column(String(20), nullable=False)
    status: Mapped[LessonStatus] = mapped_column(SQLEnum(LessonStatus), default=LessonStatus.uploaded)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=lambda: datetime.now(timezone.utc))
    updated_at: Mapped[datetime] = mapped_column(DateTime, default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))

    parent = relationship("User", back_populates="lessons")
    child = relationship("Child", back_populates="lessons")
    analysis = relationship("ContentAnalysis", back_populates="lesson", uselist=False)
    games = relationship("Game", back_populates="lesson")
