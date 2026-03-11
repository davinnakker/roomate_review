from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from .schemas import CreatePerson, CreateReview, PeopleResponse
from crud_functions import functions
from database.config import get_db, engine
from database import models

# create tables is not there
models.Base.metadata.create_all(bind=engine)

# initiate fastapi server
app = FastAPI()

@app.post("/people/create_person/")
def create_person(person: CreatePerson, db: Session = Depends(get_db)):
    functions.create_person(db=db, person=person)
    return {"response": f"{person.nameFirst} {person.nameLast} successfully created!"}

@app.get("/people/search_people/", response_model=list[PeopleResponse])
def search_people(query: str, k: int, db: Session = Depends(get_db)):
    persons = functions.search_people(db, query, k)
    return persons

@app.post("/reviews/create_review/")
def create_review(review: CreateReview):
    pass
