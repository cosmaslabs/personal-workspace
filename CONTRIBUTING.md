# Contributing to Our Projects

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing to our projects.

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Getting Started](#getting-started)
- [Development Process](#development-process)
- [Submitting Changes](#submitting-changes)
- [Coding Standards](#coding-standards)
  - [Python](#python)
  - [JavaScript/TypeScript](#javascripttypescript)
  - [General](#general)
- [Testing Guidelines](#testing-guidelines)
- [Documentation](#documentation)
- [Project-Specific Guidelines](#project-specific-guidelines)
  - [AI Crypto Price Predictor](#ai-crypto-price-predictor)
  - [Document Digitization OCR System](#document-digitization-ocr-system)
  - [Marketing Analytics Tool](#marketing-analytics-tool)
  - [NocoBase Backend](#nocobase-backend)
- [Questions or Need Help?](#questions-or-need-help)
- [License](#license)

## Getting Started

1. **Fork and Clone**

   ```bash
   git clone --recursive https://github.com/yourusername/repository-name.git
   cd repository-name
   ```

2. **Install Dependencies**
   - Follow project-specific setup instructions in each project's README
   - Install development tools:

     ```bash
     python -m pip install --upgrade pip
     pip install flake8 pytest black isort
     ```

3. **Create a Branch**

   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development Process

1. **Choose an Issue**
   - Look for issues labeled `good first issue` or `help wanted`
   - Comment on the issue to let others know you're working on it
   - Ask questions if anything is unclear

2. **Local Development**
   - Make your changes in a feature branch
   - Follow the coding standards
   - Write tests for new features
   - Update documentation as needed

3. **Commit Guidelines**
   - Use conventional commits format
   - Keep commits atomic and focused
   - Example:

     ```
     feat(crypto): add support for ETH price prediction
     fix(ocr): resolve memory leak in image processing
     docs(analytics): update API documentation
     ```

## Submitting Changes

1. **Before Submitting**
   - Run all tests: `pytest`
   - Run linting: `flake8`
   - Format code: `black . && isort .`
   - Update documentation if needed

2. **Pull Request Process**
   - Fill out the PR template completely
   - Link related issues
   - Include screenshots for UI changes
   - Add notes about database migrations
   - Request review from maintainers

3. **Code Review**
   - Address review comments
   - Keep the PR updated with the target branch
   - Be responsive to feedback

## Coding Standards

### Python

- Follow PEP 8 style guide
- Use type hints
- Maximum line length: 88 characters
- Use docstrings for functions and classes
- Sort imports with isort

### JavaScript/TypeScript

- Use ESLint configuration
- Follow Prettier formatting
- Use TypeScript where possible
- Document complex functions

### General

- Write clear, descriptive variable names
- Keep functions focused and small
- Add comments for complex logic
- Use consistent naming conventions

## Testing Guidelines

1. **Unit Tests**
   - Write tests for new features
   - Maintain 80% code coverage minimum
   - Test edge cases
   - Use meaningful test names

2. **Integration Tests**
   - Test component interactions
   - Cover critical user paths
   - Use mock data appropriately

3. **Running Tests**

   ```bash
   # Run unit tests
   pytest

   # Run with coverage
   pytest --cov=./

   # Run specific tests
   pytest path/to/test_file.py -k test_name
   ```

## Documentation

1. **Code Documentation**
   - Document all public APIs
   - Include usage examples
   - Explain complex algorithms
   - Update when changing functionality

2. **Project Documentation**
   - Keep README.md updated
   - Document setup processes
   - Include troubleshooting guides
   - Provide architecture diagrams

## Project-Specific Guidelines

### AI Crypto Price Predictor

- Follow ML model versioning guidelines
- Document model parameters
- Include performance metrics
- Test prediction accuracy

### Document Digitization OCR System

- Test with various document types
- Include sample documents
- Document preprocessing steps
- Test OCR accuracy

### Marketing Analytics Tool

- Follow data privacy guidelines
- Document data schemas
- Include data validation
- Test reporting accuracy

### NocoBase Backend

- Follow NocoBase contribution guidelines
- Test plugin compatibility
- Document API changes
- Include migration guides

## Questions or Need Help?

- Join our community Discord/Slack
- Check the FAQ in the wiki
- Ask in GitHub Discussions
- Contact the maintainers

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.
