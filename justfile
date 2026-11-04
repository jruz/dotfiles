mod ts '.just/ts.justfile'
mod bun '.just/bun.justfile'

# ─── main ─────────────────────────────────────────────────────────────────────

check:
    just parallel \
      just-fmt-check \
      nix-check \
      shellcheck-check \
      lua-check \
      nushell-check \
      ts::check \
      woodpecker-check \
      bun::check

setup:
    just ts::install

test:
    just bun::test
    just ts::oxlint-rules-check
    just nushell-test

fix:
    just just-fmt-fix
    just nix-fix
    just ts::fix

clean:
    just nix-clean

stow:
    #!/usr/bin/env nu
    match $nu.os-info.name {
      "macos" => { ^just stow-mac }
      "linux" => { ^just stow-linux }
      $other => { error make {msg: $"Unsupported Stow platform: ($other)"} }
    }

bootstrap:
    #!/usr/bin/env nu
    ^just git-hooks-setup
    print "Stowing dotfiles..."
    if (^uname) == "Darwin" {
      ^just stow-mac
      print ""
      print "Setting up Home Manager..."
      ^just nix-hm-switch
      print ""
      print "Setting up nix-darwin..."
      ^just nix-darwin-switch
    } else {
      ^just stow-linux
      print ""
      print "Setting up Home Manager..."
      ^just nix-hm-switch
    }
    print ""
    print "Configuring SSH agent..."
    ^just ssh-setup
    print ""
    print "Bootstrap complete!"

parallel +RECIPES:
    #!/usr/bin/env nu
    let runs = ([{{ RECIPES }}] | par-each {|recipe|
        ^just $recipe o+e>| complete | insert recipe $recipe })
    for run in $runs {
        if $run.exit_code == 0 {
            print $"PASS ($run.recipe)"
        } else {
            print $"FAIL ($run.recipe)" $run.stdout
        }
    }
    if ($runs | any {|run| $run.exit_code != 0 }) { exit 1 }

# ─── just ─────────────────────────────────────────────────────────────────────

just-fmt-check:
    just \
      --fmt \
      --check \
      --unstable

just-fmt-fix:
    just \
      --fmt \
      --unstable

# ─── nix ──────────────────────────────────────────────────────────────────────

nix-check:
    fd \
      --extension nix \
      --exec nixfmt --check
    statix check .
    deadnix --fail .
    just nix-version-sync-check

nix-fix:
    fd \
      --extension nix \
      --exec nixfmt
    statix fix .
    deadnix --edit .

nix-version-sync-check:
    sandbox bun run scripts/nix-check-version-sync.ts

nix-list:
    nix-channel --list

nix-latest:
    #!/usr/bin/env nu
    (gh api repos/NixOS/nixpkgs/branches
      --paginate -q '.[].name'
      | lines
      | where {|it| $it =~ '^nixos-\d+\.\d+$'}
      | sort --natural
      | last
      | split row '-'
      | last)

nix-channel-upgrade VERSION:
    nix-channel --add https://nixos.org/channels/nixos-{{ VERSION }} nixpkgs
    nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
    nix-channel --update
    nix-channel --list

nix-core-upgrade:
    sudo nix upgrade-nix

nix-full-upgrade:
    just nix-channel-upgrade $(just nix-latest)
    just nix-core-upgrade
    just nix-hm-update
    just nix-hm-switch
    just nix-darwin-update

nix-clean:
    nix-collect-garbage

# ─── home manager ─────────────────────────────────────────────────────────────

nix-hm-edit:
    cp -r ~/.config/home-manager ~/dev/dotfiles/home/.config
    nvim ~/dev/dotfiles/home/.config/home-manager/home.nix

nix-hm-config:
    rm -rf ~/.config/home-manager
    cp -r ~/dev/dotfiles/home/.config/home-manager ~/.config

nix-hm-update:
    nix flake update --flake ./home/.config/home-manager/
    just nix-hm-switch

