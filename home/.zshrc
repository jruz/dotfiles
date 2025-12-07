# ZSH
DISABLE_UPDATE_PROMPT=true

# ZGEN
source ~/.zgen/zgen.zsh

if ! zgen saved; then
  zgen oh-my-zsh
  zgen oh-my-zsh themes/robbyrussell
  zgen oh-my-zsh plugins/fzf
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-completions
  zgen save
fi

setopt HIST_IGNORE_DUPS

#bindkey -v
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward
bindkey "^O" accept-line-and-down-history

# NIX
# linux
if [ -e /home/jruz/.nix-profile/etc/profile.d/nix.sh ]; then
  source /home/jruz/.nix-profile/etc/profile.d/nix.sh;
fi
# macos
if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh';
fi

# VARS
export EDITOR='nvim'
export GIT_EDITOR='nvim'
export DOTFILES='/home/jruz/dev/dotfiles'
export GPG_TTY=$(tty)

# RG
export RIPGREP_CONFIG_PATH=~/.config/rg/config

# FZF
export FZF_COMPLETION_TRIGGER='``'
export FZF_DEFAULT_COMMAND='rg --files --glob=!{.git,node_modules,.obsidian}'

# Personal bins
export PATH="$PATH:$HOME/.local/bin"

# Disable Ctrl-Q Ctrl-S
stty -ixon

# AWS
#source /usr/bin/aws_zsh_completer.sh
#export AWS_REGION="eu-central-1"

eval "$(starship init zsh)"
eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"

# YARN
# export PATH="$(yarn global bin):$PATH"

# EMACS DOOM
export PATH="$PATH:$HOME/.config/emacs/bin"

# JUST
source <(just --completions zsh)

# SCRIPTS & ALIAS (explicit order)
source ~/.config/zsh/ssh-agent.sh
source ~/.config/zsh/mise.sh
source ~/.config/zsh/mise_completion.sh
source ~/.config/zsh/alias.sh
source ~/.config/zsh/functions.sh
source ~/.config/zsh/js.sh
source ~/.config/zsh/path.sh

# WATCH FILES LIMIT
ulimit -n 4096
