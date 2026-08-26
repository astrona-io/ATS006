#!/usr/bin/env bash
# Bootstrap: installs the /usr/local/bin/service-probe diagnostic program
# and prepares a writable /var/log/monitor directory. The lab's own task
# is to build the /opt/monitor/run-check.sh wrapper around this probe --
# bootstrap must not create that wrapper or export PROBE_MODE anywhere.

set -eu

sudo tee /usr/local/bin/service-probe > /dev/null <<'EOF'
#!/usr/bin/env bash
echo "PROBE_DIAG: probe invoked with PROBE_MODE=${PROBE_MODE:-unset}" >&2

if [ -n "${CHECK_ID:-}" ]; then
  echo "PROBE_WARN: unexpected CHECK_ID=${CHECK_ID} visible to probe (should be shell-local only)" >&2
fi

if [ "${PROBE_MODE:-}" = "strict" ]; then
  echo "PROBE_OK: service healthy under strict mode"
  exit 0
else
  echo "PROBE_DEGRADED: strict mode not active" >&2
  exit 9
fi
EOF

sudo chmod +x /usr/local/bin/service-probe

sudo mkdir -p /var/log/monitor
sudo chown "$(whoami)" /var/log/monitor
