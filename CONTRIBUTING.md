# Contributing to Homelab Infrastructure Documentation

Thank you for your interest in contributing to the homelab infrastructure documentation! This guide provides information about how you can contribute to this project.

## How to Contribute

We welcome contributions to improve and extend the documentation. There are several ways to contribute:

### Reporting Issues
- Create an issue for any problems you encounter
- Report documentation gaps or inconsistencies
- Suggest improvements to existing content

### Submitting Changes
- Fork the repository
- Create a feature branch for your changes
- Make your modifications
- Submit a pull request with a clear description of your changes

## Code Style Guidelines

### Documentation Standards

#### File Naming
- Use descriptive, hyphen-separated names: `0-setup-guide.md`, `docker-compose.service.yml`
- Number prefixes for sequential guides: `0.1-device-separation-guide.md`
- Service documentation: `docs/services/<service-name>/`

#### Structure
- Title Case headers for main sections
- `inline code` for commands, file paths, and configuration values
- 2-space indentation for nested content
- Bold for emphasis, *italic* for variables

#### Service Documentation Template
Each service should include two main sections:

**Current Setup**
- Overview of current deployment
- Docker configuration details
- Active configuration (image, ports, volumes, networks, environment)
- Known issues and limitations

**Best Practices & Industry Standards**
- Security hardening recommendations
- Image management (version pinning)
- Resource management (CPU/memory limits, healthchecks)
- Monitoring and logging recommendations
- Backup and recovery strategies
- Upgrade priority and timeline

### YAML Configuration
```yaml
services:
  service-name:
    image: specific-tag:latest  # Pin versions - never use :latest in production
    container_name: descriptive-name
    restart: unless-stopped
    environment:
      UPPERCASE_UNDERSCORE: "${ENV_VAR}"
    volumes:
      - ./config:/app/config:ro
      - service_data:/app/data
```
- Use kebab-case for keys
- Always pin image versions (avoid `:latest` in production)
- Use UPPERCASE_WITH_UNDERSCORES for environment variables
- Add explanatory comments for non-obvious configurations
- Use read-only mounts (`:ro`) where possible

### Terraform (HCL)
```hcl
variable "example" {
  type        = string
  description = "Description of what this variable does"
  default     = "value"
  validation {
    condition     = length(var.example) <= 10
    error_message = "Error message when validation fails"
  }
}
```
- Use snake_case for variable names
- Always include descriptions for variables and outputs
- Add validation blocks for type safety

### Bash Scripts
```bash
#!/bin/bash
set -euo pipefail

command_with_error_handling() {
    if ! command --option value; then
        echo "ERROR: Command failed" >&2
        return 1
    fi
}
```
- Use `#!/bin/bash` shebang
- Always use `set -euo pipefail`
- Use 2-space indentation
- Use descriptive function names (snake_case)
- Handle errors with meaningful messages

### Kubernetes
- Use descriptive resource names
- Add labels for organization (`app:`, `environment:`, `tier:`)
- Include resource limits and requests
- Use kustomize for environment-specific configurations

## Naming Conventions

- Services: `plex`, `grafana-prod`, `qbittorrent-vpn`
- Networks: `service_network` (kebab-case)
- Files: `kebab-case`, descriptive names
- Env vars: `UPPERCASE_WITH_UNDERSCORES`
- Terraform variables: `snake_case`
- Documentation: `Title Case` for headings

## Security Best Practices

- **Secrets**: Use environment variables only, never hardcode credentials
- **File permissions**: `chmod 600` for sensitive configs, `chmod 700` for scripts
- **Access**: Least-privilege, read-only mounts where possible
- **Containers**: Use specific image tags, not `:latest`
- **Network**: Follow VLAN segmentation guidelines
- **Documentation**: Include security considerations in all service docs

## Error Handling

- Check exit codes (`set -euo pipefail` for bash)
- Provide meaningful error messages
- Validate inputs with clear error messages
- Include healthchecks in Docker configurations

## Git Standards

### Commit Format
```
# Commit format: type(scope): description
# Types: feat, fix, docs, style, refactor, test, chore
feat(pfsense): Add firewall rules for new VLAN
fix(traefik): Resolve certificate renewal issue
docs(keycloak): Update SSO configuration guide
```

## Testing

Before submitting your contribution:
1. Ensure that all syntax is correct
2. Validate configurations where applicable
3. Test that documentation builds correctly
4. Follow existing document formatting and style guidelines

## Pull Request Process

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Commit with clear, descriptive messages
5. Submit a pull request
6. Address any feedback from code reviews

## Code of Conduct

Please read and follow our [Code of Conduct](CODE_OF_CONDUCT.md) in all your interactions with the project.