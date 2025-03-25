"""Tests for test helper utilities."""

import base64
import json
from datetime import datetime, timedelta, timezone
from typing import Optional

from ..test_helpers import (
    MockDB,
    MockRedis,
    create_test_user,
    generate_random_string,
    generate_test_token,
    load_test_data,
    login_test_user,
)

class MockClient:
    """Mock FastAPI test client."""
    def __init__(self, response_data: dict, status_code: int = 200):
        self.response_data = response_data
        self.status_code = status_code

    def post(self, url: str, json: Optional[dict] = None) -> "MockResponse":
        """Simulate POST request."""
        return MockResponse(self.response_data, self.status_code)

class MockResponse:
    """Mock API response."""
    def __init__(self, data: dict, status_code: int = 200):
        self.data = data
        self.status_code = status_code

    def json(self) -> dict:
        """Return response data."""
        return self.data

def test_generate_random_string():
    """Test random string generation."""
    # Test default length
    str1 = generate_random_string()
    assert len(str1) == 10
    assert isinstance(str1, str)

    # Test custom length
    str2 = generate_random_string(length=20)
    assert len(str2) == 20

    # Test uniqueness
    assert str1 != str2

def test_generate_test_token():
    """Test JWT token generation."""
    # Test default token
    token = generate_test_token()
    assert isinstance(token, str)
    assert len(token.split(".")) == 3

    # Test token payload
    payload = json.loads(
        base64.b64decode(token.split(".")[1] + "==").decode("utf-8")
    )
    assert "sub" in payload
    assert "role" in payload
    assert "exp" in payload
    assert payload["sub"] == "test_user"
    assert payload["role"] == "user"

    # Test custom user and role
    token = generate_test_token(user_id="custom_user", role="admin")
    payload = json.loads(
        base64.b64decode(token.split(".")[1] + "==").decode("utf-8")
    )
    assert payload["sub"] == "custom_user"
    assert payload["role"] == "admin"

    # Test expiration
    exp_minutes = 60
    token = generate_test_token(exp_minutes=exp_minutes)
    payload = json.loads(
        base64.b64decode(token.split(".")[1] + "==").decode("utf-8")
    )
    now = int(datetime.now(timezone.utc).timestamp())
    assert payload["exp"] > now
    assert payload["exp"] <= now + (exp_minutes * 60)

def test_load_test_data():
    """Test loading test data."""
    data = load_test_data()
    assert isinstance(data, dict)
    assert "crypto_prices" in data
    assert "documents" in data
    assert "campaigns" in data
    assert "users" in data

def test_create_test_user():
    """Test user creation."""
    response_data = {
        "id": "user_001",
        "email": "test@example.com",
        "name": "Test User"
    }
    client = MockClient(response_data, status_code=201)
    result = create_test_user(client)
    assert result["id"] == "user_001"
    assert result["email"] == "test@example.com"

def test_login_test_user():
    """Test user login."""
    response_data = {
        "access_token": "test_token",
        "token_type": "bearer"
    }
    client = MockClient(response_data)
    result = login_test_user(client)
    assert result["access_token"] == "test_token"
    assert result["token_type"] == "bearer"

def test_mock_db():
    """Test mock database operations."""
    db = MockDB()
    collection = "test_collection"

    # Test insert
    doc = {"name": "test", "value": 123}
    doc_id = db.insert(collection, doc)
    assert isinstance(doc_id, str)

    # Test find_one
    found = db.find_one(collection, {"_id": doc_id})
    assert found is not None
    assert found["name"] == "test"
    assert found["value"] == 123

    # Test find
    docs = db.find(collection, {"name": "test"})
    assert len(docs) == 1
    assert docs[0]["value"] == 123

    # Test update_one
    updated = db.update_one(
        collection,
        {"_id": doc_id},
        {"$set": {"value": 456}}
    )
    assert updated is True
    found = db.find_one(collection, {"_id": doc_id})
    assert found is not None
    assert found["value"] == 456

    # Test delete_one
    deleted = db.delete_one(collection, {"_id": doc_id})
    assert deleted is True
    found = db.find_one(collection, {"_id": doc_id})
    assert found is None

def test_mock_redis():
    """Test mock Redis operations."""
    redis = MockRedis()

    # Test set/get
    redis.set("key1", "value1")
    val1: Optional[str] = redis.get("key1")
    assert val1 == "value1"

    # Test expiry
    redis.set("key2", "value2", ex=1)
    val2: Optional[str] = redis.get("key2")
    assert val2 == "value2"

    # Simulate time passing
    redis.expires["key2"] = datetime.now(timezone.utc) - timedelta(seconds=2)
    assert redis.get("key2") is None

    # Test delete
    redis.set("key3", "value3")
    assert redis.delete("key3") is True
    assert redis.get("key3") is None

    # Test non-existent key
    assert redis.get("nonexistent") is None
    assert redis.delete("nonexistent") is False
