#compdef fh

_fh() {
  local -a commands
  commands=(
    'checkout:Checkout branch'
    'view:View folder/files in the browser'
    'pr:PR related commands'
    'prune:Prune merged branches'
    'push:Push to origin by default'
    'delete:Delete branches'
    'sync:Sync main/master branch'
    'remote:Remote related commands'
  )

  if (( CURRENT == 2 )); then
    _describe -t commands 'fh commands' commands
  elif (( CURRENT == 3 )); then
    case $words[2] in
      pr)
        local -a pr_commands
        pr_commands=(
          'checkout:Checkout PR branch'
          'view:View PR in the browser'
        )
        _describe -t commands 'pr commands' pr_commands
        ;;
      remote)
        local -a remote_commands
        remote_commands=(
          'add:Add forked repositories to remote'
          'delete:Delete remote'
        )
        _describe -t commands 'remote commands' remote_commands
        ;;
    esac
  fi
}

_fh "$@"
