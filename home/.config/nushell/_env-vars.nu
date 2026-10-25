load-env {
    EDITOR: 'nvim'
    GIT_EDITOR: 'nvim'
    DOTFILES: $"($env.HOME)/dev/dotfiles"
    COLORTERM: "truecolor"
    GPG_TTY: (try { ^tty } catch { "/dev/tty" })
    RIPGREP_CONFIG_PATH: $"($env.HOME)/.config/rg/config"
    SOPS_AGE_KEY_FILE: $"($env.HOME)/.config/sops/age/keys.txt"
    DIRENV_LOG_FORMAT: ""
}
