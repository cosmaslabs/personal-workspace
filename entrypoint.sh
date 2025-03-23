#!/bin/bash
set -e

# Function to wait for a service
wait_for_service() {
    local host="$1"
    local port="$2"
    local service="$3"
    local timeout="${4:-30}"

    echo "Waiting for $service to be ready..."
    for i in $(seq 1 $timeout); do
        if nc -z "$host" "$port"; then
            echo "$service is ready!"
            return 0
        fi
        echo "Waiting for $service... $i/$timeout"
        sleep 1
    done
    echo "Timeout waiting for $service"
    return 1
}

# Wait for required services
if [ "$PYTHON_ENV" != "test" ]; then
    wait_for_service "${POSTGRES_HOST:-postgres}" "${POSTGRES_PORT:-5432}" "PostgreSQL"
    wait_for_service "${REDIS_HOST:-redis}" "${REDIS_PORT:-6379}" "Redis"
fi

# Apply database migrations
if [ "$1" = "migrate" ]; then
    echo "Running database migrations..."
    alembic upgrade head
    exit 0
fi

# Create initial admin user if needed
if [ "$1" = "create-admin" ]; then
    echo "Creating admin user..."
    python scripts/create_admin.py
    exit 0
fi

# Start Gunicorn for API
if [ "$1" = "api" ]; then
    echo "Starting API server..."
    exec gunicorn --bind 0.0.0.0:8000 \
        --workers ${API_WORKERS:-4} \
        --threads ${API_THREADS:-2} \
        --worker-class uvicorn.workers.UvicornWorker \
        --timeout 120 \
        --keepalive 5 \
        --max-requests 1000 \
        --max-requests-jitter 50 \
        --access-logfile - \
        --error-logfile - \
        app.main:app
fi

# Start Node.js application
if [ "$1" = "web" ]; then
    echo "Starting web application..."
    if [ "$NODE_ENV" = "production" ]; then
        exec npm run start
    else
        exec npm run dev
    fi
fi

# Start worker processes
if [ "$1" = "worker" ]; then
    echo "Starting Celery worker..."
    exec celery -A app.tasks worker \
        --loglevel=${LOG_LEVEL:-info} \
        --concurrency=${WORKER_CONCURRENCY:-4} \
        --max-tasks-per-child=${MAX_TASKS_PER_CHILD:-1000}
fi

# Start scheduler
if [ "$1" = "scheduler" ]; then
    echo "Starting Celery beat scheduler..."
    exec celery -A app.tasks beat \
        --loglevel=${LOG_LEVEL:-info}
fi

# Start development server
if [ "$1" = "dev" ]; then
    echo "Starting development server..."
    exec uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
fi

# Default: show usage
echo "Usage: $0 {migrate|create-admin|api|web|worker|scheduler|dev}"
exit 1
