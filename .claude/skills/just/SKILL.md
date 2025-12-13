---
name: just
description: Use when running brew bundle, darwin-rebuild, home-manager switch, mise upgrade, nix flake update, nix upgrade-nix, nix-channel, nix-collect-garbage, or stow commands. These commands are BANNED and must use justfile recipes instead.
---

# Just Skill

## Golden Rule

**NEVER run package management or system configuration commands directly. ALWAYS use the justfile recipes.**

This repository enforces using justfile recipes for all package management and system configuration to ensure proper workflows (like copying config files before applying changes).

## Banned Commands

The following commands are banned in `.claude/settings.json` and MUST be run via their just recipe counterparts:

| Banned Command | Use Instead | Purpose |
|----------------|-------------|---------|
| `brew bundle` | `just mac-update` | Update macOS GUI applications |
| `darwin-rebuild switch` | `just nix-darwin-switch` | Apply macOS system settings |
| `home-manager switch` | `just nix-hm-switch` | Apply Home Manager configuration |
| `mise upgrade` | `just mise-upgrade` | Upgrade language runtimes |
| `nix flake update` | `just nix-hm-update` or `just nix-darwin-update` | Update flake dependencies |
| `nix upgrade-nix` | `just nix-core-upgrade` | Upgrade Nix itself |
| `nix-channel --add` | `just nix-channel-upgrade VERSION` | Add/update Nix channels |
| `nix-channel --update` | `just nix-channel-upgrade VERSION` | Update Nix channels |
| `nix-collect-garbage` | `just nix-clean` or `just clean` | Clean up Nix store |
| `stow` | `just stow-mac`, `just stow-linux`, or `just stow-home` | Deploy dotfiles |

## Common Just Recipes

### Package Management

```bash
just mac-update              # Update Homebrew packages and casks
just mac-outdated            # Check for outdated macOS packages

just mise-upgrade            # Upgrade all mise tools
just mise-outdated           # Check for outdated mise tools
just mise-clean              # Prune unused mise versions
just mise-remove TOOL        # Remove a mise tool from config
```

### Nix & Home Manager

```bash
just nix-hm-switch           # Apply Home Manager config (use after editing home.nix)
just nix-hm-update           # Update Home Manager flake and apply
just nix-hm-edit             # Edit Home Manager config in nvim

just nix-core-upgrade        # Upgrade Nix itself
just nix-channel-upgrade VER # Upgrade Nix channels to specific version
just nix-clean               # Clean up Nix store
just nix-full-upgrade        # Full upgrade: Nix + Home Manager + nix-darwin
```

### macOS System Configuration (nix-darwin)

```bash
just nix-darwin-switch       # Apply nix-darwin system config
just nix-darwin-update       # Update nix-darwin flake and apply
just nix-darwin-edit         # Edit nix-darwin config in nvim
just nix-darwin-diff         # Compare active config with dotfiles version
```

### Dotfiles Deployment

```bash
just stow-mac                # Deploy dotfiles on macOS (home + home-mac)
just stow-linux              # Deploy dotfiles on Linux (home + home-linux)
just stow-home               # Deploy only base home/ directory
```

### Other Utilities

```bash
just bootstrap               # Full system setup (stow + home-manager + nix-darwin + ssh + mise)
just clean                   # Clean up Nix store and mise versions
just lint                    # Run all linters (shellcheck + selene)
```

## Why Use Just Recipes?

1. **Proper Workflow**: Recipes handle copying config files from dotfiles to the correct locations before applying changes
2. **Consistency**: Ensures everyone uses the same commands and flags
3. **Safety**: Prevents mistakes like applying configs from the wrong location
4. **Documentation**: Recipe names are self-documenting

## Example Workflows

### Adding a Package to Home Manager

```bash
# 1. Edit the config file
nvim ~/dev/dotfiles/home/.config/home-manager/home.nix

# 2. Apply changes using just recipe (NOT home-manager switch)
just nix-hm-switch
```

### Updating macOS GUI Applications

```bash
# 1. Edit Brewfile
nvim ~/dev/dotfiles/home-mac/Brewfile

# 2. Update packages using just recipe (NOT brew bundle)
just mac-update
```

### Changing macOS System Settings

```bash
# 1. Edit nix-darwin config
nvim ~/dev/dotfiles/mac/nix-darwin/flake.nix

# 2. Apply changes using just recipe (NOT darwin-rebuild)
just nix-darwin-switch
```

## Common Mistakes to Avoid

1. **Running banned commands directly** - Always check if there's a just recipe first
2. **Forgetting the workflow** - Recipes handle copying configs before applying
3. **Not using the right recipe** - `nix-hm-switch` vs `nix-hm-update` (update also updates the flake)

## Verification

When you need to run a package management or system configuration command:
1. Check if it's in the banned commands list above
2. Use the corresponding just recipe instead
3. If unsure, run `just --list` to see all available recipes
