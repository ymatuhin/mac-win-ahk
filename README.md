# mac-win-shortcuts

AutoHotkey v2 script that remaps common macOS `Cmd` shortcuts to Windows-friendly equivalents.

The script is intended for people using an Apple keyboard on Windows or anyone who wants `Win` to behave more like `Cmd`.

It also includes a workaround for cases where the `Win` key gets logically "stuck" after a shortcut.

## Requirements

- Windows
- [AutoHotkey v2](https://www.autohotkey.com/)

## Files

- [mac-win-shortcuts.ahk](/Users/ym/Dev/mac-win-shortcuts/mac-win-shortcuts.ahk) - main shortcut script

## How to use

1. Install AutoHotkey v2.
2. Open [mac-win-shortcuts.ahk](/Users/ym/Dev/mac-win-shortcuts/mac-win-shortcuts.ahk) on Windows.
3. Keep the script running in the tray, or add it to Windows startup.

## Included shortcuts

### Editing

- `Cmd+C` -> `Ctrl+C`
- `Cmd+V` -> `Ctrl+V`
- `Cmd+X` -> `Ctrl+X`
- `Cmd+A` -> `Ctrl+A`
- `Cmd+Z` -> `Ctrl+Z`
- `Cmd+Shift+Z` -> `Ctrl+Shift+Z`
- `Cmd+F` -> `Ctrl+F`
- `Cmd+G` -> `Ctrl+G`
- `Cmd+B` -> `Ctrl+B`
- `Cmd+I` -> `Ctrl+I`
- `Cmd+U` -> `Ctrl+U`
- `Cmd+K` -> `Ctrl+K`
- `Cmd+,` -> `Ctrl+,`
- `Cmd+Enter` -> `Ctrl+Enter`
- `Cmd+Backspace` -> `Delete`

### Files and windows

- `Cmd+N` -> `Ctrl+N`
- `Cmd+Shift+N` -> `Ctrl+Shift+N`
- `Cmd+S` -> `Ctrl+S`
- `Cmd+Shift+S` -> `Ctrl+Shift+S`
- `Cmd+O` -> `Ctrl+O`
- `Cmd+P` -> `Ctrl+P`
- `Cmd+Q` -> `Alt+F4`
- `Cmd+M` -> minimize active window

### Browser-style shortcuts

- `Cmd+T` -> `Ctrl+T`
- `Cmd+Shift+T` -> `Ctrl+Shift+T`
- `Cmd+W` -> `Ctrl+W`
- `Cmd+Shift+W` -> `Ctrl+Shift+W`
- `Cmd+R` -> `Ctrl+R`
- `Cmd+L` -> `Ctrl+L`
- `Cmd+D` -> `Ctrl+D`

### Navigation

- `Cmd+Left` -> `Home`
- `Cmd+Right` -> `End`
- `Cmd+Shift+Left` -> `Shift+Home`
- `Cmd+Shift+Right` -> `Shift+End`
- `Cmd+Up` -> `Ctrl+Home`
- `Cmd+Down` -> `Ctrl+End`
- `Cmd+Shift+Up` -> `Ctrl+Shift+Home`
- `Cmd+Shift+Down` -> `Ctrl+Shift+End`
- `Cmd+Tab` -> `Alt+Tab`

## Notes

- The script uses `Win` as the `Cmd` key.
- `Cmd+Tab` keeps `Alt` held while `Win` is pressed, then releases `Alt` when `Win` is released.
- `#MenuMaskKey vkE8` is used to reduce `Win` key sticking issues after hotkeys.
