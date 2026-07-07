/**
 * 1Password autofill for Glide via the `op` CLI.
 *
 * This sidesteps 1Password's native Universal Autofill (which doesn't
 * recognise Glide's bundle id `app.glide-browser.glide`, so URL detection
 * never works) by doing everything ourselves:
 *
 *   1. `op item list` gives us every Login item *with its URLs*, so we match
 *      against the current page host locally — no dependency on 1Password's
 *      hardcoded browser list.
 *   2. A leader key (or the in-field badge) opens a Quick-Access-style menu
 *      built with `glide.commandline`.
 *   3. On selection, `op item get` fetches the credential and we inject it
 *      into the page via `glide.content.execute`.
 *   4. Login fields are decorated with a subtle "halo" + a clickable
 *      1Password badge, re-applied on every navigation.
 *
 * Secrets are only ever fetched lazily (at fill time) and passed straight
 * into the content process — never cached, never logged.
 */

// ---------------------------------------------------------------------------
// Decoration config — tweak the halo/badge appearance here.
//
// NOTE: `applyDecoration` runs in the content process (its body is stringified
// and cannot capture outer variables), so this object is passed in via `args`.
// It is the single source of truth for the visual constants.
// ---------------------------------------------------------------------------

/** Phosphor Icons `password` glyph (weight: fill), tinted at runtime. */
const PASSWORD_ICON_DATA_URL =
  'data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgZmlsbD0iIzAwMDAwMCIgdmlld0JveD0iMCAwIDI1NiAyNTYiPjxwYXRoIGQ9Ik0yMjQsNDhIMzJBMTYsMTYsMCwwLDAsMTYsNjRWMTkyYTE2LDE2LDAsMCwwLDE2LDE2SDIyNGExNiwxNiwwLDAsMCwxNi0xNlY2NEExNiwxNiwwLDAsMCwyMjQsNDhabS0xOS40Miw5NC43MWE4LDgsMCwxLDEtMTMsOS40MUwxODQsMTQxLjYxbC03LjYzLDEwLjUxYTgsOCwwLDEsMS0xMy05LjQxbDcuNjQtMTAuNS0xMi4zNi00YTgsOCwwLDEsMSw1LTE1LjIxTDE3NiwxMTdWMTA0YTgsOCwwLDAsMSwxNiwwdjEzbDEyLjM1LTRhOCw4LDAsMCwxLDUsMTUuMjFsLTEyLjM2LDRabS03MiwwYTgsOCwwLDEsMS0xMyw5LjQxTDExMiwxNDEuNjFsLTcuNjMsMTAuNTFhOCw4LDAsMSwxLTEzLTkuNDFsNy42NC0xMC41LTEyLjM2LTRhOCw4LDAsMSwxLDUtMTUuMjFMMTA0LDExN1YxMDRhOCw4LDAsMCwxLDE2LDB2MTNsMTIuMzUtNGE4LDgsMCwxLDEsNSwxNS4yMWwtMTIuMzYsNFpNNjQsODh2ODBhOCw4LDAsMCwxLTE2LDBWODhhOCw4LDAsMCwxLDE2LDBaIj48L3BhdGg+PC9zdmc+';

interface HaloConfig {
  /** Transparent gap (px) between the input's edge and the halo band. */
  readonly offset: number;
  /** Width (px) of the visible halo band. */
  readonly thickness: number;
  /** `backdrop-filter: blur()` radius (px) applied behind the halo. */
  readonly blurRadius: number;
  /** Halo fill opacity (0–1). */
  readonly opacity: number;
  /** Outer corner radius (px). Inner radius is derived as `outer - thickness`. */
  readonly outerRadius: number;
  /** Extra width (px) the band gains on the right to host the badge. */
  readonly buttonWidth: number;
  /** Halo fill colour (any CSS colour; opacity is applied separately). */
  readonly color: string;
  /** Badge icon tint colour. */
  readonly iconColor: string;
  /** Data URL for the badge icon. */
  readonly iconDataUrl: string;
}

