# GitHub Repository Strategy

## Repository Structure

Our monorepo contains three AI-driven projects and a NocoBase backend:

```
.
├── projects/
│   ├── AI_Crypto_Price_Predictor/        # BTC/ETH price prediction system
│   ├── Document_Digitization_OCR_System/ # Document processing system
│   └── University_Marketing_Analytics_Tool/ # Marketing analytics system
├── nocobase/                            # Backend service (git submodule)
├── databases/                           # Database configurations
├── docs/                               # Documentation
├── logs/                              # Application logs
└── scripts/                          # Utility scripts
```

## Branch Strategy

1. Main Branches:
   - `main` - Production-ready code
   - `develop` - Integration branch for feature development
   - `staging` - Pre-production testing

2. Supporting Branches:
   - Feature: `feature/project-name/feature-description`
   - Bug Fix: `fix/project-name/bug-description`
   - Hotfix: `hotfix/project-name/issue-description`
   - Release: `release/v{major}.{minor}.{patch}`

## Branch Workflow

1. Development Process:
   - Create feature branch from `develop`
   - Develop and test feature
   - Create PR to merge into `develop`
   - After review, merge into `develop`

2. Release Process:
   - Create release branch from `develop`
   - Test and fix any issues
   - Merge into `main` and tag release
   - Merge back into `develop`

3. Hotfix Process:
   - Create hotfix branch from `main`
   - Fix critical issue
   - Merge into both `main` and `develop`

## Commit Convention

We follow the Conventional Commits specification:

\`\`\`
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
\`\`\`

Types:

- feat: New feature
- fix: Bug fix
- docs: Documentation changes
- style: Code style changes (formatting, etc.)
- refactor: Code refactoring
- test: Adding or modifying tests
- chore: Maintenance tasks

Scopes:

- crypto: AI Crypto Price Predictor
- ocr: Document Digitization System
- analytics: Marketing Analytics Tool
- backend: NocoBase backend
- global: Cross-project changes

## Pull Request Process

1. Create PR with descriptive title following commit convention
2. Fill out PR template:
   - Description of changes
   - Related issue numbers
   - Testing performed
   - Screenshots (if UI changes)
   - Breaking changes
   - Checklist of completed items

3. PR Review Requirements:
   - Code review by at least one team member
   - All automated tests passing
   - No merge conflicts
   - Documentation updated
   - Linting checks passed

## CI/CD Pipeline

1. On Push to Feature Branch:
   - Run linting
   - Run unit tests
   - Run integration tests
   - Build check

2. On PR to Develop:
   - All above checks
   - Coverage report
   - Performance benchmarks
   - Security scans

3. On Merge to Main:
   - All checks
   - Build artifacts
   - Deploy to staging
   - Run E2E tests
   - Deploy to production

## Version Control Best Practices

1. Commits:
   - Make atomic commits (one logical change per commit)
   - Write clear commit messages following convention
   - Reference issue numbers in commits when applicable

2. Code Review:
   - Review for logic, security, and performance
   - Check for documentation updates
   - Verify test coverage
   - Look for potential side effects

3. Documentation:
   - Keep README files updated
   - Document API changes
   - Update configuration guides
   - Maintain changelog

## Release Strategy

1. Version Numbering (SemVer):
   - Major: Breaking changes
   - Minor: New features
   - Patch: Bug fixes

2. Release Process:
   - Update version numbers
   - Generate changelog
   - Create release branch
   - Run full test suite
   - Create GitHub release with notes
   - Deploy to production

3. Release Notes:
   - Summarize changes
   - List all features, fixes, and changes
   - Include upgrade instructions
   - Document breaking changes

## Submodule Management (NocoBase)

1. Updating NocoBase:

   ```bash
   git submodule update --remote nocobase
   git add nocobase
   git commit -m "chore(backend): update nocobase to latest version"
   ```

2. When cloning the repository:

   ```bash
   git clone --recursive [repository-url]
   # or after normal clone:
   git submodule update --init --recursive
   ```

## Security Considerations

1. Protected Branches:
   - `main` and `develop` are protected
   - Require PR reviews
   - Require status checks
   - No force pushes

2. Secrets Management:
   - Use GitHub Secrets for sensitive data
   - No credentials in code
   - Use environment variables
   - Regular security audits

## Issue Management

1. Issue Labels:
   - Type: bug, feature, docs, etc.
   - Priority: high, medium, low
   - Status: in progress, review, blocked
   - Project: crypto, ocr, analytics

2. Issue Templates:
   - Bug report template
   - Feature request template
   - Documentation update template

3. Project Boards:
   - Kanban board per project
   - Sprint planning board
   - Release tracking board
