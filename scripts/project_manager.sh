#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Default values
PROJECT="all"
ACTION="status"

# Help message
show_help() {
    echo -e "${BLUE}Project Management Script${NC}"
    echo
    echo "Usage: $0 [-p PROJECT] [-a ACTION]"
    echo
    echo "Options:"
    echo "  -p PROJECT  Project (crypto|ocr|analytics|all) [default: all]"
    echo "  -a ACTION   Action (init|clean|test|lint|docs|deps|status) [default: status]"
    echo
    echo "Actions:"
    echo "  init    - Initialize project structure and dependencies"
    echo "  clean   - Clean up generated files and caches"
    echo "  test    - Run tests with coverage"
    echo "  lint    - Run linters and formatters"
    echo "  docs    - Generate project documentation"
    echo "  deps    - Update project dependencies"
    echo "  status  - Show project status"
    echo
    echo "Examples:"
    echo "  $0 -p crypto -a test"
    echo "  $0 -p all -a lint"
    echo "  $0 -a status"
}

# Parse command line arguments
while getopts "p:a:h" opt; do
    case $opt in
        p) PROJECT="$OPTARG" ;;
        a) ACTION="$OPTARG" ;;
        h) show_help; exit 0 ;;
        ?) show_help; exit 1 ;;
    esac
done

# Validate project
if [[ ! "$PROJECT" =~ ^(crypto|ocr|analytics|all)$ ]]; then
    echo -e "${RED}Invalid project: $PROJECT${NC}"
    exit 1
fi

# Validate action
if [[ ! "$ACTION" =~ ^(init|clean|test|lint|docs|deps|status)$ ]]; then
    echo -e "${RED}Invalid action: $ACTION${NC}"
    exit 1
fi

# Project-specific operations
handle_project() {
    local project=$1
    local base_dir="projects"

    case $project in
        crypto)
            dir="$base_dir/AI_Crypto_Price_Predictor"
            ;;
        ocr)
            dir="$base_dir/Document_Digitization_OCR_System"
            ;;
        analytics)
            dir="$base_dir/University_Marketing_Analytics_Tool"
            ;;
        *)
            echo -e "${RED}Invalid project: $project${NC}"
            return 1
            ;;
    esac

    echo -e "${BLUE}Processing $project project...${NC}"
    cd "$dir"

    case $ACTION in
        init)
            echo -e "${GREEN}Initializing $project...${NC}"
            pip install -r requirements.txt
            pre-commit install
            alembic upgrade head
            ;;
        clean)
            echo -e "${YELLOW}Cleaning $project...${NC}"
            find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
            find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
            find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
            find . -type d -name ".coverage" -exec rm -rf {} + 2>/dev/null || true
            find . -type d -name "htmlcov" -exec rm -rf {} + 2>/dev/null || true
            find . -type d -name "dist" -exec rm -rf {} + 2>/dev/null || true
            find . -type d -name "build" -exec rm -rf {} + 2>/dev/null || true
            ;;
        test)
            echo -e "${GREEN}Testing $project...${NC}"
            pytest --cov=src --cov-report=term-missing --cov-report=html
            ;;
        lint)
            echo -e "${GREEN}Linting $project...${NC}"
            black .
            isort .
            flake8 .
            mypy src
            ;;
        docs)
            echo -e "${GREEN}Generating documentation for $project...${NC}"
            cd docs
            make html
            cd ..
            ;;
        deps)
            echo -e "${GREEN}Updating dependencies for $project...${NC}"
            pip install -U -r requirements.txt
            safety check
            ;;
        status)
            echo -e "${BLUE}Status for $project:${NC}"
            echo -e "${YELLOW}Git Status:${NC}"
            git status --short
            echo -e "\n${YELLOW}Branch Info:${NC}"
            git branch -v
            echo -e "\n${YELLOW}Last 3 Commits:${NC}"
            git log -3 --oneline
            echo -e "\n${YELLOW}Test Coverage:${NC}"
            coverage report || echo "No coverage data found"
            ;;
    esac

    cd - > /dev/null
}

# Execute for specified project or all projects
if [ "$PROJECT" = "all" ]; then
    for proj in crypto ocr analytics; do
        handle_project $proj
    done
else
    handle_project $PROJECT
fi

echo -e "${GREEN}Project operations completed successfully!${NC}"
