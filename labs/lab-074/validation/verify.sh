#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
set -u
fail() { echo "FAIL: $*"; exit 1; }
body=$(sudo curl --noproxy '*' --silent --show-error --fail --max-time 5 \
  --cacert /opt/lab-ca/ca.crt --resolve status.lab.internal:8443:127.0.0.1 \
  https://status.lab.internal:8443/ 2>/dev/null) || fail 'trusted hostname-verified TLS request failed'
test "$body" = 'certificate service ready' || fail 'TLS service returned the wrong application body'
sudo openssl x509 -in /etc/nginx/tls/status.crt -checkend 604800 -noout >/dev/null || fail 'certificate must remain valid for at least seven days'
status=0
sudo curl --noproxy '*' --silent --max-time 5 --cacert /opt/lab-ca/unrelated.crt \
  --resolve status.lab.internal:8443:127.0.0.1 https://status.lab.internal:8443/ >/dev/null 2>&1 || status=$?
test "$status" = 60 || fail "unrelated CA must cause certificate rejection, got curl exit $status"
mode=$(sudo stat -c %a /etc/nginx/tls/status.key)
test "$mode" = 600 || fail 'private key must retain mode 600'
echo 'PASS: live TLS verifies with the lab CA and hostname, rejects an unrelated CA, and has sufficient lifetime'
ASTRONA_STUDENT_SCRIPT
