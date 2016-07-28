#
# Defines environment variables.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

export SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh"

type -p rbenv &> /dev/null && eval "$(rbenv init -)"
type -p pyenv &> /dev/null && eval "$(pyenv init -)"
