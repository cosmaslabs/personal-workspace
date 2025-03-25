"""Setup configuration for test utilities package."""

from setuptools import find_packages, setup

setup(
    name="test-utils",
    version="0.1.0",
    description="Test utilities for project components",
    author="Your Name",
    author_email="your.email@example.com",
    packages=find_packages(),
    python_requires=">=3.10",
    install_requires=[
        "fastapi>=0.115.0,<1.0.0",
        "pydantic>=2.0.0,<3.0.0",
        "PyJWT>=2.0.0,<3.0.0",
        "SQLAlchemy>=2.0.0,<3.0.0",
        "redis>=5.0.0,<6.0.0",
        "python-dotenv>=1.0.0,<2.0.0",
    ],
    extras_require={
        "test": [
            "pytest>=8.0.0,<9.0.0",
            "pytest-asyncio>=0.25.0,<1.0.0",
            "pytest-cov>=4.0.0,<5.0.0",
            "pytest-mock>=3.0.0,<4.0.0",
            "pytest-timeout>=2.0.0,<3.0.0",
            "faker>=19.0.0,<20.0.0",
        ],
        "dev": [
            "black>=24.0.0,<25.0.0",
            "flake8>=7.0.0,<8.0.0",
            "isort>=5.0.0,<6.0.0",
            "mypy>=1.0.0,<2.0.0",
            "pre-commit>=3.0.0,<4.0.0",
        ],
    },
    classifiers=[
        "Development Status :: 3 - Alpha",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.10",
        "Topic :: Software Development :: Testing",
        "Topic :: Software Development :: Libraries :: Python Modules",
    ],
)
