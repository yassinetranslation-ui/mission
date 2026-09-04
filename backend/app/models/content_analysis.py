import uuid
from datetime import datetime, timezone
from sqlalchemy import String, Text, ForeignKey, DateTime, JSON, Integer, Float
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.database import Base

class ContentAnalysis(Base):
    __tablename__ = "content_analyses"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    lesson_id: Mapped[str] = mapped_column(String(36), ForeignKey("lessons.id", ondelete="CASCADE"), unique=True)
    subject: Mapped[str] = mapped_column(String(100), nullable=True)
    topic: Mapped[str] = mapped_column(String(255), nullable=True)
    language: Mapped[str] = mapped_column(String(10), default="ar")
    estimated_grade: Mapped[str] = mapped_column(String(50), nullable=True)
    difficulty: Mapped[str] = mapped_column(String(50), nullable=True)
    summary: Mapped[str] = mapped_column(Text, nullable=True)
    concepts: Mapped[dict] = mapped_column(JSON, nullable=True)
    learning_objectives: Mapped[list] = mapped_column(JSON, nullable=True)
    important_facts: Mapped[list] = mapped_column(JSON, nullable=True)
    terminology: Mapped[dict] = mapped_column(JSON, nullable=True)
    potential_questions: Mapped[list] = mapped_column(JSON, nullable=True)
    prompt_version: Mapped[str] = mapped_column(String(50), nullable=True)
    input_tokens: Mapped[int] = mapped_column(Integer, nullable=True)
    output_tokens: Mapped[int] = mapped_column(Integer, nullable=True)
    estimated_cost: Mapped[float] = mapped_column(Float, nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=lambda: datetime.now(timezone.utc))

    lesson = relationship("Lesson", back_populates="analysis")
    concepts_list = relationship("Concept", back_populates="analysis", cascade="all, delete-orphan")
    games = relationship("Game", back_populates="analysis")
