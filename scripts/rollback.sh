# scripts/rollback.sh
#!/bin/bash
# Rollback deployment script

set -e

ENVIRONMENT=${1:-production}
APP_NAME=${APP_NAME:-microservice-app}
REVISION=${2:-0}

echo "Rolling back deployment in $ENVIRONMENT environment..."

if [ "$REVISION" -eq 0 ]; then
    kubectl rollout undo deployment/$APP_NAME -n $ENVIRONMENT
else
    kubectl rollout undo deployment/$APP_NAME -n $ENVIRONMENT --to-revision=$REVISION
fi

echo "Waiting for rollback to complete..."
kubectl rollout status deployment/$APP_NAME -n $ENVIRONMENT --timeout=5m

echo "Rollback completed successfully!"
