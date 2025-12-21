# Cisco Switch Configuration for Home Lab Network

## Assumed Hardware and Initial Assessment

### Typical Home Lab Cisco Switches
```yaml
Common Models:
  - Cisco Catalyst 2960 Series (24/48 port)
  - Cisco Catalyst 3560 Series (24/48 port)
  - Cisco Catalyst 2950 Series (older, limited features)
  - Cisco SG300 Series (Small Business)

Capabilities to Check:
  - VLAN support (802.1Q)
  - Spanning Tree Protocol (STP/RSTP)
  - Port security features
  - SNMP support
  - Power over Ethernet (PoE) - if needed
  - Stacking capability
```

## Initial Switch Preparation

### Basic Configuration Setup
```cisco
! Initial console connection (9600-8-N-1)
! Default login: no username, password: cisco

! Enter privileged mode
enable

! Enter global configuration mode
configure terminal

! Set hostname
hostname HOMELAB-SW01

! Configure enable password
enable secret YourStrongPassword123!

! Configure console password
line console 0
password YourConsolePassword123!
login
exec-timeout 30 0
logging synchronous
exit

! Configure VTY (Telnet/SSH) access
line vty 0 15
password YourVTYPassword123!
login local
transport input ssh
exec-timeout 30 0
logging synchronous
exit

! Create admin user
username admin privilege 15 secret YourAdminPassword123!

! Configure management IP (VLAN 10)
interface vlan 10
ip address 10.0.10.2 255.255.255.0
no shutdown
exit

! Set default gateway
ip default-gateway GW_MGMT_VLAN

! Configure SSH
ip domain-name lab.local
crypto key generate rsa modulus 2048
ip ssh version 2
ip ssh time-out 60
ip ssh authentication-retries 3

! Save configuration
copy running-config startup-config
```

## VLAN Configuration

### Create VLANs
```cisco
! Create all VLANs for the home lab
vlan 10
name MANAGEMENT
exit

vlan 20
name PRODUCTION
exit

vlan 30
name MEDIA
exit

vlan 40
name LAB
exit

vlan 50
name IOT
exit

vlan 60
name GUEST
exit

vlan 70
name DMZ
exit

vlan 80
name BASTION
exit

vlan 90
name AUTOMATION
exit

! Verify VLAN creation
show vlan brief
```

### VLAN Database Alternative (older switches)
```cisco
! For older switches that don't support VLAN configuration mode
vlan database
vlan 10 name MANAGEMENT
vlan 20 name PRODUCTION
vlan 30 name MEDIA
vlan 40 name LAB
vlan 50 name IOT
vlan 60 name GUEST
vlan 70 name DMZ
vlan 80 name BASTION
vlan 90 name AUTOMATION
exit
```

## Port Configuration

### Trunk Ports (Uplinks to pfSense and other switches)
```cisco
! Configure uplink to pfSense firewall
interface GigabitEthernet0/1
description UPLINK-TO-PFSENSE
switchport mode trunk
switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
switchport trunk native vlan 999
spanning-tree portfast trunk
no shutdown
exit

! Configure inter-switch links
interface GigabitEthernet0/2
description UPLINK-TO-SW02
switchport mode trunk
switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
switchport trunk native vlan 999
spanning-tree portfast trunk
no shutdown
exit

! Configure link to managed switch (if cascading)
interface GigabitEthernet0/23
description UPLINK-TO-UBIQUITI-SWITCH
switchport mode trunk
switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
switchport trunk native vlan 999
no shutdown
exit
```

### Access Ports by VLAN

#### Management VLAN Ports
```cisco
! Management devices (IPMI, switch management, APs)
interface range FastEthernet0/1-4
description MANAGEMENT-DEVICES
switchport mode access
switchport access vlan 10
switchport port-security
switchport port-security maximum 2
switchport port-security violation restrict
switchport port-security aging time 1440
spanning-tree portfast
no shutdown
exit
```

#### Production VLAN Ports
```cisco
! Production servers
interface range FastEthernet0/5-8
description PRODUCTION-SERVERS
switchport mode access
switchport access vlan 20
switchport port-security
switchport port-security maximum 1
switchport port-security violation shutdown
spanning-tree portfast
no shutdown
exit
```

#### Media VLAN Ports
```cisco
! Media servers and devices
interface range FastEthernet0/9-12
description MEDIA-SERVERS
switchport mode access
switchport access vlan 30
switchport port-security
switchport port-security maximum 1
switchport port-security violation restrict
spanning-tree portfast
no shutdown
exit
```

#### Lab VLAN Ports
```cisco
! Lab/Development equipment
interface range FastEthernet0/13-16
description LAB-EQUIPMENT
switchport mode access
switchport access vlan 40
spanning-tree portfast
no shutdown
exit
```

#### IoT VLAN Ports
```cisco
! IoT devices (Raspberry Pi, smart devices)
interface range FastEthernet0/17-20
description IOT-DEVICES
switchport mode access
switchport access vlan 50
switchport port-security
switchport port-security maximum 3
switchport port-security violation restrict
spanning-tree portfast
no shutdown
exit
```

#### Guest VLAN Ports
```cisco
! Guest access points or devices
interface range FastEthernet0/21-22
description GUEST-ACCESS
switchport mode access
switchport access vlan 60
switchport port-security
switchport port-security maximum 5
switchport port-security violation restrict
spanning-tree portfast
no shutdown
exit
```

## Advanced Security Configuration

### Port Security Enhancement
```cisco
! Global port security settings
! Enable aging for dynamic addresses
interface range FastEthernet0/1-24
switchport port-security aging type inactivity
switchport port-security aging time 60
exit

! Secure unused ports
interface range FastEthernet0/23-24
description UNUSED-SECURE
switchport mode access
switchport access vlan 999
shutdown
exit
```

