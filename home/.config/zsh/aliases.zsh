alias vi=nvim
alias vim=nvim

alias hs=homeshick

alias J=fasd_cd

# Git

alias gl1="COLUMNS=200 git log --pretty=oneline"
alias gRP=git-prune-local
alias gry="git add yarn.lock && git rebase --continue"
alias gsxx=git-stash-drop
# Unique commits from current branch
alias gcu="git log --pretty=oneline --no-merges \"^\$(git-branch-current)\""

alias pop="git reset HEAD~1"
alias wip="git add . && git commit --verbose --no-verify -m 'wip'"

# Fancy Unix replacements

if command -v bat >&/dev/null 2>&1; then
  alias cat=bat
fi

if command -v exa >&/dev/null 2>&1; then
  alias ls="$XDG_DATA_HOME/exa-wrapper.sh"
fi

alias jj="fasd_cd -tdi"

# Images

alias icat="kitty +kitten icat"

# History

alias hspl="history_sync_pull -y -r 91C155A78968EEE863ED8B22626AE770762AC2F3"
alias hsps="history_sync_push -y -r 91C155A78968EEE863ED8B22626AE770762AC2F3"
alias hss="hspl && hsps"

# SSH

if [[ $TERM == 'xterm-kitty' ]]; then
  alias sshk="kitty +kitten ssh"
fi

# Kubernetes

alias k=kubectl
alias kx=kubectx
alias kn=kubens

# 1Password (it won't read symbolic links so homeshick linked config doesn't work)
alias op="op --config $HOMESHICK_KINGDOM/private/home/.config/op"

alias gpg-preset-passphrase="$(gpgconf --list-dirs libexecdir)/gpg-preset-passphrase"
alias gpgr="gpg-connect-agent reloadagent /bye"

# Node

alias update-node-version="node --version | tr -d v >! .node-version"
