# Wrap-Up: Mission Debrief

Well flown, astronaut. You can now change a packaged station's behaviour with a sticky note on its duty card, and leave the vendor's card untouched. Look back at what you learned, check yourself, and land cleanly.

## What you learned

This module was about the drop-in override: where it lives, how systemd merges it, and how to apply, prove and remove it.

**From [Write a Drop-In Override](./course-01-write-a-drop-in-override.md):**

- Never edit a vendor unit under `/usr/lib/systemd/system/`. The package manager owns it and an upgrade wipes your change.
- `sudo systemctl edit <unit>` writes a drop-in, usually `/etc/systemd/system/<name>.service.d/override.conf`.
- `systemctl edit --full` makes a complete local copy that replaces the vendor unit; use it only for big rewrites.
- For single-value lines such as `Restart=` and `RestartSec=`, the last value wins.
- `Environment=` lines add up.
- `ExecStart=` appends to a list. Write an empty `ExecStart=` first to clear it, then the new command.

**From [Apply, Prove and Revert an Override](./course-02-apply-prove-and-revert-an-override.md):**

- `sudo systemctl daemon-reload` then `sudo systemctl restart <unit>` makes the override take effect. `reload` is not enough.
- `systemctl cat <unit>` shows the vendor fragment and each drop-in, in load order.
- `systemctl show <unit> -p Restart -p RestartUSec -p Environment` shows the values in force right now.
- `sudo systemctl revert <unit>` removes all local overrides; follow it with `daemon-reload` and `restart`.

## Your missions

You proved the skill in a graded mission, right after the part that taught it:

| Mission | After the part | What you proved |
| --- | --- | --- |
| [systemd Unit Override Lab](../../../labs/lab-072/docs/question.md) | Apply, Prove and Revert an Override | gave a packaged service a restart policy and an environment variable with a drop-in, vendor file unchanged |

If you skipped it, go back to it now. The exam asks for exactly this skill.

## Check yourself

Try to answer each question before you open the answer.

<details>
<summary>1. Why not add <code>Restart=on-failure</code> straight into <code>/usr/lib/systemd/system/cups.service</code>?</summary>

The package manager owns that file. The next upgrade either overwrites your edit or keeps the package's version, so your change does not survive.
</details>

<details>
<summary>2. Where does <code>sudo systemctl edit cups.service</code> save its file?</summary>

Usually at `/etc/systemd/system/cups.service.d/override.conf`: a separate fragment under `/etc`, not a copy of the vendor unit.
</details>

<details>
<summary>3. When would you use <code>systemctl edit --full</code>?</summary>

Only when you need to rewrite most of the unit. It saves a complete copy at `/etc/systemd/system/cups.service` that fully replaces the vendor version, and you then keep it in step by hand.
</details>

<details>
<summary>4. Your drop-in has only <code>ExecStart=/usr/sbin/cupsd -f -c /etc/cups/custom-cupsd.conf</code>. Why does the service not use it reliably?</summary>

`ExecStart=` appends to a list, so the vendor's command is still there. Put an empty `ExecStart=` line first to clear the list, then your new command.
</details>

<details>
<summary>5. Do you need to clear the vendor's <code>Environment=</code> before adding <code>Environment=APP_ENV=production</code>?</summary>

No. `Environment=` lines add up, so your variable simply joins the vendor's.
</details>

<details>
<summary>6. You saved a drop-in and ran <code>systemctl reload</code>. Why did <code>Restart=</code> not change?</summary>

`reload` only asks the application to reread its own configuration, and systemd still had the old unit cached. Run `sudo systemctl daemon-reload`, then `sudo systemctl restart`.
</details>

<details>
<summary>7. How do you prove the override is in force?</summary>

`systemctl cat <unit>` shows the vendor fragment followed by your override file. `systemctl show <unit> -p Restart -p RestartUSec -p Environment` shows the values systemd enforces right now.
</details>

<details>
<summary>8. How do you go back to the vendor's configuration?</summary>

`sudo systemctl revert <unit>`, then `sudo systemctl daemon-reload` and `sudo systemctl restart <unit>`.
</details>

## Clean up

Each mission runs in its own training ship. When you are done with this module, remove any mission that is still running.

First, see what is still running:

```sh
astrona list
```

Remove the mission. The command takes its **name**, not its folder path:

```sh
astrona destroy ats-006-lab-072
```

Then check that everything is gone:

```sh
astrona list
```

```text
No astrona labs running.
```

If you practised on a test machine of your own, run `sudo systemctl revert <unit>`, `sudo systemctl daemon-reload` and `sudo systemctl restart <unit>` to put the service back the way the package shipped it.

> *Leave the vendor's card alone, put your change on a sticky note, and let `systemctl cat` prove the result.*
