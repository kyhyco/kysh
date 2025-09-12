# ls
alias l='eza -a -1 --group-directories-first'
alias ll='eza -a -1 --group-directories-first -l --no-time --no-filesize --no-user'
alias lll='eza -a -1 --group-directories-first -l -g --no-time --no-filesize'

# backtrack
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# show directories
alias d1='tree -d -L 1'
alias d2='tree -d -L 2'
alias d3='tree -d -L 3'

# show files
alias f1='tree -L 1'
alias f2='tree -L 2'
alias f3='tree -L 3'

# Open folder in Finder in the terminal
of() {
  target=`osascript -e 'tell application "Finder" to get POSIX path of (target of front Finder window as text)'`
  cd "$target"
}

