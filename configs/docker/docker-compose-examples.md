#### Wetty

> **📖 Related Documentation:** [Setup Guide](../setup/0%20-%20Setup%20Guide.md) | [Network Summary](../network/Network%20Summary.md)

```yaml
services:
  bastion:
    image: wettyoss/wetty
    ports:
      - "3000:3000"
    environment:
      - SSHHOST=localhost
      - SSHPORT=22
      - SSHUSER=bastionuser
    volumes:
      - ./ssh-keys:/home/node/.ssh:ro
    restart: unless-stopped
    
  nginx:
    image: nginx:alpine
    ports:
      - "443:443"
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/ssl/certs
    depends_on:
      - bastion
    restart: unless-stopped
```

```nginx
# nginx.conf
events {
    worker_connections 1024;
}

http {
    upstream wetty {
        server bastion:3000;
    }
    
    server {
        listen 80;
        return 301 https://$server_name$request_uri;
    }
    
    server {
        listen 443 ssl;
        server_name your-domain.com;
        
        ssl_certificate /etc/ssl/certs/cert.pem;
        ssl_certificate_key /etc/ssl/certs/key.pem;
        
        # Basic auth for additional security
        auth_basic "Bastion Access";
        auth_basic_user_file /etc/nginx/.htpasswd;
        
        location / {
            proxy_pass http://wetty;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
}
```

#### Guacamole
```yaml
services:
  guacamole-db:
    image: postgres:13
    environment:
      POSTGRES_DB: guacamole_db
      POSTGRES_USER: guacamole_user
      POSTGRES_PASSWORD: YOUR_DB_PASSWORD
    volumes:
      - guacamole-db:/var/lib/postgresql/data

  guacamole:
    image: guacamole/guacamole
    depends_on:
      - guacamole-db
    environment:
      POSTGRES_DATABASE: guacamole_db
      POSTGRES_HOSTNAME: guacamole-db
      POSTGRES_USER: guacamole_user
      POSTGRES_PASSWORD: YOUR_DB_PASSWORD
    ports:
      - "8080:8080"

volumes:
  guacamole-db:
```

#### Media Stack
- Plex, Servarr
```yaml
version: '3.8'
services:
  plex:
    image: plexinc/pms-docker
    container_name: plex
    network_mode: host
    environment:
      - TZ=America/New_York
      - PLEX_CLAIM=YOUR_PLEX_CLAIM_TOKEN
    volumes:
      - /opt/plex/config:/config
      - /mnt/media:/data
    restart: unless-stopped

  sonarr:
    image: linuxserver/sonarr
    container_name: sonarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New_York
    volumes:
      - /opt/sonarr:/config
      - /mnt/media/tv:/tv
      - /mnt/downloads:/downloads
    ports:
      - 8989:8989
    restart: unless-stopped

  radarr:
    image: linuxserver/radarr
    container_name: radarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New_York
    volumes:
      - /opt/radarr:/config
      - /mnt/media/movies:/movies
      - /mnt/downloads:/downloads
    ports:
      - 7878:7878
    restart: unless-stopped

  prowlarr:
    image: linuxserver/prowlarr
    container_name: prowlarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New_York
    volumes:
      - /opt/prowlarr:/config
    ports:
      - 9696:9696
    restart: unless-stopped

  overseerr:
    image: linuxserver/overseerr
    container_name: overseerr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New_York
    volumes:
      - /opt/overseerr:/config
    ports:
      - 5055:5055
    restart: unless-stopped

  qbittorrent:
    image: linuxserver/qbittorrent
    container_name: qbittorrent
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New_York
      - WEBUI_PORT=8080
    volumes:
      - /opt/qbittorrent:/config
      - /mnt/downloads:/downloads
    ports:
      - 8080:8080
      - 6881:6881
      - 6881:6881/udp
    restart: unless-stopped
```

