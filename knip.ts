import type { KnipConfig } from "knip";

const config: KnipConfig = {
  entry: ["scripts/*.ts!", "scripts/**/*.test.ts"],
  project: ["scripts/**/*.ts!", "!scripts/**/*.test.ts!", "*.ts"],
};

export default config;
