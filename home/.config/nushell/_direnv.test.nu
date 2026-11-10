use std/assert
use _direnv.nu *

const MOCK = path self | path dirname | path join _direnv.mock.nu

def fixture []: nothing -> path {
    let root = mktemp --directory
    mkdir ($root | path join bin) ($root | path join project)
    cp $MOCK ($root | path join bin direnv)
    ^chmod +x ($root | path join bin direnv)
    '' | save ($root | path join calls)
    $root
}

def test-direnv-exposes-only-reload-alias []: nothing -> nothing {
    let commands = scope commands | get name
    assert ('direnv-load' not-in $commands)
    assert ('direnv-reload' not-in $commands)
    assert equal (scope aliases | where name == dr | length) 1
}

def test-direnv-directory-hook-resolves-private-loader []: nothing -> nothing {
    let root = fixture
    let previous = $env.PWD
    load-env {
        PATH: ($env.PATH | prepend ($root | path join bin))
        NU_DIRENV_TEST_CALLS: ($root | path join calls)
    }
    cd ($root | path join project)
    do --env ($env.config.hooks.env_change.PWD | last)
    assert equal $env.NU_DIRENV_TEST_DIRECTORY $env.PWD
    assert equal (open --raw $env.NU_DIRENV_TEST_CALLS | lines) [export]
    cd $previous
    rm --permanent --recursive $root
}

def test-direnv-reload-refreshes-environment []: nothing -> nothing {
    let root = fixture
    let previous = $env.PWD
    load-env {
        PATH: ($env.PATH | prepend ($root | path join bin))
        NU_DIRENV_TEST_CALLS: ($root | path join calls)
    }
    cd ($root | path join project)
    dr
    assert equal $env.NU_DIRENV_TEST_DIRECTORY $env.PWD
    assert equal (open --raw $env.NU_DIRENV_TEST_CALLS | lines) [reload export]
    cd $previous
    rm --permanent --recursive $root
}
