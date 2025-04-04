setopt extendedglob

for config in $XDG_CONFIG_HOME/zsh/(^(prezto|completion)).zsh; source $config

# Editors
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'

export ZLE_RPROMPT_INDENT=0

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
  $ASDF_DATA_DIR/completions
)

# Executable search path
path=(
  /opt/homebrew/bin
  /usr/local/{bin,sbin}
  $HOME/.cargo/bin
  $GOPATH/bin
  $SPICETIFY_INSTALL
  $WORK_BIN
  $path
)

source "${ASDF_DATA_DIR}/asdf.sh"

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
