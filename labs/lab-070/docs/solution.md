# Solution Walkthrough

You wrap `healthcheck.sh` as a systemd service, change its restart delay with a drop-in override, and give it a key and a self-signed certificate. The grader checks the base unit file, the drop-in, the live state of the service, and the key and certificate files.

## Step 1: Create the service user and give it the log directory

Create a system account with no home directory and no login shell, then hand it the log directory the bootstrap left owned by root:

```sh
sudo useradd --system --no-create-home --shell /usr/sbin/nologin healthcheck
sudo chown healthcheck:healthcheck /var/log/healthcheck
```

Check the owner:

```sh
stat -c '%U:%G' /var/log/healthcheck
```

```text
healthcheck:healthcheck
```

## Step 2: Write the base unit file

Save this as `/etc/systemd/system/healthcheck.service` (for example with `sudo nano /etc/systemd/system/healthcheck.service`):

```ini
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
```

`RestartSec=` is left out on purpose. It comes only from the drop-in in the next step, and the grader fails the lab if this base file sets it.

## Step 3: Load, enable and start the service

Apply it:

```sh
sudo systemctl daemon-reload
sudo systemctl enable --now healthcheck.service
```

`daemon-reload` makes systemd read the new unit file. `enable --now` starts the service now and at every boot.

## Step 4: Add the restart delay with a drop-in

Open a drop-in:

```sh
sudo systemctl edit healthcheck.service
```

Type this into the editor, then save and close it:

```ini
[Service]
RestartSec=10
```

`systemctl edit` saves it as `/etc/systemd/system/healthcheck.service.d/override.conf`. The base unit file is never touched again. A drop-in works the same way on a unit you wrote yourself as on one a package installed: it keeps the value you tune in its own small file.

## Step 5: Apply the drop-in and check it

Apply it:

```sh
sudo systemctl daemon-reload
sudo systemctl restart healthcheck.service
```

Then check the result:

```sh
systemctl cat healthcheck.service
systemctl show healthcheck.service -p RestartUSec
systemctl is-active healthcheck.service
systemctl is-enabled healthcheck.service
```

`systemctl cat` shows your base unit followed by the `override.conf` fragment. `systemctl show` should report `RestartUSec=10s`, which proves the drop-in is loaded on the live unit. The last two commands should print `active` and `enabled`.

## Step 6: Generate the key and lock it down

Move into the TLS folder, generate a 2048-bit RSA key and restrict it at once:

```sh
cd /opt/healthcheck/tls
openssl genrsa -out healthcheck.key 2048
chmod 600 healthcheck.key
```

## Step 7: Write the configuration file and make the certificate

The SAN is an X.509 extension, so `-subj` cannot set it; a configuration file can. Save this as `openssl-healthcheck.cnf` in `/opt/healthcheck/tls`:

```ini
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
```

Use it to make a self-signed certificate valid for 365 days:

```sh
openssl req -new -x509 \
  -key healthcheck.key \
  -out healthcheck.crt \
  -days 365 \
  -config openssl-healthcheck.cnf
```

`x509_extensions` is the line `openssl req -new -x509` reads, so the SAN goes into the certificate.

## Step 8: Prove the key and certificate match

Compare the modulus of both files:

```sh
openssl x509 -noout -modulus -in healthcheck.crt | openssl md5
openssl rsa   -noout -modulus -in healthcheck.key | openssl md5
```

Identical hashes confirm the key and certificate are a matching pair.

## Step 9: Final checks and submit

Run the final checks:

```sh
systemctl is-active healthcheck.service
systemctl is-enabled healthcheck.service
systemctl show healthcheck.service -p RestartUSec
openssl x509 -in /opt/healthcheck/tls/healthcheck.crt -noout -subject -dates
```

The subject should contain `healthcheck.internal.local`, and `notBefore` and `notAfter` should be about 365 days apart. When everything looks right, send the lab for grading from your own machine:

```sh
astrona submit -c labs/lab-070
```
