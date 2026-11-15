import { expect, test } from "bun:test";
import {
  readConfiguration,
  type NpmConfig,
} from "./lib/flake-update-config.ts";
import { readCurrentVersion, updateFlake } from "./npm-flake-update.ts";

const config: NpmConfig = {
  kind: "npm",
  name: "Example",
  path: "example/flake.nix",
  packageName: "@example/tool",
  distTag: "next",
  repository: "example/tool.nix",
  tagPrefix: "release-",
};

const content = `{
  tool.url = "github:example/tool.nix?ref=release-1.2.3";
  other.url = "github:example/other?ref=v1.0.0";
}`;

test("reads a configured repository and tag prefix", () => {
  const version = readCurrentVersion(content, config);
  expect(version).toBe("1.2.3");
});

test("updates only the configured flake reference", () => {
  const updated = updateFlake(content, config, "2.0.0-beta.1");
  const expected = content.replace("release-1.2.3", "release-2.0.0-beta.1");
  expect(updated).toBe(expected);
});

test("escapes repository punctuation instead of matching another input", () => {
  const unrelated = content.replace("tool.nix", "tool-nix");
  expect(() => updateFlake(unrelated, config, "2.0.0")).toThrow(
    "missing flake reference",
  );
});

test("leaves an up-to-date flake unchanged", () => {
  const updated = updateFlake(content, config, "1.2.3");
  expect(updated).toBe(content);
});

test("supports tag names without a prefix", () => {
  const unprefixed = { ...config, tagPrefix: "" };
  const version = readCurrentVersion(content, unprefixed);
  expect(version).toBe("release-1.2.3");
});

test("rejects unknown configuration names", () => {
  expect(() => readConfiguration("unknown-package")).toThrow();
});

test("loads every supported configuration kind", () => {
  expect(readConfiguration("codex").kind).toBe("npm");
  expect(readConfiguration("herdr-core").kind).toBe("release-manifest");
  expect(readConfiguration("claude").kind).toBe("anthropic-manifest");
});
