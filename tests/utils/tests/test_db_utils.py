"""Tests for database utilities."""

import pytest

from ..test_data.db_utils import (DBConfig, RedisConfig, RetryConfig,
                                 TestConfig, TestDBConfig, TimeoutConfig,
                                 get_db_url, get_redis_url, get_test_config,
                                 get_timeout_config, get_retry_config,
                                 load_db_config)

def test_db_config():
    """Test database configuration model."""
    config = DBConfig(
        name="test_db",
        host="localhost",
        port=5432,
        user="test_user",
        password="test_pass",
        tables=["test_table"]
    )
    assert config.name == "test_db"
    assert config.port == 5432
    assert len(config.tables) == 1

def test_redis_config():
    """Test Redis configuration model."""
    config = RedisConfig(
        host="localhost",
        port=6379,
        db=1,
        password="test_pass",
        cache_ttl=3600,
        prefix="test:"
    )
    assert config.port == 6379
    assert config.cache_ttl == 3600
    assert config.prefix == "test:"

def test_test_config():
    """Test test configuration model."""
    config = TestConfig(
        batch_size=100,
        cleanup_enabled=True,
        seed_enabled=True,
        mock_external_apis=True
    )
    assert config.batch_size == 100
    assert config.cleanup_enabled is True

def test_timeout_config():
    """Test timeout configuration model."""
    config = TimeoutConfig(
        db_connection=5,
        query_execution=10,
        api_request=3,
        cache_operation=1
    )
    assert config.db_connection == 5
    assert config.query_execution == 10

def test_retry_config():
    """Test retry configuration model."""
    config = RetryConfig(
        db_connection=3,
        api_request=2,
        cache_operation=1,
        delay_seconds=0.5
    )
    assert config.db_connection == 3
    assert config.delay_seconds == 0.5

def test_load_db_config():
    """Test loading database configuration."""
    config = load_db_config()
    assert isinstance(config, TestDBConfig)
    assert "crypto" in config.databases
    assert config.redis.host == "localhost"

def test_get_db_url():
    """Test getting database URL."""
    url = get_db_url("crypto")
    expected = "postgresql://test_user:test_pass@localhost:5432/crypto_test_db"
    assert url == expected

    # Test invalid database
    with pytest.raises(ValueError):
        get_db_url("invalid_db")

def test_get_redis_url():
    """Test getting Redis URL."""
    url = get_redis_url()
    expected = "redis://:redis_pass@localhost:6379/1"
    assert url == expected

def test_get_test_config():
    """Test getting test configuration."""
    config = get_test_config()
    assert config["batch_size"] == 100
    assert config["cleanup_enabled"] is True

def test_get_timeout_config():
    """Test getting timeout configuration."""
    config = get_timeout_config()
    assert config["db_connection"] == 5
    assert config["query_execution"] == 10

def test_get_retry_config():
    """Test getting retry configuration."""
    config = get_retry_config()
    assert config["db_connection"] == 3
    assert config["delay_seconds"] == 0.5
