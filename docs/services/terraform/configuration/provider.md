# Proxmox Provider Configuration

## Overview

The Terraform setup uses the Proxmox provider for managing LXC containers and other resources within the Proxmox Virtual Environment.

## Provider Configuration

### Basic Provider Setup
```
provider "proxmox" {
  pm_api_url      = "https://<proxmox-host>:8006/api2/json"
  pm_user         = "<username>@pve"
  pm_password     = var.pm_password
  pm_tls_insecure = true
}
```

### Provider Requirements
- Proxmox VE 6.0 or higher
- Valid API credentials
- Network access to Proxmox host

### Authentication Methods
1. **Username/Password** - Basic authentication
2. **API Tokens** - Token-based authentication (recommended)
3. **Environment Variables** - Secure credential management

## Resource Types

### LXC Containers
Primary resource managed through Terraform:
- Container creation and configuration
- Resource allocation (CPU, memory, disk)
- Network configuration
- Template-based deployment

### VM Management
- VM provisioning (when supported by provider)
- Resource configuration
- Network settings

### Storage Management
- Storage pool references
- Disk allocation
- Volume management

## Configuration Examples

### Single LXC Container
```
resource "proxmox_lxc" "example" {
  target_node = "HOMELAB-01"
  hostname    = "example-container"
  memory      = 2048
  cores       = 2
  disk        = 20
  
  os_template = "local:vztmpl/debian-11-standard_amd64.tar.gz"
  
  network {
    name = "net0"
    ip   = "10.10.10.100/24"
    gw   = "10.10.10.1"
  }
}
```

### Multiple Container Deployment
Using for_each or count for multiple containers:
```
resource "proxmox_lxc" "containers" {
  count = length(var.container_config)
  
  target_node = var.container_config[count.index].node
  hostname    = var.container_config[count.index].hostname
  memory      = var.container_config[count.index].memory
  cores       = var.container_config[count.index].cores
  disk        = var.container_config[count.index].disk
}
```

## Environment Variables

### Setting Credentials
```bash
export PROXMOX_VE_USERNAME="user@pve"
export PROXMOX_VE_PASSWORD="password"
export PROXMOX_VE_ENDPOINT="https://proxmox.host:8006/api2/json"
```

### Security Best Practices
- Never commit credentials to version control
- Use environment variables or secure vaults
- Rotate credentials regularly
- Use API tokens when possible

## Troubleshooting

### Common Issues
1. **Authentication Failures**
   - Verify credentials are correct
   - Check API access permissions
   - Validate TLS certificate settings

2. **Resource Creation Failures**
   - Check resource limits on Proxmox
   - Verify storage availability
   - Validate network configuration

3. **State Synchronization Issues**
   - Check state file integrity
   - Verify backend connectivity
   - Resolve any state locks