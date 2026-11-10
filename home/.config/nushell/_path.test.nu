use std/assert

def test-path-module-preserves-order-and-removes-duplicates []: nothing -> nothing {
    $env.PATH = [/example/tools /example/tools /usr/bin]
    use _path.nu
    assert equal ($env.PATH | first 4) [
        ($env.HOME | path join .cargo bin)
        ($env.HOME | path join .amp bin)
        ($env.HOME | path join .orbstack bin)
        /example/tools
    ]
    assert ('/usr/bin' in $env.PATH)
    assert (($env.HOME | path join .local bin) in $env.PATH)
    assert equal ($env.PATH | length) ($env.PATH | uniq | length)
}

def test-path-module-keeps-temporaries-private []: nothing -> nothing {
    use _path.nu
    let names = scope variables | get name
    assert ('$base_paths' not-in $names)
    assert ('$existing_path' not-in $names)
}
