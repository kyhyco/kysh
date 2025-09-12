if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

() {
  function prompt_mise() {
    # Check if mise.toml exists in current directory or ancestors
    local current_dir="$PWD"
    local has_mise_toml=false

    while [[ "$current_dir" != "$HOME" ]]; do
      if [[ -f "$current_dir/mise.toml" ]]; then
        has_mise_toml=true
        break
      fi
      current_dir="$(dirname "$current_dir")"
    done

    # Only show segment if mise.toml is found and not in home directory
    if [[ $has_mise_toml == false ]] || [[ $PWD == $HOME ]]; then
      return
    fi

    local whitelist=(node python go ruby rust)

    local plugins=("${(@f)$(mise ls --current --offline 2>/dev/null | awk '!/\(symlink\)/ && $3!="~/.tool-versions" && $3!="~/.config/mise/config.toml" && $3!="(missing)" {if ($1) print $1, $2}')}")
    local plugin
    local isFirstPlugin=true

    for plugin in ${(k)plugins}; do
      local parts=("${(@s/ /)plugin}")
      local tool=${parts[1]}
      local version=${parts[2]}

      # Only display whitelisted languages
      if [[ ${whitelist[(ie)$tool]} -le ${#whitelist} ]]; then
        local tool_upper=${(U)tool}

        if $isFirstPlugin; then
          p10k segment -t "via"
          isFirstPlugin=false
        fi

        p10k segment -r -i "${tool_upper}_ICON" -s $tool_upper -t "$version"
      fi
    done
  }

  # Colors/icons you already set continue to work:
  typeset -g POWERLEVEL9K_MISE_FOREGROUND=$WHITE

  typeset -g POWERLEVEL9K_MISE_GO_FOREGROUND=4
  typeset -g POWERLEVEL9K_MISE_GO_VISUAL_IDENTIFIER_EXPANSION=''

  typeset -g POWERLEVEL9K_MISE_NODE_FOREGROUND=2
  typeset -g POWERLEVEL9K_MISE_NODE_VISUAL_IDENTIFIER_EXPANSION=''

  typeset -g POWERLEVEL9K_MISE_PYTHON_FOREGROUND=3
  typeset -g POWERLEVEL9K_MISE_PYTHON_VISUAL_IDENTIFIER_EXPANSION=''

  typeset -g POWERLEVEL9K_MISE_RUBY_FOREGROUND=168
  typeset -g POWERLEVEL9K_MISE_RUBY_VISUAL_IDENTIFIER_EXPANSION=''

  typeset -g POWERLEVEL9K_MISE_RUST_FOREGROUND=37
  typeset -g POWERLEVEL9K_MISE_RUST_VISUAL_IDENTIFIER_EXPANSION=''

  # Substitute the default asdf prompt element
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=("${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[@]/asdf/mise}")
}
