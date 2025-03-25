"""Pydantic models for test data validation."""

from datetime import datetime
from decimal import Decimal
from enum import Enum
from typing import Optional

from pydantic import BaseModel, Field


class CryptoPrice(BaseModel):
    """Schema for crypto price data."""
    id: str = Field(..., pattern=r"^[A-Z]{2,10}_\d{8}$")
    symbol: str = Field(..., min_length=2, max_length=10)
    price: Decimal = Field(..., gt=0)
    timestamp: datetime
    source: str = Field(..., min_length=3)


class DocumentStatus(str, Enum):
    """Document processing status."""
    PENDING = "pending"
    PROCESSING = "processing"
    PROCESSED = "processed"
    FAILED = "failed"


class Document(BaseModel):
    """Schema for document data."""
    id: str = Field(..., pattern=r"^DOC\d{3}$")
    title: str = Field(..., min_length=5, max_length=100)
    content: str = Field(..., min_length=10)
    created_at: datetime
    status: DocumentStatus


class CampaignStatus(str, Enum):
    """Campaign status."""
    DRAFT = "draft"
    ACTIVE = "active"
    PAUSED = "paused"
    COMPLETED = "completed"


class Campaign(BaseModel):
    """Schema for marketing campaign data."""
    id: str = Field(..., pattern=r"^CAM\d{3}$")
    name: str = Field(..., min_length=5, max_length=50)
    start_date: datetime
    end_date: datetime
    budget: Decimal = Field(..., gt=0)
    status: CampaignStatus


class UserRole(str, Enum):
    """User role types."""
    ADMIN = "admin"
    USER = "user"
    GUEST = "guest"


class User(BaseModel):
    """Schema for user data."""
    id: str = Field(..., pattern=r"^USR\d{3}$")
    email: str = Field(..., pattern=r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
    name: str = Field(..., min_length=3, max_length=50)
    role: UserRole
    created_at: datetime
    updated_at: Optional[datetime] = None


def validate_test_data(data_type: str, data: dict) -> bool:
    """Validate test data against schemas."""
    schema_map = {
        "crypto_prices": CryptoPrice,
        "documents": Document,
        "campaigns": Campaign,
        "users": User,
    }

    schema = schema_map.get(data_type)
    if not schema:
        raise ValueError(f"Unknown data type: {data_type}")

    try:
        schema(**data)
        return True
    except Exception:
        return False
