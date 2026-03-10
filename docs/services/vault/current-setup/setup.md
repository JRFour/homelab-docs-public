# Vault Current Setup

## Deployment

Vault is deployed as a direct installation on an LXC container.

## Configuration

Vault configuration includes:

### TLS/SSL Configuration

- Uses internal PKI for certificate management
- Root CA: "hogwarts.home Intermediate Authority"
- Issuer reference: "root-2026"
- Certificate Authority token: `hvs.<token>`

### PKI Setup

1. Root certificate creation:
   ```
   vault write -field=certificate pki/root/generate/internal \
        common_name="hogwarts.home" \
        issuer_name="root-2026" \
        ttl=87600h
   ```

2. Intermediate CA generation:
   ```
   vault write -format=json pki_int/intermediate/generate/internal \
        common_name="hogwarts.home Intermediate Authority" \
        issuer_name="hogwarts-dot-home-intermediate" \
        | jq -r '.data.csr' > pki_intermediate.csr
   ```

3. Certificate role creation:
   ```
   vault write pki_int/roles/hogwarts-dot-home \
        issuer_ref="$(vault read -field=default pki_int/config/issuers)" \
        allowed_domains="hogwarts.home" \
        allow_subdomains=true \
        max_ttl="720h"
   ```

### Access Control

- Admin token: `hvs.<token>`
- CA token: `hvs.<token>`

## Services

Vault serves as:
- Secrets management system
- Certificate authority for internal services
- ACME provider for Proxmox node certificates