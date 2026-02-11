# Sample Microservice - CI/CD Pipeline

A production-ready CI/CD pipeline for deploying microservices to AWS EKS with comprehensive security scanning, monitoring, and automated testing.

## Architecture Overview

The pipeline implements a complete DevOps workflow:

- **Infrastructure as Code**: Terraform manages k3s infra
- **Containerization**: Docker multi-stage builds for optimized images
- **Orchestration**: K3s on OCI vm
- **CI/CD**: GitHub Actions for automated pipeline
- **Security**: Multiple scanning tools (Snyk, Trivy, GitLeaks, SonarCloud)
- **Monitoring**: Prometheus, Grafana, CloudWatch
- **Alerting**: SNS, Slack integration

## Prerequisites

- OCI vm
- GitHub account
- kubectl CLI
- Terraform >= 1.0
- Docker
- Node.js 18+
- Helm 3+

## Quick Start

### 1. Setup Infrastructure

```bash
# Configure AWS credentials
export AWS_ACCESS_KEY_ID=your_access_key
export AWS_SECRET_ACCESS_KEY=your_secret_key
export AWS_REGION=us-east-1

# Initialize and apply Terraform
cd terraform
terraform init
terraform plan
terraform apply
```

### 2. Configure GitHub Secrets

Add these secrets to your GitHub repository:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `SNYK_TOKEN`
- `SONAR_TOKEN`
- `CODECOV_TOKEN`
- `SLACK_WEBHOOK`
- `COSIGN_PRIVATE_KEY`
- `COSIGN_PASSWORD`

### 3. Deploy Monitoring Stack

```bash
# Setup Prometheus and Grafana
./scripts/setup-monitoring.sh
```

### 4. Deploy Application

Push to main branch to trigger the CI/CD pipeline, or deploy manually:

```bash
./scripts/deploy.sh production
```

## Pipeline Stages

### 1. Security Scanning
- Static code analysis with SonarCloud
- Dependency vulnerability scanning with Snyk
- Secret scanning with GitLeaks
- OWASP Dependency Check

### 2. Testing
- Unit tests with Jest
- Integration tests
- Code coverage reporting

### 3. Build & Push
- Multi-stage Docker build
- Push to Amazon ECR
- Container vulnerability scanning with Trivy
- Image signing with Cosign

### 4. Deploy
- Update kubeconfig
- Apply Kubernetes manifests
- Rolling deployment with zero downtime
- Smoke tests

### 5. Monitoring
- Prometheus metrics collection
- Grafana dashboards
- CloudWatch logs and metrics
- Custom alerts

## Project Structure

```
.
├── app/                      # Application source code
│   ├── server.js            # Main application
│   ├── package.json         # Dependencies
│   └── Dockerfile           # Container definition
├── terraform/               # Infrastructure as Code
│   ├── main.tf             # Main Terraform config
│   └── variables.tf        # Variable definitions
├── k8s/                    # Kubernetes manifests
│   ├── deployment.yml      # Deployment configuration
│   ├── service.yml         # Service definition
│   ├── ingress.yml         # Ingress configuration
│   └── hpa.yml             # Autoscaling configuration
├── monitoring/             # Monitoring configuration
│   ├── prometheus-values.yml
│   └── cloudwatch-agent-config.yml
├── security/              # Security policies
│   ├── network-policy.yml
│   └── policy-as-code.rego
├── tests/                 # Test files
│   ├── unit/
│   └── integration/
├── scripts/               # Automation scripts
│   ├── deploy.sh
│   ├── rollback.sh
│   └── setup-infrastructure.sh
└── .github/
    └── workflows/
        └── cicd.yml       # GitHub Actions pipeline
```

## Security Features

### Container Security
- Non-root user execution
- Read-only root filesystem
- Dropped Linux capabilities
- Security context constraints

### Network Security
- Network policies for microsegmentation
- TLS/SSL termination at load balancer
- Private subnets for workloads

### Scanning
- Pre-commit secret scanning
- Dependency vulnerability scanning
- Container image scanning
- Static code analysis
- Policy-as-code validation

## Monitoring & Alerting

### Metrics
- CPU and memory utilization
- Request rate and latency
- Error rates
- Custom application metrics

### Alerts
- High error rate
- High response time
- Pod failures
- Resource exhaustion
- Container restarts

### Dashboards
- Cluster overview
- Application performance
- Resource utilization
- Error tracking

## Rollback Strategy

Automatic rollback on deployment failure:

```bash
# Manual rollback to previous version
./scripts/rollback.sh production

# Rollback to specific revision
./scripts/rollback.sh production 3
```

## Scaling

### Horizontal Pod Autoscaling
- CPU-based scaling: 70% threshold
- Memory-based scaling: 80% threshold
- Min replicas: 3
- Max replicas: 10

### Cluster Autoscaling
Managed by EKS with node groups scaling based on demand.

## Cost Optimization

- Spot instances for non-production environments
- Right-sized resource requests/limits
- ECR lifecycle policies
- CloudWatch log retention policies
- Auto-scaling to handle demand

## Troubleshooting

### Check pod status
```bash
kubectl get pods -n production
kubectl describe pod <pod-name> -n production
kubectl logs <pod-name> -n production
```

### View deployment history
```bash
kubectl rollout history deployment/sample-microservice -n production
```

### Check metrics
```bash
kubectl top pods -n production
kubectl top nodes
```

## Next

1. Create a feature branch
2. Make changes
3. Run tests: `make test`
4. Run security scans: `make security`
5. Submit pull request

