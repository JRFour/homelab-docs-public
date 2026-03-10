# Configuration

## Docker Compose Configuration

### Basic Setup
```yaml
services:
  traefik:
    image: traefik:v3.4
    container_name: traefik
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
```

### Network Configuration
```yaml
    networks:
      - proxy

networks:
  proxy:
    name: proxy
    driver: bridge
```

### Port Mappings
```yaml
    ports:
      - "80:80"     # HTTP
      - "443:443"   # HTTPS
      - "8080:8080" # Dashboard
```

### Volume Mounts
```yaml
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./certs:/certs:ro
      - ./dynamic:/dynamic:ro
```

## EntryPoints Configuration

### HTTP EntryPoint
```yaml
      - "--entrypoints.web.address=:80"
      - "--entrypoints.web.http.redirections.entrypoint.to=websecure"
      - "--entrypoints.web.http.redirections.entrypoint.scheme=https"
      - "--entrypoints.web.http.redirections.entrypoint.permanent=true"
```

### HTTPS EntryPoint
```yaml
      - "--entrypoints.websecure.address=:443"
      - "--entrypoints.websecure.http.tls=true"
```

## Providers

### Docker Provider
```yaml
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--providers.docker.network=proxy"
```

### File Provider
```yaml
      - "--providers.file.filename=/dynamic/tls.yaml"
```

## API & Dashboard

### Dashboard Configuration
```yaml
      - "--api.dashboard=true"
      - "--api.insecure=false"
```

### Dashboard Router with Basic Auth
```yaml
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.dashboard.rule=(Host(`dashboard.prod-proxy-01`) && (PathPrefix(`/dashboard`) || PathPrefix(`/api`)))"
      - "traefik.http.routers.dashboard.entrypoints=websecure"
      - "traefik.http.routers.dashboard.service=api@internal"
      - "traefik.http.routers.dashboard.tls=true"
      - "traefik.http.middlewares.dashboard-auth.basicauth.users=admin:$$apr1$$Tbn38QMk$$TGBsO9a3YbYeYlXFVBvhD1"
      - "traefik.http.routers.dashboard.middlewares=dashboard-auth@docker"
```

## Observability

### Logging
```yaml
      - "--log.level=INFO"
      - "--accesslog=true"
```

### Metrics
```yaml
      - "--metrics.prometheus=true"
```

## Service Routing Labels

### Enabling Service Discovery
```yaml
    labels:
      - "traefik.enable=true"
```

### Router Configuration
```yaml
      - "traefik.http.routers.<name>.rule=Host(`hostname`)"
      - "traefik.http.routers.<name>.entrypoints=websecure"
      - "traefik.http.routers.<name>.tls=true"
```

## Let's Encrypt Configuration

### DNS Challenge (Commented)
```yaml
      - "--certificatesresolvers.letsencrypt.acme.dnschallenge=true"
      - "--certificatesresolvers.letsencrypt.acme.dnschallenge.provider=cloudflare"
      - "--certificatesresolvers.letsencrypt.acme.dnschallenge.resolvers=X.X.X.X:53"
      - "--certificatesresolvers.le.acme.storage=/letsencrypt/acme.json"
```

### HTTP Challenge (Commented)
```yaml
      - "--certificatesresolvers.le.acme.httpchallenge.entrypoint=web"
```

## Secrets Configuration

### Cloudflare Secrets (Optional)
```yaml
    environment:
      - CLOUDFLARE_EMAIL_FILE=/run/secrets/cf_email
      - CLOUDFLARE_API_KEY_FILE=/run/secrets/cf_token
    secrets:
      - cf_email
      - cf_token

secrets:
  cf_token:
    file: ./letsencrypt/cf_token
  cf_email:
    file: ./letsencrypt/cf_email
```

## Dynamic Configuration

### TLS Configuration File
The dynamic TLS configuration should be placed in `./dynamic/tls.yaml`:

```yaml
tls:
  options:
    default:
      minVersion: VersionTLS12
      cipherSuites:
        - TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        - TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        - TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
        - TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
      curvePreferences:
        - CurveP521
        - CurveP384
      sniStrict: true
```
