# Keycloak Current Setup

## Deployment Overview

Keycloak is deployed as a Docker container on an Ubuntu LXC on the Production VLAN (20). It serves as the primary identity provider for the homelab.

## Server Configuration

| Parameter | Value |
|-----------|-------|
| Hostname | PROD-AUTH-01 |
| IP Address | [Configured via DHCP on VLAN 20] |
| Operating System | Ubuntu LXC |
| Container Runtime | Docker |

## Resource Allocation

- **vCPU**: 4 cores
- **RAM**: 8 GB
- **Storage**: 80 GB

## Docker Configuration

```yaml
services:
  keycloak:
    image: quay.io/keycloak/keycloak:latest
    command: start-dev
    container_name: keycloak
    environment:
    - KC_HOSTNAME=[ip of keycloak server]
    - KC_HOSTNAME_PORT=8080
    - KC_BOOTSTRAP_ADMIN_USERNAME=admin
    - KC_BOOTSTRAP_ADMIN_PASSWORD=admin
    ports:
      - "8080:8080"
    restart: unless-stopped
```

## Network Configuration

- **VLAN**: Production (20)
- **Port**: 8080 (HTTP)
- **Network Mode**: Bridge

## Integration Notes

Keycloak is configured to potentially integrate with Samba AD for user federation via LDAP. The setup documentation covers:
- LDAP user federation provider configuration
- Kerberos authentication setup
- SAML-based service provider integration
- Protocol mappers for user/group synchronization

## Known Limitations

- Running in `start-dev` mode - not suitable for production
- Using `:latest` tag - no version pinning
- Default admin credentials configured in compose file
- No HTTPS/TLS configured
- No healthcheck defined
- No resource limits set
