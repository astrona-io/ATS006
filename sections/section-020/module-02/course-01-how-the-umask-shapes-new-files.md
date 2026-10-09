# How The umask Shapes New Files

Astronaut, every new crate that lands in your cargo hold gets a lock setting before anyone touches it. That default setting is the `umask` (short for "user file-creation mask"). This part shows where the starting permissions come from, how the mask removes bits from them, and how to predict the result before you create anything.

Think of the `umask` as a stencil laid over a fresh lock badge. The badge starts with the most permissions it could have, and the stencil blocks some of them out. The stencil can only block. It never adds a bit of its own. That one fact explains almost every surprising thing about the `umask`.

## Two starting points: files and directories

Before the mask is applied, the program that creates something asks the kernel for a starting mode. Which starting mode it asks for depends on what is being created. This section shows both.

### The two bases

- A new **regular file** starts from `666`: read and write for everyone, but never execute. A program that creates a plain data file, such as `touch` or a text editor, does not assume the file should be runnable.
- A new **directory** starts from `777`: read, write and execute for everyone. On a directory, execute means "may enter", which you normally want for a new directory.

### Who applies the mask

Each process carries its own `umask`. The shell's `umask` command sets it for the shell, and every program the shell starts inherits a copy. When a program creates a file or directory, the kernel, the ship's core, removes the mask's bits from the requested mode. So `touch` asks for `666`, and the kernel stores `666` with the mask's bits taken out.

## Removing bits: the mask at work

A mask of `022` means "remove write from the group, remove write from others". Nothing more, nothing less:

```
File:      666 - 022 = 644   (rw-r--r--)
Directory: 777 - 022 = 755   (rwxr-xr-x)
```

This is why a new file usually shows up as `644` and a new directory as `755`: `022` is a very common default mask.

### Subtraction is a shortcut

The "minus" above is a handy shortcut, but what really happens is that each bit in the mask is switched off. When every bit in the mask is also in the base, subtracting digit by digit gives the right answer. When the mask switches off a bit the base never had, the bit simply stays off.

For example, with a mask digit of `7` on a file digit of `6`, the result is `0`, not a negative number: `6` is read and write, `7` is read, write and execute, and switching off all three leaves nothing. So think "which bits does the mask switch off?" rather than "what is the difference?".

## Why a new file is never executable from the umask alone

A mask of `000` switches off nothing at all. It still never produces an executable new file. This section explains why.

### Follow the base

The file's base is `666`, and `666` never included an execute bit for anyone. The mask can only remove bits that were in the base. It has no way to add a bit the base never offered.

If a new file must be executable straight away, the execute bit has to come from somewhere else: an explicit `chmod +x` afterwards, or a tool like `install -m` that sets an exact mode when it creates the file.

## Reading and predicting

Two commands show you the current mask, in two different formats. This section shows both, then shows how to predict and check a result.

### Two ways to read the mask

```bash
umask
umask -S
```

Plain `umask` prints the mask itself in octal: the bits that get switched off. `umask -S` prints the resulting permissions in symbolic form instead, for example `u=rwx,g=rx,o=rx`. Many people find `umask -S` easier, because it skips the arithmetic and shows what you actually get for a directory.

### Predicting a result

Predicting is simple once you have the mask. Given `umask 027`:

```
File:      666 - 027 = 640   (rw-r-----)
Directory: 777 - 027 = 750   (rwxr-x---)
```

For the file, the last digit is the "switch off" case: the mask's `7` removes the `6` completely, leaving `0`.

### Try it: check a prediction

Always check a prediction against reality before you trust it. Run the test inside parentheses: `bash` runs the commands in a subshell, a short-lived copy of your shell, so the `umask 027` there does not change your own shell:

```bash
rm -rf /tmp/mask-test-file /tmp/mask-test-dir
( umask 027; touch /tmp/mask-test-file; mkdir /tmp/mask-test-dir )
stat -c '%a %n' /tmp/mask-test-file /tmp/mask-test-dir
```

```text
640 /tmp/mask-test-file
750 /tmp/mask-test-dir
```

The file got `640` and the directory `750`, exactly as predicted. Now try it with your own current mask, which is whatever `umask` printed above:

```bash
touch /tmp/predict-test-file
mkdir /tmp/predict-test-dir
stat -c '%a %n' /tmp/predict-test-file /tmp/predict-test-dir
```

Compare the two numbers with what you worked out by hand from your mask.

> [!TIP]
> In an exam, check a `umask` change with a throwaway file and directory and `stat -c '%a'`. It takes ten seconds and proves the result instead of the arithmetic.

## Common pitfalls

> [!WARNING]
> - **Expecting the `umask` to add bits.** It only switches bits off. A new file never gets execute from the mask.
> - **Using the file base for a directory.** Files start from `666`, directories from `777`. The same mask gives different results.
> - **Subtracting digit by digit blindly.** A mask digit of `7` on a file digit of `6` leaves `0`, not a negative number.
> - **Mixing up `umask` and `umask -S`.** `umask` prints the bits removed. `umask -S` prints the permissions you get.
> - **Testing with a file that already exists.** `touch` on an existing file does not change its mode. Remove the test file first.
