#!/bin/zsh

GREEN='\033[1;32m'
NC='\033[0m'

function titler {
  echo "${GREEN}-------------------- Updating ${1}${NC}"
}

source ~/.zshrc

titler "Zgen"
zgen selfupdate

titler "Zgen plugins"
zgen update

titler "Vim"
vim +PlugUpgrade +qa
vim +PlugUpdate +qa
vim +PlugClean! +qa

titler "RVM"
rvm get stable

titler "NVM"
cd "$NVM_DIR" && git fetch origin && git checkout "$(git describe --abbrev=0 --tags)"
source "$NVM_DIR/nvm.sh"
cd "$OLDPWD" || return

#titler "Gems"
#bundle install --gemfile=~/dev/dotfiles/Gemfile

#rvm install ruby --latest
#nvm install node latest

titler "Clear pacman and pacaur"
sudo pacaur -Sc --noconfirm
