from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime

class RegisterRequest(BaseModel):
    email: EmailStr
    password: str
    name: str

class LoginRequest(BaseModel):
    email: EmailStr
    password: str

class UserResponse(BaseModel):
    id: str
    email: EmailStr
    name: str
    role: str
    preferred_language: str
    created_at: datetime
    updated_at: Optional[datetime] = None
    
    model_config = {"from_attributes": True, "use_enum_values": True}

class AuthResponse(BaseModel):
    user: UserResponse
    access_token: str
    refresh_token: str
    token_type: str = "bearer"
    
    model_config = {"from_attributes": True}

class TokenRefreshRequest(BaseModel):
    refresh_token: str
