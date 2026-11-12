# TLS trust playground

NGINX serves an expired certificate at `https://status.lab.internal:8443/`. Use `--resolve status.lab.internal:8443:127.0.0.1` to reach it. The lab CA, an unrelated CA and signing configuration are in `/opt/lab-ca/`. Renewing the playground restores the expired fixture.
