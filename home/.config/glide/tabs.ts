const duckDuckGo = glide.excmds.create(
  {
    name: 'ddg',
    description: 'Search DuckDuckGo in a new tab',
  },
  async ({ args_arr: args }) => {
    const query = args.join(' ');
    const params = new URLSearchParams({ q: query, t: 'ffab', ia: 'web' });
    const url = `https://duckduckgo.com/?${params}`;

    await browser.tabs.create({ url });
  },
);
// oxfmt-ignore
declare global { interface ExcmdRegistry { ddg: typeof duckDuckGo; } }

const tabDuplicate = glide.excmds.create(
  {
    name: 'tab_duplicate',
    description: 'Duplicate the active tab',
  },
  async () => {
    const { id } = await browser.tabs.getCurrent();

    assert(id);

    await browser.tabs.duplicate(id);
  }
);
// oxfmt-ignore
declare global { interface ExcmdRegistry { tab_duplicate: typeof tabDuplicate; } }

const tabPinToggle = glide.excmds.create(
  {
    name: 'tab_pin_toggle',
    description: 'Pin or unpin a tab depending on its current state',
  },
  async ({ args_arr: [arg] }) => {
    const active = await glide.tabs.active();

    const argsId = arg && /\d+/.test(arg) ? parseInt(arg, 10) : null;
    const id = argsId ?? active.id;

    const { pinned } = await browser.tabs.get(id);

    await glide.excmds.execute(pinned ? `tab_unpin ${id}` : `tab_pin ${id}`);
  }
);
// oxfmt-ignore
declare global { interface ExcmdRegistry { tab_pin_toggle: typeof tabPinToggle; } }