#### Monitoring & Logging Stack
- Prometheus, Grafana, Elasticsearch, Logstash, Kibana, Filebeat
```yaml
services:
  prometheus:
    image: prom/prometheus
    container_name: prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
      - '--web.enable-lifecycle'
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    ports:
      - 9090:9090
    restart: unless-stopped

  grafana:
    image: grafana/grafana
    container_name: grafana
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin123
    volumes:
      - grafana_data:/var/lib/grafana
    ports:
      - 3000:3000
    restart: unless-stopped

  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.9.0
    container_name: elasticsearch
    environment:
      - discovery.type=single-node
      - "ES_JAVA_OPTS=-Xms1g -Xmx1g"
      - xpack.security.enabled=false
    volumes:
      - elasticsearch_data:/usr/share/elasticsearch/data
    ports:
      - 9200:9200
    restart: unless-stopped

  logstash:
    image: docker.elastic.co/logstash/logstash:8.9.0
    container_name: logstash
    volumes:
      - ./logstash/pipeline:/usr/share/logstash/pipeline
    ports:
      - 5044:5044
      - 5000:5000/tcp
      - 5000:5000/udp
      - 9600:9600
    depends_on:
      - elasticsearch
    restart: unless-stopped

  kibana:
    image: docker.elastic.co/kibana/kibana:8.9.0
    container_name: kibana
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    ports:
      - 5601:5601
    depends_on:
      - elasticsearch
    restart: unless-stopped

  filebeat:
    image: docker.elastic.co/beats/filebeat:8.9.0
    container_name: filebeat
    user: root
    volumes:
      - ./filebeat/filebeat.yml:/usr/share/filebeat/filebeat.yml:ro
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
    depends_on:
      - logstash
    restart: unless-stopped

volumes:
  prometheus_data:
  grafana_data:
  elasticsearch_data:
```

#### Home Automation Stack
- HA, mosquitto, zigbee, nodered
```yaml
services:
  homeassistant:
    image: ghcr.io/home-assistant/home-assistant:stable
    container_name: homeassistant
    privileged: true
    restart: unless-stopped
    environment:
      - TZ=America/New_York
    volumes:
      - /opt/homeassistant:/config
      - /run/dbus:/run/dbus:ro
    network_mode: host

  mosquitto:
    image: eclipse-mosquitto
    container_name: mosquitto
    restart: unless-stopped
    ports:
      - 1883:1883
      - 9001:9001
    volumes:
      - /opt/mosquitto/config:/mosquitto/config
      - /opt/mosquitto/data:/mosquitto/data
      - /opt/mosquitto/log:/mosquitto/log

  zigbee2mqtt:
    image: koenkk/zigbee2mqtt
    container_name: zigbee2mqtt
    restart: unless-stopped
    volumes:
      - /opt/zigbee2mqtt:/app/data
      - /run/udev:/run/udev:ro
    ports:
      - 8080:8080
    environment:
      - TZ=America/New_York
    devices:
      - /dev/ttyUSB0:/dev/ttyUSB0
    depends_on:
      - mosquitto

  nodered:
    image: nodered/node-red
    container_name: nodered
    restart: unless-stopped
    environment:
      - TZ=America/New_York
    volumes:
      - /opt/nodered:/data
    ports:
      - 1880:1880
```

#### SSL Certificate Management
```yaml
services:
  step-ca:
    image: smallstep/step-ca
    container_name: step-ca
    environment:
      - DOCKER_STEPCA_INIT_NAME=Home Lab CA
      - DOCKER_STEPCA_INIT_DNS_NAMES=ca.lab.local
    volumes:
      - step-ca_data:/home/step
    ports:
      - 9000:9000
    restart: unless-stopped

volumes:
  step-ca_data:
```

