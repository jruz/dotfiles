use std/config *

def --env direnv-load []: nothing -> nothing {
  ^direnv export json
  | from json
  | default {}
  | update cells --columns [PATH] { do (env-conversions).path.from_string $in }
  | load-env
}

def --env direnv-reload []: nothing -> nothing {
  ^direnv reload
  direnv-load
}

export alias dr = direnv-reload

export-env {
  $env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []
  $env.config.hooks.env_change.PWD ++= [{|| direnv-load }]
}
