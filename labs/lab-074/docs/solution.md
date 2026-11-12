# Reference solution

Run inside the lab VM:

```bash
sudo openssl req -new -key /etc/nginx/tls/status.key -subj /CN=status.lab.internal -out /opt/lab-ca/status.csr
sudo openssl ca -batch -config /opt/lab-ca/ca.conf -in /opt/lab-ca/status.csr -out /etc/nginx/tls/status.crt -days 30
sudo nginx -t
sudo systemctl reload nginx
```

```bash
sudo curl --noproxy '*' --cacert /opt/lab-ca/ca.crt \
  --resolve status.lab.internal:8443:127.0.0.1 https://status.lab.internal:8443/
sudo openssl x509 -in /etc/nginx/tls/status.crt -noout -dates -ext subjectAltName
```

Repeat the request using `/opt/lab-ca/unrelated.crt` and confirm curl reports a certificate trust error. CI also reinstalls the expired certificate, checks that grading fails, restores the solution and reboots the VM.
