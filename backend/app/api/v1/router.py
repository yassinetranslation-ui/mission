from fastapi import APIRouter
from app.api.v1 import auth, children, upload, games, sessions, progress

api_router = APIRouter()

api_router.include_router(auth.router, prefix="/auth", tags=["Auth"])
api_router.include_router(children.router, prefix="/children", tags=["Children"])
api_router.include_router(upload.router, prefix="/upload", tags=["Upload"])
api_router.include_router(games.router, prefix="/games", tags=["Games"])
api_router.include_router(sessions.router, prefix="/sessions", tags=["Sessions"])
api_router.include_router(progress.router, prefix="/progress", tags=["Progress"])
