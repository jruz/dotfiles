const LOADER = path self | path dirname | path join _env-load.nu

def check-loader [directory: path, assertions: string]: nothing -> nothing {
    let script = $directory | path join check.nu
    $"use std/assert\nuse '($LOADER)'\n($assertions)\n" | save $script
    with-env {HOME: $directory} {
        ^nu --no-config-file $script
    }
    rm --permanent --recursive $directory
}

def test-env-load-preserves-equals []: nothing -> nothing {
    let directory = mktemp --directory
    'NU_ENV_LOAD_TEST_VALUE=first=second==' | save ($directory | path join .env)
    check-loader $directory "assert equal $env.NU_ENV_LOAD_TEST_VALUE 'first=second=='"
}

def test-env-load-preserves-empty-values []: nothing -> nothing {
    let directory = mktemp --directory
    'NU_ENV_LOAD_TEST_VALUE=' | save ($directory | path join .env)
    check-loader $directory "assert equal $env.NU_ENV_LOAD_TEST_VALUE ''"
}

def test-env-load-comments-and-duplicates []: nothing -> nothing {
    let directory = mktemp --directory
    "# Synthetic test data\n\nNU_ENV_LOAD_TEST_VALUE=first\nNU_ENV_LOAD_TEST_VALUE=last\n"
    | save ($directory | path join .env)
    check-loader $directory "assert equal $env.NU_ENV_LOAD_TEST_VALUE 'last'"
}

def test-env-load-missing-file []: nothing -> nothing {
    let directory = mktemp --directory
    check-loader $directory "assert ('NU_ENV_LOAD_TEST_VALUE' not-in $env)"
}
