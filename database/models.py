from sqlalchemy import Column, Integer, String, DateTime, Text, ForeignKey
from sqlalchemy.orm import column_property
from datetime import datetime
from .config import Base

class Person(Base):
    __tablename__ = "people"

    id = Column(Integer, primary_key=True, index=True)
    name_first = Column(String(50))
    name_last = Column(String(50))

    full_name = column_property(name_last + ", " + name_first)

class Review(Base):
    __tablename__ = "reviews"

    id = Column(Integer, primary_key=True, index=True)
    roomate_id = Column(Integer, ForeignKey("people.id"))
    author_id = Column(Integer, ForeignKey("people.id"))
    term = Column(String(20))
    year = Column(Integer)
    rating = Column(Integer)
    review = Column(Text)
    date_created = Column(DateTime, default=datetime.utcnow)
