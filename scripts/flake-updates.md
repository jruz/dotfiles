# Flake updates

- Add packages to [`flake-updates.json`](flake-updates.json).
- Use `npm` for an npm version mapped to a GitHub flake reference.
- Use `release-manifest` for a manifest containing `version` and `targets.<name>.sha256`.
- Manifest packages must use the `name`/`sha256` layout in [`herdr-core.nix`](../home/.config/home-manager/packages/herdr-core.nix).
- Add a recipe calling `nu scripts/nix-package-update.nu <key>`.
- The orchestrator checks cleanliness before editing and commits only the configured path and Home Manager lockfile.
- Test with `just nix-package-update-test` and `just bun::test`.
