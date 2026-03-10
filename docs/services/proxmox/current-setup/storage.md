# Storage Configuration

## Overview

The Proxmox environment utilizes a hybrid storage approach combining local storage with centralized ZFS pools from TrueNAS Scale.

## Local Storage

### LVM (Logical Volume Manager)
- Initial LVM setup
- Root partition expansion procedure:
  ```
  lvremove /dev/pve/data
  lvresize -1 +100%FREE /dev/pve/root
  resize2fs /dev/mapper/pve-root
  ```
- Data partition management
- Storage capacity planning

### Storage Pool Management
- Local storage pools
- Volume group configuration
- Partitioning strategy

## Centralized Storage

### TrueNAS Scale Integration
- ZFS pool setup
- Storage replication
- Snapshot management
- Backup strategy

### Storage Benefits
- Deduplication and compression
- SSD caching for performance
- Automated snapshots
- Long-term archive capabilities

## Storage Types

### Local Storage
- High-speed NVMe drives
- Performance optimized for VM caching
- Local storage for frequently accessed files

### Network Storage
- ZFS pools from TrueNAS
- Replicated across locations
- Backup and archive storage

### Performance Considerations
- Storage tiering strategy
- I/O performance optimization
- Cache management for VMs

## Storage Management

### Monitoring
- Disk space usage tracking
- Performance metrics
- Health monitoring

### Maintenance
- Regular maintenance procedures
- Space optimization
- Backup verification

## Storage Migration
Process for moving VMs between storage types
Backup and restore procedures