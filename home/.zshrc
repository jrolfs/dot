#
# zplug
#

source ~/.zplug/init.zsh

zplug "jrolfs/prezto", \
  as:plugin, \
  use:init.zsh, \
  hook-build:"ln -s $ZPLUG_REPOS/jrolfs/prezto $HOME/.zprezto"

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

# Homeshick
zplug "$HOME/.homesick/repos/homeshick", \
  from:local, \
  use:homeshick.sh

# Base16 Shell
zplug "$HOME/.config/base16-shell/scripts", \
  from:local, \
  use:base16-ocean.sh

# Nix
zplug "$HOME/.nix-profile/etc/profile.d", \
  from:local, \
  use:nix.sh

zplug "plugins/pip", from:oh-my-zsh
zplug "plugins/grunt", from:oh-my-zsh
zplug "plugins/gulp", from:oh-my-zsh

zplug "spwhitt/nix-zsh-completions"
zplug "kuno/npm-zsh-completion"

zplug "zsh-users/zsh-syntax-highlighting", nice:10
zplug "zsh-users/zsh-completions"

if ! zplug check; then
  zplug install
fi

zplug load

#
# /zplug
#


# jEnv
type -p jenv &> /dev/null && eval "$(jenv init -)"

source ~/.aliases.zsh
