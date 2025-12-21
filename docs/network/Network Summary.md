# Complete Home Lab Network Design Summary

> **📖 Related Documentation:** [Firewall Rules](../network/Firewall%20Rules.md) | [Switch Configuration](../network/2%20-%20Switch.md) | [Setup Guide](../setup/0%20-%20Setup%20Guide.md) | [Proxmox Setup](../setup/3%20-%20Proxmox.md)


## Network Architecture Overview

### Physical Infrastructure
```yaml
Core Hardware:
  - pfSense Firewall (Netgate 6100 or custom build)
  - 42U Server Rack with environmental controls
  - 3x Primary Servers (Proxmox hypervisors)
  - 4x Raspberry Pi (specialized services)
  - Custom TrueNAS Scale + Commercial NAS backup
  - Cisco switches (2960/3560 series) + Ubiquiti gear
  - Enterprise UPS systems (3000VA + 1500VA)
  - 10GbE core network with 1GbE access

Total Investment: ~$35,000 (full build) | ~$15,000 (minimal)
```

## Network Segmentation (9 VLANs)

### VLAN Structure
```yaml
VLAN 10 - Management (YOUR_MGMT_SUBNET):
  Purpose: Infrastructure management
  Devices: pfSense, switches, IPMI, wireless APs
  Security: Highest restriction - admin access only

VLAN 20 - Production (YOUR_PROD_SUBNET):
  Purpose: Core production services
  Services: DNS (Pi-hole), Auth (Keycloak/FreeIPA), Vault, Traefik
  Security: High - critical service protection

VLAN 30 - Media (YOUR_MEDIA_SUBNET):
  Purpose: Media streaming and management
  Services: Plex, Sonarr, Radarr, qBittorrent, Overseerr
  Security: Medium - content-focused with internet access

VLAN 40 - Lab (YOUR_LAB_SUBNET):
  Purpose: Development and testing
  Services: Kubernetes, GitLab, Jenkins, Nexus, sandbox VMs
  Security: Medium - flexible for experimentation

VLAN 50 - IoT (YOUR_IOT_SUBNET):
  Purpose: Smart home and IoT devices
  Services: Home Assistant, MQTT, Zigbee2MQTT, smart devices
  Security: High isolation - no direct internet for devices

VLAN 60 - Guest (YOUR_GUEST_SUBNET):
  Purpose: Guest device access
  Services: Internet access only
  Security: Complete isolation from internal networks

VLAN 70 - DMZ (YOUR_DMZ_SUBNET):
  Purpose: Public-facing web services
  Services: WordPress, Ghost blog, HAProxy, MySQL, Redis
  Security: Internet-facing with strict egress controls

VLAN 80 - Bastion (YOUR_BASTION_SUBNET):
  Purpose: Secure access and security tools
  Services: SSH gateway, Guacamole, Wetty, VPN, IDS/IPS
  Security: Highest - all access logged and monitored

VLAN 90 - Automation (YOUR_AUTO_SUBNET):
  Purpose: Workflow automation
  Services: n8n, message queues, automation workers
  Security: Medium-high with broad access for automation
```

## Service Distribution Across Hardware

### HOMELAB-01 (Primary Production Server)
```yaml
Resources: 128GB RAM, 16+ cores, NVMe storage
Critical Services:
  - Production DNS, Auth, Proxy (VLANs 20)
  - Plex Media Server with GPU transcoding (VLAN 30)
  - Primary website services (VLAN 70)
  - Docker Swarm manager (VLAN 20)
Redundancy: High availability for all critical services
```

### HOMELAB-02 (Development Server)
```yaml
Resources: 64-128GB RAM, 12+ cores
Development Focus:
  - Kubernetes cluster (3-node: 1 master + 2 workers)
  - GitLab CE with CI/CD pipelines
  - n8n automation platform (VLAN 90)
  - Development sandboxes and testing
Innovation: Primary environment for learning and testing
```

### HOMELAB-03 (Utility/Backup Server)
```yaml
Resources: 32-64GB RAM, 8+ cores
Support Services:
  - ELK stack for logging (VLAN 10)
  - Prometheus + Grafana monitoring (VLAN 10)
  - Bastion services (VLAN 80)
  - Backup repositories and offsite sync
Reliability: Monitoring and backup infrastructure
```

### Raspberry Pi Cluster
```yaml
PI-01 (Network Services): Secondary DNS, DHCP relay, network monitoring
PI-02 (IoT Gateway): Home Assistant, Zigbee2MQTT, MQTT broker
PI-03 (Edge Monitoring): Environmental sensors, UPS monitoring, local dashboards
PI-04 (Development): ARM testing, Git mirrors, lightweight K3s node
```

## Security Architecture

### Firewall Strategy (pfSense)
```yaml
Perimeter Defense:
  - Cloudflare CDN protection for public services
  - GeoIP blocking and fail2ban integration
  - IDS/IPS with Suricata
  - Only essential ports exposed (80, 443, 2222)

Inter-VLAN Security:
  - Default deny all cross-VLAN traffic
  - Explicit allow rules for required services
  - Management and automation VLANs have broader access
  - Guest VLAN completely isolated
  - IoT devices cannot reach internet directly

Advanced Features:
  - DHCP snooping and port security on switches
  - 802.1X authentication (future enhancement)
  - VPN access through WireGuard/OpenVPN
  - Centralized logging and alerting
```

