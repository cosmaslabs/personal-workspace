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
ENV="dev"
ACTION="create"

# Help message
show_help() {
    echo -e "${PURPLE}Environment Setup Script${NC}"
    echo
    echo "Usage: $0 [-e ENV] [-a ACTION]"
    echo
    echo "Options:"
    echo "  -e ENV     Environment (dev|staging|prod) [default: dev]"
    echo "  -a ACTION  Action (create|update|validate|encrypt|decrypt) [default: create]"
    echo
    echo "Actions:"
    echo "  create   - Create new environment configuration"
    echo "  update   - Update existing environment configuration"
    echo "  validate - Validate environment configuration"
    echo "  encrypt  - Encrypt sensitive environment variables"
    echo "  decrypt  - Decrypt sensitive environment variables"
    echo
    echo "Examples:"
    echo "  $0 -e prod -a create"
    echo "  $0 -e staging -a update"
    echo "  $0 -a validate"
}

# Parse command line arguments
while getopts "e:a:h" opt; do
    case $opt in
        e) ENV="$OPTARG" ;;
        a) ACTION="$OPTARG" ;;
        h) show_help; exit 0 ;;
        ?) show_help; exit 1 ;;
    esac
done

# Validate environment
if [[ ! "$ENV" =~ ^(dev|staging|prod)$ ]]; then
    echo -e "${RED}Invalid environment: $ENV${NC}"
    exit 1
fi

# Validate action
if [[ ! "$ACTION" =~ ^(create|update|validate|encrypt|decrypt)$ ]]; then
    echo -e "${RED}Invalid action: $ACTION${NC}"
    exit 1
fi

# Required environment variables
declare -A REQUIRED_VARS=(
    ["POSTGRES_USER"]="Database username"
    ["POSTGRES_PASSWORD"]="Database password"
    ["POSTGRES_DB"]="Database name"
    ["REDIS_HOST"]="Redis host"
    ["REDIS_PORT"]="Redis port"
    ["REDIS_PASSWORD"]="Redis password"
    ["JWT_SECRET"]="JWT secret key"
    ["API_KEY"]="API access key"
    ["NODE_ENV"]="Node environment"
    ["PYTHON_ENV"]="Python environment"
)

# Function to generate secure random string
generate_secure_string() {
    openssl rand -base64 32
}

# Function to encrypt sensitive data
encrypt_value() {
    local value="$1"
    echo "$value" | openssl enc -aes-256-cbc -a -salt -pass pass:"$ENCRYPTION_KEY"
}

# Function to decrypt sensitive data
decrypt_value() {
    local value="$1"
    echo "$value" | openssl enc -aes-256-cbc -d -a -salt -pass pass:"$ENCRYPTION_KEY"
}

# Function to create/update environment file
setup_env_file() {
    local env_file=".env.$ENV"
    local action=$1
    local existing_vars=()

    # Load existing variables if updating
    if [[ "$action" == "update" && -f "$env_file" ]]; then
        while IFS='=' read -r key value; do
            if [[ ! "$key" =~ ^# && -n "$key" ]]; then
                existing_vars+=("$key")
            fi
        done < "$env_file"
    fi

    echo -e "${BLUE}Setting up $env_file...${NC}"

    # Create or truncate file
    if [[ "$action" == "create" ]]; then
        echo "# Environment configuration for $ENV" > "$env_file"
        echo "# Generated on $(date)" >> "$env_file"
        echo "" >> "$env_file"
    fi

    # Add or update variables
    for var in "${!REQUIRED_VARS[@]}"; do
        local desc="${REQUIRED_VARS[$var]}"
        local current_value=""

        # Check if variable exists in current environment
        if [[ "$action" == "update" ]]; then
            current_value=$(grep "^$var=" "$env_file" | cut -d'=' -f2- || echo "")
        fi

        echo -e "${YELLOW}$var - $desc${NC}"
        if [[ -n "$current_value" ]]; then
            echo -e "Current value: [hidden]"
            read -p "Enter new value (press Enter to keep current): " value
            value=${value:-$current_value}
        else
            read -p "Enter value (press Enter for random): " value
            value=${value:-$(generate_secure_string)}
        fi

        echo "$var=$value" >> "$env_file.tmp"
    done

    # Replace original file with temporary file
    mv "$env_file.tmp" "$env_file"
}

# Function to validate environment file
validate_env() {
    local env_file=".env.$ENV"
    local missing_vars=()
    local status=0

    echo -e "${BLUE}Validating $env_file...${NC}"

    if [[ ! -f "$env_file" ]]; then
        echo -e "${RED}Environment file $env_file does not exist!${NC}"
        exit 1
    fi

    # Check for required variables
    for var in "${!REQUIRED_VARS[@]}"; do
        if ! grep -q "^$var=" "$env_file"; then
            missing_vars+=("$var")
            status=1
        fi
    done

    # Report validation results
    if [[ ${#missing_vars[@]} -eq 0 ]]; then
        echo -e "${GREEN}All required variables are present!${NC}"
    else
        echo -e "${RED}Missing required variables:${NC}"
        for var in "${missing_vars[@]}"; do
            echo -e "${YELLOW}- $var: ${REQUIRED_VARS[$var]}${NC}"
        done
    fi

    return $status
}

# Execute requested action
case $ACTION in
    create)
        setup_env_file "create"
        ;;
    update)
        setup_env_file "update"
        ;;
    validate)
        validate_env
        ;;
    encrypt)
        echo -e "${YELLOW}Enter encryption key:${NC}"
        read -s ENCRYPTION_KEY
        echo
        for env_file in .env.*; do
            if [[ -f "$env_file" && "$env_file" != *.enc ]]; then
                echo -e "${BLUE}Encrypting $env_file...${NC}"
                encrypt_value "$(cat "$env_file")" > "$env_file.enc"
            fi
        done
        ;;
    decrypt)
        echo -e "${YELLOW}Enter encryption key:${NC}"
        read -s ENCRYPTION_KEY
        echo
        for env_file in .env.*.enc; do
            if [[ -f "$env_file" ]]; then
                output_file=${env_file%.enc}
                echo -e "${BLUE}Decrypting $env_file to $output_file...${NC}"
                decrypt_value "$(cat "$env_file")" > "$output_file"
            fi
        done
        ;;
esac

echo -e "${GREEN}Environment setup completed successfully!${NC}"
