#!/usr/bin/env bash
# Bootstrap: stages the unmanaged healthcheck.sh script, its (root-owned)
# log directory, and an empty TLS working directory. Does NOT create the
# "healthcheck" user, the systemd unit, the drop-in override, or any TLS
# material -- those are the graded task across all three parts.

set -eu

sudo mkdir -p /opt/healthcheck
sudo tee /opt/healthcheck/healthcheck.sh > /dev/null << 'EOF'
#!/usr/bin/env bash
set -eu
LOG=/var/log/healthcheck/healthcheck.log
while true; do
  echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) status=ok" >> "$LOG"
  sleep 5
done
EOF
sudo chmod +x /opt/healthcheck/healthcheck.sh

# Log directory exists but is intentionally still root-owned -- the student
# must chown it to the "healthcheck" user once that user is created.
sudo mkdir -p /var/log/healthcheck

# Empty TLS working directory, owned by the login user, ready for key/cert
# generation.
sudo mkdir -p /opt/healthcheck/tls
sudo chown "$(whoami)":"$(whoami)" /opt/healthcheck/tls

if ! command -v openssl >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get install -y openssl
fi

sudo udevadm settle --timeout=30 || true
