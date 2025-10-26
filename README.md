# WireGuard VPN server

https://www.wireguard.com/quickstart/

## Deploy

Install WireGuard CLI:

```
brew install wireguard-tools
```

Run terraform:

```
make init
make plan
make apply
make connect <IP-ADDR>
```

Показать qr-код для подключения:

```
brew install qrencode
make qr
```

## Check wireguard status

```
# Проверить, включен ли автозапуск
systemctl is-enabled wg-quick@wg0

# Проверить текущий статус
systemctl status wg-quick@wg0

# Посмотреть состояние интерфейса
sudo wg show wg0
# Смотрим на:
# - latest handshake: должен быть недавним или (none)
# - transfer: должны быть цифры или 0
# Если latest handshake: (none) - соединение НЕ установлено!

# Проверить, слушает ли WireGuard порт
sudo ss -tulpn | grep 51820

# Логи
sudo journalctl -u wg-quick@wg0 -n 50 -f

# Проверить доступность порта на сервере
nc -vuz server_ip 51820
```

Еще проверяем публичные ключи на сервере и клиенте (`/etc/wireguard/wg0.conf` и `deploy/client.conf`)

## Wireguard connect

С сервера должен пинговаться клиент после успешного подключения (`ping 10.9.0.2`)

### На мобильном телефоне:

На MacOS создаем qrcode:

```
brew install qrencode
make qr
```

Сканируем в приложении WireGuard, подключаемся к VPN

### На компьютере

```
sudo mkdir -p /etc/wireguard
sudo cp deploy/client.conf /etc/wireguard/wg0.conf
sudo wg-quick up wg0
sudo wg show
sudo wg-quick down wg0
```
