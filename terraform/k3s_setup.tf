# 1. Fetch Public IP for the TLS Certificate
data "http" "my_ip" {
  url = "https://ipv4.icanhazip.com"
}

# 2. Local Setup and Manifest Application
resource "null_resource" "k3s_install_local" {
  
  # Re-run if any of the configuration files change
  triggers = {
    registry_config = filemd5("${path.module}/../k3s/registry-config.yaml")
    traefik_config  = filemd5("${path.module}/../k3s/traefik-config.yaml")
  }

  provisioner "local-exec" {
    command = <<EOT
      # Update Firewall
      sudo firewall-cmd --permanent --add-port=6443/tcp
      sudo firewall-cmd --permanent --add-port=80/tcp
      sudo firewall-cmd --permanent --add-port=443/tcp
      sudo firewall-cmd --reload

      # Install K3s (using the IP fetched by Terraform)
      curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--tls-san ${trimspace(data.http.my_ip.response_body)}" sh -

      # Setup Private Registry
      sudo mkdir -p /etc/rancher/k3s
      sudo cp ${path.module}/../k3s/registry-config.yaml /etc/rancher/k3s/registries.yaml

      # Deploy K3s Manifests
      # K3s auto-deploys any yaml found in this specific directory
      sudo mkdir -p /var/lib/rancher/k3s/server/manifests
      sudo cp ${path.module}/../k3s/traefik-config.yaml /var/lib/rancher/k3s/server/manifests/
      sudo cp ${path.module}/../k3s/local-storage.yaml /var/lib/rancher/k3s/server/manifests/

      # Finalize permissions and restart
      sudo chmod 644 /etc/rancher/k3s/k3s.yaml
      sudo systemctl restart k3s
    EOT
  }
}

output "k3s_node_ip" {
  value = "K3s installed on host with Public IP: ${trimspace(data.http.my_ip.response_body)}"
}
