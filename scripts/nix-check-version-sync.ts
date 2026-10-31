import { log } from "./lib/log.ts";
import {
  checkReleaseSync,
  formatReleaseFailure,
} from "./nix-check-version-sync/releases.ts";
import type { FlakeFile, FlakeInput } from "./nix-check-version-sync/types.ts";

const files: readonly FlakeFile[] = [
  {
    file: "home/.config/home-manager/flake.nix",
    inputs: ["nixpkgs", "home-manager"],
  },
  {
    file: "mac/nix-darwin/flake.nix",
    inputs: ["nixpkgs", "nix-darwin"],
  },
];

const readSource = async (path: string): Promise<string> => {
  try {
    return await Bun.file(path).text();
  } catch (error) {
    log.error(`cannot read flake: ${path}`);
    throw error;
  }
};

const readInputs = async (file: FlakeFile): Promise<readonly FlakeInput[]> => {
  const source = await readSource(file.file);
  return file.inputs.map((name) => ({ file: file.file, name, source }));
};

const main = async (): Promise<void> => {
  const source = await readSource("flake.nix");
  const root: FlakeInput = { file: "flake.nix", name: "nixpkgs", source };
  const pending = files.map(readInputs);
  const groups = await Promise.all(pending);
  const inputs = groups.flat();
  const result = checkReleaseSync(root, inputs);
  if (!result.success) {
    const messages = result.error.map(formatReleaseFailure);
    messages.forEach(log.error);
    process.exitCode = 1;
    return;
  }
  log.ok(`Nix inputs match root nixpkgs release ${result.data}`);
};

await main();
