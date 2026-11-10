use std/assert
use _functions.nu *
use _just-completions.nu *

const PUBLIC_COMMANDS = [
    wr gcmsg gdr gld glm grm grc grr gpsu gpsuf gri last-commit
    tme untar encrypt decrypt wifi-ip cable-ip eject brain mp yf yo wh
    tma tmk zk za zel tmux-dev zellij-mac zellij-mini gen-passphrase gen-ssh-key
]

const PRIVATE_HELPERS = [
    is-linux is-osx is-ssh osc52-copy this-branch get-ip brain-path
    'nu-complete zellij-sessions'
    'nu-complete tmux-sessions'
    get-recipes
    'nu-complete just'
    'nu-complete just assignments'
    'nu-complete just al-st'
    'nu-complete just format'
    'nu-complete just shells'
    'nu-complete just color-when'
    'nu-complete just color'
]

def test-modules-export-interactive-commands []: nothing -> nothing {
    let commands = scope commands | get name
    for name in $PUBLIC_COMMANDS {
        assert ($name in $commands) $"Expected public command: ($name)"
    }
}

def test-modules-hide-internal-helpers []: nothing -> nothing {
    let commands = scope commands | get name
    for name in $PRIVATE_HELPERS {
        assert ($name not-in $commands) $"Unexpected public helper: ($name)"
    }
}

def test-modules-export-just-signature []: nothing -> nothing {
    assert equal (which just | get type) [external]
}

def test-exported-wh-inspects-imported-command []: nothing -> nothing {
    assert equal (wh just | get type) [external]
}
