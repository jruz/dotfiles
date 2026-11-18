import { expect, test } from "bun:test";
import { missingTargets, updateHashes } from "./renovate-package-hashes.ts";

const content = `  targets = {
    x86_64-linux = {
      name = "linux-x64";
      sha256 = "old-linux";
    };
    aarch64-darwin = {
      name = "darwin-arm64";
      sha256 = "old-darwin";
    };
  };
`;

const expected = `  targets = {
    x86_64-linux = {
      name = "linux-x64";
      sha256 = "new-linux";
    };
    aarch64-darwin = {
      name = "darwin-arm64";
      sha256 = "new-darwin";
    };
  };
`;

const hashes = [
  { name: "linux-x64", sha256: "new-linux" },
  { name: "darwin-arm64", sha256: "new-darwin" },
  { name: "win32-x64", sha256: "new-windows" },
];

test("updates the hash of every target", () => {
  const updated = updateHashes(content, hashes);
  expect(updated).toBe(expected);
});

test("lists targets without a hash", () => {
  const partial = [{ name: "linux-x64", sha256: "new-linux" }];
  const missing = missingTargets(content, partial);
  expect(missing).toEqual(["darwin-arm64"]);
});

test("lists no targets when every hash exists", () => {
  const missing = missingTargets(content, hashes);
  expect(missing).toEqual([]);
});
