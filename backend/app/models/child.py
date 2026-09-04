import uuid
from datetime import datetime, timezone
from sqlalchemy import String, Integer, ForeignKey, JSON, DateTime
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.database import Base

class Child(Base):
    __tablename__ = "children"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    parent_id: Mapped[str] = mapped_column(String(36), ForeignKey("users.id", ondelete="CASCADE"))
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    age: Mapped[int] = mapped_column(Integer, nullable=False)
    avatar: Mapped[str] = mapped_column(String(500), nullable=True)
    preferred_language: Mapped[str] = mapped_column(String(10), default="en")
    grade_level: Mapped[str] = mapped_column(String(50), nullable=True)
    preferred_subjects: Mapped[dict] = mapped_column(JSON, nullable=True)
    xp_total: Mapped[int] = mapped_column(Integer, default=0)
    current_level: Mapped[int] = mapped_column(Integer, default=1)
    current_streak: Mapped[int] = mapped_column(Integer, default=0)
    last_activity_date: Mapped[datetime] = mapped_column(DateTime, nullable=True)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=lambda: datetime.now(timezone.utc))
    updated_at: Mapped[datetime] = mapped_column(DateTime, default=lambda: datetime.now(timezone.utc), onupdate=lambda: datetime.now(timezone.utc))

    parent = relationship("User", back_populates="children")
    lessons = relationship("Lesson", back_populates="child")
    sessions = relationship("GameSession", back_populates="child")
