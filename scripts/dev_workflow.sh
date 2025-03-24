#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Default values
WORKFLOW="setup"
PROJECT="all"

# Help message
show_help() {
    echo -e "${PURPLE}Development Workflow Helper${NC}"
    echo
    echo "Usage: $0 [-w WORKFLOW] [-p PROJECT]"
    echo
    echo "Options:"
    echo "  -w WORKFLOW  Workflow (setup|start|stop|update|release) [default: setup]"
    echo "  -p PROJECT   Project (crypto|ocr|analytics|all) [default: all]"
    echo
    echo "Workflows:"
    echo "  setup   - Initial project setup (install deps, setup hooks, init db)"
    echo "  start   - Start development environment"
    echo "  stop    - Stop development environment"
    echo "  update  - Update dependencies and run migrations"
    echo "  release - Prepare for release (tests, docs, version bump)"
    echo
    echo "Examples:"
    echo "  $0 -w setup -p crypto"
    echo "  $0 -w start"
    echo "  $0 -w release -p analytics"
}

# Parse command line arguments
while getopts "w:p:h" opt; do
    case $opt in
        w) WORKFLOW="$OPTARG" ;;
        p) PROJECT="$OPTARG" ;;
        h) show_help; exit 0 ;;
        ?) show_help; exit 1 ;;
    esac
done

# Validate workflow
if [[ ! "$WORKFLOW" =~ ^(setup|start|stop|update|release)$ ]]; then
    echo -e "${RED}Invalid workflow: $WORKFLOW${NC}"
    exit 1
fi

# Validate project
if [[ ! "$PROJECT" =~ ^(crypto|ocr|analytics|all)$ ]]; then
    echo -e "${RED}Invalid project: $PROJECT${NC}"
    exit 1
fi

# Function to run workflow for a specific project
run_workflow() {
    local project=$1
    echo -e "${BLUE}Running $WORKFLOW workflow for $project...${NC}"

    case $WORKFLOW in
        setup)
            # Initial setup
            echo -e "${GREEN}Setting up $project...${NC}"
            ./scripts/project_manager.sh -p $project -a init
            ./scripts/setup_hooks.sh
            ./scripts/db_manager.sh -p $project -a migrate
            ;;
        start)
            # Start development environment
            echo -e "${GREEN}Starting development environment for $project...${NC}"
            ./scripts/docker_helper.sh -e dev -p $project -a start
            ;;
        stop)
            # Stop development environment
            echo -e "${YELLOW}Stopping development environment for $project...${NC}"
            ./scripts/docker_helper.sh -e dev -p $project -a stop
            ;;
        update)
            # Update dependencies and database
            echo -e "${GREEN}Updating $project...${NC}"
            ./scripts/project_manager.sh -p $project -a deps
            ./scripts/db_manager.sh -p $project -a migrate
            ;;
        release)
            # Prepare for release
            echo -e "${GREEN}Preparing release for $project...${NC}"
            # Run tests
            ./scripts/project_manager.sh -p $project -a test
            if [ $? -ne 0 ]; then
                echo -e "${RED}Tests failed! Aborting release preparation.${NC}"
                exit 1
            fi
            # Run linting
            ./scripts/project_manager.sh -p $project -a lint
            # Generate docs
            ./scripts/project_manager.sh -p $project -a docs
            # Create database backup
            ./scripts/db_manager.sh -p $project -a backup
            # Show status
            ./scripts/project_manager.sh -p $project -a status
            ;;
    esac
}

# Execute workflow for specified project or all projects
if [ "$PROJECT" = "all" ]; then
    for proj in crypto ocr analytics; do
        run_workflow $proj
    done
else
    run_workflow $PROJECT
fi

case $WORKFLOW in
    setup)
        echo -e "${GREEN}Setup completed! You can now start development with:${NC}"
        echo -e "  $0 -w start"
        ;;
    start)
        echo -e "${GREEN}Development environment is running.${NC}"
        echo -e "To view logs: ${YELLOW}./scripts/docker_helper.sh -a logs${NC}"
        ;;
    stop)
        echo -e "${YELLOW}Development environment stopped.${NC}"
        ;;
    update)
        echo -e "${GREEN}Update completed! Consider restarting the development environment:${NC}"
        echo -e "  $0 -w restart"
        ;;
    release)
        echo -e "${GREEN}Release preparation completed!${NC}"
        echo -e "Next steps:"
        echo -e "1. Review the changes"
        echo -e "2. Update CHANGELOG.md"
        echo -e "3. Create a release branch"
        echo -e "4. Submit a pull request"
        ;;
esac

echo -e "${GREEN}Workflow completed successfully!${NC}"
