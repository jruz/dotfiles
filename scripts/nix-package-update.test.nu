use std/assert
use std/log

const RUNNER = path self nix-package-update.nu
const LOCKFILE = "home/.config/home-manager/flake.lock"
const FLAKE = "home/.config/home-manager/flake.nix"
const HERDR = "home/.config/home-manager/packages/herdr-core.nix"
const CLAUDE = "home/.config/home-manager/packages/claude.nix"

const SANDBOX = '#!/usr/bin/env nu
use std/assert
def main [runtime: string, action: string, script: string, package: string] {
    assert equal [$runtime $action] [bun run]
    assert equal $package $env.PACKAGE
    let expected = if $package in [herdr-core claude] {
        "scripts/package-flake-update.ts"
    } else {
        "scripts/npm-flake-update.ts"
    }
    assert equal $script $expected
    if $env.SCENARIO == "current" { exit 2 }
    if $env.SCENARIO == "updater-failure" { exit 1 }
    "updated" | save --append $env.SOURCE
    {version: "9.8.7"} | to json --raw
}
'

const JUST = '#!/usr/bin/env nu
def main [recipe: string] {
    $"($recipe)\n" | save --append actions
    if $env.SCENARIO == $recipe { exit 1 }
    if $recipe == "nix-hm-switch" {
        "updated" | save --append home/.config/home-manager/flake.lock
    }
}
'

const SCENARIOS = [
    success
    current
    dirty-source
    dirty-lock
    updater-failure
    nix-hm-switch
]

def run [command: string, arguments: list<string>]: nothing -> nothing {
    run-external $command ...$arguments
}

def prepare []: nothing -> nothing {
    mkdir bin home/.config/home-manager/packages
    for file in [$LOCKFILE $FLAKE $HERDR $CLAUDE unrelated] {
        "original" | save $file
    }
    $SANDBOX | save bin/sandbox
    $JUST | save bin/just
    run chmod [+x bin/sandbox bin/just]
    run git [init --quiet]
    run git [config user.name Test]
    run git [config user.email test@example.invalid]
    run git [config commit.gpgsign "false"]
    run git [config core.hooksPath /dev/null]
    run git [add .]
    run git [commit --quiet --message initial]
    "unrelated change" | save --append unrelated
    run git [add unrelated]
}

def verify-result [case: record, result: record]: nothing -> nothing {
    let source = $case.source
    let scenario = $case.scenario
    let succeeds = $scenario in [success current]
    assert equal ($result.exit_code == 0) $succeeds $result.stderr
    let count = (^git rev-list --count HEAD | into int)
    assert equal $count (if $scenario == "success" { 2 } else { 1 })
    assert equal (^git diff --cached --name-only -- unrelated | str trim) unrelated
    if $scenario == "success" {
        let committed = (^git show --pretty=format: --name-only HEAD
            | lines
            | where $it != ""
            | sort)
        assert equal $committed ([$source $LOCKFILE] | sort)
        assert equal (open actions | lines) [nix-hm-switch]
        assert ((^git log -1 --format=%s | str trim) ends-with "Update to 9.8.7")
    }
    if $scenario in [current dirty-source dirty-lock updater-failure] {
        assert not ("actions" | path exists)
    }
}

def verify [package: string, scenario: string]: nothing -> record {
    let source = match $package {
        "herdr-core" => $HERDR
        "claude" => $CLAUDE
        _ => $FLAKE
    }
    let directory = (^mktemp --directory | str trim)
    let original = pwd
    let outcome = try {
        cd $directory
        prepare
        if $scenario == "dirty-source" {
            "dirty" | save --append $source
        }
        if $scenario == "dirty-lock" {
            "dirty" | save --append $LOCKFILE
            run git [add $LOCKFILE]
        }
        let result = (with-env {
            PATH: ($env.PATH | prepend ($directory | path join bin))
            SCENARIO: $scenario
            SOURCE: $source
            PACKAGE: $package
        } { ^nu $RUNNER $package | complete })
        verify-result {source: $source, scenario: $scenario} $result
        {success: true}
    } catch {|error|
        {success: false, error: $error}
    }
    cd $original
    rm --recursive --force $directory
    $outcome
}

def main []: nothing -> nothing {
    for package in [herdr-core claude pi] {
        for scenario in $SCENARIOS {
            let outcome = verify $package $scenario
            if not $outcome.success {
                log error $outcome.error.rendered
                exit 1
            }
            print $"PASS ($package): ($scenario)"
        }
    }
}
