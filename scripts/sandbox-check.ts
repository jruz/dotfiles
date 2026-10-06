import assert from "node:assert/strict";
import { existsSync, mkdirSync, mkdtempSync, rmSync } from "node:fs";

import { log } from "./log";

const checkWritableDirectory = (directory: string): void => {
  try {
    const temporaryDirectory = mkdtempSync(`${directory}/sandbox-check-`);
    rmSync(temporaryDirectory, { recursive: true });
  } catch (error: unknown) {
    log.error(`writable directory check failed: ${directory}`);
    throw error;
  }
};

const checkReadonlyFilesystem = (): void => {
  try {
    mkdirSync("/sandbox-check");
  } catch (error: unknown) {
    assert(error instanceof Error && "code" in error);
    assert.equal(error.code, "EROFS");
    log.info("root filesystem: read-only");
    return;
  }
  assert.fail("root filesystem is writable");
};

const checkSandbox = (): void => {
  const hostProjectDirectory = process.argv[2];
  assert(hostProjectDirectory, "host project path is required");

  const blockedPaths = [
    hostProjectDirectory,
    "/root/.ssh",
    "/root/.config/sops",
    "/var/run/docker.sock",
  ];
  const visiblePaths = ["/app/flake.nix", "/app/package.json"];

  blockedPaths.forEach((path) => {
    assert(!existsSync(path), `unexpected access: ${path}`);
  });
  visiblePaths.forEach((path) => {
    assert(existsSync(path), `missing project file: ${path}`);
  });
  checkReadonlyFilesystem();
  ["/tmp", "/app/node_modules", "/root/.bun"].forEach(checkWritableDirectory);
  log.ok("sandbox isolation: ok");
};

try {
  checkSandbox();
} catch (error: unknown) {
  log.error(String(error));
  process.exit(1);
}
