# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

path+=(
  $HOME/.rbenv/shims
  $HOME/.pyenv/shims
  $HOME/.nodenv/shims
  $HOME/.jenv/shims
)
