# Spanning Tree Protocol Configuration

## Overview

Spanning Tree Protocol (STP) is implemented on both Cisco switches to prevent loops in the network topology and provide path redundancy.

## Current STP Configuration

### Spanning Tree Mode

Both switches use Per-VLAN Spanning Tree (PVST):

```
spanning-tree mode pvst
spanning-tree extend system-id
```

### PVST Characteristics
- Separate spanning tree instance per VLAN
- Optimal path selection per VLAN
- Faster convergence than CST
- Cisco-proprietary enhancement

## Spanning Tree Operation

### Root Bridge Selection

#### HOMELAB-SW01 (Primary)
- Acts as root bridge for most VLANs
- Lower bridge ID priority
- Connected directly to pfSense router

#### HOMELAB-SW02 (Secondary)
- Backup root bridge
- Higher bridge ID priority
- Provides path redundancy

### Port States

| State | Behavior | Forwarding Traffic |
|-------|----------|-------------------|
| Forwarding | Normal operation | Yes |
| Learning | Preparing but not forwarding | No |
| Blocking | Preventing loops | No |
| Disabled | Admin shutdown | No |
| Listening | Transition state | No |

## PortFast Configuration

### Trunk Ports with PortFast

The following trunk ports have PortFast enabled for faster convergence:

#### HOMELAB-SW01
```
spanning-tree portfast trunk
```
Applied to:
- GigabitEthernet0/1 (Uplink to pfSense)
- Port-channel1 (Uplink to SW02)

#### HOMELAB-SW02
```
spanning-tree portfast trunk
```
Applied to:
- Port-channel1 (Uplank to SW01)

### PortFast Purpose
- Bypass listening/learning states on trunk ports
- Reduces convergence time
- Used for ports connected to routers/switches (not endpoints)

### PortFast Usage Guidelines
**Do NOT enable PortFast on:**
- Access ports with end devices
- Ports that might create loops
- User workstation ports

**OK to enable PortFast on:**
- Trunk ports to routers
- Trunk ports to other switches
- Uplink ports
- Ports with known topology

## Loop Prevention

### Current Measures

1. **Port-Channel (EtherChannel)**
   - Provides redundant paths
   - Load balances traffic
   - Prevents loop formation

2. **Trunk Allowed VLANs**
   - Only explicitly allowed VLANs can traverse
   - Prevents unauthorized VLAN spreading
   - Limits broadcast domains

3. **Native VLAN Separation**
   - Native VLAN set to unused VLAN (999)
   - Prevents VLAN 1 traffic hijacking

## STP Security

### Potential Issues

#### BPDU Guard
- Not currently configured
- Would prevent unauthorized switch connections
- Recommended for access ports

**Configuration:**
```
spanning-tree portfast bpduguard default
```

#### Root Guard
- Not currently configured
- Would prevent root bridge role change
- Recommended on ports connecting to less trusted switches

**Configuration:**
```
spanning-tree guard root
```

#### Loop Guard
- Not currently configured
- Would detect unidirectional links
- Recommended for critical links

**Configuration:**
```
spanning-tree loopguard default
```

## Monitoring STP

### Show Commands

#### View STP Status
```
show spanning-tree
show spanning-tree vlan <vlan-id>
show spanning-tree interface <interface>
show spanning-tree bridge
```

#### View Port States
```
show spanning-tree portfast
show spanning-tree blockedports
```

### Key Metrics to Monitor
- Root bridge elections
- Port state changes
- Topology changes
- Blocking/forwarding states

## Troubleshooting

### Common STP Issues

1. **Excessive Topology Changes**
   - Check for flapping links
   - Verify cable integrity
   - Check for spanning-tree loop

2. **Slow Convergence**
   - Verify PortFast on correct ports
   - Check link duplex/speed
   - Review load balancing

3. **Root Bridge Issues**
   - Verify root bridge priority
   - Check for unintended root election
   - Review BPDU transmission

### Recovery Steps
1. Identify affected VLAN
2. Check port states
3. Review recent changes
4. Clear spanning-tree if needed:
   ```
   clear spanning-tree detected-protocols
   ```

## Recommendations

### Immediate Improvements
1. Enable BPDU Guard on access ports
2. Configure Root Guard on trunk ports to edge switches
3. Enable Loop Guard on important links

### Future Enhancements
1. Consider Rapid PVST+ (RSTP) for faster convergence
2. Implement MSTP for load balancing
3. Add redundant links with proper STP tuning