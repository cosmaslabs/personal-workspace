# Contributing to AI Crypto Price Predictor

First off, thanks for taking the time to contribute! 🎉

## Code of Conduct

This project and everyone participating in it is governed by our
[Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to
uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the issue list as you might find out
that you don't need to create one. When you create a bug report, please include
as many details as possible:

- Use a clear and descriptive title
- Describe the exact steps which reproduce the problem
- Provide specific examples to demonstrate the steps
- Describe the behavior you observed after following the steps
- Explain which behavior you expected to see instead and why
- Include screenshots and animated GIFs if possible

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. Create an issue and
provide the following information:

- Use a clear and descriptive title
- Provide a step-by-step description of the suggested enhancement
- Provide specific examples to demonstrate the steps
- Describe the current behavior and explain the behavior you expected to see
- Explain why this enhancement would be useful

### Development Process

1. Fork the repo
2. Create a new branch:

   ```bash
   git checkout -b feature/my-feature
   # or
   git checkout -b fix/my-fix
   ```

3. Make your changes
4. Run tests:

   ```bash
   make test
   make lint
   ```

5. Commit your changes using conventional commits:

   ```bash
   git commit -m "feat: add amazing feature"
   # or
   git commit -m "fix: resolve issue #123"
   ```

6. Push to your fork
7. Open a Pull Request

### Development Setup

1. Install dependencies:

   ```bash
   pip install -r requirements.txt
   pip install -r requirements-dev.txt
   ```

2. Install pre-commit hooks:

   ```bash
   make setup
   ```

3. Create configuration:

   ```bash
   cp .env.example .env
   # Edit .env with your settings
   ```

4. Run tests:

   ```bash
   make test
   ```

### Code Style

We use several tools to maintain code quality:

- Black for code formatting
- isort for import sorting
- flake8 for style guide enforcement
- mypy for type checking
- pylint for code analysis

Run all checks with:

```bash
make lint
```

### Testing

- Write tests for new code
- Maintain test coverage
- Follow existing test patterns
- Include both unit and integration tests

Run tests with:

```bash
make test            # Run all tests
make test-coverage   # Run tests with coverage
make test-integration  # Run integration tests
```

### Documentation

- Update documentation for new features
- Include docstrings in Python code
- Follow Google style docstrings
- Update API documentation when changing endpoints

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` new features
- `fix:` bug fixes
- `docs:` documentation changes
- `style:` code style changes
- `refactor:` code refactoring
- `test:` adding or updating tests
- `chore:` maintenance tasks

### Pull Request Process

1. Follow the PR template
2. Update documentation
3. Add tests for new code
4. Ensure CI passes
5. Get review from maintainers
6. Squash commits if requested
7. Maintain clean commit history

### Release Process

1. Update version in pyproject.toml
2. Update CHANGELOG.md
3. Create release PR
4. Get approval from maintainers
5. Merge and tag release
6. Create GitHub release

## Additional Notes

### Issue Labels

- `bug`: Something isn't working
- `enhancement`: New feature or request
- `documentation`: Documentation improvements
- `good first issue`: Good for newcomers
- `help wanted`: Extra attention needed
- `security`: Security related issues

### Project Structure

```
.
├── src/               # Source code
│   ├── api/          # API endpoints
│   ├── data/         # Data processing
│   ├── models/       # ML models
│   └── utils/        # Utilities
├── tests/            # Test files
├── docs/             # Documentation
└── configs/          # Configuration
```

### Communication

- GitHub Issues: Bug reports and feature requests
- GitHub Discussions: General questions and discussions
- Email: <security@cosmaslabs.com> for security issues

### Resources

- [Project Documentation](docs/)
- [API Documentation](docs/api.md)
- [Architecture Guide](docs/architecture.md)
- [Style Guide](docs/style.md)

## Recognition

Contributors will be recognized in:

- CONTRIBUTORS.md file
- Release notes
- Project documentation

Thank you for contributing! 🙏
