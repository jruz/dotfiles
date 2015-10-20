# antigen
source ~/dev/dotfiles/antigen/antigen.zsh

# load oh-my-zsh
antigen use oh-my-zsh

# Install bundles
antigen bundle vi-mode
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions

# Themes
antigen theme robbyrussell

# Antigen do
antigen apply

bindkey -v

# vars
export EDITOR='vim'
export TERM='xterm-256color'

# aliases
for file in ~/dev/dotfiles/.zsh/*
do
    source $file
done

# Personal bins
export PATH="$PATH:$HOME/dev/dotfiles/bin"

# NVM
export NVM_DIR="/home/jruz/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# RVM
export PATH="$GEM_HOME/bin:$HOME/.rvm/bin:$PATH"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
