# Wrapping a Script as a systemd Service

Astronaut, every ship has at least one job that somebody started by hand and then forgot. It is a useful script that loops forever. Someone once launched it with `nohup ... &` and walked away. It works, right up until the ship restarts, or the process dies quietly at 3 in the morning and nobody notices for three days, because nothing was watching it.

**systemd** closes exactly that gap. Picture it as the ship's duty officer: it starts every station, watches it, and restarts it when it falls over. A **service** is a station that must always be staffed. The **unit file** is the duty card for one station: it says exactly how that station runs. In this module you write that duty card for a plain script, load it, and learn to read the ship's log when the station will not start.

## Learning objectives

After this module you can:

- Write a unit file with `[Unit]`, `[Service]` and `[Install]` sections that wraps a script.
- Explain why `After=` alone does not start a network target, and pair it with `Wants=`.
- Choose between `network.target` and `network-online.target`.
- Run a service as a dedicated, unprivileged system user with `User=` and `Group=`.
- Pick a `Restart=` value and explain what `RestartSec=` protects against.
- Explain the difference between `systemctl start`, `systemctl enable` and `systemctl enable --now`.
- Run `systemctl daemon-reload` after every unit file change, and check a unit with `systemd-analyze verify`.
- Diagnose a unit that will not start with `journalctl -u <unit> -b`, and recognise `status=203/EXEC` and a start rate limit.

## Before you start

Every mission starts with a pre-flight check, astronaut. Make sure you have the knowledge this module expects and a machine to practise on.

### What you should already know

- **How to run a command with `sudo`.** Writing to `/etc/systemd/system/` and creating users needs the captain's authority, so most commands here start with `sudo`.
- **What a process is.** A process is one running program, like a crew member doing one job. When it ends, it hands back an exit code: `0` means success, anything else means something went wrong.
- **How to edit a file in the terminal**, for example with `nano` or `vim`.

### What you need

A playground: one Ubuntu 24.04 training ship in the simulator, with the `bash` shell. Everything the examples use is already on it, so you do not need to install anything.

### What is in your playground

Your playground is a virtual machine on your computer. It already has:

- The script `/usr/local/bin/collector.sh`. It writes one line with the time to `/var/log/collector.log` every five seconds, until stopped.
- No unit file for it yet. You write that.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->

Open a terminal on it:

```sh
astrona ssh service-unit-playground
```

Every command block in the parts runs **inside that virtual machine**, as the user `candidate`, who can use `sudo`.

## How this module is laid out

1. [Anatomy of a Unit File](./course-01-anatomy-of-a-unit-file.md): the three sections of a duty card, and what each line does.
2. [Load, Start and Enable a Service](./course-02-load-start-and-enable-a-service.md): `daemon-reload`, `systemd-analyze verify`, `enable --now`, and proof that the restart policy works.
   - Mission: [systemd Unit Creation Lab](../../../labs/lab-071/docs/question.md)
3. [Diagnose a Unit That Will Not Start](./course-03-diagnose-a-unit-that-will-not-start.md): reading the journal, and two failures to recognise on sight.
4. [Wrap-Up: Mission Debrief](./course-04-wrap-up.md)

## Why this matters

Turning a loose script into a supervised service is one of the most common jobs a Linux administrator does, and the exam asks for it directly. A unit file with the wrong `Restart=` value, or an `After=` line that does not really pull in the network, looks fine at a glance. It fails the first time the network is slow at boot. Knowing what each line does is what keeps your stations staffed.

<!-- curriculum-practice -->
## Practice and assessment

- [systemd Unit Creation Lab](../../../labs/lab-071/docs/question.md): Create a non-root system user and give it the log directory; Write a unit file that runs a script as that user and restarts it on failure; Enable and start the service so it runs now and after a reboot.
- [Service Configuration Capstone Lab](../../../labs/lab-070/docs/question.md): Wrap a script as a systemd service that runs as its own non-root user; Change the restart delay with a drop-in override, not by editing the unit file; Issue a key and a self-signed certificate with a SAN and prove they match.
