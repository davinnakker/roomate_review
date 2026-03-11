from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from dotenv import load_dotenv
import os
load_dotenv()

# create engine
password = os.getenv("MYSQLPASSWORD")
DATABASE_URL = f"mysql+pymysql://root:{password}@db:3306/roomates"
engine = create_engine(DATABASE_URL)

# greate session class and its function
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# make Base Parent Class
Base = declarative_base()