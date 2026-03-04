function exists {
  return $(command -v $1 >&/dev/null 2>&1)
}

mkdir -p $XDG_CONFIG_HOME/zsh/completions

# # See: https://github.com/mklabs/tabtab
# [[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

unset exists