#### Website Stack
- haproxy, nginx (x2), wordpress, ghost, hugo, mysql (x2), redis, varnish, cloudflare tunnel 
```yaml
networks:
  web_network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16

services:
  # Load Balancer / Reverse Proxy
  haproxy:
    image: haproxy:2.8-alpine
    container_name: haproxy-primary
    ports:
      - "80:80"
      - "443:443"
      - "8404:8404"  # Stats page
    volumes:
      - ./haproxy/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro
      - ./ssl:/etc/ssl/certs:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
    networks:
      web_network:
        ipv4_address: 172.20.0.10
    restart: unless-stopped
    depends_on:
      - nginx-primary
      - nginx-secondary

  # Primary Web Server
  nginx-primary:
    image: nginx:1.24-alpine
    container_name: nginx-primary
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx/sites-enabled:/etc/nginx/sites-enabled:ro
      - ./www:/var/www/html:ro
      - ./ssl:/etc/ssl/certs:ro
    networks:
      web_network:
        ipv4_address: 172.20.0.20
    restart: unless-stopped

  # Secondary Web Server
  nginx-secondary:
    image: nginx:1.24-alpine
    container_name: nginx-secondary
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx/sites-enabled:/etc/nginx/sites-enabled:ro
      - ./www:/var/www/html:ro
      - ./ssl:/etc/ssl/certs:ro
    networks:
      web_network:
        ipv4_address: 172.20.0.21
    restart: unless-stopped

  # WordPress
  wordpress:
    image: wordpress:6.3-php8.2-fpm
    container_name: wordpress
    environment:
      WORDPRESS_DB_HOST: mysql-primary:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: YOUR_DB_PASSWORD
      WORDPRESS_DB_NAME: wordpress
      WORDPRESS_CONFIG_EXTRA: |
        define('WP_REDIS_HOST', 'redis');
        define('WP_REDIS_PORT', 6379);
    volumes:
      - wordpress_data:/var/www/html
      - ./php/php.ini:/usr/local/etc/php/php.ini:ro
    networks:
      web_network:
        ipv4_address: 172.20.0.30
    depends_on:
      - mysql-primary
      - redis
    restart: unless-stopped

  # Ghost Blog
  ghost:
    image: ghost:5-alpine
    container_name: ghost-blog
    environment:
      database__client: mysql
      database__connection__host: mysql-primary
      database__connection__user: ghost
      database__connection__password: YOUR_DB_PASSWORD
      database__connection__database: ghost
      url: https://blog.yourdomain.com
    volumes:
      - ghost_data:/var/lib/ghost/content
    networks:
      web_network:
        ipv4_address: 172.20.0.31
    depends_on:
      - mysql-primary
    restart: unless-stopped

  # Static Site Generator (Hugo)
  hugo-site:
    image: nginx:alpine
    container_name: hugo-static
    volumes:
      - ./hugo/public:/usr/share/nginx/html:ro
      - ./nginx/static.conf:/etc/nginx/conf.d/default.conf:ro
    networks:
      web_network:
        ipv4_address: 172.20.0.32
    restart: unless-stopped

  # Primary MySQL Database
  mysql-primary:
    image: mysql:8.0
    container_name: mysql-primary
    environment:
      MYSQL_ROOT_PASSWORD: YOUR_DB_PASSWORD
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: YOUR_DB_PASSWORD
    volumes:
      - mysql_primary_data:/var/lib/mysql
      - ./mysql/my.cnf:/etc/mysql/my.cnf:ro
      - ./mysql/init:/docker-entrypoint-initdb.d:ro
    networks:
      web_network:
        ipv4_address: 172.20.0.50
    ports:
      - "3306:3306"
    restart: unless-stopped

  # MySQL Secondary (Read Replica)
  mysql-secondary:
    image: mysql:8.0
    container_name: mysql-secondary
    environment:
      MYSQL_ROOT_PASSWORD: YOUR_DB_PASSWORD
      MYSQL_REPLICATION_MODE: slave
      MYSQL_REPLICATION_USER: replicator
      MYSQL_REPLICATION_PASSWORD: YOUR_DB_PASSWORD
      MYSQL_MASTER_HOST: mysql-primary
    volumes:
      - mysql_secondary_data:/var/lib/mysql
      - ./mysql/my-slave.cnf:/etc/mysql/my.cnf:ro
    networks:
      web_network:
        ipv4_address: 172.20.0.51
    depends_on:
      - mysql-primary
    restart: unless-stopped

  # Redis Cache
  redis:
    image: redis:7-alpine
    container_name: redis-cache
    command: redis-server --appendonly yes --requirepass YOUR_DB_PASSWORD
    volumes:
      - redis_data:/data
    networks:
      web_network:
        ipv4_address: 172.20.0.55
    restart: unless-stopped

  # Varnish Cache
  varnish:
    image: varnish:7.1
    container_name: varnish-cache
    volumes:
      - ./varnish/default.vcl:/etc/varnish/default.vcl:ro
    networks:
      web_network:
        ipv4_address: 172.20.0.60
    depends_on:
      - nginx-primary
      - nginx-secondary
    restart: unless-stopped

  # Cloudflare Tunnel
  cloudflared:
    image: cloudflare/cloudflared:latest
    container_name: cloudflare-tunnel
    command: tunnel --no-autoupdate run --token YOUR_API_TOKEN
    networks:
      web_network:
        ipv4_address: 172.20.0.12
    restart: unless-stopped

volumes:
  wordpress_data:
  ghost_data:
  mysql_primary_data:
  mysql_secondary_data:
  redis_data:
```

