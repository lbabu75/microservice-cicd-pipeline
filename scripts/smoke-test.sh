# scripts/smoke-test.sh
#!/bin/bash
# Smoke tests after deployment

set -e

ENDPOINT=${1}
if [ -z "$ENDPOINT" ]; then
    echo "Usage: $0 <endpoint>"
    exit 1
fi

echo "Running smoke tests against $ENDPOINT..."

# Health check
echo "Testing health endpoint..."
curl -f http://$ENDPOINT/health || exit 1

# Readiness check
echo "Testing readiness endpoint..."
curl -f http://$ENDPOINT/ready || exit 1

# API endpoint
echo "Testing API endpoint..."
curl -f http://$ENDPOINT/api/users || exit 1

# Metrics endpoint
echo "Testing metrics endpoint..."
curl -f http://$ENDPOINT/metrics || exit 1

echo "All smoke tests passed!"
