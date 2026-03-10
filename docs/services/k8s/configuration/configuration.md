# Kubernetes Configuration

## Cluster Architecture

The Kubernetes cluster follows a standard architecture using:
- Kubernetes base manifests for core functionality
- Kustomize overlays for environment-specific configurations

## Manifest Structure

### Base Components
- `namespace.yaml` - Defines the `homelab-lab` namespace
- `deployment.yaml` - Standard Nginx deployment with rolling update strategy
- `service.yaml` - ClusterIP service exposing port 80
- `network-policy.yaml` - Security policies for pod communication
- `test-deployment.yaml` and `test-service.yaml` - For validation purposes

### Overlays
- `dev/` - Development environment with single replica
- `prod/` - Production environment with enhanced security

## Deployment Process

### Applying Base Manifests
```bash
kubectl apply -k k8s/base/
```

### Applying Development Environment
```bash
kubectl apply -k k8s/overlays/dev/
```

## Configuration Parameters

Environment-specific configurations include:
- Development: Single replica deployments with development labels
- Production: Multiple replicas, enhanced security, resource limits and requests

## Security Configuration

### Network Policies
- Allow internal pod communication
- Restrict external access to services
- Follow principle of least privilege

### RBAC
- Role-based access control for cluster resources
- Limited user and service account permissions

### Secret Management
- All secrets managed externally
- Integration with external secret stores recommended