```bash
# haproxy/haproxy.cfg
global
    daemon
    log stdout local0
    chroot /var/lib/haproxy
    stats socket /run/haproxy/admin.sock mode 660 level admin
    stats timeout 30s
    user haproxy
    group haproxy

defaults
    mode http
    log global
    option httplog
    option dontlognull
    option log-health-checks
    option forwardfor
    option http-server-close
    timeout connect 5000
    timeout client 50000
    timeout server 50000
    errorfile 400 /etc/haproxy/errors/400.http
    errorfile 403 /etc/haproxy/errors/403.http
    errorfile 408 /etc/haproxy/errors/408.http
    errorfile 500 /etc/haproxy/errors/500.http
    errorfile 502 /etc/haproxy/errors/502.http
    errorfile 503 /etc/haproxy/errors/503.http
    errorfile 504 /etc/haproxy/errors/504.http

frontend web_frontend
    bind *:80
    bind *:443 ssl crt /etc/ssl/certs/yourdomain.com.pem
    redirect scheme https if !{ ssl_fc }
    
    # ACLs for different sites
    acl is_blog hdr(host) -i blog.yourdomain.com
    acl is_static hdr(host) -i static.yourdomain.com
    acl is_wordpress hdr(host) -i www.yourdomain.com yourdomain.com
    
    # Route to appropriate backends
    use_backend blog_servers if is_blog
    use_backend static_servers if is_static
    use_backend wordpress_servers if is_wordpress
    default_backend wordpress_servers

backend wordpress_servers
    balance roundrobin
    option httpchk GET /wp-admin/admin-ajax.php
    server nginx-primary 172.20.0.20:80 check
    server nginx-secondary 172.20.0.21:80 check backup

backend blog_servers
    balance roundrobin
    option httpchk GET /ghost/api/v4/admin/site/
    server ghost-blog 172.20.0.31:2368 check

backend static_servers
    balance roundrobin
    option httpchk GET /
    server hugo-static 172.20.0.32:80 check

listen stats
    bind *:8404
    stats enable
    stats uri /stats
    stats refresh 30s
    stats admin if TRUE
```

