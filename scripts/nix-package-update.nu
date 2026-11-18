use std/log

const CONFIGURATION = path self flake-updates.json

def run [command: string, arguments: list<string>]: nothing -> nothing {
    run-external $command ...$arguments out> /dev/stderr
}

def commit-update [config: record, version: string]: nothing -> nothing {
    run git [
        commit
        --only
        --message
        $"[deps] ($config.name): Update to ($version)"
        --
        ...$config.paths
    ]
}

# Update a flake package, switch Home Manager, and commit the result.
def main [
    package: string # Package name from flake-updates.json.
]: nothing -> nothing {
    let package_config = (open $CONFIGURATION | get --optional $package)
    if $package_config == null {
        log error $"Unknown package: ($package)"
        exit 1
    }
    let script = match $package_config.kind {
        "npm" => "scripts/npm-flake-update.ts"
        _ => {
            log error $"Unknown update kind: ($package_config.kind)"
            exit 1
        }
    }
    let config = {
        name: $package_config.name
        paths: [$package_config.path home/.config/home-manager/flake.lock]
    }
    let status = ^git status --porcelain -- ...$config.paths
    if ($status | is-not-empty) {
        log error $"Commit or stash existing ($config.name) source/lockfile changes first"
        exit 1
    }
    let update = (^sandbox bun run $script $package err> /dev/stderr | complete)
    if $update.exit_code == 2 { return }
    if $update.exit_code != 0 {
        log error $"($config.name) updater failed with exit code ($update.exit_code)"
        exit 1
    }
    let version = ($update.stdout | from json | get version | into string)
    run just [nix-hm-switch]
    commit-update $config $version
}
