import { readFile, writeFile } from "node:fs/promises";
import { resolve } from "node:path";
import { z } from "zod";
import { readConfiguration } from "./lib/flake-update-config.ts";
import { log } from "./lib/log.ts";
import { output } from "./lib/output.ts";

const ArtifactSchema = z
  .object({ sha256: z.string().regex(/^[a-f0-9]{64}$/) })
  .readonly();

const ReleaseSchema = z
  .object({
    version: z.string().regex(/^[0-9A-Za-z.+-]+$/),
    targets: z.record(z.string(), ArtifactSchema).readonly(),
  })
  .readonly();

const TargetSchema = z
  .object({ name: z.string(), sha256: z.string() })
  .readonly();

export const updatePackage = (content: string, release: unknown): string => {
  const { version, targets } = ReleaseSchema.parse(release);
  const versionPattern = /version = "[^"]+";/;
  if (!versionPattern.test(content)) {
    throw new Error("missing version: package definition");
  }
  const matches = Array.from(
    content.matchAll(
      /name = "(?<name>[^"]+)";\s+sha256 = "(?<sha256>[^"]+)";/g,
    ),
  );
  if (matches.length === 0) {
    throw new Error("missing target: package definition");
  }
  return matches.reduce(
    (updated, match) => {
      const target = TargetSchema.parse(match.groups);
      const artifact = ArtifactSchema.parse(targets[target.name]);
      return updated.replace(match[0], () =>
        match[0].replace(target.sha256, artifact.sha256),
      );
    },
    content.replace(versionPattern, `version = "${version}";`),
  );
};

const prepareUpdate = async () => {
  const config = readConfiguration(process.argv[2]);
  if (config.kind !== "release-manifest") {
    throw new Error(`not a release-manifest package: ${config.name}`);
  }
  const path = resolve(import.meta.dir, "..", config.path);
  const content = await readFile(path, "utf-8");
  const response = await fetch(config.releaseUrl);
  if (!response.ok) {
    throw new Error(`release request: ${response.status}`);
  }
  const release = ReleaseSchema.parse(await response.json());
  const updated = updatePackage(content, release);
  return { config, path, content, updated, version: release.version };
};

const main = async (): Promise<void> => {
  const { config, path, content, updated, version } = await prepareUpdate();
  if (updated === content) {
    log.ok(`${config.name} is up to date`);
    process.exit(2);
  }
  await writeFile(path, updated);
  log.ok(`${config.path} updated`);
  output.json({ version });
};

if (import.meta.main) {
  try {
    await main();
  } catch (error: unknown) {
    log.error(`package flake update: ${String(error)}`);
    process.exit(1);
  }
}
