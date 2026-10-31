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
