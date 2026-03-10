# Current Setup

## Terraform Version

### Required Version
- Terraform version: 1.0+
- Provider versions: Specific versions for Proxmox (likely v0.30+)

### Installation Notes
Based on the documentation note about installation issues:
- If using Debian-based systems, ensure correct distribution codename
- Common issue with `$(lsb_release -cs)` returning invalid codenames like `debbie`
- Fix: Manually specify correct Debian codename (e.g., `bookworm` for Debian 12)

## Provider Configuration

### Proxmox Provider
The implementation uses the Proxmox provider for managing:
- LXC containers
- VM resources
- Storage management
- Network configurations

### Provider Setup
```
provider "proxmox" {
  pm_api_url      = "https://<proxmox-host>:8006/api2/json"
  pm_user         = "<username>@pve"
  pm_password     = "<password>"
  pm_tls_insecure = true
}
```

## Project Structure

### Current Projects
1. **Simple Test Build** (`dev/`)
   - Basic LXC container deployment
   - Validation of Terraform concepts

2. **Repetition Project** (`build_many_lxc/`)
   - Repetitive container building
   - Resource reuse capabilities

3. **Environment Separation** (`build_many_lxc/` with env files)
   - Environment-specific configurations
   - Multiple environments (dev, prod, test, etc.)

### Directory Structure
```
Terraform/
├── dev/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars
├── build_many_lxc/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tf
│   └── env_tfvars/
│       ├── dev.tfvars
│       ├── prod.tfvars
│       ├── mgmt.tfvars
│       ├── media.tfvars
│       ├── dmz.tfvars
│       ├── bastion.tfvars
│       ├── auto.tfvars
│       └── test_terraform.tfvars
└── build_single_lxc/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── terraform.tfvars
```

## Infrastructure Overview

### Resources Managed
- LXC containers
- Storage allocation
- Network configuration
- Resource limits and constraints

### Environment Separation
The implementation separates environments through:
- Environment-specific variable files
- Different directory structures
- Workspace management (potential future implementation)

## State File Management

### Current State Management
- State file storage approach needed
- Recommended solutions:
  - MinIO (S3 compatible)
  - HTTP self-hosted storage
  - Local file storage (for testing only)

### Security Considerations
- State file encryption
- Access controls
- Backup procedures

## Dependencies

### Required Tools
- Terraform CLI
- Proxmox provider
- Environment variables for authentication
- SSH keys for container configuration

### Optional Tools
- Terraform Cloud/Enterprise (for team collaboration)
- Terragrunt (for configuration management)