#!/usr/bin/env nu

# Simulate direnv for isolated integration tests.
def main [
    action: string # Direnv action to record.
    ..._args: string # Additional arguments accepted by direnv.
]: nothing -> nothing {
    $"($action)\n" | save --append $env.NU_DIRENV_TEST_CALLS
    if $action == 'export' {
        {NU_DIRENV_TEST_DIRECTORY: $env.PWD} | to json | print
    }
}
