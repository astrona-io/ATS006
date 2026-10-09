# Load, Start and Enable a Service

Astronaut, a duty card lying on the desk does nothing. The duty officer (systemd) must read it, check it, put the station on the launch checklist and staff it. This part takes a unit file from disk to a running, enabled service, and then proves that the restart policy really works.

The commands below need the `backup-agent.service` unit file saved at `/etc/systemd/system/backup-agent.service`, the script `/opt/backup/nightly-backup.sh` (executable) and the system user `backupsvc`.

## The step that is easy to forget: `daemon-reload`

systemd keeps unit definitions cached in memory after it first reads them from disk. That cache is the reason for one command you must run every time you touch a unit file.

### Why a new unit works and an edited one does not

Write a brand-new unit file and `systemctl start` it at once, and it works. systemd had not loaded anything for that unit name before, so there is nothing old to get in the way.

Now edit that same unit file later: change `Restart=`, add a line, fix a typo. `systemctl restart` will quietly keep using the *old*, cached definition and ignore your edit, until you run:

```sh
sudo systemctl daemon-reload
```

`daemon-reload` makes systemd read every unit file from disk into its memory again. It is like telling the duty officer to read all the duty cards again.

> [!TIP]
> Make `daemon-reload` a habit: any time you touch a unit file, run it straight after, before you start or restart anything. Skipping it is the most common cause of "I changed the file but nothing happened".

### Check the unit before you start it

Before you start a service, run a cheap syntax check:

```sh
sudo systemd-analyze verify backup-agent.service
```

`systemd-analyze verify` reads the unit and reports syntax errors or unknown lines **without** starting the service. It catches a misspelled line name before you waste time chasing a "failure" that was only a typo. If it prints nothing about your unit, it found no problem.

## Start it now and at every boot

With the unit loaded and checked, flip both switches: staff the station now, and put it on the launch checklist for the next boot.

### Reload, enable and start in one go

Load the new file and start the service, now and at every boot:

```sh
sudo systemctl daemon-reload
sudo systemctl enable --now backup-agent.service
```

`daemon-reload` makes systemd read the new unit file. `enable --now` creates the symbolic link in `multi-user.target.wants/` (so it starts at every boot) and starts the service right away.

### Confirm both switches

Check the two switches separately:

```sh
systemctl is-active backup-agent.service
systemctl is-enabled backup-agent.service
```

The first command should print `active` and the second `enabled`. If you only see one of them, you flipped only one switch.

To see the values systemd really loaded, ask it for the properties:

```sh
systemctl show backup-agent.service -p Restart -p User -p After
```

Look for `Restart=on-failure`, `User=backupsvc`, and `network-online.target` somewhere in the `After=` line. This is what systemd itself is using, not what you think the file says.

## Prove the restart policy works

A restart policy you never tested is only a hope. Kill the running process yourself and watch systemd bring it back.

### Kill the process and watch it return

Stop the script's process by force, the way a crash would:

```sh
sudo pkill -f nightly-backup.sh
```

Wait a few seconds (the unit waits `RestartSec=5` before restarting), then look at the status:

```sh
systemctl status backup-agent.service
```

The service should be `active (running)` again, with a new process ID. Being killed by a signal counts as a failure, so `Restart=on-failure` brought the crew member back. A clean `sudo systemctl stop backup-agent.service`, on the other hand, would leave it stopped.

## Common pitfalls

> [!WARNING]
> - **Editing a unit file and skipping `daemon-reload`.** systemd keeps using the old, cached version.
> - **Running only `start` or only `enable`.** One makes it run now, the other makes it survive a reboot. A task that asks for both needs `enable --now`.
> - **Trusting the file instead of systemd.** Check with `systemctl show` what systemd actually loaded.
> - **Never testing the restart policy.** Kill the process once and watch it come back.
> - **Testing the restart with `systemctl stop`.** A deliberate stop never triggers `Restart=on-failure`.

## Your mission: systemd Unit Creation Lab

You can now write a unit file, load it, and start it now and at every boot. The mission asks you to wrap an existing metrics script as `metrics-collector.service`, running as its own system user, restarting on failure, ordered after the real network, and enabled.

Start the mission:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS006.git -c labs/lab-071
```

Open a terminal on the lab machine:

```sh
astrona ssh ats-006-lab-071
```

Read the task in the [question](../../../labs/lab-071/docs/question.md) and solve it on your own first. When you think you are done, send it for grading:

```sh
astrona submit -c labs/lab-071
```

When the mission is done, remove it:

```sh
astrona destroy ats-006-lab-071
```
