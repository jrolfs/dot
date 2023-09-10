import { generateThemeUrl } from "./helpers.mjs";

const colors = [
  "#32302f",
  "#32302f",
  "#d4be98",
  "#7c6f64",
  "#928374",
  "#ea6962",
  "#e78a4e",
  "#d8a657",
  "#a9b665",
  "#89b482",
  "#7daea3",
  "#d3869b",
];

console.log(
  generateThemeUrl({
    name: "Gruvbox Material Dark Soft",
    version: "1",
    colors,
    appearance: "dark",
  })
);
