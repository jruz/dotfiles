# System Update Command

Update all system dependencies and applications using justfile recipes.

## Instructions

Run these commands sequentially, waiting for each to complete before proceeding to the next.

## Detect Platform

Use `uname -s` to detect the OS:
- Darwin = macOS
- Linux = Check distro via `/etc/os-release`

For Linux, read `/etc/os-release` and check the `ID` field:
- `ubuntu` or `debian` = Ubuntu/Debian (apt-based)
- `fedora` = Fedora (dnf-based)
- `nixos` = NixOS (nix-based, no system package manager step)

### macOS

```bash
just mac-update
```

```bash
just nix-full-upgrade
```

```bash
just mise-upgrade
```

### Ubuntu/Debian (WSL or native)

```bash
just ubuntu-update
```

```bash
just nix-hm-update
```

```bash
just mise-upgrade
```

### Fedora

```bash
sudo dnf upgrade --refresh -y && sudo dnf autoremove -y
```

```bash
just nix-hm-update
```

```bash
just mise-upgrade
```

### NixOS

```bash
sudo nixos-rebuild switch --upgrade
```

```bash
just nix-hm-update
```

```bash
just mise-upgrade
```

## Notes

- `mac-update` updates Homebrew and upgrades GUI apps from `home-mac/Brewfile`
- `nix-full-upgrade` combines: nix core upgrade, Home Manager update, and nix-darwin update
- `nix-hm-update` updates the Home Manager flake and switches to it (CLI tools)
- `mise-upgrade` upgrades language runtimes (Node, Python, Rust, Go, etc.)
- `ubuntu-update` runs apt update, full-upgrade, and autoremove

## Optional Cleanup

After updates complete successfully, optionally run:

```bash
just clean
```

This runs `nix-collect-garbage` and `mise prune` to remove old versions.
