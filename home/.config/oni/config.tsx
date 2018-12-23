import * as React from "react";
import * as Oni from "oni-api";

export const activate = (oni: Oni.Plugin.Api) => {
  console.log("config activated");
};

export const deactivate = (oni: Oni.Plugin.Api) => {
  console.log("config deactivated");
};

export const configuration = {
  "oni.useDefaultConfig": false,
  "oni.loadInitVim": true,

  "oni.useExternalPopupMenu": true,

  "oni.hideMenu": false,

  "oni.exclude": ["**/node_modules/**"],
  "oni.bookmarks": [],

  "editor.backgroundOpacity": 1.0,
  "editor.backgroundImageUrl": null,
  "editor.backgroundImageSize": "initial",

  "editor.clipboard.enabled": false,

  "editor.renderer": "canvas",
  "editor.split.mode": "oni",

  "editor.quickInfo.enabled": true,
  "editor.quickInfo.delay": 500,

  "editor.completions.enabled": true,
  "editor.errors.slideOnFocus": true,
  "editor.formatting.formatOnSwitchToNormalMode": false,

  "editor.fontLigatures": true,
  "editor.fontSize": "13px",
  "editor.fontFamily": "Operator Mono SSm Lig",

  "editor.quickOpen.execCommand": null,

  "editor.scrollBar.visible": false,

  "editor.fullScreenOnStart": false,

  "editor.cursorLine": true,
  "editor.cursorLineOpacity": 0.1,

  "editor.cursorColumn": false,
  "editor.cursorColumnOpacity": 0.1,

  "environment.additionalPaths": [],

  "statusbar.enabled": false,

  "tabs.enabled": true,
  "tabs.showVimTabs": true
};
