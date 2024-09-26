import psycopg2
from fastapi import APIRouter

from dbs_assignment.config import settings

router = APIRouter()


def get_database_version():
    try:

        connection = psycopg2.connect(
            host=settings.DATABASE_HOST,
            port=settings.DATABASE_PORT,
            dbname=settings.DATABASE_NAME,
            user=settings.DATABASE_USER,
            password=settings.DATABASE_PASSWORD,
        )

        cursor = connection.cursor()

        cursor.execute("SELECT version();")

        db_version = cursor.fetchone()[0]

        cursor.close()
        connection.close()

        return db_version

    except Exception as e:
        return str(e)


@router.get("/v1/status")
async def status():

    version = get_database_version()

    return {'version': version}
