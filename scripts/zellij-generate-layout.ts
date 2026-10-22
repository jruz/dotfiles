#!/usr/bin/env bun

import { parseArgs } from "util";
import { write, file } from "bun";
import { z } from "zod/v4";
import { parse as parseYaml } from "yaml";
import { Document, Node, Entry, Value, Identifier, format } from "@bgotink/kdl";
import { log } from "./lib/log.ts";

const RIGHT = "\ue0b0";
const LEFT = "\ue0b2";

const StringSchema = z.string();
const StringArraySchema = z.array(StringSchema);

const ConfigSchema = z
  .object({
    layouts: z.record(StringSchema, StringArraySchema),
  })
  .readonly();

type Tab = {
  readonly path: string;
  readonly name: string;
};

const tabNameFromPath = (path: string): string => {
  const basename = path.split("/").at(-1) ?? path;
  return basename.replace(/^\./, "").toLowerCase();
};

const toTab = (path: string): Tab => ({
  path,
  name: tabNameFromPath(path),
});

const quotedValue = (v: string | number | boolean): Value => {
  const val = new Value(v);
  if (typeof v === "string") {
    val.representation = `"${v}"`;
  }
  return val;
};

const quotedArg = (value: string | number | boolean): Entry =>
  new Entry(quotedValue(value), null);

const quotedProp = (key: string, value: string | number | boolean): Entry =>
  new Entry(quotedValue(value), new Identifier(key));

const val = (name: string, value: string | number | boolean): Node => {
  const n = Node.create(name);
  const arg = quotedArg(value);
  n.entries.push(arg);
  return n;
};

const bare = (name: string): Node => Node.create(name);

const kdlNode = (
  name: string,
  props: Record<string, string | number | boolean>,
  children?: Node[],
): Node => {
  const n = Node.create(name);
  Object.entries(props).forEach(([key, value]) => {
    const prop = quotedProp(key, value);
    n.entries.push(prop);
  });
  if (children) {
    n.children = new Document(children);
  }
  return n;
};

const topBarPlugin = (): Node =>
  kdlNode(
    "plugin",
    {
      location:
        "https://github.com/dj95/zjstatus/releases/download/v0.23.0/zjstatus.wasm",
    },
    [
      val(
        "format_left",
        `#[bg=#b4befe,fg=#1e1e2e,bold] {session} #[bg=#1e1e2e,fg=#b4befe]${RIGHT}{tabs}`,
      ),
      val("format_center", ""),
      val("format_right", "{command_user}{command_host}"),
      val("format_space", ""),

      val("border_enabled", "false"),

      val("command_host_command", "hostname -s"),
      val("command_host_format", `#[bg=#b4befe,fg=#1e1e2e,bold] {stdout} `),
      val("command_host_interval", "0"),

      val("command_user_command", "whoami"),
      val(
        "command_user_format",
        `#[fg=#45475a]${LEFT}#[bg=#45475a,fg=#cdd6f4] {stdout} #[fg=#b4befe,bg=#45475a]${LEFT}`,
      ),
      val("command_user_interval", "0"),

      val(
        "tab_normal",
        `#[bg=#45475a,fg=#1e1e2e]${RIGHT}#[bg=#45475a,fg=#cdd6f4] {index} {name} #[bg=#1e1e2e,fg=#45475a]${RIGHT}`,
      ),
      val(
        "tab_normal_fullscreen",
        `#[bg=#45475a,fg=#1e1e2e]${RIGHT}#[bg=#45475a,fg=#cdd6f4] {index} {name} [] #[bg=#1e1e2e,fg=#45475a]${RIGHT}`,
      ),
      val(
        "tab_active",
        `#[bg=#b4befe,fg=#1e1e2e]${RIGHT}#[bg=#b4befe,fg=#1e1e2e,bold] {index} {name} #[bg=#1e1e2e,fg=#b4befe]${RIGHT}`,
      ),
      val(
        "tab_active_fullscreen",
        `#[bg=#b4befe,fg=#1e1e2e]${RIGHT}#[bg=#b4befe,fg=#1e1e2e,bold] {index} {name} [] #[bg=#1e1e2e,fg=#b4befe]${RIGHT}`,
      ),
      val("tab_separator", ""),

      val("_allow_exec_host_cmd", true),
    ],
  );

