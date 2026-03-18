# VLAN Configuration

## Overview

Both switches implement a comprehensive 9-VLAN network segmentation strategy using 802.1Q trunking. This provides network isolation, security, and traffic management across all network segments.

## VLAN Structure

### VLAN Assignment Table

| VLAN ID | Name | Subnet | Purpose | Switch Ports |
|---------|------|--------|---------|--------------|
| 1 | Default | N/A | Unused (admin down) | N/A |
| 10 | Management | 10.10.0.0/24 | Infrastructure management | Trunk only |
| 20 | Production | 10.20.0.0/24 | Core production services | Access + Trunk |
| 30 | Media | 10.30.0.0/24 | Media streaming | Access + Trunk |
| 40 | Lab | 10.40.0.0/24 | Development/testing | Access + Trunk |
| 50 | IoT | 10.50.0.0/24 | Smart home devices | Access + Trunk |
| 60 | Guest | 10.60.0.0/24 | Guest network | Access + Trunk |
| 70 | DMZ | 10.70.0.0/24 | Public-facing services | Access + Trunk |
| 80 | Bastion | 10.80.0.0/24 | Security/access | Access + Trunk |
| 90 | Automation | 10.90.0.0/24 | Workflow automation | Access + Trunk |

## Trunk Port Configuration

### Allowed VLANs on Trunks

All trunk ports are configured to carry the following VLANs:
```
Allowed VLANs: 10, 20, 30, 40, 50, 60, 70, 80, 90
```

### HOMELAB-SW01 Trunk Ports

| Interface | Description | Allowed VLANs | Native VLAN |
|-----------|-------------|---------------|-------------|
| GigabitEthernet0/1 | Uplink to pfSense | 10,20,30,40,50,60,70,80,90 | 1 (default) |
| FastEthernet0/1 | Uplink to WiFi AP | 10,20,30,40,50,60,70,80,90 | 60 |
| FastEthernet0/2 | Uplink to Tertiary | 10,20,30,40,50,60,70,80,90 | 999 |
| FastEthernet0/7 | Bridge Port | 10,20,30,40,50,60,70,80,90 | 1 (default) |
| FastEthernet0/8 | Bridge Port | 10,20,30,40,50,60,70,80,90 | 1 (default) |
| Port-channel1 | Uplink to SW02 | 10,20,30,40,50,60,70,80,90 | 1 (default) |

### HOMELAB-SW02 Trunk Ports

| Interface | Description | Allowed VLANs | Native VLAN |
|-----------|-------------|---------------|-------------|
| FastEthernet0/20 | Trunk to Secondary PVE | 10,20,30,40,50,60,70,80,90 | 999 |
| FastEthernet0/22 | Trunk to Primary PVE | 10,20,30,40,50,60,70,80,90 | 999 |
| FastEthernet0/23 | General Trunk | 10,20,30,40,50,60,70,80,90 | 999 |
| FastEthernet0/24 | Trunk to Proxmox | 10,20,30,40,50,60,70,80,90 | 10 |
| GigabitEthernet0/1 | Port-channel to SW01 | 10,20,30,40,50,60,70,80,90 | 1 (default) |
| GigabitEthernet0/2 | Port-channel to SW01 | 10,20,30,40,50,60,70,80,90 | 1 (default) |
| Port-channel1 | Uplink to SW01 | 10,20,30,40,50,60,70,80,90 | 1 (default) |

## VLAN Configuration Commands

### Creating VLANs
```
vlan 10
 name Management
vlan 20
 name Production
vlan 30
 name Media
vlan 40
 name Lab
vlan 50
 name IoT
vlan 60
 name Guest
vlan 70
 name DMZ
vlan 80
 name Bastion
vlan 90
 name Automation
```

### Trunk Port Configuration Example
```
interface GigabitEthernet0/1
 description UPLINK-TO-PFSENSE
 switchport trunk encapsulation dot1q
 switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
 switchport mode trunk
 spanning-tree portfast trunk
```

### Access Port Configuration Example
```
interface FastEthernet0/2
 description Server-Port
 switchport access vlan 20
 switchport mode access
```

## Native VLAN Configuration

### Management VLAN
- **Native VLAN**: 10 (Management)
- **Purpose**: Switch management and inter-VLAN routing
- **Security Note**: Native VLAN should be changed from default VLAN 1

### Native VLAN Settings
| Port | Switch | Native VLAN |
|------|--------|--------------|
| WiFi AP Uplink | SW01 | 60 (Guest) |
| Tertiary Switch | SW01 | 999 (Unused) |
| Proxmox Links | SW02 | 999 (Unused) |
| General Trunk | SW02 | 999 (Unused) |

## VLAN Routing

### Inter-VLAN Communication
- **Router**: pfSense handles inter-VLAN routing
- **Management Gateway**: 10.10.0.1
- **Switch Management**: 10.10.0.2 (SW01), 10.10.0.3 (SW02)

### Default Gateway Configuration
```
ip default-gateway 10.10.0.1
```

## VLAN Security

### Current Security Measures
- Unused ports assigned to unused VLAN (999)
- Native VLAN changed from default VLAN 1
- Trunk ports explicitly specify allowed VLANs
- Port security available but not fully configured

### Recommended Security Enhancements
- Enable DHCP snooping
- Implement VLAN access control lists (VACLs)
- Configure private VLANs for additional isolation
- Enable ARP inspection (DAI)