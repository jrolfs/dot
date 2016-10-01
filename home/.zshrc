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

# jEnv
type -p jenv &> /dev/null && eval "$(jenv init -)"

# Key Bindings
bindkey '^R' history-incremental-search-backward

# Completions
type -p npm &> /dev/null && eval "$(npm completion)"
type -p grunt &> /dev/null && eval "$(grunt --completion=zsh)"
type -p gulp &> /dev/null && eval "$(gulp --completion=zsh)"

# MySQL collation
export COLLATION=utf8_general_ci

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/scripts/base16-ocean.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#
# Aliases

# Neovim
alias vi=nvim
alias vim=nvim
