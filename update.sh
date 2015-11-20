#!/bin/zsh

GREEN='\033[1;32m'
NC='\033[0m'

function titler {
  echo "${GREEN}-------------------- ${1}${NC}"
}

source ~/.zshrc

titler "Updating Antigen"
antigen selfupdate

titler "Updating antigen plugins"
antigen update

titler "Updating vim plugins"
vim +PluginUpdate +qa
