[Interface]
PrivateKey = ${CLIENT_PRIVKEY}
Address = 10.9.0.2/24

[Peer]
PublicKey = ${SERVER_PUBKEY}
AllowedIPs = 0.0.0.0/0
Endpoint = ${WIREGUARD_SERVER_IP}:${WIREGUARD_SERVER_PORT} # Внешний IP сервера
PersistentKeepalive = 25
