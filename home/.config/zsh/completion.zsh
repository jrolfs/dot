function exists {
  return $(command -v $1 >&/dev/null 2>&1)
}

exists kitty && kitty + complete setup zsh | source /dev/stdin
exists gh && gh completion -s zsh >! $XDG_CONFIG_HOME/zsh/completions/_gh


# See: https://github.com/mklabs/tabtab
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

unset exists
