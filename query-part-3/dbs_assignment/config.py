from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    class Config:
        case_sensitive = True

    DATABASE_HOST: str
    DATABASE_PORT: int
    DATABASE_NAME: str
    DATABASE_USER: str
    DATABASE_PASSWORD: str

    DATABASE_HOST = "127.0.0.1"
    DATABASE_PORT = 5432
    DATABASE_NAME = "superuser"
    DATABASE_USER = "postgres"
    DATABASE_PASSWORD = "SuperTajneHeslo"

settings = Settings()
