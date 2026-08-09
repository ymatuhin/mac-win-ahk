# Setting it up in Keychron Launcher (no flashing)

This is the no-risk path: [Keychron Launcher](https://launcher.keychron.com) only rewrites the keymap stored in the keyboard's EEPROM. The firmware itself is untouched, layers 0 and 1 (the Mac side) stay factory, and everything here is undone by Launcher's own keyboard reset.

The cost compared to [the compiled keymap](keymap/keymap.c): no macOS-style `Cmd+Tab` switcher, and the two Shift-conditional keys move to separate positions. See [Compromises](#compromises).

## How it works

Launcher exposes four layers and QMK resolves the **highest active layer first**, so a held `Cmd` layer has to sit above the Windows base layer (2). The only slot left is layer 3 — the Fn layer. So layer 3 becomes a merged **Fn + Cmd** layer, reached either by holding `Fn` or by holding the key next to the space bar.

That collision is harmless in practice: the `Cmd` shortcuts live on the letters and digits, the Fn functions live on the F-row, and the two sets don't overlap once the Bluetooth keys are moved off the number row (below).

## Before you start

- Open [launcher.keychron.com](https://launcher.keychron.com) in Chrome, Edge, Brave, Opera or Vivaldi (Safari and Firefox do not support WebHID).
- Connect the keyboard **by cable** and set the Mac/Win slider to **Win**, so Launcher edits the layers you are actually using.
- Assign keycodes from Launcher's key picker; combinations like `LCTL(KC_C)` are entered through the *Any* / custom keycode field.

## Layer 2 — Windows base

Only two keys change:

| Key | Assign | Result |
|---|---|---|
| the key left of `Space` (left `Alt` on the stock bottom row) | `MO(3)` | holding it opens the Cmd layer; tapping it does nothing, so the Start menu never opens |
| `Caps Lock` | `LGUI(KC_SPC)` | input language switch |

That position is the one `Cmd` occupies on a Mac. Move `Alt` to the key it displaces if you still need it on the left half.

## Layer 3 — merged Fn + Cmd

### F-row — Fn functions, relocated

The Bluetooth keys live on the number row by default, which the `Cmd+1…0` tab shortcuts need. Move them up here:

| Key | Assign | Result |
|---|---|---|
| `F1` / `F2` / `F3` | `BT_HST1` / `BT_HST2` / `BT_HST3` | Bluetooth hosts 1-3 |
| `F4` | `P2P4G` | 2.4 GHz receiver |
| `F5` | `LGUI(LSFT(KC_S))` | screenshot selection (replaces `Cmd+Shift+4`) |
| `F6` | `BAT_LVL` | battery level indicator |
| `F7` … `F12` | leave as they are | media and volume, factory defaults |

### Number row

| Key | Assign | Result |
|---|---|---|
| `1` … `9` | `LCTL(KC_1)` … `LCTL(KC_9)` | switch browser tabs |
| `0` | `LCTL(KC_0)` | reset zoom |
| `Backspace` | `KC_DEL` | forward delete |

### Letters

| Key | Assign | Result |
|---|---|---|
| `Q` | `LALT(KC_F4)` | close the application |
| `W` | `LCTL(KC_W)` | close tab |
| `R` | `LCTL(KC_R)` | reload |
| `T` | `LCTL(KC_T)` | new tab |
| `U` | `LCTL(KC_U)` | underline |
| `I` | `LCTL(KC_I)` | italic |
| `O` | `LCTL(KC_O)` | open |
| `P` | `LCTL(KC_P)` | print |
| `A` | `LCTL(KC_A)` | select all |
| `S` | `LCTL(KC_S)` | save |
| `D` | `LCTL(KC_D)` | bookmark |
| `F` | `LCTL(KC_F)` | find |
| `G` | `LCTL(KC_G)` | find next |
| `K` | `LCTL(KC_K)` | insert link |
| `L` | `LCTL(KC_L)` | address bar |
| `Z` | `LCTL(KC_Z)` | undo |
| `X` | `LCTL(KC_X)` | cut |
| `C` | `LCTL(KC_C)` | copy |
| `V` | `LCTL(KC_V)` | paste |
| `B` | `LCTL(KC_B)` | bold |
| `N` | `LCTL(KC_N)` | new window |
| `M` | `LGUI(KC_DOWN)` | minimize |
| `,` | `LCTL(KC_COMM)` | settings |

`Cmd+Shift+<key>` variants need no separate entries — physical Shift passes through, so `Cmd+Shift+Z` comes out as `Ctrl+Shift+Z`.

### Everything else

| Key | Assign | Result |
|---|---|---|
| `Tab` | `LALT(KC_TAB)` | app switcher, see [Compromises](#compromises) |
| `Caps Lock` | `KC_CAPS` | real Caps Lock (`Fn+Caps` or `Cmd+Caps`) |
| `Enter` | `LCTL(KC_ENT)` | send / confirm |
| `Space` | `LGUI(KC_S)` | Windows Search, the Spotlight analog |
| `←` / `→` | `KC_HOME` / `KC_END` | start / end of line |
| `↑` / `↓` | `LCTL(KC_HOME)` / `LCTL(KC_END)` | start / end of document |

Arrows with Shift held select, as on macOS.

### What gets overwritten

The letter keys on layer 3 currently hold the RGB controls (effect, hue, saturation, speed) and `B` holds the battery indicator. Both are still reachable: RGB is configurable in Launcher itself, and the battery level moves to `F6` above. Brightness (`F1`/`F2`), Task View (`F3`) and File Explorer (`F4`) are given up to the Bluetooth keys — Task View is `Win+Tab` and Explorer is `Win+E` on any keyboard anyway.

## Compromises

- **`Cmd+Tab` does not hold the switcher open.** The macOS behaviour needs `Alt` held between `Tab` presses, which is state across events — impossible in a GUI keymap. `LALT(KC_TAB)` jumps to the previous window on each press instead of cycling. Doing it with a macro that presses `Alt` down and never releases it leaves a stuck modifier; that is the exact failure this project left AutoHotkey over, so don't.
- **Shift-conditional keys are split up.** `Cmd+Shift+4` becomes `Fn+F5`, and real `Caps Lock` becomes `Fn+Caps`. Nothing is lost, the finger position changes.

Both are the reason [the compiled keymap](README.md#build-and-flash) exists — it puts the `Cmd` layer on layer 4, where the collision disappears, and handles the conditionals in C.

## Undoing all of it

Launcher's keyboard reset restores the factory keymap. Nothing here touches the firmware, the bootloader or the Hall Effect calibration.
