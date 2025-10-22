# Security group

resource "yandex_vpc_security_group" "instance-security-group" {
  # https://yandex.cloud/ru/docs/vpc/concepts/security-groups
  name       = "app-security-group"
  network_id = yandex_vpc_network.network.id

  ingress {
    description    = "Allow SSH"
    protocol       = "ANY"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description    = "Allow Wireguard TCP"
    protocol       = "TCP"
    port           = var.wireguard-server-port
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description    = "Allow Wireguard UDP"
    protocol       = "UDP"
    port           = var.wireguard-server-port
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Permit ANY"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  provider = yandex.with-project-info
}
