# umask — Why New Files Aren't 777 By Default

Create a brand-new file with `touch notes.txt` and check its permissions — you'll almost always see `644`, never `666`, and certainly never `777`, even though you never ran `chmod`. Create a brand-new directory with `mkdir project/` and it typically comes out `755`. Nobody set those numbers explicitly. They fell out of a calculation that happens automatically, every single time something new is created, driven by a value called the `umask`.

Think of `umask` as a stencil laid over a fresh sheet of paper before any writing happens. The paper itself starts with a maximum possible permission print already assumed — one pattern for files, a different pattern for directories — and the stencil blocks out certain areas so they never get inked in. The stencil can only *block*, never add extra ink of its own. That single fact — subtraction only, never addition — explains almost every surprising or confusing thing about how `umask` behaves.

## Two Starting Points: Files vs Directories

Before `umask` ever enters the picture, the kernel assumes a *maximum* starting permission set depending on what's being created:

- A new **regular file** starts from `666` — read and write for everyone, but *never* execute for anyone, because nothing creating a plain data file presumes it should be runnable.
- A new **directory** starts from `777` — read, write, and execute for everyone, because execute on a directory means "can enter it," which is normally exactly what you want for a freshly made directory.

`umask` is then subtracted from whichever base applies. A mask of `022` means "remove write from group, remove write from other" — nothing more, nothing less:

```
File:      666 - 022 = 644   (rw-r--r--)
Directory: 777 - 022 = 755   (rwxr-xr-x)
```

This is why a fresh file typically shows up `644` and a fresh directory `755` on most default installations — `022` is a very common out-of-the-box mask.

## Why Files Never Get an Execute Bit From umask Alone

Here's the detail that trips people up until it clicks: a mask of `000` (subtracting nothing at all) still never produces an executable new file. Walk through the math and it becomes obvious why — the file's starting base is `666`, and `666` never included an execute bit for anyone in the first place. `umask` can only take away permissions that were present in the base to begin with; it has no mechanism to grant a bit the base never offered. If you need a freshly created file to be executable immediately, that has to come from somewhere else entirely — an explicit `chmod +x` afterward, or a tool like `install -m` that sets an exact mode at creation time, bypassing the umask calculation completely.

## Reading and Predicting

Two commands show you the current mask, in two different formats:

```bash
umask
umask -S
```

Plain `umask` prints the octal *mask itself* — the thing you subtract. `umask -S` prints the symbolic *resulting* permission set instead — what you'll actually get, which many people find easier to reason about directly since it skips the subtraction step.

Predicting is just arithmetic once you have the mask. Given `umask 027`:

```
File:      666 - 027 = 640   (rw-r-----)
Directory: 777 - 027 = 750   (rwxr-x---)
```

Always verify a prediction against reality before trusting it in a live task:

```bash
touch /tmp/predict-test-file
mkdir /tmp/predict-test-dir
stat -c '%a %n' /tmp/predict-test-file /tmp/predict-test-dir
```

## Setting umask for the Current Shell vs Persistently

Typing `umask 027` directly at a prompt only changes the mask for that one interactive shell session — it evaporates the moment the session ends. To make a mask stick for every future login, it has to live inside a shell startup file that gets read at login time, most commonly `~/.bash_profile` or `~/.profile` for a login shell:

```bash
echo 'umask 027' >> ~/.bash_profile
source ~/.bash_profile
```

The `source` step (or simply starting a fresh login session) is what actually applies the change to the current shell — appending the line alone doesn't retroactively change a shell that's already running. For a system-wide default that applies to every user who doesn't set their own override, the relevant setting lives in `/etc/login.defs`, under the `UMASK` directive.

One habit worth building early: `umask` takes the *mask*, never the *desired result*. If a requirement says "new files should come out `640`," the number to type into `umask` is `027` (the value that produces `640` when subtracted from `666`), not `640` itself. Confusing the two is one of the single most common umask mistakes.

## Services, Daemons, and Cron Jobs Have Their Own umask

A per-user shell umask only governs processes that actually inherit that login shell's environment. A `systemd`-managed service, a cron job, or a daemon launched from an init script typically does *not* run inside anyone's interactive shell — it inherits whatever umask the process that started it was using, which is very often unrelated to any individual human user's `~/.bash_profile`. If a service creates files with permissions that look wrong and its own configuration has no explicit permission setting, the umask its *process* is running under — not any user's login shell — is usually the first thing worth checking. `systemd` units even have an explicit `UMask=` directive for exactly this reason, since a service's ideal umask frequently differs from a human's.

## umask and Group Collaboration Are Different Problems

It's tempting to reach for umask alone to solve "everyone on the team should be able to work with everyone else's files," but umask only ever governs the *permission bits* at the moment of creation — it says nothing about which *group* a new file ends up owned by. A permissive umask combined with files still landing in each contributor's own personal primary group doesn't actually produce shared access; the group-ownership half of that problem is what the setgid bit on a directory solves instead (covered in the previous module). Real team directories typically need both working together: a umask loose enough that group members can read/write each other's files, and setgid so those files consistently land in the *team's* group rather than scattering across everyone's individual accounts.

## Self-Check and Verification

To prove you can predict, verify, and persist a umask correctly:

1. Run `umask` and `umask -S` and write down both the current mask and its symbolic resulting permission set.
2. By hand, compute what a brand-new file and a brand-new directory should come out as under that mask, then create one of each and confirm your prediction with `stat -c '%a'`.
3. Pick a target result — say, files at `600` and directories at `700` — and work backward to the mask that produces it. Set that mask in the current shell only (no startup file yet) and verify.
4. Persist that same mask in a login shell startup file, start a fresh login session (or `source` the file), and confirm the mask survives and still produces the correct results.
5. Explain, without looking anything up, why a mask of `000` can never make a brand-new file executable — tie the answer back to the file's `666` starting base.
