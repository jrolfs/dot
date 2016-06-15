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
eval "$(pyenv init -)"
eval "$(gulp --completion=zsh)"
eval "$(npm completion)"

# MySQL collation
export COLLATION=utf8_general_ci

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/base16-ocean.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias vi=nvim
alias vim=nvim
