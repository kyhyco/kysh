if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

() {
  function prompt_mise() {
    # Find the closest mise.toml walking up from $PWD, but stop at $HOME
    local dir="$PWD" closest_mise_toml=""
    while [[ "$dir" != "$HOME" ]]; do
      if [[ -f "$dir/mise.toml" ]]; then
        closest_mise_toml="$dir/mise.toml"
        break
      fi
      dir="${dir:h}"  # dirname in zsh
    done

    # No project mise.toml found (or we're at $HOME) → render nothing
    [[ -n "$closest_mise_toml" ]] || return

    # Pull active tools ONLY from that closest mise.toml
    # - ignore global files (~/.tool-versions, ~/.config/mise/config.toml)
    # - only take entries whose source.path == closest file
    # - output lines: "<tool> <version>" (or just "<tool>" if version is "")
    # - if a language needs to be installed display "missing"
    local -a lines
    lines=(${(f)"$(
      mise ls --current --offline -J 2>/dev/null | jq -r --arg want "$closest_mise_toml" '
        to_entries[] as $e
        | $e.key as $tool
        | $e.value[]
        | select(.source.path == $want)
        | if .active then
            if (.version|length) > 0
              then "\($tool) \(.version)"
              else "\($tool)"
            end
          else
            "\($tool) missing"
          end
      '
    )"})

    # Whitelist of tools to show
    local -a whitelist=(node python go ruby rust)

    # Render segments (skip empty versions)
    local isFirst=true
    local line tool version tool_upper
    for line in $lines; do
      # split "tool [version]" → parts[1]=tool, parts[2]=version (if present)
      local -a parts
      parts=(${=line})
      tool="${parts[1]}"
      version="${parts[2]}"

      # show only if whitelisted and version present
      if (( ${whitelist[(Ie)$tool]} )) && [[ -n "$version" ]]; then
        tool_upper="${(U)tool}"
        if $isFirst; then
          p10k segment -t "via"
          isFirst=false
        fi
        p10k segment -r -i "${tool_upper}_ICON" -s "$tool_upper" -t "$version"
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
