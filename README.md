# AI-Driven Applications Monorepo

[![CI](https://github.com/yourusername/repository/actions/workflows/main.yml/badge.svg)](https://github.com/yourusername/repository/actions/workflows/main.yml)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)
[![Code Style: Prettier](https://img.shields.io/badge/code_style-prettier-ff69b4.svg)](https://github.com/prettier/prettier)

This monorepo contains three AI-driven applications and a NocoBase backend integration:

1. 🤖 **AI Crypto Price Predictor**: Advanced cryptocurrency price prediction system
2. 📄 **Document Digitization OCR System**: Intelligent document processing and digitization
3. 📊 **University Marketing Analytics Tool**: Data-driven marketing analytics platform
4. 🔧 **NocoBase Backend**: Customized backend service integration

## Project Structure

```
.
├── projects/
│   ├── AI_Crypto_Price_Predictor/        # BTC/ETH price prediction
│   ├── Document_Digitization_OCR_System/ # Document processing
│   └── University_Marketing_Analytics_Tool/ # Marketing analytics
├── nocobase/                            # Backend service
├── databases/                           # Database configurations
├── docs/                               # Documentation
├── logs/                              # Application logs
└── scripts/                          # Utility scripts
```

## Quick Start

### Prerequisites

- Node.js >= 16.x
- Python >= 3.9
- Docker & Docker Compose
- Git

### Setup

1. **Clone the Repository**

   ```bash
   git clone --recursive https://github.com/yourusername/repository.git
   cd repository
   ```

2. **Install Dependencies**

   ```bash
   # Install JavaScript dependencies
   npm install

   # Install Python dependencies
   pip install -r requirements.txt
   ```

3. **Environment Setup**

   ```bash
   # Copy example env files
   cp .env.example .env
   ```

4. **Start Development Servers**

   ```bash
   npm run dev
   ```

## Development

### Commands

- `npm run dev` - Start all development servers
- `npm run build` - Build all projects
- `npm run test` - Run all tests
- `npm run lint` - Lint all code
- `npm run format` - Format all code

### Project-Specific Commands

#### AI Crypto Price Predictor

- `npm run dev:crypto` - Start crypto predictor development server
- `npm run build:crypto` - Build crypto predictor
- `npm run test:crypto` - Run crypto predictor tests

#### Document OCR System

- `npm run dev:ocr` - Start OCR system development server
- `npm run build:ocr` - Build OCR system
- `npm run test:ocr` - Run OCR system tests

#### Marketing Analytics Tool

- `npm run dev:analytics` - Start analytics tool development server
- `npm run build:analytics` - Build analytics tool
- `npm run test:analytics` - Run analytics tool tests

### Contributing

Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting pull requests.

#### Commit Convention

We use [Conventional Commits](https://www.conventionalcommits.org/). You can use:

```bash
npm run commit
```

This will guide you through the commit process using Commitizen.

### Documentation

- [GitHub Repository Strategy](docs/github-strategy.md)
- [Development Guides](docs/)
- [API Documentation](docs/api/)
- [NocoBase Guide](docs/nocobase-guide.md)

## Security

For security issues, please see our [Security Policy](SECURITY.md).

## Code of Conduct

Please read our [Code of Conduct](CODE_OF_CONDUCT.md) before contributing.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support:

- Open an issue
- Join our community Discord/Slack
- Email support: [INSERT SUPPORT EMAIL]

## Acknowledgments

- NocoBase team for the backend framework
- All contributors and maintainers
- Open source community

## Status

| Project | Status | Coverage |
|---------|--------|----------|
| AI Crypto Price Predictor | [![Status](https://img.shields.io/badge/status-active-success.svg)]() | [![Coverage](https://img.shields.io/codecov/c/github/yourusername/repository/main.svg)]() |
| Document OCR System | [![Status](https://img.shields.io/badge/status-active-success.svg)]() | [![Coverage](https://img.shields.io/codecov/c/github/yourusername/repository/main.svg)]() |
| Marketing Analytics | [![Status](https://img.shields.io/badge/status-active-success.svg)]() | [![Coverage](https://img.shields.io/codecov/c/github/yourusername/repository/main.svg)]() |
| NocoBase Backend | [![Status](https://img.shields.io/badge/status-active-success.svg)]() | [![Coverage](https://img.shields.io/codecov/c/github/yourusername/repository/main.svg)]() |
