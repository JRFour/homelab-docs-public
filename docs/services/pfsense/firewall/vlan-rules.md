# Per-VLAN Rules

## Management VLAN (10.10.0.0/24)

### Inbound Rules
| Rule | Description | Status |
|-----|----|----|
| Allow DNS to Production | Permits DNS queries from management to production | Completed |
| Allow NTP | Enables time synchronization | Completed |
| Allow management to all VLANs | Grants full access from management network | Completed |
| Allow IPMI/iDRAC | Enables hardware monitoring access | Not Started |
| Allow SNMP monitoring | Permits network monitoring access | Completed |
| Allow SSH to all internal | Enables administrative access to all internal services | Completed |
| Allow automation monitoring | Grants access for automation monitoring | Completed |
| Allow bastion administration | Allows management access via bastion | Completed |
| Block all other inbound | Security hardening | Completed |

### Outbound Rules
```
# Allow management to all internal networks
pass out on $MGMT_IF from $MGMT_NET to $PROD_NET keep state
pass out on $MGMT_IF from $MGMT_NET to $MEDIA_NET keep state
pass out on $MGMT_IF from $MGMT_NET to $LAB_NET keep state
pass out on $MGMT_IF from $MGMT_NET to $IOT_NET keep state
pass out on $MGMT_IF from $MGMT_NET to $GUEST_NET keep state
pass out on $MGMT_IF from $MGMT_NET to $DMZ_NET keep state
pass out on $MGMT_IF from $MGMT_NET to $BASTION_NET keep state
pass out on $MGMT_IF from $MGMT_NET to $AUTOMATION_NET keep state
```

## Production VLAN (10.20.0.0/24)

### Inbound Rules
| Rule | Description | Status |
|-----|----|----|
| Allow internet for updates | Permits internet access for security updates | Completed |
| Allow DNS queries | Enables DNS resolution | Completed |
| Allow NTP | Enables time synchronization | Completed |
| Allow Keycloak to Plex for SSO | Permits SSO between authentication and media services | Completed |
| Allow DNS from all VLANs | Allows DNS queries from other networks | Completed |
| Allow auth services access | Permits access to authentication services | Completed |
| Allow Vault access | Enables access to secrets management | Completed |
| Allow reverse proxy access | Permits reverse proxy communication | Completed |
| Allow management access | Grants management network access | Completed |
| Allow automation access | Allows automation services access | Completed |
| Block direct internet to production | Security hardening | Completed |

### Outbound Rules
```
# Production internet access for updates and services
pass out on $PROD_IF from $PROD_NET to any port { 53, 80, 443, 123 } keep state

# Allow access to authentication services
pass out on $PROD_IF from $PROD_NET to $MGMT_NET port 389 keep state
pass out on $PROD_IF from $PROD_NET to $MGMT_NET port 636 keep state
pass out on $PROD_IF from $PROD_NET to $MGMT_NET port 8080 keep state
pass out on $PROD_IF from $PROD_NET to $MGMT_NET port 8443 keep state

# Allow access to database services
pass out on $PROD_IF from $PROD_NET to $PROD_DB port 3306 keep state
pass out on $PROD_IF from $PROD_NET to $PROD_POSTGRESQL port 5432 keep state

# Allow access to monitoring services
pass out on $PROD_IF from $PROD_NET to $MONITORING_NET port 8080 keep state
pass out on $PROD_IF from $PROD_NET to $MONITORING_NET port 9090 keep state
```

## Media VLAN (10.30.0.0/24)

### Inbound Rules
| Rule | Description | Status |
|-----|----|----|
| Allow internet access | Permits internet access for media services | Completed |
| Allow torrent/usenet ports | Enables media downloads | Completed |
| Allow DNS to production | Allows DNS queries to production | Completed |
| Allow auth to production | Grants authentication access | Completed |
| Allow Plex from DMZ | Permits reverse proxy access from DMZ | Completed |
| Allow Overseerr from DMZ | Allows Overseerr access from DMZ | Completed |
| Allow management access | Grants management access | Completed |
| Allow automation access | Allows automation services access | Completed |
| Allow IoT Home Assistant to Plex | Permits IoT access to media services | Completed |
| Block from other VLANs | Security hardening | Completed |

