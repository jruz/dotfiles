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
export FZF_DEFAULT_COMMAND='rg --files --hidden'

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

# ASDF
ASDF_PATH_FILE=~/.asdf_path

function load_asdf() {
  source $(cat ~/.asdf_path)
  fpath=(${ASDF_DIR}/completions $fpath)
  autoload -Uz compinit && compinit
}

function update_asdf_path() {
  fd --full-path 'asdf-vm/asdf\.sh$' /nix/store | head -n 1 > $ASDF_PATH_FILE
}

if [[ -f "$ASDF_PATH_FILE" ]]; then
  load_asdf
  (&>/dev/null update_asdf_path &)
else
  echo "ASDF_PATH_FILE not found, creating..."
  update_asdf_path
  load_asdf
fi

# YARN
export PATH="$(yarn global bin):$PATH"

# EMACS DOOM
export PATH="$PATH:$HOME/.config/emacs/bin"

# JUST
source <(just --completions=bash)

# SCRIPTS & ALIAS
for file in ~/.config/zsh/*
do
    source $file
done
