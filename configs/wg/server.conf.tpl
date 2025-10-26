[Interface]
Address = 10.9.0.1/24
PrivateKey = ${SERVER_PRIVKEY}
ListenPort = ${WIREGUARD_SERVER_PORT}
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

[Peer]
PublicKey = ${CLIENT_PUBKEY}
AllowedIPs = 10.9.0.2/32
