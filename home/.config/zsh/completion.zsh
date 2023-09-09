function exists {
  return $(command -v $1 >&/dev/null 2>&1)
}

# NOTE: seems like this file isn't running for some reason... zplug? Anyways,
# I've added most of these directly to the repo. I'm honestly not sure how the
# Kitty completion is working right now.

# # Kitty
# exists kitty && kitty + complete setup zsh | source /dev/stdin

# # GitHub
# exists gh && gh completion -s zsh >! $XDG_CONFIG_HOME/zsh/completions/_gh

# # Infrastructure stuff
# exists kubectl && kubectl completion zsh >! $XDG_CONFIG_HOME/zsh/completions/_kubectl
# exists infractl && infractl completion zsh >! $XDG_CONFIG_HOME/zsh/completions/_infractl

# # See: https://github.com/mklabs/tabtab
# [[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

unset exists
