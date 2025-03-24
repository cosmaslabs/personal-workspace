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
ACTION="backup"
TYPE="all"
RETENTION=30

# Help message
show_help() {
    echo -e "${PURPLE}Backup Management Script${NC}"
    echo
    echo "Usage: $0 [-a ACTION] [-t TYPE] [-r RETENTION]"
    echo
    echo "Options:"
    echo "  -a ACTION    Action (backup|restore|list|verify|clean) [default: backup]"
    echo "  -t TYPE      Backup type (db|files|config|models|all) [default: all]"
    echo "  -r DAYS      Backup retention in days [default: 30]"
    echo
    echo "Actions:"
    echo "  backup   - Create new backup"
    echo "  restore  - Restore from backup"
    echo "  list     - List available backups"
    echo "  verify   - Verify backup integrity"
    echo "  clean    - Remove old backups"
    echo
    echo "Examples:"
    echo "  $0 -a backup -t db"
    echo "  $0 -a restore -t files"
    echo "  $0 -a list -t all"
}

# Parse command line arguments
while getopts "a:t:r:h" opt; do
    case $opt in
        a) ACTION="$OPTARG" ;;
        t) TYPE="$OPTARG" ;;
        r) RETENTION="$OPTARG" ;;
        h) show_help; exit 0 ;;
        ?) show_help; exit 1 ;;
    esac
done

# Validate action
if [[ ! "$ACTION" =~ ^(backup|restore|list|verify|clean)$ ]]; then
    echo -e "${RED}Invalid action: $ACTION${NC}"
    exit 1
fi

# Validate type
if [[ ! "$TYPE" =~ ^(db|files|config|models|all)$ ]]; then
    echo -e "${RED}Invalid type: $TYPE${NC}"
    exit 1
fi

# Backup directory structure
BACKUP_ROOT="backups"
DB_BACKUP_DIR="$BACKUP_ROOT/databases"
FILES_BACKUP_DIR="$BACKUP_ROOT/files"
CONFIG_BACKUP_DIR="$BACKUP_ROOT/config"
MODELS_BACKUP_DIR="$BACKUP_ROOT/models"

# Create backup directories if they don't exist
mkdir -p "$DB_BACKUP_DIR" "$FILES_BACKUP_DIR" "$CONFIG_BACKUP_DIR" "$MODELS_BACKUP_DIR"

