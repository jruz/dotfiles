def "parse vars" [] {
  $in | from csv --noheaders --no-infer | rename 'op' 'name' 'value'
}

def --env "update-env" [] {
  for $var in $in {
    if $var.op == "set" {
      if ($var.name | str upcase) == 'PATH' {
        let mise_paths = ($var.value | split row (char esep))
        let existing_paths = ($env.PATH | where $it not-in $mise_paths)
        $env.PATH = ($existing_paths | append $mise_paths)
      } else {
        load-env {($var.name): $var.value}
      }
    } else if $var.op == "hide" and $var.name in $env {
      hide-env $var.name
    }
  }
}
export-env {
  
  "hide,CARGO_HOME,
hide,DENO_INSTALL_ROOT,
hide,RUSTUP_HOME,
hide,RUSTUP_TOOLCHAIN,
set,PATH,/Users/jruz/.nix-profile/bin:/Users/jruz/.nix-profile/bin:/Users/jruz/.orbstack/bin:/Users/jruz/.nix-profile/bin:/Users/jruz/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/Users/jruz/.local/share/zinit/polaris/bin:/Users/jruz/.nix-profile/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/jruz/.local/bin:/Users/jruz/.config/emacs/bin
hide,MISE_SHELL,
hide,__MISE_DIFF,
hide,__MISE_DIFF,
" | parse vars | update-env
  $env.MISE_SHELL = "nu"
  let mise_hook = {
    condition: { "MISE_SHELL" in $env }
    code: { mise_hook }
  }
  add-hook hooks.pre_prompt $mise_hook
  add-hook hooks.env_change.PWD $mise_hook
}

def --env add-hook [field: cell-path new_hook: any] {
  let field = $field | split cell-path | update optional true | into cell-path
  let old_config = $env.config? | default {}
  let old_hooks = $old_config | get $field | default []
  $env.config = ($old_config | upsert $field ($old_hooks ++ [$new_hook]))
}

export def --env --wrapped main [command?: string, --help, ...rest: string] {
  let commands = ["deactivate", "shell", "sh"]

  if ($command == null) {
    ^"/Users/jruz/.nix-profile/bin/mise"
  } else if ($command == "activate") {
    $env.MISE_SHELL = "nu"
  } else if ($command in $commands) {
    ^"/Users/jruz/.nix-profile/bin/mise" $command ...$rest
    | parse vars
    | update-env
  } else {
    ^"/Users/jruz/.nix-profile/bin/mise" $command ...$rest
  }
}

def --env mise_hook [] {
  ^"/Users/jruz/.nix-profile/bin/mise" hook-env -s nu
    | parse vars
    | update-env
}

