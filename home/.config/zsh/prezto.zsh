zstyle ':prezto:*:*' color 'yes'

zstyle ':prezto:load' pmodule \
  'environment' \
  'editor' \
  'history' \
  'directory' \
  'spectrum' \
  'gpg' \
  'git' \
  'ruby' \
  'node' \
  'python' \
  'utility' \
  'fasd' \
  'autosuggestions' \
  'syntax-highlighting' \
  'history-substring-search' \
  'contrib-prompt' \
  'prompt'

zstyle ':prezto:module:editor' key-bindings 'vi'
zstyle ':prezto:module:prompt' theme 'jamie'
zstyle ':prezto:module:prompt' pwd-length 'short'
zstyle ':completion:*' menu select

zstyle ':prezto:module:syntax-highlighting' highlighters \
  'main' \
  'brackets' \
  'pattern' \
  'line' \
  'cursor' \
  'root'

zstyle ':prezto:module:syntax-highlighting' styles \
  'builtin' 'fg=4,underline' \
  'command' 'fg=151,bold' \
  'function' 'fg=116,bold' \
  'alias' 'fg=63,bold' \
  'suffix-alias' 'fg=69,underline' \
  'single-hyphen-option' 'fg=247,bold' \
  'double-hyphen-option' 'fg=247,bold'