const DECORATION: HaloConfig = {
  offset: 2,
  thickness: 2,
  blurRadius: 3,
  opacity: 0.9,
  outerRadius: 8,
  buttonWidth: 22,
  color: 'rgba(37, 99, 235, 0.14)',
  iconColor: 'rgba(37, 99, 235, 0.95)',
  iconDataUrl: PASSWORD_ICON_DATA_URL,
};

// ---------------------------------------------------------------------------
// `op` CLI integration (main process)
// ---------------------------------------------------------------------------

/** 1Password account shorthands, from `op account list`. */
const ACCOUNTS = ['meter', 'my'] as const;

type Account = (typeof ACCOUNTS)[number];

const ACCOUNT_LABELS: Record<Account, string> = {
  meter: 'Work',
  my: 'Personal',
};

/**
 * Environment for spawned `op` processes.
 *
 * macOS GUI apps don't inherit the shell environment, so `PATH` and the
 * non-standard `OP_CONFIG_DIR` (this repo keeps it in the encrypted `private`
 * kingdom) must be set explicitly. `extend_env` keeps `HOME` etc. so the
 * desktop-app/Touch ID integration still resolves.
 */
const OP_ENV: Record<string, string> = {
  PATH: '/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin',
  OP_CONFIG_DIR: `${glide.path.home_dir}/.homesick/repos/private/home/.config/op`,
};

interface OpUrl {
  readonly label?: string;
  readonly primary?: boolean;
  readonly href: string;
}

interface OpListItem {
  readonly id: string;
  readonly title: string;
  readonly additional_information?: string;
  readonly urls?: readonly OpUrl[];
}

interface OpField {
  readonly id: string;
  readonly label?: string;
  readonly type: string;
  readonly purpose?: string;
  readonly value?: string;
}

interface OpItemDetail {
  readonly id: string;
  readonly title: string;
  readonly fields?: readonly OpField[];
}

/** A list item enriched with its account and normalised hostnames. */
interface IndexedItem extends OpListItem {
  readonly account: Account;
  readonly hosts: readonly string[];
}

/**
 * Run `op` with the given args and return its stdout.
 *
 * Throws (via `check_exit_code`) on a non-zero exit.
 */
const runOp = async (args: readonly string[]): Promise<string> => {
  const proc = await glide.process.execute('op', [...args], {
    env: OP_ENV,
    extend_env: true,
  });

  return await proc.stdout.text();
};

/**
 * Extract the lowercased hostname from an `op` URL `href`, which may be a bare
 * host (`meterdown.com`) or a full URL.
 */
const hostFromHref = (href: string): string => {
  try {
    const withScheme = href.includes('://') ? href : `https://${href}`;

    return new URL(withScheme).hostname.toLowerCase();
  } catch {
    return '';
  }
};

/** Loose host match: exact, or one is a subdomain of the other. */
const hostMatches = (itemHost: string, pageHost: string): boolean => {
  if (!itemHost || !pageHost) return false;
  if (itemHost === pageHost) return true;

  return pageHost.endsWith(`.${itemHost}`) || itemHost.endsWith(`.${pageHost}`);
};

/**
 * In-memory index of Login items across all accounts.
 *
 * Only non-secret metadata (id / title / urls / account) is cached; secrets
 * are fetched lazily at fill time. Cleared by the `op_reload` excmd.
 */
let indexCache: readonly IndexedItem[] | null = null;

const loadIndex = async (force = false): Promise<readonly IndexedItem[]> => {
  if (indexCache && !force) return indexCache;

  const perAccount = await Promise.all(
    ACCOUNTS.map(async (account): Promise<readonly IndexedItem[]> => {
      try {
        const json = await runOp([
          'item',
          'list',
          '--account',
          account,
          '--categories',
          'Login',
          '--format=json',
        ]);
        const items = JSON.parse(json) as readonly OpListItem[];

        return items.map(item => ({
          ...item,
          account,
          hosts: (item.urls ?? [])
            .map(url => hostFromHref(url.href))
            .filter(host => host.length > 0),
        }));
      } catch (error) {
        console.warn(`op-fill: failed to list items for "${account}"`, error);

        return [];
      }
    }),
  );

  indexCache = perAccount.flat();

  return indexCache;
};

const fieldValue = (
  detail: OpItemDetail,
  purpose: 'USERNAME' | 'PASSWORD',
): string | null => {
  const field = (detail.fields ?? []).find(f => f.purpose === purpose);

  return field?.value ?? null;
};

