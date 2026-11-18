import { readFile, writeFile } from "node:fs/promises";
import { resolve } from "node:path";
import { log } from "./lib/log.ts";

type Hash = { name: string; sha256: string };

type Release = (version: string) => Promise<Hash[]>;

const PACKAGES = resolve(
  import.meta.dirname,
  "../home/.config/home-manager/packages",
);

const record = (value: unknown, context: string): Record<string, unknown> => {
  if (typeof value !== "object" || value === null || Array.isArray(value)) {
    throw new Error(`${context} is not an object`);
  }
  const entries = Object.entries(value);
  return Object.fromEntries(entries);
};

const text = (value: unknown, context: string): string => {
  if (typeof value !== "string") {
    throw new Error(`${context} is not a string`);
  }
  return value;
};

const list = (value: unknown, context: string): unknown[] => {
  if (!Array.isArray(value)) {
    throw new Error(`${context} is not an array`);
  }
  return value;
};

const fetchRecord = async (
  url: string,
  context: string,
): Promise<Record<string, unknown>> => {
  const response = await fetch(url);
  if (!response.ok) {
    throw new Error(`${url} returned ${response.status}`);
  }
  const body: unknown = await response.json();
  return record(body, context);
};

const manifestHashes = (
  entries: Record<string, unknown>,
  field: string,
): Hash[] =>
  Object.entries(entries).map(([name, entry]) => {
    const fields = record(entry, name);
    const sha256 = text(fields[field], `${name} ${field}`);
    return { name, sha256 };
  });

const claudeHashes: Release = async (version) => {
  const manifest = await fetchRecord(
    `https://downloads.claude.ai/claude-code-releases/${version}/manifest.json`,
    "claude manifest",
  );
  const platforms = record(manifest["platforms"], "claude platforms");
  return manifestHashes(platforms, "checksum");
};

const codexAsset = /^codex-(.+)\.tar\.gz$/;

const codexAssetHash = (asset: unknown): Hash[] => {
  const fields = record(asset, "codex asset");
  const file = text(fields["name"], "codex asset name");
  const name = codexAsset.exec(file)?.[1];
  if (!name) {
    return [];
  }
  const digest = text(fields["digest"], `${name} digest`);
  return [{ name, sha256: digest.replace("sha256:", "") }];
};

const codexHashes: Release = async (version) => {
  const release = await fetchRecord(
    `https://api.github.com/repos/openai/codex/releases/tags/rust-v${version}`,
    "codex release",
  );
  const assets = list(release["assets"], "codex assets");
  return assets.flatMap(codexAssetHash);
};

const herdrCoreHashes: Release = async (version) => {
  const manifest = await fetchRecord(
    `https://releases.herdr.dev/core/${version}/manifest.json`,
    "herdr-core manifest",
  );
  const targets = record(manifest["targets"], "herdr-core targets");
  return manifestHashes(targets, "sha256");
};

const RELEASES: Record<string, Release> = {
  claude: claudeHashes,
  codex: codexHashes,
  "herdr-core": herdrCoreHashes,
};

const targetPattern =
  /name = "(?<name>[^"]+)";\s+sha256 = "(?<sha256>[^"]+)";/g;

const targetName = (match: RegExpMatchArray): string =>
  text(match.groups?.["name"], "target name");

const readVersion = (content: string, file: string): string => {
  const version = /version = "(?<version>[^"]+)";/.exec(content)?.groups?.[
    "version"
  ];
  if (!version) {
    throw new Error(`${file} has no version declaration`);
  }
  return version;
};

export const missingTargets = (content: string, hashes: Hash[]): string[] => {
  const available = new Set(hashes.map((hash) => hash.name));
  const matches = [...content.matchAll(targetPattern)];
  return matches.map(targetName).filter((name) => !available.has(name));
};

export const updateHashes = (content: string, hashes: Hash[]): string =>
  content.replace(
    targetPattern,
    (match: string, name: string, sha256: string) => {
      const hash = hashes.find((candidate) => candidate.name === name);
      if (!hash) {
        throw new Error(`no hash for ${name}`);
      }
      return match.replace(sha256, hash.sha256);
    },
  );

const releaseFor = (name: string): Release => {
  const release = RELEASES[name];
  if (!release) {
    const supported = Object.keys(RELEASES).join(", ");
    throw new Error(`Unknown package: ${name}. Use one of: ${supported}`);
  }
  return release;
};

const main = async (name: string): Promise<void> => {
  const release = releaseFor(name);
  const file = resolve(PACKAGES, `${name}.nix`);
  const content = await readFile(file, "utf-8");
  const version = readVersion(content, file);
  const hashes = await release(version);
  const missing = missingTargets(content, hashes);
  if (missing.length > 0) {
    const targets = missing.join(", ");
    throw new Error(`${name} ${version} has no hash for: ${targets}`);
  }
  const updated = updateHashes(content, hashes);
  await writeFile(file, updated);
  log.ok(`${name} ${version} hashes refreshed`);
};

if (import.meta.main) {
  try {
    const name = text(process.argv[2], "package argument");
    await main(name);
  } catch (error: unknown) {
    log.error(`renovate package hashes: ${String(error)}`);
    process.exit(1);
  }
}
