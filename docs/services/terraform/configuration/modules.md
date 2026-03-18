# Configuration

## Module Structure

### Current Modules
The implementation uses multiple modules to organize Terraform code effectively:

1. **dev/** - Simple test environment
2. **build_many_lxc/** - Repetitive container provisioning
3. **build_single_lxc/** - Single container provisioning

### Module Best Practices
- Single responsibility principle
- Reusable components
- Clear input/output interfaces
- Versioned modules where appropriate

## Variable Definitions

### Standard Variables
Common variables used across configurations:
- `vm_id` - Unique container ID
- `hostname` - Container hostname
- `memory` - Memory allocation (MB)
- `cores` - CPU cores
- `disk` - Storage size (GB)
- `network` - Network configuration
- `template` - Base image/template
- `env` - Environment type (dev, prod, etc.)

### Environment-Specific Variables
Each environment has its own variables file:
- `dev.tfvars`
- `prod.tfvars` 
- `mgmt.tfvars`
- `media.tfvars`
- `dmz.tfvars`
- `bastion.tfvars`
- `auto.tfvars`
- `test_terraform.tfvars`

## Resource Provisioning

### LXC Containers
The primary resource provisioned is LXC containers with:
- Defined resource limits
- Network configurations
- Storage allocation
- Template selection

### Resource Example
```
resource "proxmox_lxc" "my_container" {
  target_node = var.target_node
  hostname    = var.hostname
  memory      = var.memory
  cores       = var.cores
  disk        = var.disk
  net = [
    {
      name = "net0"
      ip   = var.ip_address
      gw   = var.gateway
    }
  ]
}
```

## Output Definitions

### Standard Outputs
Common outputs for each container:
- `container_id` - Unique identifier
- `ip_address` - Network address
- `hostname` - Container hostname
- `status` - Current status

### Environment Outputs
Each environment produces specific outputs for integration:
- Resource allocation details
- Network information
- Access credentials (where applicable)

## Configuration Example

### Environment Variables File Structure
```
# dev.tfvars
target_node = "HOMELAB-01"
hostname    = "dev-container"
memory      = 1024
cores       = 2
disk        = 20
ip_address  = "10.x.x.x"
gateway     = "10.x.x.x"
template    = "debian-11-default"
```

## State File Configuration

### Backend Configuration
```
terraform {
  backend "http" {
    address = "http://<minio-server>/terraform/state"
    lock_address = "http://<minio-server>/terraform/state/lock"
  }
}
```

### State Storage Solutions
1. **MinIO** (S3 compatible) - Recommended
2. **HTTP self-hosted** - Local storage
3. **Local files** - Testing only