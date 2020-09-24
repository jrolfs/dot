
function exists {
  return $(command -v $1 >&/dev/null 2>&1)
}

function mxd {
  tmux rename-window "$(basename $(pwd))"
}

function nix-rip {
  rg -g "**/*$1*/**/default.nix" --files --hidden ~/.nix-defexpr/nixpkgs/pkgs
}

function lpwd {
  zstyle -g current-pwd-length ':prezto:module:prompt' pwd-length
}

function skim { nvim $(sk); }

function add-fork {
  local source_remote=${1:-upstream}
  local source_url=$(git remote get-url $source_remote)

  local target_user=${2:-jrolfs}
  local target_remote=${3:-origin}

  local target_url=$(sed "s/:.*\//:$target_user\//" <<< $source_url)

  git remote add $target_remote $target_url
}

unset exists
