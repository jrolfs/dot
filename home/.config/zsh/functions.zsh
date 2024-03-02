#
# Miscellaneous

function exists {
  return $(command -v $1 >&/dev/null 2>&1)
}

function kill-port {
  lsof -iTCP:$1 | grep LISTEN | awk '{ print $2 }' | xargs kill $2
}

function npmv {
  if [[ "$2" =~ ^[0-9]+$ ]]; then
    npm info "$1" --json | jq --raw-output ".versions[-$2:][]"
  else
    npm info "$1" --json | jq --raw-output '.versions[-1]'
  fi
}

function nix-rip {
  rg -g "**/*$1*/**/default.nix" --files --hidden ~/.nix-defexpr/nixpkgs/pkgs
}

function skim { nvim $(sk); }

function gif {
  if [[ "$2" =~ ^[0-9]+$ ]]; then
    ffmpeg -i $1 -pix_fmt rgb8 -r 20 -f gif "${1%.*}.gif" -filter:v scale=$2:-1
  else
    ffmpeg -i $1 -pix_fmt rgb8 -r 20 -f gif "${1%.*}.gif"
  fi
}

#
# Git

function add-fork {
  local source_remote=${1:-upstream}
  local source_url=$(git remote get-url $source_remote)

  local target_user=${2:-jrolfs}
  local target_remote=${3:-origin}

  local target_url=$(sed "s/:.*\//:$target_user\//" <<< $source_url)

  git remote add $target_remote $target_url
}

function git-stash-drop {
  if [[ "$1" =~ ^[0-9]+$ ]] && ! [ $2 ]; then
    git stash drop "stash@{$1}"
  else
    git stash drop "$@"
  fi
}

function git-prune-local {
  local remote=${1:-origin}

  git remote prune $remote

  echo "\nPruning local branches"
  git branch -r | awk '{ print $1 }' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{ print $1 }' | egrep -v '^\+' | xargs git branch -D
}

function ... {
  cd $(git rev-parse --show-cdup)
}

# Hover

function unreleased {
  git log --pretty=oneline $(curl -s https://web-react.$1.4hover.app/health | jq -r '.releaseID')..$2
}

function unreleased-gh {
  echo "https://github.com/hoverinc/web-react/compare/$(curl -s https://web-react.$1.4hover.app/health | jq -r '.releaseID')..$2" | pbcopy
}


#
# GitHub

function gh-rr {
  for f in $(gh run list --workflow $1.yml | grep failure | awk '{ print $(NF-2) }'); do
    gh run rerun $f;
  done
}

#
# Kitty

# Font size
function kfs {
  # Remove all but the newest socket
  /bin/ls -t ~/.local/share/kitty | egrep '^socket' | awk 'NR>1' | xargs -I {} rm -- ~/.local/share/kitty/{}

  /opt/homebrew/bin/kitty @ --to unix:$(/run/current-system/sw/bin/fd socket ~/.local/share/kitty | tail -1) set-font-size $1
}

#
# GPG

function gpgp { echo $1 | gpg-preset-passphrase --preset 91C155A78968EEE863ED8B22626AE770762AC2F3 }
