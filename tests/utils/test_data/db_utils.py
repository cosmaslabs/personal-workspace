"""Database utilities for testing."""

import json
import os
from typing import Any, Dict, List, Optional

from pydantic import BaseModel as PydanticBaseModel


class BaseModel(PydanticBaseModel):
    """Base model for test configurations."""
    class Config:
        """Pydantic configuration."""
        arbitrary_types_allowed = True
        use_enum_values = True


class DBConfig(BaseModel):
    """Database configuration."""
    name: str
    host: str
    port: int
    user: str
    password: str
    tables: List[str]


class RedisConfig(BaseModel):
    """Redis configuration."""
    host: str
    port: int
    db: int
    password: Optional[str] = None
    cache_ttl: int
    prefix: str


class TestConfig(BaseModel):
    """Test configuration."""
    batch_size: int
    cleanup_enabled: bool
    seed_enabled: bool
    mock_external_apis: bool


class TimeoutConfig(BaseModel):
    """Timeout configuration."""
    db_connection: int
    query_execution: int
    api_request: int
    cache_operation: int


class RetryConfig(BaseModel):
    """Retry configuration."""
    db_connection: int
    api_request: int
    cache_operation: int
    delay_seconds: float


class TestDBConfig(BaseModel):
    """Complete test database configuration."""
    databases: Dict[str, DBConfig]
    redis: RedisConfig
    test_data: TestConfig
    timeouts: TimeoutConfig
    retries: RetryConfig


def load_db_config() -> TestDBConfig:
    """Load database configuration from JSON file."""
    config_path = os.path.join(
        os.path.dirname(__file__),
        "test_db_config.json"
    )
    with open(config_path) as f:
        config_data = json.load(f)
    return TestDBConfig(**config_data)


def get_db_url(db_name: str) -> str:
    """Get database URL for given database."""
    config = load_db_config()
    db_config = config.databases.get(db_name)
    if not db_config:
        raise ValueError(f"Unknown database: {db_name}")

    return (
        f"postgresql://{db_config.user}:{db_config.password}"
        f"@{db_config.host}:{db_config.port}/{db_config.name}"
    )


def get_redis_url() -> str:
    """Get Redis URL from configuration."""
    config = load_db_config()
    redis = config.redis
    password_part = f":{redis.password}@" if redis.password else "@"
    return f"redis://{password_part}{redis.host}:{redis.port}/{redis.db}"


def get_test_config() -> Dict[str, Any]:
    """Get test configuration settings."""
    config = load_db_config()
    return config.test_data.model_dump()


def get_timeout_config() -> Dict[str, int]:
    """Get timeout configuration settings."""
    config = load_db_config()
    return config.timeouts.model_dump()


def get_retry_config() -> Dict[str, Any]:
    """Get retry configuration settings."""
    config = load_db_config()
    return config.retries.model_dump()
