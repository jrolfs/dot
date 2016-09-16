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

# Needed until https://github.com/sorin-ionescu/prezto/pull/1178 gets merged 🙏
type -p nodenv &> /dev/null && eval "$(nodenv init -)"

# Key Bindings
bindkey '^R' history-incremental-search-backward

# Completions
nodenv_global_path="NODENV_VERSION=$(nodenv global)"
echo "$nodenv_global_path gulp --completion=zsh" | eval
echo "$nodenv_global_path npm completion" | eval

# MySQL collation
export COLLATION=utf8_general_ci

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/scripts/base16-ocean.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias vi=nvim
alias vim=nvim

alias lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
