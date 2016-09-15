#
# Defines environment variables.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Go
export GOPATH="${HOME}/Development/Go"

# Git Duet
export GIT_DUET_ROTATE_AUTHOR=1

# GPG/SSH
export SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh"


# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

# Init (rb|py|nod)env for non-login, non-interactive shells (graphical vim etc.)
env_init=('rbenv' 'pyenv' 'nodenv')

for env in $env_init; do
  type -p $env &> /dev/null && eval "$($env init -)"
done
