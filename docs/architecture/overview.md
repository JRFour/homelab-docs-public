# Architecture Overview

## Network Design

This document provides a complete overview of the home lab infrastructure network design, including VLAN structure, physical infrastructure, and security model.

### Physical Infrastructure

```
Core Hardware:
  - pfSense Firewall (Netgate 6100 or custom build)
  - 42U Server Rack with environmental controls
  - 3x Proxmox servers (HOMELAB-01, HOMELAB-02, HOMELAB-03)
  - 4x Raspberry Pi cluster (PI-01, PI-02, PI-03, PI-04)
```

### VLAN Structure

The home lab utilizes a 9-VLAN network segmentation scheme for optimal security, performance, and service isolation:

| VLAN ID | Name | Purpose | CIDR |
|--------|------|--------|------|
| 10 | Production | Main application services | 10.x.x.x/24 |
| 20 | DMZ | Public-facing services | 10.x.x.x/24 |
| 30 | Admin | Management services | 10.x.x.x/24 |
| 40 | Guest | Visitor services | 10.x.x.x/24 |
| 50 | Monitoring | Infrastructure monitoring | 10.x.x.x/24 |
| 60 | Development | Development environment | 10.x.x.x/24 |
| 70 | Storage | Storage services | 10.x.x.x/24 |
| 80 | Voice | VoIP services | 10.x.x.x/24 |
| 90 | IoT | IoT devices | 10.x.x.x/24 |

### Network Segmentation Strategy

1. **Security Zones**: Each VLAN represents a security zone with proper access controls
2. **Firewall Rules**: Strict egress and ingress filtering at the pfSense level
3. **Isolation**: Services in different VLANs cannot communicate without explicit rules
4. **Monitoring**: All inter-VLAN communication is logged and monitored

### Security Model

```
Network Security Layers:
1. pfSense Firewall - Primary security gate
2. VLAN segmentation - Network isolation
3. Firewall rules - Access control
4. IPSec - Secure tunnels
5. Network monitoring - Anomaly detection
```

### Device Inventory

**Proxmox Servers:**
- HOMELAB-01: Production and primary services
- HOMELAB-02: Development and testing
- HOMELAB-03: Backup and monitoring

**Raspberry Pi Cluster:**
- PI-01: Edge services and DNS
- PI-02: Media server and automation
- PI-03: Monitoring and logging
- PI-04: Backup services

### Backup Strategy

All virtual machines and critical services are protected through:
1. **Daily incremental backups** to local storage
2. **Weekly full backups** to offsite storage
3. **Automated VM snapshots** for quick recovery
4. **Configuration backups** for infrastructure as code

### High Availability

Key services include HA configurations:
- **Load balancer** with multiple instances
- **Database clusters** for data access
- **Redundant infrastructure** where possible
- **Automated failover** for critical services

### Monitoring and Logging

- **Prometheus** for metrics collection
- **Grafana** for visualization
- **ELK stack** for log aggregation
- **SIEM** for security monitoring
- **Alerting** for system anomalies

This architecture provides a secure, scalable, and maintainable foundation for the home lab infrastructure.