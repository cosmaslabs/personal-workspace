"""Test configuration and fixtures."""

import json
import os
from pathlib import Path
from typing import Any, Dict

import pytest


@pytest.fixture
def test_data_dir() -> Path:
    """Get test data directory."""
    return Path(os.path.dirname(os.path.dirname(__file__))) / "test_data"


@pytest.fixture
def sample_data(test_data_dir: Path) -> Dict[str, Any]:
    """Load sample test data."""
    with open(test_data_dir / "test_samples.json") as f:
        return json.load(f)


@pytest.fixture
def db_config(test_data_dir: Path) -> Dict[str, Any]:
    """Load database configuration."""
    with open(test_data_dir / "test_db_config.json") as f:
        return json.load(f)


@pytest.fixture
def mock_db():
    """Create mock database for testing."""
    from ..test_helpers import MockDB
    return MockDB()


@pytest.fixture
def mock_redis():
    """Create mock Redis for testing."""
    from ..test_helpers import MockRedis
    return MockRedis()


@pytest.fixture
def test_env():
    """Set up test environment variables."""
    original = dict(os.environ)
    os.environ.update({
        "TESTING": "1",
        "TEST_DB_URL": "postgresql://test:test@localhost:5432/test_db",
        "TEST_REDIS_URL": "redis://localhost:6379/1"
    })
    yield
    os.environ.clear()
    os.environ.update(original)


@pytest.fixture
def crypto_price_data(sample_data: Dict[str, Any]) -> Dict[str, Any]:
    """Get sample cryptocurrency price data."""
    return sample_data["crypto_samples"]["prices"][0]


@pytest.fixture
def document_data(sample_data: Dict[str, Any]) -> Dict[str, Any]:
    """Get sample document data."""
    return sample_data["ocr_samples"]["documents"][0]


@pytest.fixture
def campaign_data(sample_data: Dict[str, Any]) -> Dict[str, Any]:
    """Get sample campaign data."""
    return sample_data["analytics_samples"]["campaigns"][0]


@pytest.fixture
def user_data(sample_data: Dict[str, Any]) -> Dict[str, Any]:
    """Get sample user data."""
    return sample_data["users"][0]


@pytest.fixture
def auth_tokens(sample_data: Dict[str, Any]) -> Dict[str, Any]:
    """Get sample authentication tokens."""
    return sample_data["auth"]["tokens"]


@pytest.fixture
def error_data(sample_data: Dict[str, Any]) -> Dict[str, Any]:
    """Get sample error responses."""
    return sample_data["errors"]
