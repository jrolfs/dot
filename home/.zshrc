preztorc="${XDG_CONFIG_HOME}/zsh/prezto.zsh"
platformrc="${HOME}/.zshrc.$(uname | tr '[:upper:]' '[:lower:]')"

[[ -f $preztorc ]] && source $preztorc
[[ -f $platformrc ]] && source $platformrc

unset preztorc platformrc

#
# <zplug>
#

source ~/.zplug/init.zsh

zplug "sorin-ionescu/prezto", \
  as:plugin, \
  use:init.zsh, \
  hook-build:"pwd | xargs -I {} ln -fs {} $HOME/.zprezto"

zplug "belak/prezto-contrib", \
  as:plugin, \
  hook-build:"pwd | xargs -I {} ln -fs {} $HOME/.zprezto/contrib"

zplug "$XDG_CONFIG_HOME/zsh", \
  from:local, \
  use:"*.zsh"

zplug "$HOME/.homesick/repos/homeshick", \
  from:local, \
  use:homeshick.sh

zplug "tridactyl/tridactyl", \
  hook-build:"source ./native/install.sh > /dev/null 2>&1"

zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/gem", from:oh-my-zsh
zplug "plugins/github", from:oh-my-zsh
zplug "plugins/go", from:oh-my-zsh
zplug "plugins/grunt", from:oh-my-zsh
zplug "plugins/gulp", from:oh-my-zsh
zplug "plugins/mosh", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh

zplug "amar1729/chunkwm-zsh-completions"
zplug "andsens/homeshick", use:completions
zplug "docker/compose", use:contrib/completion/zsh
zplug "homebrew/brew", use:completions/zsh

zplug "zsh-users/zsh-completions"

zplug "lotabout/skim", \
  use:shell/key-bindings.zsh

if ! zplug check; then
  zplug install
fi

zplug load

#
# </zplug>
#
