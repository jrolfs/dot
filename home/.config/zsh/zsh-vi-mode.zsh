# Fix for zsh-vi-mode breaking `history-substring-search`
zvm_after_init_commands+=("bindkey '^[[A' up-line-or-search" "bindkey '^[[B' down-line-or-search")
