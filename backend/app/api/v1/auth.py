from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.schemas.auth import RegisterRequest, LoginRequest, AuthResponse, TokenRefreshRequest, UserResponse
from app.services import auth_service
from app.api.middleware.auth_middleware import get_current_user
from app.models.user import User

router = APIRouter()

@router.post("/register", status_code=status.HTTP_201_CREATED)
def register(request: RegisterRequest, db: Session = Depends(get_db)):
    """Register a new user (parent/teacher)"""
    return auth_service.register(db, request).model_dump()

@router.post("/login", response_model=AuthResponse)
def login(request: LoginRequest, db: Session = Depends(get_db)):
    """Login and get tokens"""
    return auth_service.login(db, request)

@router.post("/refresh", response_model=AuthResponse)
def refresh(request: TokenRefreshRequest, db: Session = Depends(get_db)):
    """Refresh access token"""
    return auth_service.refresh(db, request.refresh_token)

@router.get("/me", response_model=UserResponse)
def get_me(current_user: User = Depends(get_current_user)):
    """Get current user details"""
    return current_user
