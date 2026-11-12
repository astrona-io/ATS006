# Diagnose and limit a CPU-heavy service: reference repair

Inspect the process and journal before changing the unit. Apply the persistent drop-in:

```sh
sudo mkdir -p /etc/systemd/system/lfcs-cpu.service.d
sudo tee /etc/systemd/system/lfcs-cpu.service.d/resources.conf >/dev/null <<'EOF'
[Service]
CPUQuota=25%
CPUAccounting=yes
EOF
sudo systemctl daemon-reload
sudo systemctl restart lfcs-cpu.service
printf 'lfcs-cpu.service\n' | sudo tee /opt/course/cpu-service >/dev/null
```

Check `systemctl show lfcs-cpu.service` and take another timed sample. The service must remain active with its original worker. Reboot, reconnect, and repeat the checks.
