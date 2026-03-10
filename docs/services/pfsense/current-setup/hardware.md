# Hardware Configuration

## Device Specification

**Model**: Protectli Vault fw4b
**Firmware**: pfSense Community Edition 2.8.0

## Hardware Details

The Protectli Vault fw4b is a purpose-built firewall and router appliance designed for enterprise-grade security and performance. Key specifications include:

- **CPU**: Intel Atom x5-Z8350 processor (1.44 GHz quad-core)
- **Memory**: 4 GB DDR3 RAM
- **Storage**: 32 GB eMMC storage
- **Network Interfaces**: 4x Gigabit Ethernet ports
- **Power**: Standard ATX power supply
- **Form Factor**: 1U rackmountable

## Network Interface Configuration

The device is configured with the following network interfaces:

### WAN Interface
- Interface: `wan`
- Description: Internet-facing interface
- Physical port: eth0
- Mode: DHCP or static IP assignment

### LAN Interfaces
- Interface: `lan1` (VLAN 10 - Management)
- Interface: `lan2` (VLAN 20 - Production)
- Interface: `lan3` (VLAN 30 - Secure Zone)
- Interface: `lan4` (VLAN 40 - Guest)
- Interface: `lan5` (VLAN 50 - Monitoring)
- Interface: `lan6` (VLAN 60 - Development)
- Interface: `lan7` (VLAN 70 - Storage)
- Interface: `lan8` (VLAN 80 - Voice)
- Interface: `lan9` (VLAN 90 - IoT)

## Physical Setup

The device is installed in a 1U rack with:
- Power cable connected
- Network cables terminated to appropriate VLANs
- Console access available for local management
- Serial console for emergency access