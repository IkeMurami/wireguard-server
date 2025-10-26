# Wireguard keys

# resource "tls_private_key" "wg-server" {
#   algorithm = "ED25519"
# }

# resource "tls_private_key" "wg-client" {
#   algorithm = "ED25519"
# }

# Чтение ключей через external data source
data "external" "wireguard-server-keys" {
  program = ["bash", "-c", <<-EOT
    PRIVATE_KEY=$(wg genkey)
    PUBLIC_KEY=$(echo $PRIVATE_KEY | wg pubkey)
    jq -n --arg private "$PRIVATE_KEY" --arg public "$PUBLIC_KEY" '{"private_key":$private,"public_key":$public}'
  EOT
  ]
}

data "external" "wireguard-client-keys" {
  program = ["bash", "-c", <<-EOT
    PRIVATE_KEY=$(wg genkey)
    PUBLIC_KEY=$(echo $PRIVATE_KEY | wg pubkey)
    jq -n --arg private "$PRIVATE_KEY" --arg public "$PUBLIC_KEY" '{"private_key":$private,"public_key":$public}'
  EOT
  ]
}
