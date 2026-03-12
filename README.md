# mac-win-shortcuts

AutoHotkey v2 script that remaps common macOS `Cmd` shortcuts to Windows-friendly equivalents.

The script is intended for people using an Apple keyboard on Windows or anyone who wants `Win` to behave more like `Cmd`.

It also includes a workaround for cases where the `Win` key gets logically "stuck" after a shortcut.

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
- `Cmd+Shift+4` -> `Win+Shift+S`
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
- Hotkeys use a non-blocking `Win` mask, so repeated shortcuts do not hang while the key is still physically held down.
- `Cmd+Tab` keeps `Alt` held while `Win` is pressed and releases it from a timer as soon as `Win` is released.
- `#UseHook`, `SendMode("Input")`, and `#MenuMaskKey vkE8` are used to reduce stuck modifier states after hotkeys.
