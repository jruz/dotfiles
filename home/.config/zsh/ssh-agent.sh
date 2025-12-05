if [[ "$(uname)" != "Darwin" ]]; then
  if [ -z "$SSH_AUTH_SOCK" ]; then
    export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
  fi

  if ! ssh-add -l &>/dev/null; then
    rm -f "$SSH_AUTH_SOCK"
    eval $(ssh-agent -a "$SSH_AUTH_SOCK") >/dev/null
  fi
fi
