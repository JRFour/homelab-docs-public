# LLM Software Stack

## Overview

The LLM service is deployed using Docker Compose with Ollama and Open WebUI, running on an Ubuntu Desktop system with AMD GPU acceleration.

## Software Components

### Core Services
1. **Ollama** - Local LLM inference engine with ROCm support
   - Version: docker.io/ollama/ollama:rocm
   - GPU acceleration via ROCm
   - Supports various LLM models
   - API endpoint on port 11434

2. **Open WebUI** - Web-based interface for LLM interaction
   - Version: ghcr.io/open-webui/open-webui:cuda
   - Provides web-based chat interface
   - Integrates with Ollama API
   - WebUI accessible on port 8080

## Deployment Architecture

### Docker Setup
- Container orchestration using Docker Compose
- Root user mapping for proper UID/GID access
- GPU device access (/dev/kfd, /dev/dri)
- Network isolation with custom `ollama-docker` network
- Volume management for persistent data storage

### System Prerequisites
- AMD GPU drivers with ROCm support
- Docker and Docker Compose installed
- Appropriate group membership for Docker access
- UID mapping for SMB file access compatibility

## Integration with Existing Infrastructure

### Network
- Services communicate via internal Docker network
- Ports exposed for external access when needed
- Secure connections for LLM operations

### Data Access
- Shared directory access via SMB
- UID mapping ensures proper file permissions
- Configuration files accessible for management

## Security Considerations

### Container Security
- Reduced privilege containers
- SELinux/AppArmor integration
- Network isolation from host services
- Security context with seccomp unconfined

### GPU Access
- Device access restricted to necessary containers
- GPU memory management
- Driver access isolation

This software stack provides a robust, GPU-accelerated LLM environment that integrates well with the existing home lab infrastructure.