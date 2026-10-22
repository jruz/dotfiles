import type { KnipConfig } from "knip";

const config: KnipConfig = {
  entry: ["scripts/*.ts!", "scripts/**/*.test.ts"],
  project: ["scripts/**/*.ts!", "!scripts/**/*.test.ts!", "*.ts"],
  ignoreDependencies: ["prettier"],
};

export default config;
