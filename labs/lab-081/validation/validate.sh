#!/usr/bin/env bash
# Match the account used by astrona ssh, including its home and permissions.
sudo -H -u student bash <<'ASTRONA_STUDENT_SCRIPT'
set -eu
fail() { echo "FAIL: $*"; exit 1; }
sudo cmp /usr/local/bin/lfcs-cpu-worker.py /usr/local/share/lfcs/cpu-worker.reference || fail 'assigned workload changed'
quota=$(systemctl show lfcs-cpu.service -p CPUQuotaPerSecUSec --value)
[ "$quota" = 250ms ] || fail 'service CPU quota must be 25 percent'
systemctl is-active --quiet lfcs-cpu.service || fail 'assigned service is not running'
[ "$(cat /opt/course/cpu-service 2>/dev/null)" = lfcs-cpu.service ] || fail 'record the responsible service in /opt/course/cpu-service'
first=$(systemctl show lfcs-cpu.service -p CPUUsageNSec --value)
sleep 8
last=$(systemctl show lfcs-cpu.service -p CPUUsageNSec --value)
python3 - "$first" "$last" <<'CHECK'
import sys
used = int(sys.argv[2]) - int(sys.argv[1])
# Eight seconds at 25% should consume about two CPU seconds. Allow scheduling jitter.
if not 80_000_000 < used < 3_600_000_000:
    print(f'FAIL: unexpected CPU consumption during sample: {used} ns')
    sys.exit(1)
CHECK
echo 'PASS: original service remains active with a measured CPU budget'
ASTRONA_STUDENT_SCRIPT
