## Security Implementation

> **📖 Related Documentation:** [Network Summary](network-summary.md) | [Switch Configuration](switch.md) | [Setup Guide](../setup/setup-guide.md)


### pfSense Firewall Rules
| *Rule*                              | *Completed*                      |
| ----------------------------------- | -------------------------------- |
| ***WAN***                           |                                  |
| Block RFC1918 from Internet         | X                                |
| Allow HTTP/HTTPS to DMZ Nginx       | X (Needs focus to reverse proxy) |
| Allow SSH to Bastion                | X                                |
| Allow Cloudflare to DMZ             | X                                |
|                                     |                                  |
| ***VLAN 10: Management***           |                                  |
| Allow DNS to Production             | X                                |
| Allow NTP                           | X                                |
| Allow management to all VLANs       | X                                |
| Allow IPMI/iDRAC                    |                                  |
| Allow SNMP monitoring               | X                                |
| Allow SSH to all internal           | X                                |
| Allow automation monitoring         | X                                |
| Allow bastion administration        | X                                |
| Block all other inbound             | X                                |
|                                     |                                  |
| ***VLAN 20: Production***           |                                  |
| Allow internet for updates          | X                                |
| Allow DNS queries                   | X                                |
| Allow NTP                           | X                                |
| Allow Keycloak to Plex for SSO      | X                                |
| Allow DNS from all VLANs            | X                                |
| Allow auth services access          | X                                |
| Allow Vault access                  | X                                |
| Allow reverse proxy access          | X                                |
| Allow management access             | X                                |
| Allow automation access             | X                                |
| Block direct internet to production | X                                |
|                                     |                                  |
| ***VLAN 30: Media***                |                                  |
| Allow internet access               | X                                |
| Allow torrent/usenet ports          | X                                |
| Allow DNS to production             | X                                |
| Allow auth to production            | X                                |
| Allow Plex from DMZ                 | X                                |
| Allow Overseerr from DMZ            | X                                |
| Allow management access             | X                                |
| Allow automation access             | X                                |
| Allow IoT Home Assistant to Plex    | X                                |
| Block from other VLANs              | X                                |
|                                     |                                  |
| ***VLAN 40: Lab/Dev***              |                                  |
| Allow full internet access          | X                                |
| Allow access to production services | X                                |
| Media services testing access       | X                                |
| Allow management access             | X                                |
| Allow bastion access                | X                                |
| Allow automation access             | X                                |
| Allow lab inter-communication       | X                                |
| Block from other VLANs              | X                                |
|                                     |                                  |
| ***VLAN 50: IoT/Home Automation***  |                                  |
| Allow DNS queries                   | X                                |
| Allow NTP                           | X                                |
| Allow Home Assistant to Plex        | X                                |
| Allow Home Assistant to Auth        | X                                |
| Allow special device to internet    | X                                |
| Allow Home Assistant web gui to DMZ | X                                |
| Allow management access             | X                                |
| Allow automation access             | X                                |
| Allow MQTT to other devices         | X                                |
| Block intenet access                | X                                |
| Block VLAN access                   | X                                |
|                                     |                                  |
| ***VLAN 60: Guest***                |                                  |
| Allow internet access               | X                                |
| Allow DNS to Production             | X                                |
| Allow management access             | X                                |
| Block all other inbound             | X                                |
| Block VLAN access                   | X                                |
|                                     |                                  |


# VLAN 70: DMZ
Internet-facing with strict egress controls
DMZ → Media + IoT:
  - Reverse proxy to Plex
  - Home Assistant web interface
Management → DMZ:
  - Administrative access (SSH, HTTPS, SNMP)
  - Monitoring and backup operations  
Automation → DMZ:
  - Workflow automation
  - Health checks and monitoring
  - Configuration management
Allow reverse proxy to Plex			
Allow management access				
Allow bastion access				
Allow automation access				


# VLAN 80: Bastion
Security: Highest - all access logged and monitored
Bastion → All VLANs:
  - Administrative access
  - Security monitoring
Management → Bastion:
  - Administrative access (SSH, HTTPS, SNMP)
  - Monitoring and backup operations
Automation → Bastion:
  - Workflow automation
  - Health checks and monitoring
  - Configuration management

# VLAN 90: Automation
Automation → All VLANs:
  - Workflow automation
  - Health checks and monitoring
  - Configuration management



