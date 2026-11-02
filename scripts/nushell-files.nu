export def discover []: nothing -> list<string> {
    let result = (^fd --hidden --no-ignore --type file --extension nu
        --exclude .git --exclude node_modules --exclude tmp
        | complete)
    if $result.exit_code != 0 { error make {msg: $result.stderr} }
    $result.stdout | lines | path expand | sort
}
