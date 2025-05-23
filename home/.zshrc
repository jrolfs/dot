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

zplug "$HOME/.travis", \
  from:local, \
  defer:3, \
  use:travis.sh

zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/gem", from:oh-my-zsh
zplug "plugins/golang", from:oh-my-zsh
zplug "plugins/mosh", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh
zplug "plugins/pod", from:oh-my-zsh

zplug "andsens/homeshick", use:completions
zplug "homebrew/brew", use:completions/zsh
zplug "bobthecow/launchctl-completion", use:"launchctl-completion.bash"

zplug "ahmetb/kubectx"

zplug "zsh-users/zsh-completions"
zplug "ryutok/rust-zsh-completions"

if ! zplug check; then
  zplug install
fi

zplug load

#
# </zplug>
#

if [[ -v STARSHIP_ENABLED ]] then
  eval "$(starship init zsh)"
fi
