#!/bin/bash
# scripts/deploy.sh
# Main deployment script

set -e

# Configuration
ENVIRONMENT=${1:-production}
AWS_REGION=${AWS_REGION:-us-east-1}
CLUSTER_NAME=${CLUSTER_NAME:-microservice-cluster}
APP_NAME=${APP_NAME:-microservice-app}

echo "========================================="
echo "Deploying to: $ENVIRONMENT"
echo "AWS Region: $AWS_REGION"
echo "EKS Cluster: $CLUSTER_NAME"
echo "========================================="

# Update kubeconfig
echo "Updating kubeconfig..."
aws eks update-kubeconfig --name $CLUSTER_NAME --region $AWS_REGION

# Verify cluster connectivity
echo "Verifying cluster connectivity..."
kubectl cluster-info

# Apply Kubernetes manifests
echo "Applying Kubernetes manifests..."
kubectl apply -f k8s/namespace.yml
kubectl apply -f k8s/configmap.yml
kubectl apply -f k8s/secret.yml
kubectl apply -f k8s/deployment.yml
kubectl apply -f k8s/service.yml
kubectl apply -f k8s/ingress.yml
kubectl apply -f k8s/hpa.yml

# Wait for rollout
echo "Waiting for rollout to complete..."
kubectl rollout status deployment/$APP_NAME -n $ENVIRONMENT --timeout=5m

# Verify deployment
echo "Verifying deployment..."
kubectl get pods -n $ENVIRONMENT -l app=$APP_NAME
kubectl get svc -n $ENVIRONMENT -l app=$APP_NAME

echo "========================================="
echo "Deployment completed successfully!"
echo "========================================="
