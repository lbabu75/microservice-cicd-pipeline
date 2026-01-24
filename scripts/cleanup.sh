# scripts/cleanup.sh
#!/bin/bash
# Cleanup resources

set -e

ENVIRONMENT=${1:-production}

echo "WARNING: This will delete all resources in $ENVIRONMENT environment!"
read -p "Are you sure? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Aborted"
    exit 1
fi

echo "Deleting Kubernetes resources..."
kubectl delete namespace $ENVIRONMENT

echo "Destroying Terraform infrastructure..."
cd terraform
terraform destroy -auto-approve

echo "Cleanup completed!"
