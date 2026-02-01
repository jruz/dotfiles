use _gemini.nu

$env.config = ($env.config | upsert keybindings {
    $env.config.keybindings? | default [] | append {
        name: gemini_prompt
        modifier: control
        keycode: char_g
        mode: [emacs, vi_normal, vi_insert]
        event: {
            send: executehostcommand
            cmd: "commandline edit --replace (commandline | _gemini)"
        }
    }
})
