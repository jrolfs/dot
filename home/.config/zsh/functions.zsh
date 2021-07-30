
function exists {
  return $(command -v $1 >&/dev/null 2>&1)
}

function nix-rip {
  rg -g "**/*$1*/**/default.nix" --files --hidden ~/.nix-defexpr/nixpkgs/pkgs
}

function skim { nvim $(sk); }

function add-fork {
  local source_remote=${1:-upstream}
  local source_url=$(git remote get-url $source_remote)

  local target_user=${2:-jrolfs}
  local target_remote=${3:-origin}

  local target_url=$(sed "s/:.*\//:$target_user\//" <<< $source_url)

  git remote add $target_remote $target_url
}

function kill-port {
  lsof -iTCP:$1 | grep LISTEN | awk '{ print $2 }' | xargs kill $2
}

function yarn-latest {
  yarn info "$1" --json | jq --raw-output '.data.versions[-1]'
}
