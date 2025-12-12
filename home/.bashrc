# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix

PS1="nix-shell::\W λ "

alias q="exit"
alias ls='lsd'
alias la='lsd --almost-all --group-dirs=first --human-readable --long'
alias las='lsd --almost-all --group-dirs=first --human-readable --long --dereference'
alias awk='gawk'
alias cat='bat'
alias find='fd'
alias grep='rg'
