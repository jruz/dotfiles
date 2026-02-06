$env.EDITOR = 'nvim'
$env.GIT_EDITOR = 'nvim'
$env.DOTFILES = $"($env.HOME)/dev/dotfiles"
$env.GPG_TTY = (try { tty } catch { "/dev/tty" })
$env.RIPGREP_CONFIG_PATH = $"($env.HOME)/.config/rg/config"
$env.DIRENV_LOG_FORMAT = ""
