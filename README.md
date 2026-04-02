# mac-win-shortcuts

AutoHotkey v2 script that remaps the left `Win` key to `Ctrl` and adds a few custom left-`Ctrl` shortcuts for macOS-style behavior.

The script is intended for people using an Apple keyboard on Windows who want the left `Win` key to behave like `Ctrl`.

## Requirements

- Windows
- [AutoHotkey v2](https://www.autohotkey.com/)

## Files

- [mac-win-shortcuts.ahk](/Users/ym/Dev/mac-win-ahk/mac-win-shortcuts.ahk) - main shortcut script

## How to use

1. Install AutoHotkey v2.
2. Open [mac-win-shortcuts.ahk](/Users/ym/Dev/mac-win-ahk/mac-win-shortcuts.ahk) on Windows.
3. Keep the script running in the tray, or add it to Windows startup.

## Included shortcuts

### Editing

- `LWin` -> `Left Ctrl`
- `Ctrl+Shift+4` -> `Win+Shift+S`
- `Ctrl+Backspace` -> `Delete`

### Files and windows

- `Left Ctrl+Q` -> `Alt+F4`
- `Left Ctrl+M` -> minimize active window

### Browser-style shortcuts

- Standard `Ctrl+...` shortcuts are available directly because `LWin` is remapped to `Left Ctrl`

### Navigation

- `Left Ctrl+Left` -> `Home`
- `Left Ctrl+Right` -> `End`
- `Left Ctrl+Shift+Left` -> `Shift+Home`
- `Left Ctrl+Shift+Right` -> `Shift+End`
- `Left Ctrl+Up` -> `Ctrl+Home`
- `Left Ctrl+Down` -> `Ctrl+End`
- `Left Ctrl+Shift+Up` -> `Ctrl+Shift+Home`
- `Left Ctrl+Shift+Down` -> `Ctrl+Shift+End`
- `Left Ctrl+Tab` -> `Alt+Tab`

## Notes

- The script remaps only the left `Win` key to `Left Ctrl`.
- Custom shortcuts now listen only on left `Ctrl`, and the previous `Win` release logic has been removed.
- Native shortcuts on right `Ctrl` stay unchanged.
