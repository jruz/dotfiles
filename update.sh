#!/bin/zsh

GREEN='\033[1;32m'
NC='\033[0m'

function titler {
  echo "${GREEN}-------------------- Updating ${1}${NC}"
}

source ~/.zshrc

titler "Antigen"
antigen selfupdate

titler "Antigen plugins"
antigen update

titler "Vim plugins"
vim +PluginUpdate +qa

titler "RVM"
rvm get stable

titler "NVM"
cd $NVM_DIR
git fetch -p
git checkout $(git describe --tags `git rev-list --tags --max-count=1`)
source $NVM_DIR/nvm.sh
cd $OLDPWD

titler "Gems"
bundle install --gemfile=~/dev/dotfiles/Gemfile

rvm install ruby --latest
nvm install node latest
