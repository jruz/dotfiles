set working-directory := '..'

edit:
    cp -r ~/.config/home-manager ~/dev/dotfiles/home/.config
    nvim ~/dev/dotfiles/home/.config/home-manager/home.nix

config:
    rm -rf ~/.config/home-manager
    cp -r ~/dev/dotfiles/home/.config/home-manager ~/.config

update:
    nix flake update --flake ./home/.config/home-manager/
    just home-manager::switch

input-update INPUT:
    nix flake update {{ quote(INPUT) }} --flake ./home/.config/home-manager/

switch:
    just home-manager::config
    just home-manager::activate

[private]
activate:
    #!/usr/bin/env nu
    let system = (^nix eval --expr "builtins.currentSystem"
      --impure
      --raw)
    let flake = $"($env.HOME)/.config/home-manager#jruz@($system)"
    ^home-manager switch --flake $flake
    if $env.LAST_EXIT_CODE != 0 { exit $env.LAST_EXIT_CODE }
    ^cp $"($env.HOME)/.config/home-manager/flake.lock" home/.config/home-manager/flake.lock
    if $env.LAST_EXIT_CODE != 0 { exit $env.LAST_EXIT_CODE }
    ^bat cache --build

config-check:
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

build-check:
    #!/usr/bin/env nu
    let system = (^nix eval
      --impure
      --raw
      --expr "builtins.currentSystem")
    (^nix build
      --no-link
      $"path:./home/.config/home-manager#homeConfigurations.\"jruz@($system)\".activationPackage")
