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
export RIPGREP_CONFIG_PATH=~/config/rg/config

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

# PROMPT THEME
PROMPT="%(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}➜)"
PROMPT+='%{$fg[cyan]%}(%c)%{$reset_color%}$(git_prompt_info) λ '
# git
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})%{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

# YARN
# export PATH="$(yarn global bin):$PATH"

# EMACS DOOM
export PATH="$PATH:$HOME/.config/emacs/bin"

# JUST
source <(just --completions=bash)

# RTX
RTX_USE_TOML=1

# SCRIPTS & ALIAS
for file in ~/.config/zsh/*
do
    source $file
done

# WATCH FILES LIMIT
ulimit -n 4096
