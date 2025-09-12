at() {
  emulate -L zsh

  local mapfile name def
  mapfile=$(mktemp -t at_aliases.XXXXXX) || return 1

  # Build a table: "<name>\t<definition>"
  for name in ${(k)aliases}; do
    [[ $name == @* && $name != @ ]] || continue
    def=${aliases[$name]}
    def=${def//$'\n'/ }                 # flatten newlines
    printf '%s\t%s\n' "$name" "$def" >> "$mapfile"
  done

  if [[ ! -s $mapfile ]]; then
    print -u2 "No @-aliases found."
    rm -f -- "$mapfile"
    return 1
  fi

  # --- Compute preview width based on longest alias name ---
  # Terminal columns (fallback to 80 if unknown)
  local cols=${COLUMNS:-$(tput cols 2>/dev/null || print -r -- 80)}

  # Longest alias name length
  local maxlen
  maxlen=$(cut -f1 "$mapfile" | awk '{ if (length>max) max=length } END { print max+0 }')
  [[ -z $maxlen ]] && maxlen=1

  # Add some padding between list and preview
  local padding=4
  local listw=$(( maxlen + padding ))

  # Keep list width reasonable
  (( listw < 20 ))       && listw=20
  (( listw > cols - 20 )) && listw=cols - 20

  # Preview takes the remaining space, as a percentage
  local preview_pct=$(( 100 - ( (listw * 100) / cols ) ))
  # Clamp to sane bounds
  (( preview_pct < 20 )) && preview_pct=20
  (( preview_pct > 95 )) && preview_pct=95

  # --- fzf with dynamic preview width ---
  local sel
  sel=$(
    cut -f1 "$mapfile" | sort |
    fzf --ansi \
        --preview="awk -F '\t' -v k='{}' '\$1==k{print \$2}' \"$mapfile\" | bat -l sh --color=always --style=plain" \
        --preview-window="right:${preview_pct}%:wrap"
  ) || { rm -f -- "$mapfile"; return }

  rm -f -- "$mapfile"
  eval "$sel"        # run the chosen @-alias
}

alias @=at
