import { readFile, writeFile } from "node:fs/promises";
import { resolve } from "node:path";
import { z } from "zod";
import {
  readConfiguration,
  type NpmConfig,
} from "./lib/flake-update-config.ts";
import { log } from "./lib/log.ts";
import { output } from "./lib/output.ts";

const NpmRegistrySchema = z
  .object({ "dist-tags": z.record(z.string(), z.string()) })
  .readonly();

const referencePattern = (config: NpmConfig): RegExp => {
  const prefix = `github:${config.repository}?ref=${config.tagPrefix}`;
  const escaped = prefix.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  return new RegExp(`${escaped}([^"\\s]+)`);
};

export const readCurrentVersion = (
  content: string,
  config: NpmConfig,
): string => {
  const match = referencePattern(config).exec(content);
  if (!match?.[1]) {
    throw new Error(`missing flake reference: ${config.repository}`);
  }
  return match[1];
};

export const updateFlake = (
  content: string,
  config: NpmConfig,
  version: string,
): string => {
  readCurrentVersion(content, config);
  return content.replace(
    referencePattern(config),
    () => `github:${config.repository}?ref=${config.tagPrefix}${version}`,
  );
};

const fetchLatestVersion = async (config: NpmConfig): Promise<string> => {
  const response = await fetch(
    `https://registry.npmjs.org/${encodeURIComponent(config.packageName)}`,
  );
  if (!response.ok) {
    throw new Error(`npm registry returned ${response.status}`);
  }
  const data = NpmRegistrySchema.parse(await response.json());
  return z.string().min(1).parse(data["dist-tags"][config.distTag]);
};

const prepareUpdate = async () => {
  const config = readConfiguration(process.argv[2]);
  if (config.kind !== "npm") {
    throw new Error(`not an npm flake: ${config.name}`);
  }
  const path = resolve(import.meta.dir, "..", config.path);
  const content = await readFile(path, "utf-8");
  const current = readCurrentVersion(content, config);
  const latest = await fetchLatestVersion(config);
  return { config, path, content, current, latest };
};

const main = async (): Promise<void> => {
  const { config, path, content, current, latest } = await prepareUpdate();
  log.info(`${config.name}: ${current} -> ${latest}`);
  if (current === latest) {
    log.ok(`${config.name} is up to date`);
    process.exit(2);
  }
  await writeFile(path, updateFlake(content, config, latest));
  log.ok(`${config.path} updated`);
  output.json({ version: latest });
};

if (import.meta.main) {
  try {
    await main();
  } catch (error: unknown) {
    log.error(`npm flake update: ${String(error)}`);
    process.exit(1);
  }
}
