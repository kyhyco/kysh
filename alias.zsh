export EDITOR='nvim'

source "$KYSH_PATH/alias/alias-git.zsh"
source "$KYSH_PATH/alias/alias-docker.zsh"
source "$KYSH_PATH/alias/alias-navigation.zsh"
source "$KYSH_PATH/alias/alias-at.zsh"

# editing
alias sz='exec zsh' # wipes all temporary variables. source zsh doesn't do that
alias ez='($EDITOR ~/.zshrc)'
alias ezz='($EDITOR $KYSH_PATH)'

# shorthands
alias tree='tree -C'
alias q='exit'
alias c='clear'
alias o='open'
alias t='touch'
alias md='mkdir -p'
alias rd='rm -rf'
alias cx='chmod +x'
alias pingg='ping www.google.com'
alias myip="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"
