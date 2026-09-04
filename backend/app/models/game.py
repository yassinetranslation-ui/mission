import uuid
from typing import Optional
from datetime import datetime, timezone
from sqlalchemy import String, Text, ForeignKey, DateTime, JSON, Integer, Float
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.database import Base

class Game(Base):
    __tablename__ = "games"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    lesson_id: Mapped[Optional[str]] = mapped_column(String(36), ForeignKey("lessons.id", ondelete="CASCADE"), nullable=True)
    analysis_id: Mapped[Optional[str]] = mapped_column(String(36), ForeignKey("content_analyses.id", ondelete="CASCADE"), nullable=True)
    title: Mapped[str] = mapped_column(String(255), nullable=False)
    description: Mapped[Optional[str]] = mapped_column(Text, nullable=True)
    game_type: Mapped[Optional[str]] = mapped_column(String(50), nullable=True)
    language: Mapped[str] = mapped_column(String(10), default="ar")
    age_min: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    age_max: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    estimated_duration: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    difficulty: Mapped[Optional[str]] = mapped_column(String(50), nullable=True)
    xp_reward: Mapped[int] = mapped_column(Integer, default=0)
    specification: Mapped[Optional[dict]] = mapped_column(JSON, nullable=True)
    prompt_version: Mapped[Optional[str]] = mapped_column(String(50), nullable=True)
    status: Mapped[str] = mapped_column(String(50), default="generating")
    input_tokens: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    output_tokens: Mapped[Optional[int]] = mapped_column(Integer, nullable=True)
    estimated_cost: Mapped[Optional[float]] = mapped_column(Float, nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=lambda: datetime.now(timezone.utc))
    updated_at: Mapped[datetime] = mapped_column(DateTime, default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))

    lesson = relationship("Lesson", back_populates="games")
    analysis = relationship("ContentAnalysis", back_populates="games")
    sessions = relationship("GameSession", back_populates="game")