#### Bastion Host Stack
```yaml
networks:
  bastion_network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.21.0.0/16

services:
  # Primary Bastion Host
  bastion-primary:
    build: ./bastion
    container_name: bastion-primary
    hostname: bastion-01
    environment:
      - TZ=America/New_York
      - BASTION_USER=bastionuser
      - ENABLE_2FA=true
    volumes:
      - ./bastion/ssh-keys:/home/bastionuser/.ssh:ro
      - ./bastion/config:/etc/bastion:ro
      - bastion_logs:/var/log/bastion
    networks:
      bastion_network:
        ipv4_address: 172.21.0.10
    ports:
      - "2222:22"
    restart: unless-stopped

  # Web-based SSH Terminal (Wetty)
  wetty:
    image: wettyoss/wetty
    container_name: wetty-terminal
    environment:
      - SSHHOST=bastion-primary
      - SSHPORT=22
      - SSHUSER=bastionuser
      - BASE=/terminal/
    networks:
      bastion_network:
        ipv4_address: 172.21.0.20
    depends_on:
      - bastion-primary
    restart: unless-stopped

  # Apache Guacamole (Web-based RDP/VNC/SSH)
  guacamole-db:
    image: postgres:13
    container_name: guacamole-postgres
    environment:
      POSTGRES_DB: guacamole_db
      POSTGRES_USER: guacamole_user
      POSTGRES_PASSWORD: YOUR_DB_PASSWORD
    volumes:
      - guacamole_db:/var/lib/postgresql/data
      - ./guacamole/initdb.sql:/docker-entrypoint-initdb.d/initdb.sql:ro
    networks:
      bastion_network:
        ipv4_address: 172.21.0.25
    restart: unless-stopped

  guacamole:
    image: guacamole/guacamole
    container_name: guacamole-server
    environment:
      POSTGRES_DATABASE: guacamole_db
      POSTGRES_HOSTNAME: guacamole-db
      POSTGRES_USER: guacamole_user
      POSTGRES_PASSWORD: YOUR_DB_PASSWORD
      POSTGRES_PORT: 5432
      GUACAMOLE_HOME: /etc/guacamole
    volumes:
      - ./guacamole/guacamole.properties:/etc/guacam
```

