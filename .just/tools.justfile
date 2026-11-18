set working-directory := '..'

check:
    nix develop ./.tools --command check

renovate-dry-run:
    nix develop ./.tools --command just --justfile .tools/justfile renovate::dry-run
