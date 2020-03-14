alias gty="gpg-connect-agent updatestartuptty /bye"

alias vi=nvim
alias vim=nvim

alias hs=homeshick

alias jj="fasd_cd -tdi"

alias gl1="git log --pretty=oneline"

alias cz=git-cz

alias gRP="git branch -r | awk '{ print \$1 }' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{ print \$1 }' | xargs git branch -D"
