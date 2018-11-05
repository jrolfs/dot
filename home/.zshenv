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
export ZSH_EXTRA_COMPLETIONS="${XDG_CONFIG_HOME}/zsh/completions"

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

# *env
export JENV_ROOT="${XDG_DATA_HOME}/jenv"
export NODENV_ROOT="${XDG_DATA_HOME}/nodenv"
export PYENV_ROOT="${XDG_DATA_HOME}/pyenv"
export RBENV_ROOT="${XDG_DATA_HOME}/rbenv"

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"

  path=(
    $RBENV_ROOT/{bin,shims}
    $PYENV_ROOT/{bin,shims}
    $NODENV_ROOT/{bin,shims}
    $JENV_ROOT/{bin,shims}
    $HOME/.emacs.d/bin
    $path
  )

  eval "$(rbenv init -)"
  eval "$(pyenv init -)"
  eval "$(nodenv init -)"
fi
