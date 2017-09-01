#
# Options
#

setopt HIST_IGNORE_SPACE

#
# Environment
#

# XDG
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CONFIG_HOME="${HOME}/.config"

# Go
export GOPATH="${HOME}/Development/Go"

# Git Duet
export GIT_DUET_ROTATE_AUTHOR=1

# GPG/SSH
export SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh"

# FZF
export FZF_DEFAULT_COMMAND='ag --ignore .git -g ""'

# Nix
export NIXPKGS_ALLOW_UNFREE=1


# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  path+=(
    $HOME/.rbenv/{bin,shims}
    $HOME/.pyenv/{bin,shims}
    $HOME/.nodenv/{bin,shims}
    $HOME/.jenv/{bin,shims}
  )

  eval "$(rbenv init -)"
  eval "$(pyenv init -)"
  eval "$(nodenv init -)"

  source "${ZDOTDIR:-$HOME}/.zprofile"
fi
