# Multi-stage build for AI-Driven Applications
# Stage 1: Python base
FROM python:3.9-slim as python-base

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        build-essential \
        tesseract-ocr \
        libtesseract-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Stage 2: Node.js builder
FROM node:16-alpine as node-builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./
COPY tsconfig*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build JavaScript/TypeScript applications
RUN npm run build

# Stage 3: Python builder
FROM python-base as python-builder

# Set working directory
WORKDIR /app

# Copy Python requirements
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY . .

# Build Python packages
RUN python -m compileall .

# Stage 4: Final production image
FROM python-base

# Set working directory
WORKDIR /app

# Copy built artifacts from builders
COPY --from=node-builder /app/dist ./dist
COPY --from=python-builder /app/__pycache__ ./__pycache__
COPY --from=python-builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

# Copy necessary files
COPY requirements.txt .
COPY package.json .
COPY entrypoint.sh /entrypoint.sh

# Set up project structure
RUN mkdir -p \
    logs \
    data/crypto \
    data/documents \
    models/crypto

# Make entrypoint executable
RUN chmod +x /entrypoint.sh

# Set production environment
ENV NODE_ENV=production \
    PYTHON_ENV=production

# Expose necessary ports
EXPOSE 3000 8000

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

# Set entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Default command
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "--threads", "2", "app.main:app"]
