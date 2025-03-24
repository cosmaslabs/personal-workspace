"""Tests for test configuration module."""

import os
from pathlib import Path

from ..test_config import (MOCK_SETTINGS, REDIS_SETTINGS, REPORT_SETTINGS,
                           REPORTS_DIR, RETRIES, TEST_DATA_DIR,
                           TEST_DATA_SETTINGS, TEST_DB_SETTINGS, TEST_ENV_VARS,
                           TEST_ROOT, TIMEOUTS, cleanup_test_environment,
                           get_test_settings, setup_test_environment)


def test_test_directories():
    """Test test directory paths."""
    assert TEST_ROOT == Path(__file__).parent.parent
    assert TEST_DATA_DIR == TEST_ROOT / "test_data"
    assert REPORTS_DIR == Path(os.path.dirname(TEST_ROOT)) / "reports"


def test_database_settings():
    """Test database settings."""
    assert "crypto" in TEST_DB_SETTINGS
    assert "ocr" in TEST_DB_SETTINGS
    assert "analytics" in TEST_DB_SETTINGS

    for db_config in TEST_DB_SETTINGS.values():
        assert "url" in db_config
        assert "pool_size" in db_config
        assert "max_overflow" in db_config
        assert "timeout" in db_config


def test_redis_settings():
    """Test Redis settings."""
    assert "url" in REDIS_SETTINGS
    assert "encoding" in REDIS_SETTINGS
    assert "decode_responses" in REDIS_SETTINGS
    assert REDIS_SETTINGS["encoding"] == "utf-8"
    assert REDIS_SETTINGS["retry_on_timeout"] is True


def test_test_data_settings():
    """Test test data settings."""
    assert TEST_DATA_SETTINGS["batch_size"] == 100
    assert TEST_DATA_SETTINGS["max_samples"] == 1000
    assert TEST_DATA_SETTINGS["seed"] == 42
    assert "date_format" in TEST_DATA_SETTINGS
    assert "datetime_format" in TEST_DATA_SETTINGS


def test_mock_settings():
    """Test mock settings."""
    assert MOCK_SETTINGS["mock_external_apis"] is True
    assert MOCK_SETTINGS["mock_file_system"] is True
    assert MOCK_SETTINGS["mock_time"] is True
    assert MOCK_SETTINGS["mock_random"] is True


def test_environment_variables():
    """Test environment variables."""
    assert TEST_ENV_VARS["TESTING"] == "1"
    assert TEST_ENV_VARS["TEST_MODE"] == "unit"
    assert TEST_ENV_VARS["LOG_LEVEL"] == "DEBUG"
    assert "PYTHONPATH" in TEST_ENV_VARS


def test_report_settings():
    """Test report settings."""
    assert "junit_xml" in REPORT_SETTINGS
    assert "coverage_html" in REPORT_SETTINGS
    assert "coverage_xml" in REPORT_SETTINGS
    assert "benchmark_json" in REPORT_SETTINGS


def test_timeouts():
    """Test timeout settings."""
    assert TIMEOUTS["db_connection"] == 5
    assert TIMEOUTS["query_execution"] == 10
    assert TIMEOUTS["api_request"] == 3
    assert TIMEOUTS["cache_operation"] == 1


def test_retries():
    """Test retry settings."""
    assert RETRIES["db_connection"] == 3
    assert RETRIES["api_request"] == 2
    assert RETRIES["cache_operation"] == 1
    assert RETRIES["delay_seconds"] == 0.5


def test_get_test_settings():
    """Test getting all test settings."""
    settings = get_test_settings()

    assert "databases" in settings
    assert "redis" in settings
    assert "test_data" in settings
    assert "mocking" in settings
    assert "environment" in settings
    assert "reports" in settings
    assert "timeouts" in settings
    assert "retries" in settings
    assert "paths" in settings


def test_setup_environment(tmp_path):
    """Test environment setup."""
    # Backup current environment
    original_env = dict(os.environ)

    try:
        # Set up test environment
        setup_test_environment()

        # Check environment variables
        assert os.environ["TESTING"] == "1"
        assert os.environ["TEST_MODE"] == "unit"
        assert os.environ["LOG_LEVEL"] == "DEBUG"

        # Check directories
        assert TEST_DATA_DIR.exists()
        assert REPORTS_DIR.exists()

    finally:
        # Restore original environment
        os.environ.clear()
        os.environ.update(original_env)


def test_cleanup_environment(tmp_path):
    """Test environment cleanup."""
    # Create temporary test files
    test_tmp = REPORTS_DIR / "test.tmp"
    test_tmp.touch()

    # Set test environment variables
    os.environ.update(TEST_ENV_VARS)

    # Clean up environment
    cleanup_test_environment()

    # Check that temporary files are removed
    assert not test_tmp.exists()

    # Check that environment variables are reset
    for key in TEST_ENV_VARS:
        assert key not in os.environ
