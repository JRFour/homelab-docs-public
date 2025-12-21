# AGENTS.md - Home Lab Infrastructure Guidelines

## Build/Lint/Test Commands
```bash
# YAML validation
yamllint **/*.yml **/*.yaml

# Docker Compose validation
docker-compose config --quiet

# Ansible syntax check
ansible-playbook --syntax-check playbooks/test-connectivity.yml

# Markdown link validation
markdown-link-check docs/**/*.md

# Bash script linting
shellcheck scripts/**/*.sh

# Single test run (Ansible playbook)
ansible-playbook playbooks/test-connectivity.yml --limit localhost
```

## Code Style Guidelines
- **Documentation**: Descriptive filenames (`0-setup-guide.md`), title case headers, 2-space indentation, 80-char line limit
- **YAML**: kebab-case keys, pinned versions, `UPPERCASE_UNDERSCORES` env vars, explanatory comments on complex configs
- **Bash**: Use `#!/bin/bash`, set -e, descriptive functions, error handling with traps, 2-space indentation
- **Naming**: Services (`plex`, `grafana-prod`), networks (`service_network`), descriptive filenames, kebab-case for files
- **Security**: Secrets in env vars only, read-only mounts, least-privilege access, no hardcoded credentials
- **Git**: Conventional commits (`type(scope): description`) - types: feat, fix, docs, style, refactor, test, chore
- **Error Handling**: Check command exit codes, provide meaningful error messages, use traps for cleanup
- **Imports**: Group imports logically, alphabetize within groups, minimize unused imports (N/A for bash/markdown)
