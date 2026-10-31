export type InputName = "nixpkgs" | "home-manager" | "nix-darwin";

export type FlakeFile = Readonly<{
  file: string;
  inputs: readonly InputName[];
}>;

export type FlakeInput = Readonly<{
  file: string;
  name: InputName;
  source: string;
}>;

export type ReleaseErrorCode = "release-not-found" | "release-mismatch";

export type ReleaseFailure =
  | Readonly<{
      code: "release-not-found";
      file: string;
      input: InputName;
    }>
  | Readonly<{
      code: "release-mismatch";
      file: string;
      input: InputName;
      expected: string;
      actual: string;
    }>;

export type Result<T, E> =
  | Readonly<{ success: true; data: T }>
  | Readonly<{ success: false; error: E }>;
