# GnuPG
alias gty="gpg-connect-agent updatestartuptty /bye"

# Editors
alias vi=nvim
alias vim=nvim

# homeshick
alias hs=homeshick

# fasd
alias jj="fasd_cd -tdi"

# Git
alias gl1="git log --pretty=oneline"

function exists {
  return $(command -v $1 >&/dev/null 2>&1)
}

if exists 'code-insiders'; then
  exists 'code' && alias code-stable=code
  alias code=code-insiders
fi

# tmux
function mxd {
  tmux rename-window "$(basename $(pwd))"
}

function lpwd {
  zstyle -g current-pwd-length ':prezto:module:prompt' pwd-length
}


unset -f exists # ¯\_(ツ)_/¯
