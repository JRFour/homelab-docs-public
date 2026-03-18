# ACME Certificate Management

## Overview

The Proxmox virtualization environment includes automated certificate management using the Vault PKI intermediate CA. This configuration enables automated certificate issuance for Proxmox nodes and services using the HashiCorp Vault PKI backend.

## Prerequisites

Before configuring ACME with Vault:
- Vault PKI backend is already set up and accessible
- Proxmox nodes trust the Vault CA (ensure the Vault CA certificate is in the system trust store)
  - Add root certificate (.crt) to `/usr/local/share/ca-certificates/` and run `update-ca-certificates`, `systemctl restart pveproxy`, and `systemctl restart pvestatd`
- You have the Vault ACME directory URL (e.g., `https://vault.unicornafk.fr:8200/v1/pki/acme/directory`)

## Configuration Steps

### 1. Register ACME Account
Register an ACME account via CLI:
```bash
pvenode acme account register default <your-email>
```
- Choose **option 2 (Custom)** when prompted for the directory endpoint
- Enter your Vault ACME directory URL: `https://10.x.x.x:8200/v1/pki_int/acme/directory`
- Do **not** use external account binding (EAB) unless required

### 2. Set Domains
Configure the domains for which certificates will be issued:
```bash
pvenode config set --acme domains="server.example.com;node1.example.com"
```
- Replace with your actual domain(s), matching DNS records (e.g., for HA or round-robin setups)

### 3. Order Certificate
Order the certificate:
```bash
pvenode acme cert order
```
- The system will validate the domains and issue the certificate using Vault as the CA

### 4. Multi-Node Deployment
- Repeat steps 1-2 once on the first node
- Repeat step 3 on all nodes

## Security Considerations

1. **Trust Chain**: Ensure Proxmox nodes trust the Vault CA certificate
2. **Network Access**: Verify Proxmox nodes can access Vault at `https://10.x.x.x:8200`
3. **Certificate Storage**: Automated certificates stored in Proxmox certificate store
4. **Rotation**: Certificates automatically renewed by ACME process

## Integration Details

The ACME integration uses Vault's intermediate PKI:
- ACME directory endpoint: `https://10.x.x.x:8200/v1/pki_int/acme/directory`
- This allows Proxmox to request certificates from Vault using Vault's ACME support
- Certificates are automatically renewed based on expiration dates

## Troubleshooting

### Common Issues
1. **Certificate Trust**: If nodes fail to trust Vault CA, ensure proper certificate installation and service restart
2. **Network Connectivity**: Verify Proxmox can reach Vault at configured URL
3. **Domain Validation**: Ensure DNS records match domains configured in Proxmox

### Verification Steps
1. Check Vault logs for ACME-related errors
2. Verify certificate is properly installed on node
3. Confirm automatic renewal process works
4. Monitor Proxmox logs for certificate events

## References

- [Homelab docs: Proxmox ACME with Vault](https://homelab.adminafk.fr/guide/proxmox_acme/)
- [Proxmox VE Certificate Management Wiki](https://pve.proxmox.com/wiki/Certificate_Management)