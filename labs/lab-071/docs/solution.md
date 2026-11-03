# Solution Walkthrough

You wrap `/opt/metrics/collector.sh` as a service that systemd watches, restarts on failure and starts at every boot. The grader reads the live state from systemd itself, so each step ends with something you can check.

## Step 1: Create the dedicated service user

Create a system account with no home directory and no login shell:

```sh
sudo useradd --system --no-create-home --shell /usr/sbin/nologin metrics
```

`--system` gives the account a system user ID (below 1000). A dedicated, unprivileged account means the service never needs root.

Check it:

```sh
id metrics
getent passwd metrics
```

The user ID should be below 1000, and the last field of the `getent` line should be `/usr/sbin/nologin`.

## Step 2: Give the log directory to that user

The bootstrap left `/var/log/metrics-collector` owned by root. The script runs as `metrics`, so that account must be able to write there:

```sh
sudo chown metrics:metrics /var/log/metrics-collector
```

Check it:

```sh
stat -c '%U:%G' /var/log/metrics-collector
```

```text
metrics:metrics
```

## Step 3: Write the unit file

Save this as `/etc/systemd/system/metrics-collector.service` (for example with `sudo nano /etc/systemd/system/metrics-collector.service`):

```ini
[Unit]
Description=Metrics Collector Service
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=metrics
Group=metrics
ExecStart=/opt/metrics/collector.sh
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

`After=` and `Wants=network-online.target` together order the unit after real network availability and actually pull that target in. `After=` alone would only set the order; it would not make sure the target starts at all. `Restart=on-failure` restarts the script after a crash, but not after a deliberate stop. `WantedBy=multi-user.target` is what `enable` uses to start it at boot.

## Step 4: Reload systemd and start the service

Apply it:

```sh
sudo systemctl daemon-reload
sudo systemctl enable --now metrics-collector.service
```

`daemon-reload` makes systemd read the new unit file; run it any time a unit file is created or changed. `enable --now` covers both "running now" and "survives a reboot" in one command.

## Step 5: Check the result

Then check the result:

```sh
systemctl is-active metrics-collector.service
systemctl is-enabled metrics-collector.service
systemctl show metrics-collector.service -p Restart -p User -p After -p Wants
```

The first command should print `active` and the second `enabled`. In the `systemctl show` output, look for `Restart=on-failure`, `User=metrics`, and `network-online.target` in both the `After=` and the `Wants=` lines. These are the values the grader reads.

If the unit does not start, do not edit the file yet. Run `journalctl -u metrics-collector.service -b` first: `systemctl status` cuts the log short, and the full journal almost always shows the real error, such as a permission problem.

## Step 6: Submit

When every check looks right, send the lab for grading from your own machine:

```sh
astrona submit -c labs/lab-071
```
