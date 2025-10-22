data "yandex_compute_image" "image" {
  family = local.ycloud.image-family

  provider = yandex.with-project-info
}

# Чтобы instance был доступен из сети
resource "yandex_vpc_address" "addr" {
  name = "instance-adress"
  external_ipv4_address {
    zone_id = local.ycloud.zone
  }

  provider = yandex.with-project-info
}

resource "yandex_compute_instance" "instance" {
  name = "vm-instance"

  platform_id = "standard-v3" # Intel Ice Lake, https://yandex.cloud/ru/docs/compute/concepts/vm-platforms
  zone        = local.ycloud.zone

  # service_account_id = var.service-account-id
  resources {
    core_fraction = 50 # 50%
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.image.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    # Управляем, какие порты открываем
    security_group_ids = [
      yandex_vpc_security_group.instance-security-group.id
    ]

    # Если хотим открыть наружу (дать публичный адрес)
    nat            = true
    nat_ip_address = yandex_vpc_address.addr.external_ipv4_address[0].address
  }

  connection {
    host        = yandex_vpc_address.addr.external_ipv4_address[0].address
    user        = local.connection.default-user
    type        = "ssh"
    private_key = file(local.connection.ssh-key.path)
    timeout     = "2m"
  }

  metadata = {
    user-data = data.cloudinit_config.cloud-init.rendered
  }

  provider = yandex.with-project-info
}
