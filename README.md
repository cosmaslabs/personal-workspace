# Personal Workspace

A comprehensive personal workspace showcasing my learning journey in software development. Features multiple projects including AI/ML, document processing, and analytics, along with reusable test utilities and development tools. Built with Python, FastAPI, and modern development practices.

## Projects

### [AI Crypto Price Predictor](projects/AI_Crypto_Price_Predictor/)

Machine learning model for cryptocurrency price prediction using historical data and market indicators.

### [Document Digitization OCR System](projects/Document_Digitization_OCR_System/)

Document processing system using OCR and machine learning for automated data extraction.

### [University Marketing Analytics Tool](projects/University_Marketing_Analytics_Tool/)

Data analytics platform for university marketing campaign performance tracking and insights.

## Features

- Comprehensive test utilities
- Database and Redis utilities
- Mock implementations for testing
- JWT token generation
- Data validation schemas
- Development tools and configurations

## Tech Stack

- Python 3.10+
- FastAPI
- SQLAlchemy
- Redis
- PyTest
- Pydantic
- Docker

## Development

### Installation

```bash
# Clone repository
git clone https://github.com/cosmaslabs/personal-workspace.git
cd personal-workspace

# Install dependencies
pip install -r requirements.txt

# Install development dependencies
pip install -r requirements-dev.txt

# Install pre-commit hooks
pre-commit install
```

### Running Tests

```bash
# Run all tests
pytest tests/

# Run with coverage
pytest --cov=src tests/
```

### Code Quality

```bash
# Format code
black .

# Sort imports
isort .

# Type checking
mypy .

# Lint code
flake8 .
```

## Project Structure

```
.
├── projects/                  # Project implementations
│   ├── AI_Crypto_Price_Predictor/
│   ├── Document_Digitization_OCR_System/
│   └── University_Marketing_Analytics_Tool/
├── tests/                    # Test suites
│   ├── utils/               # Test utilities
│   ├── unit/               # Unit tests
│   ├── integration/        # Integration tests
│   └── e2e/               # End-to-end tests
├── docs/                    # Documentation
├── scripts/                 # Utility scripts
└── requirements/            # Dependencies
```

## Contributing

1. Create feature branch (`git checkout -b feature/amazing-feature`)
2. Commit changes (`git commit -m 'feat: add amazing feature'`)
3. Push branch (`git push origin feature/amazing-feature`)
4. Open pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
