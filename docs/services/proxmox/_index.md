# Proxmox Overview

This documentation covers the Proxmox virtualization infrastructure for the home lab, including configuration, management, and best practices.

## Current Status

The homelab utilizes a multi-server Proxmox environment with three primary servers:
- **HOMELAB-01**: Primary production server
- **HOMELAB-02**: Development and testing server  
- **HOMELAB-03**: Utility and backup server

## Infrastructure Purpose

The Proxmox environment serves as the core virtualization platform for:
- Container orchestration (LXC containers)
- Virtual machine hosting
- Resource sharing across services
- High availability and redundancy
- Development and testing environments

## Architecture

The architecture implements:
- Multi-server cluster with resource sharing
- VLAN segmentation for network isolation
- GPU passthrough capabilities
- ZFS storage integration
- Centralized management

## Documentation Sections

### Current Setup
- Hardware specifications and configurations
- OS installation and first-boot procedures
- Storage and network configuration

### Configuration
- VM/container templates and creation
- GPU passthrough setup
- Backup procedures

### Management
- Cluster setup and maintenance
- Resource allocation and monitoring
- Performance optimization

### Best Practices
- Upgrade recommendations
- Security hardening
- Performance optimization strategies