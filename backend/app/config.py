from pydantic_settings import BaseSettings, SettingsConfigDict
from pydantic import model_validator
from typing import Optional

class Settings(BaseSettings):
    server_host: str = "0.0.0.0"
    server_port: int = 8000
    debug: bool = True

    # Standard database URL (fallback)
    database_url: str = "sqlite:///./misson.db"

    # Support for cPanel / Laravel style DB variables
    db_connection: Optional[str] = None
    db_host: Optional[str] = None
    db_port: Optional[int] = None
    db_database: Optional[str] = None
    db_username: Optional[str] = None
    db_password: Optional[str] = None

    jwt_secret_key: str = "change-this-to-a-secure-random-string"
    jwt_algorithm: str = "HS256"
    access_token_expire_minutes: int = 30
    refresh_token_expire_days: int = 7

    claude_api_key: str = ""
    claude_model: str = "claude-sonnet-4-20250514"
    claude_max_tokens: int = 4096

    max_upload_size_mb: int = 20
    upload_dir: str = "./uploads"

    demo_mode: bool = True

    rate_limit_per_minute: int = 30
    generation_limit_free: int = 3

    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    @model_validator(mode="after")
    def assemble_database_url(self):
        if self.db_connection and self.db_database:
            driver = "mysql+pymysql" if self.db_connection == "mysql" else self.db_connection
            user_pass = ""
            if self.db_username:
                user_pass = f"{self.db_username}"
                if self.db_password:
                    user_pass += f":{self.db_password}"
                user_pass += "@"
            
            host_port = f"{self.db_host or '127.0.0.1'}"
            if self.db_port:
                host_port += f":{self.db_port}"
                
            self.database_url = f"{driver}://{user_pass}{host_port}/{self.db_database}"
        return self

def get_settings() -> Settings:
    return Settings()