# Function to create backup
create_backup() {
    local type=$1
    local timestamp=$(date +%Y%m%d_%H%M%S)
    echo -e "${BLUE}Creating $type backup...${NC}"

    case $type in
        db)
            # Backup each database
            for db in crypto_db ocr_db analytics_db; do
                echo -e "${YELLOW}Backing up database: $db${NC}"
                docker-compose exec -T postgres pg_dump -U postgres "$db" > \
                    "$DB_BACKUP_DIR/${db}_${timestamp}.sql"
            done
            ;;
        files)
            # Backup uploaded files and data
            tar -czf "$FILES_BACKUP_DIR/files_${timestamp}.tar.gz" \
                data/crypto data/documents
            ;;
        config)
            # Backup configuration files
            tar -czf "$CONFIG_BACKUP_DIR/config_${timestamp}.tar.gz" \
                .env* config/* nginx/conf/*
            ;;
        models)
            # Backup ML models
            tar -czf "$MODELS_BACKUP_DIR/models_${timestamp}.tar.gz" \
                models/crypto/* models/ocr/*
            ;;
    esac
}

# Function to restore backup
restore_backup() {
    local type=$1
    echo -e "${YELLOW}Restoring $type backup...${NC}"

    case $type in
        db)
            # Restore latest database backups
            for db in crypto_db ocr_db analytics_db; do
                latest_backup=$(ls -t "$DB_BACKUP_DIR/${db}_"*.sql 2>/dev/null | head -1)
                if [[ -n "$latest_backup" ]]; then
                    echo -e "${BLUE}Restoring database: $db${NC}"
                    docker-compose exec -T postgres psql -U postgres "$db" < "$latest_backup"
                fi
            done
            ;;
        files)
            latest_backup=$(ls -t "$FILES_BACKUP_DIR/files_"*.tar.gz 2>/dev/null | head -1)
            if [[ -n "$latest_backup" ]]; then
                tar -xzf "$latest_backup" -C /
            fi
            ;;
        config)
            latest_backup=$(ls -t "$CONFIG_BACKUP_DIR/config_"*.tar.gz 2>/dev/null | head -1)
            if [[ -n "$latest_backup" ]]; then
                tar -xzf "$latest_backup" -C /
            fi
            ;;
        models)
            latest_backup=$(ls -t "$MODELS_BACKUP_DIR/models_"*.tar.gz 2>/dev/null | head -1)
            if [[ -n "$latest_backup" ]]; then
                tar -xzf "$latest_backup" -C /
            fi
            ;;
    esac
}

# Function to list backups
list_backups() {
    local type=$1
    echo -e "${BLUE}Available backups for $type:${NC}"

    case $type in
        db)
            ls -lh "$DB_BACKUP_DIR"
            ;;
        files)
            ls -lh "$FILES_BACKUP_DIR"
            ;;
        config)
            ls -lh "$CONFIG_BACKUP_DIR"
            ;;
        models)
            ls -lh "$MODELS_BACKUP_DIR"
            ;;
        all)
            echo -e "${YELLOW}Database backups:${NC}"
            ls -lh "$DB_BACKUP_DIR"
            echo -e "\n${YELLOW}File backups:${NC}"
            ls -lh "$FILES_BACKUP_DIR"
            echo -e "\n${YELLOW}Config backups:${NC}"
            ls -lh "$CONFIG_BACKUP_DIR"
            echo -e "\n${YELLOW}Model backups:${NC}"
            ls -lh "$MODELS_BACKUP_DIR"
            ;;
    esac
}

# Function to verify backup integrity
verify_backup() {
    local type=$1
    echo -e "${BLUE}Verifying $type backups...${NC}"

    case $type in
        db)
            for backup in "$DB_BACKUP_DIR"/*.sql; do
                if [[ -f "$backup" ]]; then
                    echo -e "${YELLOW}Verifying: $(basename "$backup")${NC}"
                    if psql -f "$backup" >/dev/null 2>&1; then
                        echo -e "${GREEN}✓ Valid${NC}"
                    else
                        echo -e "${RED}✗ Invalid${NC}"
                    fi
                fi
            done
            ;;
        files|config|models)
            for backup in "$BACKUP_ROOT/$type"/*.tar.gz; do
                if [[ -f "$backup" ]]; then
                    echo -e "${YELLOW}Verifying: $(basename "$backup")${NC}"
                    if tar -tzf "$backup" >/dev/null 2>&1; then
                        echo -e "${GREEN}✓ Valid${NC}"
                    else
                        echo -e "${RED}✗ Invalid${NC}"
                    fi
                fi
            done
            ;;
    esac
}

# Function to clean old backups
clean_backups() {
    local type=$1
    echo -e "${YELLOW}Cleaning old $type backups (older than $RETENTION days)...${NC}"

    case $type in
        db)
            find "$DB_BACKUP_DIR" -name "*.sql" -type f -mtime +$RETENTION -delete
            ;;
        files)
            find "$FILES_BACKUP_DIR" -name "*.tar.gz" -type f -mtime +$RETENTION -delete
            ;;
        config)
            find "$CONFIG_BACKUP_DIR" -name "*.tar.gz" -type f -mtime +$RETENTION -delete
            ;;
        models)
            find "$MODELS_BACKUP_DIR" -name "*.tar.gz" -type f -mtime +$RETENTION -delete
            ;;
        all)
            find "$BACKUP_ROOT" -type f \( -name "*.sql" -o -name "*.tar.gz" \) -mtime +$RETENTION -delete
            ;;
    esac
}

# Execute requested action
case $ACTION in
    backup)
        if [[ "$TYPE" == "all" ]]; then
            for t in db files config models; do
                create_backup $t
            done
        else
            create_backup $TYPE
        fi
        ;;
    restore)
        if [[ "$TYPE" == "all" ]]; then
            for t in db files config models; do
                restore_backup $t
            done
        else
            restore_backup $TYPE
        fi
        ;;
    list)
        list_backups $TYPE
        ;;
    verify)
        if [[ "$TYPE" == "all" ]]; then
            for t in db files config models; do
                verify_backup $t
            done
        else
            verify_backup $TYPE
        fi
        ;;
    clean)
        if [[ "$TYPE" == "all" ]]; then
            clean_backups all
        else
            clean_backups $TYPE
        fi
        ;;
esac

echo -e "${GREEN}Backup operations completed successfully!${NC}"
