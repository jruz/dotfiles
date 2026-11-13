import { expect, test } from "bun:test";
import { readFile } from "node:fs/promises";
import { updatePackage } from "./package-flake-update.ts";

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
  const checksums = updated.match(/sha256 = "a{64}";/g);
  expect(checksums).toHaveLength(4);
});

test("supports another package with different targets", () => {
  const definition = `version = "1.0.0";
  name = "freebsd-x86_64";
  sha256 = "${"b".repeat(64)}";`;
  const updated = updatePackage(definition, {
    version: "2.0.0-rc.1",
    targets: { "freebsd-x86_64": artifact },
  });
  expect(updated).toContain('version = "2.0.0-rc.1";');
  expect(updated).toContain(`sha256 = "${artifact.sha256}";`);
});

test("rejects a manifest missing a target used by the package", () => {
  expect(() =>
    updatePackage(content, {
      version: "9.8.7",
      targets: { "macos-aarch64": artifact },
    }),
  ).toThrow();
});

test("leaves an up-to-date package unchanged", () => {
  const updated = updatePackage(content, release);
  const unchanged = updatePackage(updated, release);
  expect(unchanged).toBe(updated);
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
