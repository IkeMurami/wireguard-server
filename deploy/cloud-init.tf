locals {
  ssh_pub_key_content = fileexists("${local.ssh-key-file-name}.pub") ? file("${local.ssh-key-file-name}.pub") : "# SSH key will be generated during apply"
}

locals {
  write_files = [
    {
      path = "${local.base-dir}/server.conf",
      content = templatefile("${local.configs.wireguard}/server.conf.tpl", {
        SERVER_PRIVKEY = tls_private_key.wg-server.private_key_openssh
        CLIENT_PUBKEY  = tls_private_key.wg-client.public_key_openssh
      })
    }
  ]
  base-cloud-init = {
    # User setup configuration
    users = [
      {
        name  = local.connection.default-user
        sudo  = "ALL=(ALL) NOPASSWD:ALL"
        shell = "/bin/bash"
        ssh_authorized_keys = [
          local.ssh_pub_key_content
        ]
      }
    ]

    package_update  = true
    package_upgrade = true
    packages = [
      "wireguard"
    ]

    runcmd = [
      "echo 'Hello, World!' > /etc/hello-world.txt",
      # Install WireGuard
      # "sudo apt update && sudo apt upgrade -y",
      # "sudo apt install wireguard -y"
      # "chmod 666 /var/run/docker.sock"
    ]
    // Move configs to VM
    write_files = local.write_files
  }
  cloud-init-yaml = yamlencode(
    local.base-cloud-init
  )
}

data "cloudinit_config" "cloud-init" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"

    content = local.cloud-init-yaml
  }
}
