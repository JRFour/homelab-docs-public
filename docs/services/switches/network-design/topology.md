# Network Topology

## Physical Topology

### Overview

The network infrastructure uses a two-switch design with trunk connections to the pfSense firewall and Proxmox cluster:

```
                    ┌─────────────────────┐
                    │    pfSense FW       │
                    │   (10.x.x.x)      │
                    └──────────┬──────────┘
                               │
                    ┌──────────┴──────────┐
                    │   HOMELAB-SW01       │
                    │  Cisco 2960-24TC-L │
                    │   (10.x.x.x)      │
                    └──────────┬──────────┘
                               │
                    ┌──────────┴──────────┐
                    │  Port-Channel 1    │
                    │   (EtherChannel)    │
                    └──────────┬──────────┘
                               │
                    ┌──────────┴──────────┐
                    │   HOMELAB-SW02      │
                    │   Cisco 3560-8PC-S  │
                    │   (10.x.x.x)      │
                    └──────────┬──────────┘
                               │
         ┌─────────────────────┼─────────────────────┐
         │                     │                     │
         │                     │                     │
   ┌─────┴─────┐        ┌──────┴──────┐      ┌──────┴──────┐
   │  Proxmox │        │   Servers   │      │   WiFi AP   │
   │  Cluster │        │  (Various)  │      │  (VLAN 60)  │
   └───────────┘        └─────────────┘      └─────────────┘
```

## Network Segments

### Management Segment (VLAN 10)
- **Network**: 10.x.x.x/24
- **Gateway**: 10.x.x.x (pfSense)
- **Switch Management**: 10.x.x.x (SW01), 10.x.x.x (SW02)
- **Purpose**: Infrastructure management

### Production Segment (VLAN 20)
- **Network**: 10.x.x.x/24
- **Devices**: TrueNAS, general servers
- **Access**: Multiple ports on both switches

### Media Segment (VLAN 30)
- **Network**: 10.x.x.x/24
- **Devices**: SearxNG, Repository, Black PI, 3CX
- **Access**: Multiple ports on SW02

### Other VLANs
- VLAN 40-90: Trunked to all switches
- Each serves specific purpose
- Access controlled at pfSense level

## Traffic Flow

### Inter-Switch Communication

1. **Port-Channel 1**: Gigabit EtherChannel
   - Provides 2 Gbps bandwidth
   - LACP active mode
   - Redundant paths

2. **Bridge Ports (SW01)**: Fast Ethernet
   - FastEthernet0/7 and Fa0/8
   - Additional redundancy

### WAN Connectivity

1. pfSense → SW01 (GigabitEthernet0/1)
   - All VLANs trunked
   - Tagged traffic

2. SW01 → SW02 (Port-channel1)
   - All VLANs trunked
   - Full redundancy

### Server Connectivity

#### Proxmox Cluster
- **Primary**: Trunk on Fa0/22 (SW02)
- **Secondary**: Trunk on Fa0/20 (SW02)
- **Tertiary**: Fa0/24 (SW02)
- All Proxmox nodes have trunk connections

#### Storage (TrueNAS)
- **Connection**: Fa0/18 (SW02)
- **VLAN**: 20 (Production)

## Port Distribution

### HOMELAB-SW01 (24 ports + 2 uplinks)
| Usage | Ports | Status |
|-------|-------|--------|
| Trunk to pfSense | Gi0/1 | Active |
| Trunk to SW02 | Po1 | Active |
| WiFi AP | Fa0/1 | Active |
| Tertiary Switch | Fa0/2 | Active |
| Bridge Ports | Fa0/7, Fa0/8 | Active |
| Unused | Fa0/3-6 | Down |

### HOMELAB-SW02 (8 ports + 1 uplink)
| Usage | Ports | Status |
|-------|-------|--------|
| Server Ports | Fa0/2,4,6,8,10,18 | Active |
| Proxmox Links | Fa0/20,22,24 | Active |
| Trunk to SW01 | Po1 (Gi0/1-2) | Active |
| Unused | Fa0/1,3,5,7,9,11-17,19,21 | Down |

## Bandwidth Considerations

### Current Capacity
- **Inter-switch**: 2 Gbps (GigE port-channel)
- **Uplink to router**: 1 Gbps
- **Access ports**: 100 Mbps (Fast Ethernet)

### Potential Bottlenecks
- 100 Mbps access ports for high-throughput servers
- Single uplink to pfSense (1 Gbps)

### Recommendations
- Upgrade to Gigabit switches
- Add second uplink to pfSense
- Consider 10GbE uplinks for storage

## Network Diagrams

### VLAN Flow
```
Internet
   │
   ▼
pfSense Firewall
   │
   │ Trunk (All VLANs)
   ▼
HOMELAB-SW01
   │
   │ Port-Channel
   ▼
HOMELAB-SW02
   │
   ├──▶ Production VLAN (Servers)
   ├──▶ Media VLAN (Media servers)
   ├──▶ Lab VLAN (Development)
   ├──▶ IoT VLAN (Smart home)
   ├──▶ Guest VLAN (Visitors)
   ├──▶ DMZ VLAN (Public services)
   ├──▶ Bastion VLAN (Admin access)
   └──▶ Automation VLAN (Workflows)
```

### Redundant Path Example
```
Server A ──┐
          │
          ├─▶ SW02 ──Port-Channel──▶ SW01 ──▶ pfSense
          │
Server B ──┘
```