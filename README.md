# AI-Driven Portfolio Projects

This repository contains three sophisticated AI-driven projects showcasing diverse applications of machine learning, computer vision, and data analytics.

## Projects Overview

### 1. AI Crypto Price Predictor

- Predicts BTC and ETH price movements with 68% accuracy
- Uses TensorFlow, Python, and CoinGecko API
- Implements LSTM models and sentiment analysis
- Location: `projects/AI_Crypto_Price_Predictor/`

### 2. Document Digitization OCR System

- Processes 500+ daily scanned documents
- Uses OpenCV and Tesseract for OCR
- Features full-text search and document management
- Location: `projects/Document_Digitization_OCR_System/`

### 3. University Marketing Analytics Tool

- Customer segmentation using K-means clustering
- Recommendation engine for 200+ marketing students
- Uses Python, scikit-learn, and Plotly Dash
- Location: `projects/University_Marketing_Analytics_Tool/`

## Backend Integration

This repository integrates with NocoBase as a backend service, providing:

- RESTful API endpoints for all projects
- Database management
- User authentication
- Admin dashboard

## Repository Structure

```
.
├── projects/
│   ├── AI_Crypto_Price_Predictor/
│   ├── Document_Digitization_OCR_System/
│   └── University_Marketing_Analytics_Tool/
├── nocobase/          # Backend service
├── databases/         # Database configurations
├── docs/             # Documentation
├── logs/             # Application logs
└── scripts/          # Utility scripts
```

## Getting Started

1. Clone the repository:

```bash
git clone [repository-url]
cd [repository-name]
```

2. Set up NocoBase backend:

```bash
cd nocobase
yarn install --frozen-lockfile
yarn nocobase install --lang=en-US
```

3. Set up individual projects:

- Each project has its own setup instructions in its respective directory
- Follow the development guide in each project's docs folder

## Development Workflow

1. Branch Naming Convention:

- Feature: `feature/project-name/feature-description`
- Bug Fix: `fix/project-name/bug-description`
- Enhancement: `enhance/project-name/description`

2. Commit Message Format:

```
type(scope): description

[optional body]
[optional footer]
```

3. Pull Request Process:

- Create PR from your feature branch to `develop`
- Require code review before merging
- Ensure all tests pass
- Update documentation as needed

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to your fork
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
