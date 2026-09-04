import uuid
from datetime import datetime, timezone
from sqlalchemy import String, Text, Integer, ForeignKey, JSON, DateTime
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.database import Base

class Achievement(Base):
    __tablename__ = "achievements"

    id: Mapped[str] = mapped_column(String(50), primary_key=True, default=lambda: str(uuid.uuid4()))
    name: Mapped[str] = mapped_column(String(255), nullable=False)
    description: Mapped[str] = mapped_column(Text, nullable=False)
    icon: Mapped[str] = mapped_column(String(255), nullable=True)
    category: Mapped[str] = mapped_column(String(50), nullable=False)
    criteria: Mapped[dict] = mapped_column(JSON, nullable=False)
    xp_bonus: Mapped[int] = mapped_column(Integer, default=0)
    created_at: Mapped[datetime] = mapped_column(DateTime, default=lambda: datetime.now(timezone.utc))

class ChildAchievement(Base):
    __tablename__ = "child_achievements"

    id: Mapped[str] = mapped_column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    child_id: Mapped[str] = mapped_column(String(36), ForeignKey("children.id", ondelete="CASCADE"))
    achievement_id: Mapped[str] = mapped_column(String(50), ForeignKey("achievements.id", ondelete="CASCADE"))
    earned_at: Mapped[datetime] = mapped_column(DateTime, default=lambda: datetime.now(timezone.utc))

    child = relationship("Child")
    achievement = relationship("Achievement")
