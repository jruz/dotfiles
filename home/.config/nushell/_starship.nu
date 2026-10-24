$env.STARSHIP_SHELL = "nu"

if (which starship | is-not-empty) {
  load-env {
    PROMPT_COMMAND: {|| ^starship prompt --cmd-duration $env.CMD_DURATION_MS $"--status=($env.LAST_EXIT_CODE)" --terminal-width (term size).columns }
    PROMPT_COMMAND_RIGHT: {|| ^starship prompt --right --cmd-duration $env.CMD_DURATION_MS $"--status=($env.LAST_EXIT_CODE)" --terminal-width (term size).columns }
    PROMPT_INDICATOR: ""
    PROMPT_MULTILINE_INDICATOR: {|| ^starship prompt --continuation }
  }
}