const bottomBarPlugin = (): Node =>
  kdlNode(
    "plugin",
    {
      location:
        "https://github.com/dj95/zjstatus/releases/download/v0.23.0/zjstatus.wasm",
    },
    [
      val("format_left", "{mode}"),
      val("format_center", "{tabs}"),
      val("format_right", "{command_sys}{datetime}"),
      val("format_space", ""),

      val("border_enabled", "false"),

      val(
        "mode_normal",
        `#[bg=#b4befe,fg=#1e1e2e,bold] NORMAL #[bg=#1e1e2e,fg=#b4befe]${RIGHT}`,
      ),
      val(
        "mode_tmux",
        `#[bg=#fab387,fg=#1e1e2e,bold] TMUX #[bg=#1e1e2e,fg=#fab387]${RIGHT}`,
      ),
      val(
        "mode_locked",
        `#[bg=#f38ba8,fg=#1e1e2e,bold] LOCKED #[bg=#1e1e2e,fg=#f38ba8]${RIGHT}`,
      ),
      val(
        "mode_scroll",
        `#[bg=#89dceb,fg=#1e1e2e,bold] SCROLL #[bg=#1e1e2e,fg=#89dceb]${RIGHT}`,
      ),
      val(
        "mode_rename_tab",
        `#[bg=#fab387,fg=#1e1e2e,bold] RENAME #[bg=#1e1e2e,fg=#fab387]${RIGHT}`,
      ),

      val("tab_normal", ""),
      val("tab_active", `#[bg=#b4befe,fg=#1e1e2e,bold] {name} `),
      val("tab_separator", ""),

      val("command_sys_command", "zjstatus-sysinfo"),
      val(
        "command_sys_format",
        `#[fg=#45475a]${LEFT}#[bg=#45475a,fg=#cdd6f4] {stdout} `,
      ),
      val("command_sys_interval", "3"),

      val(
        "datetime",
        `#[fg=#b4befe,bg=#45475a]${LEFT}#[bg=#b4befe,fg=#1e1e2e,bold] {format} `,
      ),
      val("datetime_format", "%H:%M"),
      val("datetime_timezone", "Europe/Madrid"),
    ],
  );

const defaultTabTemplate = (): Node =>
  kdlNode("default_tab_template", {}, [
    kdlNode("pane", { size: 1, borderless: true }, [topBarPlugin()]),
    kdlNode("pane", { split_direction: "vertical" }, [
      kdlNode("pane", {}, [bare("children")]),
    ]),
    kdlNode("pane", { size: 1, borderless: true }, [bottomBarPlugin()]),
  ]);

const generateTab = (tab: Tab, idx: number): Node => {
  const props: Record<string, string | number | boolean> = {
    name: tab.name,
    cwd: tab.path,
  };
  if (idx === 0) {
    props["focus"] = true;
  }
  return kdlNode("tab", props, [
    kdlNode("pane", { split_direction: "vertical" }, [
      bare("pane"),
      bare("pane"),
    ]),
  ]);
};

const toKdlV1 = (kdlV2: string): string =>
  kdlV2.replaceAll("#true", "true").replaceAll("#false", "false");

const generateLayout = (tabs: readonly Tab[]): string => {
  const tabNodes = tabs.map((tab, idx) => generateTab(tab, idx));
  const layout = kdlNode("layout", {}, [defaultTabTemplate(), ...tabNodes]);
  const formatted = format(new Document([layout]));
  return toKdlV1(formatted);
};

const { values } = parseArgs({
  args: Bun.argv.slice(2),
  options: {
    name: { type: "string" },
  },
  strict: true,
});

if (!values.name) {
  log.error("Missing --name argument");
  process.exit(1);
}

const configPath = new URL("zellij-generate-layout.yaml", import.meta.url)
  .pathname;
const raw = await file(configPath).text();
const parsed: unknown = parseYaml(raw);
const config = ConfigSchema.parse(parsed);

const paths = config.layouts[values.name];
if (!paths) {
  log.error(`Layout "${values.name}" not found in config`);
  process.exit(1);
}

const tabs = paths.map(toTab);
const output = `home/.config/zellij/layouts/${values.name}.kdl`;

const content = generateLayout(tabs);
await write(output, content);
log.info(`Layout saved to ${output}`);
