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
ACTION="check"
SCOPE="all"

# Help message
show_help() {
    echo -e "${PURPLE}Dependency Management Script${NC}"
    echo
    echo "Usage: $0 [-a ACTION] [-s SCOPE]"
    echo
    echo "Options:"
    echo "  -a ACTION  Action (check|update|audit|sync|list|freeze) [default: check]"
    echo "  -s SCOPE   Scope (python|node|all) [default: all]"
    echo
    echo "Actions:"
    echo "  check   - Check for outdated dependencies"
    echo "  update  - Update dependencies to latest versions"
    echo "  audit   - Run security audit on dependencies"
    echo "  sync    - Synchronize dependencies across projects"
    echo "  list    - List all dependencies"
    echo "  freeze  - Create frozen requirements files"
    echo
    echo "Examples:"
    echo "  $0 -a check -s python"
    echo "  $0 -a update"
    echo "  $0 -a audit -s node"
}

# Parse command line arguments
while getopts "a:s:h" opt; do
    case $opt in
        a) ACTION="$OPTARG" ;;
        s) SCOPE="$OPTARG" ;;
        h) show_help; exit 0 ;;
        ?) show_help; exit 1 ;;
    esac
done

# Validate action
if [[ ! "$ACTION" =~ ^(check|update|audit|sync|list|freeze)$ ]]; then
    echo -e "${RED}Invalid action: $ACTION${NC}"
    exit 1
fi

# Validate scope
if [[ ! "$SCOPE" =~ ^(python|node|all)$ ]]; then
    echo -e "${RED}Invalid scope: $SCOPE${NC}"
    exit 1
fi

# Function to handle Python dependencies
handle_python_deps() {
    local action=$1
    echo -e "${BLUE}Managing Python dependencies...${NC}"

    case $action in
        check)
            echo -e "${YELLOW}Checking for outdated Python packages...${NC}"
            pip list --outdated
            ;;
        update)
            echo -e "${GREEN}Updating Python packages...${NC}"
            pip install -U pip
            pip install -U -r requirements.txt
            for project in projects/*/requirements.txt; do
                echo -e "${YELLOW}Updating $project...${NC}"
                pip install -U -r "$project"
            done
            ;;
        audit)
            echo -e "${YELLOW}Running security audit on Python packages...${NC}"
            safety check
            pip-audit
            ;;
        sync)
            echo -e "${GREEN}Synchronizing Python dependencies across projects...${NC}"
            # Create temporary merged requirements file
            tempfile=$(mktemp)
            cat requirements.txt projects/*/requirements.txt > "$tempfile"
            # Sort and deduplicate
            sort -u "$tempfile" > requirements.txt
            # Update project-specific requirements
            for project in projects/*/requirements.txt; do
                cp requirements.txt "$project"
            done
            rm "$tempfile"
            ;;
        list)
            echo -e "${BLUE}Listing Python packages...${NC}"
            pip list
            ;;
        freeze)
            echo -e "${GREEN}Creating frozen requirements...${NC}"
            pip freeze > requirements.frozen.txt
            ;;
    esac
}

# Function to handle Node.js dependencies
handle_node_deps() {
    local action=$1
    echo -e "${BLUE}Managing Node.js dependencies...${NC}"

    case $action in
        check)
            echo -e "${YELLOW}Checking for outdated Node.js packages...${NC}"
            npm outdated
            ;;
        update)
            echo -e "${GREEN}Updating Node.js packages...${NC}"
            npm update
            npm install
            ;;
        audit)
            echo -e "${YELLOW}Running security audit on Node.js packages...${NC}"
            npm audit
            ;;
        sync)
            echo -e "${GREEN}Synchronizing Node.js dependencies...${NC}"
            # Update all project package.json files
            for project in projects/*/package.json; do
                echo -e "${YELLOW}Syncing $project...${NC}"
                jq -s '.[0].dependencies * .[1].dependencies' \
                    package.json "$project" > temp.json && \
                    jq --arg project "$project" \
                    '.dependencies' temp.json > "$project"
                rm temp.json
            done
            ;;
        list)
            echo -e "${BLUE}Listing Node.js packages...${NC}"
            npm list
            ;;
        freeze)
            echo -e "${GREEN}Creating package-lock.json...${NC}"
            npm shrinkwrap
            ;;
    esac
}

# Execute for specified scope
case $SCOPE in
    python)
        handle_python_deps "$ACTION"
        ;;
    node)
        handle_node_deps "$ACTION"
        ;;
    all)
        handle_python_deps "$ACTION"
        handle_node_deps "$ACTION"
        ;;
esac

# Post-action messaging
case $ACTION in
    check)
        echo -e "${YELLOW}Review outdated packages and consider updating.${NC}"
        ;;
    update)
        echo -e "${GREEN}Dependencies updated! Consider running tests:${NC}"
        echo "  ./scripts/project_manager.sh -a test"
        ;;
    audit)
        echo -e "${YELLOW}Review security audit results and address any issues.${NC}"
        ;;
    sync)
        echo -e "${GREEN}Dependencies synchronized! Commit changes:${NC}"
        echo "  git add requirements.txt projects/*/requirements.txt"
        echo "  git commit -m 'chore: sync dependencies'"
        ;;
    list)
        echo -e "${BLUE}Review the list of installed packages.${NC}"
        ;;
    freeze)
        echo -e "${GREEN}Requirements frozen! Consider committing:${NC}"
        echo "  git add requirements.frozen.txt package-lock.json"
        echo "  git commit -m 'chore: update frozen dependencies'"
        ;;
esac

echo -e "${GREEN}Dependency management completed successfully!${NC}"
