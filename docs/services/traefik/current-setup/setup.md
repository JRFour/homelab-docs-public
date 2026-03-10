# Current Setup

## Host Information

| Hostname | IP Address | VLAN | Resources |
|----------|------------|------|-----------|
| PROD-PROXY-01 | [IP Address] | Production (20) | 2 vCPU, 4GB RAM, 40GB disk |

## Docker Configuration

### Container Details
- **Image**: `traefik:v3.4`
- **Container Name**: `traefik`
- **Restart Policy**: `unless-stopped`

### Network Configuration
- **Network**: `proxy` (bridge driver)
- **Ports Exposed**:
  - `80:80` (HTTP)
  - `443:443` (HTTPS)
  - `8080:8080` (Dashboard)

### Volume Mounts
- `/var/run/docker.sock:/var/run/docker.sock:ro` - Docker socket for service discovery
- `./certs:/certs:ro` - SSL certificates
- `./dynamic:/dynamic:ro` - Dynamic configuration

## EntryPoints Configuration

### Web (HTTP)
- **Address**: `:80`
- **Automatic Redirect**: HTTP to HTTPS (permanent 301)

### WebSecure (HTTPS)
- **Address**: `:443`
- **TLS Enabled**: true

## Providers Configuration

### Docker Provider
- **Enabled**: true
- **ExposedByDefault**: false
- **Network**: `proxy`

### File Provider
- **Configuration File**: `/dynamic/tls.yaml`

## API & Dashboard

### Dashboard
- **Enabled**: true
- **Access**: Secured via basic auth
- **URL**: `dashboard.prod-proxy-01`

### Basic Auth Middleware
- **Credentials**: `admin:$apr1$Tbn38QMk$TGBsO9a3YbYeYlXFVBVBvhD1`
- **Note**: Password is `P@ssw0rd` (hashed)

## Observability

### Logging
- **Log Level**: INFO
- **Access Log**: Enabled

### Metrics
- **Prometheus**: Enabled

## Services

### Whoami (Test Service)
- **Image**: `traefik/whoami`
- **Route**: `Host(\`prod-proxy-01\`) && PathPrefix(\`/whoami\`)`
- **EntryPoint**: websecure
- **TLS**: Enabled

## Known Issues & Limitations

1. **TLS Certificates**: Not yet configured
   - Let's Encrypt not fully set up
   - Using self-signed or placeholder certificates
   - Cloudflare DNS challenge prepared but not active

2. **Dashboard Security**:
   - Dashboard is exposed but uses basic auth
   - Consider further restricting access

3. **HTTPS Redirect**:
   - HTTP to HTTPS redirect is enabled
   - Permanent redirect configured
