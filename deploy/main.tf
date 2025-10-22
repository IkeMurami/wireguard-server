# SSH connection
resource "tls_private_key" "vm-ssh-key" {
  algorithm = "ED25519"
}

resource "local_file" "vm-ssh-key-priv" {
  content         = tls_private_key.vm-ssh-key.private_key_openssh
  filename        = local.ssh-key-file-name
  file_permission = "0600"
}

resource "local_file" "vm-ssh-key-pub" {
  content         = tls_private_key.vm-ssh-key.public_key_openssh
  filename        = "${local.ssh-key-file-name}.pub"
  file_permission = "0644"
}

# Wireguard keys

resource "tls_private_key" "wg-server" {
  algorithm = "ED25519"
}

resource "tls_private_key" "wg-client" {
  algorithm = "ED25519"
}

# resource "null_resource" "wireguard-setup" {
#   # Подключение к существующей VM
#   connection {
#     type        = "ssh"
#     host        = yandex_compute_instance.instance.network_interface.0.nat_ip_address
#     user        = local.connection.default-user
#     private_key = file(var.connection.ssh-key.path)
#   }

#   provisioner "remote-exec" {
#     inline = [ 
#         "sudo mkdir -p ${local.base-dir}",
#         "sudo cd ${local.base-dir}",
#         # Create keys
#         "sudo umask 077",
#         "sudo wg genkey > privatekey",
#         "sudo wg pubkey < privatekey > publickey",
#         # Set network interface
#         "sudo ip link add wg0 type wireguard",
#         "sudo ip addr add 10.0.0.1/24 dev wg0",
#         # Set wg
#         "sudo wg set wg0 private-key ./private",
#         "sudo ip link set wg0 up"
#     ]
#   }
# }
