source $XDG_CONFIG_HOME/zsh/keys.zsh
source $XDG_CONFIG_HOME/zsh/aliases.zsh

# Browser
if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

# Editors
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'

#
# jenv
type -p jenv &> /dev/null && eval "$(jenv init -)"

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# ZSH function search path
fpath+=(
  $XDG_CONFIG_HOME/zsh/themes
  $XDG_CONFIG_HOME/zsh/completions
)

# Executable search path
path=(
  /usr/local/{bin,sbin}
  $HOME/.emacs.d/bin
  $JENV_ROOT/bin
  $NODENV_ROOT/bin
  $PYENV_ROOT/bin
  $RBENV_ROOT/bin
  $GOPATH/bin
  $path
)

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

#
# Temporary Files
#

TMPPREFIX="$(mktemp -d)/zsh"
