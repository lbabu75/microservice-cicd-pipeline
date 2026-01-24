# scripts/run-security-scans.sh
#!/bin/bash
# Run security scans locally

set -e

echo "Running security scans..."

# Snyk scan
echo "Running Snyk vulnerability scan..."
snyk test --all-projects || true

# Trivy scan
echo "Running Trivy container scan..."
trivy image --severity HIGH,CRITICAL sample-microservice:latest || true

# GitLeaks scan
echo "Running GitLeaks secret scan..."
gitleaks detect --source . --verbose || true

# OPA policy check
echo "Running OPA policy validation..."
conftest test k8s/ --policy security/policy-as-code.rego || true

echo "Security scans completed!"
