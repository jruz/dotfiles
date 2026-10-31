import type {
  FlakeInput,
  InputName,
  ReleaseErrorCode,
  ReleaseFailure,
  Result,
} from "./types.ts";

const releasePatterns: Readonly<Record<InputName, RegExp>> = {
  nixpkgs: /nixpkgs\.url\s*=\s*"[^"\n]*nixos-(\d+\.\d+)"/,
  "home-manager": /home-manager\.url\s*=\s*"[^"\n]*release-(\d+\.\d+)"/,
  "nix-darwin": /nix-darwin\.url\s*=\s*"[^"\n]*nix-darwin-(\d+\.\d+)"/,
};

const failureMessages: Readonly<Record<ReleaseErrorCode, string>> = {
  "release-not-found": "release not found",
  "release-mismatch": "release mismatch",
};

const parseRelease = (input: FlakeInput): Result<string, ReleaseFailure> => {
  const pattern = releasePatterns[input.name];
  const match = pattern.exec(input.source);
  const release = match?.[1];
  if (release === undefined) {
    return {
      success: false,
      error: { code: "release-not-found", file: input.file, input: input.name },
    };
  }
  return { success: true, data: release };
};

const checkInput = (
  input: FlakeInput,
  expected: string,
): readonly ReleaseFailure[] => {
  const parsed = parseRelease(input);
  if (!parsed.success) return [parsed.error];
  if (parsed.data === expected) return [];
  return [
    {
      code: "release-mismatch",
      file: input.file,
      input: input.name,
      expected,
      actual: parsed.data,
    },
  ];
};

export const checkReleaseSync = (
  root: FlakeInput,
  inputs: readonly FlakeInput[],
): Result<string, readonly ReleaseFailure[]> => {
  const reference = parseRelease(root);
  if (!reference.success) return { success: false, error: [reference.error] };
  const failures = inputs.flatMap((input) => checkInput(input, reference.data));
  if (failures.length > 0) return { success: false, error: failures };
  return { success: true, data: reference.data };
};

export const formatReleaseFailure = (failure: ReleaseFailure): string => {
  const message = failureMessages[failure.code];
  const location = `${failure.file} (${failure.input})`;
  if (failure.code === "release-not-found") return `${message}: ${location}`;
  return `${message}: ${location} ${failure.actual} (root: ${failure.expected})`;
};
