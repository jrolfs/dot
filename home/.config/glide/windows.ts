const windowClose = glide.excmds.create(
  {
    name: 'window_close',
    description: `
      Close the active window along with all the tabs in it (not to be
      confused with ⌘ + w, which only closes the current tab on macOS)
    `,
  },
  async () => {
    const window = await browser.windows.getCurrent();

    assert(window.id);

    await browser.windows.remove(window.id);
  },
);
// oxfmt-ignore
declare global { interface ExcmdRegistry { window_close: typeof windowClose; } }
