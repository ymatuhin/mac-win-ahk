# AGENTS.md

## What this repo is

A [QMK](https://qmk.fm) keymap for the **Keychron Q6 HE** (ANSI with knob, `keychron/q6_he/ansi_encoder`) that makes the key next to the space bar behave like macOS `Cmd` on Windows. Developed on macOS, the keyboard is used on Windows.

The remapping used to run on the PC: first an AutoHotkey v2 script, then a kanata config (`mac-win-shortcuts.kbd`, removed — see git history). Both were replaced because anything on the Windows side is either a hook (ignored by games, stuck modifiers) or the Interception kernel driver, whose 10-device lifetime limit gets exhausted by a monitor USB hub that re-enumerates devices. Firmware has neither problem.

## Files

- `keymap/keymap.c` — the keymap, single source of truth
- `keymap/config.h` — `DYNAMIC_KEYMAP_LAYER_COUNT 5`; `keymap/rules.mk` — `VIA_ENABLE = yes`
- `build.sh` — clones Keychron's QMK fork, copies `keymap/` in as the `mac_win` keymap, compiles/flashes
- `check-keymap.py` — asserts every layer has the same shape
- `README.md` — user-facing build/flash instructions and the shortcut list
- `LAUNCHER.md` — the no-flashing alternative: the same shortcuts entered by hand in Keychron Launcher, where the Cmd layer has to share layer 3 with Fn. Keep it in sync with `keymap.c` when shortcuts change.
- `uninstall.ps1` — leftover from the kanata era, removes that install from Windows

## Upstream

Firmware comes from [Keychron/qmk_firmware](https://github.com/Keychron/qmk_firmware), branch **`2025q3`** (not upstream QMK — Hall Effect boards only exist in the fork). Board definitions live in `keyboards/keychron/q6_he/`, the stock keymap this one is derived from is `q6_he/ansi_encoder/keymaps/keychron/keymap.c`.

## Status

Built and flashed onto the owner's board; the shortcuts, the held `Cmd+Tab` switcher and the "tapping `Cmd` does not open the Start menu" behaviour are confirmed working on hardware. Flashing goes over DFU from macOS (`./build.sh flash`); `dfu-util` printing `dfuERROR ... firmware is corrupt` before the write is the bootloader's state machine, not a real error, and is cleared automatically — see README.

## Rules

- Every layer in `keymap.c` must have **exactly the same number of entries in the same order** — QMK compiles a short layer silently and shifts every key after the mistake. After any edit:

  ```
  python3 check-keymap.py
  ```

  A real compile (`./build.sh`) is the only full check; the script only catches shape errors.
- Layer order is load-bearing. The physical Mac/Win slider sets the default layer to 0 (Mac) or 2 (Win) in `q6_he.c`, and QMK resolves the **highest active layer first** — so the `CMD` layer must stay above `WIN_BASE`. It is layer 4, which is why `DYNAMIC_KEYMAP_LAYER_COUNT` is raised to 5; with VIA enabled, layers past that count read back empty.
- Layers 0-3 come from the upstream `keychron` keymap, with the owner's own tweaks carried over from their Launcher export: `KC_F17`/`KC_F18` on both base layers, `KC_KB_POWER` on the Mac layer's Insert, `NK_TOGG` on both Fn layers, and the Windows bottom-row modifier order. Don't "clean them up".
- Four positions that held Launcher macros (`M0`, `M2`, `M3`, `M4`) are deliberately left at stock — Launcher's export JSON stores macro *slots*, not their bodies, so there was nothing to port. If the owner ever supplies the bodies, they go into `keymap.c` directly.
- Custom keycodes use the `QK_USER_0` range, never `SAFE_RANGE`: Keychron's own keycodes occupy the `QK_KB` range via `keychron_common.h`.
- The `Cmd` key (bottom row, next to the space bar) is a pure `MO(CMD)` layer key with no tap action — tapping it must NOT open the Start menu. Don't "fix" this with tap-hold; it's deliberate.
- `Shift` is intentionally not remapped: `Cmd+Shift+<key>` variants work by physical Shift passing through. Only add explicit handling when the shifted output differs from the unshifted one (see `CMD_4` and `LANG` in `process_record_user` for the pattern).
- The `Cmd+Tab` switcher holds `KC_LALT` between `Tab` presses and releases it in `layer_state_set_user` when the `CMD` layer drops. That release is what commits the switcher selection — keep it if you touch `CMD_TAB`.
- Keep the "Included shortcuts" section of `README.md` in sync with the keymap.
- `uninstall.ps1` must stay ASCII-only and keep its UTF-8 BOM. Windows PowerShell 5.1 reads BOM-less files in the ANSI codepage: a UTF-8 em-dash decodes in cp1251 to a smart quote (`”`) that terminates strings early and breaks parsing (this happened once). Check after editing: `grep -P '[^\x00-\x7F]' *.ps1` should only match the BOM line.
