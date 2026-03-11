const zoom = glide.excmds.create(
  {
    name: 'zoom',
    description: 'Set the default zoom',
  },
  async ({ args_arr: args }) => {
    console.log('ZOOM')
  },
);
// oxfmt-ignore
declare global { interface ExcmdRegistry { ddg: typeof zoom; } }
