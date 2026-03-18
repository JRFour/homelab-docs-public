# LLM Hardware Setup

## Overview

The Large Language Model (LLM) service is hosted on a dedicated Ubuntu Desktop system with AMD GPU acceleration for optimal performance.

## Hardware Specifications

### System
- **Type**: Ubuntu Desktop
- **CPU**: High-performance x86-64 processor
- **Memory**: Sufficient RAM for model loading and processing
- **Storage**: Fast SSD for model files and system operations
- **GPU**: AMD graphics card supporting ROCm compute capabilities

### GPU Requirements
- AMD GPU compatible with ROCm 6.x
- Support for Radeon Open Compute (ROCm) framework
- Sufficient VRAM for model loading and processing
- Compatible with GPU compute operations

## Storage Configuration

### Local Storage
- Root filesystem with sufficient space for system and Docker volumes
- Dedicated storage for LLM model files
- Configuration directories for Ollama and WebUI

### Model Storage
- Models stored in `/home/ubuntu/.ollama` directory (mapped via Docker volume)
- Additional storage for large models and datasets
- Backup procedures for model files

This hardware setup supports the AMD GPU-accelerated LLM workloads with sufficient resources for model training and inference operations.