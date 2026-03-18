# DMZ VLAN Rules

## Overview
The DMZ VLAN acts as a secure internet-facing zone with strict egress controls and limited access to internal services.

## DMZ VLAN (10.x.x.x/24) Rules

### Outbound Rules
```
# === DMZ VLAN OUTBOUND ===
# Internet for CDN, updates
pass out on $DMZ_IF from $DMZ_NET to any port { 53, 80, 443, 123 } keep state

# Database access to production
pass out on $DMZ_IF from $DMZ_WORDPRESS to $PROD_MYSQL port 3306 keep state

# Auth to production
pass out on $DMZ_IF from $DMZ_NET to $PROD_KEYCLOAK port { 8080, 8443 } keep state

# Media service access
pass out on $DMZ_IF from $DMZ_NGINX to $MEDIA_NET port { 32400, 5055 } keep state

# IoT service access
pass out on $DMZ_IF from $DMZ_NGINX to $IOT_HOMEASSISTANT port 8123 keep state
```

### Inbound Rules
```
# === DMZ VLAN INBOUND ===
# Web traffic from internet via port forwards
pass in on $DMZ_IF from any to $DMZ_NGINX port { 80, 443 } keep state

# Cloudflare tunnel
pass in on $DMZ_IF from any to $DMZ_CLOUDFLARED port { 80, 443, 7844 } keep state

# Management access
pass in on $DMZ_IF from { $MGMT_NET, $BASTION_NET } to $DMZ_NET port { 22, 80, 443, 3306, 6379 } keep state

# Automation access for website management
pass in on $DMZ_IF from $AUTOMATION_NET to $DMZ_NET port { 22, 80, 443, 3306, 6379, 8080 } keep state

# Block access to internal networks except allowed
block out log on $DMZ_IF from $DMZ_NET to { $MGMT_NET, $LAB_NET, $BASTION_NET }
```

## DMZ Security Model
The DMZ provides:
- Isolated web-facing services
- Strict egress controls
- Limited access to internal services
- Comprehensive logging
- Secure reverse proxy access to internal services