# add_static_ips.sh Script Documentation

This script automates adding static IP assignments to pfSense using the REST API. It reads Terraform output and provisions DHCP static mappings accordingly.

## Prerequisites
- pfSense with REST API package installed
- Terraform with `container_info` output defined
- API token with appropriate permissions

## Usage
```bash
# Export required environment variables
export PFSENSE_API_TOKEN="your-api-token-here"
export PFSENSE_HOST="pfsense.hogwarts.home"  # Optional, default: pfsense.hogwarts.home
export PFSENSE_DOMAIN="hogwarts.home"       # Optional, default: hogwarts.home
export DRY_RUN=0                            # Optional, default: 0 (0=apply, 1=show what would happen)
export FORCE_UPDATE=0                       # Optional, default: 0 (0=prompt, 1=auto-update)

# Run the script
./add_static_ips.sh
```

## Features
- Reads Terraform output (`container_info` value)
- Maps IP addresses to appropriate interfaces based on subnet
- Supports dry-run mode (`DRY_RUN=1`)
- Prompts user for updates when mapping exists with different values
- Supports force-update mode (`FORCE_UPDATE=1`) for automation
- Automatically applies changes after updates
- Idempotent operations - skips identical mappings

## Environment Variables
| Variable | Description | Default |
|----------|-------------|---------|
| `PFSENSE_API_TOKEN` | API token for pfSense | Required |
| `PFSENSE_HOST` | pfSense hostname/IP | `pfsense.hogwarts.home` |
| `PFSENSE_DOMAIN` | Domain for DHCP mappings | `hogwarts.home` |
| `DRY_RUN` | Show what would be done without applying | `0` |
| `FORCE_UPDATE` | Automatically update existing mappings | `0` |
| `DEBUG` | Enable detailed logging | `0` |
| `INSECURE` | Allow insecure HTTPS connections | `1` |

## Interface Mapping
IP address third octet determines interface:
- 20 → opt1
- 30 → opt2
- 40 → opt3
- 50 → opt4
- 10 → opt6
- 60 → opt7
- 70 → opt8
- 80 → opt9
- 90 → opt10

## Example Terraform Output
The script expects Terraform to output a `container_info` value with containers that have:
- `hostname`
- `ip_address`
- `mac_address`
- `vlan_id`

## Implementation Details
- Uses `PATCH` method to update existing mappings when values differ
- Uses `POST` method to create new mappings
- Automatically calls `apply` endpoint after configuration changes
- All HTTP status codes are checked properly
- Error handling with detailed logging