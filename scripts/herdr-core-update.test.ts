import { expect, test } from "bun:test";
import { readFile } from "node:fs/promises";
import { updatePackage } from "./herdr-core-update.ts";

const content = await readFile(
  new URL(
    "../home/.config/home-manager/packages/herdr-core.nix",
    import.meta.url,
  ),
  "utf-8",
);
const artifact = { sha256: "a".repeat(64) };
const release = {
  version: "9.8.7",
  targets: {
    "macos-aarch64": artifact,
    "macos-x86_64": artifact,
    "linux-aarch64": artifact,
    "linux-x86_64": artifact,
    "windows-x86_64": artifact,
  },
};

test("updates the version and every supported checksum", () => {
  const updated = updatePackage(content, release);
  expect(updated).toContain('version = "9.8.7";');
  expect(updated.match(/sha256 = "a{64}";/g)).toHaveLength(4);
});

test("leaves an up-to-date package unchanged", () => {
  const updated = updatePackage(content, release);
  expect(updatePackage(updated, release)).toBe(updated);
});

test("rejects incomplete release metadata", () => {
  expect(() =>
    updatePackage(content, { version: "9.8.7", targets: {} }),
  ).toThrow();
});

test("rejects invalid checksums", () => {
  expect(() =>
    updatePackage(content, {
      ...release,
      targets: { ...release.targets, "linux-aarch64": { sha256: "invalid" } },
    }),
  ).toThrow();
});

test("fails when the package layout no longer matches", () => {
  expect(() => updatePackage("", release)).toThrow("missing version");
  expect(() => updatePackage('version = "1.0.0";', release)).toThrow(
    "missing target",
  );
});
