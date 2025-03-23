#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Setting up Git hooks...${NC}"

# Check if pre-commit is installed
if ! command -v pre-commit &> /dev/null; then
    echo -e "${RED}pre-commit is not installed. Installing...${NC}"
    pip install pre-commit
fi

# Install pre-commit hooks
pre-commit install --install-hooks
pre-commit install --hook-type commit-msg

# Install commitizen
if ! command -v cz &> /dev/null; then
    echo -e "${RED}commitizen is not installed. Installing...${NC}"
    pip install commitizen
fi

# Install husky
if [ -f "package.json" ]; then
    echo -e "${GREEN}Installing husky for JavaScript files...${NC}"
    npm install -D husky
    npm run prepare
fi

# Create Git hooks directory if it doesn't exist
mkdir -p .git/hooks

# Create pre-push hook
cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash
set -e

echo "Running tests before push..."
python -m pytest

echo "Running security checks..."
safety check
bandit -r projects/*/src

echo "Running type checks..."
mypy projects/*/src
EOF

chmod +x .git/hooks/pre-push

echo -e "${GREEN}Git hooks setup complete!${NC}"
echo -e "Installed hooks:"
echo -e "- pre-commit (code quality)"
echo -e "- commit-msg (commit message format)"
echo -e "- pre-push (tests and security checks)"

echo -e "\n${GREEN}You can now use:${NC}"
echo -e "- 'git commit' (will run pre-commit checks)"
echo -e "- 'npm run commit' or 'cz' (for guided commits)"
echo -e "- 'git push' (will run tests and security checks)"
