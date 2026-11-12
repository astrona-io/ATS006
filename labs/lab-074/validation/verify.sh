#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
set -u
fail() { echo "FAIL: $*"; exit 1; }
body=$(sudo curl --noproxy '*' --silent --show-error --fail --max-time 5 \
  --cacert /opt/lab-ca/ca.crt --resolve status.lab.internal:8443:127.0.0.1 \
  https://status.lab.internal:8443/) || fail 'trusted hostname-verified TLS request failed'
test "$body" = 'certificate service ready' || fail 'TLS service returned the wrong application body'
certificate=$(mktemp)
trap 'rm -f "$certificate"' EXIT
timeout 10 openssl s_client -connect 127.0.0.1:8443 -servername status.lab.internal \
  -showcerts </dev/null 2>/dev/null | openssl x509 -out "$certificate" 2>/dev/null || fail 'could not read the served certificate'
openssl x509 -in "$certificate" -checkend 604800 -noout >/dev/null || fail 'served certificate must remain valid for at least seven days'
status=0
sudo curl --noproxy '*' --silent --max-time 5 --cacert /opt/lab-ca/unrelated.crt \
  --resolve status.lab.internal:8443:127.0.0.1 https://status.lab.internal:8443/ >/dev/null 2>&1 || status=$?
test "$status" = 60 || fail "unrelated CA must cause certificate rejection, got curl exit $status"
mode=$(sudo stat -c %a /etc/nginx/tls/status.key)
test "$mode" = 600 || fail 'private key must retain mode 600'
echo 'PASS: live TLS verifies with the lab CA and hostname, rejects an unrelated CA, and has sufficient lifetime'
ASTRONA_STUDENT_SCRIPT
