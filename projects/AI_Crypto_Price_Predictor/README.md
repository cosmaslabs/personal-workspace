# AI Crypto Price Predictor

## Project Overview

An advanced cryptocurrency price prediction system leveraging multiple AI approaches to forecast BTC and ETH prices with approximately 68% accuracy. The system combines traditional deep learning with modern LLM capabilities, integrated with NocoBase for robust data management and API services.

## Technical Architecture

### Core Components

1. **Data Pipeline**
   - CoinGecko API Integration
   - NocoBase data storage & retrieval
   - Real-time data streaming
   - Historical data management
   - Feature engineering pipeline

2. **AI/ML Stack**
   - LLM Integration:
     - GitHub Copilot
     - OpenAI GPT API
     - Claude API
     - Custom LLM plugin for NocoBase
   - Deep Learning:
     - TensorFlow 2.x
     - PyTorch 2.0+
   - Data Science:
     - pandas-ta (Technical Analysis)
     - scikit-learn
     - NumPy

3. **Infrastructure**
   - NocoBase backend
   - Docker containerization
   - MLflow experiment tracking
   - FastAPI backend
   - Redis caching
   - PostgreSQL data warehouse

### NocoBase Integration

```typescript
// nocobase/plugins/crypto-predictor/src/server.ts
export default {
  name: 'crypto-predictor',
  async load() {
    // Register custom collections
    this.db.collection({
      name: 'price_predictions',
      fields: [
        {
          type: 'string',
          name: 'cryptocurrency',
        },
        {
          type: 'float',
          name: 'predicted_price',
        },
        {
          type: 'float',
          name: 'confidence_score',
        },
      ],
    });

    // Register custom actions
    this.app.resource({
      name: 'predictions',
      actions: {
        async predict(ctx) {
          const model = await loadModel();
          const prediction = await model.predict(ctx.request.body);
          return { prediction };
        },
      },
    });
  },
};
```

## Development Setup

### Prerequisites

```bash
# System requirements
Python 3.8+
CUDA 11.0+ (for GPU support)
Node.js 16+ (for NocoBase)
Docker Desktop
PostgreSQL 10+
```

### Environment Setup

```bash
# 1. Set up NocoBase
cd nocobase
yarn install
yarn build
yarn start

# 2. Set up prediction service
cd ../projects/AI_Crypto_Price_Predictor
python -m venv venv
source venv/bin/activate  # or `venv\Scripts\activate` on Windows
pip install -r requirements.txt
pip install -r requirements-dev.txt
```

### API Configuration

```python
# .env file structure
NOCOBASE_API_BASE_URL=http://localhost:13000/api
NOCOBASE_API_KEY=your_key_here
COINGECKO_API_KEY=your_key_here
OPENAI_API_KEY=your_key_here
CLAUDE_API_KEY=your_key_here
DATABASE_URL=postgresql://user:pass@localhost:5432/crypto_db
```

## AI Learning Path

### 1. Fundamental Concepts

```python
# Example: Understanding time series prediction
from src.models.baseline import SimpleMovingAverage

class TimeSeriesBasics:
    def demonstrate_moving_average(self, data: pd.Series, window: int):
        """
        Educational example of moving average calculation
        """
        ma = SimpleMovingAverage(window=window)
        result = ma.calculate(data)

        # Visualization for learning
        plt.figure(figsize=(12, 6))
        plt.plot(data, label='Original')
        plt.plot(result, label=f'{window}-period MA')
        plt.legend()
        plt.title('Understanding Moving Averages')
        return plt
```

### 2. Advanced Topics

```python
# Example: LLM-enhanced feature engineering
class LLMFeatureEngineer:
    def extract_market_sentiment(self, news_data: List[str]) -> float:
        """
        Demonstrate LLM-based sentiment analysis
        """
        prompt = self._create_educational_prompt(news_data)
        sentiment = self.llm.analyze(prompt)

        # Educational logging
        logger.info(f"Prompt structure: {prompt}")
        logger.info(f"LLM reasoning: {sentiment.explanation}")
        return sentiment.score
```

### 3. Model Development Journey

```python
# Progressive model implementation
class ModelProgression:
    def __init__(self):
        self.models = {
            'baseline': SimpleMovingAverage(),
            'intermediate': LSTMModel(),
            'advanced': HybridLLMModel()
        }

    def compare_models(self, data: pd.DataFrame):
        """
        Educational comparison of different approaches
        """
        results = {}
        for name, model in self.models.items():
            results[name] = {
                'prediction': model.predict(data),
                'explanation': model.explain()
            }
        return results
```

## Project Structure

```
.
├── nocobase/
│   └── plugins/
│       └── crypto-predictor/     # NocoBase plugin
├── data/                         # Data storage
│   ├── raw/                     # Raw API data
│   └── processed/               # Processed datasets
├── models/                      # Saved models
│   ├── llm/                    # LLM configurations
│   ├── tensorflow/             # TensorFlow models
│   └── pytorch/                # PyTorch models
├── notebooks/                  # Jupyter notebooks
│   ├── tutorials/             # Learning materials
│   ├── analysis/              # Data analysis
│   ├── modeling/              # Model development
│   └── evaluation/            # Performance evaluation
├── src/                       # Source code
│   ├── data/                 # Data management
│   ├── models/               # Model implementations
│   ├── api/                 # API endpoints
│   └── utils/               # Utilities
└── tests/                   # Test suites
```

## Educational Resources

### 1. Interactive Tutorials

- Jupyter notebooks with step-by-step explanations
- Real-time model training visualization
- Performance metric analysis
- Error analysis and debugging guides

### 2. Model Development Progression

- Baseline implementation
- Feature engineering techniques
- Advanced model architectures
- Ensemble methods
- LLM integration strategies

### 3. Best Practices

- Code quality standards
- Testing methodologies
- Documentation guidelines
- Performance optimization
- Security considerations

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for contribution guidelines.

## License

MIT License - See [LICENSE.md](./LICENSE.md) for details
