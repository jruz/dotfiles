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
export EDITOR='emacs'
export GIT_EDITOR='emacs'
export DOTFILES='/home/jruz/dev/dotfiles'
export GPG_TTY=$(tty)

# aliases
for file in ~/dev/dotfiles/.zsh/*
do
    source $file
done

# Personal bins
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/dev/dotfiles/bin"

# Disable Ctrl-Q Ctrl-S
stty -ixon

# ASDF
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash
export PATH="$HOME/.asdf/installs/rust/1.37.0/bin:$PATH"

# Yarn global bins
export PATH="$(yarn global bin):$PATH"

# AWS
source /usr/bin/aws_zsh_completer.sh
export AWS_REGION="eu-central-1"

# Fractal
export FRCTLS_WORK_DIR="/home/jruz/dev/freelance/fractal"
source $FRCTLS_WORK_DIR/cli/shell/frctls-completion.sh

# Doom
export PATH="$HOME/.emacs.d/bin:$PATH"
