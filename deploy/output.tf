output "external-ip" {
  value = yandex_compute_instance.instance.network_interface.0.nat_ip_address
}

resource "local_sensitive_file" "client-config" {
  content  = local.wireguard.client-config
  filename = "${path.module}/client.conf"
}

output "wg-server-pubkey" {
  value = data.external.wireguard-server-keys.result.public_key
}

output "wg-client-pubkey" {
  value = data.external.wireguard-client-keys.result.public_key
}
