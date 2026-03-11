from database.models import Person, Review
from api.schemas import CreatePerson, CreateReview
from sqlalchemy.orm import Session

def create_person(db: Session, person: CreatePerson):

    db_row = Person(name_first = person.nameFirst,
                    name_last = person.nameLast)
    
    db.add(db_row)
    db.commit()


def create_review(db: Session, review: CreateReview):

    db_row = Review(roomate_id = review.roomate_id,
                    author_id = review.author_id,
                    term = review.term,
                    year = review.year,
                    rating = review.rating,
                    review = review.review,
                    date_created = review.date_created)

    db.add(db_row)
    db.commit()

def search_people(db: Session, query: str, k: int):

    persons = db.query(Person).filter(Person.full_name.ilike(f"%{query}%")).limit(k).all()

    return persons