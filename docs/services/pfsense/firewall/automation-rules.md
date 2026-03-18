# Automation VLAN Rules

## Overview
The Automation VLAN provides secure access for automation services while maintaining strict controls on communication with other networks.

## Automation VLAN (10.x.x.x/24) Rules

### Outbound Rules
```
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

### Inbound Rules
```
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

## Automation Security Model
The Automation VLAN provides:
- Secure execution environment for automation workflows
- Controlled access to all other networks
- Automated monitoring and alerting
- Integration with external services through secure channels
- Isolation from direct internet access