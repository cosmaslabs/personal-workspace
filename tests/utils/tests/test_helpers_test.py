"""Tests for test helper utilities."""

import pytest
from datetime import datetime, timedelta

from ..test_helpers import (
    MockDB,
    MockRedis,
    generate_random_string,
    generate_test_token,
)

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

    # Test custom user and role
    token = generate_test_token(user_id="custom_user", role="admin")
    assert "custom_user" in token
    assert "admin" in token

    # Test expiration
    token = generate_test_token(exp_minutes=1)
    assert token is not None

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
    assert redis.get("key1") == "value1"

    # Test expiry
    redis.set("key2", "value2", ex=1)
    assert redis.get("key2") == "value2"

    # Simulate time passing
    redis.expires["key2"] = datetime.utcnow() - timedelta(seconds=2)
    assert redis.get("key2") is None

    # Test delete
    redis.set("key3", "value3")
    assert redis.delete("key3") is True
    assert redis.get("key3") is None

    # Test non-existent key
    assert redis.get("nonexistent") is None
    assert redis.delete("nonexistent") is False
