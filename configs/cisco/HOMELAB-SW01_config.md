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
enable secret 5 $1$OUr8$/wUS.Zx5DOkKIV4a/szvP/
!
username admin privilege 15 secret 5 $1$Q3r2$4mjNFABeL9Jsej1xOhanS/
no aaa new-model
system mtu routing 1500
ip subnet-zero
ip domain-name hogwarts.home
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
 ip address 10.10.10.2 255.255.255.0
 shutdown
!
interface Vlan10
 ip address 10.10.10.2 255.255.255.0
!
ip default-gateway 10.10.10.1
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
