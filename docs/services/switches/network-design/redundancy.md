# Redundancy Configuration

## Overview

This document details the redundancy capabilities and considerations for the network switching infrastructure.

## Current Redundancy Features

### Port-Channel (EtherChannel)

#### Configuration
- **Technology**: LACP (Link Aggregation Control Protocol)
- **Mode**: Active (both ends initiate)
- **Ports**: GigabitEthernet0/1 and GigabitEthernet0/2 on SW02
- **Partner**: GigabitEthernet0/7 and GigabitEthernet0/8 on SW01

#### Benefits
1. **Bandwidth Aggregation**: Combines 2x 1Gbps into single 2Gbps link
2. **Automatic Failover**: If one link fails, traffic reroutes automatically
3. **Load Balancing**: Distributes traffic across links
4. **Loop Prevention**: STP treats as single logical interface

#### Status
- **State**: Up/Up
- **Protocol**: LACP
- **Working Ports**: 2

### Spanning Tree Protocol

#### Root Bridge Redundancy
- **Primary Root**: HOMELAB-SW01
- **Secondary Root**: HOMELAB-SW02
- **Mechanism**: PVST provides failover

#### Port States
- Blocking ports prevent loops
- Automatic failover on link failure

## Network Resilience

### Current Failover Scenarios

#### Scenario 1: Switch-to-Switch Link Failure
```
Current: SW01 ↔ SW02 (Port-channel)
Failure: One physical link fails
Result: Traffic continues on remaining link
Recovery: Automatic (< 1 second with LACP)
```

#### Scenario 2: Complete Port-Channel Failure
```
Current: Both Port-channel links fail
Result: Traffic stops until STP reconverges
Recovery: STP takes over (30-50 seconds)
```

#### Scenario 3: Switch Failure (SW01)
```
Current: SW01 connected to pfSense
Failure: Complete switch failure
Result: All SW01-connected devices lose connectivity
Recovery: Requires manual intervention or redundant links
```

#### Scenario 4: Switch Failure (SW02)
```
Current: SW02 connected to Proxmox cluster
Failure: Complete switch failure
Result: Proxmox cluster connectivity lost
Recovery: Requires manual intervention or redundant links
```

## Gaps in Redundancy

### Single Points of Failure

1. **pfSense Uplink**
   - Single connection from SW01 to pfSense
   - No redundant link
   - Impact: Complete network outage if fails

2. **Switch-to-Switch Bandwidth**
   - Limited to 2 Gbps total
   - Single point for all inter-VLAN traffic
   - Impact: Performance bottleneck during peak

3. **WiFi AP Connection**
   - Single connection to SW01
   - No backup link
   - Impact: WiFi outage if port/link fails

4. **Server Connections**
   - Each server typically has single connection
   - No NIC teaming implemented
   - Impact: Server connectivity depends on single port

### Recommendations for Improvement

#### High Priority

1. **Dual Uplinks to pfSense**
   - Add second trunk port from SW01 to pfSense
   - Configure port-channel
   - Benefit: Failover for gateway connectivity

2. **Switch Redundancy**
   - Add third switch for full mesh
   - Implement redundant links to critical servers
   - Benefit: Zero single points of failure

#### Medium Priority

3. **NIC Teaming on Servers**
   - Configure NIC teaming on Proxmox hosts
   - Connect to both switches
   - Benefit: Server-level redundancy

4. **WiFi AP Backup**
   - Add secondary WiFi controller
   - Configure automatic failover
   - Benefit: Continuous WiFi availability

#### Low Priority

5. **Uplink Bandwidth**
   - Upgrade to 10GbE uplinks
   - Add additional port-channel members
   - Benefit: Higher bandwidth capacity

## Virtual Redundancy

### Alternative Solutions

#### Mesh Networking
- Consider Cisco mesh APs
- Self-healing wireless network
- Eliminates single WiFi AP failure

#### Stackable Switches
- Single management, multiple hardware
- Automatic failover within stack
- Simplified configuration

## Disaster Recovery

### Switch Failure Procedures

#### If HOMELAB-SW01 Fails
1. Identify affected connections
2. Route around via alternative paths if available
3. Replace/repair switch
4. Restore configuration from backup
5. Verify all connectivity

#### If HOMELAB-SW02 Fails
1. Identify affected servers
2. Verify Proxmox cluster status
3. Replace/repair switch
4. Restore port configurations
5. Verify server connectivity

### Backup Configuration

Regular backups should include:
- Running configuration
- Startup configuration
- VLAN database
- Port assignments
- Port-channel configuration

### Configuration Restoration
```
copy tftp running-config
copy tftp startup-config
```

## Monitoring Redundancy

### Key Metrics to Monitor

1. **Port-Channel Status**
   ```
   show etherchannel summary
   show lacp neighbor
   ```

2. **Spanning-Tree Status**
   ```
   show spanning-tree root
   show spanning-tree interface
   ```

3. **Link Status**
   ```
   show interface status
   show interface trunk
   ```

### Alerting Recommendations

Set up alerts for:
- Port-channel member down
- Port state changes
- STP topology changes
- Interface errors

## Summary Table

| Redundancy Feature | Current Status | Priority |
|-------------------|----------------|----------|
| Port-Channel | Implemented | - |
| Spanning Tree | Implemented | - |
| pfSense Uplink | Single | High |
| Switch Redundancy | None | High |
| Server NIC Teaming | None | Medium |
| WiFi AP Backup | None | Low |