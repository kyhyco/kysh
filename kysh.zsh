KYSH_PATH="${0:A:h}"

source "$KYSH_PATH/alias.zsh"
source "$KYSH_PATH/settings.zsh"
source "$KYSH_PATH/powerlevel10k-theme.zsh"

# Completions
source "$KYSH_PATH/completions/gh.zsh"
source "$KYSH_PATH/completions/fh.zsh"

# zsh-autosuggestions color (uses terminal theme's muted/comment color)
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=black,bold'

# External
source "$KYSH_PATH/external/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$KYSH_PATH/external/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
