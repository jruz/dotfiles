if ('~/.env' | path expand | path exists) {
  load-env (
    open ~/.env
      | lines
      | where $it !~ '^#'
      | where $it != ''
      | split column '=' key value
      | reduce --fold {} {|it, acc| $acc | insert $it.key $it.value }
  )
}
