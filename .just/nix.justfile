set working-directory := '..'

check:
    fd \
      --hidden \
      --extension nix \
      --exec nixfmt --check
    statix check .
    deadnix --fail .
    just nix::version-sync-check

fix:
    fd \
      --hidden \
      --extension nix \
      --exec nixfmt
    statix fix .
    deadnix --edit .

version-sync-check:
    sandbox bun run scripts/nix-check-version-sync.ts

hm-config-check:
    #!/usr/bin/env nu
    let flake = "path:./home/.config/home-manager"
    let configurations = (^nix eval
      --json
      $"($flake)#homeConfigurations"
      --apply builtins.attrNames
      | from json)
    for name in $configurations {
      ^nix eval --raw $"($flake)#homeConfigurations.\"($name)\".activationPackage.drvPath" | ignore
    }

hm-build-check:
    #!/usr/bin/env nu
    let system = (^nix eval
      --impure
      --raw
      --expr "builtins.currentSystem")
    (^nix build
      --no-link
      $"path:./home/.config/home-manager#homeConfigurations.\"jruz@($system)\".activationPackage")

build:
    #!/usr/bin/env nu
    let system = (^nix eval
      --impure
      --raw
      --expr "builtins.currentSystem")
    (^nix build
      --no-link
      $"path:.#devShells.($system).default")
