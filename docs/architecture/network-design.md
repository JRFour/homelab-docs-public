# Network Design

This document provides a detailed overview of the VLAN segmentation design and network security model.

## VLAN Structure

The home lab implements a 9-VLAN network segmentation scheme designed for optimal security isolation and performance.

### VLAN Mapping

| VLAN ID | Name | Purpose | Subnet | Security Level |
|--------|------|---------|--------|---------------|
| 10 | Network Management | Core infrastructure management | 10.x.x.x/24 | High |
| 20 | Application Services | Main application stack | 10.x.x.x/24 | High |
| 30 | Secure Zone | Internal services | 10.x.x.x/24 | Medium |
| 40 | Guest Networks | Visitor services | 10.x.x.x/24 | Low |
| 50 | Security Monitoring | Logging and alerting | 10.x.x.x/24 | High |
| 60 | Development | Software development | 10.x.x.x/24 | Medium |
| 70 | Storage Services | File storage and NAS | 10.x.x.x/24 | High |
| 80 | Voice Services | VoIP and telephony | 10.x.x.x/24 | Medium |
| 90 | IoT Devices | Internet of Things | 10.x.x.x/24 | Low |

### Security Configuration

1. **Inter-VLAN Routing**: Controlled via pfSense firewall
2. **Access Control Lists**: Strict egress/ingress rules
3. **Firewall Zones**: Security boundaries between VLANs
4. **Logging**: All inter-VLAN communication is captured

### Implementation

- **pfSense Configuration**: Firewall rules defined per VLAN
- **Switch Configuration**: Access control and VLAN tagging
- **Router Configuration**: Inter-VLAN routing for necessary communication
- **Monitoring**: Real-time visibility into network usage

## Hardware Infrastructure

### Network Equipment

- **Firewall**: pfSense on dedicated hardware
- **Switches**: Managed switches with VLAN support
- **Access Points**: Wireless routers with VLAN segregation
- **Monitoring Equipment**: Network taps for security monitoring

### Physical Layout

```
Core Rack Layout:
├── Network Management
│   ├── pfSense Firewall
│   ├── Network Monitoring
│   └── Backup Storage
├── Production Services
│   ├── Server 1 (HOMELAB-01)
│   ├── Server 2 (HOMELAB-02)
│   └── Server 3 (HOMELAB-03)
└── Edge Services
    ├── Raspberry Pi 1 (PI-01)
    ├── Raspberry Pi 2 (PI-02)
    ├── Raspberry Pi 3 (PI-03)
    └── Raspberry Pi 4 (PI-04)
```