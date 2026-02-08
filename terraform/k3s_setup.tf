# terraform/k3s_setup.tf
resource "null_resource" "k3s_bootstrap" {
  triggers = {
    public_ip = var.VM_PUBLIC_IP
  }

  connection {
    type        = "ssh"
    user        = "opc"
    private_key = file(var.SSH_PRIVATE_KEY_PATH)
    host        = self.triggers.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo firewall-cmd --permanent --add-port=6443/tcp",
      "sudo firewall-cmd --permanent --add-port=80/tcp",
      "sudo firewall-cmd --permanent --add-port=443/tcp",
      "sudo firewall-cmd --reload",
      "curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC='--tls-san ${self.triggers.public_ip}' sh -"
    ]
  }
}
