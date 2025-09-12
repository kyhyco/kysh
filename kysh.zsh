KYSH_PATH="${0:A:h}"

if [[ -z ${TMUX+X}${ZSH_SCRIPT+X}${ZSH_EXECUTION_STRING+X} ]];then
  tmux attach || tmux new -s kyhyco -n home
fi

source "$KYSH_PATH/alias.zsh"
source "$KYSH_PATH/settings.zsh"
source "$KYSH_PATH/powerlevel10k-theme.zsh"

# Completions
source "$KYSH_PATH/completions/gh.zsh"
source "$KYSH_PATH/completions/fh.zsh"

# External
source "$KYSH_PATH/external/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$KYSH_PATH/external/zsh-autosuggestions/zsh-autosuggestions.zsh"
