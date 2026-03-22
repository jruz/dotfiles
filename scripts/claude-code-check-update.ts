import { log } from "./log";
import { readFile } from "fs/promises";
import { homedir } from "os";
import { z } from "zod/v4";

const FLAKE_PATH = `${homedir()}/dev/dotfiles/home/.config/home-manager/flake.nix`;
const NPM_REGISTRY = "https://registry.npmjs.org/@anthropic-ai/claude-code";

const NpmRegistrySchema = z
  .object({
    "dist-tags": z.record(z.string(), z.string()),
  })
  .readonly();

const fetchStableVersion = async (): Promise<string> => {
  const response = await fetch(NPM_REGISTRY);
  if (!response.ok) {
    throw new Error(`npm registry returned ${response.status}`);
  }
  const data = NpmRegistrySchema.parse(await response.json());
  const stable = data["dist-tags"]["stable"];
  if (!stable) {
    throw new Error("no stable dist-tag found");
  }
  return stable;
};

const readCurrentVersion = async (): Promise<string> => {
  const content = await readFile(FLAKE_PATH, "utf-8");
  const match = /claude-code-nix\?ref=v([\d.]+)/.exec(content);
  if (!match) {
    throw new Error("could not find claude-code version in flake.nix");
  }
  const version = match[1];
  if (!version) {
    throw new Error("could not extract version from match");
  }
  return version;
};

const current = await readCurrentVersion();
const stable = await fetchStableVersion();

log.info(`current: ${current}`);
log.info(`stable:  ${stable}`);

if (current === stable) {
  log.ok("up to date");
} else {
  log.warn(`new version available: ${stable}`);
}