### Outbound Rules
```
# Allow media services to internet for updates and access
pass out on $MEDIA_IF from $MEDIA_NET to any port { 53, 80, 443, 123, 2222 } keep state

# Allow access to authentication services
pass out on $MEDIA_IF from $MEDIA_NET to $MGMT_NET port 8080 keep state

# Allow access to production services
pass out on $MEDIA_IF from $MEDIA_NET to $PROD_NET port { 32400, 8080, 9696, 5055 } keep state

# Allow access to monitoring and automation
pass out on $MEDIA_IF from $MEDIA_NET to $MONITORING_NET port 9090 keep state
pass out on $MEDIA_IF from $MEDIA_NET to $AUTOMATION_NET port 8080 keep state
```

## Lab/Development VLAN (10.40.0.0/24)

### Inbound Rules
| Rule | Description | Status |
|-----|----|----|
| Allow full internet access | Permits complete internet access | Completed |
| Allow access to production services | Grants access to production servers | Completed |
| Media services testing access | Allows testing access to media services | Completed |
| Allow management access | Grants network administration access | Completed |
| Allow bastion access | Enables bastion host access | Completed |
| Allow automation access | Allows automation services access | Completed |
| Allow lab inter-communication | Permits internal lab communication | Completed |
| Block from other VLANs | Security hardening | Completed |

### Outbound Rules
```
# Allow full internet access for development testing
pass out on $LAB_IF from $LAB_NET to any port { 53, 80, 443, 123, 22, 3389 } keep state

# Allow access to production services for development
pass out on $LAB_IF from $LAB_NET to $PROD_NET port { 80, 443, 3306, 5432, 8080, 8443 } keep state

# Allow access to media services
pass out on $LAB_IF from $LAB_NET to $MEDIA_NET port 32400 keep state

# Allow access to monitoring
pass out on $LAB_IF from $LAB_NET to $MONITORING_NET port 9090 keep state

# Allow access to automation
pass out on $LAB_IF from $LAB_NET to $AUTOMATION_NET port 8080 keep state
```

## IoT/Home Automation VLAN (10.50.0.0/24)

### Inbound Rules
| Rule | Description | Status |
|-----|----|----|
| Allow DNS queries | Permits DNS resolution | Completed |
| Allow NTP | Enables time synchronization | Completed |
| Allow Home Assistant to Plex | Permists Home Assistant to access Plex | Completed |
| Allow Home Assistant to Auth | Grants access to authentication services | Completed |
| Allow special device to internet | Enables internet access for special devices | Completed |
| Allow Home Assistant web gui to DMZ | Permits web interface access to DMZ | Completed |
| Allow management access | Grants management access | Completed |
| Allow automation access | Allows automation services access | Completed |
| Allow MQTT to other devices | Enables MQTT communication | Completed |
| Block internet access | Security hardening | Completed |
| Block VLAN access | Security hardening | Completed |

### Outbound Rules
```
# Allow IoT devices to internet for updates and cloud access
pass out on $IOT_IF from $IOT_NET to any port { 53, 80, 443, 123 } keep state

# Allow access to authentication services
pass out on $IOT_IF from $IOT_NET to $MGMT_NET port 8080 keep state

# Allow access to Media services
pass out on $IOT_IF from $IOT_NET to $MEDIA_NET port 32400 keep state

# Allow access to monitoring
pass out on $IOT_IF from $IOT_NET to $MONITORING_NET port 9090 keep state

# Allow access to automation services
pass out on $IOT_IF from $IOT_NET to $AUTOMATION_NET port 8080 keep state

# Allow access to MQTT broker
pass out on $IOT_IF from $IOT_NET to $IOT_NET port 1883 keep state
```

## Guest VLAN (10.60.0.0/24)

### Inbound Rules
| Rule | Description | Status |
|-----|----|----|
| Allow internet access | Permits internet access | Completed |
| Allow DNS to Production | Allows DNS queries | Completed |
| Allow management access | Grants management access | Completed |
| Block all other inbound | Security hardening | Completed |
| Block VLAN access | Security hardening | Completed |

### Outbound Rules
```
# Allow guest network internet access
pass out on $GUEST_IF from $GUEST_NET to any port { 53, 80, 443, 123 } keep state

# Allow DNS queries to production network
pass out on $GUEST_IF from $GUEST_NET to $PROD_NET port 53 keep state
```