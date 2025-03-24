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
ACTION="status"
SERVICE="all"
LOG_LEVEL="info"

# Help message
show_help() {
    echo -e "${PURPLE}Monitoring and Logging Management Script${NC}"
    echo
    echo "Usage: $0 [-a ACTION] [-s SERVICE] [-l LOG_LEVEL]"
    echo
    echo "Options:"
    echo "  -a ACTION     Action (status|logs|rotate|clean|metrics|alert) [default: status]"
    echo "  -s SERVICE    Service (api|web|worker|db|cache|nginx|all) [default: all]"
    echo "  -l LOG_LEVEL  Log level (debug|info|warn|error) [default: info]"
    echo
    echo "Actions:"
    echo "  status  - Show service status and health"
    echo "  logs    - View service logs"
    echo "  rotate  - Rotate log files"
    echo "  clean   - Clean old logs"
    echo "  metrics - Show service metrics"
    echo "  alert   - View/manage alerts"
    echo
    echo "Examples:"
    echo "  $0 -a logs -s api -l error"
    echo "  $0 -a metrics -s worker"
    echo "  $0 -a status"
}

# Parse command line arguments
while getopts "a:s:l:h" opt; do
    case $opt in
        a) ACTION="$OPTARG" ;;
        s) SERVICE="$OPTARG" ;;
        l) LOG_LEVEL="$OPTARG" ;;
        h) show_help; exit 0 ;;
        ?) show_help; exit 1 ;;
    esac
done

# Validate action
if [[ ! "$ACTION" =~ ^(status|logs|rotate|clean|metrics|alert)$ ]]; then
    echo -e "${RED}Invalid action: $ACTION${NC}"
    exit 1
fi

# Validate service
if [[ ! "$SERVICE" =~ ^(api|web|worker|db|cache|nginx|all)$ ]]; then
    echo -e "${RED}Invalid service: $SERVICE${NC}"
    exit 1
fi

# Validate log level
if [[ ! "$LOG_LEVEL" =~ ^(debug|info|warn|error)$ ]]; then
    echo -e "${RED}Invalid log level: $LOG_LEVEL${NC}"
    exit 1
fi

# Function to handle service status
check_service_status() {
    local service=$1
    echo -e "${BLUE}Checking $service status...${NC}"

    case $service in
        api|web|worker)
            docker-compose ps $service
            docker-compose exec $service health_check.py
            ;;
        db)
            docker-compose exec postgres pg_isready -U postgres
            ;;
        cache)
            docker-compose exec redis redis-cli ping
            ;;
        nginx)
            docker-compose exec nginx nginx -t
            ;;
    esac
}

# Function to view logs
view_logs() {
    local service=$1
    local level=$2
    echo -e "${BLUE}Viewing logs for $service (level: $level)...${NC}"

    if [[ "$service" == "all" ]]; then
        docker-compose logs --tail=100 -f | grep -i "$level"
    else
        docker-compose logs --tail=100 -f "$service" | grep -i "$level"
    fi
}

# Function to rotate logs
rotate_logs() {
    local service=$1
    echo -e "${YELLOW}Rotating logs for $service...${NC}"

    local log_dir="logs/$service"
    if [[ -d "$log_dir" ]]; then
        # Create timestamped backup
        local timestamp=$(date +%Y%m%d_%H%M%S)
        tar -czf "$log_dir/archive_${timestamp}.tar.gz" "$log_dir"/*.log

        # Remove old logs
        find "$log_dir" -name "*.log" -type f -exec rm {} \;

        # Create new log file
        touch "$log_dir/$(date +%Y%m%d).log"

        echo -e "${GREEN}Logs rotated successfully${NC}"
    else
        echo -e "${RED}Log directory not found: $log_dir${NC}"
    fi
}

# Function to clean old logs
clean_logs() {
    local service=$1
    echo -e "${YELLOW}Cleaning old logs for $service...${NC}"

    # Remove logs older than 30 days
    find "logs/$service" -name "*.log" -type f -mtime +30 -exec rm {} \;
    find "logs/$service" -name "archive_*.tar.gz" -type f -mtime +90 -exec rm {} \;

    echo -e "${GREEN}Old logs cleaned successfully${NC}"
}

# Function to show metrics
show_metrics() {
    local service=$1
    echo -e "${BLUE}Showing metrics for $service...${NC}"

    case $service in
        api|web|worker)
            docker stats --no-stream "$service"
            ;;
        db)
            docker-compose exec postgres psql -U postgres -c "SELECT * FROM pg_stat_database;"
            ;;
        cache)
            docker-compose exec redis redis-cli info
            ;;
        nginx)
            docker-compose exec nginx nginx -V
            ;;
        all)
            docker stats --no-stream
            ;;
    esac
}

# Function to handle alerts
handle_alerts() {
    local service=$1
    echo -e "${YELLOW}Checking alerts for $service...${NC}"

    # Check resource usage
    if [[ "$service" == "all" || "$service" == "api" || "$service" == "web" || "$service" == "worker" ]]; then
        docker stats --no-stream | awk '{if($3>90) print "HIGH CPU USAGE: " $1 " (" $3 ")"}'
        docker stats --no-stream | awk '{if($7>90) print "HIGH MEMORY USAGE: " $1 " (" $7 ")"}'
    fi

    # Check disk space
    df -h | awk '{if($5>90) print "LOW DISK SPACE: " $6 " (" $5 " used)"}'

    # Check log sizes
    find logs -type f -size +100M | while read file; do
        echo "LARGE LOG FILE: $file ($(du -h "$file" | cut -f1))"
    done
}

# Execute requested action
case $ACTION in
    status)
        if [[ "$SERVICE" == "all" ]]; then
            for svc in api web worker db cache nginx; do
                check_service_status $svc
            done
        else
            check_service_status $SERVICE
        fi
        ;;
    logs)
        view_logs $SERVICE $LOG_LEVEL
        ;;
    rotate)
        if [[ "$SERVICE" == "all" ]]; then
            for svc in api web worker nginx; do
                rotate_logs $svc
            done
        else
            rotate_logs $SERVICE
        fi
        ;;
    clean)
        if [[ "$SERVICE" == "all" ]]; then
            for svc in api web worker nginx; do
                clean_logs $svc
            done
        else
            clean_logs $SERVICE
        fi
        ;;
    metrics)
        show_metrics $SERVICE
        ;;
    alert)
        handle_alerts $SERVICE
        ;;
esac

echo -e "${GREEN}Monitoring operations completed successfully!${NC}"
