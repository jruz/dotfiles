export-env {
  if ('~/.env' | path expand | path exists) {
    load-env (
      open --raw ~/.env
        | lines
        | where $it !~ '^#'
        | where $it != ''
        | split column --number 2 '=' key value
        | transpose --header-row --keep-last
        | into record
    )
  }
}
