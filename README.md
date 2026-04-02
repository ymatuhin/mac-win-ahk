# mac-win-shortcuts

AutoHotkey v2 script that maps common macOS `Cmd` shortcuts directly onto the physical left `Win` key.

The script is intended for people using an Apple keyboard on Windows who want the left `Win` key to behave like `Cmd` for common shortcuts.

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
- `Cmd+Shift+Tab` is not implemented because of AutoHotkey `AltTab` hotkey limitations

## Notes

- The script does not remap `LWin` to `Ctrl`; it binds explicit hotkeys to the physical left `Win` key.
- Native `Ctrl` shortcuts stay unchanged.
- `Cmd+Tab` is handled separately via AutoHotkey's built-in `AltTab` action.
- `Cmd+Shift+Tab` is omitted because AutoHotkey's special `ShiftAltTab` hotkeys cannot be bound to this `LWin+Shift+Tab` combination without side effects or parser errors.
