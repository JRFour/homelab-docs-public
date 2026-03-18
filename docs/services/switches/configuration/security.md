# Security Configuration

## Overview

This document covers the current security configuration of the Cisco switches and recommendations for hardening.

## Current Security Posture

### Authentication

#### Local Authentication
- Both switches use local username/password authentication
- AAA new-model: Disabled on HOMELAB-SW01, Enabled on HOMELAB-SW02
- Privilege level 15 for administrative access

#### Password Configuration
- Enable secret configured (encrypted MD5)
- Service password-encryption enabled (Type 7 - weak)
- Console and VTY passwords configured

### Network Access Control

#### SSH Configuration
- SSH version 2 only (secure)
- 60-minute timeout
- Login via local database

#### VTY Lines
```
line vty 0 4
 exec-timeout 30 0
 transport input ssh
 login local

line vty 5 15
 exec-timeout 30 0
 transport input ssh
 login local
```

#### Console Line
```
line con 0
 exec-timeout 30 0
 password <encrypted>
 login
 logging synchronous
```

## Current Security Features

### Port Security
- Not fully implemented
- Available but not configured
- Potential for MAC address limiting

### VLAN Security

#### Native VLAN
- Default VLAN 1 is disabled (shutdown)
- Native VLAN changed to unused VLANs (999) on trunk ports
- Reduces VLAN hopping risks

#### Trunk Ports
- Explicit VLAN allowed lists
- Prevents VLAN propagation
- Limits broadcast domains

### Management Access

#### Allowed Methods
- SSH (secure)
- Console (local)
- HTTP/HTTPs disabled

#### Restricted Access
- Management only from VLAN 10 (Management)
- No Telnet (insecure)
- No finger service

## Security Recommendations

### High Priority

#### 1. Strong Password Policy
- Use Type 9 (scrypt) or Type 8 (PBKDF2) for enable secret
- Enforce complex passwords
- Regular rotation schedule

**Current (Weak):**
```
service password-encryption  # Type 7 - reversible
enable secret 5 <md5>        # Type 5 - weak
```

**Recommended:**
```
enable secret 9 <scrypt>
```

#### 2. AAA Implementation
- Enable AAA for centralized management
- Configure RADIUS or TACACS+ integration
- Fallback to local authentication

**Configuration:**
```
aaa new-model
aaa authentication login default group tacacs+ local
aaa authorization exec default group tacacs+ local
```

#### 3. Disable Unused Services
- Disable HTTP server
- Disable CDP/LLDP on edge ports
- Disable unused ports

**Configuration:**
```
no ip http server
no cdp run (on access ports)
```

### Medium Priority

#### 4. Port Security
Implement MAC address limiting:

**Per-Port Configuration:**
```
interface FastEthernet0/2
 switchport port-security
 switchport port-security maximum 5
 switchport port-security violation restrict
 switchport port-security aging time 2
```

#### 5. BPDU Guard
Prevent unauthorized switch connections:

```
spanning-tree portfast bpduguard default
```

#### 6. DHCP Snooping
Prevent DHCP spoofing:

```
ip dhcp snooping
ip dhcp snooping vlan 10,20,30,40,50,60,70,80,90
```

### Lower Priority

#### 7. 802.1X Port-Based Authentication
- Network access control
- User/machine authentication
- Integration with Keycloak

#### 8. Private VLANs
- Additional VLAN isolation
- Community/isolated VLANs

#### 9. Storm Control
Prevent broadcast storms:

```
interface FastEthernet0/2
 storm-control broadcast level 10
 storm-control multicast level 10
 storm-control action shutdown
```

## Monitoring & Logging

### Current Logging
- Console logging enabled (synchronous)
- VTY logging enabled
- Timestamps configured

### Recommended Logging Enhancements
- Syslog server integration
- Log rotation
- Security event monitoring

**Syslog Configuration:**
```
logging host <syslog-server>
logging trap informational
logging source-interface Vlan10
```

## Physical Security

### Current Measures
- Switches in locked rack
- Console access limited
- Environmental controls in place

### Recommendations
- Restrict physical console access
- Implement access logging
- Consider biometric access

## Compliance Considerations

### Documentation Requirements
- Maintain current configuration backups
- Document all changes
- Regular security audits

### Access Control Lists

#### Management ACL Example
```
ip access-list extended MANAGEMENT
 permit tcp 10.10.10.0 0.0.0.255 any eq ssh
 deny ip any any log
```

**Applied to VTY:**
```
line vty 0 4
 access-class MANAGEMENT in
```

## Summary of Current vs Recommended

| Feature | Current | Recommended |
|---------|---------|-------------|
| Password Encryption | Type 7 | Type 9 |
| Authentication | Local | AAA with RADIUS/TACACS+ |
| Port Security | None | MAC limiting + BPDU Guard |
| DHCP Snooping | None | Enabled on all VLANs |
| 802.1X | None | Implemented |
| ACLs | None | Management ACLs |
| Logging | Console | Syslog + monitoring |