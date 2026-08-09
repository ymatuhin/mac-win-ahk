/* Copyright 2025 @ Keychron (https://www.keychron.com)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

/* mac-win-shortcuts for the Keychron Q6 HE (ansi_encoder).
 *
 * Makes the key next to the space bar behave like macOS Cmd, entirely inside
 * the keyboard: holding it activates the CMD layer, tapping it alone does
 * nothing. Ported from the kanata config this repo used to ship (git history).
 *
 * Layers 0-3 are Keychron's stock layers; the Windows bottom row keeps the
 * modifier arrangement from the owner's own Launcher layout. Layer 4 is the Cmd
 * layer - it has to sit above WIN_BASE (2) because QMK resolves the highest
 * active layer first.
 */

#include QMK_KEYBOARD_H
#include "keychron_common.h"

enum layers {
    MAC_BASE,
    MAC_FN,
    WIN_BASE,
    WIN_FN,
    CMD,
};

#define FN_MAC MO(MAC_FN)
#define FN_WIN MO(WIN_FN)
#define KC_CMD MO(CMD)

enum custom_keycodes {
    // QK_USER range, so these can never collide with Keychron's QK_KB keycodes
    CMD_TAB = QK_USER_0,
    CMD_4,
    LANG,
};

// clang-format off
const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [MAC_BASE] = LAYOUT_ansi_108(
        KC_ESC,   KC_BRID,  KC_BRIU,  KC_MCTRL, KC_LNPAD, UG_VALD,  UG_VALU,  KC_MPRV,  KC_MPLY,  KC_MNXT,  KC_MUTE,  KC_VOLD,  KC_VOLU,  KC_MUTE,   KC_SNAP,  KC_F17 ,  KC_F18 ,   KC_F13,  KC_F14,  KC_F15,  KC_F16,
        KC_GRV,   KC_1,     KC_2,     KC_3,     KC_4,     KC_5,     KC_6,     KC_7,     KC_8,     KC_9,     KC_0,     KC_MINS,  KC_EQL,   KC_BSPC,   KC_KB_POWER,   KC_HOME,  KC_PGUP,   KC_NUM,  KC_PSLS, KC_PAST, KC_PMNS,
        KC_TAB,   KC_Q,     KC_W,     KC_E,     KC_R,     KC_T,     KC_Y,     KC_U,     KC_I,     KC_O,     KC_P,     KC_LBRC,  KC_RBRC,  KC_BSLS,   KC_DEL,   KC_END,   KC_PGDN,   KC_P7,   KC_P8,  KC_P9,    KC_PPLS,
        KC_CAPS,  KC_A,     KC_S,     KC_D,     KC_F,     KC_G,     KC_H,     KC_J,     KC_K,     KC_L,     KC_SCLN,  KC_QUOT,            KC_ENT,                                   KC_P4,   KC_P5,  KC_P6,
        KC_LSFT,            KC_Z,     KC_X,     KC_C,     KC_V,     KC_B,     KC_N,     KC_M,     KC_COMM,  KC_DOT,   KC_SLSH,            KC_RSFT,             KC_UP,               KC_P1,   KC_P2,  KC_P3,    KC_PENT,
        KC_LCTL,  KC_LOPTN, KC_LCMMD,                               KC_SPC,                                 KC_RCMMD, KC_ROPTN, FN_MAC,  KC_RCTL,    KC_LEFT,  KC_DOWN,  KC_RGHT,   KC_P0,           KC_PDOT),

    [MAC_FN] = LAYOUT_ansi_108(
        _______,  KC_F1,    KC_F2,    KC_F3,    KC_F4,    KC_F5,    KC_F6,    KC_F7,    KC_F8,    KC_F9,    KC_F10,   KC_F11,   KC_F12,   UG_TOGG,   _______,  _______,  UG_TOGG,   _______,  _______,  _______,  _______,
        _______,  BT_HST1,  BT_HST2,  BT_HST3,  P2P4G,    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,   _______,  _______,  _______,   _______,  _______,  _______,  _______,
        UG_TOGG,  UG_NEXT,  UG_VALU,  UG_HUEU,  UG_SATU,  UG_SPDU,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,   _______,  _______,  _______,   _______,  _______,  _______,  _______,
        _______,  UG_PREV,  UG_VALD,  UG_HUED,  UG_SATD,  UG_SPDD,  _______,  _______,  _______,  _______,  _______,  _______,            _______,                                  _______,  _______,  _______,
        _______,            _______,  _______,  _______,  _______,  BAT_LVL,  NK_TOGG,  _______,  _______,  _______,  _______,            _______,             _______,             _______,  _______,  _______,  _______,
        _______,  _______,  _______,                                _______,                                _______,  _______,  _______,  _______,   _______,  _______,  _______,   _______,            _______),

    [WIN_BASE] = LAYOUT_ansi_108(
        KC_ESC,   KC_F1,    KC_F2,    KC_F3,    KC_F4,    KC_F5,    KC_F6,    KC_F7,    KC_F8,    KC_F9,    KC_F10,   KC_F11,   KC_F12,   KC_MUTE,   KC_PSCR,  KC_F17  , KC_F18 ,   KC_F13,  KC_F14,  KC_F15,  KC_F16,
        KC_GRV,   KC_1,     KC_2,     KC_3,     KC_4,     KC_5,     KC_6,     KC_7,     KC_8,     KC_9,     KC_0,     KC_MINS,  KC_EQL,   KC_BSPC,   KC_INS,   KC_HOME,  KC_PGUP,   KC_NUM,  KC_PSLS, KC_PAST, KC_PMNS,
        KC_TAB,   KC_Q,     KC_W,     KC_E,     KC_R,     KC_T,     KC_Y,     KC_U,     KC_I,     KC_O,     KC_P,     KC_LBRC,  KC_RBRC,  KC_BSLS,   KC_DEL,   KC_END,   KC_PGDN,   KC_P7,   KC_P8,  KC_P9,    KC_PPLS,
        LANG,     KC_A,     KC_S,     KC_D,     KC_F,     KC_G,     KC_H,     KC_J,     KC_K,     KC_L,     KC_SCLN,  KC_QUOT,            KC_ENT,                                   KC_P4,   KC_P5,  KC_P6,
        KC_LSFT,            KC_Z,     KC_X,     KC_C,     KC_V,     KC_B,     KC_N,     KC_M,     KC_COMM,  KC_DOT,   KC_SLSH,            KC_RSFT,             KC_UP,               KC_P1,   KC_P2,  KC_P3,    KC_PENT,
        KC_LCTL,  KC_LALT,  KC_CMD,                                 KC_SPC,                                 KC_RGUI,  KC_RALT,  FN_WIN,   KC_RCTL,   KC_LEFT,  KC_DOWN,  KC_RGHT,   KC_P0,           KC_PDOT),

    [WIN_FN] = LAYOUT_ansi_108(
        _______,  KC_BRID,  KC_BRIU,  KC_TASK,  KC_FILE,  UG_VALD,  UG_VALU,  KC_MPRV,  KC_MPLY,  KC_MNXT,  KC_MUTE,  KC_VOLD,  KC_VOLU,  UG_TOGG,   _______,  _______,  UG_TOGG,   _______,  _______,  _______,  _______,
        _______,  BT_HST1,  BT_HST2,  BT_HST3,  P2P4G,    _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,   _______,  _______,  _______,   _______,  _______,  _______,  _______,
        UG_TOGG,  UG_NEXT,  UG_VALU,  UG_HUEU,  UG_SATU,  UG_SPDU,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,   _______,  _______,  _______,   _______,  _______,  _______,  _______,
        _______,  UG_PREV,  UG_VALD,  UG_HUED,  UG_SATD,  UG_SPDD,  _______,  _______,  _______,  _______,  _______,  _______,            _______,                                  _______,  _______,  _______,
        _______,            _______,  _______,  _______,  _______,  BAT_LVL,  NK_TOGG,  _______,  _______,  _______,  _______,            _______,             _______,             _______,  _______,  _______,  _______,
        _______,  _______,  _______,                                _______,                                _______,  _______,  _______,  _______,   _______,  _______,  _______,   _______,            _______),

    // Cmd layer: held by the key next to the space bar. Shift is not remapped,
    // so every Cmd+Shift+<key> variant works by holding physical Shift.
    // _______ falls through to WIN_BASE: an unlisted Cmd+<key> types the plain key.
    [CMD] = LAYOUT_ansi_108(
        _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,  _______,   _______,  _______,  _______,   _______,  _______,  _______,  _______,
        _______,  LCTL(KC_1), LCTL(KC_2), LCTL(KC_3), CMD_4, LCTL(KC_5), LCTL(KC_6), LCTL(KC_7), LCTL(KC_8), LCTL(KC_9), LCTL(KC_0), _______, _______, KC_DEL, _______,  _______,  _______,   _______,  _______,  _______,  _______,
        CMD_TAB,  LALT(KC_F4), LCTL(KC_W), _______, LCTL(KC_R), LCTL(KC_T), _______, LCTL(KC_U), LCTL(KC_I), LCTL(KC_O), LCTL(KC_P), _______, _______, _______, _______,  _______,  _______,   _______,  _______,  _______,  _______,
        _______,  LCTL(KC_A), LCTL(KC_S), LCTL(KC_D), LCTL(KC_F), LCTL(KC_G), _______, _______, LCTL(KC_K), LCTL(KC_L), _______, _______,      LCTL(KC_ENT),                             _______,  _______,  _______,
        _______,            LCTL(KC_Z), LCTL(KC_X), LCTL(KC_C), LCTL(KC_V), LCTL(KC_B), LCTL(KC_N), LGUI(KC_DOWN), LCTL(KC_COMM), _______, _______,  _______,  LCTL(KC_HOME),          _______,  _______,  _______,  _______,
        _______,  _______,  _______,                                LGUI(KC_S),                             _______,  _______,  _______,  _______,   KC_HOME,  LCTL(KC_END), KC_END,   _______,           _______),
};

