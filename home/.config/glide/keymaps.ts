// Commands

glide.keymaps.set(
  "command",
  "<C-n>",
  "commandline_focus_next",
);
glide.keymaps.set(
  "command",
  "<C-p>",
  "commandline_focus_back",
);



//
// Tabs

/**
 * Toggle tab pinning
 */
glide.keymaps.set(
  'normal',
  '<C-S-p>',
  async () => {
    const { pinned } = await glide.tabs.active();

    await glide.excmds.execute(pinned ? 'tab_unpin' : 'tab_pin');
  },
  { description: 'Toggle pinned state of the current tab' },
);

//
// Glide

/**
 * Clear alert notifications
 */
glide.keymaps.set(
  'normal',
  '<C-l>',
  async () => glide.excmds.execute('clear'),
  { description: 'Clear alert notifications' },
);

/**
 * Reload configuration
 */
glide.keymaps.set(
  'normal',
  '<C-r>',
  async () => glide.excmds.execute('config_reload'),
  { description: 'Reload configuration' },
);
