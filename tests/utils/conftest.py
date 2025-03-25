"""Common test fixtures and configurations."""

import os
from typing import Generator

import pytest
from fastapi import FastAPI
from fastapi.testclient import TestClient

# Test environment setup
os.environ["TESTING"] = "1"
os.environ["JWT_SECRET"] = "test_secret"
os.environ["DATABASE_URL"] = "postgresql://test:test@localhost:5432/test_db"
os.environ["REDIS_URL"] = "redis://localhost:6379/0"

# Import test helpers
from .test_helpers import (MockDB, MockRedis, create_test_user,
                           generate_test_token, login_test_user)


@pytest.fixture(scope="session")
def app() -> FastAPI:
    """Create test application."""
    from projects.AI_Crypto_Price_Predictor.src.main import create_app
    return create_app()

@pytest.fixture(scope="session")
def client(app: FastAPI) -> Generator:
    """Create test client."""
    with TestClient(app) as client:
        yield client

@pytest.fixture(scope="function")
def db() -> Generator:
    """Create test database."""
    db = MockDB()
    yield db

@pytest.fixture(scope="function")
def redis() -> Generator:
    """Create test Redis."""
    redis = MockRedis()
    yield redis

@pytest.fixture(scope="function")
def auth_headers() -> dict:
    """Create authentication headers."""
    token = generate_test_token()
    return {"Authorization": f"Bearer {token}"}

@pytest.fixture(scope="function")
def test_user(client: TestClient) -> dict:
    """Create test user."""
    return create_test_user(client)

@pytest.fixture(scope="function")
def test_user_token(client: TestClient, test_user: dict) -> str:
    """Get test user token."""
    login_data = login_test_user(client)
    return login_data["access_token"]

@pytest.fixture(scope="session")
def test_data_dir() -> str:
    """Get test data directory."""
    return os.path.join(os.path.dirname(__file__), "test_data")

def pytest_configure(config):
    """Configure pytest."""
    config.addinivalue_line(
        "markers",
        "integration: mark test as integration test"
    )
    config.addinivalue_line(
        "markers",
        "e2e: mark test as end-to-end test"
    )
    config.addinivalue_line(
        "markers",
        "performance: mark test as performance test"
    )

def pytest_collection_modifyitems(items):
    """Modify test items in place to handle markers."""
    for item in items:
        if "tests/integration/" in str(item.fspath):
            item.add_marker(pytest.mark.integration)
        elif "tests/e2e/" in str(item.fspath):
            item.add_marker(pytest.mark.e2e)
        elif "tests/performance/" in str(item.fspath):
            item.add_marker(pytest.mark.performance)

@pytest.fixture(autouse=True)
def env_setup():
    """Set up test environment variables."""
    original_env = dict(os.environ)

    # Set test environment variables
    os.environ.update({
        "ENVIRONMENT": "test",
        "LOG_LEVEL": "DEBUG",
        "API_PREFIX": "/api/v1",
        "ALLOWED_HOSTS": "localhost,testserver",
    })

    yield

    # Restore original environment variables
    os.environ.clear()
    os.environ.update(original_env)

@pytest.fixture
def mock_response():
    """Create mock API response."""
    class MockResponse:
        def __init__(self, json_data, status_code=200):
            self.json_data = json_data
            self.status_code = status_code

        def json(self):
            return self.json_data
    return MockResponse

@pytest.fixture
def sample_crypto_data():
    """Sample cryptocurrency data for testing."""
    return {
        "symbol": "BTC/USD",
        "price": 50000.00,
        "timestamp": "2025-03-24T00:00:00Z",
        "volume": 1000000.00
    }

@pytest.fixture
def sample_document_data():
    """Sample document data for testing."""
    return {
        "title": "Test Document",
        "content": "Sample content for testing",
        "type": "pdf",
        "status": "processed"
    }

@pytest.fixture
def sample_analytics_data():
    """Sample analytics data for testing."""
    return {
        "campaign_id": "test_campaign",
        "metrics": {
            "impressions": 1000,
            "clicks": 100,
            "conversions": 10
        },
        "period": "2025-03"
    }
