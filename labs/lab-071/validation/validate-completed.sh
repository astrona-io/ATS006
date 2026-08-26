#!/usr/bin/env bash
set -u

# 1. Dedicated non-root system user exists with no login shell.
if ! id metrics >/dev/null 2>&1; then
  echo "FAIL: system user 'metrics' does not exist"
  exit 1
fi

metrics_uid=$(id -u metrics)
if (( metrics_uid >= 1000 )); then
  echo "FAIL: 'metrics' user has UID $metrics_uid, expected a system UID (< 1000)"
  exit 1
fi

metrics_shell=$(getent passwd metrics | cut -d: -f7)
if [[ "$metrics_shell" != *"nologin"* ]]; then
  echo "FAIL: 'metrics' user shell is '$metrics_shell', expected a nologin shell"
  exit 1
fi

# 2. Log directory owned by metrics:metrics.
owner=$(stat -c '%U:%G' /var/log/metrics-collector 2>/dev/null)
if [[ "$owner" != "metrics:metrics" ]]; then
  echo "FAIL: /var/log/metrics-collector owned by '$owner', expected 'metrics:metrics'"
  exit 1
fi

# 3. Unit exists and is loaded with the correct directives.
if ! systemctl show metrics-collector.service -p LoadState 2>/dev/null | grep -q "LoadState=loaded"; then
  echo "FAIL: metrics-collector.service is not loaded by systemd"
  exit 1
fi

exec_start=$(systemctl show metrics-collector.service -p ExecStart --value)
if [[ "$exec_start" != *"/opt/metrics/collector.sh"* ]]; then
  echo "FAIL: ExecStart does not reference /opt/metrics/collector.sh (got: '$exec_start')"
  exit 1
fi

unit_user=$(systemctl show metrics-collector.service -p User --value)
if [[ "$unit_user" != "metrics" ]]; then
  echo "FAIL: unit User= is '$unit_user', expected 'metrics'"
  exit 1
fi

restart_policy=$(systemctl show metrics-collector.service -p Restart --value)
if [[ "$restart_policy" != "on-failure" ]]; then
  echo "FAIL: unit Restart= is '$restart_policy', expected 'on-failure'"
  exit 1
fi

after_list=$(systemctl show metrics-collector.service -p After --value)
wants_list=$(systemctl show metrics-collector.service -p Wants --value)
if [[ "$after_list" != *"network-online.target"* ]] || [[ "$wants_list" != *"network-online.target"* ]]; then
  echo "FAIL: unit does not both order After= and Wants= network-online.target (After='$after_list', Wants='$wants_list')"
  exit 1
fi

# 4. Running and enabled.
active_state=$(systemctl is-active metrics-collector.service 2>/dev/null)
if [[ "$active_state" != "active" ]]; then
  echo "FAIL: metrics-collector.service is not active (state: '$active_state')"
  exit 1
fi

enabled_state=$(systemctl is-enabled metrics-collector.service 2>/dev/null)
if [[ "$enabled_state" != "enabled" ]]; then
  echo "FAIL: metrics-collector.service is not enabled (state: '$enabled_state')"
  exit 1
fi

echo "PASS: metrics-collector.service is correctly configured, running, and enabled"
exit 0
