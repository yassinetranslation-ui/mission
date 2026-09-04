from app.schemas.auth import UserResponse
from app.models.user import User, UserRole
import datetime

u = User(
    id="123", email="test@test.com", password_hash="hash", name="Test",
    role=UserRole.parent, preferred_language="en", 
    created_at=datetime.datetime.now(datetime.timezone.utc)
)

try:
    ur = UserResponse.model_validate(u)
    print("UserResponse OK:", ur)
except Exception as e:
    print("UserResponse FAILED:", e)

from app.schemas.auth import AuthResponse
try:
    ar = AuthResponse(user=ur, access_token="a", refresh_token="b")
    print("AuthResponse OK")
except Exception as e:
    print("AuthResponse FAILED:", e)
