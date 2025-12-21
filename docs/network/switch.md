[Trunk port](https://learningnetwork.cisco.com/s/question/0D53i00000Kt674CAB/command-rejected-an-interface-whose-trunk-encapsulation-is-auto-can-not-be-configured-to-trunk-mode) *- site with command needed for trunking Router Switch*

> **📖 Related Documentation:** [Network Summary](network-summary.md) | [Firewall Rules](firewall-rules.md) | [Cisco Reconfiguration](cisco-reconfigure.md)


### HOMELAB-SW01 (Router Switch) 
IP: YOUR_SWITCH_IP_1

| Interface | Status     | Protocol | Description        |
| --------- | ---------- | -------- | ------------------ |
| Vl1       | admin down | down     |                    |
| Vl10      | up         | up       |                    |
| Fa0/1     | up         | up       | UPLINK-TO-WIFI-AP  |
| Fa0/2     | up         | up       | UPLINK-TO-TERTIARY |
| Fa0/3     | down       | down     |                    |
| Fa0/4     | down       | down     |                    |
| Fa0/5     | down       | down     |                    |
| Fa0/6     | down       | down     |                    |
| Fa0/7     | up         | up       | BRIDGE-PORT        |
| Fa0/8     | up         | up       | BRIDGE-PORT        |
| Gi0/1     | up         | up       | UPLINK-TO-PFSENSE  |
| Po1       | up         | up       | UPLINK-TO-SW02     |
|           |            |          |                    |

###### Config 
```cpp
Current configuration : 4455 bytes
!
version 12.2
no service pad
service timestamps debug uptime
service timestamps log uptime
service password-encryption
!
hostname HOMELAB-SW01
!
enable secret 5 YOUR_ENABLE_SECRET
!
username YOUR_ADMIN_USER privilege 15 secret 5 YOUR_USER_SECRET
no aaa new-model
system mtu routing 1500
ip subnet-zero
ip domain-name yourdomain.local
!
!
!
crypto pki trustpoint TP-self-signed-3282333952
 enrollment selfsigned
 subject-name cn=IOS-Self-Signed-Certificate-3282333952
 revocation-check none
 rsakeypair TP-self-signed-3282333952
!
!
crypto pki certificate chain TP-self-signed-3282333952
 certificate self-signed 01
  30820250 308201B9 A0030201 02020101 300D0609 2A864886 F70D0101 04050030
  31312F30 2D060355 04031326 494F532D 53656C66 2D536967 6E65642D 43657274
  69666963 6174652D 33323832 33333339 3532301E 170D3933 30333031 30303031
  30345A17 0D323030 31303130 30303030 305A3031 312F302D 06035504 03132649
  4F532D53 656C662D 5369676E 65642D43 65727469 66696361 74652D33 32383233
  33333935 3230819F 300D0609 2A864886 F70D0101 01050003 818D0030 81890281
  8100BBF8 716F8ACA 403FED5F 845AC7C3 2A34A4B2 2BCD1DE2 FC0B1007 2CC10A04
  01621A2D A0EFAD5F DD65297A B7A2E27D 7E204C2F 0256EC5E 357B7194 41F15337
  627120F4 2F627310 13FABAB1 D38F7E60 943495C8 3ECB3E8D 2A45794B 7A504975
  BBF3B297 50EE460A B0FC7959 21395D99 AB879ED5 D1F95E68 C0A9C31C 34C54302
  E47D0203 010001A3 78307630 0F060355 1D130101 FF040530 030101FF 30230603
  551D1104 1C301A82 18677279 6666696E 646F722E 686F6777 61727473 2E686F6D
  65301F06 03551D23 04183016 8014A1E0 ED469FF9 B56B77FA B1534B6F D5813AE5
  FDED301D 0603551D 0E041604 14A1E0ED 469FF9B5 6B77FAB1 534B6FD5 813AE5FD
  ED300D06 092A8648 86F70D01 01040500 03818100 16658E2E 1E39E2A3 88C1CA02
  187433D0 76CC8EC8 61BC5D62 06CFAEAC 851143C4 E1DA900F 7E183A5A 9811E601
  E60F8817 88A975F8 85D344E7 2BD25204 922A6471 DD26FEF9 47FA2265 F4090BB5
  3B054886 D89ACCE4 BC86879F CC3DAA2D 01B65D89 F0D5813C 6F16E515 6A1E483D
  477C2DFA 7C30FAD5 758681E1 B944CC97 8FE13202
  quit
!
!
!
!
!
spanning-tree mode pvst
spanning-tree extend system-id
!
vlan internal allocation policy ascending
!
ip ssh time-out 60
ip ssh version 2
!
!
interface Port-channel1
 description UPLINK-TO-SW02
 switchport access vlan 20
 switchport trunk encapsulation dot1q
 switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
 switchport mode trunk
 spanning-tree portfast trunk
!
interface FastEthernet0/1
 description UPLINK-TO-WIFI-AP
 switchport access vlan 20
 switchport trunk encapsulation dot1q
 switchport trunk native vlan 60
 switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
 switchport mode access
!
interface FastEthernet0/2
 description UPLINK-TO-TERTIARY
 switchport access vlan 10
 switchport trunk encapsulation dot1q
 switchport trunk native vlan 999
 switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
 switchport mode trunk
!
interface FastEthernet0/3
 switchport access vlan 20
 switchport mode access
!
interface FastEthernet0/4
 switchport access vlan 20
 switchport mode access
!
interface FastEthernet0/5
 switchport access vlan 20
 switchport mode access
!
interface FastEthernet0/6
 switchport access vlan 20
 switchport mode access
!
interface FastEthernet0/7
 description BRIDGE-PORT
 switchport access vlan 90
 switchport trunk encapsulation dot1q
 switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
 switchport mode trunk
 channel-group 1 mode active
!
interface FastEthernet0/8
 description BRIDGE-PORT
 switchport access vlan 20
 switchport trunk encapsulation dot1q
 switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
 switchport mode trunk
 channel-group 1 mode active
!
interface GigabitEthernet0/1
 description UPLINK-TO-PFSENSE
 switchport trunk encapsulation dot1q
 switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
 switchport mode trunk
 spanning-tree portfast trunk
!
interface Vlan1
 ip address YOUR_SWITCH_IP_1 255.255.255.0
 shutdown
!
interface Vlan10
 ip address YOUR_SWITCH_IP_1 255.255.255.0
!
ip default-gateway YOUR_GATEWAY_IP
ip classless
ip route profile
ip http server
ip http secure-server
!
!
control-plane
!
!
line con 0
 exec-timeout 30 0
 password 7 106A5917113701002157
 logging synchronous
 login
line vty 0 4
 exec-timeout 30 0
 password 7 1321471C1F2C17210677
 logging synchronous
 login local
 transport input ssh
line vty 5 15
 exec-timeout 30 0
 password 7 1321471C1F2C17210677
 logging synchronous
 login local
 transport input ssh
!
end

```
### HOMELAB-SW02 (Server Switch)
IP: YOUR_SWITCH_IP_2

| Interface | Status     | Protocol | Description             |
| --------- | ---------- | -------- | ----------------------- |
| Vl1       | admin down | down     |                         |
| Vl10      | up         | up       |                         |
| Fa0/1     | down       | down     |                         |
| Fa0/2     | up         | up       | SearxNG-Server          |
| Fa0/3     | down       | down     |                         |
| Fa0/4     | up         | up       | Repository              |
| Fa0/5     | down       | down     |                         |
| Fa0/6     | up         | up       | Black PI                |
| Fa0/7     | down       | down     |                         |
| Fa0/8     | up         | up       | 3CX                     |
| Fa0/9     | down       | down     |                         |
| Fa0/10    | up         | up       |                         |
| Fa0/11    | down       | down     |                         |
| Fa0/12    | down       | down     |                         |
| Fa0/13    | down       | down     |                         |
| Fa0/14    | down       | down     |                         |
| Fa0/15    | down       | down     |                         |
| Fa0/16    | down       | down     |                         |
| Fa0/17    | down       | down     |                         |
| Fa0/18    | down       | down     | TrueNAS Scale           |
| Fa0/19    | down       | down     |                         |
| Fa0/20    | up         | up       | TRUNK-TO-SECONDARY-PVE  |
| Fa0/21    | down       | down     |                         |
| Fa0/22    | up         | up       | TRUNK-TO-PRIMARY-PVE    |
| Fa0/23    | up         | up       |                         |
| Fa0/24    | down       | down     | Link to Primary Proxmox |
| Gi0/1     | up         | up       |                         |
| Gi0/2     | up         | up       |                         |
| Po1       | up         | up       | UPLINK-TO-SW01          |

###### Config
```cpp
Current configuration : 4960 bytes
!
version 12.2
no service pad
service timestamps debug datetime msec
service timestamps log datetime msec
no service password-encryption
!
hostname HOMELAB-SW02
!
boot-start-marker
boot-end-marker
!
enable secret 5 YOUR_ENABLE_SECRET
!
username YOUR_ADMIN_USER privilege 15 secret 5 YOUR_USER_SECRET
aaa new-model
!
!
!
!
!
aaa session-id common
system mtu routing 1500
ip subnet-zero
!
!
ip domain-name yourdomain.local
ip device tracking
!
!
crypto pki trustpoint TP-self-signed-1914658176
 enrollment selfsigned
 subject-name cn=IOS-Self-Signed-Certificate-1914658176
 revocation-check none
 rsakeypair TP-self-signed-1914658176
!
!
crypto pki certificate chain TP-self-signed-1914658176
 certificate self-signed 01
  30820252 308201BB A0030201 02020101 300D0609 2A864886 F70D0101 04050030
  31312F30 2D060355 04031326 494F532D 53656C66 2D536967 6E65642D 43657274
  69666963 6174652D 31393134 36353831 3736301E 170D3933 30333031 30303030
  35335A17 0D323030 31303130 30303030 305A3031 312F302D 06035504 03132649
  4F532D53 656C662D 5369676E 65642D43 65727469 66696361 74652D31 39313436
  35383137 3630819F 300D0609 2A864886 F70D0101 01050003 818D0030 81890281
  8100E80B E1E6ED92 94DFA4A5 972BB549 4AA92F8E 06441A93 0A80EBCC 9FB78F38
  C6C20E80 D5CCB82F 034407C2 F5AB87FA A79A35FC 8527AEB5 10E7E8FB FB0D21DE
  FE2D55B0 AF6BC5CF 730DCE79 C56B1C44 F2B9E214 E56E5F2F 2C191D0C 31C00A16
  5AAFB22E EFA319AE 8E6CA08D D71343F0 18040B8D 176A9C41 57436ECC 1E14EE4A
  E3490203 010001A3 7A307830 0F060355 1D130101 FF040530 030101FF 30250603
  551D1104 1E301C82 1A484F4D 454C4142 2D535730 312E686F 67776172 74732E68
  6F6D6530 1F060355 1D230418 30168014 AD016B8F D8228648 9E93905E AF662A17
  C802E890 301D0603 551D0E04 160414AD 016B8FD8 2286489E 93905EAF 662A17C8
  02E89030 0D06092A 864886F7 0D010104 05000381 81001541 4899E93A 97CB3119
  75CB6C70 F3841549 C3D3BF84 6CA9AD70 052A9DFE F02A4649 807E021E 37490CAD
  82E6CDAD 89824088 76A21D77 87A84B7C F7707D60 F61728AA 8DC93063 C8B22D05
  919BF082 ADF4E9A0 BB6FACD5 8454D045 646F24C1 F53CDF23 836FAACB 5E520CE0
  88BD0700 E5E2F184 05358607 EA51AD50 5CD6AF0B BD38
  quit
!
!
!
!
!
spanning-tree mode pvst
spanning-tree extend system-id
!
vlan internal allocation policy ascending
!
ip ssh time-out 60
ip ssh version 2
!
!
interface Port-channel1
 description UPLINK-TO-SW01
 switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
 switchport mode trunk
 spanning-tree portfast trunk
!
interface FastEthernet0/1
!
interface FastEthernet0/2
 description SearxNG-Server
 switchport access vlan 30
 switchport mode access
!
interface FastEthernet0/3
!
interface FastEthernet0/4
 description Repository
 switchport access vlan 30
 switchport mode access
!
interface FastEthernet0/5
!
interface FastEthernet0/6
 description Black PI
 switchport access vlan 30
 switchport mode access
!
interface FastEthernet0/7
!
interface FastEthernet0/8
 description 3CX
 switchport access vlan 30
 switchport mode access
!
interface FastEthernet0/9
!
interface FastEthernet0/10
 switchport access vlan 30
 switchport mode access
!
interface FastEthernet0/11
!
interface FastEthernet0/12
!
interface FastEthernet0/13
!
interface FastEthernet0/14
!
interface FastEthernet0/15
!
interface FastEthernet0/16
!
interface FastEthernet0/17
!
interface FastEthernet0/18
 description TrueNAS Scale
 switchport access vlan 20
 switchport mode access
!
interface FastEthernet0/19
!
interface FastEthernet0/20
 description TRUNK-TO-SECONDARY-PVE
 switchport access vlan 10
 switchport trunk native vlan 999
 switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
 switchport mode trunk
!
interface FastEthernet0/21
!
interface FastEthernet0/22
 description TRUNK-TO-PRIMARY-PVE
 switchport access vlan 10
 switchport trunk native vlan 999
 switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
 switchport mode trunk
!
interface FastEthernet0/23
 switchport access vlan 20
 switchport trunk native vlan 999
 switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
 switchport mode access
!
interface FastEthernet0/24
 description Link to Primary Proxmox
 switchport access vlan 30
 switchport trunk native vlan 10
 switchport mode trunk
!
interface GigabitEthernet0/1
 switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
 switchport mode trunk
 channel-group 1 mode active
!
interface GigabitEthernet0/2
 switchport trunk allowed vlan 10,20,30,40,50,60,70,80,90
 switchport mode trunk
 channel-group 1 mode active
!
interface Vlan1
 ip address dhcp
 no ip route-cache
 shutdown
!
interface Vlan10
 ip address YOUR_SWITCH_IP_2 255.255.255.0
 no ip route-cache
!
ip default-gateway YOUR_GATEWAY_IP
ip http server
ip http secure-server
!
control-plane
!
!
line con 0
 exec-timeout 30 0
 password YOUR_SWITCH_PASSWORD
 logging synchronous
line vty 0 4
 exec-timeout 30 0
 password YOUR_SWITCH_PASSWORD
 logging synchronous
 transport input ssh
line vty 5 15
 exec-timeout 30 0
 password YOUR_SWITCH_PASSWORD
 logging synchronous
 transport input ssh
!
end
```


---
*Note: This is a sanitized example. Replace placeholder values with your actual configuration.*
