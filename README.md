# mac-win-shortcuts

[kanata](https://github.com/jtroo/kanata) config that makes the physical left `Win` key behave like macOS `Cmd` on Windows.

Intended for people using an Apple keyboard (or mac muscle memory) on Windows: `Cmd+C`, `Cmd+Tab`, `Cmd+arrows` and friends work the way they do on macOS, while native `Ctrl` shortcuts stay unchanged.

> **Why kanata and not AutoHotkey?** The previous version of this repo was an AutoHotkey v2 script (see git history). AHK works through Windows low-level hooks and injected input, which games and anti-cheat systems ignore, and its modifier juggling causes the `Win` key to get stuck. kanata with the Interception driver remaps keys at the kernel-driver level: applications see the remapped keys as real hardware input, so everything works in games and nothing sticks.

## Files

- [mac-win-shortcuts.kbd](mac-win-shortcuts.kbd) — the kanata config

## Requirements

- Windows 10/11
- [kanata](https://github.com/jtroo/kanata/releases) v1.11 or newer

## Installation

1. Download `windows-binaries-x64.zip` from the [kanata releases page](https://github.com/jtroo/kanata/releases) and pick **one** executable:
   - `kanata_windows_x64_gui_wintercept.exe` — **recommended**. Uses the [Interception](https://github.com/oblitum/Interception/releases) kernel driver: works in games and never gets stuck. Requires installing the driver (step 2).
   - `kanata_windows_x64_gui_winIOv2.exe` — no driver needed. Works through Windows hooks (same level as AutoHotkey), so it is fine for regular apps but games may ignore it.

   The `gui` variants run as a tray icon; `tty` variants run in a terminal window.

2. **Only for the `wintercept` variant** — install the Interception driver:
   1. Download `Interception.zip` from [oblitum/Interception releases](https://github.com/oblitum/Interception/releases) and unpack it.
   2. In an **administrator** command prompt run:
      ```
      install-interception.exe /install
      ```
   3. Reboot.
   4. If kanata complains about a missing DLL, copy `interception.dll` from the zip next to the kanata `.exe`.

3. Put the kanata `.exe` and `mac-win-shortcuts.kbd` in one folder (e.g. `C:\kanata\`) and check the config:
   ```
   kanata_windows_x64_gui_wintercept.exe --cfg mac-win-shortcuts.kbd --check
   ```

4. Run it:
   ```
   kanata_windows_x64_gui_wintercept.exe --cfg mac-win-shortcuts.kbd
   ```
   The `gui` variant sits in the system tray; you can reload the config or exit from there.

## Autostart

Use Task Scheduler (more reliable than the Startup folder because it can run elevated):

1. Open **Task Scheduler** → **Create Task**.
2. **General**: check *Run with highest privileges*.
3. **Triggers**: *At log on*.
4. **Actions**: *Start a program* → the kanata `.exe`, arguments: `--cfg C:\kanata\mac-win-shortcuts.kbd`.
5. **Settings**: uncheck *Stop the task if it runs longer than…*.

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
- The Interception driver has a lifetime limit of 10 registered input devices; if you swap keyboards/mice a lot and input dies, reinstall the driver. See [kanata platform known issues](https://github.com/jtroo/kanata/blob/main/docs/platform-known-issues.adoc).
- If shortcuts don't work in a specific elevated (admin) app while using the `winIOv2` variant, run kanata as administrator — or switch to `wintercept`, which doesn't have this problem.

## Editing the config

After changing [mac-win-shortcuts.kbd](mac-win-shortcuts.kbd), validate it:

```
kanata --cfg mac-win-shortcuts.kbd --check
```

Every `deflayer` must list exactly the keys of `defsrc`, in the same order. The `gui` variant can live-reload the config from the tray menu.
