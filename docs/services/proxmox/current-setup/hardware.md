# Hardware Specifications

## Server Inventory

### HOMELAB-01 (Primary Production Server)
- **Role**: Core production services
- **Resources**: 128GB RAM, 16+ cores, NVMe storage
- **Primary Services**: 
  - DNS, Auth, Proxy (VLANs 20)
  - Plex Media Server with GPU transcoding (VLAN 30)
  - Docker Swarm manager (VLAN 20)
  - High availability for critical services

### HOMELAB-02 (Development Server)
- **Role**: Development and testing
- **Resources**: 64-128GB RAM, 12+ cores
- **Primary Services**:
  - Kubernetes cluster (3-node: 1 master + 2 workers)
  - GitLab CE with CI/CD pipelines
  - n8n automation platform (VLAN 90)
  - Development sandboxes and testing

### HOMELAB-03 (Utility/Backup Server)
- **Role**: Support services and backup
- **Resources**: 32-64GB RAM, 8+ cores
- **Primary Services**:
  - ELK stack for logging (VLAN 10)
  - Prometheus + Grafana monitoring (VLAN 10)
  - Bastion services (VLAN 80)
  - Backup repositories and offsite sync

## Hardware Configuration

### Network Interface
- Multiple gigabit network interfaces
- VLAN-aware network configuration
- Redundant network paths where applicable

### Storage Architecture
- Primary storage in TrueNAS Scale
- ZFS with replication and snapshots
- SSD caching for performance
- Deduplication and compression

### Power and Environmental
- UPS protection
- Server rack mounting
- Environmental controls

## Proxmox Version
- Current Proxmox VE version
- Kernel version
- Available upgrades and patch status

## Upgrade Considerations
- Hardware upgrade paths
- Software update procedures
- Compatibility planning