// ---------------------------------------------------------------------------
// Content-process functions
//
// The bodies below are stringified and executed in the page, so they MUST be
// fully self-contained: no references to module-scope variables or helpers.
// Config/credentials arrive via `args`.
// ---------------------------------------------------------------------------

interface FillCredentials {
  readonly username: string | null;
  readonly password: string | null;
}

interface FillOptions {
  readonly submit: boolean;
}

/**
 * Fill the detected login fields on the page and optionally submit.
 *
 * Runs in the content process.
 */
const fillIntoPage = (
  credentials: FillCredentials,
  options: FillOptions,
): void => {
  const isVisible = (element: HTMLElement): boolean => {
    const rect = element.getBoundingClientRect();
    const style = getComputedStyle(element);

    return (
      rect.width > 0 &&
      rect.height > 0 &&
      style.visibility !== 'hidden' &&
      style.display !== 'none'
    );
  };

  const setNativeValue = (element: HTMLInputElement, value: string): void => {
    const descriptor = Object.getOwnPropertyDescriptor(
      HTMLInputElement.prototype,
      'value',
    );
    descriptor?.set?.call(element, value);
    element.dispatchEvent(new Event('input', { bubbles: true }));
    element.dispatchEvent(new Event('change', { bubbles: true }));
  };

  const inputs = Array.from(document.querySelectorAll('input')).filter(
    isVisible,
  );
  const passwordField = inputs.find(
    input => input.type.toLowerCase() === 'password',
  );

  const usernameField = (() => {
    const scope = passwordField?.form
      ? Array.from(passwordField.form.querySelectorAll('input')).filter(
          isVisible,
        )
      : inputs;
    const byAutocomplete = scope.find(input =>
      (input.getAttribute('autocomplete') ?? '')
        .toLowerCase()
        .split(/\s+/)
        .includes('username'),
    );
    if (byAutocomplete) return byAutocomplete;

    const byType = scope.find(input => {
      const type = input.type.toLowerCase();

      return type === 'email' || type === 'text' || type === 'tel';
    });

    return byType ?? null;
  })();

  let filledPassword = false;
  let filledUsername = false;

  if (usernameField && credentials.username) {
    setNativeValue(usernameField, credentials.username);
    filledUsername = true;
  }

  if (passwordField && credentials.password) {
    setNativeValue(passwordField, credentials.password);
    filledPassword = true;
  }

  const shouldSubmit =
    options.submit && (filledPassword || (filledUsername && !passwordField));

  if (!shouldSubmit) return;

  const anchor = passwordField ?? usernameField;
  if (!anchor) return;

  const form = anchor.closest('form');
  if (form) {
    const submitButton = form.querySelector<HTMLElement>(
      'button[type=submit], input[type=submit], button:not([type])',
    );
    if (submitButton) {
      submitButton.click();

      return;
    }
    if (typeof form.requestSubmit === 'function') {
      form.requestSubmit();

      return;
    }
    form.submit();

    return;
  }

  const keyInit: KeyboardEventInit = {
    key: 'Enter',
    code: 'Enter',
    keyCode: 13,
    which: 13,
    bubbles: true,
  };
  anchor.dispatchEvent(new KeyboardEvent('keydown', keyInit));
  anchor.dispatchEvent(new KeyboardEvent('keyup', keyInit));
};

/**
 * Install (idempotently) the field decorations: a masked "halo" band around
 * each login field that widens on the right into a clickable 1Password badge.
 *
 * Runs in the content process; re-invoked on every navigation. Config arrives
 * via `args` since the body cannot capture module scope.
 */
