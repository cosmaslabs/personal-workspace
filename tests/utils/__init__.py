"""Test utilities package for AI-driven applications suite."""

from .test_helpers import (
    MockDB,
    MockRedis,
    create_test_user,
    generate_random_string,
    generate_test_token,
    load_test_data,
    login_test_user,
)
from .test_data.test_schemas import (
    TestData,
    validate_test_data,
)

__version__ = "0.1.0"
__author__ = "CosmasLabs"
__license__ = "MIT"

__all__ = [
    # Test helpers
    "MockDB",
    "MockRedis",
    "create_test_user",
    "generate_random_string",
    "generate_test_token",
    "load_test_data",
    "login_test_user",
    # Test data validation
    "TestData",
    "validate_test_data",
]
