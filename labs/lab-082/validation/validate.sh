#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
set -eu
fail() { echo "FAIL: $*"; exit 1; }
sudo cmp /usr/local/bin/lfcs-memory-worker.py /usr/local/share/lfcs/memory-worker.reference || fail 'assigned workload changed'
[ "$(systemctl show lfcs-memory.service -p MemoryMax --value)" = 134217728 ] || fail 'MemoryMax must be 128 MiB'
[ "$(systemctl show lfcs-memory.service -p MemoryHigh --value)" = 100663296 ] || fail 'MemoryHigh must be 96 MiB'
systemctl is-active --quiet lfcs-memory.service || fail 'assigned service is not running'
restarts=$(systemctl show lfcs-memory.service -p NRestarts --value)
sleep 10
systemctl is-active --quiet lfcs-memory.service || fail 'service did not remain active'
[ "$(systemctl show lfcs-memory.service -p NRestarts --value)" = "$restarts" ] || fail 'service is still restarting'
current=$(systemctl show lfcs-memory.service -p MemoryCurrent --value)
[ "$current" -gt 60000000 ] || fail 'assigned memory workload is not resident'
echo 'PASS: original workload remains active within persistent memory limits'
ASTRONA_STUDENT_SCRIPT
