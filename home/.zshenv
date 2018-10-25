#
# Options
#

setopt HIST_IGNORE_SPACE

#
# Environment
#

export KEYTIMEOUT=1

# XDG
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"

# Dotfiles
export HOMESHICK_KINGDOM="${HOMESHICK_DIR:-$HOME/.homesick/repos}"
export HS_KINGDOM=$HOMESHICK_KINGDOM

# Go
export GOPATH="${HOME}/Development/Go"

# Git Duet
export GIT_DUET_ROTATE_AUTHOR=1

# GPG/SSH
export SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh"

# FZF
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_TMUX=1
export FZF_TMUX_HEIGHT='50%'

# Nix
export NIXPKGS_ALLOW_UNFREE=1

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"

  path=(
    $HOME/.rbenv/{bin,shims}
    $HOME/.pyenv/{bin,shims}
    $HOME/.nodenv/{bin,shims}
    $HOME/.jenv/{bin,shims}
    $HOME/.emacs.d/bin
    $path
  )

  eval "$(rbenv init -)"
  eval "$(pyenv init -)"
  eval "$(nodenv init -)"
fi
