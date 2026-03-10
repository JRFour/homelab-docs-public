# ServArr Current Setup

## Deployment

The ServArr stack is deployed as a Docker compose stack on an LXC container.

## Services Included

- Sonarr - TV show management
- Radarr - Movie management
- Lidarr - Music management
- Bazarr - Subtitle management
- Prowlarr - Indexer management
- qBittorrent - Torrent client
- Gluetun - VPN client

## Network Configuration

The stack uses a dedicated network:
```
networks:
  servarrnetwork:
    name: servarrnetwork
    ipam:
      config:
        - subnet: 172.x.x.x/24
```

## Docker Compose Structure

Services are configured with:
- Network connectivity using shared service network
- Volume mounts for configuration persistence
- Port mappings for web interfaces
- VPN integration through Gluetun service
- Health checks for service monitoring

## Configuration

### Volume Mounts

- `/data:/data` - Media library storage accessible to all services
- Configuration directories per service (sonarr, radarr, lidarr, etc.)

### Environment Variables

- PUID/PGID - UID/GID for container user mapping
- TZ - Timezone settings
- Various VPN and authentication settings from .env file