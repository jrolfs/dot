/**
 * @typedef {{
 *   version: string;
 *   colors: string[];
 *   name: string;
 *   appearance: 'light' | 'dark';
 * }} Options
 */

/**
 * Generate a Raycast theme URL from the provided options
 *
 * @example
 * ```js
 * generateThemeUrl({
 *   name: 'Chill Theme',
 *   version: '1',
 *   colors: [
 *    '#303446'
 *    // ...
 *   ]
 * });
 *
 * // output
 * // https://themes.ray.so/?version=1&name=Catppuccin%20Frappe&appearance=dark&colors=%23303446FF,...
 * ```
 *
 * @param {Options} options
 */
export const generateThemeUrl = ({ version, colors, name, appearance }) => {
  const base = 'https://themes.ray.so/';

  const params = new URLSearchParams({
    version,
    colors: colors.join(','),
    name,
    appearance
  });

  return `${base}?${params.toString()}`;
}