const applyDecoration = (config: HaloConfig): void => {
  const LAYER_ID = 'op-fill-layer';
  const innerRadius = Math.max(0, config.outerRadius - config.thickness);

  const stateWindow = window as unknown as {
    __opFillRescan?: () => void;
  };

  const isVisible = (element: HTMLElement): boolean => {
    const rect = element.getBoundingClientRect();
    const style = getComputedStyle(element);

    return (
      rect.width > 0 &&
      rect.height > 0 &&
      style.visibility !== 'hidden' &&
      style.display !== 'none'
    );
  };

  const findLoginInputs = (): HTMLInputElement[] => {
    const inputs = Array.from(document.querySelectorAll('input')).filter(
      isVisible,
    );
    const passwordForms = new Set(
      inputs
        .filter(input => input.type.toLowerCase() === 'password')
        .map(input => input.form)
        .filter((form): form is HTMLFormElement => form !== null),
    );

    return inputs.filter(input => {
      const type = input.type.toLowerCase();
      if (type === 'password') return true;

      const autocomplete = (input.getAttribute('autocomplete') ?? '')
        .toLowerCase()
        .split(/\s+/);
      if (autocomplete.includes('username')) return true;

      const isTextLike = type === 'email' || type === 'text';

      return isTextLike && input.form !== null && passwordForms.has(input.form);
    });
  };

  const holeMaskUrl = (holeWidth: number, holeHeight: number): string => {
    const svg =
      `<svg xmlns='http://www.w3.org/2000/svg' width='${holeWidth}' ` +
      `height='${holeHeight}'><rect x='0' y='0' width='${holeWidth}' ` +
      `height='${holeHeight}' rx='${innerRadius}' ry='${innerRadius}' ` +
      `fill='black'/></svg>`;

    return `data:image/svg+xml,${encodeURIComponent(svg)}`;
  };

  interface Decoration {
    readonly halo: HTMLDivElement;
    readonly frame: HTMLDivElement;
    readonly button: HTMLDivElement;
    lastKey: string;
  }

  const layer = (() => {
    const existing = document.getElementById(LAYER_ID);
    if (existing instanceof HTMLDivElement) return existing;

    const created = document.createElement('div');
    created.id = LAYER_ID;
    Object.assign(created.style, {
      position: 'fixed',
      inset: '0',
      pointerEvents: 'none',
      zIndex: '2147483646',
    } satisfies Partial<CSSStyleDeclaration>);
    (document.body ?? document.documentElement).appendChild(created);

    return created;
  })();

  const tracked = new Map<HTMLInputElement, Decoration>();

  const createDecoration = (): Decoration => {
    const halo = document.createElement('div');
    halo.setAttribute('data-op-fill-halo', '');
    Object.assign(halo.style, {
      position: 'absolute',
      pointerEvents: 'none',
    } satisfies Partial<CSSStyleDeclaration>);

    const frame = document.createElement('div');
    Object.assign(frame.style, {
      position: 'absolute',
      inset: '0',
      backgroundColor: config.color,
      opacity: String(config.opacity),
      backdropFilter: `blur(${config.blurRadius}px)`,
      borderRadius: `${config.outerRadius}px`,
      maskComposite: 'exclude',
      maskRepeat: 'no-repeat, no-repeat',
    } satisfies Partial<CSSStyleDeclaration>);

    const button = document.createElement('div');
    button.setAttribute('data-op-fill-button', '');
    button.setAttribute('role', 'button');
    button.setAttribute('aria-label', 'Fill with 1Password');
    Object.assign(button.style, {
      position: 'absolute',
      pointerEvents: 'auto',
      cursor: 'pointer',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
    } satisfies Partial<CSSStyleDeclaration>);

    const icon = document.createElement('div');
    Object.assign(icon.style, {
      width: '70%',
      height: '70%',
      backgroundColor: config.iconColor,
      maskImage: `url("${config.iconDataUrl}")`,
      maskRepeat: 'no-repeat',
      maskPosition: 'center',
      maskSize: 'contain',
    } satisfies Partial<CSSStyleDeclaration>);
    button.appendChild(icon);

    halo.appendChild(frame);
    halo.appendChild(button);

    return { halo, frame, button, lastKey: '' };
  };

  const syncOne = (input: HTMLInputElement, deco: Decoration): void => {
    const rect = input.getBoundingClientRect();
    const { offset, thickness, buttonWidth } = config;

    const holeWidth = rect.width + offset * 2;
    const holeHeight = rect.height + offset * 2;
    const outerWidth = holeWidth + thickness * 2 + buttonWidth;
    const outerHeight = holeHeight + thickness * 2;

    Object.assign(deco.halo.style, {
      left: `${rect.left - offset - thickness}px`,
      top: `${rect.top - offset - thickness}px`,
      width: `${outerWidth}px`,
      height: `${outerHeight}px`,
    } satisfies Partial<CSSStyleDeclaration>);

    const key = `${Math.round(holeWidth)}x${Math.round(holeHeight)}`;
    if (key !== deco.lastKey) {
      deco.lastKey = key;
      // First mask layer fills the whole frame; the second punches out the
      // input-shaped hole (composited with `exclude`), leaving the band + the
      // wider right region that hosts the badge.
      deco.frame.style.maskImage = `linear-gradient(black, black), url("${holeMaskUrl(holeWidth, holeHeight)}")`;
      deco.frame.style.maskPosition = `0 0, ${thickness}px ${thickness}px`;
      deco.frame.style.maskSize = `100% 100%, ${holeWidth}px ${holeHeight}px`;
    }

    Object.assign(deco.button.style, {
      left: `${thickness + holeWidth}px`,
      top: `${thickness}px`,
      width: `${thickness + buttonWidth}px`,
      height: `${holeHeight}px`,
    } satisfies Partial<CSSStyleDeclaration>);
  };

  const sync = (): void => {
    tracked.forEach((deco, input) => syncOne(input, deco));
  };

  const rescan = (): void => {
    const current = new Set(findLoginInputs());

    tracked.forEach((deco, input) => {
      if (!current.has(input) || !document.contains(input)) {
        deco.halo.remove();
        tracked.delete(input);
      }
    });

    current.forEach(input => {
      if (tracked.has(input)) return;

      const deco = createDecoration();
      layer.appendChild(deco.halo);
      tracked.set(input, deco);
    });

    sync();
  };

  // Already installed on this document — just re-scan for new/removed fields.
  if (stateWindow.__opFillRescan) {
    stateWindow.__opFillRescan();

    return;
  }

  let frame = 0;
  const schedule = (task: () => void): void => {
    cancelAnimationFrame(frame);
    frame = requestAnimationFrame(task);
  };

  window.addEventListener('scroll', () => schedule(sync), {
    capture: true,
    passive: true,
  });
  window.addEventListener('resize', () => schedule(sync), { passive: true });

  const resizeObserver = new ResizeObserver(() => schedule(sync));
  const mutationObserver = new MutationObserver(() => schedule(rescan));
  mutationObserver.observe(document.documentElement, {
    childList: true,
    subtree: true,
  });

  const trackedRescan = (): void => {
    rescan();
    tracked.forEach((_deco, input) => resizeObserver.observe(input));
  };

  stateWindow.__opFillRescan = trackedRescan;
  trackedRescan();
};

