#!/usr/bin/env bash
set -euo pipefail
sudo install -d -o student -g student /opt/monitor /var/log/monitor
cat >/opt/monitor/run-check.sh <<'REFERENCE_FILE'
#!/usr/bin/env bash

CHECK_ID=nightly-001
export PROBE_MODE=strict
label=${1:-manual}

/usr/local/bin/service-probe > /var/log/monitor/probe.out
/usr/local/bin/service-probe 2> /var/log/monitor/probe.err
/usr/local/bin/service-probe > /var/log/monitor/probe.combined 2>&1
/usr/local/bin/service-probe > /dev/null 2>&1
probe_exit=$?
echo "$probe_exit" > /var/log/monitor/probe.exit

if [ "$probe_exit" -eq 0 ]; then
  status=healthy
else
  status=degraded
fi

echo "label=$label" > /var/log/monitor/probe.summary
echo "status=$status" >> /var/log/monitor/probe.summary
for log_name in probe.out probe.err probe.combined; do
  echo "$log_name $(wc -l < "/var/log/monitor/$log_name") lines" >> /var/log/monitor/probe.summary
done

exit "$probe_exit"
REFERENCE_FILE
chmod +x /opt/monitor/run-check.sh
status=0
/opt/monitor/run-check.sh nightly-check || status=$?
test "$status" -ne 0

