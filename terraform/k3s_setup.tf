resource "null_resource" "k3s_install_local" {
  # This runs only once unless you manually taint it
  provisioner "local-exec" {
    command = <<EOT
      # 1. Open Firewall ports locally
      sudo firewall-cmd --permanent --add-port=6443/tcp
      sudo firewall-cmd --permanent --add-port=80/tcp
      sudo firewall-cmd --permanent --add-port=443/tcp
      sudo firewall-cmd --reload

      # 2. Install K3s (using the VM's public IP for the certificate)
      # We fetch the public IP dynamically so you don't have to hardcode it
      PUBLIC_IP=$(curl -s ifconfig.me)
      curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--tls-san $PUBLIC_IP" sh -
      
      # 3. Fix permissions so the runner user can use kubectl
      sudo chmod 644 /etc/rancher/k3s/k3s.yaml
    EOT
  }
}
