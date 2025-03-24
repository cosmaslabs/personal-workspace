"""Test configuration settings."""

import os
from pathlib import Path
from typing import Any, Dict

# Test directories
TEST_ROOT = Path(__file__).parent
TEST_DATA_DIR = TEST_ROOT / "test_data"
REPORTS_DIR = Path(os.path.dirname(TEST_ROOT)) / "reports"

# Database settings
TEST_DB_SETTINGS = {
    "crypto": {
        "url": "postgresql://test:test@localhost:5432/crypto_test_db",
        "pool_size": 5,
        "max_overflow": 10,
        "timeout": 30
    },
    "ocr": {
        "url": "postgresql://test:test@localhost:5432/ocr_test_db",
        "pool_size": 5,
        "max_overflow": 10,
        "timeout": 30
    },
    "analytics": {
        "url": "postgresql://test:test@localhost:5432/analytics_test_db",
        "pool_size": 5,
        "max_overflow": 10,
        "timeout": 30
    }
}

# Redis settings
REDIS_SETTINGS = {
    "url": "redis://localhost:6379/1",
    "encoding": "utf-8",
    "decode_responses": True,
    "socket_timeout": 5,
    "socket_connect_timeout": 5,
    "retry_on_timeout": True
}

# Test data settings
TEST_DATA_SETTINGS = {
    "batch_size": 100,
    "max_samples": 1000,
    "seed": 42,
    "date_format": "%Y-%m-%d",
    "datetime_format": "%Y-%m-%dT%H:%M:%SZ"
}

# Mock settings
MOCK_SETTINGS = {
    "mock_external_apis": True,
    "mock_file_system": True,
    "mock_time": True,
    "mock_random": True
}

# Test environment variables
TEST_ENV_VARS = {
    "TESTING": "1",
    "TEST_MODE": "unit",
    "LOG_LEVEL": "DEBUG",
    "PYTHONPATH": str(Path(os.path.dirname(TEST_ROOT))),
}

# Report settings
REPORT_SETTINGS = {
    "junit_xml": str(REPORTS_DIR / "junit.xml"),
    "coverage_html": str(REPORTS_DIR / "coverage"),
    "coverage_xml": str(REPORTS_DIR / "coverage.xml"),
    "benchmark_json": str(REPORTS_DIR / "benchmark.json")
}

# Test timeouts (in seconds)
TIMEOUTS = {
    "db_connection": 5,
    "query_execution": 10,
    "api_request": 3,
    "cache_operation": 1,
    "file_operation": 2,
    "test_execution": 30
}

# Test retries
RETRIES = {
    "db_connection": 3,
    "api_request": 2,
    "cache_operation": 1,
    "delay_seconds": 0.5,
    "max_attempts": 3
}


def get_test_settings() -> Dict[str, Any]:
    """Get all test settings."""
    return {
        "databases": TEST_DB_SETTINGS,
        "redis": REDIS_SETTINGS,
        "test_data": TEST_DATA_SETTINGS,
        "mocking": MOCK_SETTINGS,
        "environment": TEST_ENV_VARS,
        "reports": REPORT_SETTINGS,
        "timeouts": TIMEOUTS,
        "retries": RETRIES,
        "paths": {
            "test_root": str(TEST_ROOT),
            "test_data": str(TEST_DATA_DIR),
            "reports": str(REPORTS_DIR)
        }
    }


def setup_test_environment() -> None:
    """Set up test environment."""
    # Create required directories
    TEST_DATA_DIR.mkdir(parents=True, exist_ok=True)
    REPORTS_DIR.mkdir(parents=True, exist_ok=True)

    # Set environment variables
    os.environ.update(TEST_ENV_VARS)

    # Add project root to Python path
    project_root = str(Path(os.path.dirname(TEST_ROOT)).parent)
    if project_root not in os.environ["PYTHONPATH"]:
        os.environ["PYTHONPATH"] = f"{project_root}:{os.environ['PYTHONPATH']}"


def cleanup_test_environment() -> None:
    """Clean up test environment."""
    # Remove temporary files
    for path in REPORTS_DIR.glob("*.tmp"):
        path.unlink()

    # Reset environment variables
    for key in TEST_ENV_VARS:
        if key in os.environ:
            del os.environ[key]
