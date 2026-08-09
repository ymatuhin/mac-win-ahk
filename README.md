# mac-win-shortcuts

A QMK keymap for the **Keychron Q6 HE (ANSI, knob)** that makes the key next to the space bar behave like macOS `Cmd` on Windows.

Intended for people using mac muscle memory on Windows: `Cmd+C`, `Cmd+Tab`, `Cmd+arrows` and friends work the way they do on macOS, while native `Ctrl` shortcuts stay unchanged.

> **Why the firmware and not a Windows tool?** Earlier versions of this repo did the same remapping on the PC side — first an AutoHotkey v2 script, then a [kanata](https://github.com/jtroo/kanata) config (both in git history). Anything running on Windows sits behind hooks or a kernel driver: games and anti-cheat ignore hooks, and the Interception driver has a lifetime limit of 10 input devices that a monitor USB hub burns through until input dies. A keymap lives in the keyboard itself, so the remap works in games, in the BIOS, on the lock screen and in UAC windows, survives a Windows reinstall, and needs no background process at all.

## Two ways to set this up

- **[Keychron Launcher](LAUNCHER.md)** — no flashing at all. Launcher rewrites only the keymap stored in the keyboard's EEPROM: the firmware, the bootloader and the Mac layers stay factory, and one reset button undoes everything. Costs the macOS-style `Cmd+Tab` switcher and moves two Shift-conditional shortcuts to other keys.
- **[Compiled keymap](#build-and-flash)** — full parity with the old kanata config, including the held `Cmd+Tab` switcher. Requires flashing, which replaces the whole firmware image.

If `Cmd+Tab` matters to you, take the compiled route — that behaviour is the one thing Launcher cannot reproduce. Everything below describes it.

## Files

- [keymap/keymap.c](keymap/keymap.c) — the keymap, single source of truth
- [keymap/config.h](keymap/config.h) / [keymap/rules.mk](keymap/rules.mk) — five dynamic layers, VIA enabled
- [build.sh](build.sh) — clones Keychron's QMK fork, copies the keymap in, compiles (and flashes)
- [check-keymap.py](check-keymap.py) — verifies every layer has the same shape
- [LAUNCHER.md](LAUNCHER.md) — the same shortcuts set up in Keychron Launcher, without flashing
- [uninstall.ps1](uninstall.ps1) — removes the old kanata install from Windows (see below)

## Requirements

- Keychron Q6 HE, ANSI with knob (`keychron/q6_he/ansi_encoder`). Other variants need the `KEYBOARD` line in [build.sh](build.sh) changed to `iso_encoder` or `jis_encoder` and the `LAYOUT_ansi_108` macro swapped in the keymap.
- A build machine with the QMK CLI, an ARM compiler and `dfu-util` — see [Install the toolchain](#1-install-the-toolchain). It does not have to be the machine the keyboard is used on; this keymap is built on macOS and used on Windows.
- The keyboard's Mac/Win slider set to **Win** — that is what selects layer 2 as the base layer.

## Build and flash

### 1. Install the toolchain

QMK's own tap (`brew install qmk/qmk/qmk`) is the documented route, but Homebrew 6 refuses third-party taps until you run `brew trust qmk/qmk`. These three steps avoid that and were what this keymap was actually built with:

```bash
python3 -m venv ~/.qmk-venv && ~/.qmk-venv/bin/pip install qmk
```

```bash
brew install dfu-util
```

Then Arm's toolchain — Homebrew's core `arm-none-eabi-gcc` is compiler-only, has no newlib, and fails on `#include <stdint.h>`:

```bash
mkdir -p ~/.local/opt && curl -sSL https://developer.arm.com/-/media/Files/downloads/gnu/14.3.rel1/binrel/arm-gnu-toolchain-14.3.rel1-darwin-arm64-arm-none-eabi.tar.xz | tar xJ -C ~/.local/opt
```

`build.sh` picks up both the venv and `~/.local/opt/arm-gnu-toolchain-*` on its own. There is no need to run `qmk setup` — this repo brings its own checkout.

### 2. Build

```bash
./build.sh
```

First run clones [Keychron's QMK fork](https://github.com/Keychron/qmk_firmware) (branch `2025q3`, the one with Hall Effect support) into `~/qmk_keychron`; set `QMK_DIR` to put it elsewhere. Every run re-copies `keymap/` into the fork, checks the layer shapes and compiles. The result is `keychron_q6_he_ansi_encoder_mac_win.bin` in the checkout root.

### 3. Back up what flashing resets

Flashing replaces the whole firmware image, and raising `DYNAMIC_KEYMAP_LAYER_COUNT` to 5 invalidates the EEPROM the old keymap lived in. Per-key Hall Effect actuation, rapid trigger, RGB, Bluetooth pairings and **any macros recorded in Launcher** come back at defaults. Export the current layout from [Keychron Launcher](https://launcher.keychron.com) first, and copy the macro bodies out of its macro tab by hand — the export file does not contain them.

### 4. Enter bootloader mode

Unplug the cable, hold `Esc`, plug the cable back in while still holding `Esc`, then release. The board enumerates as `STM32 BOOTLOADER` / a DFU device — `dfu-util -l` lists it as `0483:df11`. If that does not work, the reset button is on the PCB next to the space bar switch — hold it while connecting the cable.

Flashing is wired-only: the keyboard must be connected by cable, not over Bluetooth or the 2.4 GHz dongle.

### 5. Flash

```bash
./build.sh flash
```

Or open the `.bin` in [QMK Toolbox](https://github.com/qmk/qmk_toolbox) once it prints `DFU device connected` and press Flash. Do not unplug the cable while it writes.

A successful run ends with `Erase done` → `Download done` → `File downloaded successfully`. Two lines look alarming and are not:

- `dfuERROR ... Device's firmware is corrupt` before the write. This is the DFU state machine, not a verdict on the image — the STM32 bootloader reports it whenever it was entered without a normal run-time exit. The `Clearing status` line right after resets it to `dfuIDLE` and the write proceeds from a clean state.
- `Transitioning to dfuMANIFEST state` at the end. That is the leave request; `dfu-util` often falls silent or reports an exit error there, after the image is already written.

Then replug the cable if the keyboard does not come back on its own, and put the Mac/Win slider on **Win**.

### If something goes wrong

The bootloader lives in its own flash region and a keymap cannot damage it, so the recovery is always the same: re-enter bootloader mode with the `Esc` trick and flash something else — this keymap again, or Keychron's stock firmware from the [firmware page](https://www.keychron.com/pages/firmware).

If the keyboard works but the `Cmd` layer does nothing, the old keymap is still in EEPROM: open Launcher and use its keyboard reset, which reloads the keymap from the firmware.

## Layers

Keychron's stock four layers are kept as they are, so the Mac side of the keyboard and the Fn layer keep working:

| # | Layer | Role |
|---|---|---|
| 0 | `MAC_BASE` | stock, used when the slider is on Mac |
| 1 | `MAC_FN` | stock |
| 2 | `WIN_BASE` | Windows base — the bottom row and `Caps Lock` differ from stock |
| 3 | `WIN_FN` | stock Fn layer: Bluetooth, 2.4 GHz, RGB, media |
| 4 | `CMD` | the `Cmd` layer, held by the key next to the space bar |

The `Cmd` layer has to sit **above** `WIN_BASE`: QMK resolves the highest active layer first, so a layer below the base layer would never be reached. That is also why this needs a compiled keymap rather than Keychron Launcher — Launcher only exposes the four stock layers.

## Included shortcuts

Hold the key next to the space bar as `Cmd` — the same position `Cmd` has on a Mac. `Shift` is not remapped, so every `Cmd+Shift+<key>` variant works by holding physical Shift.

### Editing

- `Cmd+C` / `Cmd+V` / `Cmd+X` / `Cmd+A` → `Ctrl+…`
- `Cmd+Z` / `Cmd+Shift+Z` → `Ctrl+Z` / `Ctrl+Shift+Z`
- `Cmd+F` / `Cmd+G` → `Ctrl+F` / `Ctrl+G`
- `Cmd+B` / `Cmd+I` / `Cmd+U` / `Cmd+K` → `Ctrl+…`
- `Cmd+,` → `Ctrl+,`
- `Cmd+Enter` → `Ctrl+Enter`
- `Cmd+Backspace` → `Delete`
- `Cmd+Shift+4` → `Win+Shift+S` (screenshot selection)

### Files and windows

- `Cmd+N` / `Cmd+Shift+N` / `Cmd+S` / `Cmd+Shift+S` / `Cmd+O` / `Cmd+P` → `Ctrl+…`
- `Cmd+Q` → `Alt+F4`
- `Cmd+M` → `Win+Down` (minimize; a maximized window is restored first, press twice)

### Browser-style

- `Cmd+T` / `Cmd+Shift+T` / `Cmd+W` / `Cmd+Shift+W` / `Cmd+R` / `Cmd+L` / `Cmd+D` → `Ctrl+…`
- `Cmd+1` … `Cmd+9`, `Cmd+0` → `Ctrl+1` … `Ctrl+9`, `Ctrl+0` (switch tabs / reset zoom)

### Navigation

- `Cmd+Left` / `Cmd+Right` → `Home` / `End`
- `Cmd+Up` / `Cmd+Down` → `Ctrl+Home` / `Ctrl+End`
- `Cmd+Shift+<arrow>` → same with selection
- `Cmd+Tab` → app switcher: the switcher stays open while `Cmd` is held, like on macOS; `Cmd+Shift+Tab` cycles backwards

### System

- `Cmd+Space` → `Win+S` (Windows Search, the Spotlight analog)
- `Caps Lock` → `Win+Space` (input language switch)
- `Shift+Caps Lock` → real `Caps Lock`

## Behavior notes

- **Tapping the `Cmd` key alone does nothing** — it is a pure layer key, so the Start menu never opens. The right-hand `Win` key (`RGUI`, right of the space bar) covers native `Win+…` shortcuts.
- The Windows bottom row is `Ctrl` `Alt` `Cmd` — space — `Win` `Alt` `Fn` `Ctrl`, carried over from the owner's own Launcher layout rather than Keychron's stock `Ctrl` `Win` `Alt`.
- Four keys that used to hold Launcher macros are back at their stock values — Launchpad, `Home` and `End` on the Mac layer, `F16` on the Windows top row. Launcher's export does not include macro bodies, so they could not be carried over. Write them into [keymap/keymap.c](keymap/keymap.c) as ordinary key sequences if you want them back.
- `Cmd+<key>` combos not listed above fall through to the base layer and type the plain key.
- The `Cmd+Tab` switcher works by holding `Alt` between `Tab` presses and releasing it when the `Cmd` layer is released. While the switcher is open, other `Cmd` combos also carry `Alt` — same as the kanata version behaved.
- Everything above is Windows-only by design. Flip the slider to Mac and you get Keychron's stock Mac layout back, untouched.

## Editing the keymap

Change [keymap/keymap.c](keymap/keymap.c), then:

```bash
python3 check-keymap.py
```

Every layer must list exactly the same number of entries in the same order — QMK compiles a short layer without complaint and silently shifts every key after the mistake. Then rebuild and flash with `./build.sh flash`.

Keychron Launcher can still be used for Hall Effect settings (actuation point, rapid trigger) and RGB. Remapping keys there will overwrite this keymap in EEPROM; reflashing restores it.

## Removing the old kanata install

If this machine still has the kanata setup from earlier versions of this repo, run in an **administrator** PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File uninstall.ps1
```

It stops kanata, removes the `kanata` logon task and deletes `%LOCALAPPDATA%\kanata`. If the [Interception](https://github.com/oblitum/Interception/releases) driver is also still installed, add `-RemoveDriver` and reboot. To confirm it is gone afterwards, `sc.exe query keyboard` should report error 1060 and the keyboard/mouse class `UpperFilters` should list only `kbdclass` / `mouclass`.
