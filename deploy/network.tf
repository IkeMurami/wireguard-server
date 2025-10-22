# VPC Network

resource "yandex_vpc_network" "network" {
  name = local.ycloud.network.name

  provider = yandex.with-project-info
}

resource "yandex_vpc_subnet" "subnet" {
  name           = local.ycloud.network.subnetwork-name
  network_id     = yandex_vpc_network.network.id
  zone           = local.ycloud.zone
  v4_cidr_blocks = ["10.5.0.0/24"]

  provider = yandex.with-project-info
}
