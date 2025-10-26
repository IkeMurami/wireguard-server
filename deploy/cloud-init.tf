locals {
  ssh_pub_key_content = fileexists("${local.ssh-key-file-name}.pub") ? file("${local.ssh-key-file-name}.pub") : "# SSH key will be generated during apply"
}

locals {
  write_files = [
    {
      path = "${local.base-dir}/wg0.conf",
      content = templatefile("${local.configs.wireguard}/server.conf.tpl", {
        # SERVER_PRIVKEY        = tls_private_key.wg-server.private_key_openssh
        # CLIENT_PUBKEY         = tls_private_key.wg-client.public_key_openssh

        SERVER_PRIVKEY = data.external.wireguard-server-keys.result.private_key
        CLIENT_PUBKEY  = data.external.wireguard-client-keys.result.public_key

        WIREGUARD_SERVER_PORT = var.wireguard-server-port
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

    # Install WireGuard
    package_update  = true # apt update
    package_upgrade = true # apt upgrade -y
    packages = [
      "wireguard", # apt install wireguard -y
      "qrencode"
    ]

    runcmd = [
      "echo 'Hello, World!' > /etc/hello-world.txt",
      # "chmod 666 /var/run/docker.sock",
      "sysctl -w net.ipv4.ip_forward=1",
      "systemctl enable wg-quick@wg0",
      "systemctl start wg-quick@wg0"
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
