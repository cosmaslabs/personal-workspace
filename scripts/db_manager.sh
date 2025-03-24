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
ACTION="status"

# Help message
show_help() {
    echo "Database Management Script"
    echo
    echo "Usage: $0 [-e ENV] [-p PROJECT] [-a ACTION]"
    echo
    echo "Options:"
    echo "  -e ENV      Environment (dev|prod|staging) [default: dev]"
    echo "  -p PROJECT  Project (crypto|ocr|analytics|all) [default: all]"
    echo "  -a ACTION   Action (migrate|rollback|seed|backup|restore|status) [default: status]"
    echo
    echo "Examples:"
    echo "  $0 -e dev -p crypto -a migrate"
    echo "  $0 -e prod -a backup"
    echo "  $0 -p analytics -a seed"
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
if [[ ! "$ACTION" =~ ^(migrate|rollback|seed|backup|restore|status)$ ]]; then
    echo -e "${RED}Invalid action: $ACTION${NC}"
    exit 1
fi

# Load environment variables
if [ -f ".env.$ENV" ]; then
    source ".env.$ENV"
elif [ -f ".env" ]; then
    source ".env"
else
    echo -e "${RED}No environment file found${NC}"
    exit 1
fi

# Database backup directory
BACKUP_DIR="databases/backups"
mkdir -p $BACKUP_DIR

# Project-specific database operations
handle_project() {
    local project=$1
    local base_dir="projects"

    case $project in
        crypto)
            dir="$base_dir/AI_Crypto_Price_Predictor"
            db_name="crypto_db"
            ;;
        ocr)
            dir="$base_dir/Document_Digitization_OCR_System"
            db_name="ocr_db"
            ;;
        analytics)
            dir="$base_dir/University_Marketing_Analytics_Tool"
            db_name="analytics_db"
            ;;
        *)
            echo -e "${RED}Invalid project: $project${NC}"
            return 1
            ;;
    esac

    case $ACTION in
        migrate)
            echo -e "${GREEN}Running migrations for $project...${NC}"
            alembic -c "$dir/alembic.ini" upgrade head
            ;;
        rollback)
            echo -e "${YELLOW}Rolling back migrations for $project...${NC}"
            alembic -c "$dir/alembic.ini" downgrade -1
            ;;
        seed)
            echo -e "${GREEN}Seeding database for $project...${NC}"
            python "$dir/scripts/seed_db.py"
            ;;
        backup)
            echo -e "${GREEN}Backing up database for $project...${NC}"
            timestamp=$(date +%Y%m%d_%H%M%S)
            pg_dump -h $POSTGRES_HOST -U $POSTGRES_USER -d $db_name > "$BACKUP_DIR/${db_name}_${timestamp}.sql"
            ;;
        restore)
            echo -e "${YELLOW}Restoring database for $project...${NC}"
            latest_backup=$(ls -t "$BACKUP_DIR/${db_name}_"*.sql 2>/dev/null | head -1)
            if [ -n "$latest_backup" ]; then
                psql -h $POSTGRES_HOST -U $POSTGRES_USER -d $db_name < "$latest_backup"
            else
                echo -e "${RED}No backup found for $project${NC}"
                return 1
            fi
            ;;
        status)
            echo -e "${GREEN}Checking migration status for $project...${NC}"
            alembic -c "$dir/alembic.ini" current
            alembic -c "$dir/alembic.ini" history
            ;;
    esac
}

# Execute for specified project or all projects
if [ "$PROJECT" = "all" ]; then
    for proj in crypto ocr analytics; do
        echo -e "${GREEN}Processing $proj project...${NC}"
        handle_project $proj
    done
else
    handle_project $PROJECT
fi

echo -e "${GREEN}Database operations completed successfully!${NC}"
