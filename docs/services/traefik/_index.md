# Traefik

Traefik is a modern HTTP reverse proxy and load balancer for containerized applications, providing dynamic service discovery and automatic TLS certificate management.

## Overview

Traefik serves as the primary entry point for HTTP/HTTPS traffic in the homelab, providing:
- Reverse proxy with automatic service discovery
- Load balancing across containers
- Automatic TLS certificate management
- WebSocket support
- Metrics and monitoring integration

## Server Information

| Hostname | IP Address | VLAN | Resources |
|----------|------------|------|-----------|
| PROD-PROXY-01 | [IP Address] | Production (20) | 2 vCPU, 4GB RAM, 40GB disk |

## Documentation Structure

- [Current Setup](current-setup/setup.md) - Active deployment configuration
- [Configuration](configuration/) - Configuration options and examples
- [Best Practices](best-practices/) - Security hardening and recommendations