// clang-format on
#if defined(ENCODER_MAP_ENABLE)
const uint16_t PROGMEM encoder_map[][NUM_ENCODERS][2] = {
    [MAC_BASE] = {ENCODER_CCW_CW(KC_VOLD, KC_VOLU)},
    [MAC_FN]   = {ENCODER_CCW_CW(UG_VALD, UG_VALU)},
    [WIN_BASE] = {ENCODER_CCW_CW(KC_VOLD, KC_VOLU)},
    [WIN_FN]   = {ENCODER_CCW_CW(UG_VALD, UG_VALU)},
    [CMD]      = {ENCODER_CCW_CW(KC_VOLD, KC_VOLU)},
};
#endif // ENCODER_MAP_ENABLE

// Alt stays held between Tab presses so the app switcher behaves like macOS:
// it is released when the Cmd layer is released, which commits the selection.
static bool alt_tab_held = false;

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        case CMD_TAB:
            if (record->event.pressed) {
                if (!alt_tab_held) {
                    alt_tab_held = true;
                    register_code(KC_LALT);
                    // let the Alt report land before Tab, otherwise Windows
                    // swallows the first press and never opens the switcher
                    wait_ms(20);
                }
                tap_code(KC_TAB);
            }
            return false;

        // Cmd+4 = Ctrl+4 (fourth tab), Cmd+Shift+4 = Win+Shift+S (screenshot).
        // Physical Shift is still held here, so LGUI+S comes out as Win+Shift+S.
        case CMD_4:
            if (record->event.pressed) {
                if (get_mods() & MOD_MASK_SHIFT) {
                    register_code(KC_LGUI);
                    tap_code(KC_S);
                    unregister_code(KC_LGUI);
                } else {
                    register_code(KC_LCTL);
                    tap_code(KC_4);
                    unregister_code(KC_LCTL);
                }
            }
            return false;

        // Caps Lock = Win+Space (input language switch), Shift+Caps = real Caps Lock.
        case LANG:
            if (record->event.pressed) {
                if (get_mods() & MOD_MASK_SHIFT) {
                    tap_code(KC_CAPS);
                } else {
                    register_code(KC_LGUI);
                    tap_code(KC_SPC);
                    unregister_code(KC_LGUI);
                }
            }
            return false;
    }

    return true;
}

layer_state_t layer_state_set_user(layer_state_t state) {
    if (alt_tab_held && !layer_state_cmp(state, CMD)) {
        unregister_code(KC_LALT);
        alt_tab_held = false;
    }
    return state;
}
