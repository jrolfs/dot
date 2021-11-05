#
# Options
#

setopt bang_hist
setopt extended_history
setopt hist_ignore_space
setopt hist_verify
setopt share_history

#
# Environment
#

export KEYTIMEOUT=1

# XDG
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"

# Dotfiles
export HOMESHICK_KINGDOM="${HOMESHICK_DIR:-$HOME/.homesick/repos}"
export HS_KINGDOM=$HOMESHICK_KINGDOM
export ZSH_EXTRA_COMPLETIONS="${XDG_CONFIG_HOME}/zsh/completions"

export ORGANIZATION="Hover"
export DEVELOPER="${HOME}/Developer"
export SOURCES="${DEVELOPER}/Sources"
export WORK_HOME="${DEVELOPER}/${ORGANIZATION}"
export PERSONAL_HOME="${DEVELOPER}/${ORGANIZATION}"

# History Sync
export ZSH_HISTORY_FILE_NAME=".zsh_history"
export ZSH_HISTORY_FILE="${HOME}/${ZSH_HISTORY_FILE_NAME}"
export ZSH_HISTORY_PROJ="${XDG_DATA_HOME}/history"
export ZSH_HISTORY_FILE_ENC_NAME="zsh_history"
export ZSH_HISTORY_FILE_ENC="${ZSH_HISTORY_PROJ}/${ZSH_HISTORY_FILE_ENC_NAME}"
export ZSH_HISTORY_COMMIT_MSG="sync($(hostname | tr '[:upper:]' '[:lower:]')): $(date +'%A, %B %d %Y @ %T')"

export SYNC="${HOME}/Sync"

# Go
export GOPATH="${DEVELOPER}/Go"

# Git Duet
export GIT_DUET_CO_AUTHORED_BY=1
export GIT_DUET_AUTHORS_FILE="${XDG_CONFIG_HOME}/git/authors.yml"

# GPG/SSH
export SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh"

# FZF
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_TMUX=1
export FZF_TMUX_HEIGHT='50%'

export SKIM_DEFAULT_COMMAND="fd --type f --hidden"

# Nix
export NIXPKGS_ALLOW_UNFREE=1

# Asdf
export ASDF_DATA_DIR="${XDG_DATA_HOME}/asdf"
export ASDF_CONFIG_FILE="${XDG_CONFIG_HOME}/asdf/config"

export ASDF_NPM_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME}/asdf/default-npm-packages"
export ASDF_GEM_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME}/asdf/default-gems"
export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="${XDG_CONFIG_HOME}/asdf/default-python-packages"

export NODEJS_CONFIGURE_OPTIONS="--with-intl=full-icu --download=all"
export NODEJS_CHECK_SIGNATURES="no"

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"

  path=(
    $path
  )

  source "${ASDF_DATA_DIR}/asdf.sh"
fi
