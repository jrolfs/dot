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

zplug "chriskempson/base16-shell", \
  use:"**/*oceanicnext.sh", \
  defer:3

zplug "sorin-ionescu/prezto", \
  as:plugin, \
  use:init.zsh, \
  hook-build:"pwd | xargs -I {} ln -fs {} $HOME/.zprezto"

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
zplug "docker/compose", use:contrib/completion/zsh
zplug "Homebrew/brew", use:completions/zsh

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
