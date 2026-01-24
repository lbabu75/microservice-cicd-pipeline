# scripts/setup-infrastructure.sh
#!/bin/bash
# Infrastructure setup script

set -e

cd terraform

echo "Initializing Terraform..."
terraform init

echo "Validating Terraform configuration..."
terraform validate

echo "Planning infrastructure changes..."
terraform plan -out=tfplan

read -p "Apply these changes? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Aborted"
    exit 1
fi

echo "Applying infrastructure changes..."
terraform apply tfplan

echo "Infrastructure setup completed!"

# Export outputs
echo "Exporting outputs..."
terraform output -json > outputs.json
