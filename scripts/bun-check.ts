import { $ } from "bun";

await $`bun run scripts/nix-check-version-sync.ts`;
await $`bun test ./scripts`;
