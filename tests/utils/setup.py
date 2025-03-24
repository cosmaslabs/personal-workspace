"""Setup configuration for test utilities package."""

from setuptools import find_namespace_packages, setup

setup(
    name="test-utils",
    version="0.1.0",
    description="Test utilities for AI-driven applications",
    author="CosmasLabs",
    author_email="info@cosmaslabs.com",
    packages=find_namespace_packages(include=["utils.*"]),
    install_requires=[
        "pytest>=6.2.5",
        "pytest-asyncio>=0.15.1",
        "pytest-cov>=2.12.1",
        "pytest-mock>=3.6.1",
        "httpx>=0.19.0",
        "PyJWT>=2.3.0",
        "pydantic>=1.8.2",
        "factory-boy>=3.2.0",
        "faker>=8.12.1",
    ],
    python_requires=">=3.9",
    classifiers=[
        "Development Status :: 3 - Alpha",
        "Intended Audience :: Developers",
        "Topic :: Software Development :: Testing",
        "Programming Language :: Python :: 3.9",
        "Private :: Do Not Upload",
    ],
)
