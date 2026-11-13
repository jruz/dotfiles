source ../home/.config/nushell/_env-load.nu

let notifier = (which terminal-notifier | first | get path)
(^ntfy subscribe $env.NTFY_CHANNEL_DESKTOP
    $"'($notifier)' -title \"$NTFY_TITLE\" -message \"$NTFY_MESSAGE\" -sound default")