### DMZ VLAN (YOUR_DMZ_SUBNET) Rules
```bash
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

## Bastion VLAN (YOUR_BASTION_SUBNET) Rules - COMPLETE

### Bastion Outbound Rules
```bash
# === BASTION VLAN OUTBOUND ===
# Full administrative access to all internal VLANs
pass out on $BASTION_IF from $BASTION_NET to $MGMT_NET keep state label "BASTION_Mgmt_Access"
pass out on $BASTION_IF from $BASTION_NET to $PROD_NET keep state label "BASTION_Prod_Access"
pass out on $BASTION_IF from $BASTION_NET to $MEDIA_NET keep state label "BASTION_Media_Access"
pass out on $BASTION_IF from $BASTION_NET to $LAB_NET keep state label "BASTION_Lab_Access"
pass out on $BASTION_IF from $BASTION_NET to $IOT_NET keep state label "BASTION_IoT_Access"
pass out on $BASTION_IF from $BASTION_NET to $DMZ_NET keep state label "BASTION_DMZ_Access"
pass out on $BASTION_IF from $BASTION_NET to $AUTOMATION_NET keep state label "BASTION_Auto_Access"

# Internet access for updates, external tools, and remote access
pass out on $BASTION_IF from $BASTION_NET to !$ALL_INTERNAL port { 53, 80, 443, 123 } keep state label "BASTION_Internet_Basic"
pass out on $BASTION_IF from $BASTION_NET to !$ALL_INTERNAL port { 22, 3389, 5900:5910 } keep state label "BASTION_Remote_Protocols"

# Allow Twingate connector communication
pass out on $BASTION_IF from $BASTION_TWINGATE to !$ALL_INTERNAL port { 443, 30000:32768 } keep state label "BASTION_Twingate_Connector"

# DNS resolution
pass out on $BASTION_IF from $BASTION_NET to { $PROD_PIHOLE_1, $PROD_PIHOLE_2 } port 53 keep state label "BASTION_DNS_Access"
```

### Bastion Inbound Rules
```bash
# === BASTION VLAN INBOUND ===
# SSH access from internet (via port forwarding to bastion host)
pass in on $BASTION_IF from any to $BASTION_HOST port 22 keep state label "BASTION_SSH_From_Internet"

# Guacamole web access from internet
pass in on $BASTION_IF from any to $BASTION_GUAC port { 8080, 8443 } keep state label "BASTION_Guacamole_Web"

# Wetty web terminal access
pass in on $BASTION_IF from any to $BASTION_WETTY port { 3000, 443 } keep state label "BASTION_Wetty_Access"

# VPN access from internet
pass in on $BASTION_IF from any to $BASTION_VPN port { 1194, 51820 } keep state label "BASTION_VPN_Access"

# Allow Twingate access (specific IP ranges)
table <twingate_ips> persist
pass in on $BASTION_IF from <twingate_ips> to $BASTION_NET port { 80, 443, 22 } keep state label "BASTION_Twingate_Access"

# Management access from management network
pass in on $BASTION_IF from $MGMT_NET to $BASTION_NET port { 22, 80, 443, 161 } keep state label "BASTION_Mgmt_Admin"

# Allow automation monitoring and management
pass in on $BASTION_IF from $AUTOMATION_NET to $BASTION_NET port { 22, 80, 443, 9090, 9100 } keep state label "BASTION_Automation_Monitor"

# Security services inter-communication
pass in on $BASTION_IF from $BASTION_NET to $BASTION_NET port { 22, 80, 443, 514, 5044, 9200 } keep state label "BASTION_Internal_Comm"

# Block access from other VLANs (except management and automation)
block in log on $BASTION_IF from { $PROD_NET, $MEDIA_NET, $LAB_NET, $IOT_NET, $GUEST_NET, $DMZ_NET } to $BASTION_NET label "BASTION_Block_Unauthorized"
```

## Automation VLAN (YOUR_AUTO_SUBNET) Rules - COMPLETE

### Automation Outbound Rules
```bash
# === AUTOMATION VLAN OUTBOUND ===
# Full access to management network for monitoring and administration
pass out on $AUTOMATION_IF from $AUTOMATION_NET to $MGMT_NET port { 22, 80, 443, 161, 8080, 9090 } keep state label "AUTO_Mgmt_Monitor"

# Access to production services for automation workflows
pass out on $AUTOMATION_IF from $AUTOMATION_NET to $PROD_NET port { 22, 53, 80, 443, 389, 636, 8080, 8200, 5432, 6379 } keep state label "AUTO_Prod_Access"

# Media services automation (Sonarr, Radarr, Plex management)
pass out on $AUTOMATION_IF from $AUTOMATION_NET to $MEDIA_NET port { 22, 80, 443, 8989, 7878, 9696, 5055, 32400, 8080 } keep state label "AUTO_Media_Control"

# Lab environment access for CI/CD and development automation
pass out on $AUTOMATION_IF from $AUTOMATION_NET to $LAB_NET keep state label "AUTO_Lab_Access"

# IoT and home automation integration
pass out on $AUTOMATION_IF from $AUTOMATION_NET to $IOT_NET port { 22, 80, 443, 8123, 1883, 1880, 5683 } keep state label "AUTO_IoT_Integration"

# DMZ website management and deployment
pass out on $AUTOMATION_IF from $AUTOMATION_NET to $DMZ_NET port { 22, 80, 443, 3306, 6379, 8080 } keep state label "AUTO_Website_Mgmt"

