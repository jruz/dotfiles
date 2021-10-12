# ZGEN
source ~/.zgen/zgen.zsh

if ! zgen saved; then
  zgen oh-my-zsh
  zgen oh-my-zsh themes/robbyrussell
  zgen load zsh-users/zsh-syntax-highlighting
  zgen load zsh-users/zsh-completions
  zgen save
fi

setopt HIST_IGNORE_DUPS

#bindkey -v
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward
bindkey "^O" accept-line-and-down-history

# VARS
export EDITOR='vim'
export GIT_EDITOR='vim'
export DOTFILES='/home/jruz/dev/dotfiles'
export GPG_TTY=$(tty)
export FZF_DEFAULT_COMMAND='rg --files --hidden'

# ALIAS
for file in ~/dev/dotfiles/.zsh/*
do
    source $file
done

# Personal bins
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/dev/dotfiles/bin"

# Disable Ctrl-Q Ctrl-S
stty -ixon

# AWS
#source /usr/bin/aws_zsh_completer.sh
#export AWS_REGION="eu-central-1"

# DOOM
export PATH="$HOME/.emacs.d/bin:$PATH"

# PROMPT THEME
PROMPT="%(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}➜)"
PROMPT+='%{$fg[cyan]%}(%c)%{$reset_color%}$(git_prompt_info) λ '
# git
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})%{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

# ASDF
. $HOME/.asdf/asdf.sh
fpath=(${ASDF_DIR}/completions $fpath)
autoload -Uz compinit && compinit

# YARN
export PATH="$(yarn global bin):$PATH"

# RUST
#export PATH="$HOME/.asdf/installs/rust/1.37.0/bin:$PATH"
#export PATH="$HOME/.cargo/bin:$PATH"