#### Primary n8n Deployment
```yaml
networks:
  n8n_network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.22.0.0/16
  external_network:
    external: true

services:
  # PostgreSQL Database for n8n
  n8n-db:
    image: postgres:15
    container_name: n8n-postgres
    environment:
      POSTGRES_DB: n8n
      POSTGRES_USER: n8n
      POSTGRES_PASSWORD: YOUR_DB_PASSWORD
      POSTGRES_NON_ROOT_USER: n8n
      POSTGRES_NON_ROOT_PASSWORD: YOUR_DB_PASSWORD
    volumes:
      - n8n_db_data:/var/lib/postgresql/data
      - ./n8n/db-init:/docker-entrypoint-initdb.d:ro
    networks:
      n8n_network:
        ipv4_address: 172.22.0.16
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -h localhost -U n8n"]
      interval: 10s
      timeout: 5s
      retries: 5
    restart: unless-stopped

  # Redis for Queue Management
  n8n-redis:
    image: redis:7-alpine
    container_name: n8n-redis
    command: redis-server --requirepass YOUR_DB_PASSWORD
    volumes:
      - n8n_redis_data:/data
      - ./redis/redis.conf:/usr/local/etc/redis/redis.conf:ro
    networks:
      n8n_network:
        ipv4_address: 172.22.0.15
    healthcheck:
      test: ["CMD", "redis-cli", "--raw", "incr", "ping"]
      interval: 10s
      timeout: 3s
      retries: 5
    restart: unless-stopped

  # n8n Main Application
  n8n-main:
    image: n8nio/n8n:latest
    container_name: n8n-primary
    environment:
      # Database Configuration
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=n8n-db
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=n8n
      - DB_POSTGRESDB_USER=n8n
      - DB_POSTGRESDB_PASSWORD=YOUR_DB_PASSWORD
      
      # Queue Configuration
      - QUEUE_BULL_REDIS_HOST=n8n-redis
      - QUEUE_BULL_REDIS_PORT=6379
      - QUEUE_BULL_REDIS_PASSWORD=YOUR_DB_PASSWORD
      - EXECUTIONS_MODE=queue
      
      # Security & Authentication
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=${N8N_ADMIN_USER}
      - N8N_BASIC_AUTH_PASSWORD=YOUR_DB_PASSWORD
      - N8N_JWT_AUTH_ACTIVE=true
      - N8N_JWT_AUTH_HEADER=authorization
      - N8N_JWKS_URI=${KEYCLOAK_URL}/auth/realms/homelab/protocol/openid_connect/certs
      
      # Network & Webhooks
      - WEBHOOK_URL=https://n8n.lab.local
      - N8N_HOST=n8n.lab.local
      - N8N_PORT=5678
      - N8N_PROTOCOL=https
      
      # Feature Flags
      - N8N_METRICS=true
      - N8N_LOG_LEVEL=info
      - N8N_USER_FOLDER=/home/node
      - GENERIC_TIMEZONE=America/New_York
      
      # Custom Node Modules
      - N8N_CUSTOM_EXTENSIONS=/opt/custom-nodes
      
    volumes:
      - n8n_user_data:/home/node
      - n8n_custom_nodes:/opt/custom-nodes
      - ./n8n/workflows:/opt/workflows:ro
      - ./n8n/credentials:/opt/credentials:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
    ports:
      - "5678:5678"
    networks:
      n8n_network:
        ipv4_address: 172.22.0.10
      external_network: {}
    depends_on:
      n8n-db:
        condition: service_healthy
      n8n-redis:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost:5678/healthz"]
      interval: 30s
      timeout: 10s
      retries: 3
    restart: unless-stopped

  # n8n Worker Nodes for Queue Processing
  n8n-worker-1:
    image: n8nio/n8n:latest
    container_name: n8n-worker-1
    command: worker
    environment:
      - DB_TYPE=postgresdb
      - DB_POSTGRESDB_HOST=n8n-db
      - DB_POSTGRESDB_PORT=5432
      - DB_POSTGRESDB_DATABASE=n8n
      - DB_POSTGRESDB_USER=n8n
      - DB_POSTGRESDB_PASSWORD=YOUR_DB_PASSWORD
      - QUEUE_BULL_REDIS_HOST=n8n-redis
      - QUEUE_BULL_REDIS_PORT=6379
      - QUEUE_BULL_REDIS_PASSWORD=YOUR_DB_PASSWORD
      - N8N_CUSTOM_EXTENSIONS=/opt/custom-nodes
    volumes:
      - n8n_user_data:/home/node
      - n8n_custom_nodes:/opt/custom-nodes
      - /var/run/docker.sock:/var/run/docker.sock:ro
    networks:
      n8n_network:
        ipv4_address: 172.22.0.11
      external_network: {}
    depends_on:
      - n8n-main
    restart: unless-stopped

  # RabbitMQ for Advanced Messaging
  rabbitmq:
    image: rabbitmq:3.12-management-alpine
    container_name: n8n-rabbitmq
    environment:
      RABBITMQ_DEFAULT_USER: ${RABBITMQ_USER}
      RABBITMQ_DEFAULT_PASS: YOUR_DB_PASSWORD
      RABBITMQ_DEFAULT_VHOST: n8n
    volumes:
      - rabbitmq_data:/var/lib/rabbitmq
      - ./rabbitmq/rabbitmq.conf:/etc/rabbitmq/rabbitmq.conf:ro
    ports:
      - "15672:15672"  # Management UI
      - "5672:5672"    # AMQP
    networks:
      n8n_network:
        ipv4_address: 172.22.0.25
    restart: unless-stopped

  # Webhook Gateway for External Integrations
  webhook-gateway:
    image: nginx:alpine
    container_name: n8n-webhook-gateway
    volumes:
      - ./nginx/webhook-gateway.conf:/etc/nginx/nginx.conf:ro
      - ./ssl:/etc/ssl/certs:ro
    ports:
      - "8443:443"
    networks:
      n8n_network:
        ipv4_address: 172.22.0.20
    depends_on:
      - n8n-main
    restart: unless-stopped

  # File Processing Service
  file-processor:
    image: alpine:latest
    container_name: n8n-file-processor
    command: tail -f /dev/null
    volumes:
      - n8n_file_processing:/opt/processing
      - ./scripts/file-processor.sh:/usr/local/bin/process-files.sh:ro
    networks:
      n8n_network:
        ipv4_address: 172.22.0.37
    restart: unless-stopped

volumes:
  n8n_db_data:
  n8n_redis_data:
  n8n_user_data:
  n8n_custom_nodes:
  n8n_file_processing:
  rabbitmq_data:
```

---
*Note: This is a sanitized example. Replace placeholder values with your actual configuration.*