# Bastion security monitoring and log collection
pass out on $AUTOMATION_IF from $AUTOMATION_NET to $BASTION_NET port { 22, 80, 443, 514, 5044, 9100 } keep state label "AUTO_Security_Monitor"

# Internet access for external integrations, webhooks, and updates
pass out on $AUTOMATION_IF from $AUTOMATION_NET to !$ALL_INTERNAL port { 53, 80, 443, 123, 25, 587, 993, 995 } keep state label "AUTO_Internet_Access"

# DNS resolution
pass out on $AUTOMATION_IF from $AUTOMATION_NET to { $PROD_PIHOLE_1, $PROD_PIHOLE_2 } port 53 keep state label "AUTO_DNS_Access"

# Internal automation service communication
pass out on $AUTOMATION_IF from $AUTOMATION_NET to $AUTOMATION_NET port { 5432, 6379, 5672, 15672, 9090 } keep state label "AUTO_Internal_Comm"
```

### Automation Inbound Rules
```bash
# === AUTOMATION VLAN INBOUND ===
# Allow webhooks from external services (GitHub, GitLab, etc.)
pass in on $AUTOMATION_IF from any to $AUTO_N8N port { 80, 443, 5678 } keep state label "AUTO_External_Webhooks"

# Allow webhook access from DMZ (for website automation triggers)
pass in on $AUTOMATION_IF from $DMZ_NET to $AUTO_N8N port { 80, 443, 5678 } keep state label "AUTO_DMZ_Webhooks"

# Allow media services to trigger automation workflows
pass in on $AUTOMATION_IF from $MEDIA_NET to $AUTO_N8N port { 80, 443, 5678 } keep state label "AUTO_Media_Triggers"

# Allow IoT services to trigger automation (Home Assistant, MQTT)
pass in on $AUTOMATION_IF from $IOT_NET to $AUTO_N8N port { 80, 443, 5678 } keep state label "AUTO_IoT_Triggers"

# Allow bastion to manage automation services
pass in on $AUTOMATION_IF from $BASTION_NET to $AUTOMATION_NET port { 22, 80, 443, 5432, 6379 } keep state label "AUTO_Bastion_Mgmt"

# Allow management network access for monitoring and administration
pass in on $AUTOMATION_IF from $MGMT_NET to $AUTOMATION_NET port { 22, 80, 443, 161, 5432, 6379, 15672 } keep state label "AUTO_Mgmt_Access"

# Allow production services to access automation APIs
pass in on $AUTOMATION_IF from $PROD_NET to $AUTO_N8N port { 80, 443, 5678 } keep state label "AUTO_Prod_API_Access"

# Allow lab services for CI/CD automation triggers
pass in on $AUTOMATION_IF from $LAB_NET to $AUTO_N8N port { 80, 443, 5678 } keep state label "AUTO_Lab_CICD"

# Internal automation service communication
pass in on $AUTOMATION_IF from $AUTOMATION_NET to $AUTOMATION_NET port { 5432, 6379, 5672, 15672, 9090, 3000 } keep state label "AUTO_Service_Comm"

# Block guest network access to automation
block in log on $AUTOMATION_IF from $GUEST_NET to $AUTOMATION_NET label "AUTO_Block_Guest"
```

## Cross-VLAN Communication Summary

### Traffic Flow Matrix
```bash
# === ALLOWED CROSS-VLAN COMMUNICATION SUMMARY ===
# 
# FROM → TO: Allowed Services
# 
# MGMT → ALL: Administrative access (SSH, HTTPS, SNMP)
# PROD → MEDIA: Keycloak SSO integration
# MEDIA → PROD: DNS, Authentication
# LAB → PROD: DNS, Auth, Vault
# LAB → MEDIA: Testing access to media services
# IOT → PROD: DNS, Authentication (Home Assistant only)
# IOT → MEDIA: Plex control (Home Assistant only)
# GUEST → PROD: DNS only
# DMZ → PROD: DNS, Authentication
# DMZ → MEDIA: Reverse proxy to Plex, Overseerr
# DMZ → IOT: Reverse proxy to Home Assistant
# BASTION → ALL: Full administrative access
# AUTO → ALL: Automation and monitoring access
# 
# BLOCKED COMMUNICATION:
# GUEST → ALL (except PROD DNS)
# IOT devices → Internet (except Home Assistant)
# DMZ → MGMT, LAB, BASTION (security isolation)
# MEDIA ↔ LAB (no direct communication)
# PROD → LAB (no production to lab access)
```

### Security Considerations
```bash
# === ADDITIONAL SECURITY RULES ===

# Rate limiting for external access
# SSH to bastion
pass in on $WAN_IF from any to $BASTION_HOST port 2222 keep state \
  (max-src-conn 3, max-src-conn-rate 5/60, overload <bru

---
*Note: This is a sanitized example. Replace placeholder values with your actual configuration.*
