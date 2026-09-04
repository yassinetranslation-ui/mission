from sqlalchemy.orm import Session
from sqlalchemy.future import select
from fastapi import HTTPException, status
from app.models.user import User
from app.schemas.auth import RegisterRequest, LoginRequest
from app.api.middleware.auth_middleware import hash_password, verify_password, create_access_token, create_refresh_token
from app.schemas.auth import RegisterRequest, LoginRequest, AuthResponse, UserResponse

def register(db: Session, request: RegisterRequest) -> dict:
    result = db.execute(select(User).where(User.email == request.email))
    if result.scalars().first():
        raise HTTPException(status_code=400, detail="Email already registered")
        
    new_user = User(
        email=request.email,
        password_hash=hash_password(request.password),
        name=request.name
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    
    access_token = create_access_token({"sub": new_user.id})
    refresh_token = create_refresh_token({"sub": new_user.id})
    
    return AuthResponse(
        user=UserResponse.model_validate(new_user),
        access_token=access_token,
        refresh_token=refresh_token,
        token_type="bearer"
    )

def login(db: Session, request: LoginRequest) -> dict:
    result = db.execute(select(User).where(User.email == request.email))
    user = result.scalars().first()
    
    if not user or not verify_password(request.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
        
    access_token = create_access_token({"sub": user.id})
    refresh_token = create_refresh_token({"sub": user.id})
    
    return AuthResponse(
        user=UserResponse.model_validate(user),
        access_token=access_token,
        refresh_token=refresh_token,
        token_type="bearer"
    )

def refresh(db: Session, refresh_token: str) -> dict:
    from app.config import get_settings
    from jose import jwt, JWTError
    settings = get_settings()
    try:
        payload = jwt.decode(refresh_token, settings.jwt_secret_key, algorithms=[settings.jwt_algorithm])
        user_id: str = payload.get("sub")
        if user_id is None:
            raise HTTPException(status_code=401, detail="Invalid refresh token")
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid refresh token")
        
    result = db.execute(select(User).where(User.id == user_id))
    user = result.scalars().first()
    if not user:
        raise HTTPException(status_code=401, detail="User not found")
        
    access_token = create_access_token({"sub": user.id})
    new_refresh_token = create_refresh_token({"sub": user.id})
    
    return AuthResponse(
        user=UserResponse.model_validate(user),
        access_token=access_token,
        refresh_token=new_refresh_token,
        token_type="bearer"
    )
