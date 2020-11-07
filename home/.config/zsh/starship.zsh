# XXX: workaround to allow starship to be disabled when Git makes it
# super slow, see https://github.com/starship/starship/issues/1617
if [[ -a "$(pwd)/.git/_starship_disable" ]]; then
  zstyle ':prezto:module:prompt' theme 'pure'
else
  eval "$(starship init zsh)"
fi

# Prints new line between prompts
precmd() {
  $funcstack[1]() {
    echo
  }
}
