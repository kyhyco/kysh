if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

__fzf_ctrl_t_directory="fd --type d --hidden --exclude .git --exclude node_modules --exclude .Trash --exclude Desktop --exclude Library --exclude Pictures --exclude .rvm"
export FZF_DEFAULT_COMMAND='rg --files --hidden --no-ignore-vcs -g "!{node_modules,.git,Desktop,.Trash,Library,Pictures,.rvm}"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--prompt 'Files: ' --header 'CTRL-D: Directories / CTRL-F: Files' --bind 'ctrl-d:change-prompt(Directories: )+reload($__fzf_ctrl_t_directory)' --bind 'ctrl-f:change-prompt(Files: )+reload($FZF_DEFAULT_COMMAND)'"
export FZF_ALT_C_COMMAND="fd --type d --hidden --exclude .git"
export FZF_DEFAULT_OPTS="--color=dark --layout=reverse --margin=1,1 --color=fg:15,bg:-1,hl:1,fg+:#ffffff,bg+:0,hl+:1 --color=info:8,pointer:12,marker:4,spinner:11,header:-1"

bindkey '\et' fzf-cd-widget
