# Configuration Overview

## Interfaces

### Physical Interfaces
- **WAN**: eth0 - Internet connection
- **LAN1**: eth1 - VLAN 10 (Management)
- **LAN2**: eth2 - VLAN 20 (Production)
- **LAN3**: eth3 - VLAN 30 (Secure Zone)
- **LAN4**: eth4 - VLAN 40 (Guest)
- **LAN5**: eth5 - VLAN 50 (Monitoring)
- **LAN6**: eth6 - VLAN 60 (Development)
- **LAN7**: eth7 - VLAN 70 (Storage)
- **LAN8**: eth8 - VLAN 80 (Voice)
- **LAN9**: eth9 - VLAN 90 (IoT)

### Interface Assignments
Each VLAN interface is properly configured with:
- Correct IP subnet assignments
- VLAN tagging
- Security zone assignments
- Appropriate MTU settings
- Interface descriptions

## NAT Configuration

### Port Forwarding Rules
- **Port 80**: Forward to DMZ NGINX web server
- **Port 443**: Forward to DMZ NGINX web server
- **Port 22**: Forward to Bastion host (SSH)
- **Port 7844**: Forward to Cloudflare tunnel service

### Outbound NAT
- Default behavior: Automatic NAT for all internal networks
- Exceptions: Manually configured rules for specific services

## DHCP & DNS Configuration

### DHCP Settings
- Lease time: 24 hours
- DNS servers: Internal DNS servers
- Router addresses: Correct default gateways per VLAN
- NTP servers: Internal NTP servers
- WINS servers: Disabled

### DNS Resolver
- Forwarders: Upstream DNS servers
- Cache size: 1000 entries
- Timeout: 5 seconds
- Query log enabled
- DNSSEC validation enabled

## System Settings

The following system settings are configured:
- Time zone: America/New_York
- NTP servers: Internal NTP servers
- System logging: Enabled with remote logging
- SNMP monitoring: Enabled
- SSH access: Enabled with key-based authentication
- Dashboard access: Restricted to management network