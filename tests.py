from fastapi.testclient import TestClient
from api.endpoints import app

client = TestClient(app)

def test_create_person():
    response = client.post("/people/create_person/", json={
        "nameFirst": "John",
        "nameLast": "Doe"
    })
    assert response.status_code == 200
    assert response.json() == {"response": "John Doe successfully created!"}

def test_search_people():
    response = client.get("/people/search_people/", params={
        "query": "John",
        "k": 1
    })
    assert response.status_code == 200
    assert isinstance(response.json(), list)