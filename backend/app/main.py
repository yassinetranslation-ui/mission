import logging
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.v1.router import api_router
from app.database import create_tables
import app.models
from app.config import get_settings

logger = logging.getLogger("misson")

settings = get_settings()

app = FastAPI(
    title="Misson API",
    description="Backend API for the Misson AI Educational Game Generator",
    version="1.0.0",
)

# When origins are wildcarded, credentials must be disabled: browsers reject
# `Access-Control-Allow-Origin: *` combined with `Allow-Credentials: true`.
# Auth uses Bearer tokens (not cookies), so credentials are only needed when
# explicit origins are configured.
cors_origins = settings.get_cors_origins()
allow_credentials = "*" not in cors_origins

app.add_middleware(
    CORSMiddleware,
    allow_origins=cors_origins,
    allow_credentials=allow_credentials,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(api_router, prefix="/api/v1")

@app.on_event("startup")
async def on_startup():
    create_tables()

    # Guard against shipping the placeholder JWT secret to production.
    if settings.is_using_default_jwt_secret:
        message = (
            "JWT_SECRET_KEY is still set to the insecure default value. "
            "Set a strong random JWT_SECRET_KEY before serving real users."
        )
        if settings.debug:
            logger.warning(message)
        else:
            raise RuntimeError(message)

@app.get("/health")
async def health_check():
    return {"status": "ok"}

@app.get("/")
async def root():
    return {"message": "Welcome to Misson API"}
