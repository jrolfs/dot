source ~/.keys.zsh
source ~/.aliases.zsh
source ~/.platform.zsh

# jenv
type -p jenv &> /dev/null && eval "$(jenv init -)"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


#
# zplug
#

source ~/.zplug/init.zsh

local base16="chriskempson/base16-shell"
local prezto="sorin-ionescu/prezto"

zplug $base16, \
  use:"**/*oceanicnext.sh", \
  hook-load:"source $ZPLUG_REPOS/$base16/scripts/base16-oceanicnext.sh"

zplug $prezto, \
  as:plugin, \
  use:init.zsh, \
  hook-build:"ln -s $ZPLUG_REPOS/$prezto $HOME/.zprezto"

zstyle ':prezto:*:*' color 'yes'

zstyle ':prezto:load' pmodule \
  'environment' \
  'editor' \
  'history' \
  'history-substring-search' \
  'directory' \
  'spectrum' \
  'gpg' \
  'git' \
  'ruby' \
  'node' \
  'python' \
  'utility' \
  'fasd' \
  'prompt'

zstyle ':prezto:module:editor' key-bindings 'vi'
zstyle ':prezto:module:prompt' theme 'jamie'

zplug "plugins/yarn", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh
zplug "plugins/gem", from:oh-my-zsh
zplug "plugins/grunt", from:oh-my-zsh
zplug "plugins/gulp", from:oh-my-zsh
zplug "plugins/go", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh

zplug "spwhitt/nix-zsh-completions"
zplug "kuno/npm-zsh-completion"

zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"

# Homeshick
zplug "$HOME/.homesick/repos/homeshick", \
  from:local, \
  use:homeshick.sh

if ! zplug check; then
  zplug install
fi

zplug load

#
# /zplug
#
