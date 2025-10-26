# WireGuard VPN server

https://www.wireguard.com/quickstart/

## Preparation

1. [Install](https://yandex.cloud/en/docs/cli/operations/install-cli) Yandex Cloud CLI
2. Install WireGuard CLI: `brew install wireguard-tools`
3. Install QR-code maker: `brew install qrencode`
4. Create a [cloud](https://yandex.cloud/en/docs/resource-manager/operations/cloud/create) and a [folder](https://yandex.cloud/en/docs/resource-manager/operations/folder/create) in Yandex Cloud
5. Rename `deploy/variables.tfvars.tpl` to `deploy/variables.tfvars` and replace the `cloud-id` and the `folder-id` values

## Deploy

Export Yandex Cloud key:

```
export YC_TOKEN="$(yc iam create-token)"
```

Run terraform:

```
make init
make plan
make apply
```

Show QR-code for WireGuard connection:

```
make qr
```

Destroy server:

```
make destroy
```

## Check WireGuard status

Connect to VM: `make connect <IP-ADDR>`

```
# Check if autostart is enabled
systemctl is-enabled wg-quick@wg0

# Check current status
systemctl status wg-quick@wg0

# Show network interface status
sudo wg show wg0
# Check:
# - latest handshake: should be recent or (none)
# - transfer: should show numbers or 0
# If latest handshake: (none) - connection is NOT established!

# Check if WireGuard is listening on the port
sudo ss -tulpn | grep 51820

# Read logs
sudo journalctl -u wg-quick@wg0 -n 50 -f

# Check port accessibility
nc -vuz server_ip 51820
```

Check public keys in WireGuard client and server configs:

- server: `/etc/wireguard/wg0.conf`
- client: `deploy/client.conf`

## Check WireGuard connection

- On the client: `ping 10.9.0.1`
    - if local firewall rules don't block ICMP
- On the server: `ping 10.0.0.2`

### On a mobile phone

Create the connection QR-code on a laptop:

```
make qr
```

Add new tunnel in the WireGuard app and connect to VPN

### On a laptop

Move the WireGuard client config to `/etc/wireguard` and connect to the WireGuard server:

```
sudo mkdir -p /etc/wireguard
sudo cp deploy/client.conf /etc/wireguard/wg0.conf
sudo wg-quick up wg0
sudo wg show
```

To disconnect: `sudo wg-quick down wg0`
