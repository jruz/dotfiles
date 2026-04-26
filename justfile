set dotenv-load

check:
  just nix-check
  just nix-check-version-sync
  just lint-sh
  just lint-lua
  just nushell-lint
  just ts-check

ts-install:
  just docker-run bun install

ts-check:
  just ts-install
  just docker-run bun run prettier --check .
  just docker-run bun run tsc --noEmit
  just docker-run bun run eslint .

ts-fix:
  just ts-install
  just docker-run bun run prettier --write .
  just docker-run bun run eslint . --fix

fix:
  just nix-fix
  just ts-fix

# ---------------- DOCKER
docker-run *ARGS:
  #!/usr/bin/env nu
  let args = ("{{ARGS}}" | split row ' ' | where { |it| $it != "" })
  (^docker run
    --rm
    --volume $"(pwd):/app"
    --volume bun-modules:/app/node_modules
    --workdir /app
    "registry.jruz.io/bun:1.3.11-1"
    ...$args)

clean:
  just nix-clean

nix-check:
  fd \
    --extension nix \
    --exec nixfmt --check
  statix check .
  deadnix --fail .

nix-fix:
  fd \
    --extension nix \
    --exec nixfmt
  statix fix .
  deadnix --edit .

nix-check-version-sync:
  just docker-run bun run scripts/nix-check-version-sync.ts

lint-lua:
  cd home/.config/nvim && selene .

lint-sh:
  fd -e sh --exclude tmp -x shellcheck \
    --shell=bash \
    -e SC1090 \
    -e SC1091

nushell-lint:
  #!/usr/bin/env nu
  ^fd -e nu . home/.config/nushell | lines | each { |file|
    print $"Checking ($file)..."
    nu -c $"source ($file)"
  }
  print "\n✓ All Nushell files are valid"

nushell-test:
  test-runner.nu

ssh-keygen EMAIL:
  ssh-keygen -t ed25519 -C "{{EMAIL}}"

github-auth:
  #!/usr/bin/env nu
  ^gh auth login
  ^gh ssh-key add ~/.ssh/jruz.pub

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

stow-home:
  stow -t ~ -v --ignore='home-manager' home

stow-mac:
  just stow-home
  stow -t ~ -v home-mac

stow-linux:
  just stow-home
  stow -t ~ -v home-linux

stow:
  just stow-home

git-config:
  git --no-pager config --global -l

github-signing:
  gh ssh-key add ~/.ssh/jruz.pub --type signing

tmux-plugins:
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  # do Ctrl+a I to install the plugins

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

ubuntu-update:
  sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove

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
  nix-channel --add https://nixos.org/channels/nixos-{{VERSION}} nixpkgs
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

bootstrap:
  #!/usr/bin/env nu
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

set-shell:
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

nix-clean:
  nix-collect-garbage

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

agent-update AGENT:
  #!/usr/bin/env nu
  let result = (^just docker-run bun run scripts/check-agent-update.ts {{AGENT}} | complete)
  if $result.exit_code == 0 {
    print $result.stdout
    ^just nix-hm-switch
  } else if $result.exit_code == 2 {
    print $result.stdout
  } else {
    print $result.stderr
    exit 1
  }

claude-update:
  just agent-update claude

codex-update:
  just agent-update codex

# ---------------- ZELLIJ
zellij-generate-mac:
  just docker-run bun run scripts/zellij-generate-layout.ts --name mac

zellij-generate-mini:
  just docker-run bun run scripts/zellij-generate-layout.ts --name mini \


sandbox-build:
  docker build -t dotfiles-claude-sandbox .

sandbox:
  just sandbox-build
  docker run -it --rm \
    -e CLAUDE_CODE_OAUTH_TOKEN \
    -v "$(pwd):/workspace" \
    -v "$HOME/.claude:/home/claude/.claude" \
    -v "$HOME/.claude.json:/home/claude/.claude.json" \
    -w /workspace \
    dotfiles-claude-sandbox
