# Recover a service from a memory limit: reference repair

Inspect the process and journal before changing the unit. Apply the persistent drop-in:

```sh
sudo mkdir -p /etc/systemd/system/lfcs-memory.service.d
sudo tee /etc/systemd/system/lfcs-memory.service.d/resources.conf >/dev/null <<'EOF'
[Service]
MemoryHigh=96M
MemoryMax=128M
EOF
sudo systemctl daemon-reload
sudo systemctl restart lfcs-memory.service
sleep 5
```

Check `systemctl show lfcs-memory.service` and take another timed sample. The service must remain active with its original worker. Reboot, reconnect, and repeat the checks.
