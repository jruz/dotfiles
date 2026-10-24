export-env {
    $env.FZF_DEFAULT_COMMAND = 'rg --files --glob=!{.git,node_modules,.obsidian}'
}

def list-files []: nothing -> string {
    print --stderr --no-newline "listing files..."
    let result = (^rg --files --glob "!{.git,node_modules,.obsidian}" | complete)
    print --stderr --no-newline $"\r(ansi erase_entire_line)"

    if $result.exit_code in [0 1] {
        return $result.stdout
    }

    let failures = $result.stderr | lines | where not ($it | str ends-with "Permission denied (os error 13)")
    if ($failures | is-not-empty) {
        error make {msg: $"rg file listing failed: ($failures | str join (char newline))"}
    }

    $result.stdout
}

export def path []: nothing -> oneof<string, error> {
    let files = list-files

    if ($files | is-empty) {
        return ""
    }

    let result = (
        $files
        | ^fzf --height "40%" --layout reverse --prompt "path> "
        | complete
    )

    if $result.exit_code == 0 {
        let selected = ($result.stdout | str trim)

        if ($selected | is-empty) {
            return ""
        }

        return ($selected | to nuon)
    }

    if $result.exit_code in [1 130] {
        return ""
    }

    error make {msg: $"fzf path selection failed: ($result.stderr | str trim)"}
}
