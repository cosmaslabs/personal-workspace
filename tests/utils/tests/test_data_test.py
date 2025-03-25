"""Tests for test data validation."""

import json
import os
from datetime import datetime, timezone

from ..test_data.test_schemas import (Campaign, CryptoPrice, Document, User,
                                      validate_test_data)


def test_crypto_price_schema():
    """Test cryptocurrency price data schema."""
    valid_data = {
        "symbol": "BTC/USD",
        "price": 50000.00,
        "timestamp": "2025-03-24T00:00:00Z",
        "volume": 1000000.00,
        "high": 51000.00,
        "low": 49000.00,
        "open": 49500.00,
        "close": 50000.00
    }
    price = CryptoPrice(**valid_data)
    assert price.symbol == "BTC/USD"
    assert price.price == 50000.00


def test_document_schema():
    """Test document schema."""
    valid_data = {
        "id": "doc_001",
        "type": "invoice",
        "content": "Test content",
        "metadata": {
            "date": "2025-03-24",
            "amount": 1500.00,
            "currency": "USD"
        }
    }
    doc = Document(**valid_data)
    assert doc.id == "doc_001"
    assert doc.type.value == "invoice"


def test_campaign_schema():
    """Test campaign schema."""
    valid_data = {
        "id": "camp_001",
        "name": "Test Campaign",
        "metrics": {
            "impressions": 1000,
            "clicks": 100,
            "conversions": 10,
            "revenue": 1000.00,
            "roi": 2.5
        },
        "period": "2025-03"
    }
    campaign = Campaign(**valid_data)
    assert campaign.id == "camp_001"
    assert campaign.name == "Test Campaign"


def test_user_schema():
    """Test user schema."""
    valid_data = {
        "id": "user_001",
        "email": "test@example.com",
        "name": "Test User",
        "role": "admin",
        "active": True
    }
    user = User(**valid_data)
    assert user.id == "user_001"
    assert user.role.value == "admin"


def test_test_data_validation():
    """Test complete test data validation."""
    test_data_path = os.path.join(
        os.path.dirname(__file__),
        "..",
        "test_data",
        "test_samples.json"
    )
    with open(test_data_path) as f:
        data = json.load(f)
    assert validate_test_data(data) is True


def test_date_formatting():
    """Test date handling in schemas."""
    test_date = datetime(2025, 3, 24, tzinfo=timezone.utc)
    price_data = {
        "symbol": "BTC/USD",
        "price": 50000.00,
        "timestamp": test_date,
        "volume": 1000000.00,
        "high": 51000.00,
        "low": 49000.00,
        "open": 49500.00,
        "close": 50000.00
    }

    price = CryptoPrice(**price_data)
    assert isinstance(price.timestamp, datetime)
    assert price.timestamp == test_date
    assert price.timestamp.isoformat().replace("+00:00", "Z") == "2025-03-24T00:00:00Z"
