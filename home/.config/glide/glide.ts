// Config docs:
//
//   https://glide-browser.app/config
//
// API reference:
//
//   https://glide-browser.app/api
//
// Default config files can be found here:
//
//   https://github.com/glide-browser/glide/tree/main/src/glide/browser/base/content/plugins
//
// Most default keymappings are defined here:
//
//   https://github.com/glide-browser/glide/blob/main/src/glide/browser/base/content/plugins/keymaps.mts
//
// Try typing `glide.` and see what you can do!

glide.keymaps.set(
  "normal",
  "gt",
  async () => {
    const tab = await glide.tabs.get_first({
      url: "example.com",
    });
    assert(tab && tab.id);
    await browser.tabs.update(tab.id, { active: true });
  },
  { description: "[g]o to example.com" },
);

glide.keymaps.set(
  "normal",
  "<C-S-p>",
  async () => {
    const { pinned } = await glide.tabs.active();
    await glide.excmds.execute(pinned ? "tab_unpin" : "tab_pin");
  },
  { description: "Toggle pinned state of the current tab" },
);
