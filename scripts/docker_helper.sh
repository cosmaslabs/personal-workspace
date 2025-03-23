#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Default values
ENV="dev"
PROJECT="all"
ACTION="start"

# Help message
show_help() {
    echo "Docker Environment Helper Script"
    echo
    echo "Usage: $0 [-e ENV] [-p PROJECT] [-a ACTION]"
    echo
    echo "Options:"
    echo "  -e ENV      Environment (dev|prod|staging) [default: dev]"
    echo "  -p PROJECT  Project (crypto|ocr|analytics|all) [default: all]"
    echo "  -a ACTION   Action (start|stop|restart|build|logs|clean) [default: start]"
    echo
    echo "Examples:"
    echo "  $0 -e dev -p crypto -a start"
    echo "  $0 -e prod -a build"
    echo "  $0 -p ocr -a logs"
}

# Parse command line arguments
while getopts "e:p:a:h" opt; do
    case $opt in
        e) ENV="$OPTARG" ;;
        p) PROJECT="$OPTARG" ;;
        a) ACTION="$OPTARG" ;;
        h) show_help; exit 0 ;;
        ?) show_help; exit 1 ;;
    esac
done

# Validate environment
if [[ ! "$ENV" =~ ^(dev|prod|staging)$ ]]; then
    echo -e "${RED}Invalid environment: $ENV${NC}"
    exit 1
fi

# Validate project
if [[ ! "$PROJECT" =~ ^(crypto|ocr|analytics|all)$ ]]; then
    echo -e "${RED}Invalid project: $PROJECT${NC}"
    exit 1
fi

# Validate action
if [[ ! "$ACTION" =~ ^(start|stop|restart|build|logs|clean)$ ]]; then
    echo -e "${RED}Invalid action: $ACTION${NC}"
    exit 1
fi

# Docker compose file selection
COMPOSE_FILE="docker-compose.yml"
if [ "$ENV" = "dev" ]; then
    COMPOSE_FILE="docker-compose.dev.yml"
elif [ "$ENV" = "staging" ]; then
    COMPOSE_FILE="docker-compose.staging.yml"
fi

# Project selection
PROJECT_FILTER=""
case $PROJECT in
    crypto) PROJECT_FILTER="ai-crypto-predictor" ;;
    ocr) PROJECT_FILTER="document-ocr" ;;
    analytics) PROJECT_FILTER="marketing-analytics" ;;
    all) PROJECT_FILTER="" ;;
esac

# Execute action
case $ACTION in
    start)
        echo -e "${GREEN}Starting $PROJECT services in $ENV environment...${NC}"
        if [ -n "$PROJECT_FILTER" ]; then
            docker-compose -f $COMPOSE_FILE up -d $PROJECT_FILTER
        else
            docker-compose -f $COMPOSE_FILE up -d
        fi
        ;;
    stop)
        echo -e "${YELLOW}Stopping $PROJECT services in $ENV environment...${NC}"
        if [ -n "$PROJECT_FILTER" ]; then
            docker-compose -f $COMPOSE_FILE stop $PROJECT_FILTER
        else
            docker-compose -f $COMPOSE_FILE stop
        fi
        ;;
    restart)
        echo -e "${YELLOW}Restarting $PROJECT services in $ENV environment...${NC}"
        if [ -n "$PROJECT_FILTER" ]; then
            docker-compose -f $COMPOSE_FILE restart $PROJECT_FILTER
        else
            docker-compose -f $COMPOSE_FILE restart
        fi
        ;;
    build)
        echo -e "${GREEN}Building $PROJECT services for $ENV environment...${NC}"
        if [ -n "$PROJECT_FILTER" ]; then
            docker-compose -f $COMPOSE_FILE build $PROJECT_FILTER
        else
            docker-compose -f $COMPOSE_FILE build
        fi
        ;;
    logs)
        echo -e "${GREEN}Showing logs for $PROJECT services in $ENV environment...${NC}"
        if [ -n "$PROJECT_FILTER" ]; then
            docker-compose -f $COMPOSE_FILE logs -f $PROJECT_FILTER
        else
            docker-compose -f $COMPOSE_FILE logs -f
        fi
        ;;
    clean)
        echo -e "${RED}Cleaning up $PROJECT services in $ENV environment...${NC}"
        if [ -n "$PROJECT_FILTER" ]; then
            docker-compose -f $COMPOSE_FILE rm -f $PROJECT_FILTER
        else
            docker-compose -f $COMPOSE_FILE down -v --remove-orphans
            echo -e "${YELLOW}Removing unused images...${NC}"
            docker image prune -f
        fi
        ;;
esac

echo -e "${GREEN}Operation completed successfully!${NC}"
