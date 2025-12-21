# Current Home Lab Setup

## Network Overview Diagram

```
                                Internet
                                   │
                            ┌──────┴──────┐
                            │  pfSense    │
                            │ Firewall    │
                            └──────┬──────┘
                                   │
                         ┌─────────┴─────────┐
                         │  Managed Switch   │
                         │   (VLAN Trunk)    │
                         └─────────┬─────────┘
                                   │
                    ┌──────────────┼──────────────┐
                    │              │              │
            ┌───────┴───┐   ┌──────┴──────┐    ┌──┴───┐
            │ Hardware  │   │   Virtual   │    │ WiFi │
            │ Servers   │   │ Environment │    │  AP  │
            └───────────┘   └─────────────┘    └──────┘
```

## Complete VLAN Structure
```
┌──────────────────────────────────────────────────────┐
│                    VLANs                             │
├──────────────────────────────────────────────────────┤
│ VLAN 10: Management 				   (10.10.10.0/24) │
│ VLAN 20: Production 				   (YOUR_PRODUCTION_SUBNET) │
│ VLAN 30: Media 					   (YOUR_MEDIA_SUBNET) │
│ VLAN 40: Lab/Dev					   (YOUR_LAB_SUBNET) │
└──────────────────────────────────────────────────────┘

## Current Service Distribution

### Infrastructure Services
```yaml
Core Infrastructure:
  - pfSense Firewall 		(YOUR_GATEWAY_IP)
  - Managed Switches 		(YOUR_SWITCH_IP_RANGE)
  - Wireless AP 			(YOUR_SWITCH_IP_RANGE)
  
DNS & Directory:
  - Pi-hole Primary 		(YOUR_DNS_SERVER_IP)
```  

### Application Services
```yaml
Media Stack:
  - Plex Media Server 		(YOUR_MEDIA_SERVER_IP)
  - PhotoPrism
  - qBittorrent 
  
Development Lab:
  - Proxmox
  
Home Automation:
  - Home Assistant
  - MQTT Broker 

---
*Note: This is a sanitized example. Replace placeholder values with your actual configuration.*
