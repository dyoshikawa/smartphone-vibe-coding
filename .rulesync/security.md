---
root: false
targets: ["*"]
description: "Security guidelines and best practices"
globs: ["*"]
---

# Security Guidelines

## Infrastructure Security
1. **Access Control**
   - Use SSH key-based authentication only
   - Implement least privilege for service accounts
   - Consider adding OAuth/API key authentication to HTTP endpoints

2. **Network Security**
   - Restrict SSH access to specific IPs if possible
   - Use HTTPS for all HTTP endpoints
   - Enable firewall rules appropriately

3. **Secret Management**
   - Never commit secrets to version control
   - Use terraform.tfvars for sensitive variables (gitignored)
   - Store SSH keys securely
   - Rotate credentials regularly

## Code Security
1. **Input Validation**
   - Validate all user inputs
   - Sanitize data before processing
   - Use parameterized queries if databases are added

2. **Error Handling**
   - Don't expose internal errors to users
   - Log security events appropriately
   - Implement rate limiting for public endpoints

## Operational Security
1. **Monitoring**
   - Enable audit logging for all resources
   - Monitor for unusual access patterns
   - Set up alerts for security events

2. **Updates**
   - Keep all software updated
   - Apply security patches promptly
   - Review and update dependencies regularly

## Incident Response
- Have a plan for security incidents
- Know how to quickly disable compromised resources
- Document all security-related procedures