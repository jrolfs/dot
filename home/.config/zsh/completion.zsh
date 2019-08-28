function exists {
  return $(command -v $1 >&/dev/null 2>&1)
}

exists kitty && kitty + complete setup zsh | source /dev/stdin
exists codefresh && codefresh completion zsh | source /dev/stdin

unset exists
