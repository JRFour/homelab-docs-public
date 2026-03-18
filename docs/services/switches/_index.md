# Switches Overview

This documentation covers the network switching infrastructure for the home lab, including configuration, VLAN setup, and management.

## Current Status

- **Switch Count**: 2 Cisco managed switches
- **Models**: Cisco WS-C2960-24TC-L and Cisco WS-C3560-8PC-S
- **Firmware**: Cisco IOS 12.2
- **Management IP**: 10.10.10.2 (HOMELAB-SW01), 10.10.10.3 (HOMELAB-SW02)

## Switch Roles

### HOMELAB-SW01 (Router Switch)
- **Model**: Cisco WS-C2960-24TC-L
- **Purpose**: Primary switch for router/firewall connections
- **Management IP**: 10.10.10.2
- **Key Functions**: 
  - Uplink to pfSense firewall
  - Trunk ports to WiFi access points
  - Bridge port connectivity
  - Inter-switch link to HOMELAB-SW02

### HOMELAB-SW02 (Server Switch)
- **Model**: Cisco WS-C3560-8PC-S
- **Purpose**: Server and storage connectivity
- **Management IP**: 10.10.10.3
- **Key Functions**:
  - Proxmox server connections
  - TrueNAS storage connectivity
  - Development server ports
  - Media server connections

## Network Architecture

The switching infrastructure provides:
- 9-VLAN network segmentation
- Trunk ports for inter-VLAN routing
- Port-channel links for redundancy
- SSH-based management access
- Comprehensive port labeling

## VLAN Configuration

All switches implement the following VLAN structure:
- VLAN 10: Network Management
- VLAN 20: Production Services
- VLAN 30: Media
- VLAN 40: Lab/Development
- VLAN 50: IoT/Home Automation
- VLAN 60: Guest Networks
- VLAN 70: DMZ
- VLAN 80: Bastion
- VLAN 90: Automation

## Documentation Sections

### Current Setup
- Hardware specifications and firmware details
- VLAN configuration across switches
- Management interface setup

### Configuration
- Interface assignments and port roles
- Spanning-tree configuration
- Security settings

### Network Design
- Physical topology
- Redundancy configurations

### Best Practices
- Upgrade recommendations
- Security hardening
- Performance optimization