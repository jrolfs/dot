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

zplug "$HOME/.homesick/repos/homeshick", \
  from:local, \
  use:homeshick.sh

zstyle ':prezto:*:*' color 'yes'

zstyle ':prezto:load' pmodule \
  'environment' \
  'editor' \
  'history' \
  'directory' \
  'spectrum' \
  'gpg' \
  'git' \
  'ruby' \
  'node' \
  'python' \
  'utility' \
  'fasd' \
  'autosuggestions' \
  'syntax-highlighting' \
  'history-substring-search' \
  'prompt'

zstyle ':prezto:module:editor' key-bindings 'vi'
zstyle ':prezto:module:prompt' theme 'jamie'
zstyle ':completion:*' menu select

zplug "plugins/pip", from:oh-my-zsh
zplug "plugins/gem", from:oh-my-zsh
zplug "plugins/grunt", from:oh-my-zsh
zplug "plugins/gulp", from:oh-my-zsh
zplug "plugins/go", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh

zplug "jrolfs/fzf", at:"no-path" hook-build:"./install \
    --key-bindings \
    --completion \
    --no-update-rc \
    --no-fish \
    --no-bash \
    --no-path"

zplug "docker/compose", use:contrib/completion/zsh
zplug "Homebrew/brew", use:completions/zsh
zplug "github/hub", \
  hook-build:"pwd | xargs -I {} ln -fs {}/etc/hub.zsh_completion $HOME/.zsh/completions/_hub"
zplug "andsens/homeshick", \
  hook-build:"pwd | xargs -I {} ln -fs {}/completions/_homeshick $HOME/.zsh/completions/_homeshick"

zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"

if ! zplug check; then
  zplug install
fi

zplug load

#
# /zplug
#


#
# OS specific configuration
#

os_init="${HOME}/.zshrc.$(uname | tr '[:upper:]' '[:lower:]')"

if [ -f $os_init ]; then
  source $os_init
fi

unset os_init
