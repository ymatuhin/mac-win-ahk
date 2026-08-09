#pragma once

/* The Cmd layer is layer 4, so the dynamic (VIA/Launcher) keymap has to hold
 * five layers instead of Keychron's stock four. Without this the Cmd layer
 * exists in the firmware but reads back empty once VIA takes over from EEPROM. */
#define DYNAMIC_KEYMAP_LAYER_COUNT 5
