import { log } from "./log";
import { readFile, writeFile } from "fs/promises";
import { resolve } from "path";
import { z } from "zod";

type AgentName = "claude" | "codex" | "pi";

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
  pi: {
    packageName: "@earendil-works/pi-coding-agent",
    distTag: "latest",
    flakePattern: /earendil-works\/pi\?ref=v([0-9A-Za-z.-]+)/,
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

const StringSchema = z.string();

const NpmRegistrySchema = z
  .object({
    "dist-tags": z.record(StringSchema, StringSchema),
  })
  .readonly();

const parseAgentName = (): AgentName => {
  const value = process.argv[2]?.toLowerCase();
  if (value === "claude" || value === "codex" || value === "pi") {
    return value;
  }

  throw new Error(
    "usage: bun run scripts/check-agent-update.ts <claude|codex|pi>",
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

  const json = await response.json();
  const data = NpmRegistrySchema.parse(json);
  const version = data["dist-tags"][distTag];
  if (!version) {
    throw new Error(`no ${distTag} dist-tag found for ${packageName}`);
  }

  return version;
};

const readCurrentVersion = (content: string, flakePattern: RegExp): string => {
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
const content = await readFile(FLAKE_PATH, "utf-8");
const current = readCurrentVersion(content, config.flakePattern);
const latest = await fetchLatestVersion(config.packageName, config.distTag);

log.info(`${agent}: current: ${current}`);
log.info(`${agent}: latest:  ${latest}`);

if (current === latest) {
  log.ok(`${agent} is up to date`);
  process.exit(2);
}

log.warn(`${agent}: ${current} -> ${latest}`);
const updated = content.replace(config.flakePattern, (match) =>
  match.replace(current, latest),
);
await writeFile(FLAKE_PATH, updated);
log.ok("flake.nix updated");
