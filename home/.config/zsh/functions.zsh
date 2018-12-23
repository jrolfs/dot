function exists {
  return $(command -v $1 >&/dev/null 2>&1)
}

function mxd {
  tmux rename-window "$(basename $(pwd))"
}


function nix-search {
  nix-env -qa ".*$1.*"
}

function nix-rip {
  rg -g "**/*$1*/**/default.nix" --files --hidden ~/.nix-defexpr/nixpkgs/pkgs
}

function lpwd {
  zstyle -g current-pwd-length ':prezto:module:prompt' pwd-length
}

function skim { nvim $(sk); }
