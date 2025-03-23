#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Print step message
step() {
    echo -e "${GREEN}==> ${1}${NC}"
}

# Print error message
error() {
    echo -e "${RED}ERROR: ${1}${NC}"
    exit 1
}

# Print warning message
warn() {
    echo -e "${YELLOW}WARNING: ${1}${NC}"
}

# Check prerequisites
check_prerequisites() {
    step "Checking prerequisites..."

    command -v docker >/dev/null 2>&1 || error "Docker is not installed"
    command -v docker-compose >/dev/null 2>&1 || error "Docker Compose is not installed"
    command -v python3 >/dev/null 2>&1 || error "Python 3 is not installed"
    command -v node >/dev/null 2>&1 || error "Node.js is not installed"
    command -v npm >/dev/null 2>&1 || error "npm is not installed"
    command -v git >/dev/null 2>&1 || error "git is not installed"
}

# Set up environment
setup_environment() {
    step "Setting up environment..."

    if [ ! -f .env ]; then
        cp .env.example .env
        echo "Created .env file from example"
    else
        warn ".env file already exists, skipping"
    fi
}

# Install dependencies
install_dependencies() {
    step "Installing Python dependencies..."
    python3 -m pip install --upgrade pip
    pip install -r requirements.txt

    step "Installing Node.js dependencies..."
    npm install

    step "Setting up git hooks..."
    npm run prepare
}

# Create necessary directories
create_directories() {
    step "Creating project directories..."

    mkdir -p logs
    mkdir -p data/{crypto,documents}
    mkdir -p models/crypto
    mkdir -p nginx/{logs,certs}
}

# Initialize database
init_database() {
    step "Initializing database..."

    if [ -f ".env" ]; then
        source .env
        docker-compose up -d postgres
        sleep 5 # Wait for database to be ready

        echo "Running database migrations..."
        docker-compose run --rm app ./entrypoint.sh migrate

        echo "Creating admin user..."
        docker-compose run --rm app ./entrypoint.sh create-admin
    else
        error ".env file not found"
    fi
}

# Generate self-signed certificates for development
generate_certs() {
    step "Generating self-signed certificates..."

    if [ ! -f "nginx/certs/server.crt" ]; then
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -keyout nginx/certs/server.key \
            -out nginx/certs/server.crt \
            -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
        echo "Generated self-signed certificates"
    else
        warn "Certificates already exist, skipping"
    fi
}

# Main setup process
main() {
    echo "Starting project setup..."

    check_prerequisites
    setup_environment
    install_dependencies
    create_directories
    init_database
    generate_certs

    step "Setup complete! 🎉"
    echo -e "\nNext steps:"
    echo "1. Review and update the .env file with your settings"
    echo "2. Start the development environment: docker-compose -f docker-compose.dev.yml up"
    echo "3. Visit http://localhost:3000 to access the application"
}

# Run main function
main