// ---------------------------------------------------------------------------
// Menu (main process)
// ---------------------------------------------------------------------------

interface OpFillMessages {
  readonly op_fill_requested: null;
}

const accountChip = (account: Account): HTMLElement =>
  DOM.create_element('span', {
    style: {
      fontSize: '0.7em',
      textTransform: 'uppercase',
      letterSpacing: '0.05em',
      opacity: '0.6',
      flexShrink: '0',
    },
    children: [ACCOUNT_LABELS[account]],
  });

const itemOption = (
  item: IndexedItem,
  tab: glide.TabWithID,
  options: FillOptions,
): glide.CommandLineCustomOption => {
  const username = item.additional_information ?? '';

  return {
    label: item.title,
    description: username,
    render: () =>
      DOM.create_element('div', {
        style: {
          display: 'flex',
          alignItems: 'center',
          gap: '8px',
          width: '100%',
        },
        children: [
          accountChip(item.account),
          DOM.create_element('span', {
            style: {
              flexShrink: '1',
              overflow: 'hidden',
              textOverflow: 'ellipsis',
              whiteSpace: 'nowrap',
            },
            children: [item.title],
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
            children: [username],
          }),
        ],
      }),
    matches: ({ input }) => {
      if (!input) return true;

      const lower = input.toLowerCase();

      return (
        item.title.toLowerCase().includes(lower) ||
        username.toLowerCase().includes(lower)
      );
    },
    execute: async () => {
      await fillFromItem(item, tab, options);
    },
  };
};

