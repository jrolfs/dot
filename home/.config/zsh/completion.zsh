function exists {
  return $(command -v $1 >&/dev/null 2>&1)
}

exists kitty && kitty + complete setup zsh | source /dev/stdin
exists gh && gh completion -s zsh >! $XDG_CONFIG_HOME/zsh/completions/_gh

unset exists
