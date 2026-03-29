import { log } from "./log";
import { readFile } from "fs/promises";

const EXPECTED_VERSION = "25.11";

type FlakeCheck = {
  file: string;
  pattern: RegExp;
  label: string;
};

const FLAKE_CHECKS: FlakeCheck[] = [
  {
    file: "flake.nix",
    pattern: /nixpkgs\.url.*nixos-([\d.]+)/,
    label: "nixpkgs",
  },
  {
    file: "home/.config/home-manager/flake.nix",
    pattern: /nixpkgs\.url.*nixos-([\d.]+)/,
    label: "nixpkgs",
  },
  {
    file: "home/.config/home-manager/flake.nix",
    pattern: /home-manager\.url.*release-([\d.]+)/,
    label: "home-manager",
  },
  {
    file: "mac/nix-darwin/flake.nix",
    pattern: /nixpkgs\.url.*nixos-([\d.]+)/,
    label: "nixpkgs",
  },
  {
    file: "mac/nix-darwin/flake.nix",
    pattern: /nix-darwin\.url.*nix-darwin-([\d.]+)/,
    label: "nix-darwin",
  },
];

type Mismatch = {
  file: string;
  label: string;
  version: string;
};

const checkFlake = async (check: FlakeCheck): Promise<Mismatch | null> => {
  try {
    const content = await readFile(check.file, "utf-8");
    const match = check.pattern.exec(content);
    if (!match?.[1]) {
      return { file: check.file, label: check.label, version: "not found" };
    }
    if (match[1] !== EXPECTED_VERSION) {
      return { file: check.file, label: check.label, version: match[1] };
    }
    return null;
  } catch (e: unknown) {
    return {
      file: check.file,
      label: check.label,
      version: `read error: ${String(e)}`,
    };
  }
};

const main = async () => {
  const results = await Promise.all(FLAKE_CHECKS.map(checkFlake));
  const mismatches = results.filter((r): r is Mismatch => r !== null);

  if (mismatches.length === 0) {
    log.ok(`All Nix channels pinned to ${EXPECTED_VERSION}`);
    return;
  }

  mismatches.forEach((m) => {
    log.error(
      `${m.file} (${m.label}): ${m.version} (expected ${EXPECTED_VERSION})`,
    );
  });
  process.exit(1);
};

void main();
