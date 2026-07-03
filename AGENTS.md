# AGENTS.md

## What this repo is

A [kanata](https://github.com/jtroo/kanata) keyboard config for Windows that makes the physical left `Win` key behave like macOS `Cmd`. The repo is developed on macOS but the config targets Windows.

The project used to be an AutoHotkey v2 script (`mac-win-shortcuts.ahk`, removed — see git history). It was replaced because AHK's hook-based input injection doesn't work in games and causes stuck modifier keys.

## Files

- `mac-win-shortcuts.kbd` — the kanata config, single source of truth
- `install.ps1` / `uninstall.ps1` — Windows installer scripts (download kanata, install the Interception driver, copy the config to `%LOCALAPPDATA%\kanata`, register a Task Scheduler logon task)
- `README.md` — user-facing install/usage instructions and the shortcut list

## Rules

- Every `deflayer` in the `.kbd` must list exactly the keys of `defsrc`, in the same order. When adding a shortcut, add the key to `defsrc` AND to every layer.
- After any `.kbd` change, validate it (kanata is cross-platform, `brew install kanata` works on macOS):

  ```
  kanata --cfg mac-win-shortcuts.kbd --check
  ```

- Keep the "Included shortcuts" section of `README.md` in sync with the `.kbd`.
- `Shift` is intentionally not remapped: `Cmd+Shift+<key>` variants work by physical Shift passing through. Don't add explicit shifted duplicates unless the shifted output differs from the unshifted one (see the `cmd-4` fork for the pattern).
- The left Win key is a pure layer key (no tap action) — tapping it must NOT open the Start menu. Don't "fix" this with tap-hold; it's deliberate.
- The `Cmd+Tab` switcher uses a virtual key (`vk-alt`) held until physical Cmd release. The `(on-release release-virtualkey vk-alt)` in the `@cmd` alias is what commits the switcher — keep it if you touch the alias.
- The exe names inside kanata's `windows-binaries-x64.zip` follow the pattern `kanata_windows_gui_<wintercept|winIOv2>_x64.exe` (verified against v1.11.0). If `install.ps1` breaks on a new release, check the asset layout first. PowerShell scripts can't be executed on this macOS machine — review changes to them extra carefully.
