# GnuPG
alias gty="gpg-connect-agent updatestartuptty /bye"

# Editors
alias vi=nvim
alias vim=nvim

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

unset -f exists # ¯\_(ツ)_/¯

# Homeshick
alias hs=homeshick

# Fasd
alias jj="fasd_cd -tdi"

# Git
alias gl1="git log --pretty=oneline"
