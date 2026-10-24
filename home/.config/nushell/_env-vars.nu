load-env {
    EDITOR: 'nvim'
    GIT_EDITOR: 'nvim'
    DOTFILES: $"($env.HOME)/dev/dotfiles"
    COLORTERM: "truecolor"
    GPG_TTY: (try { ^tty } catch { "/dev/tty" })
    RIPGREP_CONFIG_PATH: $"($env.HOME)/.config/rg/config"
    DIRENV_LOG_FORMAT: ""
}
if $nu.os-info.name == "macos" {
    $env.SSH_AUTH_SOCK = $"($env.HOME)/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
}
