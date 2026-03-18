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
enable secret 5 <md5-hash>
!
username admin privilege 15 secret 5 <md5-hash>
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
ip domain-name hogwarts.home
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
 ip address 10.x.x.x X.X.X.X
 no ip route-cache
!
ip default-gateway 10.x.x.x
ip http server
ip http secure-server
!
control-plane
!
!
line con 0
 exec-timeout 30 0
 password <password>
 logging synchronous
line vty 0 4
 exec-timeout 30 0
 password <password>
 logging synchronous
 transport input ssh
line vty 5 15
 exec-timeout 30 0
 password <password>
 logging synchronous
 transport input ssh
!
end