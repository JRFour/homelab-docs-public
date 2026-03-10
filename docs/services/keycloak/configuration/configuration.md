# Keycloak Configuration

## Environment Variables

Keycloak uses `KC_*` environment variables for configuration. Key settings:

| Variable | Description | Example |
|----------|-------------|---------|
| `KC_HOSTNAME` | Public hostname for Keycloak | `keycloak.homelab.local` |
| `KC_HOSTNAME_PORT` | Port for hostname | `8443` |
| `KC_BOOTSTRAP_ADMIN_USERNAME` | Initial admin username | `admin` |
| `KC_BOOTSTRAP_ADMIN_PASSWORD` | Initial admin password | (strong password) |
| `KC_DB` | Database vendor | `postgres`, `mysql` |
| `KC_DB_URL` | Database JDBC URL | JDBC connection string |
| `KC_DB_USERNAME` | Database username | `keycloak` |
| `KC_DB_PASSWORD` | Database password | (strong password) |

## Database Configuration

For production, configure an external database:

```yaml
services:
  keycloak:
    image: quay.io/keycloak/keycloak:25.0
    command: start
    environment:
      - KC_DB=postgres
      - KC_DB_URL=jdbc:postgresql://postgres:5432/keycloak
      - KC_DB_USERNAME=keycloak
      - KC_DB_PASSWORD=${KC_DB_PASSWORD}
    depends_on:
      - postgres
```

## Production Start Command

Use `start` instead of `start-dev` for production:

```yaml
command: start --optimized
```

The `--optimized` flag enables production optimizations.

## LDAP Federation

Configure LDAP user federation in the Keycloak admin console or via realm import:

```json
{
  "name": "ldap",
  "providerId": "ldap",
  "providerType": "org.keycloak.userstorage.UserStorageProvider",
  "config": {
    "vendor": ["active-directory"],
    "connectionUrl": ["ldap://ldap.homelab.local:389"],
    "bindDn": ["cn=keycloak,cn=Users,dc=homelab,dc=local"],
    "bindCredential": ["[LDAP_PASSWORD]"],
    "baseDn": ["cn=Users,dc=homelab,dc=local"],
    "usersDn": ["cn=Users,dc=homelab,dc=local"],
    "usernameLDAPAttribute": ["cn"],
    "rdnLDAPAttribute": ["cn"],
    "uuidLDAPAttribute": ["objectGUID"],
    "userObjectClasses": ["person, organizationalPerson, user"]
  }
}
```

## TLS/SSL Configuration

Configure HTTPS in production:

```yaml
environment:
  - KC_HOSTNAME_STRICT=false
  - KC_HOSTNAME_STRICT_HTTPS=false
  - KC_PROXY=edge
```
