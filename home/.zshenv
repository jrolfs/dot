# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

source ~/.keys.zsh
source ~/.aliases.zsh
source ~/.platform.zsh

#
# Options
#

setopt HIST_IGNORE_SPACE

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

path+=(
  $HOME/.rbenv/shims
  $HOME/.pyenv/shims
  $HOME/.nodenv/shims
  $HOME/.jenv/shims
)
