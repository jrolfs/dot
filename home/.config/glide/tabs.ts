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
    const { id } = await glide.tabs.active()

    assert(id);

    await browser.tabs.duplicate(id);
  },
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

    const argId = arg && /\d+/.test(arg) ? parseInt(arg, 10) : null;
    const id = argId ?? active.id;

    const { pinned } = await browser.tabs.get(id);

    await glide.excmds.execute(pinned ? `tab_unpin ${id}` : `tab_pin ${id}`);
  },
);
// oxfmt-ignore
declare global { interface ExcmdRegistry { tab_pin_toggle: typeof tabPinToggle; } }

const hasId = <T extends { id?: number }>(entity: T): entity is T & { id: number } =>
  typeof entity.id !== 'undefined';

const tabMove = glide.excmds.create(
  {
    name: 'tab_move',
    description: 'Move a ',
  },
  async ({ args_arr: [arg] }) => {
    const { id: tabId } = await glide.tabs.active();

    const move = async (windowId: number) => await browser.tabs.move(tabId, {
      windowId,
      index: 0,

    });

    if (arg === 'list') {
      const windows = await browser.windows.getAll();

      glide.commandline.show({
        options: windows.filter(hasId).map(({ id, title }) => ({
          label: `${id}: ${title}`,
          execute: async () => move(id),
        })),
      });

      return;
    }

    const argId = arg && /\d+/.test(arg) ? parseInt(arg, 10) : null;

    const window = argId
      ? await browser.windows.get(argId)
      : await browser.windows.create();

    const { id: windowId } = window;

    assert(windowId);

    await move(windowId);

    // If we're opening a new window, it opens with an empty tab open to the new
    // tab page by default, but we only want the moved tab in that window
    if (!argId) {
      const emptyTab = window.tabs?.at(-1);

      if (!emptyTab?.id) return;

      await browser.tabs.remove(emptyTab.id);
    }
  },
);
// oxfmt-ignore
declare global { interface ExcmdRegistry { tab_move: typeof tabMove; } }
