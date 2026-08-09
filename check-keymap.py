#!/usr/bin/env python3
"""Check that every layer in keymap/keymap.c has the same shape.

QMK will happily compile a layer with the wrong number of entries and silently
shift every key after the mistake, so this is the cheap guard to run after any
edit. It does not replace `./build.sh`, which is the real compile.
"""

import re
import sys
from pathlib import Path

KEYMAP = Path(__file__).parent / "keymap" / "keymap.c"


def layers(src: str):
    body = src.split("const uint16_t PROGMEM keymaps", 1)[1]
    body = body[: body.index("\n};")]

    for match in re.finditer(r"\[(\w+)\]\s*=\s*(LAYOUT_\w+)\(", body):
        i, depth = match.end(), 1
        while depth:
            depth += (body[i] == "(") - (body[i] == ")")
            i += 1
        content = body[match.end() : i - 1]
        rows = [r for r in content.split("\n") if r.strip() and not r.strip().startswith("//")]
        yield match.group(1), match.group(2), [
            len([t for t in row.split(",") if t.strip()]) for row in rows
        ]


def main() -> int:
    found = list(layers(KEYMAP.read_text()))
    if not found:
        print("no layers found - did the keymaps array move?")
        return 1

    reference = found[0][2]
    ok = True
    for name, layout, rows in found:
        status = "ok" if rows == reference else f"MISMATCH, expected {reference}"
        if rows != reference:
            ok = False
        print(f"{name:10} {layout:18} rows={rows} total={sum(rows)}  {status}")

    print("\nall layers match" if ok else "\nlayers differ - fix before flashing")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
