#
# zplug
#

source ~/.zplug/init.zsh

zplug "jrolfs/prezto", \
  hook-build:"ln -s $ZPLUG_REPOS/jrolfs/prezto $HOME/.zprezto", \
  as:plugin, \
  use:init.zsh

zstyle ':prezto:*:*' color 'yes'

zstyle ':prezto:load' pmodule \
  'environment' \
  'terminal' \
  'editor' \
  'history' \
  'history-substring-search' \
  'directory' \
  'spectrum' \
  'git' \
  'ruby' \
  'node' \
  'python' \
  'utility' \
  'fasd' \
  'prompt'

zstyle ':prezto:module:editor' key-bindings 'vi'
zstyle ':prezto:module:prompt' theme 'jamie'

zplug "zsh-users/zsh-syntax-highlighting", nice:10
zplug "zsh-users/zsh-completions"

# FZF
zplug "junegunn/fzf-bin", \
  from:gh-r, \
  as:command, \
  rename-to:fzf, \
  use:"*darwin*amd64*"

# Homeshick
zplug $HOME/.homesick/repos/homeshick, \
  from:local, \
  use:homeshick.sh

# Base16 Shell
zplug $HOME/.config/base16-shell/scripts, \
  from:local, \
  use:base16-ocean.sh

# Nix
zplug $HOME/.nix-profile/etc/profile.d, \
  from:local, \
  use:nix.sh

zplug "spwhitt/nix-zsh-completions"

if ! zplug check; then
  zplug install
fi

zplug load

#
# /zplug
#


# jEnv
type -p jenv &> /dev/null && eval "$(jenv init -)"

# Key Bindings
bindkey '^R' history-incremental-search-backward

# Completions
type -p npm &> /dev/null && eval "$(npm completion)"
type -p grunt &> /dev/null && eval "$(grunt --completion=zsh)"
type -p gulp &> /dev/null && eval "$(gulp --completion=zsh)"


#
# Aliases

# Neovim
alias vi=nvim
alias vim=nvim

alias hs=homeshick
