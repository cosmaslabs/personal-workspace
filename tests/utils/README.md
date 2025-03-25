# Test Utilities

Helper functions and utilities for testing project components.

## Features

- Database configuration management
- Redis caching utilities
- Test data generation and validation
- Mock database and Redis implementations
- JWT token generation for testing
- Common test fixtures and helpers
- Schema validation for test data

## Directory Structure

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

## Installation

```bash
# Install dependencies
pip install -r requirements.txt

# Install development dependencies
pip install -r requirements-dev.txt

# Install pre-commit hooks
pre-commit install
```

## Usage

### Configuration

```python
from tests.utils.test_config import get_test_settings

# Get test settings
settings = get_test_settings()

# Access configuration
db_config = settings.databases["crypto"]
redis_config = settings.redis
```

### Database Utilities

```python
from tests.utils.test_data.db_utils import get_db_url, get_redis_url

# Get database URL
db_url = get_db_url("crypto")  # postgresql://user:pass@host:port/db

# Get Redis URL
redis_url = get_redis_url()  # redis://:pass@host:port/db
```

### Test Helpers

```python
from tests.utils.test_helpers import (
    generate_test_token,
    create_test_user,
    MockDB,
    MockRedis
)

# Generate JWT token
token = generate_test_token(user_id="test_user", role="admin")

# Create test user
user = create_test_user(client, email="test@example.com")

# Use mock database
db = MockDB()
doc_id = db.insert("collection", {"key": "value"})
doc = db.find_one("collection", {"_id": doc_id})

# Use mock Redis
redis = MockRedis()
redis.set("key", "value", ex=60)  # Set with expiry
value = redis.get("key")
```

### Data Validation

```python
from tests.utils.test_data.test_schemas import (
    CryptoPrice,
    Document,
    Campaign,
    User,
    validate_test_data
)

# Validate crypto price data
price_data = {
    "id": "BTC_20240325",
    "symbol": "BTC",
    "price": "65432.10",
    "timestamp": "2024-03-25T00:00:00Z",
    "source": "test_exchange"
}
crypto = CryptoPrice(**price_data)

# Validate using utility function
is_valid = validate_test_data("crypto_prices", price_data)
```

## Development

### Running Tests

```bash
# Run all tests
pytest tests/utils/tests/

# Run specific test file
pytest tests/utils/tests/test_helpers_test.py

# Run with coverage
pytest tests/utils/tests/ --cov=tests/utils

# Run with verbose output
pytest -v tests/utils/tests/
```

### Code Quality

```bash
# Format code
black tests/utils/

# Sort imports
isort tests/utils/

# Type checking
mypy tests/utils/

# Lint code
flake8 tests/utils/

# Security checks
bandit -r tests/utils/
```

### Contributing

1. Create feature branch: `git checkout -b feature-name`
2. Make changes and run tests
3. Update documentation if needed
4. Run pre-commit checks: `pre-commit run --all-files`
5. Submit pull request

## Test Data Schemas

### Crypto Price

- ID pattern: `[A-Z]{2,10}_\d{8}`
- Required fields: symbol, price, timestamp, source
- Decimal validation for price (> 0)

### Document

- ID pattern: `DOC\d{3}`
- Status enum: PENDING, PROCESSING, PROCESSED, FAILED
- Required fields: title, content, created_at, status

### Campaign

- ID pattern: `CAM\d{3}`
- Status enum: DRAFT, ACTIVE, PAUSED, COMPLETED
- Required fields: name, start_date, end_date, budget, status
- Budget validation (> 0)

### User

- ID pattern: `USR\d{3}`
- Role enum: ADMIN, USER, GUEST
- Required fields: email, name, role, created_at
- Email format validation
- Optional updated_at field

## License

This project is licensed under the MIT License - see the LICENSE file for details.
