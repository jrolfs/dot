alias gty="gpg-connect-agent updatestartuptty /bye"

alias vi=nvim
alias vim=nvim

alias hs=homeshick

alias jj="fasd_cd -tdi"

alias gl1="git log --pretty=oneline"

alias cz=git-cz

alias gRP="git branch -r | awk '{ print \$1 }' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{ print \$1 }' | xargs git branch -D"

if command -v exa >&/dev/null 2>&1; then
  alias ls="$XDG_DATA_HOME/exa-wrapper.sh"
fi

alias icat="kitty +kitten icat"

alias heic2jpg="fd --regex '(?i)heic' -x sips -s format jpeg {/} --out {/.}.jpg"
