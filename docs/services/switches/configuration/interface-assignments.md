# Interface Assignments

## Overview

This document details the interface configurations and assignments for both Cisco switches in the network infrastructure.

## HOMELAB-SW01 (Cisco 2960-24TC-L)

### Interface Status

| Interface | Status | Protocol | VLAN | Description |
|-----------|--------|----------|-----|-------------|
| Vlan1 | admin down | down | N/A | Default VLAN (disabled) |
| Vlan10 | up | up | 10 | Management VLAN |
| FastEthernet0/1 | up | up | 20 | Uplink to WiFi AP |
| FastEthernet0/2 | up | up | 10 | Uplink to Tertiary |
| FastEthernet0/3 | down | down | 20 | Unused |
| FastEthernet0/4 | down | down | 20 | Unused |
| FastEthernet0/5 | down | down | 20 | Unused |
| FastEthernet0/6 | down | down | 20 | Unused |
| FastEthernet0/7 | up | up | 90 | Bridge Port |
| FastEthernet0/8 | up | up | 20 | Bridge Port |
| GigabitEthernet0/1 | up | up | Trunk | Uplink to pfSense |
| Port-channel1 | up | up | Trunk | Uplink to SW02 |

### Port Details

#### Trunk Ports

**GigabitEthernet0/1 - Uplink to pfSense**
```
description UPLINK-TO-PFSENSE
switchport trunk encapsulation dot1q
switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
switchport mode trunk
spanning-tree portfast trunk
```

**FastEthernet0/1 - Uplink to WiFi AP**
```
description UPLINK-TO-WIFI-AP
switchport access vlan 20
switchport trunk encapsulation dot1q
switchport trunk native vlan 60
switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
switchport mode access
```

**FastEthernet0/2 - Uplink to Tertiary**
```
description UPLINK-TO-TERTIARY
switchport access vlan 10
switchport trunk encapsulation dot1q
switchport trunk native vlan 999
switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
switchport mode trunk
```

**FastEthernet0/7 & FastEthernet0/8 - Bridge Ports**
```
description BRIDGE-PORT
switchport access vlan 90 (Fa0/7) / 20 (Fa0/8)
switchport trunk encapsulation dot1q
switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
switchport mode trunk
channel-group 1 mode active
```

#### Port-Channel

**Port-channel1 - Uplink to SW02**
```
description UPLINK-TO-SW02
switchport access vlan 20
switchport trunk encapsulation dot1q
switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
switchport mode trunk
spanning-tree portfast trunk
```

## HOMELAB-SW02 (Cisco 3560-8PC-S)

### Interface Status

| Interface | Status | Protocol | VLAN | Description |
|-----------|--------|----------|-----|-------------|
| Vlan1 | shutdown | down | N/A | Default VLAN (disabled) |
| Vlan10 | up | up | 10 | Management VLAN |
| FastEthernet0/1 | down | down | - | Unused |
| FastEthernet0/2 | up | up | 30 | SearxNG Server |
| FastEthernet0/3 | down | down | - | Unused |
| FastEthernet0/4 | up | up | 30 | Repository |
| FastEthernet0/5 | down | down | - | Unused |
| FastEthernet0/6 | up | up | 30 | Black PI |
| FastEthernet0/7 | down | down | - | Unused |
| FastEthernet0/8 | up | up | 30 | 3CX |
| FastEthernet0/9 | down | down | - | Unused |
| FastEthernet0/10 | up | up | 30 | Unassigned |
| FastEthernet0/11-17 | down | down | - | Unused |
| FastEthernet0/18 | up | up | 20 | TrueNAS Scale |
| FastEthernet0/19 | down | down | - | Unused |
| FastEthernet0/20 | up | up | Trunk | Trunk to Secondary PVE |
| FastEthernet0/21 | down | down | - | Unused |
| FastEthernet0/22 | up | up | Trunk | Trunk to Primary PVE |
| FastEthernet0/23 | up | up | 20 | General |
| FastEthernet0/24 | down | down | 30 | Link to Primary Proxmox |
| GigabitEthernet0/1 | up | up | Trunk | Port-channel to SW01 |
| GigabitEthernet0/2 | up | up | Trunk | Port-channel to SW01 |
| Port-channel1 | up | up | Trunk | Uplink to SW01 |

### Port Details

#### Access Ports

**FastEthernet0/2 - SearxNG Server**
```
description SearxNG-Server
switchport access vlan 30
switchport mode access
```

**FastEthernet0/4 - Repository Server**
```
description Repository
switchport access vlan 30
switchport mode access
```

**FastEthernet0/6 - Black PI**
```
description Black PI
switchport access vlan 30
switchport mode access
```

**FastEthernet0/8 - 3CX**
```
description 3CX
switchport access vlan 30
switchport mode access
```

**FastEthernet0/18 - TrueNAS Scale**
```
description TrueNAS Scale
switchport access vlan 20
switchport mode access
```

#### Trunk Ports

**FastEthernet0/20 - Trunk to Secondary PVE**
```
description TRUNK-TO-SECONDARY-PVE
switchport access vlan 10
switchport trunk native vlan 999
switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
switchport mode trunk
```

**FastEthernet0/22 - Trunk to Primary PVE**
```
description TRUNK-TO-PRIMARY-PVE
switchport access vlan 10
switchport trunk native vlan 999
switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
switchport mode trunk
```

#### Port-Channel

**GigabitEthernet0/1 & GigabitEthernet0/2**
```
switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
switchport mode trunk
channel-group 1 mode active
```

## Port Utilization Summary

### HOMELAB-SW01
- **Total Ports**: 24 + 2 uplink
- **Active Ports**: 8
- **Trunk Ports**: 6
- **Access Ports**: 2
- **Unused Ports**: 16

### HOMELAB-SW02
- **Total Ports**: 8 + 1 uplink
- **Active Ports**: 10
- **Trunk Ports**: 5
- **Access Ports**: 5
- **Unused Ports**: 2

## Port Labeling

All active ports are clearly labeled with:
- Connection type (trunk/access)
- Destination device
- VLAN assignment

Example labels:
- "UPLINK-TO-PFSENSE"
- "TRUNK-TO-PRIMARY-PVE"
- "SearxNG-Server"