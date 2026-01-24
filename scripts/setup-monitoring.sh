# scripts/setup-monitoring.sh
#!/bin/bash
# Setup monitoring stack

set -e

echo "Adding Prometheus Helm repo..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

echo "Installing kube-prometheus-stack..."
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
    --namespace monitoring \
    --create-namespace \
    --values monitoring/prometheus-values.yml \
    --wait

echo "Installing CloudWatch Container Insights..."
kubectl apply -f monitoring/cloudwatch-agent-config.yml

echo "Monitoring stack installed successfully!"
