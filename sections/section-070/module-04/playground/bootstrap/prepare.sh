#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
set -euo pipefail
sudo -n bash <<'ROOT'
set -euo pipefail
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y nginx openssl curl
install -d -m 700 /opt/lab-ca
install -d /etc/nginx/tls /srv/tls-status
printf 'certificate service ready\n' >/srv/tls-status/index.html
openssl req -new -x509 -newkey rsa:2048 -nodes -days 3650 -subj /CN=LFCS-Lab-CA -addext basicConstraints=critical,CA:TRUE -addext keyUsage=critical,keyCertSign,cRLSign -keyout /opt/lab-ca/ca.key -out /opt/lab-ca/ca.crt
openssl req -new -x509 -newkey rsa:2048 -nodes -days 3650 -subj /CN=Unrelated-CA -keyout /opt/lab-ca/unrelated.key -out /opt/lab-ca/unrelated.crt
openssl req -new -newkey rsa:2048 -nodes -subj /CN=status.lab.internal -keyout /etc/nginx/tls/status.key -out /opt/lab-ca/status.csr
chmod 600 /etc/nginx/tls/status.key /opt/lab-ca/*.key
cat >/opt/lab-ca/ca.conf <<'CONF'
[ca]
default_ca=local
[local]
database=/opt/lab-ca/index.txt
new_certs_dir=/opt/lab-ca
certificate=/opt/lab-ca/ca.crt
private_key=/opt/lab-ca/ca.key
serial=/opt/lab-ca/serial
default_md=sha256
policy=names
x509_extensions=server
unique_subject=no
[names]
commonName=supplied
[server]
basicConstraints=critical,CA:FALSE
keyUsage=critical,digitalSignature,keyEncipherment
extendedKeyUsage=serverAuth
subjectAltName=DNS:status.lab.internal
CONF
touch /opt/lab-ca/index.txt
printf '1000\n' >/opt/lab-ca/serial
openssl ca -batch -config /opt/lab-ca/ca.conf -in /opt/lab-ca/status.csr -out /etc/nginx/tls/status.crt -startdate "$(date -u -d '2 years ago' +%Y%m%d%H%M%SZ)" -enddate "$(date -u -d '1 year ago' +%Y%m%d%H%M%SZ)"
cp /etc/nginx/tls/status.crt /opt/lab-ca/expired.crt
cat >/etc/nginx/conf.d/lfcs-status.conf <<'NGINX'
server {
    listen 8443 ssl;
    server_name status.lab.internal;
    ssl_certificate /etc/nginx/tls/status.crt;
    ssl_certificate_key /etc/nginx/tls/status.key;
    root /srv/tls-status;
}
NGINX
nginx -t
systemctl enable nginx
systemctl restart nginx
ROOT
ASTRONA_STUDENT_SCRIPT
