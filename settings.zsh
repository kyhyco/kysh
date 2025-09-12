source "$KYSH_PATH/settings/settings-fzf.zsh"
source "$KYSH_PATH/settings/settings-share-history.zsh"
source "$KYSH_PATH/settings/settings-key-binds.zsh"

# Colors
autoload -U colors && colors

# Silence
setopt no_nomatch
setopt interactivecomments

# Type directory name to cd into that directory
setopt auto_cd

# Autocompletion
autoload -Uz compinit
compinit -u
zstyle ':completion:*' menu select # arrow keys to select autocompletion items
