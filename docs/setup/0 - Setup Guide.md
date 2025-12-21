# 1. PfSense
* VLAN creation
* Firewall configuration
* Static IP addresses
- [ ] Finish Firewall Configs

# 2. Switches
* *Note: see [2 - Switch](../network/2%20-%20Switch.md)

- Switches have trunk ports configured to Router, Proxmox servers, and each other
- Trunk to each other is configured on bridge port
- SSH is configured 
- Static IP on maintenance VLAN 
<b>Needs:</b>
- [ ] Configure WiFi port for trunking
# 3. Proxmox
* *Note: see [3 - Proxmox](../setup/3%20-%20Proxmox.md)*
* GPU Passthrough configured
* 3 Proxmox servers
	- [x] Cluster nodes?	
![HOMELAB-01 (Primary Production Server)](0.1%20-%20Device%20Separation%20Guide.md#HOMELAB-01%20(Primary%20Production%20Server))
![HOMELAB-02 (Development/Lab Server)](0.1%20-%20Device%20Separation%20Guide.md#HOMELAB-02%20(Development/Lab%20Server))
![HOMELAB-03 (Utility/Backup Server)](0.1%20-%20Device%20Separation%20Guide.md#HOMELAB-03%20(Utility/Backup%20Server))
## 3.1 DNS
	PROD-DNS-01:
    Services: Pi-hole Primary, Unbound
    Resources: 2 vCPU, 4GB RAM, 40GB disk
    VLAN: Production (20)
* Production VLAN
* LXC on Primary Proxmox server - direct scripted install
* Backup on Raspberry Pi  --*does not have Unbound*
* Using PiHole and Unbound
	* PiHole as ad blocker and Unbound as DNS Resolver 

## 3.2 SMB
* *Migrated over from TrueNAS*
* Specialty LXC on Primary Proxmox server - Turnkey Fileserver

## 3.3 Plex
	MEDIA-CORE-01:
    Services: Plex Media Server
    Resources: 8 vCPU, 16GB RAM, 100GB disk
    VLAN: Media (30)
    GPU: Hardware transcoding passthrough
* *Migrated over from TrueNAS*
* Docker image in VM on Primary Proxmox server
* Double GPU passthrough needed: Proxmox --> VM --> Docker
	* docs.docker.com/compose/how-tos/gpu-support
	* [ ] Write How-to guide on steps performed
```docker
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
		- PLEX_CLAIM=claim-...
		volumes:
		- /home/mediacore/plex/config:/config
		- /mnt/media:/data
		restart: unless-stopped
```

## 3.4 Keycloak
	PROD-AUTH-01:
    Services: Keycloak SSO, FreeIPA
    Resources: 4 vCPU, 8GB RAM, 80GB disk
    VLAN: Production (20)
- Docker image on Ubuntu LXC
```docker
services:
  keycloak:
    image: quay.io/keycloak/keycloak:latest
    command: start-dev
    container_name: keycloak
    environment:
    - KC_HOSTNAME=[ip of keycloak server]
    - KC_HOSTNAME_PORT=8080
    - KC_BOOTSTRAP_ADMIN_USERNAME=admin
    - KC_BOOTSTRAP_ADMIN_PASSWORD=admin
    ports:
      - "8080:8080"
    restart: unless-stopped
```

# 3.5 Traefik
	PROD-PROXY-01:
    Services: Traefik, HAProxy
    Resources: 2 vCPU, 4GB RAM, 40GB disk
    VLAN: Production (20)
* Setup documentation: https://doc.traefik.io/traefik/setup/docker/
* Dashboard Credentials:
```
admin:$$apr1$$Tbn38QMk$$TGBsO9a3YbYeYlXFVBvhD1 # admin : P@ssw0rd
```

- [ ] Need to configure TLS certs (Let's Encrypt || mkcert ??)
 - Configuration:
```yml
services:
  traefik:
    image: traefik:v3.4
    container_name: traefik
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true

#    environment:
#      - CLOUDFLARE_EMAIL_FILE=/run/secrets/cf_email
#      - CLOUDFLARE_API_KEY_FILE=/run/secrets/cf_token
#    secrets:
#      - cf_email
#      - cf_token

    networks:
     # Connect to the 'traefik_proxy' overlay network for inter-container communication across nodes
      - proxy

    ports:
      - "80:80"
      - "443:443"
      - "8080:8080"

    volumes:
#      - acme:/letsencrypt
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./certs:/certs:ro
      - ./dynamic:/dynamic:ro

    command:
      # EntryPoints
      - "--entrypoints.web.address=:80"
      - "--entrypoints.web.http.redirections.entrypoint.to=websecure"
      - "--entrypoints.web.http.redirections.entrypoint.scheme=https"
      - "--entrypoints.web.http.redirections.entrypoint.permanent=true"
      - "--entrypoints.websecure.address=:443"
      - "--entrypoints.websecure.http.tls=true"

      # Attach the static configuration tls.yaml file that contains the tls configuration settings
      - "--providers.file.filename=/dynamic/tls.yaml"

      # Providers 
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--providers.docker.network=proxy"

      # API & Dashboard 
      - "--api.dashboard=true"
      - "--api.insecure=false"

      # Observability 
      - "--log.level=INFO"
      - "--accesslog=true"
      - "--metrics.prometheus=true"

#      # Let's Encrypt
#      - "--certificatesresolvers.letsencrypt.acme.dnschallenge.delaybeforecheck=0"
#      - "--certificatesresolvers.le.acme.storage=/letsencrypt/acme.json" # Path inside container volume
#      - "--certificatesresolvers.letsencrypt.acme.dnschallenge.resolvers=1.1.1.1:53"
#      - "--certificatesresolvers.le.acme.httpchallenge.entrypoint=web"
#
#      - "--certificatesresolvers.le.acme.dnschallenge=true"
#      - "--certificatesresolvers.le.acme.dnschallenge.provider=cloudflare" # Needs provider setup
#
      # Optionally make 'le' the default resolver for TLS-enabled routers
#      - "--entrypoints.websecure.http.tls.certresolver=le"

  # Traefik Dynamic configuration via Docker labels
    labels:
      # Enable self‑routing
      - "traefik.enable=true"

      # Dashboard router
      - "traefik.http.routers.dashboard.rule=(Host(`dashboard.prod-proxy-01`) && (PathPrefix(`/dashboard`) || PathPrefix(`/api`)))"
      - "traefik.http.routers.dashboard.entrypoints=websecure"
      - "traefik.http.routers.dashboard.service=api@internal"
      - "traefik.http.routers.traefik.tls.certresolver=letsencrypt"
      - "traefik.http.routers.dashboard.tls=true"

      # Basic‑auth middleware
      - "traefik.http.middlewares.dashboard-auth.basicauth.users=admin:$$apr1$$Tbn38QMk$$TGBsO9a3YbYeYlXFVBvhD1"
      - "traefik.http.routers.dashboard.middlewares=dashboard-auth@docker"

# Whoami application
  whoami:
    image: traefik/whoami
    container_name: whoami
    restart: unless-stopped
    networks:
      - proxy
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.whoami.rule=(Host(`prod-proxy-01`) && PathPrefix(`/whoami`))"
      - "traefik.http.routers.whoami.entrypoints=websecure"
      - "traefik.http.routers.whoami.tls=true"

networks:
  proxy:
    name: proxy
    driver: bridge

#secrets:
#  cf_token:
#    file: ./letsencrypt/cf_token
#  cf_email:
#    file: ./letsencrypt/cf_email
#
volumes:
  acme:
```

# 3.6 HashiCorp Vault
	PROD-VAULT-01:
    Services: HashiCorp Vault
    Resources: 2 vCPU, 4GB RAM, 40GB disk
    VLAN: Production (20)

# 3.7 Media MGMT Services
	MEDIA-MGMT-01:
    Services: Sonarr, Radarr, Prowlarr, Overseerr, Glutun (VPN), qBittorrent
    Resources: 4 vCPU, 8GB RAM, 80GB disk
    VLAN: Media (30)
	
```yaml
# Compose file for the *arr stack. Configuration files are stored in the
# directory you launch the compose file on. Change to bind mounts if needed.
# All containers are ran with user and group ids of the main user and
# group to aviod permissions issues of downloaded files, please refer
# the read me file for more information.

#############################################################################
# NOTICE: We recently switched to using a .env file. PLEASE refer to the docs.
# https://github.com/TechHutTV/homelab/tree/main/media#docker-compose-and-env
#############################################################################

networks:
  servarrnetwork:
    name: servarrnetwork
    ipam:
      config:
        - subnet: 172.39.0.0/24

services:
  # airvpn recommended (referral url: https://airvpn.org/?referred_by=673908)
  gluetun:
    image: qmcgaw/gluetun
    container_name: gluetun
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun:/dev/net/tun # If running on an LXC see readme for more info.
    networks:
      servarrnetwork:
        ipv4_address: 172.39.0.2
    ports:
      - 8080:8080 # qbittorrent web interface
      - 6881:6881 # qbittorrent torrent port
#      - 6789:6789 # nzbget
      - 9696:9696 # prowlarr
    volumes:
      - ./gluetun:/gluetun
    # Make a '.env' file in the same directory.
    env_file:
      - .env
    healthcheck:
      test: ping -c 1 www.google.com || exit 1
      interval: 20s
      timeout: 10s
      retries: 5
    restart: unless-stopped

  qbittorrent:
    image: lscr.io/linuxserver/qbittorrent:latest
    container_name: qbittorrent
    restart: unless-stopped
    labels:
      - deunhealth.restart.on.unhealthy=true
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TZ}
      - WEBUI_PORT=8080 # must match "qbittorrent web interface" port number in gluetun's service above
#      - TORRENTING_PORT=${FIREWALL_VPN_INPUT_PORTS} # airvpn forwarded port, pulled from .env
    volumes:
      - ./qbittorrent:/config
      - /data:/data
    depends_on:
      gluetun:
        condition: service_healthy
        restart: true
    network_mode: service:gluetun
    healthcheck:
      test: ping -c 1 www.google.com || exit 1
      interval: 60s
      retries: 3
      start_period: 20s
      timeout: 10s

  # See the 'qBittorrent Stalls with VPN Timeout' section for more information.
  deunhealth:
    image: qmcgaw/deunhealth
    container_name: deunhealth
    network_mode: "none"
    environment:
      - LOG_LEVEL=info
      - HEALTH_SERVER_ADDRESS=127.0.0.1:9999
      - TZ=${TZ}
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock

#  nzbget:
#    image: lscr.io/linuxserver/nzbget:latest
#    container_name: nzbget
#    environment:
#      - PUID=${PUID}
#      - PGID=${PGID}
#      - TZ=${TZ}
#    volumes:
#      - /etc/localtime:/etc/localtime:ro
#      - ./nzbget:/config
#      - /data:/data
#    depends_on:
#      gluetun:
#        condition: service_healthy
#        restart: true
#    restart: unless-stopped
#    network_mode: service:gluetun

  prowlarr:
    image: lscr.io/linuxserver/prowlarr:latest
    container_name: prowlarr
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TZ}
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ./prowlarr:/config
    restart: unless-stopped
    depends_on:
      gluetun:
        condition: service_healthy
        restart: true
    network_mode: service:gluetun

  sonarr:
    image: lscr.io/linuxserver/sonarr:latest
    container_name: sonarr
    restart: unless-stopped
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TZ}
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ./sonarr:/config
      - /data:/data
    ports:
      - 8989:8989
    networks:
      servarrnetwork:
        ipv4_address: 172.39.0.3

  radarr:
    image: lscr.io/linuxserver/radarr:latest
    container_name: radarr
    restart: unless-stopped
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TZ}
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ./radarr:/config
      - /data:/data
    ports:
      - 7878:7878
    networks:
      servarrnetwork:
        ipv4_address: 172.39.0.4

  lidarr:
    container_name: lidarr
    image: lscr.io/linuxserver/lidarr:latest
    restart: unless-stopped
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ./lidarr:/config
      - /data:/data
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TZ}
    ports:
      - 8686:8686
    networks:
      servarrnetwork:
        ipv4_address: 172.39.0.5

  bazarr:
    image: lscr.io/linuxserver/bazarr:latest
    container_name: bazarr
    restart: unless-stopped
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TZ}
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ./bazarr:/config
      - /data:/data
    ports:
      - 6767:6767
    networks:
      servarrnetwork:
        ipv4_address: 172.39.0.6

# Newer additions to this stack feel. Remove the '#' to add the service.
#
#  ytdl-sub:
#    image: ghcr.io/jmbannon/ytdl-sub:latest
#    container_name: ytdl-sub
#    environment:
#      - PUID=${PUID}
#      - PGID=${PGID}
#      - TZ=${TZ}
#      - DOCKER_MODS=linuxserver/mods:universal-cron
#    volumes:
#      - ./ytdl-sub:/config
#      - /data/youtube:/youtube
#    networks:
#      servarrnetwork:
#        ipv4_address: 172.39.0.8
#    restart: unless-stopped
#
#  jellyseerr:
#    container_name: jellyseerr
#    image: fallenbagel/jellyseerr:latest
#    environment:
#      - PUID=${PUID}
#      - PGID=${PGID}
#      - TZ=${TZ}
#    volumes:
#      - ./jellyseerr:/app/config
#    ports:
#      - 5055:5055
#    networks:
#      servarrnetwork:
#        ipv4_address: 172.39.0.9
#    restart: unless-stopped
```

```yaml
# General UID/GIU and Timezone
TZ=America/Los_Angeles
PUID=1000
PGID=1000

# Input your VPN provider and type here
VPN_SERVICE_PROVIDER=protonvpn
VPN_TYPE=wireguard

## Mandatory, airvpn forwarded port
#FIREWALL_VPN_INPUT_PORTS=port

# Copy all these varibles from your generated configuration file
WIREGUARD_PUBLIC_KEY=YOUR_WIREGUARD_PUBLIC_KEY
WIREGUARD_PRIVATE_KEY=YOUR_WIREGUARD_PRIVATE_KEY
#WIREGUARD_PRESHARED_KEY=YOUR_WIREGUARD_PRESHARED_KEY
#WIREGUARD_ADDRESSES=ip

# Optional location varbiles, comma seperated list,no spaces after commas, make sure it matches the config you created
#SERVER_COUNTRIES=country
#SERVER_CITIES=city 

# Heath check duration
#HEALTH_VPN_DURATION_INITIAL=120s
```

# 3.8 Web Services 
- Version 1 - no separation of web host and db, no wordpress
	```yaml
	# compose.yaml
	services:
	  nginx:
	    image: nginx:latest
	    container_name: nginx
	    hostname: ghost-nginx
	    ports:
	      - 443:443
	    volumes:
	      - ./nginx/ssl/yourdomain.com.key:/etc/nginx/yourdomain.com.key:ro
	      - ./nginx/ssl/yourdomain.com.crt:/etc/nginx/yourdomain.com.crt:ro
	      - ./nginx/conf/ghost.conf:/etc/nginx/conf.d/ghost.conf:z
	    links:
	      - ghost
	    restart: always
	
	  ghost:
	    image: ghost:latest
	    container_name: ghost
	    hostname: ghost
	    volumes:
	      - ./ghost/volumes/config.json:/var/lib/ghost/config.json:z #overwrite default settings 
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
	      # Beware of special characters in password that can be interpreted by shell
	      - MYSQL_ROOT_PASSWORD= YOUR_DB_PASSWORD #specify your root pass
	      - MYSQL_DATABASE=ghostdata
	      - MYSQL_USER=ghostusr
	      - MYSQL_PASSWORD= YOUR_DB_PASSWORD #please change this
	    restart: always
	```
	
	```yaml
	# nginx/conf/ghost.conf
	server {
	  listen 443 ssl http2 default_server;
	  listen [::]:443 http2 ssl;
	  server_name yourdomain.com;
	  ssl on;
	  ssl_certificate /etc/nginx/yourdomain.com.crt;
	  ssl_certificate_key /etc/nginx/yourdomain.com.key;
	  ssl_protocols TLSv1.2;
	
	  location / {
	    proxy_set_header X-Real-IP $remote_addr;
	    proxy_set_header Host $host;
	    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	    proxy_set_header  X-Forwarded-Proto   $scheme;
	    proxy_connect_timeout                 90;
	    proxy_send_timeout                    90;
	    proxy_read_timeout                    90;
	    proxy_buffering off;
	    proxy_cache_valid 200 30m;
	    proxy_cache_valid 404 1m;
	    
	    client_max_body_size                  10m;
	    client_body_buffer_size               128k;
	
	  
	    proxy_pass http://ghost:2368;
	  }
	
	  # Cache Ghost Images
	  location ~ "/assets/images/(.*)-([a-z0-9]{10})\.(?:png|jpe?g|tiff)(.*)$" {
	    expires           max;
	    add_header        Cache-Control public;
	    add_header        Vary Accept;
	    proxy_pass        http://ghost:2368/$uri$webp_suffix;
	    access_log        off;
	  }
	
	  # Cache Ghost css and js 
	  location ~* \.(?:css|js) {
	    expires           max;
	    add_header        Cache-Control public;
	    proxy_pass        http://ghost:2368/$uri;
	    access_log        off;
	  }
	
	}
	```
	
	```json
	"_comment":"ghost/content/config.production.json"_
	{
	    "url": "http://yourdomain.com",
	    "server": {
	        "port": 2368,
	        "host": "0.0.0.0"
	    },
	    "database": {
	        "client": "mysql",
	        "connection": {
	            "host": "mysql",
	            "port": 3306,
	            "user": "",
	            "password": "",
	            "database": "ghostdata",
	            "charset": "utf8mb4"
	        }
	    },
	    "mail": {
	        "from": "'Custom Name' <myemail@address.com>", 
	        "transport": "SMTP",
	        "logger": true,
	        "options": {
	            "host": "",
	            "secureConnection": false,
	            "auth": {
	                "user": "",
	                "pass": ""
	            }
	        }
	    },
	    "logging": {
	        "transports": [
	            "file",
	            "stdout"
	        ]
	    },
	    "process": "systemd",
	    "paths": {
	        "contentPath": "/var/lib/ghost/content"
	    }
	}
	```
	
	```yaml
	# nginx/ssl/ - get key pair for domain
	# ghost/content/theme - add custom theme
	```
	```pem
-----BEGIN CERTIFICATE-----
YOUR_CERTIFICATE_HERE
-----END CERTIFICATE-----
	
	```
	```key
-----BEGIN PRIVATE KEY-----
YOUR_PRIVATE_KEY_HERE
-----END PRIVATE KEY-----
	
	```

Frigate: https://docs.frigate.video/guides/getting_started/
RustDesk Server: https://rustdesk.com/docs/en/self-host/rustdesk-server-oss/docker/
Home Assistant K3S: https://jaygould.co.uk/2024-01-01-setting-up-home-assistant-kubernetes-k3s/
PaperlessNG: https://docs.paperless-ngx.com/usage/#usage-email
GraphiteOS: https://grapheneos.org/faq#day-to-day-use
K8s: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#creating-a-deployment

---
*Note: This is a sanitized example. Replace placeholder values with your actual configuration.*
