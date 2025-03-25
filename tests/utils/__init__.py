"""Test utilities package."""

from .test_config import get_test_settings
from .test_helpers import (
    MockDB,
    MockRedis,
    create_test_user,
    generate_random_string,
    generate_test_token,
    load_test_data,
    login_test_user,
)
from .test_data.db_utils import (
    DBConfig,
    RedisConfig,
    RetryConfig,
    TestConfig,
    TestDBConfig,
    TimeoutConfig,
    get_db_url,
    get_redis_url,
    get_retry_config,
    get_test_config,
    get_timeout_config,
    load_db_config,
)
from .test_data.test_schemas import (
    Campaign,
    CryptoPrice,
    Document,
    User,
    validate_test_data,
)

__version__ = "0.1.0"
__author__ = "Your Name"
__email__ = "your.email@example.com"

__all__ = [
    # Test configuration
    "get_test_settings",

    # Test helpers
    "MockDB",
    "MockRedis",
    "create_test_user",
    "generate_random_string",
    "generate_test_token",
    "load_test_data",
    "login_test_user",

    # Database utilities
    "DBConfig",
    "RedisConfig",
    "RetryConfig",
    "TestConfig",
    "TestDBConfig",
    "TimeoutConfig",
    "get_db_url",
    "get_redis_url",
    "get_retry_config",
    "get_test_config",
    "get_timeout_config",
    "load_db_config",

    # Test schemas
    "Campaign",
    "CryptoPrice",
    "Document",
    "User",
    "validate_test_data",
]
