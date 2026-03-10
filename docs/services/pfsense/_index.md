# pfSense Overview

This documentation covers the pfSense router and firewall configuration for the home lab infrastructure.

## Current Status
- **Hardware**: Protectli Vault fw4b
- **Version**: pfSense Community Edition 2.8.0
- **Services**: VLAN routing, DHCP, DNS resolver, static IP assignments
- **VPN**: Not on pfSense (separate servers)

## Architecture
The pfSense firewall serves as the central networking hub, implementing:
- 9-VLAN network segmentation
- Strict inter-VLAN communication controls
- Comprehensive firewall rule enforcement
- Network address translation (NAT)

## VLAN Configuration
The infrastructure utilizes a 9-VLAN network segmentation scheme:
- VLAN 10: Network Management
- VLAN 20: Production Services
- VLAN 30: Secure Zone
- VLAN 40: Guest Networks
- VLAN 50: Security Monitoring
- VLAN 60: Development
- VLAN 70: Storage Services
- VLAN 80: Voice Services
- VLAN 90: IoT Devices

## Network Security
All inter-VLAN communication is strictly controlled through firewall rules with logging enabled.