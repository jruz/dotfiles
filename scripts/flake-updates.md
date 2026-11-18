# Flake updates

- Add packages to [`flake-updates.json`](flake-updates.json).
- Use `npm` for an npm version mapped to a GitHub flake reference.
- Add a recipe calling `nu scripts/nix-package-update.nu <key>`.
- The orchestrator checks cleanliness before editing and commits only the configured path and Home Manager lockfile.
- Test with `just nix-package-update-test` and `just bun::test`.