### Storm Control
```cisco
! Configure storm control on all access ports
interface range FastEthernet0/1-22
storm-control broadcast level 10.00
storm-control multicast level 10.00
storm-control unicast level 10.00
storm-control action shutdown
exit
```

### DHCP Snooping (if supported)
```cisco
! Enable DHCP snooping for security
ip dhcp snooping
ip dhcp snooping vlan 20,30,40,50,60,70,80,90

! Configure trusted interfaces (uplinks and server ports)
interface GigabitEthernet0/1
ip dhcp snooping trust
exit

interface GigabitEthernet0/2
ip dhcp snooping trust
exit

interface range FastEthernet0/5-8
ip dhcp snooping trust
exit
```

## Spanning Tree Configuration

### RSTP Configuration
```cisco
! Enable Rapid Spanning Tree Protocol
spanning-tree mode rapid-pvst

! Configure root bridge priority (make this primary switch)
spanning-tree vlan 10,20,30,40,50,60,70,80,90 priority 4096

! Configure portfast on access ports (already done above)
! Configure BPDU guard on access ports
interface range FastEthernet0/1-22
spanning-tree bpduguard enable
exit

! Configure root guard on uplinks
interface GigabitEthernet0/1
spanning-tree guard root
exit
```

## SNMP Configuration

### SNMP Setup for Monitoring
```cisco
! Configure SNMP for network monitoring
snmp-server community public RO
snmp-server community private RW
snmp-server location "Home Lab Server Rack"
snmp-server contact "admin@lab.local"

! Configure SNMP v3 (more secure)
snmp-server group HOMELAB-ADMIN v3 priv
snmp-server user admin HOMELAB-ADMIN v3 auth sha YourAuthKey123! priv aes 128 YourPrivKey123!
snmp-server host GW_MGMT_VLAN00 version 3 priv admin

! Enable SNMP traps
snmp-server enable traps
```

## QoS Configuration (if needed)

### Basic QoS for Media Traffic
```cisco
! Configure QoS for media streaming
mls qos

! Trust DSCP markings from servers
interface range FastEthernet0/9-12
mls qos trust dscp
exit

! Configure queue weights
mls qos queue-set output 1 threshold 1 100 100 50 200
mls qos queue-set output 1 threshold 2 80 90 60 400
```

## Multiple Switch Configuration

### Switch Stacking (if supported)
```cisco
! For stackable switches like 3750 series
switch 1 priority 15
switch 2 priority 14
switch 3 priority 13

! Stack configuration
stack-mac persistent timer 0
```

### Non-Stackable Multi-Switch Setup
```cisco
! Primary Switch (HOMELAB-SW01)
hostname HOMELAB-SW01
spanning-tree vlan 10,20,30,40,50,60,70,80,90 priority 4096

! Secondary Switch (HOMELAB-SW02)
hostname HOMELAB-SW02
spanning-tree vlan 10,20,30,40,50,60,70,80,90 priority 8192

! Configure inter-switch links with EtherChannel
interface range GigabitEthernet0/23-24
channel-group 1 mode active
exit

interface port-channel 1
description INTER-SWITCH-LINK
switchport mode trunk
switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
switchport trunk native vlan 999
exit
```

## Monitoring and Maintenance

### Logging Configuration
```cisco
! Configure logging
logging buffered 32768 informational
logging console warnings
logging monitor informational
logging trap informational
logging source-interface vlan 10
logging host GW_MGMT_VLAN00

! Configure NTP
ntp server GW_PROD_VLAN0
ntp server pool.ntp.org

! Set timezone
clock timezone EST -5
clock summer-time EDT recurring
```

### Backup Configuration Script
```cisco
! Enable archive for configuration backup
archive
path tftp://GW_MGMT_VLAN00/cisco-configs/$h-config
write-memory
time-period 1440
exit
```

## Complete Port Assignment Example

### 48-Port Switch Layout
```cisco
! Ports 1-4: Management VLAN (IPMI, switches, APs)
interface range FastEthernet0/1-4
switchport access vlan 10
exit

! Ports 5-12: Production servers
interface range FastEthernet0/5-12
switchport access vlan 20
exit

! Ports 13-20: Media services
interface range FastEthernet0/13-20
switchport access vlan 30
exit

! Ports 21-28: Lab equipment
interface range FastEthernet0/21-28
switchport access vlan 40
exit

! Ports 29-36: IoT devices
interface range FastEthernet0/29-36
switchport access vlan 50
exit

! Ports 37-40: Guest access
interface range FastEthernet0/37-40
switchport access vlan 60
exit

! Ports 41-44: DMZ services
interface range FastEthernet0/41-44
switchport access vlan 70
exit

! Ports 45-46: Bastion/Security
interface range FastEthernet0/45-46
switchport access vlan 80
exit

! Ports 47-48: Uplinks (Trunk)
interface range GigabitEthernet0/1-2
switchport mode trunk
switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
exit
```

## Validation Commands

### Verification Commands
```cisco
! Check VLAN configuration
show vlan brief
show interfaces status
show interfaces trunk

! Check spanning tree
show spanning-tree summary
show spanning-tree root

! Check port security
show port-security
show port-security interface FastEthernet0/1

! Check general status
show version
show running-config
show ip interface brief
show mac address-table

! Save configuration
copy running-config startup-config
```

This configuration provides enterprise-grade network segmentation and security using older Cisco equipment, integrating seamlessly with your pfSense firewall and supporting all the VLANs in your home lab design.
---
*Note: This is a sanitized example. Replace placeholder values with your actual configuration.*
