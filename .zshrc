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

# NVM
export NVM_DIR="/home/jruz/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Heroku
export PATH="/usr/local/heroku/bin:$PATH"
export PATH="./node_modules/.bin:$PATH"

# RVM
export PATH="$GEM_HOME/bin:$HOME/.rvm/bin:$PATH"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Disable Ctrl-Q Ctrl-S
stty -ixon

# AVN
#[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" # load avn

# TRAVIS
[ -f /home/jruz/.travis/travis.sh ] && source /home/jruz/.travis/travis.sh
