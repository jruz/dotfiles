# load zgen
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

# vars
export EDITOR='vim'
export GIT_EDITOR='vim'
export DOTFILES='/home/jruz/dev/dotfiles'

# aliases
for file in ~/dev/dotfiles/.zsh/*
do
    source $file
done

# Personal bins
export PATH="$PATH:$HOME/dev/dotfiles/bin"

# Disable Ctrl-Q Ctrl-S
stty -ixon

# ASDF
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash
