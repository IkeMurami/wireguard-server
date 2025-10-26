locals {
  base-dir          = "/etc/wireguard"
  ssh-key-file-name = "ycvm"
  ssh-key-file-path = pathexpand("${path.module}/${local.ssh-key-file-name}")

  connection = {
    default-user = "yc-user"
    ssh-key = {
      filename = local.ssh-key-file-name
      path     = local.ssh-key-file-path
    }
  }

  ycloud = {
    # "В каком DC разместить сервис"
    zone = "ru-central1-a"

    image-family = "ubuntu-2204-lts"

    network = {
      name            = "network"
      subnetwork-name = "subnet-a"
    }
  }

  configs = {
    wireguard = pathexpand("${path.module}/../configs/wg")
  }
}

locals {
  wireguard = {
    client-config = templatefile("${local.configs.wireguard}/client.conf.tpl", {
      CLIENT_PRIVKEY        = data.external.wireguard-client-keys.result.private_key
      SERVER_PUBKEY         = data.external.wireguard-server-keys.result.public_key
      WIREGUARD_SERVER_IP   = yandex_compute_instance.instance.network_interface.0.nat_ip_address
      WIREGUARD_SERVER_PORT = var.wireguard-server-port
    })
  }
}
