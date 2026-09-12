$env.EDITOR = 'nvim'
$env.GIT_EDITOR = 'nvim'
$env.DOTFILES = $"($env.HOME)/dev/dotfiles"
$env.COLORTERM = "truecolor"
$env.GPG_TTY = (try { tty } catch { "/dev/tty" })
$env.RIPGREP_CONFIG_PATH = $"($env.HOME)/.config/rg/config"
$env.DIRENV_LOG_FORMAT = ""
if $nu.os-info.name == "macos" {
    $env.SSH_AUTH_SOCK = $"($env.HOME)/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
}
