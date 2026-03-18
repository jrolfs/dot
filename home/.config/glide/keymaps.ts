import type { SimpleKeymapTuple } from './types';

/**
 * Default keymappings: https://github.com/glide-browser/glide/blob/main/src/glide/browser/base/content/plugins/keymaps.mts
 */

(
  [
    //
    // Command

    ['command', '<C-n>', 'commandline_focus_next', 'Focus next command'],
    ['command', '<C-p>', 'commandline_focus_back', 'Focus previous command'],

    //
    // Normal

    // Tabs
    ['normal', 'q', 'tab_close', 'Close current tab'],
    ['normal', '<S-q>', 'tab_reopen', 'Reopen last closed tab'],
    ['normal', 't', 'tab_new', 'Open a new tab'],
    ['normal', '<leader>td', 'tab_duplicate', 'Duplicate the active tab'],
    ['normal', '<leader>tp', 'tab_pin_toggle', 'Toggle pinning the active tab'],

    // Windows
    ['normal', '<leader>wl', 'window_list', 'List open windows with their IDs'],

    // Settings
    [
      'normal',
      '<leader>ss',
      'scale_toggle 1.6 2.0',
      'Toggle pixel density for all windows between 1.6 and 2.0',
    ],
    [
      'normal',
      '<leader>sS',
      'scale',
      'Scale pixel density to specified decimal value',
    ],

    // Glide
    ['normal', '<leader><C-l>', 'clear', 'Clear alert notifications'],
    ['normal', '<leader><C-r>', 'config_reload', 'Reload configuration'],
  ] satisfies SimpleKeymapTuple[]
).map(([mode, map, command, description]) =>
  glide.keymaps.set(mode, map, command, { description }),
);