nix-hm-switch:
    #!/usr/bin/env nu
    ^just nix-hm-config
    let system = (^nix eval
      --impure
      --raw
      --expr "builtins.currentSystem")
    let flake = $"($env.HOME)/.config/home-manager#jruz@($system)"
    ^home-manager switch --flake $flake
    ^cp $"($env.HOME)/.config/home-manager/flake.lock" home/.config/home-manager/flake.lock
    ^bat cache --build

# ─── nix darwin ───────────────────────────────────────────────────────────────

nix-darwin-diff:
    vimdiff ~/.config/nix-darwin/flake.nix ~/dev/dotfiles/mac/nix-darwin/flake.nix

nix-darwin-edit:
    cp -r ~/.config/nix-darwin ~/dev/dotfiles/mac
    nvim ~/dev/dotfiles/mac/nix-darwin/flake.nix

nix-darwin-switch:
    cp -r ~/dev/dotfiles/mac/nix-darwin ~/.config
    sudo darwin-rebuild switch --flake ~/.config/nix-darwin

nix-darwin-update:
    nix flake update --flake ~/.config/nix-darwin
    sudo darwin-rebuild switch --flake ~/.config/nix-darwin

# ─── lua ──────────────────────────────────────────────────────────────────────

lua-check:
    cd home/.config/nvim && selene .

# ─── shellcheck ───────────────────────────────────────────────────────────────

shellcheck-check:
    fd -e sh --exclude tmp -x shellcheck \
      --shell=bash \
      -e SC1090 \
      -e SC1091

# ─── nushell ──────────────────────────────────────────────────────────────────

nushell-check:
    #!/usr/bin/env nu
    use std/assert
    use '{{ justfile_directory() }}/scripts/nushell-files.nu' discover
    let files = discover
    for file in $files { assert (nu-check --debug $file) }
    ^nu-lint --config nu-lint.toml --format compact ...$files home/.local/bin

nushell-fix:
    #!/usr/bin/env nu
    use '{{ justfile_directory() }}/scripts/nushell-files.nu' discover
    let files = discover
    ^nu-lint --config nu-lint.toml --fix ...$files home/.local/bin

nushell-test:
    nu --no-config-file home/.local/bin/test-runner.nu

nushell-set:
    #!/usr/bin/env nu
    let shell_path = if (^uname) == "Darwin" {
      "/run/current-system/sw/bin/nu"
    } else {
      $"($env.HOME)/.nix-profile/bin/nu"
    }
    let shells = open /etc/shells | lines
    if not ($shell_path in $shells) {
      print $"Adding ($shell_path) to /etc/shells..."
      $"($shell_path)\n" | ^sudo tee --append /etc/shells
    }
    print $"Changing shell to ($shell_path)..."
    print "You may be prompted for your password:"
    ^chsh -s $shell_path
    print "Shell changed! Restart your terminal for it to take effect."

# ─── woodpecker ───────────────────────────────────────────────────────────────

woodpecker-check:
    woodpecker-cli lint --strict .woodpecker/

# ─── ssh ──────────────────────────────────────────────────────────────────────

ssh-keygen EMAIL:
    ssh-keygen -t ed25519 -C "{{ EMAIL }}"

ssh-setup:
    #!/usr/bin/env nu
    if (^uname) == "Darwin" {
      ^ssh-add --apple-use-keychain ~/.ssh/jruz
    } else {
      ^ssh-add ~/.ssh/jruz
    }

ssh-list:
    ssh-add -L

ssh-remove-all:
    ssh-add -D

ssh-add-all:
    just ssh-remove-all
    ssh-add ~/.ssh/ovh
    ssh-add ~/.ssh/mini
    ssh-add ~/.ssh/codeberg
    ssh-add ~/.ssh/github

# ─── git ──────────────────────────────────────────────────────────────────────

git-hooks-setup:
    #!/usr/bin/env nu
    ^git config --local core.hooksPath .githooks
    print "Git hooks path set to .githooks"

git-config:
    git --no-pager config --global -l

# ─── github ───────────────────────────────────────────────────────────────────

