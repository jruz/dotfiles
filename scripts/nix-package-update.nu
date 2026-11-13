const CONFIGURATION = path self flake-updates.json

def configuration [package: string]: nothing -> record {
    let config = (open $CONFIGURATION | get --optional $package)
    if $config == null { error make {msg: $"Unknown package: ($package)"} }
    let script = match $config.kind {
        "npm" => "scripts/npm-flake-update.ts"
        "release-manifest" | "anthropic-manifest" => "scripts/package-flake-update.ts"
        _ => { error make {msg: $"Unknown update kind: ($config.kind)"} }
    }
    {
        name: $config.name
        paths: [$config.path home/.config/home-manager/flake.lock]
        updater: [bun run $script $package]
    }
}

def run [command: string, arguments: list<string>]: nothing -> nothing {
    let result = (run-external $command ...$arguments | complete)
    print --stderr --no-newline $result.stdout
    print --stderr --no-newline $result.stderr
    if $result.exit_code != 0 {
        error make {msg: $"($command) failed with exit code ($result.exit_code)"}
    }
}

def ensure-clean [config: record]: nothing -> nothing {
    let status = (^git status --porcelain -- ...$config.paths | complete)
    if $status.exit_code != 0 { error make {msg: $status.stderr} }
    if ($status.stdout | is-not-empty) {
        error make {msg: $"Commit or stash existing ($config.name) source/lockfile changes first"}
    }
}

def update-source [config: record]: nothing -> record {
    let update = (^sandbox ...$config.updater | complete)
    print --stderr --no-newline $update.stderr
    if $update.exit_code == 2 { return {changed: false} }
    if $update.exit_code != 0 {
        error make {msg: $"($config.name) updater failed with exit code ($update.exit_code)"}
    }
    {
        changed: true
        version: ($update.stdout | from json | get version | into string)
    }
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

def main [package: string]: nothing -> nothing {
    try {
        let config = configuration $package
        ensure-clean $config
        let update = update-source $config
        if not $update.changed { return }
        run just [nix-hm-switch]
        commit-update $config $update.version
    } catch {|error|
        print --stderr $error.msg
        exit 1
    }
}
