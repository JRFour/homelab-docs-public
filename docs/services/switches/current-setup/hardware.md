# Hardware Specifications

## Switch Inventory

### HOMELAB-SW01 (Router Switch)

| Specification | Details |
|--------------|---------|
| **Model** | Cisco WS-C2960-24TC-L |
| **Type** | Fixed Configuration, Stackable Managed Switch |
| **Ports** | 24 x 10/100 Ethernet ports + 2 x dual-purpose uplink ports (10/100/1000) |
| **Forwarding Bandwidth** | 16 Gbps |
| **Switching Bandwidth** | 32 Gbps |
| **Flash Memory** | 16 MB |
| **DRAM** | 64 MB |
| **MAC Address Table** | 8,000 entries |
| **VLAN Support** | 255 VLANs |
| **Firmware Version** | Cisco IOS 12.2 |
| **Management IP** | 10.10.10.2 |
| **Hostname** | HOMELAB-SW01 |
| **Domain** | hogwarts.home |

### HOMELAB-SW02 (Server Switch)

| Specification | Details |
|--------------|---------|
| **Model** | Cisco WS-C3560-8PC-S |
| **Type** | Fixed Configuration, PoE Managed Switch |
| **Ports** | 8 x 10/100 Ethernet ports with PoE + 1 x dual-purpose uplink |
| **PoE Budget** | 123W |
| **Forwarding Bandwidth** | 10 Gbps |
| **Switching Bandwidth** | 32 Gbps |
| **Flash Memory** | 16 MB |
| **DRAM** | 64 MB |
| **MAC Address Table** | 12,000 entries |
| **VLAN Support** | 1,005 VLANs |
| **Firmware Version** | Cisco IOS 12.2 |
| **Management IP** | 10.10.10.3 |
| **Hostname** | HOMELAB-SW02 |
| **Domain** | hogwarts.home |

## Physical Installation

### Rack Placement
- Both switches installed in 42U server rack
- Positioned for optimal cable management
- Adequate airflow clearance

### Network Connections

#### HOMELAB-SW01 Connections
| Interface | Connection | Purpose |
|-----------|------------|---------|
| GigabitEthernet0/1 | pfSense WAN | Trunk to firewall |
| FastEthernet0/1 | WiFi AP | Trunk port |
| FastEthernet0/2 | Tertiary switch | Trunk port |
| FastEthernet0/7 | Bridge port | Inter-switch |
| FastEthernet0/8 | Bridge port | Inter-switch |
| Port-channel1 | HOMELAB-SW02 | Trunk link |

#### HOMELAB-SW02 Connections
| Interface | Connection | Purpose |
|-----------|------------|---------|
| FastEthernet0/2 | SearxNG Server | Access port |
| FastEthernet0/4 | Repository Server | Access port |
| FastEthernet0/6 | Black PI | Access port |
| FastEthernet0/8 | 3CX | Access port |
| FastEthernet0/20 | Secondary PVE | Trunk port |
| FastEthernet0/22 | Primary PVE | Trunk port |
| FastEthernet0/24 | Primary Proxmox | Trunk port |
| GigabitEthernet0/1 | HOMELAB-SW01 | Port-channel |
| GigabitEthernet0/2 | HOMELAB-SW01 | Port-channel |
| Port-channel1 | HOMELAB-SW01 | Trunk link |

## Power Requirements

### Power Consumption
- HOMELAB-SW01: 30W typical
- HOMELAB-SW02: 15W typical (plus PoE devices)

### Power Configuration
- Standard AC power connection
- No redundant power supply (future upgrade consideration)
- UPS protected

## Environmental

### Operating Conditions
- Temperature: 0°C to 45°C (32°F to 113°F)
- Humidity: 10% to 95% non-condensing
- Altitude: Up to 10,000 feet

### Cooling
- Internal fan cooling
- Front-to-back airflow
- Rack-mounted with proper ventilation

## Firmware Information

### Current IOS Version
Both switches run Cisco IOS 12.2, which provides:
- Basic layer 2 switching features
- VLAN support (802.1Q trunking)
- Spanning Tree Protocol (PVST)
- Port security features
- SSH version 2 for management

### IOS Features
- 802.1Q VLAN tagging
- Port-based VLANs
- Trunk ports with allowed VLAN lists
- Port-channel (EtherChannel) support
- Port security
- DHCP snooping capability
- IP device tracking

## Upgrade Considerations

### Firmware Upgrade Path
- Current: Cisco IOS 12.2
- Recommended: Latest stable IOS 15.x series (if hardware supports)
- Note: 2960 series may have limited upgrade options

### Hardware Limitations
- 2960-24TC-L: Limited to IOS 15.x depending on flash size
- 3560-8PC-S: Full IOS 15.x support available

### Future Enhancements
- Consider stackable switches for redundancy
- Upgrade to Gigabit switches for all ports
- Add PoE+ switches for modern APs