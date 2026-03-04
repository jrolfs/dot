/**
 * Documentation: https://glide-browser.app/config
 * Reference: https://glide-browser.app/api
 * Defaults configuration: https://github.com/glide-browser/glide/tree/main/src/glide/browser/base/content/plugins
 * Default keymappings: https://github.com/glide-browser/glide/blob/main/src/glide/browser/base/content/plugins/keymaps.mts
 */

//
// Bindings

glide.keymaps.set(
  'normal',
  'gt',
  async () => {
    const tab = await glide.tabs.get_first({
      url: 'example.com',
    });

    assert(tab && tab.id);

    await browser.tabs.update(tab.id, { active: true });
  },
  { description: '[g]o to example.com' },
);

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

//
// Block Google Popup

const GOOGLE_SIGNIN_ALLOW = [
  'accounts.google.com',
  'mail.google.com',
] as const satisfies string[];

const isGoogleSigninAllowed = (url: string): boolean => {
  try {
    const host = new URL(url).hostname.toLowerCase();

    return GOOGLE_SIGNIN_ALLOW.some(
      allowed => host === allowed || host.endsWith('.' + allowed),
    );
  } catch {
    return false;
  }
};

browser.webRequest.onBeforeRequest.addListener(
  async details => {
    // not in a tab, allow request
    if (details.tabId === -1) return {};

    try {
      const tab = await browser.tabs.get(details.tabId);

      if (isGoogleSigninAllowed(tab.url ?? '')) return {};

      return { cancel: true };
    } catch {
      return {};
    }
  },
  {
    urls: ['*://accounts.google.com/gsi/*'],
    types: ['script'],
  },
  ['blocking'],
);
