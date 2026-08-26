# Solution Guide: Service Configuration Capstone

This guide wraps `healthcheck.sh` as a systemd service, layers a drop-in override on top of it, and issues it a TLS key/certificate pair.

---

## Part 1: Create the base unit

```bash
sudo useradd --system --no-create-home --shell /usr/sbin/nologin healthcheck
sudo chown healthcheck:healthcheck /var/log/healthcheck
```

```bash
sudo tee /etc/systemd/system/healthcheck.service > /dev/null << 'EOF'
[Unit]
Description=Healthcheck Service
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=healthcheck
Group=healthcheck
ExecStart=/opt/healthcheck/healthcheck.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
```

Notice `RestartSec=` is deliberately absent here — it's added only via the drop-in in Part 2, so the base unit file stays exactly as written above.

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now healthcheck.service
```

---

## Part 2: Layer the RestartSec override with a drop-in

```bash
sudo systemctl edit healthcheck.service
```

Add:

```ini
[Service]
RestartSec=10
```

This creates `/etc/systemd/system/healthcheck.service.d/override.conf` — the base unit file from Part 1 is never touched again.

```bash
sudo systemctl daemon-reload
sudo systemctl restart healthcheck.service
```

Confirm the merge and the live value:

```bash
systemctl cat healthcheck.service
systemctl show healthcheck.service -p RestartUSec
```

> **Note:** This is the same mechanism used for overriding a vendor-packaged unit — a drop-in layers on top of whatever unit already exists, whether that unit is package-owned or, as here, one you wrote yourself. The point is keeping the tunable parameter in a separate, clearly-scoped file rather than growing the base unit file every time a value needs to change.

---

## Part 3: Generate and verify the TLS key/certificate pair

```bash
cd /opt/healthcheck/tls
openssl genrsa -out healthcheck.key 2048
chmod 600 healthcheck.key
```

```bash
cat > openssl-healthcheck.cnf << 'EOF'
[req]
default_bits       = 2048
prompt             = no
default_md         = sha256
distinguished_name = dn
x509_extensions    = req_ext

[dn]
C  = US
O  = Internal Lab
CN = healthcheck.internal.local

[req_ext]
subjectAltName = @alt_names

[alt_names]
DNS.1 = healthcheck.internal.local
EOF
```

```bash
openssl req -new -x509 \
  -key healthcheck.key \
  -out healthcheck.crt \
  -days 365 \
  -config openssl-healthcheck.cnf
```

```bash
openssl x509 -noout -modulus -in healthcheck.crt | openssl md5
openssl rsa   -noout -modulus -in healthcheck.key | openssl md5
```

Identical hashes confirm the key and certificate are a matching pair.

---

## Final Checks

```bash
systemctl is-active healthcheck.service
systemctl is-enabled healthcheck.service
systemctl show healthcheck.service -p RestartUSec
openssl x509 -in /opt/healthcheck/tls/healthcheck.crt -noout -subject -dates
```
