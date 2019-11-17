
#
# "DNTW"
# See: https://github.com/joshdick/dntw
# If you need to bypass this function and run the real `nvim`
# for some reason, just run `command nvim` instead.
function nvim () {
  if [[ "$TERM_PROGRAM" == "vscode" ]]; then
    # If we typed "nvim" while inside the integrated Visual Studio Code terminal,
    # open the file in Code instead.
    code "$@"
  else
    # Invoke `dntw_edit` with an explicit `$DNTW_NVIM_CMD` since this function's
    # name conflicts with the real `nvim`.
    DNTW_NVIM_CMD=/run/current-system/sw/bin/nvim dntw_edit "$@"
  fi
}

function ct {
  cat $1 && echo '\r'
}

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

function add-fork {
  local source_remote=${1:-upstream}
  local source_url=$(git remote get-url $source_remote)

  local target_user=${2:-jrolfs}
  local target_remote=${3:-origin}

  local target_url=$(sed "s/:.*\//:$target_user\//" <<< $source_url)

  git remote add $target_remote $target_url
}

unset exists
