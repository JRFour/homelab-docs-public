# Web Services Current Setup

## Deployment

Web services are deployed as a Docker compose stack on an LXC container.

## Services Included

1. **Nginx** - Web server and SSL termination
2. **Ghost** - Blog platform
3. **MySQL** - Database for Ghost

## Network Configuration

Services communicate through Docker network:
- Nginx exposes port 443 on host
- Ghost container listens on port 3306 (exposed but not directly accessible)
- MySQL container listens on port 3306 (exposed but not directly accessible)

## Volume Mounts

### Nginx
- SSL certificates: 
  - `/etc/nginx/realewanderer.net.key` 
  - `/etc/nginx/realewanderer.net.crt`
- Configuration: `/etc/nginx/conf.d/ghost.conf`

### Ghost
- Configuration files: `/var/lib/ghost/config.json`
- Content directory: `/var/lib/ghost/content`

### MySQL
- Database data: `/var/lib/mysql`

## Docker Compose Structure

```yaml
services:
  nginx:
    image: nginx:latest
    container_name: nginx
    hostname: ghost-nginx
    ports:
      - 443:443
    volumes:
      - ./nginx/ssl/realewanderer.net.key:/etc/nginx/realewanderer.net.key:ro
      - ./nginx/ssl/realewanderer.net.crt:/etc/nginx/realewanderer.net.crt:ro
      - ./nginx/conf/ghost.conf:/etc/nginx/conf.d/ghost.conf:z
    links:
      - ghost
    restart: always

  ghost:
    image: ghost:latest
    container_name: ghost
    hostname: ghost
    volumes:
      - ./ghost/volumes/config.json:/var/lib/ghost/config.json:z 
      - ./ghost/content:/var/lib/ghost/content:z
    expose:
      - "3306"
    restart: always
    links:
      - mysql

  mysql:
    image: mysql:latest
    container_name: mysql
    volumes:
       - ./dbdata:/var/lib/mysql:z  # Persist storage
    expose:
      - "3306"
    environment:
      - MYSQL_ROOT_PASSWORD= ${MYSQL_ROOT_PASSWORD} 
      - MYSQL_DATABASE=ghostdata
      - MYSQL_USER=ghostusr
      - MYSQL_PASSWORD= ${WP_DB_PASSWORD}
    restart: always
```

## Security

- SSL certificates mounted read-only for Nginx
- Sensitive credentials in environment variables
- Volume mounts with appropriate SELinux contexts