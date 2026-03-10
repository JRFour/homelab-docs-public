# Vault Configuration

## PKI Configuration

```
# Generate a root CA
vault write -field=certificate pki/root/generate/internal \
     common_name="hogwarts.home" \
     issuer_name="root-2026" \
     ttl=87600h > root_2026_ca.crt

# Generate intermediate CA
vault write -format=json pki_int/intermediate/generate/internal \
     common_name="hogwarts.home Intermediate Authority" \
     issuer_name="hogwarts-dot-home-intermediate" \
     | jq -r '.data.csr' > pki_intermediate.csr

# Sign intermediate
vault write -format=json pki/root/sign-intermediate \
     issuer_ref="root-2026" \
     csr=@pki_intermediate.csr \
     format=pem_bundle ttl="43800h" \
     | jq -r '.data.certificate' > intermediate.cert.pem

# Create certificate role
vault write pki_int/roles/hogwarts-dot-home \
     issuer_ref="$(vault read -field=default pki_int/config/issuers)" \
     allowed_domains="hogwarts.home" \
     allow_subdomains=true \
     max_ttl="720h"
```

## Policy Files

### admin-policy.hcl
```
path "sys/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "pki/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
```

### ca-policy.hcl
```
path "pki/*" {
  capabilities = ["read", "list"]
}
```

## ACME Integration

Vault is used as a custom ACME provider for Proxmox:
- Directory URL: `http://10.x.x.x:8200/v1/pki_int/acme/directory`

The integration with Proxmox enables automated certificate management using Vault as the CA.