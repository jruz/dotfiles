export-env {
    $env.FZF_DEFAULT_COMMAND = 'rg --files --glob=!{.git,node_modules,.obsidian}'
}

export def path [] {
    let result = (
        ^rg --files --glob "!{.git,node_modules,.obsidian}"
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
