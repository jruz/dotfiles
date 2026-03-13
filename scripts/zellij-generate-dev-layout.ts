#!/usr/bin/env bun

import { parseArgs } from "util";
import { write } from "bun";
import { log } from "./log.ts";

const LAYOUT_HEADER = `layout {
    default_tab_template {
        pane size=1 borderless=true {
            plugin location="file:~/.config/zellij/plugins/zjstatus.wasm" {
                format_left   "#[bg=#b4befe,fg=#1e1e2e,bold] {session} #[bg=#1e1e2e,fg=#b4befe]{{RIGHT}}{tabs}"
                format_center ""
                format_right  "{command_user}{command_host}"
                format_space  ""

                border_enabled  "false"

                command_host_command   "hostname -s"
                command_host_format    "#[bg=#b4befe,fg=#1e1e2e,bold] {stdout} "
                command_host_interval  "0"

                command_user_command   "whoami"
                command_user_format    "#[fg=#45475a]{{LEFT}}#[bg=#45475a,fg=#cdd6f4] {stdout} #[fg=#b4befe,bg=#45475a]{{LEFT}}"
                command_user_interval  "0"

                tab_normal              "#[bg=#45475a,fg=#1e1e2e]{{RIGHT}}#[bg=#45475a,fg=#cdd6f4] {index} {name} #[bg=#1e1e2e,fg=#45475a]{{RIGHT}}"
                tab_normal_fullscreen   "#[bg=#45475a,fg=#1e1e2e]{{RIGHT}}#[bg=#45475a,fg=#cdd6f4] {index} {name} [] #[bg=#1e1e2e,fg=#45475a]{{RIGHT}}"
                tab_active              "#[bg=#b4befe,fg=#1e1e2e]{{RIGHT}}#[bg=#b4befe,fg=#1e1e2e,bold] {index} {name} #[bg=#1e1e2e,fg=#b4befe]{{RIGHT}}"
                tab_active_fullscreen   "#[bg=#b4befe,fg=#1e1e2e]{{RIGHT}}#[bg=#b4befe,fg=#1e1e2e,bold] {index} {name} [] #[bg=#1e1e2e,fg=#b4befe]{{RIGHT}}"
                tab_separator           ""

                _allow_exec_host_cmd true
            }
        }
        pane split_direction="vertical" {
            pane {
                children
            }
        }
        pane size=1 borderless=true {
            plugin location="file:~/.config/zellij/plugins/zjstatus.wasm" {
                format_left   "{mode}"
                format_center "{tabs}"
                format_right  "{datetime}"
                format_space  ""

                border_enabled  "false"

                mode_normal       "#[bg=#b4befe,fg=#1e1e2e,bold] NORMAL #[bg=#1e1e2e,fg=#b4befe]{{RIGHT}}"
                mode_tmux         "#[bg=#fab387,fg=#1e1e2e,bold] TMUX #[bg=#1e1e2e,fg=#fab387]{{RIGHT}}"
                mode_locked       "#[bg=#f38ba8,fg=#1e1e2e,bold] LOCKED #[bg=#1e1e2e,fg=#f38ba8]{{RIGHT}}"
                mode_scroll       "#[bg=#89dceb,fg=#1e1e2e,bold] SCROLL #[bg=#1e1e2e,fg=#89dceb]{{RIGHT}}"
                mode_rename_tab   "#[bg=#fab387,fg=#1e1e2e,bold] RENAME #[bg=#1e1e2e,fg=#fab387]{{RIGHT}}"

                tab_normal              ""
                tab_active              "#[bg=#b4befe,fg=#1e1e2e,bold] {name} "
                tab_separator           ""

                datetime          "#[fg=#45475a]{{LEFT}}#[bg=#45475a,fg=#cdd6f4] Spain #[fg=#b4befe,bg=#45475a]{{LEFT}}#[bg=#b4befe,fg=#1e1e2e,bold] {format} "
                datetime_format   "%H:%M"
                datetime_timezone "Europe/Madrid"
            }
        }
    }

`;

const LAYOUT_FOOTER = "}";

type Tab = Readonly<{
  path: string;
  name: string;
}>;

const parseTab = (raw: string): Tab => {
  try {
    return JSON.parse(raw) as Tab;
  } catch (e) {
    log.error(`invalid tab JSON: ${raw}`);
    throw e;
  }
};

const generateTab = (tab: Tab, idx: number): string => {
  const focus = idx === 0 ? " focus=true" : "";
  return `    tab name="${tab.name}" cwd="${tab.path}"${focus} {
        pane split_direction="vertical" {
            pane
            pane
        }
    }
`;
};

const replacePowerline = (content: string): string =>
  content.replaceAll("{{RIGHT}}", "\ue0b0").replaceAll("{{LEFT}}", "\ue0b2");

const generateLayout = (tabs: ReadonlyArray<Tab>): string => {
  const tabsKdl = tabs.map((tab, idx) => generateTab(tab, idx)).join("");
  return replacePowerline(`${LAYOUT_HEADER}${tabsKdl}${LAYOUT_FOOTER}`);
};

const { values, positionals } = parseArgs({
  args: Bun.argv.slice(2),
  options: {
    output: { type: "string", short: "o" },
  },
  allowPositionals: true,
  strict: true,
});

if (positionals.length === 0) {
  log.error('No tabs provided. Usage: zellij-generate-dev-layout.ts --output <path> \'{"path":"/dir","name":"label"}\' ...');
  process.exit(1);
}

const tabs = positionals.map(parseTab);

if (!values.output) {
  log.error("Missing --output flag");
  process.exit(1);
}

await write(values.output, generateLayout(tabs));
log.info(`Layout saved to ${output}`);
