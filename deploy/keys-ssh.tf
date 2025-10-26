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
