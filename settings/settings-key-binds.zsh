# Emacs-style keybindings
bindkey -e
bindkey "^f" forward-word
bindkey "^b" backward-word

# nice for vim users after using ctrl-z within vim.
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z
