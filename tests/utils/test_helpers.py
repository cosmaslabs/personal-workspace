"""Common test utilities and helper functions."""

import json
import os
import random
import string
from datetime import datetime, timedelta, timezone
from typing import Any, Dict, List, Optional

import jwt

# Constants
TEST_USER_EMAIL = "test@example.com"
TEST_USER_PASSWORD = "testpass123"
JWT_SECRET = "test_secret"
JWT_ALGORITHM = "HS256"


def generate_random_string(length: int = 10) -> str:
    """Generate a random string of given length."""
    return ''.join(random.choices(string.ascii_letters + string.digits, k=length))


def generate_test_token(
        user_id: str = "test_user",
        role: str = "user",
        exp_minutes: int = 30
) -> str:
    """Generate a test JWT token."""
    now = datetime.now(timezone.utc)
    exp_time = now + timedelta(minutes=exp_minutes)
    payload = {
        "sub": user_id,
        "role": role,
        "exp": int(exp_time.timestamp())
    }
    return jwt.encode(payload, JWT_SECRET, algorithm=JWT_ALGORITHM)


def load_test_data() -> Dict[str, Any]:
    """Load test data from JSON file."""
    test_data_path = os.path.join(
        os.path.dirname(__file__),
        "test_data",
        "test_samples.json"
    )
    with open(test_data_path) as f:
        return json.load(f)


def create_test_user(
        client: Any,
        email: Optional[str] = None,
        password: Optional[str] = None
) -> Dict[str, Any]:
    """Create a test user and return the response data."""
    user_data = {
        "email": email or TEST_USER_EMAIL,
        "password": password or TEST_USER_PASSWORD,
        "name": "Test User"
    }
    response = client.post("/api/v1/users", json=user_data)
    assert response.status_code == 201
    return response.json()


def login_test_user(
        client: Any,
        email: Optional[str] = None,
        password: Optional[str] = None
) -> Dict[str, Any]:
    """Log in a test user and return the response data."""
    login_data = {
        "email": email or TEST_USER_EMAIL,
        "password": password or TEST_USER_PASSWORD
    }
    response = client.post("/api/v1/auth/login", json=login_data)
    assert response.status_code == 200
    return response.json()


class MockDB:
    """Mock database for testing."""

    def __init__(self):
        self.data: Dict[str, List[Dict[str, Any]]] = {}

    def insert(self, collection: str, document: Dict[str, Any]) -> str:
        """Insert a document into a collection."""
        if collection not in self.data:
            self.data[collection] = []
        doc_id = generate_random_string()
        document["_id"] = doc_id
        self.data[collection].append(document)
        return doc_id

    def find_one(
            self,
            collection: str,
            query: Dict[str, Any]
    ) -> Optional[Dict[str, Any]]:
        """Find a single document in a collection."""
        if collection not in self.data:
            return None
        for doc in self.data[collection]:
            if all(doc.get(k) == v for k, v in query.items()):
                return doc
        return None

    def find(
            self,
            collection: str,
            query: Dict[str, Any]
    ) -> List[Dict[str, Any]]:
        """Find all documents in a collection matching the query."""
        if collection not in self.data:
            return []
        return [
            doc for doc in self.data[collection]
            if all(doc.get(k) == v for k, v in query.items())
        ]

    def update_one(
            self,
            collection: str,
            query: Dict[str, Any],
            update: Dict[str, Any]
    ) -> bool:
        """Update a single document in a collection."""
        if collection not in self.data:
            return False
        for doc in self.data[collection]:
            if all(doc.get(k) == v for k, v in query.items()):
                doc.update(update.get("$set", {}))
                return True
        return False

    def delete_one(
            self,
            collection: str,
            query: Dict[str, Any]
    ) -> bool:
        """Delete a single document from a collection."""
        if collection not in self.data:
            return False
        for i, doc in enumerate(self.data[collection]):
            if all(doc.get(k) == v for k, v in query.items()):
                del self.data[collection][i]
                return True
        return False


class MockRedis:
    """Mock Redis for testing."""

    def __init__(self):
        self.data: Dict[str, Any] = {}
        self.expires: Dict[str, datetime] = {}

    def get(self, key: str) -> Optional[str]:
        """Get a value from Redis."""
        self._check_expiry(key)
        return self.data.get(key)

    def set(
            self,
            key: str,
            value: Any,
            ex: Optional[int] = None
    ) -> bool:
        """Set a value in Redis with optional expiry."""
        self.data[key] = value
        if ex:
            self.expires[key] = datetime.now(timezone.utc) + timedelta(seconds=ex)
        return True

    def delete(self, key: str) -> bool:
        """Delete a key from Redis."""
        if key in self.data:
            del self.data[key]
            if key in self.expires:
                del self.expires[key]
            return True
        return False

    def _check_expiry(self, key: str) -> None:
        """Check if a key has expired."""
        if key in self.expires and datetime.now(timezone.utc) > self.expires[key]:
            self.delete(key)
