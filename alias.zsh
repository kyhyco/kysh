export EDITOR='nvim'

source "$KYSH_PATH/alias/alias-git.zsh"
source "$KYSH_PATH/alias/alias-docker.zsh"
source "$KYSH_PATH/alias/alias-navigation.zsh"
source "$KYSH_PATH/alias/alias-at.zsh"

# editing
alias sz='exec zsh' # wipes all temporary variables. source zsh doesn't do that
alias ez='($EDITOR ~/.zshrc)'
alias ezz='($EDITOR $KYSH_PATH)'

# kysh update
kysh-update() {
    local kysh_config_path="$HOME/.config/kysh"
    if [[ -d "$kysh_config_path" ]]; then
        echo "Updating kysh configuration..."
        (cd "$kysh_config_path" && git pull --recurse-submodules)
        echo "kysh updated successfully!"
        echo "Run 'sz' to reload your shell configuration."
    else
        echo "Error: kysh configuration directory not found at $kysh_config_path"
        return 1
    fi
}

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
