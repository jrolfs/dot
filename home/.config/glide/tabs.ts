const ddg = glide.excmds.create(
  {
    name: 'ddg',
    description: 'Search DuckDuckGo in a new tab',
  },
  async ({ args_arr }) => {
    const query = args_arr.join(' ');
    const params = new URLSearchParams({ q: query, t: 'ffab', ia: 'web' });
    const url = `https://duckduckgo.com/?${params}`;

    await browser.tabs.create({ url });
  },
);

declare global {
  interface ExcmdRegistry {
    ddg: typeof ddg;
  }
}
