import { log } from "./log";
import { readFile } from "fs/promises";
import { resolve } from "path";
import { z } from "zod";

type AgentName = "claude" | "codex";

type AgentConfig = {
  packageName: string;
  distTag: string;
  flakePattern: RegExp;
};

const AGENTS: Record<AgentName, AgentConfig> = {
  claude: {
    packageName: "@anthropic-ai/claude-code",
    distTag: "stable",
    flakePattern: /claude-code-nix\?ref=v([0-9A-Za-z.-]+)/,
  },
  codex: {
    packageName: "@openai/codex",
    distTag: "latest",
    flakePattern: /codex-cli-nix\?ref=v([0-9A-Za-z.-]+)/,
  },
};

const FLAKE_PATH = resolve(
  import.meta.dir,
  "..",
  "home",
  ".config",
  "home-manager",
  "flake.nix",
);

const NpmRegistrySchema = z
  .object({
    "dist-tags": z.record(z.string(), z.string()),
  })
  .readonly();

const parseAgentName = (): AgentName => {
  const value = process.argv[2]?.toLowerCase();
  if (value === "claude" || value === "codex") {
    return value;
  }

  throw new Error(
    "usage: bun run scripts/check-agent-update.ts <claude|codex>",
  );
};

const fetchLatestVersion = async (
  packageName: string,
  distTag: string,
): Promise<string> => {
  const response = await fetch(
    `https://registry.npmjs.org/${encodeURIComponent(packageName)}`,
  );
  if (!response.ok) {
    throw new Error(`npm registry returned ${response.status}`);
  }

  const data = NpmRegistrySchema.parse(await response.json());
  const version = data["dist-tags"][distTag];
  if (!version) {
    throw new Error(`no ${distTag} dist-tag found for ${packageName}`);
  }

  return version;
};

const readCurrentVersion = async (flakePattern: RegExp): Promise<string> => {
  const content = await readFile(FLAKE_PATH, "utf-8");
  const match = flakePattern.exec(content);
  if (!match) {
    throw new Error(`could not find version in ${FLAKE_PATH}`);
  }

  const version = match[1];
  if (!version) {
    throw new Error("could not extract version from match");
  }

  return version;
};

const agent = parseAgentName();
const config = AGENTS[agent];
const current = await readCurrentVersion(config.flakePattern);
const latest = await fetchLatestVersion(config.packageName, config.distTag);

log.info(`${agent}: current: ${current}`);
log.info(`${agent}: latest:  ${latest}`);

if (current === latest) {
  log.ok(`${agent} is up to date`);
} else {
  log.warn(`${agent}: new version available: ${latest}`);
}
