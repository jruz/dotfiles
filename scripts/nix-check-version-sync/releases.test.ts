import { expect, test } from "bun:test";
import { checkReleaseSync, formatReleaseFailure } from "./releases.ts";
import type { FlakeInput } from "./types.ts";

const root: FlakeInput = {
  file: "flake.nix",
  name: "nixpkgs",
  source: 'nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-27.11";',
};

test("uses root nixpkgs as the release reference without a hardcoded target", () => {
  const inputs: readonly FlakeInput[] = [
    {
      file: "home/flake.nix",
      name: "nixpkgs",
      source: 'nixpkgs.url = "github:NixOS/nixpkgs/nixos-27.11";',
    },
    {
      file: "home/flake.nix",
      name: "home-manager",
      source:
        'home-manager.url = "github:nix-community/home-manager/release-27.11";',
    },
    {
      file: "mac/flake.nix",
      name: "nix-darwin",
      source: 'nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-27.11";',
    },
  ];
  const result = checkReleaseSync(root, inputs);
  expect(result).toEqual({ success: true, data: "27.11" });
});

test("returns typed mismatches for every divergent input", () => {
  const inputs: readonly FlakeInput[] = [
    {
      file: "home/flake.nix",
      name: "nixpkgs",
      source: 'nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";',
    },
    {
      file: "home/flake.nix",
      name: "home-manager",
      source:
        'home-manager.url = "github:nix-community/home-manager/release-26.05";',
    },
    {
      file: "mac/flake.nix",
      name: "nix-darwin",
      source: 'nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-26.05";',
    },
  ];
  const result = checkReleaseSync(root, inputs);
  expect(result).toEqual({
    success: false,
    error: [
      {
        code: "release-mismatch",
        file: "home/flake.nix",
        input: "nixpkgs",
        expected: "27.11",
        actual: "26.05",
      },
      {
        code: "release-mismatch",
        file: "home/flake.nix",
        input: "home-manager",
        expected: "27.11",
        actual: "26.05",
      },
      {
        code: "release-mismatch",
        file: "mac/flake.nix",
        input: "nix-darwin",
        expected: "27.11",
        actual: "26.05",
      },
    ],
  });
});

test("fails clearly when the root reference is not a release", () => {
  const unstable: FlakeInput = {
    ...root,
    source: 'nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";',
  };
  const result = checkReleaseSync(unstable, []);
  expect(result).toEqual({
    success: false,
    error: [{ code: "release-not-found", file: "flake.nix", input: "nixpkgs" }],
  });
});

test("reports missing release declarations instead of assuming a version", () => {
  const result = checkReleaseSync(root, [
    { file: "home/flake.nix", name: "home-manager", source: "{}" },
  ]);
  expect(result).toEqual({
    success: false,
    error: [
      {
        code: "release-not-found",
        file: "home/flake.nix",
        input: "home-manager",
      },
    ],
  });
});

test("handles whitespace around declarations", () => {
  const result = checkReleaseSync(root, [
    {
      file: "home/flake.nix",
      name: "nixpkgs",
      source: 'nixpkgs.url\n  =\n  "github:NixOS/nixpkgs/nixos-27.11";',
    },
  ]);
  expect(result).toEqual({ success: true, data: "27.11" });
});

test("formats typed failures without changing their codes", () => {
  const missing = formatReleaseFailure({
    code: "release-not-found",
    file: "home/flake.nix",
    input: "home-manager",
  });
  const mismatch = formatReleaseFailure({
    code: "release-mismatch",
    file: "mac/flake.nix",
    input: "nix-darwin",
    expected: "27.11",
    actual: "26.05",
  });
  expect(missing).toBe("release not found: home/flake.nix (home-manager)");
  expect(mismatch).toBe(
    "release mismatch: mac/flake.nix (nix-darwin) 26.05 (root: 27.11)",
  );
});
