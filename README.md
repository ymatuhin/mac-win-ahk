# mac-win-shortcuts

[kanata](https://github.com/jtroo/kanata) config that makes the physical left `Win` key behave like macOS `Cmd` on Windows.

Intended for people using an Apple keyboard (or mac muscle memory) on Windows: `Cmd+C`, `Cmd+Tab`, `Cmd+arrows` and friends work the way they do on macOS, while native `Ctrl` shortcuts stay unchanged.

> **Why kanata and not AutoHotkey?** The previous version of this repo was an AutoHotkey v2 script (see git history). AHK's modifier juggling causes the `Win` key to get stuck and its layer handling is fragile; kanata models the whole keyboard as layers, so `Cmd` can never be left hanging. By default kanata runs driverless (the `winIOv2` variant, Windows hooks) — no kernel driver is installed. If you need remapping inside games, there is an optional Interception-driver mode, see below.

## Files

- [mac-win-shortcuts.kbd](mac-win-shortcuts.kbd) — the kanata config
- [install.ps1](install.ps1) — automated installer (kanata + autostart, no driver)
- [update.ps1](update.ps1) — applies config changes (validate → copy → restart kanata)
- [uninstall.ps1](uninstall.ps1) — removes everything the installer set up

## Requirements

- Windows 10/11
- [kanata](https://github.com/jtroo/kanata/releases) v1.11 or newer (the installer downloads it for you)

## Installation

1. Clone or [download](https://github.com/ymatuhin/mac-win-ahk/archive/refs/heads/main.zip) this repo on the Windows machine.
2. Open PowerShell **as administrator** in the repo folder and run:

   ```powershell
   powershell -ExecutionPolicy Bypass -File install.ps1
   ```

3. That's it — no reboot, no driver. kanata starts automatically after login — look for the tray icon.

The script downloads the latest kanata release, copies the config to `%LOCALAPPDATA%\kanata`, validates it, and registers a Task Scheduler logon task (elevated, no time limit). Re-running the script updates kanata and the config in place — also run it after every config change.

Options:

- `-Variant wintercept` — use the [Interception](https://github.com/oblitum/Interception/releases) kernel driver instead of Windows hooks. Remapping then works in games too, but the driver has real downsides (see [Interception driver mode](#interception-driver-mode)) — the default `winIOv2` needs no driver and no reboot.
- `-NoAutostart` — don't create the logon task.
- `-InstallDir C:\some\path` — install somewhere other than `%LOCALAPPDATA%\kanata`.

To uninstall:

```powershell
powershell -ExecutionPolicy Bypass -File uninstall.ps1                # default (driverless) install
powershell -ExecutionPolicy Bypass -File uninstall.ps1 -RemoveDriver  # also removes the Interception driver
```

## Interception driver mode

`-Variant wintercept` swaps Windows hooks for the Interception kernel driver: applications see the remapped keys as real hardware input, so remapping works in games and in elevated windows. It is not the default because of the trade-offs:

- The driver has a **lifetime limit of 10 registered input devices**. Every keyboard/mouse that enumerates burns a slot — and USB hubs (for example the hub built into a monitor) that re-enumerate devices on sleep/wake or on a display power cycle will chew through the limit until input dies. Fixing that means reinstalling the driver.
- It is an unsigned-by-Microsoft kernel driver, requires a reboot to activate, and some anti-cheat systems dislike it.

See [kanata platform known issues](https://github.com/jtroo/kanata/blob/main/docs/platform-known-issues.adoc) for details.

<details>
<summary>Manual installation (without the script)</summary>

1. Download `windows-binaries-x64.zip` from the [kanata releases page](https://github.com/jtroo/kanata/releases) and pick **one** executable:
   - `kanata_windows_gui_winIOv2_x64.exe` — **recommended**. No driver needed, works through Windows hooks. Fine for regular apps; games may ignore it.
   - `kanata_windows_gui_wintercept_x64.exe` — uses the [Interception](https://github.com/oblitum/Interception/releases) kernel driver: also works in games, but requires installing the driver (step 2) and has the [downsides listed above](#interception-driver-mode).

   The `gui` variants run as a tray icon; `tty` variants run in a terminal window.

2. **Only for the `wintercept` variant** — install the Interception driver:
   1. Download `Interception.zip` from [oblitum/Interception releases](https://github.com/oblitum/Interception/releases) and unpack it.
   2. In an **administrator** command prompt run `install-interception.exe /install` (it is in `command line installer\`).
   3. Reboot.
   4. Copy `library\x64\interception.dll` from the zip next to the kanata `.exe`.

3. Put the kanata `.exe` and `mac-win-shortcuts.kbd` in one folder, check the config with `--check`, then run:
   ```
   kanata_windows_gui_winIOv2_x64.exe --cfg mac-win-shortcuts.kbd
   ```

4. Autostart via Task Scheduler: **Create Task** → *Run with highest privileges*, trigger *At log on*, action: the kanata `.exe` with arguments `--cfg <path>\mac-win-shortcuts.kbd`, and uncheck *Stop the task if it runs longer than…* in Settings.

</details>

## Included shortcuts

Hold the left `Win` key as `Cmd`. `Shift` is passed through physically, so every `Cmd+Shift+<key>` variant works automatically.

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

- **Tapping left `Win` alone no longer opens the Start menu** — it is a pure `Cmd` key now. Use `Ctrl+Esc` or the right `Win` key for the Start menu and native `Win+…` shortcuts.
- `Cmd+<key>` combos not listed above just type the plain key.
- The default `winIOv2` variant works through Windows hooks, so games with anti-cheat or raw-input handling may ignore the remapping. Use `-Variant wintercept` if you need it there.
- Shortcuts inside elevated (admin) windows need kanata itself to run elevated — the logon task created by `install.ps1` already does (`Run with highest privileges`).

## Editing the config

kanata runs the copy of the config in the install directory (`%LOCALAPPDATA%\kanata`), not the one in the repo. After changing [mac-win-shortcuts.kbd](mac-win-shortcuts.kbd), apply it with:

```powershell
powershell -ExecutionPolicy Bypass -File update.ps1
```

It validates the config first (kanata keeps running with the old config if validation fails), then copies it over and restarts kanata.

Every `deflayer` must list exactly the keys of `defsrc`, in the same order.
