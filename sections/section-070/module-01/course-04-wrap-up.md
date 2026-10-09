# Wrap-Up: Mission Debrief

Well flown, astronaut. You have turned a loose script into a station the duty officer watches, and you know where to look when it will not start. Look back at what you learned, check yourself, and land cleanly.

## What you learned

This module was about the duty card for one station, the unit file, and the commands that load it, start it and read its log.

**From [Anatomy of a Unit File](./course-01-anatomy-of-a-unit-file.md):**

- A unit file has three sections: `[Unit]` (description and ordering), `[Service]` (how the process runs) and `[Install]` (what `enable` does).
- `After=` only orders units. Pair it with `Wants=` so the target is really pulled in.
- `network-online.target` means an interface really works; `network.target` does not.
- `User=` and `Group=` run the script as a dedicated system user instead of root.
- `Restart=on-failure` restarts after a crash but not after a deliberate stop; `RestartSec=` stops a tight restart loop.
- `start` runs it now, `enable` makes it survive a reboot, `enable --now` does both.

**From [Load, Start and Enable a Service](./course-02-load-start-and-enable-a-service.md):**

- systemd caches unit files. Run `sudo systemctl daemon-reload` after every change.
- `systemd-analyze verify` checks a unit without starting it.
- `systemctl is-active`, `systemctl is-enabled` and `systemctl show` prove what systemd really loaded.
- Killing the process and watching it come back proves the restart policy.

**From [Diagnose a Unit That Will Not Start](./course-03-diagnose-a-unit-that-will-not-start.md):**

- Read `journalctl -u <unit> -b` before you touch the unit file.
- In `code=exited, status=1/FAILURE`, `status` is the application's exit code and `code` says how it ended.
- `status=203/EXEC` means systemd could not run the command: check the execute bit and the `#!` line, and run the command yourself as the service user.
- "Start request repeated too quickly" means the process crashes at once; the fix is in the application.

## Your missions

You proved the skill in a graded mission, right after the part that taught it:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [systemd Unit Creation Lab](../../../labs/lab-071/docs/question.md) | Load, Start and Enable a Service | wrapped a script as a service with its own user, a restart policy, real network ordering, running and enabled |

If you skipped it, go back to it now. The exam asks for exactly this skill.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. Your unit has <code>After=network-online.target</code> but no <code>Wants=</code>. What can go wrong?</summary>

`After=` only sets the order. If nothing else pulls `network-online.target` in, it is never started, and your service can start before the network is ready. Add `Wants=network-online.target`.
</details>

<details>
<summary>2. What is the difference between <code>network.target</code> and <code>network-online.target</code>?</summary>

`network.target` is reached early and only means the network stack is set up. `network-online.target` is reached once a network management service reports at least one interface as really usable.
</details>

<details>
<summary>3. You run <code>systemctl stop</code> on a unit with <code>Restart=on-failure</code>. Does systemd restart it?</summary>

No. A clean, deliberate stop is not a failure. `Restart=always` would restart it.
</details>

<details>
<summary>4. A task says the service must run now and come back after a reboot. Which command do you use?</summary>

`sudo systemctl enable --now <unit>`, or `enable` and `start` one after the other. `start` alone does not survive a reboot, and `enable` alone does not start it now.
</details>

<details>
<summary>5. You changed <code>Restart=</code> in a unit file and restarted the service, but nothing changed. Why?</summary>

systemd still uses its cached copy of the unit. Run `sudo systemctl daemon-reload` first, then restart.
</details>

<details>
<summary>6. <code>systemctl status</code> shows <code>status=203/EXEC</code>. What do you check?</summary>

That systemd could run the `ExecStart=` command at all: the script's execute permission and the interpreter in its `#!` line. Run the command yourself as the service user, for example `sudo -u backupsvc /opt/backup/nightly-backup.sh`, to see a clearer error.
</details>

<details>
<summary>7. Why read <code>journalctl -u &lt;unit&gt; -b</code> before editing the unit file?</summary>

The journal holds the error the application printed, which `systemctl status` often cuts off. The fault is usually in the application, not the unit file.
</details>

## Clean up

Each mission runs in its own training ship. When you are done with this module, remove any mission that is still running.

First, see what is still running:

```sh
astrona list
```

Remove the mission. The command takes its **name**, not its folder path:

```sh
astrona destroy ats-006-lab-071
```

Then check that everything is gone:

```sh
astrona list
```

```text
No astrona labs running.
```

If you practised on a test machine of your own, you can remove the example with `sudo systemctl disable --now backup-agent.service`, then delete `/etc/systemd/system/backup-agent.service` and run `sudo systemctl daemon-reload`.

> *A duty card for every station, a reload after every change, and the journal before the editor.*
