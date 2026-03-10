# Bastion VLAN Rules

## Overview
The Bastion VLAN provides the highest security level for administrative access, serving as a controlled gateway to all other networks.

## Bastion VLAN (10.x.x.x/24) Rules

### Outbound Rules
```
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
````
### Inbound Rules
```
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

## Bastion Security Model
The Bastion VLAN provides:
- Highest security level for administrative access
- Complete visibility and logging of all access
- Controlled access to all other VLANs
- Remote administration capabilities
- Security monitoring and alerting