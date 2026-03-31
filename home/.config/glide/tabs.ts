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
    const { id } = await glide.tabs.active();

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

const hasId = <T extends { id?: number }>(
  entity: T,
): entity is T & { id: number } => typeof entity.id !== 'undefined';

const truncate = (value: string, length: number) =>
  value.length > length ? `${value}…` : value;

const tabMove = glide.excmds.create(
  {
    name: 'tab_move',
    description: 'Move a ',
  },
  async ({ args_arr: [arg] }) => {
    const { id: tabId } = await glide.tabs.active();

    const move = async (windowId: number, index: number = -1) =>
      await browser.tabs.move(tabId, {
        windowId,
        index,
      });

    // Interactive list

    if (arg === 'list') {
      const windows = await browser.windows.getAll();

      glide.commandline.show({
        options: windows.filter(hasId).map(({ id, title, tabs }) => ({
          label: `${id}: ${title} ${tabs
            ?.map(t => t.title)
            .filter(Boolean)
            .map(title => `⎡${truncate(title, 15)}⎤`)
            .join('')}`,
          execute: async () => move(id),
        })),
      });

      return;
    }

    // Target window ID

    const argId = arg && /\d+/.test(arg) ? parseInt(arg, 10) : null;

    if (argId) {
      const { id } = await browser.windows.get(argId);

      assert(id);
      await move(id);

      return;
    }

    // New window

    const window = await browser.windows.create();
    const { id } = window;

    assert(id);
    await move(id, 1);

    // When opening a new window, it opens with an empty tab open to the new
    // tab page by default, but we only want the moved tab in that window
    const emptyId = window.tabs?.at(-1)?.id;

    if (typeof emptyId !== 'number') return;

    await browser.tabs.remove(emptyId);
  },
);
// oxfmt-ignore
declare global { interface ExcmdRegistry { tab_move: typeof tabMove; } }

const formatGroup = (group: Browser.TabGroups.TabGroup): string => {
  const title = group.title || '(untitled)';
  const state = group.collapsed ? 'collapsed' : 'expanded';

  return `${group.id}: [${group.color}] ${title} (${state})`;
};

const tabGroupMove = glide.excmds.create(
  {
    name: 'tab_group_move',
    description: 'Move the active tab into a tab group',
  },
  async ({ args_arr: [arg] }) => {
    const { id: tabId } = await glide.tabs.active();

    const addToGroup = async (groupId: number) =>
      await browser.tabs.group({ tabIds: tabId, groupId });

    // Interactive list

    if (arg === 'list') {
      const groups = await browser.tabGroups.query({});

      glide.commandline.show({
        title: 'tab groups',
        options: [
          ...groups.map((group) => ({
            label: formatGroup(group),
            execute: async () => addToGroup(group.id),
          })),
          {
            label: '+ New group',
            description: 'Create a new group with this tab',
            execute: async ({ input }) => {
              const groupId = await browser.tabs.group({ tabIds: tabId });

              if (input.trim()) {
                await browser.tabGroups.update(groupId, { title: input.trim() });
              }
            },
          },
        ],
      });

      return;
    }

    // Target group ID

    const argId = arg && /\d+/.test(arg) ? parseInt(arg, 10) : null;

    if (argId) {
      await addToGroup(argId);

      return;
    }

    // No argument — create a new group

    await browser.tabs.group({ tabIds: tabId });
  },
);
// oxfmt-ignore
declare global { interface ExcmdRegistry { tab_group_move: typeof tabGroupMove; } }

const tabGroupRename = glide.excmds.create(
  {
    name: 'tab_group_rename',
    description: 'Rename the group the active tab belongs to',
  },
  async ({ args_arr: args }) => {
    const { groupId } = await glide.tabs.active();

    if (!groupId || groupId === browser.tabGroups.TAB_GROUP_ID_NONE) {
      console.warn('Active tab is not in a group');

      return;
    }

    const newTitle = args.join(' ');

    // Interactive — show commandline pre-filled with current title

    if (!newTitle) {
      const group = await browser.tabGroups.get(groupId);

      glide.commandline.show({
        input: group.title ?? '',
        title: 'rename group',
        options: [
          {
            label: `Current: ${group.title || '(untitled)'}`,
            matches: () => true,
            execute: async ({ input }) => {
              await browser.tabGroups.update(groupId, { title: input.trim() });
            },
          },
        ],
      });

      return;
    }

    await browser.tabGroups.update(groupId, { title: newTitle });
  },
);
// oxfmt-ignore
declare global { interface ExcmdRegistry { tab_group_rename: typeof tabGroupRename; } }

