# 1. Let Terraform fetch the IP so it can "see" it
data "http" "my_ip" {
  url = "https://ifconfig.me"
}

resource "null_resource" "k3s_install_local" {
  provisioner "local-exec" {
    command = <<EOT
      sudo firewall-cmd --permanent --add-port=6443/tcp
      sudo firewall-cmd --permanent --add-port=80/tcp
      sudo firewall-cmd --permanent --add-port=443/tcp
      sudo firewall-cmd --reload

      # Use the Terraform data source variable here instead of a shell command
      curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--tls-san ${data.http.my_ip.response_body}" sh -
      
      sudo chmod 644 /etc/rancher/k3s/k3s.yaml
    EOT
  }
}

# 2. Now the output can actually show the real IP!
output "k3s_node_ip" {
  value = "K3s installed on host with Public IP: ${data.http.my_ip.response_body}"
}
