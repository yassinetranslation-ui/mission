import uuid
from datetime import datetime, timezone
from sqlalchemy import String, Integer, Float, Boolean, JSON, ForeignKey, DateTime
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.database import Base

class GameSession(Base):
    __tablename__ = "game_sessions"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    game_id: Mapped[str] = mapped_column(String(36), ForeignKey("games.id", ondelete="CASCADE"))
    child_id: Mapped[str] = mapped_column(String(36), ForeignKey("children.id", ondelete="CASCADE"))
    score: Mapped[int] = mapped_column(Integer, default=0)
    xp_earned: Mapped[int] = mapped_column(Integer, default=0)
    completion_percentage: Mapped[float] = mapped_column(Float, default=0.0)
    total_questions: Mapped[int] = mapped_column(Integer, default=0)
    correct_answers: Mapped[int] = mapped_column(Integer, default=0)
    duration_seconds: Mapped[int] = mapped_column(Integer, default=0)
    status: Mapped[str] = mapped_column(String(50), default="in_progress")
    started_at: Mapped[datetime] = mapped_column(DateTime, default=lambda: datetime.now(timezone.utc))
    completed_at: Mapped[datetime] = mapped_column(DateTime, nullable=True)

    game = relationship("Game", back_populates="sessions")
    child = relationship("Child", back_populates="sessions")
    answers = relationship("SessionAnswer", back_populates="session", cascade="all, delete-orphan")

class SessionAnswer(Base):
    __tablename__ = "session_answers"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    session_id: Mapped[str] = mapped_column(String(36), ForeignKey("game_sessions.id", ondelete="CASCADE"))
    question_id: Mapped[str] = mapped_column(String(100), nullable=False)
    concept_id: Mapped[str] = mapped_column(String(36), ForeignKey("concepts.id", ondelete="SET NULL"), nullable=True)
    answer_given: Mapped[dict] = mapped_column(JSON, nullable=False)
    is_correct: Mapped[bool] = mapped_column(Boolean, nullable=False)
    response_time_ms: Mapped[int] = mapped_column(Integer, nullable=True)
    attempt_number: Mapped[int] = mapped_column(Integer, default=1)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=lambda: datetime.now(timezone.utc))

    session = relationship("GameSession", back_populates="answers")
    concept = relationship("Concept")
