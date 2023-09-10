import { generateThemeUrl } from "./helpers.mjs";

const colors = [
  "#303446",
  "#303446",
  "#C6D0F5",
  "#737994",
  "#838BA7",
  "#E78284",
  "#EF9F76",
  "#E5C890",
  "#A6D189",
  "#8CAAEE",
  "#BABBF1",
  "#CA9EE6",
];

console.log(
  generateThemeUrl({
    name: "Catppuccin Frappe",
    version: "1",
    colors,
    appearance: "dark",
  })
);
