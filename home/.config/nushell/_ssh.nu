if $nu.os-info.name == "macos" {
  ssh-add --apple-use-keychain ~/.ssh/jruz
} else {
  if ($env.SSH_AUTH_SOCK? | is-empty) {
    let agent_output = ssh-agent -s | lines | first | parse "SSH_AUTH_SOCK={sock}; export SSH_AUTH_SOCK;"
    $env.SSH_AUTH_SOCK = $agent_output.0.sock
  }
  ssh-add ~/.ssh/jruz
}