const tabGroupCollapseToggle = glide.excmds.create(
  {
    name: 'tab_group_collapse_toggle',
    description: 'Toggle collapse/expand of the active tab group',
  },
  async () => {
    const { groupId } = await glide.tabs.active();

    if (!groupId || groupId === browser.tabGroups.TAB_GROUP_ID_NONE) {
      console.warn('Active tab is not in a group');

      return;
    }

    const { collapsed } = await browser.tabGroups.get(groupId);

    await browser.tabGroups.update(groupId, { collapsed: !collapsed });
  },
);
// oxfmt-ignore
declare global { interface ExcmdRegistry { tab_group_collapse_toggle: typeof tabGroupCollapseToggle; } }

const tabOption = (
  tab: Browser.Tabs.Tab & { id: number },
  isOtherWindow: boolean,
): glide.CommandLineCustomOption => {
  const title = tab.title ?? '';
  const url = tab.url ?? '';
  const indicator = tab.active ? '*' : tab.pinned ? 'P' : '';

  return {
    label: title,
    description: url,
    render: () =>
      DOM.create_element('div', {
        style: {
          display: 'flex',
          alignItems: 'center',
          gap: '8px',
          width: '100%',
        },
        children: [
          DOM.create_element('span', {
            style: { width: '12px', flexShrink: '0', textAlign: 'center' },
            children: [indicator],
          }),
          ...(tab.favIconUrl
            ? [
                DOM.create_element('img', {
                  src: tab.favIconUrl,
                  style: { width: '16px', height: '16px', flexShrink: '0' },
                }),
              ]
            : [
                DOM.create_element('span', {
                  style: { width: '16px', flexShrink: '0' },
                }),
              ]),
          DOM.create_element('span', {
            style: {
              flexShrink: '1',
              overflow: 'hidden',
              textOverflow: 'ellipsis',
              whiteSpace: 'nowrap',
            },
            children: [title],
          }),
          DOM.create_element('span', {
            style: {
              marginLeft: 'auto',
              opacity: '0.5',
              flexShrink: '1',
              overflow: 'hidden',
              textOverflow: 'ellipsis',
              whiteSpace: 'nowrap',
            },
            children: [url],
          }),
        ],
      }),
    matches: ({ input }) => {
      if (!input) return true;

      const lower = input.toLowerCase();

      return (
        title.toLowerCase().includes(lower) || url.toLowerCase().includes(lower)
      );
    },
    execute: async () => {
      await browser.tabs.update(tab.id, { active: true });

      if (isOtherWindow && tab.windowId) {
        await browser.windows.update(tab.windowId, { focused: true });
      }
    },
  };
};

const windowDivider = (
  window: Browser.Windows.Window,
  isCurrent: boolean,
): glide.CommandLineCustomOption => ({
  label: '',
  matches: ({ input }) => !input,
  execute: () => {},
  render: () =>
    DOM.create_element('div', {
      style: {
        display: 'flex',
        alignItems: 'center',
        gap: '8px',
        padding: '2px 0',
        opacity: '0.5',
        fontSize: '0.85em',
      },
      children: [
        DOM.create_element('span', {
          children: [
            `Window ${window.id}${isCurrent ? ' (current)' : ''}`,
          ],
        }),
        DOM.create_element('hr', {
          style: { flex: '1', border: 'none', borderTop: '1px solid currentColor', opacity: '0.3' },
        }),
      ],
    }),
});

const tabSearchAll = glide.excmds.create(
  {
    name: 'tab_search_all',
    description: 'Fuzzy search across all tabs in all windows',
  },
  async () => {
    const [allTabs, currentWindow] = await Promise.all([
      browser.tabs.query({}),
      browser.windows.getCurrent(),
    ]);

    const tabsByWindow = Map.groupBy(allTabs.filter(hasId), (tab) => tab.windowId);

    const options = [...tabsByWindow.entries()].flatMap(
      ([windowId, tabs]) => {
        const isCurrent = windowId === currentWindow.id;
        const window = { id: windowId } as Browser.Windows.Window;

        return [
          windowDivider(window, isCurrent),
          ...tabs.map((tab) => tabOption(tab, !isCurrent)),
        ];
      },
    );

    glide.commandline.show({ title: 'tabs (all windows)', options });
  },
);
// oxfmt-ignore
declare global { interface ExcmdRegistry { tab_search_all: typeof tabSearchAll; } }
