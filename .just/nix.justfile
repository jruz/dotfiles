set working-directory := '..'

check:
    fd \
      --extension nix \
      --exec nixfmt --check
    statix check .
    deadnix --fail .
    just nix::version-sync-check

fix:
    fd \
      --extension nix \
      --exec nixfmt
    statix fix .
    deadnix --edit .

version-sync-check:
    sandbox bun run scripts/nix-check-version-sync.ts

build:
    #!/usr/bin/env nu
    let system = (^nix eval
      --impure
      --raw
      --expr "builtins.currentSystem")
    (^nix build
      --no-link
      $"path:.#devShells.($system).default")
