# Services Configuration

## Overview
The pfSense firewall provides critical network services including VLAN routing, DHCP, DNS resolution, static IP assignments, and REST API access for automated management.

## VLAN Routing

The pfSense device implements full VLAN routing between all 9 network segments. Each VLAN is configured with:
- Unique IP subnet allocation
- Default gateway configuration
- Route table entries for inter-VLAN communication
- Proper interface mapping to physical hardware

## DHCP Service

### Scope Configuration
DHCP services are configured for the following VLANs:

- **VLAN 10**: Network Management (10.10.0.0/24)  
- **VLAN 20**: Production Services (10.20.0.0/24)
- **VLAN 30**: Secure Zone (10.30.0.0/24)
- **VLAN 40**: Guest Networks (10.40.0.0/24)
- **VLAN 50**: Security Monitoring (10.50.0.0/24)
- **VLAN 60**: Development (10.60.0.0/24)
- **VLAN 70**: Storage Services (10.70.0.0/24)
- **VLAN 80**: Voice Services (10.80.0.0/24)
- **VLAN 90**: IoT Devices (10.90.0.0/24)

### DHCP Settings
- Lease time: 24 hours
- DNS servers: Set to internal DNS servers
- WINS servers: Disabled
- Router address: Default gateway for each VLAN
- NTP servers: Internal NTP servers

## DNS Resolver

### Primary Function
The pfSense device acts as a DNS resolver for all internal VLANs, providing:
- Internal DNS resolution for services
- Caching of external DNS queries
- Security filtering
- DNSSEC validation (enabled)

### DNS Configuration
- Port: 53 (UDP/TCP)
- Forwarders: Upstream DNS servers
- Cache size: 1000 entries
- Timeout: 5 seconds
- Query log enabled

## Static IP Assignments

Static IP addresses are configured for critical infrastructure:
- **pfSense appliance**: 10.10.0.1 (VLAN 10)
- **Management servers**: 10.10.0.x
- **Production servers**: 10.20.0.x
- **Monitoring services**: 10.50.0.x
- **Development servers**: 10.60.0.x

## Network Address Translation (NAT)

NAT is configured for:
- Port forwards to public-facing services (DMZ)
- Internal access to external services
- Network isolation between VLANs

## REST API Access

A REST API package has been installed to enable programmatic management:
- Provides automated management of static DHCP mappings
- Supports GET, POST, PUT, and DELETE operations for DHCP static mappings
- Uses API Key authentication
- Enables centralized network management and automation

## ACME Certificate Management

Automated certificate management is configured with Vault PKI:
- ACME package installed with Vault as custom ACME server
- Certificate issuance automated for internal services
- Integration with Vault intermediate CA
- Supports certificate renewal through ACME protocol

## Service Status

All pfSense services are operational:
- VLAN routing: Active
- DHCP: Active
- DNS: Active
- NAT: Active
- Firewall: Active
- REST API: Active
- ACME Certificate Management: Active