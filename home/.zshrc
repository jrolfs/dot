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

# FZF
zplug "junegunn/fzf-bin", \
  from:gh-r, \
  as:command, \
  rename-to:fzf, \
  use:"*darwin*amd64*"

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
zplug "spwhitt/nix-zsh-completions"
zplug "kuno/npm-zsh-completion"
zplug "akoenig/gulp.plugin.zsh"
zplug "yonchu/grunt-zsh-completion"

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
