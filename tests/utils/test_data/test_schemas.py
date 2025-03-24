"""Pydantic schemas for test data validation."""

from datetime import datetime
from enum import Enum
from typing import Dict, List, Optional, Union

from pydantic import BaseModel, Field, constr


class DocumentType(str, Enum):
    """Document types."""
    INVOICE = "invoice"
    RECEIPT = "receipt"
    CONTRACT = "contract"
    REPORT = "report"


class UserRole(str, Enum):
    """User roles."""
    ADMIN = "admin"
    USER = "user"
    GUEST = "guest"


class CryptoPrice(BaseModel):
    """Cryptocurrency price data."""
    symbol: str
    price: float = Field(..., gt=0)
    timestamp: datetime
    volume: float = Field(..., gt=0)
    high: float = Field(..., gt=0)
    low: float = Field(..., gt=0)
    open: float = Field(..., gt=0)
    close: float = Field(..., gt=0)


class CryptoPrediction(BaseModel):
    """Cryptocurrency price prediction."""
    symbol: str
    predicted_price: float = Field(..., gt=0)
    confidence: float = Field(..., ge=0, le=1)
    timeframe: str
    timestamp: datetime


class DocumentMetadata(BaseModel):
    """Document metadata."""
    date: str
    amount: Optional[float] = None
    currency: Optional[str] = None
    total: Optional[float] = None
    store: Optional[str] = None


class Document(BaseModel):
    """Document data."""
    id: str
    type: DocumentType
    content: str
    metadata: DocumentMetadata


class DocumentTemplate(BaseModel):
    """Document template."""
    name: str
    fields: List[str]
    required_fields: List[str]


class CampaignMetrics(BaseModel):
    """Marketing campaign metrics."""
    impressions: int = Field(..., ge=0)
    clicks: int = Field(..., ge=0)
    conversions: int = Field(..., ge=0)
    revenue: float = Field(..., ge=0)
    roi: float = Field(..., ge=0)


class Campaign(BaseModel):
    """Marketing campaign data."""
    id: str
    name: str
    metrics: CampaignMetrics
    period: str


class SegmentCriteria(BaseModel):
    """Segment criteria."""
    enrollment_status: str
    gpa_range: List[float] = Field(..., min_items=2, max_items=2, min_length=2, max_length=2)
    engagement_level: str


class Segment(BaseModel):
    """Customer segment data."""
    id: str
    name: str
    criteria: SegmentCriteria
    size: int = Field(..., ge=0)


class User(BaseModel):
    """User data."""
    id: str
    email: str
    name: str
    role: UserRole
    active: bool = True


class AuthTokens(BaseModel):
    """Authentication tokens."""
    valid: str
    expired: str
    invalid: str


class ErrorDetails(BaseModel):
    """Error details."""
    field: Optional[str] = None
    issue: Optional[str] = None


class Error(BaseModel):
    """Error response."""
    code: str
    message: str
    details: Optional[ErrorDetails] = None


class TestData(BaseModel):
    """Complete test data structure."""
    crypto_samples: Dict[str, Union[List[CryptoPrice], List[CryptoPrediction]]]
    ocr_samples: Dict[str, Union[List[Document], List[DocumentTemplate]]]
    analytics_samples: Dict[str, Union[List[Campaign], List[Segment]]]
    users: List[User]
    auth: Dict[str, AuthTokens]
    errors: Dict[str, Error]


def validate_test_data(data: dict) -> bool:
    """Validate test data against schema."""
    try:
        TestData(**data)
        return True
    except Exception as e:
        print(f"Validation error: {e}")
        return False