/** Fetch the selected item's credential and inject it into the page. */
const fillFromItem = async (
  item: IndexedItem,
  tab: glide.TabWithID,
  options: FillOptions,
): Promise<void> => {
  try {
    const detail = JSON.parse(
      await runOp([
        'item',
        'get',
        item.id,
        '--account',
        item.account,
        '--format=json',
      ]),
    ) as OpItemDetail;

    const password = fieldValue(detail, 'PASSWORD');
    const credentials: FillCredentials = {
      username: fieldValue(detail, 'USERNAME'),
      password,
    };

    // Passwordless (SSO) items can't be auto-submitted — fall back to filling
    // the username only, never submitting.
    const submit = options.submit && password !== null;

    await glide.content.execute(fillIntoPage, {
      tab_id: tab.id,
      args: [credentials, { submit }],
    });
  } catch (error) {
    console.error('op-fill: failed to fill item', error);
  }
};

/** Build and show the item picker for the active tab's host. */
const openMenu = async (
  tab: glide.TabWithID,
  options: FillOptions,
): Promise<void> => {
  const pageHost = glide.ctx.url.hostname.toLowerCase();
  const index = await loadIndex();
  const matches = index.filter(item =>
    item.hosts.some(host => hostMatches(host, pageHost)),
  );
  const showAll = matches.length === 0;
  const items = showAll ? index : matches;

  if (items.length === 0) {
    await glide.commandline.show({
      title: '1Password',
      options: [
        {
          label: 'No 1Password items found',
          description: 'Check the `op` CLI / Touch ID, then :op_reload',
          execute: () => {},
        },
      ],
    });

    return;
  }

  await glide.commandline.show({
    title: showAll
      ? '1Password — no host match, showing all'
      : `1Password — ${pageHost}`,
    options: items.map(item => itemOption(item, tab, options)),
  });
};

// ---------------------------------------------------------------------------
// Wiring: excmds, badge-click bridge, and per-navigation decoration
// ---------------------------------------------------------------------------

/** Content → main bridge for badge clicks (the only direction Glide allows). */
const fillMessenger = glide.messengers.create<OpFillMessages>(message => {
  if (message.name !== 'op_fill_requested') return;

  void (async () => {
    const tab = await glide.tabs.active();
    await openMenu(tab, { submit: true });
  })();
});

const opFill = glide.excmds.create(
  { name: 'op_fill', description: 'Autofill from 1Password (fill + submit)' },
  async () => {
    const tab = await glide.tabs.active();
    await openMenu(tab, { submit: true });
  },
);
// oxfmt-ignore
declare global { interface ExcmdRegistry { op_fill: typeof opFill; } }

const opFillNoSubmit = glide.excmds.create(
  {
    name: 'op_fill_no_submit',
    description: 'Autofill from 1Password (fill only, no submit)',
  },
  async () => {
    const tab = await glide.tabs.active();
    await openMenu(tab, { submit: false });
  },
);
// oxfmt-ignore
declare global { interface ExcmdRegistry { op_fill_no_submit: typeof opFillNoSubmit; } }

const opReload = glide.excmds.create(
  { name: 'op_reload', description: 'Reload the cached 1Password item index' },
  async () => {
    await loadIndex(true);
  },
);
// oxfmt-ignore
declare global { interface ExcmdRegistry { op_reload: typeof opReload; } }

// Re-apply decorations and (idempotently) wire badge clicks on every
// navigation. Injection fails on non-web pages (about:, view-source:); ignore.
glide.autocmds.create('UrlEnter', /.*/, ({ tab_id }) => {
  void glide.content
    .execute(applyDecoration, { tab_id, args: [DECORATION] })
    .catch(() => {});

  fillMessenger.content.execute(
    messenger => {
      const wiredWindow = window as unknown as { __opFillClickWired?: boolean };
      if (wiredWindow.__opFillClickWired) return;
      wiredWindow.__opFillClickWired = true;

      document.addEventListener(
        'click',
        event => {
          const target = event.target as Element | null;
          if (!target?.closest('[data-op-fill-button]')) return;

          event.preventDefault();
          event.stopPropagation();
          messenger.send('op_fill_requested');
        },
        true,
      );
    },
    { tab_id },
  );
});
