$env.STARSHIP_SHELL = "nu"
$env.PROMPT_COMMAND = {|| starship prompt --cmd-duration $env.CMD_DURATION_MS $"--status=($env.LAST_EXIT_CODE)" --terminal-width (term size).columns }
$env.PROMPT_COMMAND_RIGHT = {|| starship prompt --right --cmd-duration $env.CMD_DURATION_MS $"--status=($env.LAST_EXIT_CODE)" --terminal-width (term size).columns }
$env.PROMPT_INDICATOR = ""
$env.PROMPT_MULTILINE_INDICATOR = {|| starship prompt --continuation }