import uuid
from datetime import datetime, timezone
from sqlalchemy import String, Integer, Float, ForeignKey, DateTime
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.database import Base

class LearningProgress(Base):
    __tablename__ = "learning_progress"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    child_id: Mapped[str] = mapped_column(String(36), ForeignKey("children.id", ondelete="CASCADE"))
    concept_id: Mapped[str] = mapped_column(String(100), nullable=True)
    concept_name: Mapped[str] = mapped_column(String(255), nullable=False)
    attempts: Mapped[int] = mapped_column(Integer, default=0)
    correct_answers: Mapped[int] = mapped_column(Integer, default=0)
    accuracy: Mapped[float] = mapped_column(Float, default=0.0)
    mastery_score: Mapped[float] = mapped_column(Float, default=0.0)
    mastery_tier: Mapped[str] = mapped_column(String(50), default="needs_practice")
    last_attempt_at: Mapped[datetime] = mapped_column(DateTime, nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=lambda: datetime.now(timezone.utc))
    updated_at: Mapped[datetime] = mapped_column(DateTime, default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))

    child = relationship("Child")
