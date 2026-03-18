# VLAN Configuration

## Overview
The home lab implements a 9-VLAN network segmentation strategy designed for optimal security isolation and performance.

## VLAN Mapping

| VLAN ID | Name | Purpose | Subnet | Security Level |
|--------|------|---------|--------|---------------|
| 10 | Network Management | Core infrastructure management | 10.10.0.0/24 | High |
| 20 | Application Services | Main application stack | 10.20.0.0/24 | High |
| 30 | Secure Zone | Internal services | 10.30.0.0/24 | Medium |
| 40 | Guest Networks | Visitor services | 10.40.0.0/24 | Low |
| 50 | Security Monitoring | Logging and alerting | 10.50.0.0/24 | High |
| 60 | Development | Software development | 10.60.0.0/24 | Medium |
| 70 | Storage Services | File storage and NAS | 10.70.0.0/24 | High |
| 80 | Voice Services | VoIP and telephony | 10.80.0.0/24 | Medium |
| 90 | IoT Devices | Internet of Things | 10.90.0.0/24 | Low |

## VLAN Assignments

### Management VLAN (10.10.0.0/24)
- Interface: `lan1`
- Purpose: Network management services
- Devices: pfSense router, management servers, monitoring tools

### Production VLAN (10.20.0.0/24)
- Interface: `lan2`
- Purpose: Production application services
- Devices: Application servers, databases, authentication services

### Secure Zone VLAN (10.30.0.0/24)
- Interface: `lan3`
- Purpose: Internal services requiring additional security
- Devices: Backup servers, internal services

### Guest VLAN (10.40.0.0/24)
- Interface: `lan4`
- Purpose: Visitor network access
- Devices: Guest devices, temporary access

### Security Monitoring VLAN (10.50.0.0/24)
- Interface: `lan5`
- Purpose: Monitoring and security services
- Devices: Monitoring servers, SIEM systems

### Development VLAN (10.60.0.0/24)
- Interface: `lan6`
- Purpose: Development and testing services
- Devices: Developer workstations, CI/CD servers

### Storage VLAN (10.70.0.0/24)
- Interface: `lan7`
- Purpose: File storage services
- Devices: NAS servers, storage arrays

### Voice VLAN (10.80.0.0/24)
- Interface: `lan8`
- Purpose: Voice services
- Devices: IP phones, VoIP servers

### IoT VLAN (10.90.0.0/24)
- Interface: `lan9`
- Purpose: Internet of Things devices
- Devices: Smart home devices, sensors, etc.

## Traffic Flow Matrix

The VLAN configuration implements a controlled flow model with:

1. **Management VLAN** controls access to all other VLANs
2. **Production VLAN** has limited access to other networks
3. **IoT VLAN** has strict ingress restrictions
4. **Guest VLAN** has minimal access to core services
5. **Development VLAN** has restricted access between networks

This segmentation provides defense-in-depth while maintaining operational functionality.