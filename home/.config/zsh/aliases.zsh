alias vi=nvim
alias vim=nvim

alias hs=homeshick

# Git

alias gl1="git log --pretty=oneline"
alias gRP="git branch -r | awk '{ print \$1 }' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{ print \$1 }' | xargs git branch -D"
alias gry="git add yarn.lock && git rebase --continue"
alias gsxx=git-stash-drop

# Navigation

if command -v exa >&/dev/null 2>&1; then
  alias ls="$XDG_DATA_HOME/exa-wrapper.sh"
fi

alias jj="fasd_cd -tdi"

# Images

alias icat="kitty +kitten icat"
alias heic2jpg="fd --regex '(?i)heic' -x sips -s format jpeg {/} --out {/.}.jpg"
