# Homelab Infrastructure Documentation

A comprehensive showcase of production-grade home lab infrastructure featuring advanced networking, virtualization, and automation.

## 🏗️ Project Overview

This repository demonstrates sophisticated home lab architecture with:
- **9-VLAN Enterprise Network** with pfSense firewall and managed switching
- **Proxmox Cluster** with high availability and disaster recovery
- **Comprehensive Service Stack** including media servers, SSO, monitoring, and automation
- **Zero-Trust Security** with bastion hosts, VPN access, and certificate-based authentication
- **Infrastructure as Code** with Ansible automation and n8n workflow orchestration

### Technical Architecture

**Network Infrastructure:**
- pfSense firewall with advanced routing and VPN
- Cisco managed switches with 802.1Q VLAN tagging
- 10GbE core network with 1GbE access layer
- Multi-zone DMZ and bastion architecture

**Compute & Storage:**
- Proxmox VE cluster with Ceph distributed storage
- Raspberry Pi management and utility nodes
- TrueNAS Scale with ZFS redundancy (96TB usable)
- Automated backup solutions with restic and duplicati

**Services & Applications:**
- **Media Stack**: Plex, Sonarr, Radarr, Prowlarr, qBittorrent
- **Authentication**: Keycloak SSO with social login integration
- **Monitoring**: Prometheus + Grafana with custom dashboards
- **Automation**: n8n workflows, Ansible playbooks, custom scripts

## 📚 Documentation

### Setup & Deployment
- [Setup Guide](docs/setup/0-setup-guide.md) - Complete infrastructure deployment
- [Proxmox Setup](docs/setup/3-proxmox.md) - Virtualization platform configuration
- [Network Architecture](docs/network/network-summary.md) - VLAN design and implementation

### Network Configuration
- [Switch Configuration](docs/network/2-switch.md) - Cisco switch setup and management
- [Firewall Rules](docs/network/firewall-rules.md) - pfSense rule implementation
- [DNS & DHCP](docs/network/) - Pi-hole and Kea DHCP configuration

### Services & Integration
- [Docker Services](configs/docker/docker-compose-examples.md) - Container orchestration
- [Keycloak SSO](docs/services/keycloak-setup.md) - Identity and access management
- [n8n Automation](docs/automation/n8n-automation-examples.md) - Workflow automation

## 🛠️ Technical Skills Demonstrated

- **Network Engineering**: Enterprise-grade VLAN segmentation, firewall configuration, routing protocols
- **Infrastructure Automation**: Ansible playbooks, infrastructure as code, CI/CD pipelines
- **Container Orchestration**: Docker Compose, networking, security hardening
- **Security Implementation**: Zero-trust architecture, certificate management, access controls
- **Monitoring & Observability**: Prometheus metrics, Grafana dashboards, alerting systems
- **Storage Solutions**: ZFS filesystem, Ceph distributed storage, backup strategies

## 🚀 Key Features

- **High Availability**: Redundant services, automated failover, disaster recovery
- **Scalability**: Modular design supporting easy expansion
- **Security**: Defense in depth with multiple security layers
- **Automation**: Infrastructure provisioning and configuration management
- **Monitoring**: Comprehensive observability and alerting
- **Documentation**: Detailed setup guides and operational procedures

## 📊 Infrastructure Metrics

- **Network**: 9 VLANs, 10GbE backbone, 40+ network devices
- **Compute**: 4 Proxmox nodes, 5 Raspberry Pi utilities
- **Storage**: 144TB raw capacity, 96TB usable with 3x redundancy
- **Services**: 25+ containerized applications, 10+ automation workflows
- **Uptime**: 99.9% availability with automated maintenance windows

## 🔧 Technologies Used

**Networking**: pfSense, Cisco IOS, Ubiquiti UniFi, Pi-hole, Kea DHCP
**Virtualization**: Proxmox VE, Docker, Podman, LXC containers
**Storage**: TrueNAS Scale, Ceph, ZFS, NFS/SMB shares
**Security**: Keycloak, HashiCorp Vault, SSL/TLS certificates, SSH hardening
**Automation**: Ansible, n8n, Bash scripting, GitOps workflows
**Monitoring**: Prometheus, Grafana, Nagios, custom exporters
**Development**: Git, GitHub Actions, pre-commit hooks, documentation tools

## 🤝 Contributing

This repository serves as a comprehensive reference for homelab enthusiasts and IT professionals. While the specific configurations are examples, the architecture patterns and implementation details provide valuable insights for building production-grade home lab infrastructure.

## 📄 License

This documentation is provided for educational and reference purposes. Adapt the concepts and configurations to your specific environment and security requirements.

---

*Showcasing enterprise infrastructure patterns in the homelab environment*
