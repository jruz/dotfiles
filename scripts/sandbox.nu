def image-name [config: record]: nothing -> string {
    let key = ([$config.dockerfile $config.build_args]
        | to json --raw
        | hash sha256
        | str substring 0..15)
    $"sandbox-($config.name):($key)"
}

def ensure-image [config: record]: nothing -> string {
    let image = (image-name $config)
    let lookup = (^docker image ls --quiet --filter $"reference=($image)" | complete)
    if $lookup.exit_code != 0 {
        error make {msg: $lookup.stderr}
    }
    if ($lookup.stdout | str trim | is-not-empty) {
        return $image
    }
    let args = ($config.build_args
        | items {|name, value| [--build-arg $"($name)=($value)"] }
        | flatten)
    let built = ($config.dockerfile
        | ^docker build
            --quiet
            --tag $image
            ...$args
            -)
    $built | str trim
}

def node-image [root: path, engines: record]: nothing -> string {
    let dockerfile = (open --raw ($root | path join Dockerfile.node))
    ensure-image {
        name: node
        dockerfile: $dockerfile
        build_args: {
            NODE_VERSION: $engines.node
            PNPM_VERSION: $engines.pnpm
        }
    }
}

def pnpm-mounts []: nothing -> list<string> {
    let store = ($env.HOME | path join .local share pnpm)
    let cache = ($env.HOME | path join .cache pnpm)
    mkdir $store $cache
    [
        --mount $"type=bind,src=($store),dst=($store)"
        --mount $"type=bind,src=($cache),dst=($cache)"
        --env $"pnpm_config_store_dir=($store)/store"
        --env $"pnpm_config_cache_dir=($cache)"
    ]
}

def host-output [command: string, ...args: string]: nothing -> string {
    let result = (run-external $command ...$args | complete)
    if $result.exit_code != 0 {
        error make {msg: $result.stderr}
    }
    $result.stdout | str trim
}

def secret-mounts [root: path]: nothing -> list<string> {
    (open ($root | path join ager.yaml)
        | get entries
        | where ($root | path join $it | path exists)
        | each {|entry|
            [--mount $"type=bind,src=/dev/null,dst=/app/($entry),readonly"]
        }
        | flatten)
}

def run-sandbox [command: string, args: list<string>]: nothing -> nothing {
    let root = (host-output git rev-parse '--show-toplevel')
    let relative = ($env.PWD | path relative-to $root)
    let engines = (open ($root | path join package.json) | get engines)
    let runtime = match $command {
        bun => {image: $"oven/bun:($engines.bun)", mounts: []}
        _ => {image: (node-image $root $engines), mounts: (pnpm-mounts)}
    }
    let uid = (host-output id '--user')
    let gid = (host-output id '--group')
    (exec docker run
        --interactive
        --rm
        --user $"($uid):($gid)"
        --read-only
        --cap-drop ALL
        --security-opt no-new-privileges
        --tmpfs /tmp
        --env HOME=/tmp
        --mount $"type=bind,src=($root),dst=/app"
        --workdir $"/app/($relative)"
        ...$runtime.mounts
        ...(secret-mounts $root)
        $runtime.image
        $command
        ...$args)
}

def --wrapped main [command: string, ...args: string]: nothing -> nothing {
    if $command not-in [node pnpm bun] {
        print --stderr $"Unsupported sandbox command: ($command)"
        exit 1
    }
    try {
        run-sandbox $command $args
    } catch {|err|
        print --stderr $err.msg
        exit 1
    }
}
