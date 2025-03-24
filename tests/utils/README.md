# Test Utilities

Common test utilities and helpers for the AI-driven applications suite.

## Overview

This package provides shared testing utilities, fixtures, and data for all projects in the monorepo.

## Features

- Common test fixtures
- Mock database and Redis implementations
- Test data samples and schemas
- Authentication helpers
- API testing utilities

## Installation

From the root directory:

```bash
pip install -e tests/utils
```

## Usage

### Test Helpers

```python
from test_utils.helpers import (
    generate_test_token,
    create_test_user,
    login_test_user
)

def test_authentication(client):
    # Create test user
    user = create_test_user(client)

    # Login and get token
    token = login_test_user(client)

    # Make authenticated request
    response = client.get("/api/protected",
                         headers={"Authorization": f"Bearer {token}"})
    assert response.status_code == 200
```

### Mock Database

```python
from test_utils.helpers import MockDB

def test_database_operations(mock_db):
    # Insert test data
    doc_id = mock_db.insert("users", {"name": "Test User"})

    # Query data
    user = mock_db.find_one("users", {"_id": doc_id})
    assert user["name"] == "Test User"
```

### Mock Redis

```python
from test_utils.helpers import MockRedis

def test_cache_operations(mock_redis):
    # Set cache value
    mock_redis.set("key", "value", ex=60)

    # Get cached value
    value = mock_redis.get("key")
    assert value == "value"
```

### Test Data

```python
from test_utils.test_data import load_test_data, validate_test_data

def test_with_sample_data():
    # Load test data
    data = load_test_data("test_samples.json")

    # Validate data structure
    assert validate_test_data(data)

    # Use test data
    crypto_prices = data["crypto_samples"]["prices"]
    assert len(crypto_prices) > 0
```

## Directory Structure

```
utils/
├── __init__.py
├── conftest.py           # pytest configuration and fixtures
├── test_helpers.py       # Common test utilities
├── setup.py             # Package configuration
├── README.md            # This file
└── test_data/          # Test data and schemas
    ├── test_samples.json
    └── test_schemas.py
```

## Configuration

### pytest Markers

Available pytest markers:
- `integration`: Integration tests
- `e2e`: End-to-end tests
- `performance`: Performance tests

Add to `pytest.ini`:
```ini
[pytest]
markers =
    integration: mark test as integration test
    e2e: mark test as end-to-end test
    performance: mark test as performance test
```

### Environment Variables

Test-specific environment variables:
- `TESTING=1`: Enables test mode
- `TEST_DB_URL`: Test database URL
- `TEST_REDIS_URL`: Test Redis URL

## Development

### Requirements

- Python 3.9+
- pytest 6.2+
- pydantic 1.8+

### Setup

1. Install development dependencies:
   ```bash
   pip install -r requirements-dev.txt
   ```

2. Install package in editable mode:
   ```bash
   pip install -e tests/utils
   ```

### Testing

Run tests for the utilities:
```bash
pytest tests/utils/tests
```

## Contributing

1. Follow project code style
2. Add tests for new features
3. Update documentation
4. Submit pull request

## License

Same license as the main project.
