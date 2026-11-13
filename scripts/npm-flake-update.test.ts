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
  expect(readCurrentVersion(content, config)).toBe("1.2.3");
});

test("updates only the configured flake reference", () => {
  expect(updateFlake(content, config, "2.0.0-beta.1")).toBe(
    content.replace("release-1.2.3", "release-2.0.0-beta.1"),
  );
});

test("escapes repository punctuation instead of matching another input", () => {
  expect(() =>
    updateFlake(content.replace("tool.nix", "tool-nix"), config, "2.0.0"),
  ).toThrow("missing flake reference");
});

test("leaves an up-to-date flake unchanged", () => {
  expect(updateFlake(content, config, "1.2.3")).toBe(content);
});

test("supports tag names without a prefix", () => {
  const unprefixed = { ...config, tagPrefix: "" };
  expect(readCurrentVersion(content, unprefixed)).toBe("release-1.2.3");
});

test("rejects unknown configuration names", () => {
  expect(() => readConfiguration("unknown-package")).toThrow();
});

test("loads both supported configuration kinds", () => {
  expect(readConfiguration("claude").kind).toBe("npm");
  expect(readConfiguration("herdr-core").kind).toBe("release-manifest");
});
