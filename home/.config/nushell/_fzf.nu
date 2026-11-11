export-env {
    $env.FZF_DEFAULT_COMMAND = 'fd --type file --hidden --show-errors --exclude .git --exclude node_modules --exclude .obsidian --exclude target --exclude .direnv'
}

def list-files []: nothing -> string {
    print --stderr --no-newline "listing files..."
    let files = (^fd --type file --hidden --show-errors
        --exclude .git --exclude node_modules --exclude .obsidian --exclude target --exclude .direnv)
    print --stderr --no-newline $"\r(ansi erase_entire_line)"
    $files
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
