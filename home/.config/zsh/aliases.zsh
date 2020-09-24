alias gty="gpg-connect-agent updatestartuptty /bye"

alias vi=nvim
alias vim=nvim

alias hs=homeshick

alias jj="fasd_cd -tdi"

alias gl1="git log --pretty=oneline"

alias cz=git-cz

alias gRP="git branch -r | awk '{ print \$1 }' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{ print \$1 }' | xargs git branch -D"

if command -v exa >&/dev/null 2>&1; then
  alias l="exa --icons -1a"
  alias ll="exa --icons -l"
  alias la="exa --icons -al"
  alias ls="exa --icons -G"
fi
