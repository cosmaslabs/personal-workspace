"""Tests for test data utilities."""

import json
import os
from datetime import datetime

import pytest

from ..test_data.test_schemas import (Campaign, CryptoPrice, Document,
                                      TestData, User, validate_test_data)


def test_crypto_price_schema():
    """Test CryptoPrice schema validation."""
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

    # Test valid data
    price = CryptoPrice(**valid_data)
    assert price.symbol == "BTC/USD"
    assert price.price == 50000.00

    # Test invalid price
    invalid_data = valid_data.copy()
    invalid_data["price"] = -1000
    with pytest.raises(ValueError):
        CryptoPrice(**invalid_data)

def test_document_schema():
    """Test Document schema validation."""
    valid_data = {
        "id": "doc_001",
        "type": "invoice",
        "content": "Sample content",
        "metadata": {
            "date": "2025-03-24",
            "amount": 1500.00,
            "currency": "USD"
        }
    }

    # Test valid data
    doc = Document(**valid_data)
    assert doc.id == "doc_001"
    assert doc.type.value == "invoice"

    # Test invalid type
    invalid_data = valid_data.copy()
    invalid_data["type"] = "invalid_type"
    with pytest.raises(ValueError):
        Document(**invalid_data)

def test_campaign_schema():
    """Test Campaign schema validation."""
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

    # Test valid data
    campaign = Campaign(**valid_data)
    assert campaign.id == "camp_001"
    assert campaign.metrics.impressions == 1000

    # Test invalid metrics
    invalid_data = valid_data.copy()
    invalid_data["metrics"]["impressions"] = -100
    with pytest.raises(ValueError):
        Campaign(**invalid_data)

def test_user_schema():
    """Test User schema validation."""
    valid_data = {
        "id": "user_001",
        "email": "test@example.com",
        "name": "Test User",
        "role": "admin",
        "active": True
    }

    # Test valid data
    user = User(**valid_data)
    assert user.id == "user_001"
    assert user.role.value == "admin"

    # Test invalid role
    invalid_data = valid_data.copy()
    invalid_data["role"] = "invalid_role"
    with pytest.raises(ValueError):
        User(**invalid_data)

def test_test_data_validation():
    """Test complete test data validation."""
    # Load test data file
    test_data_path = os.path.join(
        os.path.dirname(__file__),
        "..",
        "test_data",
        "test_samples.json"
    )
    with open(test_data_path) as f:
        data = json.load(f)

    # Test validation
    assert validate_test_data(data) is True

    # Test invalid data
    invalid_data = data.copy()
    invalid_data["crypto_samples"]["prices"][0]["price"] = -1000
    assert validate_test_data(invalid_data) is False

def test_date_formatting():
    """Test date handling in schemas."""
    test_date = "2025-03-24T00:00:00Z"
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
    assert price.timestamp.isoformat() + "Z" == test_date
