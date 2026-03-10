# Firewall Rules Overview

## Philosophy

The pfSense firewall implements a defense-in-depth security model with strict VLAN segmentation. The philosophy centers on:
1. **Zero trust principle** - No implicit trust between networks
2. **Principle of least privilege** - Services only access what they need
3. **Network segmentation** - Each VLAN serves a specific security purpose
4. **Comprehensive logging** - All traffic is monitored and logged

## Traffic Flow Matrix

The following matrix shows allowed cross-VLAN communication:

### Allowed Traffic
```
FROM → TO: Allowed Services
MGMT → ALL: Administrative access (SSH, HTTPS, SNMP)
PROD → MEDIA: Keycloak SSO integration
MEDIA → PROD: DNS, Authentication
LAB → PROD: DNS, Auth, Vault
LAB → MEDIA: Testing access to media services
IOT → PROD: DNS, Authentication (Home Assistant only)
IOT → MEDIA: Plex control (Home Assistant only)
GUEST → PROD: DNS only
DMZ → PROD: DNS, Authentication
DMZ → MEDIA: Reverse proxy to Plex, Overseerr
DMZ → IOT: Reverse proxy to Home Assistant
BASTION → ALL: Full administrative access
AUTO → ALL: Automation and monitoring access
```

### Blocked Communication
```
GUEST → ALL (except PROD DNS)
IOT devices → Internet (except Home Assistant)
DMZ → MGMT, LAB, BASTION (security isolation)
MEDIA ↔ LAB (no direct communication)
PROD → LAB (no production to lab access)
```

## Rule Enforcement

All rules are implemented with:
- Stateful inspection
- Logging enabled for all rules
- Rate limiting on external access
- IP-based access controls
- Time-based rule restrictions