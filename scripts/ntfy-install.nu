let agents = ($env.HOME | path join Library LaunchAgents)
let logs = ($env.HOME | path join Library Logs)
mkdir $agents $logs
let plist = ($agents | path join io.jruz.ntfy-subscribe.plist)
let log_path = ($logs | path join ntfy-subscribe.log)
{
    Label: 'io.jruz.ntfy-subscribe'
    ProgramArguments: [
        $nu.current-exe
        ($env.FILE_PWD | path join ntfy-subscribe.nu)
    ]
    EnvironmentVariables: {PATH: ($env.PATH | str join ':')}
    RunAtLoad: true
    KeepAlive: true
    ThrottleInterval: 30
    StandardOutPath: $log_path
    StandardErrorPath: $log_path
} | to json | ^plutil -convert xml1 -o $plist -- -
^launchctl bootstrap $"gui/(^id -u | str trim)" $plist
