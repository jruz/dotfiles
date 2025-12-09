# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository that manages configuration files and application installations across multiple platforms (macOS, Linux/Ubuntu, Windows/WSL2) using a multi-layered approach.

## Architecture

The repository is organized into platform-specific directories with a shared base:

- `home/` - Base configuration files shared across all platforms
- `home-mac/` - macOS-specific configurations
- `home-linux/` - Linux-specific configurations
- `ubuntu/` - Ubuntu-specific configurations
- `windows/` - Windows-specific configurations
- `mac/nix-darwin/` - Nix Darwin system configuration for macOS

Configuration deployment uses GNU Stow to symlink files from these directories to the home directory.

## Package Management Strategy

The repository uses a three-tier package management approach:

1. **CLI Tools**: Managed via Nix + Home Manager (`home/.config/home-manager/home.nix`)
   - Cross-platform CLI tools
   - Development tools (git, editors, shells)
   - Fonts (Nerd Fonts)

2. **GUI Applications (macOS)**: Managed via Homebrew (`home-mac/Brewfile`)
   - Desktop applications installed via Homebrew casks
   - Mac App Store apps installed via `mas`

3. **Language Runtimes**: Managed via mise (`home/.config/mise/config.toml`)
   - Node.js, Python, Rust, Go, Deno versions

## Common Commands

### Initial Setup

Stow dotfiles on macOS:
```bash
just stow-mac
```

Stow dotfiles on Linux:
```bash
just stow-linux
```

Just base home directory:
```bash
just stow-home
```

### Package Management

Install GUI applications on macOS:
```bash
cd home-mac && brew bundle
```

Update Homebrew packages on macOS:
```bash
just mac-update
```

Update Nix channels and apply Home Manager configuration:
```bash
just nix-update
```

Check for outdated mise tools:
```bash
just mise-outdated
```

Upgrade mise tools:
```bash
just mise-upgrade
```

Install language runtimes:
```bash
mise install
```

### Nix Darwin (macOS System Configuration)

The nix-darwin configuration in `mac/nix-darwin/flake.nix` manages system-level macOS settings including dock preferences, finder settings, and system defaults.

Edit nix-darwin configuration:
```bash
just nix-darwin-edit
```

Apply nix-darwin changes:
```bash
just nix-darwin-switch
```

Update nix-darwin flake:
```bash
just nix-darwin-update
```

View differences between active and dotfiles version:
```bash
just nix-darwin-diff
```

The nix-darwin configuration is deployed to `~/.config/nix-darwin` and applied via `darwin-rebuild`.

### System Updates

Ubuntu full system upgrade:
```bash
just ubuntu-update
```

## Configuration Files

Key configuration locations:
- Neovim: `home/.config/nvim/`
- Zsh: `home/.zshrc`, `home/.config/zsh/`
- Tmux: `home/.tmux.conf`
- Helix: `home/.config/helix/`
- Yazi: `home/.config/yazi/`
- Ripgrep: `home/.config/rg/config`
- Alacritty: `home/.config/alacritty/`
- Ghostty: `home/.config/ghostty/`
- Git UI tools: `home/.config/gitui/`, `home/.config/lazygit/`

## Development Workflow

When modifying configurations:
1. Edit files in the appropriate `home*/` directory within this repository
2. Run the appropriate `just stow-*` command to symlink changes
3. For Nix Home Manager changes, edit `home/.config/home-manager/home.nix` and run `home-manager switch`
4. For macOS system settings, edit `mac/nix-darwin/flake.nix` and use `just nix-darwin-switch`

## Platform-Specific Notes

**macOS**: Uses both Homebrew (GUI apps) and Nix (CLI tools). System-level settings managed by nix-darwin.

**Linux/Ubuntu**: Primarily uses Nix for package management.

**Configuration Deployment**: Files are symlinked using GNU Stow, not copied. Changes to dotfiles in the repository immediately affect the live configuration.

## Commit Message Convention

All commit messages must follow the format: `Tool: Description`

## Working Directory

Screenshots are stored in `./tmp/`.

## Testing CLI Tool Configurations

Before telling the user a CLI tool configuration is working, use VHS to take a screenshot and verify it yourself:

```bash
# Create a tape file in tmp/
cat > tmp/test.tape << 'EOF'
Output tmp/preview.png
Set Shell zsh
Set FontSize 14
Set Width 1200
Set Height 600
Set Theme "Catppuccin Mocha"

Type "zellij"  # or whatever CLI tool
Enter
Sleep 2s
Screenshot tmp/preview.png
Type "exit"
Enter
Sleep 500ms
EOF

# Run VHS to capture screenshot
vhs tmp/test.tape

# Then read the screenshot to verify
```

This prevents wasting the user's time with trial-and-error iterations.
