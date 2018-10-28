
# Helper to check existence of a command
function exists {
  return $(command -v $1 >&/dev/null 2>&1)
}


#
# Aliases

alias gty="gpg-connect-agent updatestartuptty /bye"

alias vi=nvim
alias vim=nvim

alias hs=homeshick

alias jj="fasd_cd -tdi"

alias gl1="git log --pretty=oneline"

if exists 'code-insiders'; then
  exists 'code' && alias code-stable=code
  alias code=code-insiders
fi


#
# Functions

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


# Clean up `exists` helper
unset -f exists # ¯\_(ツ)_/¯
