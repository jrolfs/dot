#
# OS specific functions
#

os_functions="${HOME}/.functions.$(uname | tr '[:upper:]' '[:lower:]').zsh"

if [ -f $os_functions ]; then
  source $os_functions
fi
