# Project-aware tab titles for kitty
[[ -n "$KITTY_INSTALLATION_DIR" ]] || return 0

typeset -g _ktt_icon=""
typeset -g _ktt_cached_dir=""

_ktt_detect_project() {
  [[ "$PWD" == "$_ktt_cached_dir" ]] && return
  _ktt_cached_dir="$PWD"
  _ktt_icon=""

  local dir="$PWD"
  local git_found=0

  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/tsconfig.json" ]];      then _ktt_icon=" "; return; fi
    if [[ -f "$dir/package.json" ]];      then _ktt_icon=" "; return; fi
    if [[ -f "$dir/Cargo.toml" ]];        then _ktt_icon=" "; return; fi
    if [[ -f "$dir/go.mod" ]];            then _ktt_icon=" "; return; fi
    if [[ -f "$dir/pyproject.toml" ]] ||
       [[ -f "$dir/setup.py" ]] ||
       [[ -f "$dir/requirements.txt" ]];  then _ktt_icon=" "; return; fi
    if [[ -f "$dir/Gemfile" ]] ||
       [[ -f "$dir/.ruby-version" ]];     then _ktt_icon=" "; return; fi
    if [[ -f "$dir/pom.xml" ]] ||
       [[ -f "$dir/build.gradle" ]] ||
       [[ -f "$dir/.java-version" ]];     then _ktt_icon=" "; return; fi
    if [[ -f "$dir/flake.nix" ]] ||
       [[ -f "$dir/default.nix" ]];       then _ktt_icon=" "; return; fi

    if (( ! git_found )) && [[ -d "$dir/.git" ]]; then
      git_found=1
    fi

    dir="${dir:h}"
  done

  if (( git_found )); then
    _ktt_icon=" "
  else
    _ktt_icon=""
  fi
}

_ktt_set_title() {
  _ktt_detect_project
  print -Pn "\e]2;${_ktt_icon}%1~\a"
}

_ktt_preexec() {
  print -n "\e]2;${_ktt_icon}${1%% *}\a"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _ktt_set_title
add-zsh-hook preexec _ktt_preexec
