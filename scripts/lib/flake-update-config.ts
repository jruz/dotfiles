import { z } from "zod";
import configurations from "../flake-updates.json";

const CommonSchema = z.object({
  name: z.string().min(1),
  path: z.string().min(1),
});

const NpmSchema = CommonSchema.extend({
  kind: z.literal("npm"),
  packageName: z.string().min(1),
  distTag: z.string().min(1),
  repository: z.string().regex(/^[\w.-]+\/[\w.-]+$/),
  tagPrefix: z.string(),
}).readonly();

const ConfigurationKeySchema = z.string();
const ConfigurationsSchema = z
  .record(ConfigurationKeySchema, NpmSchema)
  .readonly();

export type NpmConfig = z.infer<typeof NpmSchema>;

export const readConfiguration = (name: unknown) => {
  const key = z.string().min(1).parse(name);
  const configs = ConfigurationsSchema.parse(configurations);
  return NpmSchema.parse(configs[key]);
};
