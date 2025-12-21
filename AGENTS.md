# AGENTS.md - Home Lab Infrastructure Guidelines

## Build/Lint/Test Commands

### Configuration Validation
```bash
# YAML syntax check
yamllint *.yml *.yaml

# Docker Compose validation
docker-compose config --quiet

# Single test run (specify playbook)
ansible-playbook playbooks/test-connectivity.yml --limit localhost
```

### Documentation Testing
```bash
# Markdown link checking
markdown-link-check docs/**/*.md

# YAML validation
yamllint configs/**/*.yml docs/**/*.yml
```

## Code Style Guidelines

### Documentation Standards
- Use descriptive hyphen-separated filenames: `0-setup-guide.md`
- Title case headers, consistent indentation
- Inline code for commands/files, code blocks with syntax highlighting
- Numbered lists for sequences, bullets for unordered items

### YAML Configuration Standards
- kebab-case for service names and keys
- Pin Docker image versions explicitly
- UPPERCASE_WITH_UNDERSCORES for environment variables
- Comments explaining complex configurations

### Naming Conventions
- Services: `plex`, `grafana-prod`
- Networks: `service_network`, `management_vlan`
- Files: descriptive with technology suffixes

### Error Handling
- Use structured logging with timestamps and levels
- Validate configurations before deployment
- Implement health checks for all services

### Security Best Practices
- Store secrets in environment variables only
- Use read-only mounts where possible
- Apply least-privilege access controls
- Regular certificate validation

### Git Standards
- Commit format: `type(scope): description`
- Types: feat, fix, docs, style, refactor, test, chore
- Squash related changes, meaningful commit messages