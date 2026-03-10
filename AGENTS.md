# AGENTS.md - Home Lab Infrastructure Guidelines

This repository contains home lab infrastructure configuration including Docker Compose, Terraform, Kubernetes manifests, and documentation.

## Build/Lint/Test Commands

### YAML Validation
```bash
yamllint **/*.yml **/*.yaml
docker-compose config --quiet
docker-compose config --services
```

### Docker/Container Testing
```bash
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

### Terraform
```bash
terraform fmt -recursive
terraform validate
terraform plan
```

### Kubernetes
```bash
kubectl get nodes
kubectl get pods -A
kubectl get svc -A
```

### Bash Script Linting
```bash
shellcheck scripts/**/*.sh
```

### Single Test Run (Most Common)
```bash
docker-compose config --quiet
terraform fmt -check -recursive
yamllint **/*.yml **/*.yaml
```

## Code Style Guidelines

### Documentation Standards
- **File Naming**: Descriptive, hyphen-separated (`0-setup-guide.md`, `docker-compose.service.yml`)
- **Structure**: Title Case headers, `inline code` for commands, 2-space indent
- **Format**: Bold for emphasis, *italic* for variables, blockquotes for notes

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

### Naming Conventions
- Services: `plex`, `grafana-prod`, `qbittorrent-vpn`
- Networks: `service_network` (kebab-case)
- Files: `kebab-case`, descriptive names
- Env vars: `UPPERCASE_WITH_UNDERSCORES`
- Terraform variables: `snake_case`

### Security Best Practices
- **Secrets**: Use environment variables only, never hardcode credentials
- **File permissions**: `chmod 600` for sensitive configs, `chmod 700` for scripts
- **Access**: Least-privilege, read-only mounts where possible
- **Containers**: Use specific image tags, not `:latest`

### Error Handling
- Check exit codes (`set -euo pipefail` for bash)
- Provide meaningful error messages
- Validate inputs with clear error messages

### Git Standards
```bash
# Commit format: type(scope): description
# Types: feat, fix, docs, style, refactor, test, chore
feat(media): Add automated quality upgrade workflow
fix(network): Resolve VLAN routing issue
```

### Directory Structure
```
├── DNS/           # DNS configurations
├── K8s/           # Kubernetes manifests and scripts
├── Keycloak/      # Keycloak/OIDC setup
├── Media/         # Media services (Plex, etc.)
├── Pfsense/       # pfSense firewall configs
├── Proxmox/       # Proxmox VE configs
├── Terraform/     # Terraform IaC
├── Traefik/       # Traefik reverse proxy
├── Vault/         # HashiCorp Vault configs
├── Web_Services/  # Web application configs
└── AGENTS.md      # This file
```