### Access Control Integration
```yaml
Zero Trust Access:
  - Twingate for device-based network access
  - Guacamole for protocol gateway (RDP/VNC/SSH)
  - Bastion host for all administrative access
  - Certificate-based authentication where possible

Identity Management:
  - Keycloak for SSO across all services
  - FreeIPA for LDAP and Kerberos
  - HashiCorp Vault for secrets management
  - 2FA enabled on all critical services
```

## Advanced Automation and Integration

### Workflow Automation (n8n)
```yaml
Infrastructure Automation:
  - Health monitoring and alerting
  - Automated backup verification
  - Service restart and recovery
  - Resource utilization monitoring

Media Automation:
  - Overseerr → Sonarr/Radarr → Download → Plex
  - Failed download retry logic
  - Quality upgrades and management
  - Home Assistant integration for notifications

Home Automation:
  - IoT device monitoring and control
  - Energy usage tracking and reporting
  - Security system integration
  - Weather-based automation triggers

Development Workflow:
  - GitLab CI/CD pipeline automation
  - Automated testing and deployment
  - Environment provisioning
  - Code quality and security scanning
```

### Monitoring and Observability
```yaml
Metrics Collection:
  - Prometheus for time-series metrics
  - Grafana for visualization and dashboards
  - Node exporter on all systems
  - Custom metrics for business logic

Log Aggregation:
  - ELK stack for centralized logging
  - Structured logging across all services
  - Log correlation and alerting
  - Security event monitoring

Health Monitoring:
  - Service uptime monitoring
  - Resource utilization tracking
  - Network performance monitoring
  - Predictive alerting for issues
```

## Data Management and Backup

### Storage Strategy
```yaml
Primary Storage:
  - TrueNAS Scale with ZFS (96TB usable)
  - SSD caching for performance
  - Automated snapshots and replication
  - Deduplication and compression

Backup Strategy (3-2-1):
  - Local: ZFS replication to secondary NAS
  - Offsite: Cloud backup with encryption
  - Archive: Long-term cold storage
  - Test: Regular restore testing

Media Backup:
  - NTFS external drives for Windows compatibility
  - Automated rsync with verification
  - Plex database backup with service coordination
  - Restore documentation and scripts
```

## Key Technology Integrations

### Container Orchestration
```yaml
Docker Swarm:
  - Production services deployment
  - Multi-node high availability
  - Secrets management integration
  - Load balancing and service discovery

Kubernetes:
  - Development and testing workloads
  - Microservices architecture learning
  - CI/CD integration with GitLab
  - Helm charts for application deployment
```

### Development Pipeline
```yaml
Source Control: GitLab CE with integrated CI/CD
Artifact Storage: Nexus Repository Manager
Code Quality: SonarQube integration
Container Registry: GitLab integrated registry
Deployment: Automated to both Swarm and K8s
```

## Network Performance and Scalability

### Bandwidth Design
```yaml
Core Network: 10GbE between servers and storage
Access Network: 1GbE for most devices, 2.5GbE for APs
Internet: Optimized for streaming and remote access
Internal: High bandwidth for media streaming and backups
```

### Scalability Considerations
```yaml
Horizontal Scaling:
  - Additional servers can join Proxmox cluster
  - Kubernetes nodes can be added dynamically
  - Storage can be expanded with additional drives
  - Network can accommodate additional VLANs

Vertical Scaling:
  - RAM and CPU can be upgraded in existing servers
  - Storage pools can be expanded
  - Network can be upgraded to 25GbE/100GbE
  - Additional specialized hardware can be integrated
```

## Implementation Phases

### Phase 1: Foundation (Weeks 1-4)
- [ ] pfSense firewall configuration and basic VLANs
	- [x] VLANs 10 - 70 firewall rules
	- [ ] VLANs Bastion & Automation firewall rules
- [x] Primary server setup with Proxmox
	- [ ] Setup Guide
- [ ] Core production services (DNS, auth, proxy)
	- [x] DNS
	- [x] Auth
	- [ ] Proxy
- [ ] Basic monitoring and backup

### Phase 2: Core Services (Weeks 5-8)
- Media stack deployment and configuration
- Development environment setup
- Network monitoring and logging
- Cisco switch integration

### Phase 3: Advanced Features (Weeks 9-12)
- n8n automation platform deployment
- Twingate and Guacamole integration
- Advanced security features
- Website hosting stack

### Phase 4: Optimization (Weeks 13-16)
- Performance tuning and optimization
- Comprehensive backup testing
- Documentation and runbooks
- Advanced monitoring and alerting

## Expected Outcomes

### Learning Opportunities
```yaml
Technologies Mastered:
  - Enterprise networking and VLANs
  - Container orchestration (Docker + Kubernetes)
  - Infrastructure as Code (Terraform + Ansible)
  - Zero Trust networking concepts
  - Advanced automation and workflows
  - Security best practices and monitoring
```

### Practical Benefits
```yaml
Home Automation: Comprehensive smart home control
Media Streaming: Professional-grade media server
Development Environment: Full CI/CD pipeline
Security: Enterprise-level network protection
Backup: Robust data protection and recovery
Remote Access: Secure access from anywhere
```

This design provides a production-ready, enterprise-grade home lab that serves as both a learning platform and a practical home infrastructure, with proper security, monitoring, and automation throughout.
---
*Note: This is a sanitized example. Replace placeholder values with your actual configuration.*
