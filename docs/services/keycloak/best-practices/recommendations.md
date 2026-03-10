# Keycloak Best Practices

## Security Hardening

### Image Management

- **Pin versions**: Always use specific image tags, never `:latest`
  ```yaml
  image: quay.io/keycloak/keycloak:25.0.2
  ```
- Use Quay.io official images only
- Regularly update to latest stable versions

### Authentication

- **Change default credentials**: Remove hardcoded admin credentials
  ```yaml
  environment:
    - KEYCLOAK_ADMIN=admin
    - KEYCLOAK_ADMIN_PASSWORD=${KEYCLOAK_ADMIN_PASSWORD}
  ```
- Use environment variables for secrets, never commit to version control
- Enable MFA for admin accounts

### TLS/HTTPS

- **Enable TLS in production**: Never run Keycloak over plain HTTP in production
  ```yaml
  environment:
    - KC_HTTPS_KEY_STORE_FILE=/etc/keycloak/keystore.p12
    - KC_HTTPS_KEY_STORE_PASSWORD=${KC_HTTPS_KEY_STORE_PASSWORD}
  ```
- Use strong TLS ciphers
- Redirect HTTP to HTTPS
- Configure certificate properly

### Network Security

- Run behind reverse proxy (Traefik)
- Restrict network access to VLAN 20 only
- Use firewall rules to limit access

### Database Security

- Use external database (PostgreSQL/MySQL) instead of H2
- Enable SSL for database connections
- Use strong database passwords

## Resource Management

### Memory Tuning

Keycloak requires adequate heap memory:

```yaml
environment:
  - JAVA_OPTS=-Xms512m -Xmx2048m -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=512m
```

### Healthchecks

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:8080/health/ready"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 60s
```

### Resource Limits

```yaml
deploy:
  resources:
    limits:
      cpus: '4'
      memory: 4G
    reservations:
      cpus: '2'
      memory: 2G
```

## Recommended Production Configuration

```yaml
services:
  keycloak:
    image: quay.io/keycloak/keycloak:25.0
    command: start --optimized
    container_name: keycloak
    environment:
      - KC_HOSTNAME=keycloak.homelab.local
      - KC_HOSTNAME_STRICT=false
      - KC_PROXY=edge
      - KC_DB=postgres
      - KC_DB_URL=jdbc:postgresql://postgres:5432/keycloak
      - KC_DB_USERNAME=keycloak
      - KC_DB_PASSWORD=${KC_DB_PASSWORD}
      - KEYCLOAK_ADMIN=${KEYCLOAK_ADMIN}
      - KEYCLOAK_ADMIN_PASSWORD=${KEYCLOAK_ADMIN_PASSWORD}
    ports:
      - "8443:8443"
    volumes:
      - ./certs:/etc/keycloak/certs:ro
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "https://localhost:8443/health/ready"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 120s
```

## Monitoring

- Enable Keycloak metrics endpoint
- Monitor JVM memory usage
- Track login attempts and failures
- Set up alerts for authentication failures

## Backup Strategy

- Backup Keycloak database regularly
- Export realm configurations
- Store realm JSON exports in version control
- Document custom theme/component modifications

## Upgrade Priority

| Priority | Task | Timeline |
|----------|------|----------|
| High | Pin Keycloak version | Week 1 |
| High | Enable TLS/HTTPS | Week 1 |
| High | Change admin credentials | Week 1 |
| Medium | Add healthcheck | Week 2 |
| Medium | Configure external database | Week 2 |
| Medium | Add resource limits | Week 2 |
| Low | Set up monitoring | Month 1 |
| Low | Configure LDAP federation | Month 1 |
