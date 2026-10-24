use _gemini.nu
use _fzf.nu

let gemini_keybinding = {
    name: gemini_prompt
    modifier: control
    keycode: char_g
    mode: [emacs vi_normal vi_insert]
    event: {
        send: executehostcommand
        cmd: "commandline edit --replace (commandline | _gemini)"
    }
}

let fzf_path_keybinding = {
    name: fzf_path
    modifier: control
    keycode: char_p
    mode: [emacs vi_normal vi_insert]
    event: {
        send: executehostcommand
        cmd: "commandline edit --insert (_fzf path)"
    }
}

let keybindings = (
    $env.config?
    | default {}
    | get keybindings?
    | default []
    | append $gemini_keybinding
)

$env.config = ($env.config? | default {} | upsert keybindings {
    if (which fzf | length) > 0 {
        $keybindings | append $fzf_path_keybinding
    } else {
        $keybindings
    }
})
