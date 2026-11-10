import { readFile, writeFile } from "node:fs/promises";
import { resolve } from "node:path";
import { z } from "zod";
import { log } from "./lib/log.ts";

const TargetSchema = z.enum([
  "macos-aarch64",
  "macos-x86_64",
  "linux-aarch64",
  "linux-x86_64",
]);

const ArtifactSchema = z
  .object({ sha256: z.string().regex(/^[a-f0-9]{64}$/) })
  .readonly();

const ReleaseSchema = z
  .object({
    version: z.string().regex(/^\d+\.\d+\.\d+$/),
    targets: z
      .object({
        "macos-aarch64": ArtifactSchema,
        "macos-x86_64": ArtifactSchema,
        "linux-aarch64": ArtifactSchema,
        "linux-x86_64": ArtifactSchema,
      })
      .readonly(),
  })
  .readonly();

export const updatePackage = (content: string, release: unknown): string => {
  const { version, targets } = ReleaseSchema.parse(release);
  const versionPattern = /version = "[^"]+";/;
  if (!versionPattern.test(content)) {
    throw new Error("missing version: herdr-core.nix");
  }

  const versionUpdated = content.replace(
    versionPattern,
    `version = "${version}";`,
  );
  return TargetSchema.options.reduce((updated, name) => {
    const pattern = new RegExp(`(name = "${name}";\\s+sha256 = ")[^"]+(";)`);
    if (!pattern.test(updated)) {
      throw new Error(`missing target: ${name}`);
    }
    return updated.replace(
      pattern,
      (_match, prefix: string, suffix: string) =>
        `${prefix}${targets[name].sha256}${suffix}`,
    );
  }, versionUpdated);
};

const main = async (): Promise<void> => {
  const path = resolve(
    import.meta.dir,
    "../home/.config/home-manager/packages/herdr-core.nix",
  );
  const response = await fetch("https://releases.herdr.dev/core/latest.json");
  if (!response.ok) {
    throw new Error(`release request: ${response.status}`);
  }

  const content = await readFile(path, "utf-8");
  const release: unknown = await response.json();
  const updated = updatePackage(content, release);
  if (updated === content) {
    log.ok("herdr-core is up to date");
    process.exit(2);
  }

  await writeFile(path, updated);
  log.ok("herdr-core.nix updated");
};

if (import.meta.main) {
  try {
    await main();
  } catch (error: unknown) {
    log.error(`herdr-core update: ${String(error)}`);
    process.exit(1);
  }
}
