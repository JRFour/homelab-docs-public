# Home Lab Infrastructure

This repository contains the complete home lab infrastructure configuration including Docker Compose, Terraform, Kubernetes manifests, and comprehensive enterprise-grade documentation.

## Repository Overview

This project follows enterprise documentation standards with a focus on:
- Complete network architecture and design documentation
- Service-specific configuration guides with current state and upgrade recommendations
- Security hardening and best practices
- Operational procedures and runbooks

## Directory Structure

```
homelab-configs-private/
├── .github/                    # GitHub workflows and templates
│   ├── workflows/              # CI/CD pipelines
│   └── ISSUE_TEMPLATE/        # Issue templates
├── docs/                      # Documentation
│   ├── architecture/           # Network design and security
│   │   ├── overview.md
│   │   └── network-design.md
│   ├── services/              # Service documentation
│   │   ├── pfsense/          # pfSense router & firewall
│   │   ├── switches/         # Cisco switches
│   │   ├── proxmox/          # Proxmox VE
│   │   ├── terraform/        # Terraform infrastructure
│   │   ├── vault/            # HashiCorp Vault
│   │   ├── plex/             # Plex media server
│   │   ├── servarr/          # ServArr media management stack
│   │   ├── web-services/     # Web hosting stack
│   │   ├── k8s/              # Kubernetes deployments
│   │   ├── dns/              # DNS services
│   │   ├── smb/              # SMB file sharing
│   │   ├── wifi/             # Wireless network
│   │   └── llm/              # LLM services
│   ├── infrastructure/        # Terraform, Kubernetes
│   ├── operations/           # Procedures and runbooks
│   └── security/             # Security policies
├── configs/                   # Actual configurations
├── scripts/                   # Utility scripts
├── LICENSE                    # MIT License
├── README.md
├── CONTRIBUTING.md
├── SECURITY.md
├── CODE_OF_CONDUCT.md
├── CHANGELOG.md
├── AGENTS.md
└── .gitignore
```

## Documentation Coverage

This repository includes comprehensive documentation covering all aspects of the home lab infrastructure:

- **Network Architecture**: Complete network design and security documentation
- **Service Configurations**: Detailed guides for each service including current setup and best practices
- **Infrastructure**: Terraform configurations and Kubernetes manifests
- **Operations**: Procedures and runbooks for managing the infrastructure
- **Security**: Security policies and hardening recommendations

## How to Navigate the Documentation

1. **Architecture Overview**: Start with `docs/architecture/overview.md` for system-wide understanding
2. **Service-Specific Docs**: Find detailed documentation for each service in `docs/services/`
3. **Infrastructure**: Check `docs/infrastructure/` for Terraform and Kubernetes configurations
4. **Operations**: Refer to `docs/operations/` for operational procedures and runbooks

## Link to Architecture Documentation

- [Network Architecture Overview](docs/architecture/overview.md)
- [Network Design Documentation](docs/architecture/network-design.md)

## Contribution Guidelines

1. Fork the repository
2. Create a feature branch
3. Follow code style guidelines in AGENTS.md
4. Write clear commit messages using conventional commits format
5. Open a pull request
6. Ensure all tests pass before merging

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed contribution guidelines.