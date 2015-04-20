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

# Hub
# eval "$(hub alias -s)"

# Homeshick
source "$HOME/.homesick/repos/homeshick/homeshick.sh"

# Key Bindings
bindkey '^R' history-incremental-search-backward

eval "$(rbenv init -)"
eval "$(nodenv init -)"
