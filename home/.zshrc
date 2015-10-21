#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Completions
fpath=($HOME/.homesick/repos/homeshick/completions $fpath)
fpath=(/usr/local/share/zsh/site-functions $fpath)

# Custom Themes
fpath=($HOME/.zthemes $fpath)

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

# Homeshick
source "$HOME/.homesick/repos/homeshick/homeshick.sh"

# Key Bindings
bindkey '^R' history-incremental-search-backward

# Completions
eval "$(rbenv init -)"
eval "$(gulp --completion=zsh)"
eval "$(npm completion)"

# MySQL collation
export COLLATION=utf8_general_ci

# Aliases
alias dockerdaemon="bash -c 'clear && DOCKER_HOST=tcp://192.168.99.100:2376 DOCKER_CERT_PATH=/Users/Jamie/.docker/machine/machines/default DOCKER_TLS_VERIFY=1 /bin/zsh'"
