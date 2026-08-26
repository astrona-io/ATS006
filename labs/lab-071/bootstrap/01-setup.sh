#!/usr/bin/env bash
# Bootstrap: stages the unmanaged collector.sh script and its log directory,
# but does NOT create the "metrics" user, the systemd unit, or fix directory
# ownership -- those are the graded task the student must perform.

set -eu

sudo mkdir -p /opt/metrics
sudo tee /opt/metrics/collector.sh > /dev/null << 'EOF'
#!/usr/bin/env bash
set -eu
LOG=/var/log/metrics-collector/collector.log
while true; do
  echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) cpu=$(cat /proc/loadavg | awk '{print $1}') mem_free_kb=$(awk '/MemFree/{print $2}' /proc/meminfo)" >> "$LOG"
  sleep 5
done
EOF
sudo chmod +x /opt/metrics/collector.sh

# Log directory exists but is intentionally still root-owned -- the student
# must chown it to the "metrics" user once that user is created.
sudo mkdir -p /var/log/metrics-collector

sudo udevadm settle --timeout=30 || true
