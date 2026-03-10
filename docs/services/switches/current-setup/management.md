# Management Configuration

## Management Interface

### IP Address Configuration

Both switches are configured with static IP addresses on VLAN 10 (Management):

#### HOMELAB-SW01
```
interface Vlan10
 ip address 10.x.x.x X.X.X.X
 no shutdown
```

#### HOMELAB-SW02
```
interface Vlan10
 ip address 10.x.x.x X.X.X.X
 no shutdown
```

### Default Gateway
```
ip default-gateway 10.x.x.x
```

## Access Methods

### SSH Access
- **SSH Version**: 2
- **Port**: 22
- **Authentication**: Local username/password
- **Timeout**: 60 minutes

#### SSH Configuration
```
ip ssh time-out 60
ip ssh version 2
```

#### Access Lines
```
line vty 0 4
 transport input ssh
 login local
line vty 5 15
 transport input ssh
 login local
```

### Console Access
- **Port**: Console (RJ-45)
- **Baud Rate**: 9600
- **Authentication**: Local password

#### Console Configuration
```
line con 0
 exec-timeout 30 0
 password <encrypted>
 login
 logging synchronous
```

## User Accounts

### Local Users

Both switches have local user accounts configured:

#### HOMELAB-SW01
```
username admin privilege 15 secret 5 <encrypted>
enable secret 5 <encrypted>
```

#### HOMELAB-SW02
```
username admin privilege 15 secret 5 <encrypted>
enable secret 5 <encrypted>
```

### Privilege Levels
- **Level 15**: Full administrative access
- **Level 1**: Basic read-only access

## Authentication

### Local Authentication
Both switches use local database for authentication:
- AAA new-model disabled on HOMELAB-SW01
- AAA new-model enabled on HOMELAB-SW02

### Password Configuration

#### Enable Secret
- Encrypted using MD5 (type 5)
- Should be changed regularly

#### Line Passwords
- Console: Configured with exec timeout
- VTY: Configured with exec timeout

## Management Security

### Current Configuration
- SSH version 2 only (more secure than SSHv1)
- Local authentication (not RADIUS/TACACS+)
- Console access protected
- VTY access via SSH only

### Security Recommendations

#### High Priority
1. **Change Default Passwords**
   - Update all default passwords
   - Use strong, unique passwords
   - Store passwords securely

2. **Enable AAA**
   ```
   aaa new-model
   aaa authentication login default group tacacs+ local
   aaa authorization exec default group tacacs+ local
   ```

3. **Use RADIUS/TACACS+**
   - Centralize authentication
   - Better audit trail
   - Easier account management

#### Medium Priority
4. **Restrict Management Access**
   - Limit which IPs can access management
   - Use ACLs on VTY lines

5. **Enable Logging**
   - Syslog configuration
   - Log management traffic

6. **Implement 802.1X**
   - Port-based network access control
   - Future enhancement

## Network Management

### SNMP Configuration
- **SNMP Version**: v2c (basic)
- **Read Community**: public (should be changed)
- **Device Tracking**: Enabled on SW02

### SNMP Security Recommendations
- Use SNMPv3 with encryption
- Change default community strings
- Restrict SNMP access via ACLs

### Monitoring Points
- Interface statistics
- VLAN information
- Spanning-tree status
- Port-channel status

## Firmware Management

### Current Version
- Cisco IOS 12.2

### Upgrade Considerations
- Check Cisco compatibility matrix
- Verify flash memory requirements
- Plan maintenance window
- Backup current configuration

## Backup Configuration

### Configuration Backup
Regular backups should include:
- Running configuration
- Startup configuration
- VLAN database

### Backup Methods
1. **TFTP**
   ```
   copy running-config tftp
   ```

2. **SCP**
   ```
   ip scp server enable
   copy running-config scp:
   ```

3. **Manual**
   - Terminal capture
   - Screen logging

## Disaster Recovery

### Password Recovery
- Physical access to console required
- Follow Cisco password recovery procedure
- Document process before needed

### Firmware Recovery
- XMODEM through console
- TFTP server
- ROMMON mode access