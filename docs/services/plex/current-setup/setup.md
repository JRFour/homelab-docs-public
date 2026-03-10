# Plex Media Current Setup

## Deployment

Plex is deployed on a dedicated VM with GPU passthrough support for hardware acceleration.

## Hardware Configuration

- Running on a dedicated VM with GPU passthrough
- GPU device: NVIDIA (accessed via nvidia-docker)

## Network

- Uses host network mode for direct access to ports
- Configured for optimal streaming performance

## Configuration

### Docker Compose
```yaml
services:
  plex:
    image: plexinc/pms-docker
    deploy:
      resources:
        devices:
          - driver: nvidia
            count: all
            capabilities: [gpu]
    container_name: plex
    network_mode: host
    environment:
    - TZ=America/New_York
    - PLEX_CLAIM=claim-<token>...
    volumes:
    - /home/mediacore/plex/config:/config
    - /mnt/media:/data
    restart: unless-stopped
```

### Volumes

- `/home/mediacore/plex/config:/config` - Plex configuration
- `/mnt/media:/data` - Media library storage

### Environment Variables

- `TZ=America/New_York` - Timezone setting
- `PLEX_CLAIM=claim-<token>...` - Plex claim token for authentication