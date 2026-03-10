# WAN Interface Rules

## Overview
The WAN interface rules provide the first line of defense against external threats while allowing properly configured access to internal services.

## WAN Inbound Rules

### Security Rules
| Rule | Description | Status |
|------|-------------|--------|
| Block RFC1918 from Internet | Prevent private IP address ranges from entering the network | Completed |
| Allow HTTP/HTTPS to DMZ Nginx | Permits web traffic to DMZ services | Completed |
| Allow SSH to Bastion | Permits secure administrative access via bastion host | Completed |
| Allow Cloudflare to DMZ | Enables Cloudflare tunnel connectivity | Completed |

### Port Forwarding
- Port 80 → DMZ NGINX web server
- Port 443 → DMZ NGINX web server  
- Port 22 → Bastion host (SSH access)
- Port 7844 → Cloudflare tunnel service

## WAN Outbound Rules

### Basic Internet Access
```
# Basic internet access for updates and essential services
pass out on $WAN_IF from any to any port { 53, 80, 443, 123 } keep state
```

### Security Considerations
- All outbound traffic is inspected for malicious patterns
- DNS queries are resolved through internal DNS servers
- Time synchronization with NTP servers is enabled
- No direct internet access for internal VLANs (except DMZ services)