from pydantic import BaseModel, Field
from enum import Enum
from datetime import datetime, date

# endpoint that makes a person
class CreatePerson(BaseModel):
    nameFirst: str
    nameLast: str

# endpoint that makes a review
class Term(str, Enum):
    fall = "Fall"
    winter = "Winter"
    spring = "Spring"

class CreateReview(BaseModel):
    roomate_id: int
    author_id: int
    term: Term
    year: int = Field(ge=2025, le=2035)
    rating: int = Field(ge=1, le=5)
    review: str
    date_created: datetime = Field(default_factory=datetime.utcnow())

# response model for search persons (recommendations)
class PeopleResponse(BaseModel):
    id: int
    name_first: str
    name_last: str
    full_name: str

    class Config:
        from_attributes = True
