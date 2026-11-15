import { readFile, writeFile } from "node:fs/promises";
import { resolve } from "node:path";
import { z } from "zod";
import { readConfiguration } from "./lib/flake-update-config.ts";
import { log } from "./lib/log.ts";
import { output } from "./lib/output.ts";

const ArtifactSchema = z
  .object({ sha256: z.string().regex(/^[a-f0-9]{64}$/) })
  .readonly();

const TargetNameSchema = z.string();
const ArtifactsSchema = z.record(TargetNameSchema, ArtifactSchema).readonly();

const ReleaseSchema = z
  .object({
    version: z.string().regex(/^[0-9A-Za-z.+-]+$/),
    targets: ArtifactsSchema,
  })
  .readonly();

const PlatformSchema = z.object({ checksum: z.string() }).readonly();
const PlatformsSchema = z.record(TargetNameSchema, PlatformSchema).readonly();

const AnthropicManifestSchema = z
  .object({
    version: z.string(),
    platforms: PlatformsSchema,
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
  const targetMatches = content.matchAll(
    /name = "(?<name>[^"]+)";\s+sha256 = "(?<sha256>[^"]+)";/g,
  );
  const matches = Array.from(targetMatches);
  if (matches.length === 0) {
    throw new Error("missing target: package definition");
  }
  const versioned = content.replace(versionPattern, `version = "${version}";`);
  return matches.reduce((updated, match) => {
    const target = TargetSchema.parse(match.groups);
    const artifact = ArtifactSchema.parse(targets[target.name]);
    return updated.replace(match[0], () =>
      match[0].replace(target.sha256, artifact.sha256),
    );
  }, versioned);
};

export const fromAnthropicManifest = (manifest: unknown) => {
  const { version, platforms } = AnthropicManifestSchema.parse(manifest);
  const platformsEntries = Object.entries(platforms);
  const targetEntries = platformsEntries.map(([name, platform]) => [
    name,
    { sha256: platform.checksum },
  ]);
  const targets: unknown = Object.fromEntries(targetEntries);
  return ReleaseSchema.parse({ version, targets });
};

const fetchOk = async (url: string): Promise<Response> => {
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(`release request ${url}: ${response.status}`);
  }
  return response;
};

type PackageConfig = Exclude<
  ReturnType<typeof readConfiguration>,
  { kind: "npm" }
>;

const fetchAnthropicRelease = async (releasesUrl: string, channel: string) => {
  const pointer = await fetchOk(`${releasesUrl}/${channel}`);
  const version = (await pointer.text()).trim();
  const manifest = await fetchOk(`${releasesUrl}/${version}/manifest.json`);
  const body: unknown = await manifest.json();
  return fromAnthropicManifest(body);
};

const fetchRelease = async (config: PackageConfig) => {
  if (config.kind === "anthropic-manifest") {
    return fetchAnthropicRelease(config.releasesUrl, config.channel);
  }
  const response = await fetchOk(config.releaseUrl);
  const body: unknown = await response.json();
  return ReleaseSchema.parse(body);
};

const prepareUpdate = async () => {
  const config = readConfiguration(process.argv[2]);
  if (config.kind === "npm") {
    throw new Error(`not a package definition: ${config.name}`);
  }
  const path = resolve(import.meta.dir, "..", config.path);
  const content = await readFile(path, "utf-8");
  const release = await fetchRelease(config);
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
