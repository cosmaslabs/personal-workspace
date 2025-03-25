# Test Utilities

Helper functions and utilities for testing the project components.

## Structure

```
tests/utils/
├── __init__.py               # Package initialization
├── test_config.py           # Test configuration settings
├── test_helpers.py          # Common test helper functions
├── test_data/              # Test data and schemas
│   ├── db_utils.py         # Database utilities
│   ├── test_schemas.py     # Pydantic models for test data
│   ├── test_samples.json   # Sample test data
│   └── test_db_config.json # Database configuration
└── tests/                  # Tests for utilities
    ├── test_config_test.py
    ├── test_helpers_test.py
    ├── test_data_test.py
    └── test_db_utils.py
```

## Features

- Database configuration management
- Redis caching utilities
- Test data generation and validation
- Mock database and Redis implementations
- JWT token generation for testing
- Common test fixtures and helpers

## Usage

### Configuration

```python
from tests.utils.test_config import get_test_settings

# Get test settings
settings = get_test_settings()
```

### Database Utilities

```python
from tests.utils.test_data.db_utils import get_db_url, get_redis_url

# Get database URL
db_url = get_db_url("crypto")

# Get Redis URL
redis_url = get_redis_url()
```

### Test Helpers

```python
from tests.utils.test_helpers import (
    generate_test_token,
    create_test_user,
    MockDB,
    MockRedis
)

# Generate test JWT token
token = generate_test_token(user_id="test_user", role="admin")

# Use mock database
db = MockDB()
doc_id = db.insert("collection", {"key": "value"})

# Use mock Redis
redis = MockRedis()
redis.set("key", "value", ex=60)
```

## Development

### Installation

```bash
# Install dependencies
pip install -r requirements.txt

# Install development dependencies
pip install -r requirements-dev.txt
```

### Running Tests

```bash
# Run all tests
pytest tests/utils/tests/

# Run with coverage
pytest tests/utils/tests/ --cov=tests/utils

# Run specific test file
pytest tests/utils/tests/test_helpers_test.py
```

### Contributing

1. Create feature branch: `git checkout -b feature-name`
2. Make changes and run tests
3. Format code: `black tests/utils/`
4. Run linting: `flake8 tests/utils/`
5. Submit pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
