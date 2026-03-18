# LLM Service Setup

## Overview

The Large Language Model (LLM) service is hosted on a dedicated Ubuntu Desktop system with AMD GPU acceleration for optimal performance. This documentation covers the current deployment and configuration.

## Current Configuration

The LLM service is deployed using Docker Compose with Ollama and Open WebUI:

### Ollama Service
- Running with ROCm support (`docker.io/ollama/ollama:rocm`)
- GPU device access via `/dev/kfd` and `/dev/dri`
- Context length limited to 75072 characters
- Port 11434 exposed for API access
- User mapping to UID 1000 for SMB file access compatibility

### Open WebUI Service
- Web-based interface for LLM interaction
- Running on port 8080
- Integrated with Ollama API at `http://ollama:11434`
- Uses persistent volume for data storage

## Network Configuration
- Custom Docker network `ollama-docker`
- Internal service communication only
- External ports (11434, 8080) available upon request

## Storage and Volumes
- Persistent data storage mapped via Docker volumes
- Configuration directory (`/home/ubuntu/.ollama`) accessible for user access
- WebUI data stored in `/app/backend/data` volume

## File System Access
- UID mapping to the host user (1000:1000) for proper file access
- SMB share integration through UID compatibility
- Configuration directory modified to allow access

## Repository Reference
- Original GitHub repository: https://github.com/JRFour/ollama-docker-amd.git
- Configuration modified from original to match host UID for SMB access

## Status
All services are operational and accessible:
- Ollama service: Active
- WebUI service: Active
- GPU acceleration: Functional
- Network: Operational