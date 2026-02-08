#!/bin/bash
# 1. Install K3s if not present
if ! command -v k3s &> /dev/null; then
    curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--tls-san $(curl -s ifconfig.me/ip)" sh -
fi

# 2. Apply Cluster Level Configurations
sudo kubectl apply -f k3s/traefik-config.yaml
sudo kubectl apply -f k3s/local-storage.yaml

# 3. Handle Private Registry (Requires Restart)
sudo mkdir -p /etc/rancher/k3s
sudo cp k3s/registry-config.yaml /etc/rancher/k3s/registries.yaml
sudo systemctl restart k3s

echo "Cluster configurations applied successfully."
