from app.database import SessionLocal
from app.schemas.auth import RegisterRequest
from app.services import auth_service

db = SessionLocal()
req = RegisterRequest(email="direct@example.com", password="Password123!", name="Direct")
try:
    res = auth_service.register(db, req)
    print("Success:", res)
except Exception as e:
    import traceback
    traceback.print_exc()
