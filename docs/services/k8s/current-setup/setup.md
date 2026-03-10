# Kubernetes Current Setup

## Overview

Kubernetes is used in the homelab to provide container orchestration and management.

## Deployment

- Uses standard Kubernetes base manifests with Kustomize overlays for different environments
- Deployments are managed with kubectl apply against k8s/base/ and k8s/overlays/dev/

## Manifests

### Base Components
- `namespace.yaml` - Namespace definition: homelab-lab
- `deployment.yaml` - Nginx deployment with rolling update strategy
- `service.yaml` - ClusterIP service exposing port 80
- `network-policy.yaml` - Network policies for pod-to-pod communication
- `test-deployment.yaml` - Test deployment for validation
- `test-service.yaml` - Test service for validation

### Overlays
- `dev/` - Development environment with single replica
- `prod/` - Production environment with multiple replicas and enhanced security

## Resources

### Deployments
- Single replica in dev environment
- Rolling update strategy
- Resource requests/limits defined for container

### Services
- ClusterIP type service
- Port 80 exposed
- Labels used for service discovery 

### Network Policies
- Allow internal pod communication
- Restrict external access
- Follow principle of least privilege

## Configuration Parameters

Environment-specific configurations defined through Kustomize overlays:
- Development (`k8s/overlays/dev/`)
  - Single replica deployment
  - Development labels and annotations
- Production (`k8s/overlays/prod/`)
  - Multiple replicas (configurable)
  - Security enhancements
  - Resource limits and requests

## Security

- All secrets managed externally
- Network policies restrict pod communication
- RBAC roles define access control
- Namespace isolation
- Regular security scanning recommended