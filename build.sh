#!/usr/bin/env bash
#
# Builds the firmware: clones Keychron's QMK fork if needed, drops keymap/ into
# it as the `mac_win` keymap and compiles.
#
#   ./build.sh            # compile only
#   ./build.sh flash      # compile and flash (keyboard must be in bootloader mode)
#
# Override the checkout location with QMK_DIR=/some/path ./build.sh
set -euo pipefail

KEYBOARD="keychron/q6_he/ansi_encoder"
KEYMAP="mac_win"
BRANCH="2025q3"
REPO="https://github.com/Keychron/qmk_firmware.git"
QMK_DIR="${QMK_DIR:-$HOME/qmk_keychron}"

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ARM toolchain: Homebrew's core arm-none-eabi-gcc ships without newlib and dies
# on <stdint.h>, so prefer Arm's own toolchain unpacked under ~/.local/opt.
for dir in "$HOME"/.local/opt/arm-gnu-toolchain-*/bin; do
    [ -x "$dir/arm-none-eabi-gcc" ] && PATH="$dir:$PATH" && break
done

# qmk cli, either on PATH or in the venv from the README
QMK_BIN="$(command -v qmk || true)"
[ -z "$QMK_BIN" ] && [ -x "$HOME/.qmk-venv/bin/qmk" ] && QMK_BIN="$HOME/.qmk-venv/bin/qmk"
if [ -z "$QMK_BIN" ]; then
    echo "qmk cli not found - see 'Install the toolchain' in README.md" >&2
    exit 1
fi

if ! command -v arm-none-eabi-gcc >/dev/null 2>&1; then
    echo "arm-none-eabi-gcc not found - see 'Install the toolchain' in README.md" >&2
    exit 1
fi

if [ ! -d "$QMK_DIR" ]; then
    echo "Cloning Keychron's QMK fork into $QMK_DIR (this is a few hundred MB)..."
    git clone --depth 1 --branch "$BRANCH" --recurse-submodules --shallow-submodules \
        "$REPO" "$QMK_DIR"
fi

dest="$QMK_DIR/keyboards/$KEYBOARD/keymaps/$KEYMAP"
rm -rf "$dest"
mkdir -p "$dest"
cp "$here/keymap/"* "$dest/"

python3 "$here/check-keymap.py"

export QMK_HOME="$QMK_DIR"
cd "$QMK_DIR"
if [ "${1:-}" = "flash" ]; then
    "$QMK_BIN" flash -kb "$KEYBOARD" -km "$KEYMAP"
else
    "$QMK_BIN" compile -kb "$KEYBOARD" -km "$KEYMAP"
    echo
    echo "Firmware written to $QMK_DIR/keychron_q6_he_ansi_encoder_${KEYMAP}.bin"
    echo "Flash it with ./build.sh flash, or with QMK Toolbox."
fi
