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
│ VLAN 20: Production 				   (10.10.20.0/24) │
│ VLAN 30: Media 					   (10.10.30.0/24) │
│ VLAN 40: Lab/Dev					   (10.10.40.0/24) │
└──────────────────────────────────────────────────────┘

## Current Service Distribution

### Infrastructure Services
```yaml
Core Infrastructure:
  - pfSense Firewall 		(YOUR_GATEWAY_IP)
  - Managed Switches 		(10.10.10.X)
  - Wireless AP 			(10.10.10.X)
  
DNS & Directory:
  - Pi-hole Primary 		(GW_PROD_VLAN0)
```  

### Application Services
```yaml
Media Stack:
  - Plex Media Server 		(10.0.30.XX)
  - PhotoPrism
  - qBittorrent 
  
Development Lab:
  - Proxmox
  
Home Automation:
  - Home Assistant
  - MQTT Broker 
---
*Note: This is a sanitized example. Replace placeholder values with your actual configuration.*