github-auth:
    #!/usr/bin/env nu
    ^gh auth login
    ^gh ssh-key add ~/.ssh/jruz.pub

github-signing:
    gh ssh-key add ~/.ssh/jruz.pub --type signing

# ─── stow ─────────────────────────────────────────────────────────────────────

stow-home:
    stow -t ~ -v --ignore='home-manager' home

stow-mac:
    just stow-home
    stow -t ~ -v home-mac

stow-linux:
    just stow-home
    stow -t ~ -v home-linux

# ─── tmux ─────────────────────────────────────────────────────────────────────

tmux-plugins:
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    # do Ctrl+a I to install the plugins

# ─── neovim ───────────────────────────────────────────────────────────────────

nvim-plugins-clean:
    nvim --headless '+PluginsClean' '+qa'

nvim-plugins-update:
    nvim --headless '+PluginsUpdate!' '+qa'

# ─── mac ──────────────────────────────────────────────────────────────────────

mac-uninstall-dry-run:
    cd home-mac && brew bundle cleanup

mac-uninstall:
    cd home-mac && brew bundle cleanup --force

mac-install:
    cd home-mac && brew bundle

mac-outdated:
    brew outdated
    mas outdated

mac-update:
    brew update
    cd home-mac && brew bundle upgrade

# ─── ubuntu ───────────────────────────────────────────────────────────────────

ubuntu-update:
    sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove

# ─── ip ───────────────────────────────────────────────────────────────────────

ip-router:
    #!/usr/bin/env nu
    let match = arp -a | lines | find '7c:10:c9:b3:b0:d8' | first
    if $match == null { error make {msg: "Router not found in ARP table"} }
    let ip = $match | parse -r '\((?<ip>[0-9.]+)\)' | get ip.0?
    if $ip == null { error make {msg: "Could not parse IP from ARP entry"} }
    print $"http://($ip)"

ip-repeater:
    #!/usr/bin/env nu
    let match = arp -a | lines | find '8:8a:f1:f:69:f6' | first
    if $match == null { error make {msg: "Repeater not found in ARP table"} }
    let ip = $match | parse -r '\((?<ip>[0-9.]+)\)' | get ip.0?
    if $ip == null { error make {msg: "Could not parse IP from ARP entry"} }
    print $"http://($ip)"

# ─── agents ───────────────────────────────────────────────────────────────────

agent-update AGENT:
    #!/usr/bin/env nu
    let result = (^sandbox bun run scripts/check-agent-update.ts {{ AGENT }} | complete)
    print $result.stderr
    if $result.exit_code == 0 {
      ^just nix-hm-switch
    } else if $result.exit_code != 2 {
      exit 1
    }

claude-update:
    just agent-update claude

codex-update:
    just agent-update codex

pi-update:
    just agent-update pi

herdr-core-update:
    #!/usr/bin/env nu
    let result = (^sandbox bun run scripts/herdr-core-update.ts | complete)
    print $result.stderr
    if $result.exit_code == 0 {
      ^just nix-hm-switch
    } else if $result.exit_code != 2 {
      exit 1
    }

# ─── ntfy ─────────────────────────────────────────────────────────────────────

ntfy-subscribe:
    #!/usr/bin/env nu
    let log_path = ($env.HOME | path join Library Logs ntfy-subscribe.log)
    let notifier = (which terminal-notifier | first | get path)
    (^launchctl submit
      -l io.jruz.ntfy-subscribe
      -o $log_path
      -e $log_path
      -- (which ntfy | first | get path) subscribe
      $env.NTFY_CHANNEL
      $"'($notifier)' -title \"$NTFY_TITLE\" -message \"$NTFY_MESSAGE\" -sound default")

ntfy-stop:
    launchctl remove io.jruz.ntfy-subscribe

# ─── zellij ───────────────────────────────────────────────────────────────────

zellij-generate-mac:
    sandbox bun run scripts/zellij-generate-layout.ts --name mac

zellij-generate-mini:
    sandbox bun run scripts/zellij-generate-layout.ts --name mini
