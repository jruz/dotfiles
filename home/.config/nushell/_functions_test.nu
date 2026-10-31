source _functions.nu
use std/assert

def test-gen-passphrase-default []: nothing -> nothing {
    assert ((gen-passphrase) =~ '^([A-Z][a-z]+-){4}[0-9]$')
}

def test-gen-passphrase-one-word []: nothing -> nothing {
    assert ((gen-passphrase 1) =~ '^[A-Z][a-z]+-[0-9]$')
}

def test-gen-passphrase-five-words []: nothing -> nothing {
    assert ((gen-passphrase 5) =~ '^([A-Z][a-z]+-){5}[0-9]$')
}

def test-gen-ssh-key-without-passphrase []: nothing -> nothing {
    let directory = (^mktemp --directory | str trim)
    let result = (do { gen-ssh-key test-key --directory $directory --no-passphrase } | complete)
    let private_exists = ($directory | path join "test-key" | path exists)
    let public_exists = ($directory | path join "test-key.pub" | path exists)
    ^rm --recursive --force $directory
    assert equal $result.exit_code 0
    assert $private_exists
    assert $public_exists
}
