"""Tests for test data validation schemas."""

from datetime import datetime, timezone
from decimal import Decimal

import pytest

from ..test_data.test_schemas import (
    Campaign,
    CampaignStatus,
    CryptoPrice,
    Document,
    DocumentStatus,
    User,
    UserRole,
    validate_test_data,
)

def test_crypto_price_schema():
    """Test crypto price validation."""
    valid_data = {
        "id": "BTC_20240325",
        "symbol": "BTC",
        "price": Decimal("65432.10"),
        "timestamp": datetime.now(timezone.utc),
        "source": "test_exchange"
    }
    crypto = CryptoPrice(**valid_data)
    assert crypto.symbol == "BTC"
    assert crypto.price == Decimal("65432.10")

    # Test invalid data
    with pytest.raises(ValueError):
        CryptoPrice(
            id="invalid_id",
            symbol="B",  # Too short
            price=Decimal("-100"),  # Negative price
            timestamp=datetime.now(timezone.utc),
            source="ex"  # Too short
        )

def test_document_schema():
    """Test document validation."""
    valid_data = {
        "id": "DOC001",
        "title": "Test Document Title",
        "content": "Sample document content for testing",
        "created_at": datetime.now(timezone.utc),
        "status": "processed"
    }
    doc = Document(**valid_data)
    assert doc.title == "Test Document Title"
    assert doc.status == DocumentStatus.PROCESSED

    # Test invalid data
    with pytest.raises(ValueError):
        Document(
            id="INVALID",
            title="Test",  # Too short
            content="Too short",
            created_at=datetime.now(timezone.utc),
            status="invalid_status"  # Invalid enum value
        )

def test_campaign_schema():
    """Test campaign validation."""
    start_date = datetime.now(timezone.utc)
    end_date = datetime.now(timezone.utc)
    valid_data = {
        "id": "CAM001",
        "name": "Test Campaign Name",
        "start_date": start_date,
        "end_date": end_date,
        "budget": Decimal("10000.00"),
        "status": "active"
    }
    campaign = Campaign(**valid_data)
    assert campaign.name == "Test Campaign Name"
    assert campaign.status == CampaignStatus.ACTIVE

    # Test invalid data
    with pytest.raises(ValueError):
        Campaign(
            id="INVALID",
            name="Test",  # Too short
            start_date=end_date,
            end_date=start_date,
            budget=Decimal("-100"),  # Negative budget
            status="invalid_status"  # Invalid enum value
        )

def test_user_schema():
    """Test user validation."""
    valid_data = {
        "id": "USR001",
        "email": "test@example.com",
        "name": "Test User",
        "role": "admin",
        "created_at": datetime.now(timezone.utc)
    }
    user = User(**valid_data)
    assert user.email == "test@example.com"
    assert user.role == UserRole.ADMIN

    # Test invalid data
    with pytest.raises(ValueError):
        User(
            id="INVALID",
            email="invalid_email",  # Invalid email format
            name="Te",  # Too short
            role="invalid_role",  # Invalid enum value
            created_at=datetime.now(timezone.utc)
        )

def test_validate_test_data():
    """Test data validation utility."""
    crypto_data = {
        "id": "BTC_20240325",
        "symbol": "BTC",
        "price": Decimal("65432.10"),
        "timestamp": datetime.now(timezone.utc),
        "source": "test_exchange"
    }
    assert validate_test_data("crypto_prices", crypto_data) is True

    # Test invalid data type
    with pytest.raises(ValueError):
        validate_test_data("invalid_type", {})

    # Test invalid data
    invalid_data = {
        "id": "INVALID",
        "symbol": "B",
        "price": -100,
        "timestamp": "invalid_date",
        "source": ""
    }
    assert validate_test_data("crypto_prices", invalid_data) is False
