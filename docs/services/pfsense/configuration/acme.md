# ACME Certificate Management

## Overview

The pfSense firewall supports ACME certificate management to automate certificate issuance from the Vault PKI intermediate CA. This enables automated certificate provisioning for internal services that require SSL/TLS certificates.

## ACME Package Setup

### Installation

1. Enable the ACME Package:
   - Go to **System > Package Manager**
   - Search for "ACME" and install the package

### Custom ACME Server Configuration

Configure Vault as a custom ACME server:
1. Navigate to **System > ACME Settings**
2. Click **Add Custom ACME Server**
3. Fill in the fields:
   - **Internal ID**: e.g., `vault-acme` (lowercase letters, numbers, dash)
   - **Display Name**: e.g., `Vault ACME Server`
   - **Server URL**: `http://10.10.20.5:8200/v1/pki_int/acme/directory`

## Account Key Setup

### Generate New Account Key

To create and register an account key:
1. Navigate to **Services > ACME Certificates**, **Account Keys** tab
2. Click **Add**
3. Fill in the info as described in Account Key Settings
4. Click **Generate New Account Key**
5. Click **Register ACME Account Key**
6. Click **Save**

## Certificate Configuration

### Webroot Local Folder Setup

Configure certificates using Webroot Local Folder method:
1. Navigate to **Services > ACME Certificates > Certificates**
2. Click **+ Add** to create a new certificate
3. Under **Account Keys**, select an account
4. In **Domain SAN List**, enter your domain(s) (e.g., `example.com`)
5. Select **Webroot Local Folder** as the **Method**
6. Set the **Root Folder** to: `/usr/local/www/.well-known/acme-challenge/`

## Integration with Vault PKI

The ACME integration with Vault PKI uses the intermediate CA:
- Vault ACME directory endpoint: `http://10.10.20.5:8200/v1/pki_int/acme/directory`
- This allows pfSense to request certificates from Vault using a custom ACME server

## Certificate Renewal

Certificates are automatically renewed by the ACME package based on their expiration dates. The renewal process:
- Uses the existing account key
- Contacts Vault's ACME endpoint
- Requests new certificates with same parameters
- Updates the pfSense configuration automatically

## Security Considerations

1. Network access: Ensure pfSense can access Vault at `http://10.10.20.5:8200`
2. Trust chain: Verify that pfSense nodes trust the Vault CA certificate
3. Policies: Use appropriate Vault policies to control who can issue certificates
4. EAB Support: Consider enabling External Account Binding (EAB) for additional security if required
5. HTTPS: For production, secure your Vault with HTTPS for ACME endpoints

## Testing

To test your ACME setup:
1. Register a test account key
2. Create a test certificate (e.g., `test.hogwarts.home`)
3. Verify certificate is properly issued and installed
4. Test certificate renewal process
5. Check Vault logs for any ACME-related errors