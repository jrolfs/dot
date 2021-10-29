#
# Miscellaneous

function exists {
  return $(command -v $1 >&/dev/null 2>&1)
}

function kill-port {
  lsof -iTCP:$1 | grep LISTEN | awk '{ print $2 }' | xargs kill $2
}

function yarn-latest {
  yarn info "$1" --json | jq --raw-output '.data.versions[-1]'
}

function nix-rip {
  rg -g "**/*$1*/**/default.nix" --files --hidden ~/.nix-defexpr/nixpkgs/pkgs
}

function skim { nvim $(sk); }

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
  git branch -r | awk '{ print $1 }' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{ print $1 }' | xargs git branch -D
}

# Hover

function unreleased {
  git log --pretty=oneline $(curl -s https://web-react.$1.4hover.app/health | jq -r '.releaseID')..$2
}


#
# GitHub

function gh-rr {
  for f in $(gh run list --workflow $1.yml | grep failure | awk '{ print $(NF-2) }'); do
    gh run rerun $f;
  done
}

# Hover

function unreleased-gh {
  echo "https://github.com/hoverinc/web-react/compare/$(curl -s https://web-react.$1.4hover.app/health | jq -r '.releaseID')..$2" | pbcopy
}
