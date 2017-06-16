#
# OS specific configuration
#

os_init="${HOME}/.$(uname | tr '[:upper:]' '[:lower:]').zsh"

if [ -f $os_init ]; then
  source $os_init
fi
