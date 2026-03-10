# Keycloak

Keycloak is an open-source Identity and Access Management solution providing SSO, user federation, and role-based access control for homelab services.

## Overview

Keycloak serves as the central identity provider for the homelab, providing:
- Single Sign-On (SSO) across multiple services
- User authentication with OAuth 2.0 / OpenID Connect
- LDAP/Active Directory integration for user federation
- Role and group-based authorization

## Server Information

| Hostname | IP Address | VLAN | Resources |
|----------|------------|------|-----------|
| PROD-AUTH-01 | [IP Address] | Production (20) | 4 vCPU, 8GB RAM, 80GB disk |

## Documentation Structure

- [Current Setup](current-setup/setup.md) - Active deployment configuration
- [Configuration](configuration/) - Configuration options and examples
- [Best Practices](best-practices/) - Security hardening and recommendations
