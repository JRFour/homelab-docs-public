# Vault Best Practices & Recommendations

## Security Hardening

1. **Token Management**
   - Regular rotation of admin tokens
   - Use least privilege principle for all tokens
   - Implement token expiration policies
   - Disable root tokens in production

2. **PKI Security**
   - Regular rotation of root certificates
   - Monitor certificate lifecycles
   - Implement certificate revocation procedures
   - Use short-lived intermediate certificates

3. **Access Control**
   - Implement role-based access control (RBAC)
   - Regular audit of access policies
   - Enable audit logging for all operations
   - Limit network access to Vault server

## Upgrade Considerations

1. **Version Management**
   - Pin Vault versions in production
   - Test upgrades in staging environment
   - Backup configuration and secrets before upgrades

2. **Configuration Updates**
   - Review policy changes during upgrades
   - Apply security patches in a controlled manner
   - Validate certificate authority operations post-upgrade

## Backup Strategy

1. **Data Backup**
   - Regular snapshot backups of LXC container
   - Export of Vault configuration policies
   - Document all certificate rotations and issuance

2. **Disaster Recovery**
   - Maintain backup of unseal keys
   - Test recovery procedures regularly
   - Document recovery steps for Vault server

## Monitoring and Alerts

1. **Health Checks**
   - Monitor Vault server health
   - Track authentication failures
   - Monitor certificate issuance and expiration

2. **Logging**
   - Enable comprehensive audit logging
   - Integrate with centralized logging system
   - Set up alerts for security events