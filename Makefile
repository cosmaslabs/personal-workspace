# Makefile for AI-Driven Applications

# Variables
PYTHON = python3
PIP = pip
NPM = npm
DOCKER = docker
DOCKER_COMPOSE = docker-compose
DOCKER_COMPOSE_DEV = docker-compose -f docker-compose.dev.yml
MKDOCS = mkdocs

.PHONY: help install dev build test lint docs clean deploy

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo
	@echo 'Targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install: ## Install all dependencies
	$(PIP) install -r requirements.txt
	$(NPM) install

dev: ## Start development environment
	$(DOCKER_COMPOSE_DEV) up --build

build: ## Build all projects
	$(DOCKER) build -t ai-crypto-predictor -f projects/AI_Crypto_Price_Predictor/Dockerfile .
	$(DOCKER) build -t document-ocr -f projects/Document_Digitization_OCR_System/Dockerfile .
	$(DOCKER) build -t marketing-analytics -f projects/University_Marketing_Analytics_Tool/Dockerfile .

test: ## Run all tests
	$(PYTHON) -m pytest
	$(NPM) test

lint: ## Run linters and formatters
	black .
	isort .
	flake8
	$(NPM) run lint
	$(NPM) run format

docs: ## Build documentation
	$(MKDOCS) build

docs-serve: ## Serve documentation locally
	$(MKDOCS) serve

clean: ## Clean up generated files
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	find . -type f -name "*.pyo" -delete
	find . -type f -name "*.pyd" -delete
	find . -type f -name ".coverage" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	find . -type d -name "*.egg" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
	find . -type d -name ".mypy_cache" -exec rm -rf {} +
	find . -type d -name ".hypothesis" -exec rm -rf {} +
	find . -type d -name "node_modules" -exec rm -rf {} +
	find . -type d -name "dist" -exec rm -rf {} +
	find . -type d -name "build" -exec rm -rf {} +
	rm -rf .coverage htmlcov/ .tox/ .nox/

deploy-staging: ## Deploy to staging environment
	@echo "Deploying to staging..."
	$(DOCKER_COMPOSE) -f docker-compose.yml up -d

deploy-prod: ## Deploy to production environment
	@echo "Deploying to production..."
	$(DOCKER_COMPOSE) -f docker-compose.prod.yml up -d

migrate: ## Run database migrations
	$(DOCKER_COMPOSE) run --rm app ./entrypoint.sh migrate

create-admin: ## Create admin user
	$(DOCKER_COMPOSE) run --rm app ./entrypoint.sh create-admin

logs: ## View application logs
	$(DOCKER_COMPOSE) logs -f

update-deps: ## Update dependencies
	$(PIP) install -U pip
	$(PIP) install -U -r requirements.txt
	$(NPM) update

security-check: ## Run security checks
	safety check
	bandit -r .
	npm audit

version: ## Show versions of core dependencies
	@echo "Python version:"
	@$(PYTHON) --version
	@echo "\nPip version:"
	@$(PIP) --version
	@echo "\nNode version:"
	@node --version
	@echo "\nNpm version:"
	@$(NPM) --version
	@echo "\nDocker version:"
	@$(DOCKER) --version
	@echo "\nDocker Compose version:"
	@$(DOCKER_COMPOSE) --version
