if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

() {
  function prompt_mise() {
    local dir="$PWD"
    local closest_mise_toml=""
    while [[ "$dir" != "$HOME" ]]; do
      if [[ -f "$dir/mise.toml" ]]; then
        closest_mise_toml="$dir/mise.toml"
        break
      fi
      dir="${dir:h}"  # dirname in zsh
    done

    # No project mise.toml found (or we're at $HOME) → render nothing
    [[ -n "$closest_mise_toml" ]] || return

    local lines=(${(f)"$(
      mise ls --current --offline -l -J 2>/dev/null | jq -r --arg home "$HOME" '
        to_entries[] as $e
        | $e.key as $tool
        | select($tool | IN("node", "rust", "python", "go", "ruby"))
        | $e.value[]
        | select(.source.path != ($home + "/mise.toml"))
        | if .active then
            "\($tool) \(.version)"
          else
            "\($tool) missing"
          end
      '
    )"})

    if (( ${#lines})); then
      p10k segment -t "via"
    fi

    local line tool version parts
    for line in $lines; do
      parts=(${=line})
      tool="${(U)parts[1]}"
      version="${parts[2]}"

      p10k segment -r -i "${tool}_ICON" -s "$tool" -t "$version"
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
