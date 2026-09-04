from fastapi import Depends
from sqlalchemy.orm import Session
from app.database import get_db
from app.config import get_settings, Settings
# get_current_user and get_claude_service will be imported from their respective modules

def get_config() -> Settings:
    return get_settings()
